#############################################################################
##
##  PackageInfo.g for the package `RAMEGA'                     Zsolt Adam Balogh
##                                                             Vasyl Laver
##
##

SetPackageInfo( rec(
PackageName := "RAMEGA",
Subtitle := "A package for Random Methods in Group Algebras",
Version := "1.000",
Date := "04/04/2020",
License := "GPL-2.0-or-later",

PackageWWWHome := Concatenation( "https://gap-packages.github.io/", ~.PackageName ),
    SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Balogh",
    FirstNames    := "Zsolt Adam",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "baloghzsa@gmail.com",
   	Place         := "Al Ain",
    Institution   := "UAE University"
  ),
  rec(
    LastName      := "Laver",
    FirstNames    := "Vasyl",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "vasyl.laver@uzhnu.edu.ua",
  	Place         := "Uzhhorod",
    Institution   := "Uzhhorod National University"
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
   "The <span class=\"pkgname\">RAMEGA</span> package is a package with random methods for group algebras.",


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
  GAP := ">= 4.10",
  NeededOtherPackages := [["GAPDoc", "1.5"], ["LAGUNA", "3.9"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := ["group rings", "group algebras", "random methods"]

));
