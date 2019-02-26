#############################################################################
##
#W  boolfunc_def.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: boolfunc_def.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some generic methods for Boolean functions,
##	represented as vectors over GF(2).
##
#############################################################################
##

DeclareRepresentation("IsLogicFunctionRep", IsComponentObjectRep, ["variables","dimensions","truth_vector","field"]);

######################################################################
##
#F  LogicFunction(Variables, Dimensions, Truth_Vector)
##
##  Produces a logic function
##  Variables - number o variables, Dimensions - dimension vector.
##
InstallMethod( LogicFunction, "Variables, Dimensions, Truth_Vector", true, [IsPosInt,IsDenseList,IsDenseList],3,
function(vars, dims, vals)

    local LF,bfunc,F,i;

	if Size(dims)<>vars+1 then
    Error("Dimension vector must be of size ",vars+1);
	fi;

	if Size(dims)<>Size(Filtered(dims,i->IsPosInt(i)=true)) then
     Error("Dimension vector must be a list of integers.");
	fi;

	if Size(dims)<>Size(Filtered(dims,i->i>1)) then
     Error("Elements of the dimension vector must be bigger than 1.");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->i>=0)) then
     Error("Elements of the truth vector can't be negative numbers.");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->IsInt(i)=true)) then
     Error("Truth vector must be a list of integers.");
	fi;

	if Size(vals)<>Product(dims{[1..Size(dims)-1]}) then
     Error("Truth vector has be of the size ",Product(dims{[1..Size(dims)-1]}),".");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->i<dims[Size(dims)])) then
     Error("Elements of the truth vector can't be bigger than ",dims[Size(dims)]-1,".");
	fi;

	# Construct the family of all logic functions.
  F:= NewFamily( "Logic Function" , IsLogicFunctionObj );

  bfunc := rec(numvars := vars,
             dimension := dims,
             output:= vals,
             );

  LF := Objectify( NewType( F, IsLogicFunctionObj and IsLogicFunctionRep and IsAttributeStoringRep ),
                 bfunc );

  # Return the logic function.
  return LF;
end);

InstallOtherMethod( LogicFunction, "Variables, Dimension, Truth_Vector", true, [IsPosInt,IsPosInt,IsDenseList],3,
function(vars, dims, vals)

    local LF,bfunc,F,i,l;

	if dims<=1 then
     Error("Dimension must not less than 2.");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->i>=0)) then
     Error("Elements of the truth vector can't be negative numbers.");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->IsInt(i)=true)) then
     Error("Truth vector must be a list of integers.");
	fi;

	if Size(vals)<>dims^vars then
     Error("Truth vector has be of the size ",dims^vars,".");
	fi;

	if Size(vals)<>Size(Filtered(vals,i->i<dims)) then
     Error("Elements of the truth vector can't be bigger than ",dims[Size(dims)]-1,".");
	fi;

	# Construct the family of all logic functions.
  F:= NewFamily( "Logic Function" , IsLogicFunctionObj );

	bfunc := rec(numvars := vars,
             dimension := dims,
             output:= vals,
             );

  LF := Objectify( NewType( F, IsLogicFunctionObj and IsLogicFunctionRep and IsAttributeStoringRep ),
                 bfunc );

  # Return the logic function.
  return LF;
end);

#############################################################################
##
#M  ViewObj( <A> ) . . . . . . . . . . . print logic function
##
InstallMethod( ViewObj,
        "displays a logic function",
        true,
        [IsLogicFunctionObj and IsLogicFunctionRep], 0,
        function( A )
		local k;
		if IsInt(A!.dimension) then
			k:=A!.dimension;
			if k=2 then
				Print("< Boolean function of ", A!.numvars, " variables >");
			else
				Print("< ",k,"-valued logic function of ", A!.numvars, " variables >");
			fi;
		else
			Print("< logic function of ", A!.numvars, " variables and dimension vector ", A!.dimension,">");
		fi;

end);


