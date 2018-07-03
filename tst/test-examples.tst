gap> START_TEST("Testing examples from Chapter 2 of Thelma manual.");
gap> LoadPackage("thelma",false);
true

## Example 2.1.1

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> Display(te);
Weight vector = [ 1, 2 ], Threshold = 3.
Threshold Element realizes the function f :
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

## Example 2.1.2

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> IsThresholdElement(te);
true
gap> IsThresholdElement([[1,2],3]);
false

## Example 2.1.3

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> f:=OutputOfThresholdElement(te);
[ 0, 0, 0, 1 ]

## Example 2.1.4

gap> te:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> sv:=StructureOfThresholdElement(te);
[ [ 1, 2 ], 3 ]

## Example 2.1.5

gap> te:=RandomThresholdElement(4,-10,10);
< threshold element with weight vector [ -1, -3, -7, 0 ] and threshold 9 >

## Example 2.1.6

gap> te1:=ThresholdElement([1,2],3);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> OutputOfThresholdElement(te1);
[ 0, 0, 0, 1 ]
gap> te2:=ThresholdElement([1,2],0);
< threshold element with weight vector [ 1, 2 ] and threshold 0 >
gap> OutputOfThresholdElement(te2);
[ 1, 1, 1, 1 ]
gap> te3:=ThresholdElement([1,1],2);
< threshold element with weight vector [ 1, 1 ] and threshold 2 >
gap> OutputOfThresholdElement(te3);
[ 0, 0, 0, 1 ]
gap> te1<te2;
true
gap> te1>te2;
false
gap> te1=te3;
true

## Example 2.2.1
## In all further examples we omit the case of polynomials, as it requires input from user.

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];
[ 0, 0, 0, 1 ]
gap> c:=CharacteristicVectorOfFunction(f);
[ 2, 2, 2 ]
gap> f:="0001";
"0001"
gap> c:=CharacteristicVectorOfFunction(f);
[ 2, 2, 2 ]

## Example 2.2.2

gap> f:="0001";;
gap> c:=CharacteristicVectorOfFunction(f);
[ 2, 2, 2 ]
gap> IsCharacteristicVectorOfSTE(c);
true
gap> f:="0110";;
gap> ## f = x+y;
gap> c:=CharacteristicVectorOfFunction(f);
[ 0, 0, 0 ]
gap> IsCharacteristicVectorOfSTE(c);
false

## Example 2.2.3

gap> f:=[0*Z(2),0*Z(2),0*Z(2),0*Z(2),0*Z(2),Z(2)^0,Z(2)^0,0*Z(2)];
[ 0, 0, 0, 0, 0, 1, 1, 0 ]
gap> nn:=BooleanFunctionByNeuralNetwork(f);;
gap> Display(nn);
Inner Layer:
[ [[ 1, -2, 3 ], 4], [[ 1, 2, -3 ], 3] ]
Outer Layer: disjunction
Neural Network realizes the function f :
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
Sum of Products:[ 5, 6 ]
gap> IsUnateInVariable(f,1);
true
gap> f:="00000110";
"00000110"
gap> IsUnateInVariable(f,2);
false
gap> IsUnateInVariable(f,3);
false

## Example 2.2.4

gap> f:=[0*Z(2),Z(2)^0,Z(2)^0,Z(2)^0];
[ 0, 1, 1, 1 ]
gap> IsUnateBooleanFunction(f);
true
gap> f:="1001";
"1001"
gap> IsUnateBooleanFunction(f);
false

## Example 2.2.5

gap> f:=[0*Z(2),0*Z(2),0*Z(2),0*Z(2),0*Z(2),Z(2)^0,Z(2)^0,0*Z(2)];
[ 0, 0, 0, 0, 0, 1, 1, 0 ]
gap> InfluenceOfVariable(f,1);
2
gap> InfluenceOfVariable(f,3);
2
gap> f:="00000110";
"00000110"
gap> InfluenceOfVariable(f,2);
2
gap> InfluenceOfVariable(f,3);
2

