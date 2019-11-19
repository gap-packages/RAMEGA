#
# Ramega: A GAP package on random methods for group rings
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", ">= 2016.01.21") then
    Error("AutoDoc 2016.01.21 or newer is required");
fi;

AutoDoc(rec(
    gapdoc := rec(
                main:= "ramega.xml",
                bib := "ramegabib.xml"
                )
));
