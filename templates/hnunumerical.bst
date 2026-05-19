ENTRY{ author title journal year volume number pages publisher address booktitle school institution note howpublished url doi }
{}{}
READ
FUNCTION {begin.bib}
{ "\\begin{thebibliography}{99}" write$ newline$ }
FUNCTION {end.bib}
{ "\\end{thebibliography}" write$ newline$ }
FUNCTION {article}{ output.bibitem author write$ ". " write$ title write$ ". " write$ journal write$ ", " write$ year write$ "." write$ newline$ }
FUNCTION {book}{ output.bibitem author write$ ". " write$ title write$ ". " write$ publisher write$ ", " write$ year write$ "." write$ newline$ }
FUNCTION {inproceedings}{ output.bibitem author write$ ". " write$ title write$ ". " write$ booktitle write$ ", " write$ year write$ "." write$ newline$ }
FUNCTION {misc}{ output.bibitem author write$ ". " write$ title write$ ". " write$ year write$ "." write$ newline$ }
READ
EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}
