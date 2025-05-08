\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{customreport}[2025/03/14 Custom Report Class]

% Base class
\LoadClass[a4paper]{report}

%%%%%%%%%%%%%%
%
% Packages
%
%%%%%%%%%%%%%%
\RequirePackage[utf8]{inputenc}  % UTF-8 encoding
\RequirePackage[T1]{fontenc}     % Better font encoding
\RequirePackage[ngerman]{babel}  % Language support
\RequirePackage{lmodern}         % Latin Modern font
\RequirePackage{graphicx}        % Including graphics
\RequirePackage{caption}         % Customizing the caption
\RequirePackage{pdflscape}       % Landscape mode
\RequirePackage{geometry}
\RequirePackage{amsmath, amssymb} % Mathematical symbols and equations
\RequirePackage{hyperref}        % Clickable links
\RequirePackage{nameref}         % References with names
\RequirePackage[nottoc]{tocbibind} % Include TOC in the table of contents
\RequirePackage{setspace}       % Line spacing
\RequirePackage{titlesec}       % Headings
\RequirePackage{iftex}  % Simplifies checking for LuaLaTeX/XeLaTeX
\RequirePackage{fancyhdr}       % Headers and footers
\RequirePackage{parskip}        % Spacing between paragraphs
\RequirePackage{etoolbox}       % Conditional macros
\RequirePackage{siunitx}        % Number alignment in tables
\RequirePackage{multirow}       % Multirows in tables
\RequirePackage{booktabs}       % Prettier tables
\RequirePackage{longtable}      % Long tables spanning pages
\RequirePackage[backend=biber, style=apa]{biblatex} % Bibliography
\RequirePackage{csquotes}       % Proper citation formatting
\RequirePackage{pdfpages}
\RequirePackage[most]{tcolorbox}
\RequirePackage{xcolor}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{eurosym}
\RequirePackage{float}
\RequirePackage{afterpage}
\RequirePackage{listings}
\PassOptionsToPackage{toc}{listings}
\RequirePackage{lscape}
\RequirePackage{lastpage}
\RequirePackage{tabularx}
\RequirePackage{lscape}
\RequirePackage{longtable}
\RequirePackage{xltabular}
\RequirePackage{pifont}
%\RequirePackage{tocloft}
\RequirePackage{courier} % Monospace-Font
\RequirePackage[toc,page,title]{appendix}		% for appendices
\ifLuaTeX  % If using LuaLaTeX
    \RequirePackage{fontspec}
\elseifXeTeX  % If using XeLaTeX
    \RequirePackage{fontspec}
%\else  % Default to pdfLaTeX
\fi

%%%%%%%%%%%%%%
%
% Layout
%
%%%%%%%%%%%%%%
% Margins
\geometry{
    %top=2cm,
    %left=2.5cm,
    %bottom=4cm,
    %right=2cm,
    %headsep=1.5cm,
    %headheight=5.5cm,
    %footskip=2.5cm
    top=3.5cm, 
    bottom=3.5cm, 
    headheight=2cm,
    headsep=1cm,
    footskip=1.5cm
}

%%%%%%%%%%%%%%
%
% Font
%
%%%%%%%%%%%%%%
\@ifpackageloaded{fontspec}{
    \setmainfont{Arial}[Numbers={Monospaced,Proportional}, SizeFeatures={Size=11}]
}{
    \renewcommand{\rmdefault}{lmss}  % Use Latin Modern Sans as fallback
}

% special characters
\newcommand{\cmark}{\ding{51}}
\newcommand{\xmark}{\ding{55}}

% Line spacing
\setstretch{1.5}

% Heading adjustments
%\titleformat{\chapter}[block]{\sffamily\bfseries\Large}{Kapitel\ \thechapter}{1.5em}{%\ifnum\value{chapter}=0\relax\else---\hspace{0.75em}\ \fi}
\titleformat{\chapter}[block]{\sffamily\bfseries\Large}{\thechapter}{1em}{}
\titleformat{\section}[block]{\sffamily\bfseries\Large}{\thesection}{1em}{}
\titleformat{\subsection}[block]{\sffamily\bfseries\normalsize}{\thesubsection}{1em}{}
\titleformat{\subsubsection}[block]{\sffamily\bfseries\normalsize}{\thesubsubsection}{1em}{}

\titlespacing*{\chapter}{0pt}{2ex}{1ex}
\titlespacing*{\section}{0pt}{1ex}{0.5ex}
\titlespacing*{\subsection}{0pt}{0.6ex}{0.3ex}
\titlespacing*{\subsubsection}{0pt}{0.6ex}{0.3ex}

