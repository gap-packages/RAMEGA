gap> START_TEST("Testing examples from Chapter 2 of Thelma manual.");
gap> LoadPackage("thelma",false);
true

## Example 2.1.1

gap> f:=LogicFunction(2,2,[0,0,1,1]);
< Boolean function of 2 variables >
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 1
[ 1, 1 ] || 1
gap> f:=LogicFunction(2,3,[0,0,1,1,2,1,2,0,1]);
< 3-valued logic function of 2 variables >
gap> Display(f);
3-valued logic function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 0, 2 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 2
[ 1, 2 ] || 1
[ 2, 0 ] || 2
[ 2, 1 ] || 0
[ 2, 2 ] || 1

## Example 2.1.2

gap> f:=LogicFunction(2,2,[0,1,1,1]);;
gap> IsLogicFunction(f);
true

## Example 2.1.3

gap> x:=Indeterminate(GF(2),"x");;
gap> y:=Indeterminate(GF(2),"y");;
gap> pol:=x+y;;
gap> f:=PolynomialToBooleanFunction(pol,2);
< Boolean function of 2 variables >
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 0

## Example 2.1.4

gap> f:=LogicFunction(3,2,[0,0,0,0,0,1,1,0]);
< Boolean function of 3 variables >
gap> Display(f);
Boolean function of 3 variables.
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
gap> IsUnateInVariable(f,1);
true
gap> IsUnateInVariable(f,2);
false
gap> IsUnateInVariable(f,3);
false

## Example 2.1.5

gap> f:=LogicFunction(2,2,[0,1,1,1]);;
gap> IsUnateBooleanFunction(f);
true
gap> f:=LogicFunction(2,2,[0,1,1,0]);;
gap> IsUnateBooleanFunction(f);
false

## Example 2.1.6

gap> f:=LogicFunction(3,2,[0,0,0,0,0,1,1,0]);
< Boolean function of 3 variables >
gap> Display(f);
Boolean function of 3 variables.
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
gap> InfluenceOfVariable(f,2);
2

## Example 2.1.7

gap> f:=LogicFunction(2,2,[0,0,0,1]);
< Boolean function of 2 variables >
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1
gap> fsd:=SelfDualExtensionOfBooleanFunction(f);
< Boolean function of 3 variables >
gap> Display(fsd);
Boolean function of 3 variables.
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 1
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 1

## Example 2.1.8

gap> f:=LogicFunction(2,2,[0,1,1,0]);;
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 0
gap> out:=SplitBooleanFunction(f,1,false);;
gap> Print(out[1]);
[2, 2,[ 0, 1, 1, 1 ]]
gap> Print(out[2]);
[2, 2,[ 1, 1, 1, 0 ]]
gap> out:=SplitBooleanFunction(f,1,true);;
gap> Print(out[1]);
[2, 2,[ 0, 1, 0, 0 ]]
gap> Print(out[2]);
[2, 2,[ 0, 0, 1, 0 ]]

## Example 2.1.9

gap> f:=LogicFunction(3,2,[0,1,1,0,1,0,0,0]);;
gap> k:=KernelOfBooleanFunction(f);
[ [ [ 0*Z(2), 0*Z(2), Z(2)^0 ], [ 0*Z(2), Z(2)^0, 0*Z(2) ],
      [ Z(2)^0, 0*Z(2), 0*Z(2) ] ], 1 ]


## Example 2.1.10

gap> ## Continuation of Example 2.2.4
gap> rk:=ReducedKernelOfBooleanFunction(k[1]);;
gap> j:=1;;
gap> for i in rk do Print(j,".\n"); Display(i); Print("\n"); j:=j+1; od;
1.
 . . .
 . 1 1
 1 . 1

2.
 . 1 1
 . . .
 1 1 .

3.
 1 . 1
 1 1 .
 . . .

## Example 3.1.1

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> Display(te);
Weight vector = [ 1, 2 ], Threshold = 3.
Threshold Element realizes the function f :
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1
Sum of Products:[ 3 ]
gap> w:=[1,2,4,-4,6,8,10,-25,6,32];;
gap> T:=60;;
gap> te:=ThresholdElement(w,T);
< threshold element with weight vector [ 1, 2, 4, -4, 6, 8, 10, -25, 6, 32
 ] and threshold 60 >
gap> Display(te);
Weight vector = [ 1, 2, 4, -4, 6, 8, 10, -25, 6, 32 ], Threshold = 60.
Threshold Element realizes the function f :
Sum of Products:[ 59, 155, 185, 187, 251, 315, 379, 411, 427, 441, 443, 507, 5\
71, 667, 697, 699, 763, 827, 891, 923, 939, 953, 955, 1019 ]

