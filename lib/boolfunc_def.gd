#############################################################################
##
#W  boolfunc_def.gd                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: boolfunc_def.gd,v 1.00 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##

DeclareOperation( "CharacteristicVectorOfFunction", [IsFFECollection]);
DeclareOperation( "IsCharacteristicVectorOfSTE", [IsVector]);
DeclareOperation("KernelOfBooleanFunction", [IsFFECollection]);
DeclareGlobalFunction( "ReducedKernelOfBooleanFunction" );
DeclareOperation( "IsInverseInKernel", [IsFFECollection] );
DeclareOperation( "IsKernelContainingPrecedingVectors",[IsFFECollection] );
DeclareOperation("IsRKernelBiggerOfCombSum", [IsFFECollection]);
DeclareOperation("IsUnateInVariable",[IsFFECollection,IsInt]);
DeclareOperation("IsUnateBooleanFunction",[IsFFECollection]);
DeclareOperation("SelfDualExtensionOfBooleanFunction",[IsFFECollection]);
DeclareOperation("InfluenceOfVariable",[IsFFECollection,IsInt]);
DeclareOperation("SplitBooleanFunction",[IsFFECollection,IsInt,IsBool]);


#E
##