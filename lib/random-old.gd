#############################################################################
##
#W  random.gd                         Zsolt Adam Balogh <baloghzsa@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: random.gd,v 1.00 $
##
#Y  Copyright (C)  2019,  UAE University, UAE
##

DeclareGlobalFunction( "BasicGroup" ); #+
DeclareOperation( "IsLienEngel", [IsGroupRing]); #+
DeclareOperation( "RandomLienEngelLength", [IsGroupRing, IsPosInt]);
DeclareOperation( "GetRandomNormalizedUnit", [IsGroupRing]); #+
DeclareOperation( "GetRandomNormalizedUnitaryUnit", [IsGroupRing]); #+
DeclareOperation( "GetRandomUnit", [IsGroupRing]); #+
DeclareOperation( "GetRandomElementFromAugmentationIdeal", [IsGroupRing]); #+
DeclareOperation( "RandomExponent", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomExponentOfNormalizedUnitsCenter", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomNilpotencyClass", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomDerivedLength", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomCommutatorSubgroup", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomCommutatorSubgroupOfNormalizedUnits", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomCenterOfCommutatorSubgroup", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "RandomNormalizedUnitGroup", [IsGroupRing]); #+
DeclareOperation( "RandomCommutatorSeries", [IsGroupRing, IsPosInt]); #+ Check output
DeclareOperation( "RandomLowerCentralSeries", [IsGroupRing, IsPosInt]); #+ Check output
DeclareOperation( "RandomUnitaryOrder", [IsGroupRing, IsPosInt]); #+
DeclareOperation( "GetRandomCentralNormalizedUnit", [IsGroupRing]); #+
DeclareOperation( "RandomCentralUnitaryOrder", [IsGroupRing, IsPosInt]); #NO EXAMPLE
DeclareOperation( "RandomUnitarySubgroup", [IsGroupRing, IsPosInt]);#+
DeclareOperation( "RandomDihedralDepth", [IsGroupRing, IsPosInt]); #CHECK CORECTNESS
DeclareOperation( "RandomQuaternionDepth", [IsGroupRing, IsPosInt]); #CHECK CORECTNESS

#E
##