## Example 3.1.2

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> IsThresholdElement(te);
true
gap> IsThresholdElement([[1,2],3]);
false

## Example 3.1.3

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> f:=OutputOfThresholdElement(te);
< Boolean function of 2 variables >
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1

## Example 3.1.4

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> sv:=StructureOfThresholdElement(te);
[ [ 1, 2 ], 3 ]

## Example 3.1.6

gap> te1:=ThresholdElement([1,2],3);;
gap> Print(OutputOfThresholdElement(te1),"\n");
[2, 2,[ 0, 0, 0, 1 ]]
gap> te2:=ThresholdElement([1,2],0);;
gap> Print(OutputOfThresholdElement(te2),"\n");
[2, 2,[ 1, 1, 1, 1 ]]
gap> te3:=ThresholdElement([1,1],2);;
gap> Print(OutputOfThresholdElement(te3),"\n");
[2, 2,[ 0, 0, 0, 1 ]]
gap> te1<te2;
true
gap> te1>te2;
false
gap> te1=te3;
true

## Example 3.2.1

gap> f:=LogicFunction(2,2,[0,0,0,1]);
< Boolean function of 2 variables >
gap> CharacteristicVectorOfFunction(f);
[ 2, 2, 2 ]

## Example 3.2.2

gap> f:=LogicFunction(2,2,[0,0,0,1]);
< Boolean function of 2 variables >
gap> c:=CharacteristicVectorOfFunction(f);
[ 2, 2, 2 ]
gap> IsCharacteristicVectorOfSTE(c);
true

## Example 3.2.3
gap> f:=LogicFunction(3,2,[0,1,0,1,0,1,1,0]);;
gap> k:=KernelOfBooleanFunction(f);;
gap> Display(k[1]);
 . . 1
 . 1 1
 1 . 1
 1 1 .
gap> IsInverseInKernel(f);
true


## Example 3.2.4

gap> ##Continuation of the previous example
gap> IsKernelContainingPrecedingVectors(f);
false

## Example 3.2.5

gap> f:=LogicFunction(2,2,[0,1,1,0]);
< Boolean function of 2 variables >
gap> IsRKernelBiggerOfCombSum(f);
false

## Example 3.2.6

gap> f:=LogicFunction(3,2,[1,1,0,0,1,0,0,0]);
< Boolean function of 3 variables >
gap> te:=BooleanFunctionBySTE(f);
< threshold element with weight vector [ -1, -4, -2 ] and threshold -2 >
gap> Display(te);
Weight vector = [ -1, -4, -2 ], Threshold = -2.
Threshold Element realizes the function f :
Boolean function of 3 variables.
[ 0, 0, 0 ] || 1
[ 0, 0, 1 ] || 1
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 1
[ 1, 0, 1 ] || 0
[ 1, 1, 0 ] || 0
[ 1, 1, 1 ] || 0
Sum of Products:[ 0, 1, 4 ]
gap> f:=LogicFunction(2,2,[0,1,1,0]);
< Boolean function of 2 variables >
gap> te:=BooleanFunctionBySTE(f);
[  ]

## Example 3.2.7

gap> f:="1x001x0x";
"1x001x0x"
gap> te:=PDBooleanFunctionBySTE(f);
< threshold element with weight vector [ -1, -2, -3 ] and threshold -1 >
gap> Display(te);
Weight vector = [ -1, -2, -3 ], Threshold = -1.
Threshold Element realizes the function f :
Boolean function of 3 variables.
[ 0, 0, 0 ] || 1
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 1
[ 1, 0, 1 ] || 0
[ 1, 1, 0 ] || 0
[ 1, 1, 1 ] || 0
Sum of Products:[ 0, 4 ]

## Example 3.3.1
## We changed the RandomThresholdELement lines.

gap> f:=LogicFunction(2,2,[0,0,0,1]);
< Boolean function of 2 variables >
gap> te1:=ThresholdElement([0,-1],0);
< threshold element with weight vector [ 0, -1 ] and threshold 0 >
gap> Display(OutputOfThresholdElement(te1));
Boolean function of 2 variables.
[ 0, 0 ] || 1
[ 0, 1 ] || 0
[ 1, 0 ] || 1
[ 1, 1 ] || 0
gap> te2:=ThresholdElementTraining(te1,1,f,100);
< threshold element with weight vector [ 2, 1 ] and threshold 3 >
gap> Display(OutputOfThresholdElement(te2));
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1


## Example 3.3.2