#############################################################################
##
#M  PrintObj( <A> ) . . . . . . . . . . . print logic function
##
InstallMethod( PrintObj,
        "displays a logic function",
        true,
        [IsLogicFunctionObj and IsLogicFunctionRep], 0,
        function( A )
    Print("[",A!.numvars,", ",A!.dimension,",",A!.output,"]");
end);

#############################################################################
##
#M  Display( <A> ) . . . . . . . . . . . print threshold element
##
InstallMethod( Display,
       "displays a logic function",
        true,
        [IsLogicFunctionObj and IsLogicFunctionRep], 0,
        function( A )
		local i,t,ff,k,tup,it,i1,temp,kk,t1;


		if IsInt(A!.dimension) then
			if A!.dimension=2 then Print("Boolean function of ",A!.numvars," variables.\n");
			else Print(A!.dimension,"-valued logic function of ",A!.numvars," variables.\n"); fi;
			t:=IteratorOfTuples([0..A!.dimension-1],A!.numvars);
			k:=1;
			for i in t do
				Print(i," || ",A!.output[k],"\n");
				k:=k+1;
			od;
		else
			tup:=[]; it:=true;
			kk:=ShallowCopy(A!.dimension{[1..Size(A!.dimension)-1]});

	    for i in kk do
	      if it=true then for i1 in [0..i-1] do Add(tup,[i1]); od; it:=false;
	      else
	        temp:=[];
	        for t in tup do
	          for i1 in [0..i-1] do
	            t1:=ShallowCopy(t); Add(t1,i1); Add(temp,t1);
	          od;
	        od;
	        tup:=ShallowCopy(temp);
	      fi;
	    od;
			k:=1;
			for i in tup do
				Print(i," || ",A!.output[k],"\n");
				k:=k+1;
			od;
		fi;

end);

#############################################################################
##
#F  IsLogicFunction(A)
##
##  Tests if A is a logic function
##
InstallGlobalFunction( IsLogicFunction, function(A)
    return(IsLogicFunctionObj(A));
end);

############################################################################
##
#M Methods for the comparison operations for logic functions.
##
InstallMethod( \=,
        "for two logic functions",
        [ IsLogicFunctionObj and IsLogicFunctionRep,
          IsLogicFunctionObj and IsLogicFunctionRep,  ],
        0,
        function( x, y )
    return(x!.output = y!.output);

end );


InstallMethod( \<,
        "for two logic functions",
        [ IsLogicFunctionObj and IsLogicFunctionRep,
          IsLogicFunctionObj and IsLogicFunctionRep,  ],
        0,
        function( x, y )
          if (Size(x!.output)<>Size(y!.output)) then
            return fail;
          else
            return(x!.output < y!.output);
          fi;

end );


#############################################################################
##
#F  PolynomialToBooleanFunction(pol,n)
##
##  Given a polynomial over GF(2) and the number of the input variables, this
##  function returns logic function object.
##
##
InstallGlobalFunction(PolynomialToBooleanFunction, function(pol,n)
    local i,w,t;
    if not(IsPosInt(n)) then
      Error("n has to be a positive integer.");
    fi;
    if not(IsPolynomial(pol)) then
      Error("Firest argument has to be a polynomial.");
    fi;
    return LogicFunction(n,2,THELMA_INTERNAL_PolToOneZero(pol,n));
end);

