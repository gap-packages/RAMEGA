#############################################################################
##
#W  boolfunc_def.gd                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: boolfunc_def.gd,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##

DeclareCategory( "IsLogicFunctionObj", IsObject );
DeclareCategoryCollections( "IsLogicFunctionObj" );
DeclareOperation( "LogicFunction",  [IsPosInt,IsDenseList,IsDenseList]);
DeclareGlobalFunction( "IsLogicFunction" );
DeclareGlobalFunction("PolynomialToBooleanFunction");
DeclareOperation( "CharacteristicVectorOfFunction", [IsObject]);
DeclareOperation( "IsCharacteristicVectorOfSTE", [IsVector]);
DeclareOperation("KernelOfBooleanFunction", [IsObject]);
DeclareGlobalFunction( "ReducedKernelOfBooleanFunction" );
DeclareOperation( "IsInverseInKernel", [IsObject] );
DeclareOperation( "IsKernelContainingPrecedingVectors",[IsObject] );
DeclareOperation("IsRKernelBiggerOfCombSum", [IsObject]);
DeclareOperation("IsUnateInVariable",[IsObject,IsPosInt]);
DeclareOperation("IsUnateBooleanFunction",[IsObject]);
DeclareOperation("SelfDualExtensionOfBooleanFunction",[IsObject]);
DeclareOperation("InfluenceOfVariable",[IsObject,IsPosInt]);
DeclareOperation("SplitBooleanFunction",[IsObject,IsPosInt,IsBool]);


#E
##
