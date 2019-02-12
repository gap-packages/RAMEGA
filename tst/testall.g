###############################################################################
##
##  testall.g                   THELMA                Victor Bovdi,Vasyl Laver
##
##  Copyright (C)  2018,  UAE University, UAE
##
LoadPackage( "thelma" );
TestDirectory(DirectoriesPackageLibrary( "thelma", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);

##
#E
###############################################################################
