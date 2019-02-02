#############################################################################
##
#W  threl_def.gd                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: threl_def.gd,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file declares the category of threshold elements.
##

DeclareCategory( "IsThresholdElementObj", IsObject );
DeclareCategoryCollections( "IsThresholdElementObj" );
DeclareGlobalFunction( "ThresholdElement" );
DeclareGlobalFunction( "OutputOfThresholdElement" );
DeclareGlobalFunction( "StructureOfThresholdElement" );
DeclareGlobalFunction( "IsThresholdElement" );
DeclareGlobalFunction( "RandomThresholdElement" );

#E