% Numbering format
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}

%%%%%%%%%%%%%%
%
% Table
%
%%%%%%%%%%%%%%
% Table adjustments
\renewcommand{\arraystretch}{1.2} % line spacing for tables
% alignment of numbers in tables
\sisetup{ 
  round-mode = places, % Rounds numbers
  round-precision = 2, % to 2 places
}

%%%%%%%%%%%%%%
%
% Header & Footer
%
%%%%%%%%%%%%%%
% Header and footer settings
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\@title}
\fancyhead[R]{\leftmark}
%\fancyfoot[R]{\thepage}
%\fancyfoot[L]{\@author}
%\fancyfoot[C]{\@date}
%\fancyhead[C]{\begin{figure}[H] \centering\ifx\@image\@empty\else\includegraphics[width=30mm]{\@image}\fi\end{figure}}
\fancyfoot[R]{Seite~\thepage~von~\pageref{LastPage}}
\fancyfoot[L]{\@author}
\fancyfoot[C]{
\@date% \\ 
%smoca ag $\bullet$ Technoparkstrasse 2, 8406 Winterthur $\bullet$ +41 52 508 59 57 $\bullet$ www.smoca.ch
}

%\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}


%rewrites plain page style to make header work with toc, bib, lof, etc.
\makeatletter
\let\ps@plain\ps@fancy
\makeatother

%%%%%%%%%%%%%%
%
% Table of Content
%
%%%%%%%%%%%%%%
% Stellt sicher, dass für \section Punkte hinzugefügt werden
%\renewcommand{\cftsecdotsep}{\cftdotsep}  

\setcounter{tocdepth}{4} % Inhaltsverzeichnisebenen
\setcounter{secnumdepth}{4} % Nummerierungsebenen

%%%%%%%%%%%%%%
%
% Table of Literatur
%
%%%%%%%%%%%%%%
\newcommand{\listofliteratur}[0]{
	%\chapter*{Literaturverzeichnis}
	%\addcontentsline{toc}{chapter}{Literaturverzeichnis}
	\printbibliography[
		heading=bibintoc,
		title={Literaturverzeichnis}
	]
}