######################################################################
##
#F  CharacteristicVectorOfFunction(f)
##
##  Returns the charateristic vector of Boolean function.
##
InstallMethod(CharacteristicVectorOfFunction, "f", true, [IsObject], 1,
function(f1)
	local t, n, f, i, l, m,m2;

	if (IsLogicFunction(f1)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f1!.numvars;

	if (f1!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	t:=Tuples([0,1],n);
	t:=TransposedMat(t);
	f:=f1!.output;
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);

InstallOtherMethod(CharacteristicVectorOfFunction, "f", true, [IsFFECollection], 1,
function(f)
	local t, n, f1, i, l, m,m2;

	n:=Size(f);

	if not IsFFECollection(f) then
	    Error("Function should be presented as a vector over GF(2)");
	fi;

	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=Tuples([0,1],LogInt(Size(f),2));
	t:=TransposedMat(t);
	f:=List(f,Order);
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);

InstallOtherMethod(CharacteristicVectorOfFunction, "f", true, [IsPolynomial], 1,
function(f)
	local t, n, f1, i, l, m,m2, var, k;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");

	t:=IteratorOfTuples(GF(2),n);
	f1:=[];
	for i in t do
		Add(f1,Order(Value(f,var,i)));
	od;


	t:=Tuples([0,1],n);
	t:=TransposedMat(t);
	f:=f1;
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);


InstallOtherMethod(CharacteristicVectorOfFunction, "f", true, [IsString], 1,
function(f)
	local t, n, f1, i, l, m,m2, var, k;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	f1:=[];
	k:=1;
	for i in [1..Size(f)] do
		if f[k]='1' then Add(f1,1); else Add(f1,0); fi;
		k:=k+1;
	od;

	t:=Tuples([0,1],n);
	t:=TransposedMat(t);

	f:=f1;
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);

## Check if given vector is a ch.vect. of realizable function
InstallMethod(IsCharacteristicVectorOfSTE, "check if function is realizable for n<=6", true, [IsVector], 1,
function(v)
	if Size(v)>7 then
		Error("Enter characteristic vectors for n<=6 variables.\n");
	else
		return (v in THELMA_INTERNAL_CharVectSet);
	fi;
end);

######################################################################
##
#F  KernelOfBooleanFunction(f)
##
##  Returns the kernel of Boolean function.
##
InstallMethod(KernelOfBooleanFunction, "f", true, [IsObject], 1,
function(lf)

	local t,f1,f0,i,n,k,f;

	if (IsLogicFunction(lf)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=lf!.numvars;

	if (lf!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f:=THELMA_INTERNAL_BFtoGF(lf);

	t:=IteratorOfTuples(GF(2),LogInt(Size(f),2));
	f1:=[]; f0:=[];
	k:=1;
	for i in t do
		if f[k]=One(GF(2)) then Add(f1,i); else Add(f0,i); fi;
		k:=k+1;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);


InstallOtherMethod(KernelOfBooleanFunction, "f", true, [IsFFECollection], 1,
function(f)

	local t,f1,f0,i,n,k;

	n:=Size(f);
	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(Size(f),2));
	f1:=[]; f0:=[];
	k:=1;
	for i in t do
		if f[k]=One(GF(2)) then Add(f1,i); else Add(f0,i); fi;
		k:=k+1;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);


#f-polynomial
InstallOtherMethod(KernelOfBooleanFunction, "f", true, [IsPolynomial], 1,
function(f)

	local t,f1,f0,i,n,var,v,k;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables n (n>=",Size(var),"):\n");
	t:=IteratorOfTuples(GF(2),n);

	if Size(var)<n then
		k:=Size(var)+1;
		var:=ShallowCopy(var);
		for i in [k..n] do Add(var,k); od;
	fi;

	t:=IteratorOfTuples(GF(2),n);

	f1:=[]; f0:=[];
	for i in t do
		v:=Value(f,var,i);
		if v=One(GF(2)) then Add(f1,i); else Add(f0,i); fi;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);

#f is a string
InstallOtherMethod(KernelOfBooleanFunction, "f", true, [IsString], 1,
function(f)

	local t,f1,f0,i,n,k;

	n:=Size(f);
	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(Size(f),2));
	f1:=[]; f0:=[];
	k:=1;
	for i in t do
		if f[k]='1' then Add(f1,i); else Add(f0,i); fi;
		k:=k+1;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);

######################################################################
##
#F  ReducedKernelOfBooleanFunction(k)
##
##  Given the kernel of Boolean function, returns the reduced kernel.
##
InstallGlobalFunction(ReducedKernelOfBooleanFunction, function(k)
	local i,j,l,rk;

	if not IsFFECollColl(k) then
	    Error("Kernel should be presented as a matrix over GF(2)");
	fi;

	rk:=[];
	for i in k do
		l:=[];
		for j in k do
			Add(l,i+j);
		od;
		Add(rk,l);
	od;
	return rk;
end);



######################################################################
##
#F  IsInverseInKernel(k)
##
##  This function checks if there are any inverse vectors in the kernel.
##	If yes - the given function can't be implemented by a single
##  threshold element.
##
##
# f - vector over GF(2)
InstallMethod(IsInverseInKernel, "f", true, [IsObject],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "f", true, [IsFFECollection],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "f", true, [IsPolynomial],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "f", true, [IsString],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "kernel", true, [IsFFECollColl],1,
function(ker)
	local i, j, inv, bool;

	bool:=false;
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

######################################################################
##
#F  IsKernelContainingPrecedingVectors(k)
##
##  This function checks if there the kernel contains the preceding vectors
##	for all vectors in the kernel. If no - the given function can't be implemented by a single
##  threshold element.
##
##
InstallMethod(IsKernelContainingPrecedingVectors, "f", true, [IsObject],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "f", true, [IsFFECollection],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "f", true, [IsString],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "f", true, [IsPolynomial],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "ker", true, [IsFFECollColl],1,
function(ker)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(ker);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

#############################################################################
##
#F  IsRKernelBiggerOfCombSum(rker)
##  Another neccessary condition
##
InstallMethod(IsRKernelBiggerOfCombSum, "f", true, [IsObject], 1,
function(f)
	local n, sum, i, m, k, j, rker;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "f", true, [IsFFECollection], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "reduced kernel", true, [IsFFECollCollColl], 1,
function(rker)
	local n, sum, i, m, k, j;
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "f", true, [IsString], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "f", true, [IsPolynomial], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);


#############################################################################
##
#F  IsUnateInVariable(f,v)
##
##
##  f - vector over GF(2)

InstallMethod(IsUnateInVariable,"function, integer", true, [IsObject, IsPosInt], 2,
function(f, v)
	local n;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	if v>n then
		Error("No variable with this number.");
	fi;

	return THELMA_INTERNAL_IsUnateInVar(THELMA_INTERNAL_BFtoGF(f),v);
end);

InstallOtherMethod(IsUnateInVariable,"function, integer", true, [IsFFECollection, IsPosInt], 2,
function(f, v)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_IsUnateInVar(f,v);
end);


#f - string
InstallOtherMethod(IsUnateInVariable, "function", true, [IsString,IsPosInt], 1,
function(f,v)
local n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	return THELMA_INTERNAL_IsUnateInVar(f,v);
end);

#f - polynomial
InstallOtherMethod(IsUnateInVariable, "function", true, [IsPolynomial,IsPosInt], 1,
function(f,v)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToOneZero(f,n);
	return THELMA_INTERNAL_IsUnateInVar(f1,v);
end);

#############################################################################
##
#F  IsUnateBooleanFunction(f)
##  Another neccessary condition
##
## f - vector over GF(2)
InstallMethod(IsUnateBooleanFunction, "function", true, [IsObject], 1,
function(f)
	local n;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	return THELMA_INTERNAL_IsUnateBFunc(THELMA_INTERNAL_BFtoGF(f));
end);

InstallOtherMethod(IsUnateBooleanFunction, "function", true, [IsFFECollection], 1,
function(f)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_IsUnateBFunc(f);
end);

#f - string
InstallOtherMethod(IsUnateBooleanFunction, "function", true, [IsString], 1,
function(f)
local n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	return THELMA_INTERNAL_IsUnateBFunc(f);
end);

#f - polynomial
InstallOtherMethod(IsUnateBooleanFunction, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToOneZero(f,n);
	return THELMA_INTERNAL_IsUnateBFunc(f1);
end);



#############################################################################
##
#F  SelfDualExtensionOfBooleanFunction(f)
##
## f - vector over GF(2)
InstallMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsObject], 1,
function(f)
	local n;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	return LogicFunction(n+1,2,List(THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(THELMA_INTERNAL_BFtoGF(f)),Order));
end);

InstallOtherMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsFFECollection], 1,
function(f)
	local n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return LogicFunction(n+1,2,List(THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f),Order));