## Example 2.2.6

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];;
gap> fsd:=SelfDualExtensionOfBooleanFunction(f);;
gap> fsd;
[ 0, 0, 0, 1, 0, 1, 1, 1 ]
gap> f:="0001";;
gap> fsd:=SelfDualExtensionOfBooleanFunction(f);
[ 0, 0, 0, 1, 0, 1, 1, 1 ]

## Example 2.2.7

gap> f:=[0*Z(2),Z(2)^0,Z(2)^0,0*Z(2)];;
gap> out:=SplitBooleanFunction(f,1,false);;
gap> out[1];
[ 0, 1, 1, 1 ]
gap> out[2];
[ 1, 1, 1, 0 ]
gap> f:="0110";
"0110"
gap> out:=SplitBooleanFunction(f,1,true);;
gap> out[1];
[ 0, 1, 0, 0 ]
gap> out[2];
[ 0, 0, 1, 0 ]

## Example 2.2.8

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];
[ 0, 0, 0, 1 ]
gap> k:=KernelOfBooleanFunction(f);
[ [ [ 1, 1 ] ], 1 ]
gap> f:="0111";
"0111"
gap> k:=KernelOfBooleanFunction(f);
[ [ [ 0, 0 ] ], 0 ]
gap> f:="01010110";;
gap> k:=KernelOfBooleanFunction(f);
[ [ [ 0, 0, 1 ], [ 0, 1, 1 ], [ 1, 0, 1 ], [ 1, 1, 0 ] ], 1 ]

## Example 2.2.9

gap> ## Continuation of the last example
gap> rk:=ReducedKernelOfBooleanFunction(k[1]);;
gap> j:=1;
1
gap> for i in rk do Print(j,".\n"); Display(i); Print("\n"); j:=j+1; od;
1.
 . . .
 . 1 .
 1 . .
 1 1 1

2.
 . 1 .
 . . .
 1 1 .
 1 . 1

3.
 1 . .
 1 1 .
 . . .
 . 1 1

4.
 1 1 1
 1 . 1
 . 1 1
 . . .

## Example 2.2.10

gap> f:="01010110";;
gap> k:=KernelOfBooleanFunction(f);;
gap> Display(k[1]);
 . . 1
 . 1 1
 1 . 1
 1 1 .
gap> IsInverseInKernel(f);
true

## Example 2.2.11

gap> f:="01010110";;
gap> IsKernelContainingPrecedingVectors(f);
false

## Example 2.2.12

gap> f:="0110";;
gap> IsRKernelBiggerOfCombSum(f);
false

## Example 2.2.13

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];
[ 0, 0, 0, 1 ]
gap> te:=BooleanFunctionBySTE(f);
< threshold element with weight vector [ 1, 2 ] and threshold 3 >
gap> f:="11001000";
"11001000"
gap> te:=BooleanFunctionBySTE(f);
< threshold element with weight vector [ -1, -4, -2 ] and threshold -2 >
gap> Display(last);
Weight vector = [ -1, -4, -2 ], Threshold = -2.
Threshold Element realizes the function f :
[ 0, 0, 0 ] || 1
[ 0, 0, 1 ] || 1
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 1
[ 1, 0, 1 ] || 0
[ 1, 1, 0 ] || 0
[ 1, 1, 1 ] || 0
Sum of Products:[ 0, 1, 4 ]

## Example 2.2.14

gap> f:="1x001x0x";
"1x001x0x"
gap> te:=PDBooleanFunctionBySTE(f);
< threshold element with weight vector [ -1, -2, -3 ] and threshold -1 >
gap> OutputOfThresholdElement(te);
[ 1, 0, 0, 0, 1, 0, 0, 0 ]