%%%%%%%%%%%%%%
%
% Code
%
%%%%%%%%%%%%%%
% Kotlin
\lstdefinelanguage{kotlin}{
  comment=[l]{//},
  commentstyle={\color{gray}\ttfamily},
  emph={filter, first, firstOrNull, forEach, lazy, map, mapNotNull, println},
  emphstyle={\color{OrangeRed}},
  identifierstyle=\color{black},
  keywords={!in, !is, abstract, actual, annotation, as, as?, break, by, catch, class, companion, const, constructor, continue, crossinline, data, delegate, do, dynamic, else, enum, expect, external, false, field, file, final, finally, for, fun, get, if, import, in, infix, init, inline, inner, interface, internal, is, lateinit, noinline, null, object, open, operator, out, override, package, param, private, property, protected, public, receiveris, reified, return, return@, sealed, set, setparam, super, suspend, tailrec, this, throw, true, try, typealias, typeof, val, var, vararg, when, where, while},
  keywordstyle={\color{NavyBlue}\bfseries},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  morestring=[s]{"""*}{*"""},
  ndkeywords={@Deprecated, @JvmField, @JvmName, @JvmOverloads, @JvmStatic, @JvmSynthetic, Array, Byte, Double, Float, Int, Integer, Iterable, Long, Runnable, Short, String, Any, Unit, Nothing},
  ndkeywordstyle={\color{BurntOrange}\bfseries},
  sensitive=true,
  stringstyle={\color{ForestGreen}\ttfamily},
  basicstyle=\ttfamily\footnotesize,
}

% Swift
\definecolor{keyword}{HTML}{BA2CA3}
\definecolor{string}{HTML}{D12F1B}
\definecolor{comment}{HTML}{008400}
\lstdefinelanguage{swift}{
  keywords={
open,catch,@escaping,nil,throws,func,if,then,else,for,in,while,do,switch,case,default,where,break,continue,fallthrough,return,typealias,struct,class,enum,protocol,var,func,let,get,set,willSet,didSet,inout,init,deinit,extension,subscript,prefix,operator,infix,postfix,precedence,associativity,left,right,none,convenience,dynamic,final,lazy,mutating,nonmutating,optional,override,required,static,unowned,safe,weak,internal,private,public,is,as,self,unsafe,dynamicType,true,false,nil,Type,Protocol,
  },
  comment=[l]{//}, % l is for line comment
  comment=[s]{/*}{*/}, % s is for start and end delimiter
  morestring=[b]", % defines that strings are enclosed in double quotes
  breaklines=true,
  escapeinside={\%*}{*)},
  numbers=left,
  captionpos=b,
  breakatwhitespace=true,
  basicstyle=\linespread{1.0}\ttfamily\footnotesize, % https://tex.stackexchange.com/a/102728/129441
  showstringspaces=false, % lets spaces in strings appear as real spaces
  columns=fixed,
  keepspaces=true,
  keywordstyle=\color{keyword},
  stringstyle=\color{string},
  commentstyle=\color{comment},
  basicstyle=\ttfamily\footnotesize,
}

% YML
\lstdefinelanguage{YAML}{
  keywords={true,false,null,y,n},
  keywordstyle=\color{blue}\bfseries,
  sensitive=false,
  comment=[l]{\#},
  morecomment=[l]{\#},
  morestring=[b]',
  morestring=[b]",
  stringstyle=\color{orange},
  commentstyle=\color{gray}\ttfamily,
  basicstyle=\ttfamily\footnotesize,
}

% Bash
\lstdefinelanguage{Bash}{
  morekeywords={cd, set, export, brew},
  keywordstyle=\color{blue}\bfseries,
  sensitive=true,
  comment=[l]{\#},
  commentstyle=\color{gray}\ttfamily,
  morestring=[b]",
  stringstyle=\color{orange},
  basicstyle=\ttfamily\footnotesize,
}

% JSON
\lstdefinelanguage{json}{
    morestring=[b]",
    morecomment=[l]{//},
    moredelim=**[is][\color{gray}]{@}{@},
    stringstyle=\color{teal},
    keywordstyle=\color{blue},
    commentstyle=\color{gray}\ttfamily,
    basicstyle=\ttfamily\footnotesize,
    literate=
     *{0}{{{\color{purple}0}}}{1}
      {1}{{{\color{purple}1}}}{1}
      {2}{{{\color{purple}2}}}{1}
      {3}{{{\color{purple}3}}}{1}
      {4}{{{\color{purple}4}}}{1}
      {5}{{{\color{purple}5}}}{1}
      {6}{{{\color{purple}6}}}{1}
      {7}{{{\color{purple}7}}}{1}
      {8}{{{\color{purple}8}}}{1}
      {9}{{{\color{purple}9}}}{1}
      {:}{{{\color{black}:{}}}}{1}
      {,}{{{\color{black},}}}{1}
      {"true"}{{{\color{orange}"true"}}}{1}
      {"false"}{{{\color{orange}"false"}}}{1}
      {"null"}{{{\color{orange}"null"}}}{1},
}


% default
\lstset{
  frame=single,
  breaklines=true,
  captionpos=b,
  numbers=left,
  numberstyle=\tiny\color{gray},
  xleftmargin=2em,
  framexleftmargin=1.5em,
  basicstyle=\ttfamily\footnotesize,
}

%inline
\definecolor{inlinebg}{RGB}{245,245,245}
\definecolor{inlineborder}{RGB}{220,220,220}
\lstdefinestyle{inlinecode}{
  basicstyle=\ttfamily\footnotesize,
  backgroundcolor=\color{inlinebg},
  frame=single,
  rulecolor=\color{inlineborder},
  framesep=1pt,
  framerule=0.4pt,
  breaklines=true,
}

\let\oldlstinline\lstinline

\renewcommand{\lstinline}[1]{
  \oldlstinline[style=inlinecode]{#1}
}

\renewcommand{\lstlistingname}{Code}
\newcommand{\listoflistings}{
\lstlistoflistings
\addcontentsline{toc}{chapter}{\lstlistlistingname}
}
\renewcommand{\lstlistlistingname}{Codeverzeichnis}

%%%%%%%%%%%%%%
%
% References
%
%%%%%%%%%%%%%%
% Hyperlink settings
\hypersetup{
    colorlinks=true,      % Enables colored links
    linkcolor=black,       % Color for internal links (e.g., Table of Contents)
    urlcolor=blue,        % Color for URLs
    citecolor=black,       % Color for citations in the bibliography
    filecolor=blue,       % Color for file links
    menucolor=blue        % Color for menu links in Acrobat
}

%appendix
\renewcommand\appendixtocname{Anhang}
\renewcommand\appendixpagename{Anhang}

% Bibliography source
\addbibresource{bibliography.bib}

% Image path
%\graphicspath{{./img/}}

\input{customreport/titlepage}
