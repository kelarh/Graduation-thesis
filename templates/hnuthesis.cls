\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hnuthesis}[2026/05/11 HNU bachelor thesis class rebuilt]

\LoadClass[UTF8,a4paper,openany,zihao=-4]{ctexbook}

\RequirePackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial}
\setmonofont{Courier New}
\setCJKmainfont{SimSun}[AutoFakeBold=true]
\setCJKsansfont{SimHei}

\RequirePackage{geometry}
\geometry{
  paper=a4paper,
  top=30mm,
  bottom=25mm,
  left=25mm,
  right=25mm,
  headheight=5mm,
  headsep=15mm,
  footskip=15mm
}

\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{caption}
\RequirePackage{etoolbox}
\RequirePackage{indentfirst}
\RequirePackage[sort&compress,numbers,super]{natbib}
\setcitestyle{super,open={[},close={]}}
\bibliographystyle{plainnat}

\newcommand\hnu@define@term[1]{
  \expandafter\gdef\csname #1\endcsname##1{\expandafter\gdef\csname hnu@#1\endcsname{##1}}
  \csname #1\endcsname{}
}
\hnu@define@term{title}
\hnu@define@term{author}
\hnu@define@term{authorid}
\hnu@define@term{college}
\hnu@define@term{major}
\hnu@define@term{workon}
\hnu@define@term{supervisor}
\hnu@define@term{outsupervisor}
\hnu@define@term{submitdate}
\hnu@define@term{hnuname}
\hnu@define@term{hnucode}
\hnu@define@term{degree}
\hnu@define@term{clc}
\hnu@define@term{secrettext}

\newcommand\setfontsize[2]{\fontsize{#1}{#2}\selectfont}
\newcommand\linetext[2]{\underline{\makebox[#1][c]{#2}}}

\setlength{\parindent}{2\ccwd}
\setlength{\parskip}{0pt}
\linespread{1.25}\selectfont

\ctexset{
  chapter={
    format=\centering\rmfamily\bfseries\fontsize{18pt}{22.5pt}\selectfont,
    beforeskip=0.5\baselineskip,
    afterskip=0.5\baselineskip,
    name={},
    number=\thechapter,
    aftername=\hspace{1em}
  },
  section={
    format=\rmfamily\bfseries\fontsize{14pt}{17.5pt}\selectfont,
    beforeskip=0.5\baselineskip,
    afterskip=0.5\baselineskip
  },
  subsection={
    format=\rmfamily\bfseries\fontsize{12pt}{15pt}\selectfont,
    beforeskip=0.5\baselineskip,
    afterskip=0.5\baselineskip
  },
  subsubsection={
    format=\rmfamily\bfseries\fontsize{12pt}{15pt}\selectfont,
    beforeskip=0.5\baselineskip,
    afterskip=0.5\baselineskip
  },
  paragraph={
    format=\rmfamily\bfseries\fontsize{12pt}{15pt}\selectfont,
    beforeskip=0pt,
    afterskip=0pt,
    runin=true
  },
  subparagraph={
    format=\rmfamily\bfseries\fontsize{12pt}{15pt}\selectfont,
    beforeskip=0pt,
    afterskip=0pt,
    runin=true
  }
}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{\rmfamily\fontsize{10.5pt}{10.5pt}\selectfont 湖南科技大学本科生毕业设计（论文）}
\fancyfoot[C]{\rmfamily\fontsize{10.5pt}{10.5pt}\selectfont\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\renewcommand\frontmatter{\cleardoublepage\@mainmatterfalse\pagenumbering{roman}\renewcommand{\thepage}{-\roman{page}-}}
\renewcommand\mainmatter{\cleardoublepage\@mainmattertrue\pagenumbering{arabic}\renewcommand{\thepage}{-\arabic{page}-}}
\AtBeginDocument{%
  \frontmatter
  % 对抗 pandoc/parskip 的默认改写，统一正文首行缩进
  \setlength{\parindent}{2\ccwd}%
  \setlength{\parskip}{0pt}%
}
\pretocmd{\@chapter}{\if@mainmatter\else\mainmatter\fi}{}{}

\renewcommand\maketitle{%
  \begin{titlepage}
    \thispagestyle{empty}
    \begin{tikzpicture}[remember picture,overlay]
      \node[anchor=north west,xshift=2.2cm,yshift=-2.2cm] at (current page.north west)
      {\includegraphics[width=8.0cm]{figures/hnust-logo.png}};

      \node[anchor=north,yshift=-7.8cm] at (current page.north)
      {{\rmfamily\bfseries\fontsize{26pt}{32pt}\selectfont 本 科 毕 业 设 计（论 文）}};

      \node[anchor=north,yshift=-12.9cm] at (current page.north)
      {{\rmfamily\fontsize{18pt}{22pt}\selectfont
      \begin{tabular}{@{}p{3.0cm}p{12.0cm}@{}}
      题\qquad 目 & \linetext{12.0cm}{\hnu@title} \\[0.85em]
      作\qquad 者 & \linetext{12.0cm}{\hnu@author} \\[0.85em]
      学\qquad 院 & \linetext{12.0cm}{\hnu@college} \\[0.85em]
      专\qquad 业 & \linetext{12.0cm}{\hnu@major} \\[0.85em]
      学\qquad 号 & \linetext{12.0cm}{\hnu@authorid} \\[0.85em]
      校内指导老师 & \linetext{12.0cm}{\hnu@supervisor} \\[0.85em]
      校外指导老师 & \linetext{12.0cm}{\hnu@outsupervisor} \\
      \end{tabular}}};

      \node[anchor=north,yshift=-26.5cm] at (current page.north)
      {{\rmfamily\fontsize{18pt}{22pt}\selectfont \hnu@submitdate}};
    \end{tikzpicture}
    \null
  \end{titlepage}
}

\newenvironment{abstract}{%
  \cleardoublepage
  \chapter*{摘\quad 要}
  \addcontentsline{toc}{chapter}{摘\quad 要}
}{ }

\newcommand\keywords[1]{\par\noindent\textbf{关键词：}#1}

\renewcommand\contentsname{目\quad 录}
\renewcommand\tableofcontents{%
  \frontmatter
  \chapter*{\contentsname}%
  \addcontentsline{toc}{chapter}{\contentsname}%
  \@starttoc{toc}%
}

% 参考文献区样式：五号宋体、条目无额外段间距、悬挂缩进
\renewcommand\bibfont{\rmfamily\fontsize{10.5pt}{13pt}\selectfont}
\setlength{\bibsep}{0pt}
\setlength{\bibhang}{2\ccwd}
\renewcommand\@biblabel[1]{[#1]\hfill}

\captionsetup{font={small},labelsep=space}

\makeatother
