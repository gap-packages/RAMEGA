#############################################################################
##
#W  random.gd                         Zsolt Adam Balogh <baloghzsa@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#Y  Copyright (C)  2020,  UAE University, UAE
##

DeclareOperation( "BasicGroup", [IsGroupRing]);
DeclareOperation( "GetRandomUnit", [IsGroupRing]);
DeclareOperation( "GetRandomNormalizedUnit", [IsGroupRing]);
DeclareOperation( "GetRandomUnitaryUnit", [IsGroupRing]);
DeclareOperation( "GetRandomNormalizedUnitaryUnit", [IsGroupRing]);
DeclareOperation( "IsLienEngel", [IsGroupRing]);
DeclareOperation( "RandomLienEngelLength", [IsGroupRing, IsPosInt]);
DeclareOperation( "GetRandomElementFromAugmentationIdeal", [IsGroupRing]);
DeclareOperation( "RandomExponent", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomExponentOfNormalizedUnitsCenter", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomNilpotencyClass", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomDerivedLength", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomCommutatorSubgroup", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomCommutatorSubgroupOfNormalizedUnits", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomNormalizedUnitGroup", [IsGroupRing]);
DeclareOperation( "RandomCommutatorSeries", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomLowerCentralSeries", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomUnitaryOrder", [IsGroupRing, IsPosInt]);
DeclareOperation( "GetRandomCentralNormalizedUnit", [IsGroupRing]);
DeclareOperation( "RandomUnitarySubgroup", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomDihedralDepth", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomQuaternionDepth", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomOmega", [IsGroupRing, IsPosInt, IsPosInt]);
DeclareOperation( "RandomAgemo", [IsGroupRing, IsPosInt, IsPosInt]);
#========================================================================
DeclareOperation( "GetRandomSubgroupOfNormalizedUnitGroup", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomConjugacyClass", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomConjugacyClasses", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomIsCentralElement", [IsGroupRing, IsElementOfFreeMagmaRing, IsPosInt]);
DeclareOperation( "RandomIsNormal", [IsGroupRing, IsGroup, IsPosInt]);
#DeclareOperation( "RandomCommutatorSubgroup", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomCenterOfCommutatorSubgroup", [IsGroupRing, IsPosInt]);
#DeclareOperation( "RandomLowerCentralSeries", [IsGroupRing, IsPosInt]);
DeclareOperation( "RandomConjugacyClassByElement", [IsGroupRing, IsElementOfFreeMagmaRing, IsPosInt]);
