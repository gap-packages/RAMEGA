###############################################################################
##
##  testall.g                   RAMEGA                Balogh Zsolt, Vasyl Laver
##
##  Copyright (C)  2018,  UAE University, UAE
##
LoadPackage( "ramega" );
TestDirectory(DirectoriesPackageLibrary( "ramega", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);

##
#E
###############################################################################