end);

#f - string
InstallOtherMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsString], 1,
function(f)
local n,f1,i;

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


	return LogicFunction(n+1,2,List(THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f1),Order));
end);

#f - polynomial
InstallOtherMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return LogicFunction(n+1,2,List(THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f1),Order));
end);


#############################################################################
##
#F  InfluenceOfVariable(f)
##
## f - vector over GF(2)
InstallMethod(InfluenceOfVariable, "function, var", true, [IsObject, IsPosInt], 2,
function(f,v)
	local n;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	if (v>n) then
		Error("There is no variable with this number.");
	fi;

	return THELMA_INTERNAL_InfluenceOfVariable(THELMA_INTERNAL_BFtoGF(f),v);
end);

InstallOtherMethod(InfluenceOfVariable, "function, var", true, [IsFFECollection, IsPosInt], 2,
function(f,v)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_InfluenceOfVariable(f,v);
end);

#f - string
InstallOtherMethod(InfluenceOfVariable, "function, var", true, [IsString, IsPosInt], 2,
function(f, v)
local i, n, f1;

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


	return THELMA_INTERNAL_InfluenceOfVariable(f1,v);
end);

#f - polynomial
InstallOtherMethod(InfluenceOfVariable, "function, var", true, [IsPolynomial, IsPosInt], 2,
function(f, v)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_InfluenceOfVariable(f1,v);
end);

