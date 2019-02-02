#############################################################################
##
#W  neural_network.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: neural_network.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file declares the category of neural network.
##
#############################################################################
##
#C IsNeuralNetworkObj    . . . . . .  network of threshold elements
##

DeclareRepresentation("IsNeuralNetworkRep", IsComponentObjectRep, ["layer1","layer2"]);

######################################################################
##
#F  NeuralNetwork(InnerLayer, OuterLayer)
##
##  Produces a neural network
##  Inner layer is given as a list of threshold elements,
##  the outer layer is given by a boolean value.
##  If true - the outer layer is a disjunction, if false - conjunction of inverses.
##

InstallGlobalFunction( NeuralNetwork, function(InnerLayer, OuterLayer)

    local t,Func,A, alph, tel, F, i, j, x, y, TE, l;

	if not IsDenseList(InnerLayer) then
        Error("Inner Layer has to be a dense list of threshold elements");
	fi;

	if not IsBool(OuterLayer) then
        Error("Outer Layer should be given as a boolean");
	fi;

	if Size(InnerLayer)<2 and OuterLayer<>fail then
		Error("Inner Layer should contain at least 2 threshold elements or there has to be disjunction or conjunction on outer layer");
	fi;

	for i in InnerLayer do
		if not IsThresholdElement(i) then
			Error("Inner Layer has to be a dense list of threshold elements");
		fi;
	od;

  # Construct the family of all neural networks.
  F:= NewFamily( "Neural Networks" , IsNeuralNetworkObj );



	if Size(InnerLayer)=1 and OuterLayer=fail then
		tel := rec(innerlayer := InnerLayer,
				outerlayer := OuterLayer,
				);

		TE := Objectify( NewType( F, IsNeuralNetworkObj and IsNeuralNetworkRep and IsAttributeStoringRep ),
                 tel );
		# Return the neural network.
		return TE;
	fi;


    tel := rec(innerlayer := InnerLayer,
               outerlayer := OuterLayer,
               );

    TE := Objectify( NewType( F, IsNeuralNetworkObj and IsNeuralNetworkRep and IsAttributeStoringRep ),
                 tel );

    # Return the neural network.
    return TE;
end);

######################################################################
##
#F  OutputOfNeuralNetwork(NN)
##
InstallGlobalFunction( OutputOfNeuralNetwork, function(NN)
local l,i,aplh,InnerLayer,OuterLayer,alph;
    InnerLayer:=NN!.innerlayer;
    OuterLayer:=NN!.outerlayer;

	  if not IsNeuralNetworkObj(NN) then
        Error("The argument to OutputOfNeuralNetwork must be a neural network");
    fi;

    l:=[];
  	for i in InnerLayer do Add(l,OutputOfThresholdElement(i)); od;

    if Size(InnerLayer)=1 and OuterLayer=fail then
    	return l[1];
    fi;

    alph:=THELMA_INTERNAL_BFtoGF(l[1]);

  	if OuterLayer=true then
  		  for i in [2..Size(l)] do
  			     alph:=THELMA_INTERNAL_Disjunction(alph,THELMA_INTERNAL_BFtoGF(l[i]));
  		  od;
  	elif OuterLayer=false then
    		for i in [2..Size(l)] do
  			     alph:=THELMA_INTERNAL_Conjunction(alph,THELMA_INTERNAL_BFtoGF(l[i]));
  		  od;
  	fi;

    return LogicFunction(LogInt(Size(alph),2),2,List(alph,Order));
end);

#############################################################################
##
#M  ViewObj( <A> ) . . . . . . . . . . . print neural network
##
InstallMethod( ViewObj,
        "displays a neural network",
        true,
        [IsNeuralNetworkObj and IsNeuralNetworkRep], 0,
        function( A )
		if (A!.outerlayer = true) then
			Print("< neural network with ", Size(A!.innerlayer), " threshold elements on inner layer and disjunction on outer level >");
		elif (A!.outerlayer = false) then
			Print("< neural network with ", Size(A!.innerlayer), " threshold elements on inner layer and conjunction on outer level >");
		else
			Print("< neural network with one threshold element >");
		fi;
end);


#############################################################################
##
#M  PrintObj( <A> ) . . . . . . . . . . . print neural network
##
InstallMethod( PrintObj,
        "displays a neural network",
        true,
        [IsNeuralNetworkObj and IsNeuralNetworkRep], 0,
        function( A )
    Print("Inner Layer:",A!.innerlayer,"\n");
	if A!.outerlayer=true then
		Print("Outer Layer: disjunction \n");
	elif A!.outerlayer=false then
		Print("Outer Layer: conjunction \n");
	else
		Print("No Outer Layer in the Neural Network \n");
	fi;
end);

