#############################################################################
##
##  PackageInfo.g for the package `Thelma'                     Victor Bovdi
##                                                             Vasyl Laver
##
##

SetPackageInfo( rec(
PackageName := "Thelma",
Subtitle := "A package on threshold elements",
Version := "1.00",
Date := "18/10/2018",
PackageWWWHome := Concatenation( "https://vlaver.github.io/", ~.PackageName ),
    SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/vlaver/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Bovdi",
    FirstNames    := "Victor",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "vbovdi@gmail.com",
   	Place         := "Al Ain",
    Institution   := "UAE University"
  ),
  rec(
    LastName      := "Laver",
    FirstNames    := "Vasyl",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "vasyl.laver@uzhnu.edu.ua",
  	Place         := "Al Ain",
    Institution   := "UAE University"
  ),
],

Status := "dev",

##  You must provide the next two entries if and only if the status is
##  "accepted" because is was successfully refereed:
# format: 'name (place)'
# CommunicatedBy := "Mike Atkinson (St. Andrews)",
#CommunicatedBy := "Edmund Robertson (St. Andrews)",
# format: mm/yyyy
# AcceptDate := "08/1999",
#AcceptDate := "09/2004",

README_URL := 
  Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),

AbstractHTML :=
   "The <span class=\"pkgname\">Thelma</span> package is package with algorithms to deal with threshold elements.",


PackageDoc := rec(
  BookName  := ~.PackageName,
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  # the path to the .six file used by GAP's help system
  SixFile   := "doc/manual.six",
  # a longer title of the book, this together with the book name should
  # fit on a single text line (appears with the '?books' command in GAP)
  LongTitle := ~.Subtitle,
),

Dependencies := rec(
  GAP := ">= 4.4",
  NeededOtherPackages := [["GAPDoc", "1.5"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation(
  "----------------------------------------------------------------\n",
  "Loading  Thelma ", ~.Version, ", a package for threshold logic\n",
#  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,",\n",
#        " (", ~.Persons[1].WWWHome, ")\n",
#  "   ", ~.Persons[2].FirstNames, " ", ~.Persons[2].LastName,".\n"
#        " (", ~.Persons[2].WWWHome, ")\n",
#  "   ", ~.Persons[3].FirstNames, " ", ~.Persons[3].LastName,"\n",
#        " (", ~.Persons[3].WWWHome, ")\n",
  "For help, type: ?Thelma: \n",
  "----------------------------------------------------------------\n" ),

Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["threshold elements", "neural networks", "threshold logic"]

));
