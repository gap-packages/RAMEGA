## We use Neural Networks because the functions involved incorporate other functions, designed for threshold elements.
## Alse, one can change n to any other value, but the test will run much longer.

gap> START_TEST("Testing all Boolean functions for n=3");
gap> LoadPackage("thelma",false);
true
gap> n:=3;;
gap> t:=Tuples([0,1],2^n);;
gap> test:=true;;
gap> for f in t do if OutputOfNeuralNetwork(BooleanFunctionByNeuralNetwork(LogicFunction(n,2,f)))<>LogicFunction(n,2,f) then test:=false; break; fi; od;
gap> test;
true
gap> STOP_TEST( "test-n-3.tst", 200000000000 );

##############################################################
#E