#############################################################################
##
#M  Display( <A> ) . . . . . . . . . . . print neural network
##
InstallMethod( Display,
       "displays a neural network",
        true,
        [IsNeuralNetworkObj and IsNeuralNetworkRep], 0,
        function( A )
		local i,t,ff,k;

		Print("Inner Layer: \n");
		Print(A!.innerlayer,"\n");

		if A!.outerlayer=true then
			Print("Outer Layer: disjunction \n");
		elif A!.outerlayer=false then
			Print("Outer Layer: conjunction \n");
		else
			Print("No Outer Layer \n");
		fi;

		Print("Neural Network realizes the function f : \n");

    ff:=OutputOfNeuralNetwork(A);

    k:=1;
    if ff!.numvars<=4 then
      Display(ff);
    fi;

    Print(THELMA_INTERNAL_VectorToFormula(THELMA_INTERNAL_BFtoGF(ff)),"\n");
end);

#############################################################################
##
#F  IsNeuralNetwork(A)
##
##  Tests if A is a neural network
##
InstallGlobalFunction( IsNeuralNetwork, function(A)
    return(IsNeuralNetworkObj(A));
end);

#############################################################
BindGlobal("THELMA_INTERNAL_FindMaxSet",function(ker)
# Arguments: ker - a matrix over GF(2);
# Output: a matrix on which maximal p(A) matrix (see GecheRobotyshyn83) is achieved.
	local rq,qlist,tempw,tempi,res, aminus, maxi,i0, l,t,prows,pcols,
	  j0, n, i, w, z, q, LS, qtest, temp, bool, ptest, tt, mout, templist;

	n:=Size(ker[1]);

	if (Size(ker) = 1) and (Position(ker[1],One(GF(2)))=fail) then
		return [ker[1]];
	fi;

	qlist:=[];
	mout:=[]; #tolerance matrix L
	bool:=true;
	pcols:=THELMA_INTERNAL_SortCols(ker);

	ker:=TransposedMat(Permuted(TransposedMat(ker),pcols));

	prows:=THELMA_INTERNAL_SortRows(ker);
	ker:=Permuted(ker,prows);
	i:=1;
	#Check if first row of reduced kernel coincide with the first rows of tolerance matrix
	while  (i<=n) and (2^(i-1)<=Size(ker)) do
		if (ker{[1..2^(i-1)]}{[1..i]} <> THELMA_INTERNAL_BuildToleranceMatrix(i)
			or THELMA_INTERNAL_CheckZeroMat(ker{[1..2^(i-1)]}{[i+1..n]})=false)=true
			then break; fi;
		i:=i+1;
	od;


	if i=2  then
		return [ker[1]];
	fi;

	#i0 shows the size of the considered tolerance matrices
	i0:=i-1;
	#j0 number of the considered row
	j0:=2^(i0-1)+1;

	maxi:=n-Position(Reversed(ker[Size(ker)]),One(GF(2)))+1;

	z:=[];
	mout:=ker{[1..j0-1]};

	#Second stage. We are seeking for all L* matrices
	while ((bool<>false) and (i0<maxi))=true do
		LS:=THELMA_INTERNAL_BuildInverseToleranceMatrix(i0);
		q:=0;

		if qlist=[] then
			while ((j0+q<=Size(ker)) and (q<2^(i0-1))
				and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
				and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
				Add(mout,ker[j0+q]);
				q:=q+1;
			od;
		else
			while ((j0+q<=Size(ker)) and (q<2^(i0-1)) and (q<=qlist[Size(qlist)])
				and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
				and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
				Add(mout,ker[j0+q]);
				q:=q+1;
			od;
		fi;

		if q=0 then
			bool:=false;
			ker:=TransposedMat(Permuted(TransposedMat(ker),pcols^(-1)));
			return ker{[1..j0-1]};
		fi;

		Add(qlist,q);

		i0:=i0+1; j0:=j0+q;

		templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
		templist[i0]:=One(GF(2));
		if Position(ker,templist)<>fail then
			j0:=Position(ker,templist);
		fi;

	od;


	LS:=THELMA_INTERNAL_BuildInverseToleranceMatrix(i0);
	q:=0;


	templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
	templist[maxi]:=One(GF(2));

	if i0=maxi and Position(ker,templist)<>fail then
		j0:=Position(ker,templist);
	fi;

	if (bool<>false) then
		while (j0+q<=Size(ker) and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
		and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
			Add(mout,ker[j0+q]);
			q:=q+1;
		od;
	fi;

	mout:=TransposedMat(Permuted(TransposedMat(mout),pcols^(-1)));
	return mout;
end);

#############################################################
BindGlobal("THELMA_INTERNAL_FormNList",function(ker,rker)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Output: a matrix over GF(2) on which the maximal p(A) matrix is acheived.
	local t, i, maxi, maxs,sc;

	maxi:=1; maxs:=THELMA_INTERNAL_FindMaxSet(rker[1]);

		for i in [1..Size(rker)] do
			t:=THELMA_INTERNAL_FindMaxSet(rker[i]);
			if Size(t)>Size(maxs) then
				maxs:=t; maxi:=i;
			fi;
		od;

	sc:=ShallowCopy(maxs);
	for i in [1..Size(sc)] do sc[i]:=sc[i]+ker[maxi]; od;
	return sc;
end);

######################################################################
##
#F  FindThresholdNetwork(f)
##
##  Returns the Neural Network realizing the given Boolean function
##
##

InstallMethod(BooleanFunctionByNeuralNetwork, "f", true, [IsObject], 1,
function(f)
	local irste, bool,kkk,rker,ker,k, onezero, i, m, kdif,nl, output, temp, reverz ;

  if (IsLogicFunction(f)=false) then
    Error("f has to be a logic function.");
  fi;

  if (f!.dimension<>2) then
    Error("f has to be a Boolean function.");
  fi;

	irste:=BooleanFunctionBySTE(f);
	if irste<>[] then
		return NeuralNetwork([irste],fail);
	fi;

	m:=[];
	k:=KernelOfBooleanFunction(f);

	ker:=k[1];
	onezero:=k[2];
	rker:=ReducedKernelOfBooleanFunction(ker);
	nl:=THELMA_INTERNAL_FormNList(ker,rker);

	Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1));
	kdif:=Difference(ker,nl);

	bool:=false;


	while kdif<>[] do
		rker:=ReducedKernelOfBooleanFunction(kdif);

		nl:=THELMA_INTERNAL_FormNList(kdif,rker);

		if Intersection(kdif,nl)<>[] then Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1)); fi;
		kdif:=Difference(kdif,nl);
	od;

	output:=[];

 for i in m do
  if onezero=1 then
    temp:=BooleanFunctionBySTE(i);
  else
    temp:=BooleanFunctionBySTE(List(i,j->j+One(GF(2))));
  fi;
  Add(output,temp);
  od;

	if onezero=1 then
		return NeuralNetwork(output,true);
	else
		return NeuralNetwork(output,false);
	fi;