gap> f:=LogicFunction(2,2,[0,0,0,1]);
< Boolean function of 2 variables >
gap> te1:=ThresholdElement([0,2],2);
< threshold element with weight vector [ 0, 2 ] and threshold 2 >
gap> Display(OutputOfThresholdElement(te1));
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 0
[ 1, 1 ] || 1
gap> te2:=ThresholdElementBatchTraining(te1,1,f,100);
< threshold element with weight vector [ 2, 2 ] and threshold 3 >
gap> Display(OutputOfThresholdElement(te2));
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1

## Example 3.3.3

gap> x:=Indeterminate(GF(2),"x");;
gap> y:=Indeterminate(GF(2),"y");;
gap> pol:=x*y+x+y;;
gap> f:=PolynomialToBooleanFunction(pol,2);
< Boolean function of 2 variables >
gap> Display(f);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 1
gap> te:=WinnowAlgorithm(f,2,100);
< threshold element with weight vector [ 1, 1 ] and threshold 1 >
gap> Display(OutputOfThresholdElement(te));
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 1

## Example 3.3.4

gap> ##Conjunction can not be trained by Winnow algorithm.
gap> x:=Indeterminate(GF(2),"x");;
gap> y:=Indeterminate(GF(2),"y");;
gap> pol:=x*y;;
gap> f:=PolynomialToBooleanFunction(pol,2);
< Boolean function of 2 variables >
gap> te:=WinnowAlgorithm(f,2,100);
[  ]
gap> ## But in the case of Winnow2 we can obtain the desirable result.
gap> te:=Winnow2Algorithm(f,2,100);
< threshold element with weight vector [ 1/2, 1/2 ] and threshold 1 >
gap> Display(te);
Weight vector = [ 1/2, 1/2 ], Threshold = 1.
Threshold Element realizes the function f :
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 1
Sum of Products:[ 3 ]

## Example 3.3.5

gap> f:=x*y+x+y;;
gap> x:=Indeterminate(GF(2),"x");;
gap> y:=Indeterminate(GF(2),"y");;
gap> pol:=x*y+x+y;;
gap> f:=PolynomialToBooleanFunction(pol,2);;
gap> te:=STESynthesis(f);
< threshold element with weight vector [ 2, 2 ] and threshold 1 >
gap> Display(te);
Weight vector = [ 2, 2 ], Threshold = 1.
Threshold Element realizes the function f :
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 1
Product of Sums:[ 0 ]

## Example 4.1.1

gap> te1:=ThresholdElement([1,1],1);
< threshold element with weight vector [ 1, 1 ] and threshold 1 >
gap> te2:=ThresholdElement([-1,-2],-2);
< threshold element with weight vector [ -1, -2 ] and threshold -2 >
gap> inner:=[te1,te2];
[ < threshold element with weight vector [ 1, 1 ] and threshold 1 >,
  < threshold element with weight vector [ -1, -2 ] and threshold -2 > ]
gap> nn:=NeuralNetwork(inner,false);
< neural network with
2 threshold elements on inner layer and conjunction on outer level >
gap> Display(last);
Inner Layer:
[ [[ 1, 1 ], 1], [[ -1, -2 ], -2] ]
Outer Layer: conjunction
Neural Network realizes the function f :
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 0
Sum of Products:[ 1, 2 ]

## Example 4.1.2

gap> ## Consider the neural network <C>nn</C> from the previous example.
gap> IsNeuralNetwork(nn);
true

## Example 4.1.3

gap> f:=OutputOfNeuralNetwork(nn);
< Boolean function of 2 variables >
gap> Display(last);
Boolean function of 2 variables.
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 0

## Example 4.2.1

gap> x:=Indeterminate(GF(2),"x");;
gap> y:=Indeterminate(GF(2),"y");;
gap> z:=Indeterminate(GF(2),"z");;
gap> f:=PolynomialToBooleanFunction(x*y+z,3);
< Boolean function of 3 variables >
gap> nn:=BooleanFunctionByNeuralNetwork(f);
< neural network with
2 threshold elements on inner layer and disjunction on outer level >
gap> Display(last);
Inner Layer:
[ [[ -1, -2, 4 ], 2], [[ 1, 2, -3 ], 3] ]
Outer Layer: disjunction
Neural Network realizes the function f :
Boolean function of 3 variables.
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 1
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 1
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
Sum of Products:[ 1, 3, 5, 6 ]

## Example 4.2.2.

gap> f:=LogicFunction(3,2,[0,0,0,0,0,1,1,0]);
< Boolean function of 3 variables >
gap> nn:=BooleanFunctionByNeuralNetworkDASG(f);
< neural network with 2 threshold elements on inner layer and conjunction on outer level >
gap> Display(last);
Inner Layer:
[ [[ 1, 4, 2 ], 3], [[ 1, -4, -2 ], -3] ]
Outer Layer: conjunction
Neural Network realizes the function f :
Boolean function of 3 variables.
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
Sum of Products:[ 5, 6 ]