#############################################################################
##
#F  SplitBooleanFunction(f,v,b)
##
## f - vector over GF(2)
InstallMethod(SplitBooleanFunction, "function, var, bool", true, [IsObject, IsPosInt, IsBool], 3,
function(f,v,b)
	local n,temp;
	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

  if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	if (v>n) then
		Error("No variable with such number.");
	fi;

	temp:=THELMA_INTERNAL_SplitBooleanFunction(THELMA_INTERNAL_BFtoGF(f),v,b);
	return [LogicFunction(n,2,List(temp[1],Order)),LogicFunction(n,2,List(temp[2],Order))];
end);

InstallOtherMethod(SplitBooleanFunction, "function, var, bool", true, [IsFFECollection, IsPosInt, IsBool], 3,
function(f,v,b)
	local n,temp;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	temp:=THELMA_INTERNAL_SplitBooleanFunction(f,v,b);
	return [LogicFunction(n,2,List(temp[1],Order)),LogicFunction(n,2,List(temp[2],Order))];

end);

#f - string
InstallOtherMethod(SplitBooleanFunction, "function, var, bool", true, [IsString, IsPosInt, IsBool], 3,
function(f,v,b)
local i, n, f1, temp;

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
		temp:=THELMA_INTERNAL_SplitBooleanFunction(f,v,b);
		return [LogicFunction(n,2,List(temp[1],Order)),LogicFunction(n,2,List(temp[2],Order))];
end);

#f - polynomial
InstallOtherMethod(SplitBooleanFunction, "function, var, bool", true, [IsPolynomial, IsPosInt, IsBool], 3,
function(f, v, b)
local f1,var,n,temp;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	temp:=THELMA_INTERNAL_SplitBooleanFunction(f1,v,b);
	return [LogicFunction(n,2,List(temp[1],Order)),LogicFunction(n,2,List(temp[2],Order))];
end);


#E
##
