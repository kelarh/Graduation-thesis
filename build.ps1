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
    Write-Host "❌ Pandoc 转换失败，请检查报错信息。" -ForegroundColor Red
    exit $LASTEXITCODE
}

# 去掉 microtype 以规避 MiKTeX 的配置报错
$lines = Get-Content $texFile
$filtered = @()
$skip = $false
foreach ($line in $lines) {
    if ($line -match '\\bibliographystyle\{') {
        continue
    }
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
    $filtered += $line
}
Set-Content $texFile $filtered

xelatex -halt-on-error -interaction=nonstopmode -output-directory=output $texFile *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ XeLaTeX 编译失败，请检查报错信息。" -ForegroundColor Red
    exit $LASTEXITCODE
}

$auxFile = "output/thesis.aux"
$hasCitations = $false
if (Test-Path $auxFile) {
    $hasCitations = Select-String -Path $auxFile -Pattern '^\\citation\{' -Quiet
}

if ($hasCitations) {
    bibtex output/thesis *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ BibTeX 编译失败，请检查报错信息。" -ForegroundColor Red
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
    Write-Host "✅ 编译成功！" -ForegroundColor Green
} else {
    Write-Host "❌ 编译失败，请检查报错信息。" -ForegroundColor Red
}