## Example 2.3.1

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];
[ 0, 0, 0, 1 ]
gap> te1:=RandomThresholdElement(2,-2,2);
< threshold element with weight vector [ 2, 0 ] and threshold 0 >
gap> OutputOfThresholdElement(te1);
[ 1, 1, 1, 1 ]
gap> te2:=ThresholdElementTraining(te1,1,f,100);
< threshold element with weight vector [ 2, 1 ] and threshold 3 >
gap> OutputOfThresholdElement(te2);
[ 0, 0, 0, 1 ]

## Example 2.3.2

gap> f:=[0*Z(2),0*Z(2),0*Z(2),Z(2)^0];
[ 0, 0, 0, 1 ]
gap> te1:=RandomThresholdElement(2,-2,2);
< threshold element with weight vector [ -1, 0 ] and threshold 0 >
gap> OutputOfThresholdElement(te1);
[ 1, 1, 0, 0 ]
gap> te2:=ThresholdElementBatchTraining(te1,1,f,100);
< threshold element with weight vector [ 1, 1 ] and threshold 2 >
gap> OutputOfThresholdElement(te2);
[ 0, 0, 0, 1 ]

## Example 2.3.3

gap> f:="0111";;
gap> te:=WinnowAlgorithm(f,2,100);
< threshold element with weight vector [ 1, 1 ] and threshold 1 >
gap> OutputOfThresholdElement(te);
[ 0, 1, 1, 1 ]

## Example 2.3.4

gap> ## Conjunction can not be trained by Winnow algorithm.
gap> f:="0001";;
gap> te:=WinnowAlgorithm(f,2,100);
[ ]
gap> ## But in the case of Winnow2 we can obtain the desirable result.
gap> te:=Winnow2Algorithm(f,2,100);
< threshold element with weight vector [ 1/2, 1/2 ] and threshold 1 >
gap> OutputOfThresholdElement(te);
[ 0, 0, 0, 1 ]

## Example 2.3.5

gap> f:="0111";;
gap> te:=STESynthesis(f);
< threshold element with weight vector [ 2, 2 ] and threshold 1 >
gap> Display(last);
Weight vector = [ 2, 2 ], Threshold = 1.
Threshold Element realizes the function f :
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 1
Product of Sums:[ 0 ]

## Example 3.1.1

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
[ 0, 0 ] || 0
[ 0, 1 ] || 1
[ 1, 0 ] || 1
[ 1, 1 ] || 0
Sum of Products:[ 1, 2 ]

## Example 3.1.2

gap> ## Consider the neural network from previous example.
gap> IsNeuralNetwork(nn);
true

## Example 3.1.3

gap> OutputOfNeuralNetwork(nn);
[ 0, 1, 1, 0 ]

## Example 3.2.1

gap> f:="01010110";;
gap> nn:=BooleanFunctionByNeuralNetwork(f);
< neural network with
2 threshold elements on inner layer and disjunction on outer level >
gap> Display(last);
Inner Layer:
[ [[ -1, -2, 4 ], 2], [[ 1, 2, -3 ], 3] ]
Outer Layer: disjunction
Neural Network realizes the function f :
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 1
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 1
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
Sum of Products:[ 1, 3, 5, 6 ]

## Example 3.2.2

gap> f:="00000110";
"00000110"
gap> nn:=BooleanFunctionByNeuralNetworkDASG(f);
< neural network with
2 threshold elements on inner layer and conjunction on outer level >
gap> Display(last);
Inner Layer:
[ [[ 1, -4, -2 ], -3], [[ 1, 4, 2 ], 3] ]
Outer Layer: conjunction
Neural Network realizes the function f :
[ 0, 0, 0 ] || 0
[ 0, 0, 1 ] || 0
[ 0, 1, 0 ] || 0
[ 0, 1, 1 ] || 0
[ 1, 0, 0 ] || 0
[ 1, 0, 1 ] || 1
[ 1, 1, 0 ] || 1
[ 1, 1, 1 ] || 0
Sum of Products:[ 5, 6 ]


gap> STOP_TEST( "test-examples.tst", 200000000000 );

##############################################################
#E
