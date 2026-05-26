# 确保在脚本目录下运行
Set-Location -Path $PSScriptRoot

# 让 LaTeX 在项目目录优先寻找本地配置
$env:TEXINPUTS = "$PSScriptRoot;" + $env:TEXINPUTS
$bstPath = Join-Path $PSScriptRoot "templates"
if (-not $env:BSTINPUTS) { $env:BSTINPUTS = "" }
$env:BSTINPUTS = "$bstPath;" + $env:BSTINPUTS

$outputFile = "output/thesis.pdf"

# 如果没有 output 文件夹就建一个
if (!(Test-Path "output")) { New-Item -ItemType Directory -Path "output" }

# 注意：每一行末尾的反引号 ` 后面千万不能有空格
$texFile = "output/thesis.tex"

$ProgressPreference = "SilentlyContinue"

pandoc main.md `
    src/01_intro.md `
    src/02_methods.md `
    src/03_results.md `
    src/04_application.md `
    src/05_prospect.md `
    -o $texFile `
    --standalone `
    --top-level-division=chapter `
    --natbib `
    --resource-path=.:figures `
    --number-sections `
    --toc *> $null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Pandoc conversion failed. Check errors." -ForegroundColor Red
    exit $LASTEXITCODE
}

# 去掉 microtype 以规避 MiKTeX 的配置报错
# 同时插入 bibliography style 和按 .bib 文件顺序生成的 \nocite{...}
$bibfile = Join-Path $PSScriptRoot 'references\thesis_ref.bib'
$bibkeys = @()
if (Test-Path $bibfile) {
    $bibkeys = Get-Content $bibfile | ForEach-Object {
        if ($_ -match '^\s*@\w+\{([^,]+),') { $matches[1] }
    } | Where-Object { $_ -ne $null }
}
$nocite = '\nocite{' + ($bibkeys -join ',') + '}'

$lines = Get-Content $texFile
$filtered = @()
$skip = $false
$insertedNocite = $false
foreach ($line in $lines) {
    if ($line -like '*microtype.sty*') {
        $skip = $true
        continue
    }
    if ($skip) {
        if ($line -match '^\}\{\}\s*$') {
            $skip = $false
        }
        continue
    }
    # replace bibliography style to unsrtnat to use citation order
    if ($line -match '^\s*\\bibliographystyle\{') {
        $filtered += '\bibliographystyle{unsrtnat}'
        continue
    }
    # insert nocite right after \begin{document} so nocite dictates order
    if (-not $insertedNocite -and ($line -match '^\s*\\begin\{document\}')) {
        $filtered += $line
        if ($bibkeys.Count -gt 0) { $filtered += $nocite }
        $insertedNocite = $true
        continue
    }
    # 在 \bibliography{...} 前插入样式和 nocite（按 .bib 文件顺序）
    if ($line -match '^\s*\\bibliography\{') {
        # ensure bibliography line preserved
    }
    $filtered += $line
}
Set-Content $texFile $filtered

xelatex -halt-on-error -interaction=nonstopmode -output-directory=output $texFile *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "XeLaTeX compilation failed. Check errors." -ForegroundColor Red
    exit $LASTEXITCODE
}

$auxFile = "output/thesis.aux"
$hasCitations = $false
if (Test-Path $auxFile) {
    $hasCitations = Select-String -Path $auxFile -Pattern '^\\citation\{' -Quiet
}

if ($hasCitations) {
    # Clean duplicate \bibstyle lines in .aux (some templates write it multiple times)
    if (Test-Path $auxFile) {
        $auxLines = Get-Content $auxFile
        $firstBibstyleFound = $false
        $newAux = @()
        foreach ($l in $auxLines) {
            if ($l -match '^\\bibstyle\{') {
                if (-not $firstBibstyleFound) {
                    # force first bibstyle to unsrtnat so bibtex uses it
                    $newAux += '\bibstyle{unsrtnat}'
                    $firstBibstyleFound = $true
                } else {
                    # skip duplicate
                    continue
                }
            } else {
                $newAux += $l
            }
        }
        # Keep original lines except ensure the first \bibstyle is exactly '\bibstyle{unsrtnat}'
        $finalAux = @()
        $firstBibstyleFound = $false
        foreach ($ln in $auxLines) {
            if ($ln -match 'bibstyle\{') {
                if (-not $firstBibstyleFound) {
                    $finalAux += '\bibstyle{unsrtnat}'
                    $firstBibstyleFound = $true
                } else {
                    continue
                }
            } else {
                $finalAux += $ln
            }
        }
        Set-Content -Path $auxFile -Value $finalAux
    }
    bibtex output/thesis *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "BibTeX compilation failed. Check errors." -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

xelatex -halt-on-error -interaction=nonstopmode -output-directory=output $texFile *> $null
xelatex -halt-on-error -interaction=nonstopmode -output-directory=output $texFile *> $null

if ($LASTEXITCODE -eq 0) {
    $sourcePdf = Resolve-Path -Path "output/thesis.pdf"
    $targetPdf = Resolve-Path -Path $outputFile -ErrorAction SilentlyContinue
    if (-not $targetPdf -or $sourcePdf.Path -ne $targetPdf.Path) {
        Copy-Item -Path $sourcePdf.Path -Destination $outputFile -Force
    }
    Remove-Item -ErrorAction SilentlyContinue output\thesis.aux, output\thesis.bbl, output\thesis.blg, output\thesis.log, output\thesis.toc, output\thesis.out, output\thesis.lof, output\thesis.lot, output\thesis.fls, output\thesis.fdb_latexmk, output\thesis.tex
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "Compilation succeeded!" -ForegroundColor Green
} else {
    Write-Host "Compilation failed. Check the logs in output/." -ForegroundColor Red
}