end);

InstallOtherMethod(BooleanFunctionByNeuralNetwork, "f", true, [IsFFECollection], 1,
function(f)
	local irste, bool,kkk,rker,ker,k, onezero, i, m, kdif,nl, output, temp, reverz ;

	irste:=BooleanFunctionBySTE(f);
	if irste<>[] then
		return NeuralNetwork([irste],fail);
	fi;

	m:=[];
	k:=KernelOfBooleanFunction(f);

	ker:=k[1];
	onezero:=k[2];
	rker:=ReducedKernelOfBooleanFunction(ker);
	nl:=THELMA_INTERNAL_FormNList(ker,rker);

	Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1));
	kdif:=Difference(ker,nl);

	bool:=false;


	while kdif<>[] do
		rker:=ReducedKernelOfBooleanFunction(kdif);

		nl:=THELMA_INTERNAL_FormNList(kdif,rker);

		if Intersection(kdif,nl)<>[] then Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1)); fi;
		kdif:=Difference(kdif,nl);
	od;

	output:=[];

 for i in m do
  if onezero=1 then
    temp:=BooleanFunctionBySTE(i);
  else
    temp:=BooleanFunctionBySTE(List(i,j->j+One(GF(2))));
  fi;
  Add(output,temp);
od;

	if onezero=1 then
		return NeuralNetwork(output,true);
	else
		return NeuralNetwork(output,false);
	fi;

end);


