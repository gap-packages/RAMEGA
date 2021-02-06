gap> START_TEST("Testing examples from Ramega manual.");
gap> LoadPackage("ramega",false);
true

## Example 2.1.1
gap> RANDOM_SEED(1);
gap> G:=CyclicGroup(IsFpGroup,4);
<fp group of size 4 on the generators [ a ]>
gap> Elements(G);
[ <identity ...>, a, a^2, a^3 ]
gap> KG:=GroupRing(GF(2),G);
<algebra-with-one over GF(2), with 1 generators>
gap> BasicGroup(KG);
<group of size 4 with 1 generators>
gap> Elements(last);
[ (Z(2)^0)*<identity ...>, (Z(2)^0)*a, (Z(2)^0)*a^2, (Z(2)^0)*a^3 ]


## Example 2.1.2

gap> G:=CyclicGroup(4);
<pc group of size 4 with 2 generators>
gap> KG:=GroupRing(GF(2),G);
<algebra-with-one over GF(2), with 2 generators>
gap> IsLienEngel(KG);
false

gap> G:=DihedralGroup(16);
<pc group of size 16 with 4 generators>
gap> KG:=GroupRing(GF(2),G);
<algebra-with-one over GF(2), with 4 generators>
gap> IsLienEngel(KG);
true

## Example 2.2.1

gap> G:=CyclicGroup(4);
<pc group of size 4 with 2 generators>
gap> KG:=GroupRing(GF(7),G);
<algebra-with-one over GF(7), with 2 generators>
gap> u:=GetRandomUnit(KG);;
gap> Augmentation(u)<>Zero(KG);
true
gap> u*u^-1;
(Z(7)^0)*<identity> of ...


## Example 2.2.2

gap> G:=DihedralGroup(IsFpGroup,16);;
gap> KG:=GroupRing(GF(2),G);;
gap> u:=GetRandomNormalizedUnit(KG);;
gap> Augmentation(u);
Z(2)^0
gap> u*u^-1;
(Z(2)^0)*<identity ...>

## Example 2.2.3

gap> G:=CyclicGroup(4);;
gap> KG:=GroupRing(GF(2),G);;
gap> u:=GetRandomNormalizedUnitaryUnit(KG);;
gap> u*Involution(u);
(Z(2)^0)*<identity> of ...
gap> Augmentation(u);
Z(2)^0

## Example 2.2.4
gap> G:=CyclicGroup(16);;
gap> Aut:=AutomorphismGroup(G);;
gap> KG:=GroupRing(GF(2),G);;
gap> Aut2:=Filtered(Aut,i->Order(i)=2);;
gap> Aut2;
[ [ f1*f3 ] -> [ f1*f2*f4 ], [ f1*f3 ] -> [ f1*f3*f4 ],
[ f1*f3 ] -> [ f1*f2 ] ]
gap> eta:=Aut2[2];
[ f1*f3 ] -> [ f1*f3*f4 ]
gap> u:=GetRandomNormalizedUnitaryUnit(KG,eta);;
gap> u*RAMEGA_InvolutionKG(u, eta, KG);
(Z(2)^0)*<identity> of ...


## Example 2.2.5

gap> G:=CyclicGroup(IsFpGroup,4);;
gap> KG:=GroupRing(GF(2),G);;
gap> u:=GetRandomCentralNormalizedUnit(KG);;
gap> Augmentation(u);
Z(2)^0
gap> bool:=true;
true
gap> for x in Elements(KG) do
> if x*u<>u*x then bool:=false; break; fi;
> od;
gap> bool;
true

## Example 2.2.6

gap> G:=QuaternionGroup(16);
<pc group of size 16 with 4 generators>
gap> KG:=GroupRing(GF(2),G);
<algebra-with-one over GF(2), with 4 generators>
gap> u:=GetRandomElementFromAugmentationIdeal(KG);;
gap> Augmentation(u);
0*Z(2)

## Example 2.3.1
gap> G:=DihedralGroup(16);;
gap> KG:=GroupRing(GF(2),G);;
gap> RandomLienEngelLength(KG,100);
4

## Example 2.3.2
gap> G:=DihedralGroup(16);;
gap> KG:=GroupRing(GF(2),G);;
gap> RandomExponent(KG,100);
8

## Example 2.3.3
gap> G:=DihedralGroup(16);;
gap> KG:=GroupRing(GF(2),G);;
gap> RandomExponentOfNormalizedUnitsCenter(KG,100);
4

## Example 2.3.4
gap> G:=DihedralGroup(16);;
gap> KG:=GroupRing(GF(2),G);;
gap> RandomNilpotencyClass(KG,100);
#I  LAGUNA package: Constructing Lie algebra ...
#I  LAGUNA package: Checking Lie nilpotency ...
4

## Example 2.3.5
gap> D:=DihedralGroup(IsFpGroup,8);;
gap> KG:=GroupRing(GF(2),D);;
gap> RandomDerivedLength(KG,100);
2