## Example 5.1.1

gap> F:=GF(13);;
gap> st:=[[Z(13)^5,Z(13)^7],Z(13)^4];;
gap> dim:=[2,3,3];;
gap> mvte:=MVThresholdElement(st,dim,F);
< multivalued threshold element over GF(13) with structure [[ 6, 11 ], 3] and
  dimension vector [ 2, 3, 3 ] >
gap> Display(mvte);
Structure vector = [[ 6, 11 ], 3]
Dimension vector = [[ 2, 3, 3 ]]
Field: GF(13)
Multi-Valued Threshold Element realizes the function f :
[ 1, 1 ]  ||  9
[ 1, 3 ]  ||  3
[ 1, 9 ]  ||  1
[ 12, 1 ]  ||  1
[ 12, 3 ]  ||  1
[ 12, 9 ]  ||  9
gap> F:=GF(5);;
gap> st:=[[Z(5)^0,Z(5)^0],Z(5)^2];;
gap> dim:=2;;
gap> mvte:=MVThresholdElement(st,dim,F);
< multivalued threshold element over GF(5) with structure [[ 1, 1 ],
4] and dimension vector [ 2, 2, 2 ] >
gap> Display(mvte);
Structure vector = [[ 1, 1 ], 4]
Dimension vector = [[ 2, 2, 2 ]]
Field: GF(5)
Multi-Valued Threshold Element realizes the function f :
[ 1, 1 ]  ||  1
[ 1, 4 ]  ||  4
[ 4, 1 ]  ||  4
[ 4, 4 ]  ||  1

## Example 5.1.2

gap> IsMVThresholdElement(mvte);
true

## Example 5.1.3

gap> F:=GF(13);;
gap> st:=[[Z(13)^5,Z(13)^7],Z(13)^4];;
gap> dim:=[2,3,3];;
gap> mvte:=MVThresholdElement(st,dim,F);
< multivalued threshold element over GF(13) with structure [[ 6, 11 ], 3] and
  dimension vector [ 2, 3, 3 ] >
gap> f:=OutputOfMVThresholdElement(mvte);
< logic function of 2 variables and dimension vector [ 2, 3, 3 ]>
gap> Display(f);
[ 0, 0 ] || 2
[ 0, 1 ] || 1
[ 0, 2 ] || 0
[ 1, 0 ] || 0
[ 1, 1 ] || 0
[ 1, 2 ] || 2

## Example 5.1.4

gap> StructureOfMVThresholdElement(mvte);
[ [ Z(13)^5, Z(13)^7 ], Z(13)^4 ]

## Example 5.1.5

gap> f:=LogicFunction(2,2,[0,1,1,0]);
< Boolean function of 2 variables >
gap> mvte:=MVBooleanFunctionBySTE(f,GF(3));
[  ]
gap> mvte:=MVBooleanFunctionBySTE(f,GF(5));
< multivalued threshold element over GF(5) with structure [[ 4, 4 ],
4] and dimension vector [ 2, 2, 2 ] >
gap> Display(last);
Structure vector = [[ 4, 4 ], 4]
Dimension vector = [[ 2, 2, 2 ]]
Field: GF(5)
Multi-Valued Threshold Element realizes the function f :
[ 1, 1 ]  ||  1
[ 1, 4 ]  ||  4
[ 4, 1 ]  ||  4
[ 4, 4 ]  ||  1
gap> ## Consider an example if dimensions are presented as a list.
gap> f:=LogicFunction(2,[2,3,3],[0,0,1,1,2,2]);
< logic function of 2 variables and dimension vector [ 2, 3, 3 ]>
gap> mvte:=MVBooleanFunctionBySTE(f,GF(13));
< multivalued threshold element over GF(13) with structure [[ 12, 10 ], 5]
  and dimension vector [ 2, 3, 3 ] >
gap> Display(last);
Structure vector = [[ 12, 10 ], 5]
Dimension vector = [[ 2, 3, 3 ]]
Field: GF(13)
Multi-Valued Threshold Element realizes the function f :
[ 1, 1 ]  ||  1
[ 1, 3 ]  ||  1
[ 1, 9 ]  ||  3
[ 12, 1 ]  ||  3
[ 12, 3 ]  ||  9
[ 12, 9 ]  ||  9


gap> STOP_TEST( "test-examples.tst", 200000000000 );

##############################################################
#E