#f-polynomial
InstallOtherMethod(BooleanFunctionByNeuralNetwork, "f", true, [IsPolynomial], 1,
function(f)
	local irste, bool,kkk,rker,ker,k, onezero, i, m, kdif,nl, output, temp, reverz, j ;

	k:=KernelOfBooleanFunction(f);

	irste:=BooleanFunctionBySTE(k[1],k[2]);
	if irste<>[] then
		return NeuralNetwork([irste],fail);
	fi;

	m:=[];

	ker:=k[1];
	onezero:=k[2];
	rker:=ReducedKernelOfBooleanFunction(ker);
	nl:=THELMA_INTERNAL_FormNList(ker,rker);

	Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1));
	kdif:=Difference(ker,nl);

	bool:=false;

	while kdif<>[] do
		rker:=ReducedKernelOfBooleanFunction(kdif);

		nl:=THELMA_INTERNAL_FormNList(kdif,rker);

		if Intersection(kdif,nl)<>[] then Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1)); fi;
		kdif:=Difference(kdif,nl);
	od;

	output:=[];

	for i in m do
    if onezero=1 then
      temp:=BooleanFunctionBySTE(i);
    else
      temp:=BooleanFunctionBySTE(List(i,j->j+One(GF(2))));
    fi;

		Add(output,temp);
	od;

	if onezero=1 then
		return NeuralNetwork(output,true);
	else
		return NeuralNetwork(output,false);
	fi;

end);

#f - string

InstallOtherMethod(BooleanFunctionByNeuralNetwork, "f", true, [IsString], 1,
function(f)
	local irste, bool,kkk,rker,ker,k, onezero, i, m, kdif,nl, output, temp, reverz, n, st, outer ;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	irste:=BooleanFunctionBySTE(f);
	if irste<>[] then
		return NeuralNetwork([irste],fail);
	fi;

	m:=[];
	k:=KernelOfBooleanFunction(f);

	ker:=k[1];
	onezero:=k[2];
	rker:=ReducedKernelOfBooleanFunction(ker);
	nl:=THELMA_INTERNAL_FormNList(ker,rker);

	Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1));
	kdif:=Difference(ker,nl);

	bool:=false;

	while kdif<>[] do
		rker:=ReducedKernelOfBooleanFunction(kdif);

		nl:=THELMA_INTERNAL_FormNList(kdif,rker);

		if Intersection(kdif,nl)<>[] then Add(m,THELMA_INTERNAL_FindFunctionFromKernel(nl,1)); fi;
		kdif:=Difference(kdif,nl);
	od;

	output:=[];

	if onezero = 1 then
		for i in m do
			temp:=BooleanFunctionBySTE(i);
			Add(output,temp);
		od;
		outer:=true;
	else
		for i in m do
			temp:=BooleanFunctionBySTE(i);
			st:=StructureOfThresholdElement(temp);
			st[1]:=-st[1];
			st[2]:=-st[2]+1;
			temp:=ThresholdElement(st[1],st[2]);
			Add(output,temp);
		od;
		outer:=false;
	fi;

	return NeuralNetwork(output,outer);
end);

############################################################################
##
#M Methods for the comparison operations for neural networks.
##
InstallMethod( \=,
        "for two neural networks",
        [ IsNeuralNetworkObj and IsNeuralNetworkRep,
          IsNeuralNetworkObj and IsNeuralNetworkRep,  ],
        0,
        function( x, y )
    return(x!.func = y!.func);

end );


InstallMethod( \<,
        "for two neural networks",
        #    IsIdenticalObj,
        [ IsNeuralNetworkObj and IsNeuralNetworkRep,
          IsNeuralNetworkObj and IsNeuralNetworkRep,  ],
        0,
        function( x, y )
    return(x!.func < y!.func);
end );


#############################################################################
##
#F  BooleanFunctionByNeuralNetworkDASG(f)
##
## f - vector over GF(2)
InstallMethod(BooleanFunctionByNeuralNetworkDASG, "function", true, [IsObject], 1,
function(f)
	local n;
  if (IsLogicFunction(f)=false) then
    Error("f has to be a logic function.");
  fi;

  if (f!.dimension<>2) then
    Error("f has to be a Boolean function.");
  fi;

	return THELMA_INTERNAL_BooleanFunctionByNeuralNetworkDASG(THELMA_INTERNAL_BFtoGF(f));
end);

InstallOtherMethod(BooleanFunctionByNeuralNetworkDASG, "function", true, [IsFFECollection], 1,
function(f)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_BooleanFunctionByNeuralNetworkDASG(f);
end);

#f - string
InstallOtherMethod(BooleanFunctionByNeuralNetworkDASG, "function", true, [IsString], 1,
function(f)
local i,f1,n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;
  f1:=[];
  for i in [1..Size(f)] do
    if f[i]='1' then Add(f1, Z(2)^0);
    elif f[i]='0' then Add(f1, 0*Z(2));
    fi;
  od;

	return THELMA_INTERNAL_BooleanFunctionByNeuralNetworkDASG(f1);
end);

#f - polynomial
InstallOtherMethod(BooleanFunctionByNeuralNetworkDASG, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_BooleanFunctionByNeuralNetworkDASG(f1);
end);


#E
##