## Example 2.3.6
gap> G:=DihedralGroup(IsFpGroup,8);;
gap> KG:=GroupRing(GF(2),G);;
gap> SG:=RandomCommutatorSubgroup(KG,100);;
gap> StructureDescription(SG);
"C2 x C2 x C2"

## Example 2.3.7
gap> G:=DihedralGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> SG:=RandomCommutatorSubgroupOfNormalizedUnits(KG,100);;
gap> u:=Random(Elements(SG));;
gap> Augmentation(u);
Z(2)^0

## Example 2.3.8
gap> G:=DihedralGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> SG:=RandomNormalizedUnitGroup(KG);;
gap> u:=Random(Elements(SG));;
gap> Augmentation(u);
Z(2)^0

## Example 2.3.9
gap> G:=DihedralGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> SG:=RandomUnitarySubgroup(KG,100);;
gap> u:=Random(Elements(SG));;
gap> Augmentation(u);
Z(2)^0
gap> u*u^-1;
(Z(2)^0)*<identity> of ...

## Example 2.3.10
gap> G:=DihedralGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> CS:=RandomCommutatorSeries(KG,200);;
gap> List(CS,i->Size(i));
[ 128, 8, 1 ]

## Example 2.3.11
gap> G:=DihedralGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> CS:=RandomLowerCentralSeries(KG,200);;
#I  LAGUNA package: Constructing Lie algebra ...
#I  LAGUNA package: Checking Lie nilpotency ...
gap> List(CS,i->Size(i));
[ 128, 8, 1 ]

## Example 2.3.12
gap> G:=CyclicGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> ord:=RandomUnitaryOrder(KG,500);
32

## Example 2.3.13
gap> G:=CyclicGroup(8);;
gap> KG:=GroupRing(GF(2),G);;
gap> RO:=RandomOmega(KG,2,50);;
gap> u:=Random(Elements(RO));;
gap> (u^2)^2;
(Z(2)^0)*<identity> of ...
gap> ## Let h be a group.
gap> h:=SmallGroup(16,10);;
gap> RO:=RandomOmega(h,2,50);;
gap> u:=Random(Elements(RO));;
gap> (u^2)^2;
<identity> of ...

## Example 2.3.14
gap> KG:=GroupRing(GF(2),CyclicGroup(8));;
gap> RA:=RandomAgemo(KG,2,50);
<group with 2 generators>
gap> StructureDescription(RA);
"C2"

## Example 2.3.15
gap> G:=SmallGroup([64,6]);
<pc group of size 64 with 6 generators>
gap> StructureDescription(G);
"(C8 x C4) : C2"
gap> RandomDihedralDepth(G,1000);
2

## Example 2.3.16
gap> G:=SmallGroup([64,10]);
<pc group of size 64 with 6 generators>
gap> StructureDescription(G);
"(C8 : C4) : C2"
gap> RandomQuaternionDepth(G,1000);
2

## Example 2.3.17
gap> KG:=GroupRing(GF(2),DihedralGroup(8));;
gap> G:=GetRandomSubgroupOfNormalizedUnitGroup(KG,2);;
gap> el:= Elements(G)[1];;
gap> Augmentation(el);
Z(2)^0

## Example 2.3.18
gap> KG:=GroupRing(GF(2),DihedralGroup(8));;
gap> cc:=RandomConjugacyClass(KG,4);;
gap> cc[1]*cc[2]*cc[1]^-1 = cc[2];
true

## Example 2.3.19
gap> KG:=GroupRing(GF(2),SmallGroup(8,3));;
gap> cc:=RandomConjugacyClasses(KG,100);;
gap> Size(Union(cc));
128
gap> Collected(List(cc,x->Number(x)));
[ [ 1, 16 ], [ 4, 28 ] ]
gap> vkg:=RandomNormalizedUnitGroup(KG);;
gap> Size(vkg);
128


## Example 2.3.20
gap> KG:=GroupRing(GF(2),CyclicGroup(16));;
gap> u:=Random(Elements(KG));;
gap> RandomIsCentralElement(KG,u,100);
true

## Example 2.3.21
gap> KG:=GroupRing(GF(2),CyclicGroup(4));;
gap> u:=Elements(KG)[16];
(Z(2)^0)*f1*f2
gap> G:=Group(u);;
gap> StructureDescription(G);
"C4"
gap> RandomIsNormal(KG,G,100);
true

## Example 2.3.22
gap> KG:=GroupRing(GF(2),DihedralGroup(8));;
gap> cc:=RandomCenterOfCommutatorSubgroup(KG,100);
<group with 8 generators>
gap> StructureDescription(cc);
"C2 x C2 x C2"

## Example 2.3.23
gap> KG:=GroupRing(GF(2),DihedralGroup(8));;
gap> u:=Random(Elements(KG));;
gap> rcc:= RandomConjugacyClassByElement(KG,u,100);;
gap> rcc[1]*u*rcc[1]^-1 = u;
true




gap> STOP_TEST( "test-examples.tst", 200000000000 );

##############################################################
#E
