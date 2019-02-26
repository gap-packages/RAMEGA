##############################################################
BindGlobal("THELMA_INTERNAL_BFtoGF",function(lf)
# Arguments: lf - boolean function;
# Output: truth vector over GF(2).
	local i;
	if (lf!.dimension <> 2) then
		Error("Logic function has to be a Boolean Function.");
	else
		return List(lf!.output,i->Elements(GF(2))[i+1]);
	fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_BuildToleranceMatrix",function(n)
# Arguments: n - number of variables, for which we build the matrix;
# Output: a tolerance matrix of n variables.
local t,l,i, k;
	t:=IteratorOfTuples(GF(2),n);
	l:=[]; k:=1;
	for i in t do
		Add(l,Reversed(i));
		k:=k+1;
		if k=2^(n-1)+1 then break; fi;
	od;
	return l;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_BuildInverseToleranceMatrix",function(n)
# Arguments: n - number of variables, for which we build the matrix;
# Output: an inverse tolerance matrix of n variables.
local t,l,i,k,e;
	t:=IteratorOfTuples(GF(2),n);
	e:=ListWithIdenticalEntries(n,One(GF(2)));
	l:=[]; k:=1;
	for i in t do
		Add(l,Reversed(i)+e);
		k:=k+1;
		if k=2^(n-1)+1 then break; fi;
	od;
	return Reversed(l);
end);

##############################################################
BindGlobal("THELMA_INTERNAL_PolToOneZero",function(p,n)
# Arguments: a polynimal p over GF(2) and the nuber of variables n
# Output: truth vector of the Boolean function f
	local i, v, k, t, f;

	v:=OccuringVariableIndices(p);
	if Size(v)<n then
		k:=Size(v)+1;
		v:=ShallowCopy(v);
		for i in [k..n] do Add(v,k); od;
	fi;
	t:=IteratorOfTuples(GF(2),n);

	f:=[];
	for i in t do
		Add(f,Order(Value(p,v,i)));
	od;
	return f;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_PolToGF2",function(p,n)
# Arguments: a polynimal p over GF(2) and the nuber of variables n
# Output: truth vector of the Boolean function f over GF(2)
	local i, v, k, t, f;

	v:=OccuringVariableIndices(p);
	if Size(v)<n then
		k:=Size(v)+1;
		v:=ShallowCopy(v);
		for i in [k..n] do Add(v,k); od;
	fi;
	t:=IteratorOfTuples(GF(2),n);

	f:=[];
	for i in t do
		Add(f,Value(p,v,i));
	od;
	return f;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_ThrTr",function(l,T,step,f,n)
# Arguments: l - initial weight vector (a list); T - initial threshold;
#	Arguments: step - positive integer, on which we increment weights and threshold if needed;
#	Arguments: f - truth vector of the Boolean function, a list of 0 and 1;
#	Arguments: n - the maximal number of iterations. By default = 1000;
# Output: threshold element, which realizes f or [] if f is not realizable.
local t, j, err, y, i, tup;
	t:=IteratorOfTuples([0,1], LogInt(Size(f),2));

	j:=0;
	repeat
		t:=IteratorOfTuples([0,1], Size(l));
		y:=[];
		j:=j+1;
		err:=0;
		i:=1;
		for tup in t do
			if l*tup>=T then Add(y,1); else Add(y,0); fi;
			if y[i]<>f[i] then
				T:=T-step*(f[i]-y[i]);
				l:=l+step*(f[i]-y[i])*tup;

				err:=err+AbsInt(f[i]-y[i]);
			fi;
			i:=i+1;
		od;
	until (err<=0) or (j=n);

	if y=f then return ThresholdElement(l,T); else return []; fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_ThrBatchTr",function(l,T,step,f,n)
# Arguments: l - initial weight vector (a list); T - initial threshold;
#	Arguments: step - positive integer, on which we increment weights and threshold if needed;
#	Arguments: f - truth vector of the Boolean function, a list of 0 and 1;
#	Arguments: n - the maximal number of iterations. By default = 1000;
# Output: threshold element, which realizes f or [] if f is not realizable.
local t, j, err, y, i, tup, wc, Tc;
	j:=0;
	repeat
		t:=IteratorOfTuples([0,1], LogInt(Size(f),2));

		y:=[]; wc:=[]; Tc:=0;
		j:=j+1;
		err:=0;
		for i in [1..LogInt(Size(f),2)] do Add(wc,0); od;
		Tc:=0;

		i:=1;
		for tup in t do
			if l*tup>=T then Add(y,1); else Add(y,0); fi;
			if y[i]<>f[i] then
				Tc:=Tc-step*(f[i]-y[i]);
				wc:=wc+step*(f[i]-y[i])*tup;
				err:=err+AbsInt(f[i]-y[i]);
			fi;
			i:=i+1;
		od;

		T:=T+Tc;
		l:=l+wc;
	until (err<=0) or (j=1000);

	if y=f then return ThresholdElement(l,T); else return []; fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_Winnow",function(f,step,niter)
# Arguments: f - truth vector of the Boolean function, a list of 0 and 1;
#	Arguments: step - positive integer, on which we increment weights if needed;
#	Arguments: niter - the maximal number of iterations. By default = 1000;
# Output: threshold element, which realizes f or [] if f is not trainable by Winnow.
local k, w,T,t, j, n, err, y, i, tup, xx;
	n:=LogInt(Size(f),2);
	w:=ListWithIdenticalEntries(n,1);
	T:=n/2;

	k:=1;
	repeat
		t:=IteratorOfTuples([0,1], LogInt(Size(f),2));


		y:=[];
		i:=1;

		for tup in t do
			if w*tup>=T then
			    Add(y,1);
				if f[i]=0 then
					for j in [1..Size(tup)] do
						if tup[j]=1 then w[j]:=0; fi;
					od;
				fi;
			else
				Add(y,0);
				if f[i]=1 then
					for j in [1..Size(tup)] do
						if tup[j]=1 then w[j]:=step*w[j]; fi;
					od;
				fi;
			fi;
			i:=i+1;
		od;

		err:=Sum(List(f-y,AbsInt));
		k:=k+1;
	until (err=0) or (k=niter);

	if y=f then return ThresholdElement(w,T); else return []; fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_Winnow2",function(f,step,niter)
# Arguments: f - truth vector of the Boolean function, a list of 0 and 1;
#	Arguments: step - positive integer, on which we increment weights if needed;
#	Arguments: niter - the maximal number of iterations. By default = 1000;
# Output: threshold element, which realizes f or [] if f is not trainable by Winnow2.
local k, w,T,t, j, n, err, y, i, tup, xx;
	n:=LogInt(Size(f),2);
	w:=ListWithIdenticalEntries(n,1);
	T:=n/2;

	k:=1;
	repeat
		t:=IteratorOfTuples([0,1], LogInt(Size(f),2));


		y:=[];
		i:=1;

		for tup in t do
			if w*tup>=T then
			    Add(y,1);
				if f[i]=0 then
					for j in [1..Size(tup)] do
						if tup[j]=1 then w[j]:=w[j]/step; fi;
					od;
				fi;
			else
				Add(y,0);
				if f[i]=1 then
					for j in [1..Size(tup)] do
						if tup[j]=1 then w[j]:=step*w[j]; fi;
					od;
				fi;
			fi;
			i:=i+1;
		od;

		err:=Sum(List(f-y,AbsInt));
		k:=k+1;
	until (err=0) or (k=niter);

	if y=f then return ThresholdElement(w,T); else return []; fi;
end);


##############################################################
BindGlobal("THELMA_INTERNAL_IsUnateInVar",function(f,v)
# Arguments: f - truth vector of the Boolean function, a list (or string);
# Arguments: v - number of variable, a positive integer;
# Output: "true" if f is unate in v, and "false" otherwise.
local n, t, k, un, up, i, j;

n:=LogInt(Size(f),2);
if v>n then
	Error("Number of variable should be less than ",n,".\n");
fi;

if v<1 then
	Error("Number of variable should a positive number.\n");
fi;

	up:=true; un:=true;

	k:=n-v;
	i:=1;

	j:=1;
	while (i+2^k<2^n+1) do

		if f[i]>f[i+2^k] then up:=false; fi;
		if f[i]<f[i+2^k] then un:=false; fi;

		if j=2^k then
			i:=i+2^k+1; j:=1;
		else
			i:=i+1; j:=j+1;
		fi;

	od;

	if ((up or un) = false) then return false; fi;
return true;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_IsUnateBFunc",function(f)
# Arguments: f - truth vector of the Boolean function, a list (or string);
# Output: "true" if f is unate, and "false" otherwise.
local n, t, k, un, up, i, j;

  t:=0;

  n:=LogInt(Size(f),2);

  while (t<=n-1) do
    up:=true; un:=true;
    k:=n-1-t;
    i:=1;  j:=1;
    while (i+2^k<2^n+1) do

      if f[i]>f[i+2^k] then up:=false; fi;
      if f[i]<f[i+2^k] then un:=false; fi;

      if j=2^k then
        i:=i+2^k+1; j:=1;
      else
        i:=i+1; j:=j+1;
      fi;

    od;

    if ((up or un) = false) then return false; fi;
    t:=t+1;
  od;
  return true;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_SortCols",function(mat)
# Arguments: mat - matrix over GF(2);
# Output: A permutation, that sorts the columns according the decrease of the number of Z(2)^0 elements.
  local t, i,p,l;
	l:=TransposedMat(mat);
	t:=List(l,i-> -Size(Filtered(i, j->j=One(GF(2)))));
	p:=SortingPerm(t);
	return p;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_SortRows",function(mat)
# Arguments: mat - matrix over GF(2);
# Output: A permutation, that sorts the rows according to the increase of the decimal values of
# the reversed rows.
	local i,p;
	p:=SortingPerm(List(mat,i->NumberFFVector(Reversed(i),2)));
	return p;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_PIndex",function(mat)
# Arguments: mat - matrix over GF(2);
# Output: A list containing positions of columns, which don't have corresponding unitary vector.
	local row, ind1, ind2, pos;
#	Print("PIndex \n");
#	Display(mat);

	ind1:=[]; ind2:=[];

	for row in mat do
		pos:=Positions(row,One(GF(2)));
		if Size(pos)>1 then ind1:=Union(ind1,pos);
		elif Size(pos)=1 then ind2:=Union(ind2,pos);
		fi;
	od;

	return Difference(ind1,ind2);
end);



BindGlobal("THELMA_INTERNAL_QMat",function(n)
    local mat, i, k;

    mat:=[];

    for i in [1..2^n] do
      Add(mat,ListWithIdenticalEntries(2^n,0));
    od;

#    Display(mat);

    k:=1;
    i:=1;

    for k in Filtered([1..2^n], j-> (j mod 2 = 1) ) do
      mat[i][k]:=1; mat[i][k+1]:=1;
#      Print(i, "  ", k, "\n");
      i:=i+1;
    od;

    for k in Filtered([1..2^n], j-> (j mod 2 = 1) ) do
      mat[i][k]:=1; mat[i][k+1]:=-1;
#      Print(i, "  ", k, "\n");
      i:=i+1;
    od;
    return mat;
end);

BindGlobal("THELMA_INTERNAL_CharG",function(g,l)
  return (-1)^(g*l);
end);

BindGlobal("THELMA_INTERNAL_DecToBin",function(m,n)
  local i, l, k;
  l:=ListWithIdenticalEntries(n,0);
  k:=1;
  while m<>0 do
     l[k]:=m mod 2;
     m:=Int(m/2);
     k:=k+1;
  od;
  return Reversed(l);
end);

##############################################################
BindGlobal("THELMA_INTERNAL_ConvertDecToBin",function(dec,n)
# Arguments: dec - a positive integer decimal number; n - length of the output vector;
# Output: A list containing the binary representation of dec.
	local rem,l,i,lgf, temp;

	temp:=[Zero(GF(2)),One(GF(2))];
	l:=[];
	if dec=0 then l:=[Zero(GF(2))]; else
		while dec>0 do
			rem:=dec mod 2;
			Add(l,temp[rem+1]);
			dec:= Int(dec/2);
		od;
	fi;

	while Size(l)<n do Add(l,Zero(GF(2))); od;

	return Reversed(l);
end);

##############################################################
BindGlobal("THELMA_INTERNAL_VectorToFormula", function(f)
# Arguments: f - a truth vector of some Boolean function, with values from GF(2);
# Output: The Sum of Products or the Product of Sums representation of f.
	local i, n, x, s, t, k, l;

	n:=LogInt(Size(f),2);

	if not IsFFECollection(f) then
	    Error("Function should be presented as a vector over GF(2)");
	fi;

	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	if f=ListWithIdenticalEntries(Size(f),f[1]) then
	return Concatenation("Function = ",String(Order(f[1]))); fi;

	k:=KernelOfBooleanFunction(f);
	l:=[];

	for t in k[1] do
		Add(l,NumberFFVector(t,2));
	od;

	if k[2] = 1 then return Concatenation("Sum of Products:",String(l)); else
	return Concatenation("Product of Sums:",String(l)); fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_FindPrecedingVectors", function(a)
# Arguments: a - a vector over GF(2);
# Output: The set of vectors which precede a.
	local l,temp,i,bool,n,t;
	n:=Size(a);
	t:=Tuples(GF(2),n);
	l:=[];
	for temp in t do
		bool:=true;
		for i in [1..n] do
			if temp[i]>a[i] then
				bool:=false;
				break;
			fi;
		od;
		if bool=true then
			Add(l,temp);
		fi;
	od;
	return l;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_Disjunction", function(a,b)
# Arguments: a,b - a vectors over GF(2);
# Output: vector c, a componentwise disjunction of a and b.
	local i,n,c;
	c:=[];
	n:=Size(a);
	for i in [1..n] do
		Add(c,a[i]+b[i]+a[i]*b[i]);
	od;
	return c;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_Conjunction", function(a,b)
# Arguments: a,b - a vectors over GF(2);
# Output: vector c, a componentwise conjunction of a and b.
	local i,n,c;
	c:=[];
	n:=Size(a);
	for i in [1..n] do
		Add(c,a[i]*b[i]);
	od;
	return c;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_FindFunctionFromKernel", function(ker,onezero)
# Arguments: ker - a matrix over GF(2), onezero - 1 or 0, the value on which the kernel is acheived;
# Output: truth vector of Boolean function.
	local l,i,f;
	l:=List(ker,i->NumberFFVector(i,2));
	f:=[];
	for i in [0..2^Size(ker[1])-1] do
		if i in l then
			Add(f,Z(2)^0);
		else
			Add(f,0*Z(2));
		fi;
	od;

	if onezero=1 then
		return f;
	else
		return List(f,i->i+Z(2)^0);
	fi;
end);


##############################################################
BindGlobal("THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction", function(f)
# Arguments: f - truth vector of Boolean function (a vector over GF(2));
# Output: truth vector of self dual extension of Boolean function.
  local i, output;
  output:=[];

  for i in [1..Size(f)] do
    Add(output,f[i]);
    Add(output, One(GF(2))+f[Size(f)-i+1]);
  od;

  return output;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_InfluenceOfVariable", function(f, v)
# Arguments: f - truth vector of Boolean function (a vector over GF(2));
# Arguments: v - a positive integer, the number of the variable;
# Output: truth vector of self dual extension of Boolean function.
  local n, t, k, i, j, w;

  n:=LogInt(Size(f),2);
  if v>n then
    Error("Number of variable should be less than ",n,".\n");
  fi;

    k:=n-v;
    i:=1;

    j:=1; w:=0;
    while (i+2^k<2^n+1) do

      if f[i]+f[i+2^k]=One(GF(2)) then w:=w+1; fi;

      if j=2^k then
        i:=i+2^k+1; j:=1;
      else
        i:=i+1; j:=j+1;
      fi;

    od;

  return w;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_IsUnateAndInfluenceInVar",function(f,v)
# Arguments: f - truth vector of the Boolean function, a list (or string);
# Arguments: v - number of variable, a positive integer;
# Output: "true" if f is unate in v, and "false" otherwise.
local n, t, k, un, up, i, j, w;

n:=LogInt(Size(f),2);
if v>n then
	Error("Number of variable should be less than ",n,".\n");
fi;

if v<1 then
	Error("Number of variable should a positive number.\n");
fi;

	up:=true; un:=true;

	k:=n-v;
	i:=1;

	j:=1;w:=0;
	while (i+2^k<2^n+1) do

		if f[i]>f[i+2^k] then up:=false; fi;
		if f[i]<f[i+2^k] then un:=false; fi;

    if f[i]+f[i+2^k]=One(GF(2)) then w:=w+1; fi;

		if j=2^k then
			i:=i+2^k+1; j:=1;
		else
			i:=i+1; j:=j+1;
		fi;

	od;

	if ((up or un) = false) then return [false,w]; fi;
return [true,w];
end);


##############################################################
BindGlobal("THELMA_INTERNAL_SplitBooleanFunction", function(f, v, b)
# Arguments: f - truth vector of Boolean function (a vector over GF(2));
# Arguments: v - a positive integer, the number of the variable;
# Arguments: b - a Boolean value. "true" - disjunction, "false" - conjunction;
# Output: a list with two entries - the truth vectors of output functions.
  local n, t, k, i, j, fa, fb, tup, val;

  if b=true then
    val:=Zero(GF(2));
  else
    val:=One(GF(2));
  fi;
  n:=LogInt(Size(f),2);
  if v>n then
    Error("Number of variable should be less than ",n,".\n");
  fi;

  tup:=IteratorOfTuples(GF(2),n);

  fa:=[]; fb:=[];
  j:=1;
  for i in tup do
    if i[v]=Zero(GF(2)) then
        Add(fa,f[NumberFFVector(i,2)+1]);
        Add(fb,val);
    else
        Add(fb,f[NumberFFVector(i,2)+1]);
        Add(fa,val);
    fi;
  od;
  return [fa,fb];
end);

##############################################################
BindGlobal("THELMA_INTERNAL_BooleanFunctionByNeuralNetworkDASG", function(f)
# Arguments: f - truth vector of Boolean function (a vector over GF(2));
# Output: a neural network, implementing this function.
  local n,workset,inner,outer,i, temp, fa, fb, threl, decompose,
        indun, wun, idec, fout, iter, bbb;
  n:=LogInt(Size(f),2);
  if Size(Filtered(f,i->i=One(GF(2))))>Size(Filtered(f,i->i=Zero(GF(2)))) then
    outer:=true;
  else
    outer:=false;
  fi;

  inner:=[];
  workset:=[f];
  iter:=1;

  while workset<>[] do

    temp:=workset[Size(workset)]; Unbind(workset[Size(workset)]);
    decompose:=false;

		threl:=BooleanFunctionBySTE(temp);
    if threl<>[] then Add(inner,threl); else decompose:=true; fi;

    if decompose = true then
      indun:=[]; wun:=[];
      for i in [1..n] do
				if IsUnateInVariable(temp,i)=false then
          Add(indun,i);
          Add(wun,InfluenceOfVariable(temp,i));
        fi;
      od;

      if indun<>[] then
				idec:=indun[PositionMaximum(wun)];
			else
				idec:=Random([1..n]);
			fi;

      fout:=SplitBooleanFunction(temp, idec, outer);

			threl:=BooleanFunctionBySTE(fout[1]);
      if threl<>[] then Add(inner,threl); else Add(workset,THELMA_INTERNAL_BFtoGF(fout[1])); fi;

			threl:=BooleanFunctionBySTE(fout[2]);
      if threl<>[] then Add(inner,threl); else Add(workset,THELMA_INTERNAL_BFtoGF(fout[2])); fi;
    fi;
  od;

	if Size(inner)=1 then outer:=fail; fi;
  return(NeuralNetwork(inner,outer));
end);


##############################################################
BindGlobal("THELMA_INTERNAL_SimplifyVector",function(l)
# Arguments: l - vector of rational numbers;
# Output: a vector of integers.
	local lcmv;
	lcmv:=Lcm(List(l,DenominatorRat));
	l:=lcmv*l;
	if Gcd(l)<>0 then return List(l,i->i/Gcd(l)); else return l; fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_IsLinIndependent",function(m)
# Arguments: m - set of vectors;
# Output: true - if vectors are linearly independent, false - otherwise.
	if Size(m)>Size(m[1]) then
		return false;
	elif RankMat(m)=Size(m) then
		return true;
	else
		return false;
	fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_GetBMultBase",function(f)
# Arguments: truth vector of Boolean function f over GF(2);
# Output: Characteristic vector of f.
	local t,i,l;
	t:=Tuples([-1,1],LogInt(Size(f),2));
	t:=TransposedMat(t);
	l:=[];
	for i in t do
		Add(l,i*f);
	od;
	Add(l,Sum(f));
	return l;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_SignR",function(x)
# Arguments: rational number x;
# Output: sign of x.
	if x>0 then return 1;
	elif x=0 then return 0;
	else return -1;
	fi;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_BuildH",function(c)
# Arguments: weight-threshold vector c;
# Output: function H.
	local t,tt,i,ff,onev,j,x;

	t:=Tuples([-1,1],Size(c)-1);
	t:=TransposedMat(t);
	tt:=ShallowCopy(t);

	onev:=[];
	for j in [1..Size(tt[1])] do Add(onev,1); od;
	Add(tt,onev);
	tt:=TransposedMat(tt);
	ff:=[];
	for i in tt do
		Add(ff,c*i);
	od;
	return List(ff, x->THELMA_INTERNAL_SignR(x));
end);

##############################################################
BindGlobal("THELMA_INTERNAL_STESynthesis",function(g)
# Arguments: truth vector of function g over GF(2);
# Output: threshold element realizing g if it is STE-realizable, [] otherwise.
	local temp,i, j, j11, f, b, c, c1, el, H, h, H1, t, w, realizible, K,K0, SetH, go, err, thr;
	#f-function in base [-1,1]; b-char. vector for f; H=sgn ci*x; h - char. vector for H;
	#t - tuples; w - structure of the threshold element;
	f:=List(g,Order);
	f:=List(f,i->2*i-1);
	b:=THELMA_INTERNAL_GetBMultBase(f);
	SetH:=[];

	i:=1;
	c:=ShallowCopy(b);
	H:=THELMA_INTERNAL_BuildH(c);

	#We have to check that H has no zero elements. If there are some, we change the corresponding coordinate of c.
	while Position(H,0)<>fail do
		temp:=RandomMat(1,Size(c),[0..1]);
		c:=c+temp[1];
		H:=THELMA_INTERNAL_BuildH(c);
	od;

	h:=THELMA_INTERNAL_GetBMultBase(H);
	Add(SetH,h);

	H1:=ShallowCopy(H);
	go:=false;
	realizible:=false;


	err:=false;
	while (H<>f) do
		i:=i+1;
		if i=100 then #Here 100 is maximum number of iterations.
			realizible:=false;
			return [];
			break;
		fi;


		K0:=(c*(h-b))/(((b-h)*(b-h)));
		c1:=c;

		repeat
			go:=false; err:=false;
			repeat
				K:=(3/2)*K0;
				#coef. is arbitrary. one can choose a random number for (1,2), but it's better to choose a number close to 2.
				c1:=c1+K*(b-h);
				H:=THELMA_INTERNAL_BuildH(c1);
			until Position(H,0)=fail;
			c:=c1;

			h:=THELMA_INTERNAL_GetBMultBase(H);
			Add(SetH,h);
			if (Size(Set(SetH))=Size(SetH)) then
				go:=true;
			fi;

			if ((Size(Set(SetH))<Size(SetH)) and THELMA_INTERNAL_IsLinIndependent(Set(b-SetH))=false) then
				err:=true;
			fi;
		until (go or err) = true;
		if err=true then return []; break; fi;
	od;

	if H=f then realizible:=true; fi;

	w:=[];
	if realizible = true then
		for j in [1..(Size(c)-1)] do Add(w,c[j]); od;
		Add(w,(1/2)*(Sum(w)-c[Size(c)]));
	fi;

	if w<>[] then w:=THELMA_INTERNAL_SimplifyVector(w);	fi;
	thr:=w[Size(w)]; Unbind(w[Size(w)]);
	return ThresholdElement(w,thr);
end);

##############################################################
BindGlobal("THELMA_INTERNAL_FSign",function(F,eps,st,q,psi)
# Arguments: F - GF(p^k); eps - PrimitiveElement of F; st - structure vector of
# Arguments: multi-valued neuron; q - order of cyclic group from which neuron takes its output;
# Arguments: psi - input value, some element of F.
# Output: some element of cyclic group of order q.
    local j,deg,u;
    deg:=LogFFE(psi,eps); u:=Size(F)-1;
    for j in [0..q-1] do
      if (deg>=(j*u)/q) and (deg<((j+1)*u)/q) then break; fi;
    od;
    return eps^(u*j/q);
end);

##############################################################
BindGlobal("THELMA_INTERNAL_CharacterOfGroup",function(g,r,F)
# Arguments: g - element of direct product of cyclic groups; r - a list of dimensions; F - GF(p^k);
# Output: character of element g over field F.
  local out,t, pel, g1, sum, ii, i;
  pel:=PrimitiveElement(F);
  g1:=List(g,ii->LogFFE(ii,pel));
  sum:=0;

  for i in [1..Size(r)] do
    sum:=sum+g1[i]*r[i];
  od;

  return pel^sum;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_CharTable",function(g,r,F)
# Arguments: g - elements of direct product of cyclic groups; r - dimension vector; F - GF(p^k);
# Output: character table of elements of g over field F.
  local out1,out2,gi,ri,temp,tup, ind, p;

  out1:=[]; out2:=[];
  ind:=[];
  for ri in r do
    temp:=[];
    for gi in g do
     Add(temp,THELMA_INTERNAL_CharacterOfGroup(gi,ri,F));
    od;
    if Sum(ri)<=1 then
      Add(out1,temp);
      if Position(ri,1)<>fail then Add(ind,Position(ri,1)); else Add(ind,0); fi;
    else Add(out2,temp);
    fi;
  od;
  p:=Sortex(ind);

  return [Permuted(out1,p),out2];
end);

BindGlobal("THELMA_INTERNAL_FindSolMat",function(l,tup,mode) #true - 1 sol; false - multiple
# Arguments: l - ff matrix, tup - possible values for solutions, mode - 1 or multiple Solutions
# Output: a solution to the system
local mat,rnk,n,tt,t,temp,k,var,j,sol;
l:=EchelonMat(l);
mat:=l.vectors;
rnk:=RankMat(mat);

if rnk<Size(mat) then return []; fi;

n:=Size(mat[1]);

t:=Tuples(tup,n-rnk);
var:=Positions(l.heads, 0);
sol:=[];

for tt in t do
  temp:=ListWithIdenticalEntries(n,Zero(mat[1][1]));
  k:=1;
  for j in var do temp[j]:=tt[k]; k:=k+1; od;

  k:=1;
  for j in Difference([1..n],var) do temp[j]:=-(mat[k]{var}*temp{var}); k:=k+1; od;

	if Filtered(temp, j -> not(j in tup) )=[] then ##we check if the solution is correct
		if mode = true then
			return temp;

		fi;
		Add(sol,temp);
	fi;
od;

return sol;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_FindWeights",function(mat,f,q,F)
# Arguments: mat - character table; f - vector of function; q - dimension of cyclic group of f; F - GF(p^k);
# Output: structure vector of a multi-valued threshold element (if exists).
  local inp,n,i,elm,r,mm,j, sol,w,solved, temp, slist, ss, struct,s,mv,bool,st,lg,groups,tup;
  inp:=[];
  elm:=Elements(Units(F));

  for i in [1..(Size(F)-1)/q[Size(q)]] do Add(inp,elm[i]); od;

  mm:=[];
  for i in mat[2] do
    temp:=[];
    for j in [1..Size(i)] do Add(temp,Inverse(i[j])*f[j]); od;
    Add(mm,temp);
  od;

	sol:=THELMA_INTERNAL_FindSolMat(mm,inp,true);

	if sol = [] then return []; fi;




		groups:=[];
	  for i in q do Add(groups,Group((PrimitiveElement(F))^((Size(F)-1)/i))); od;
	  lg:=List(groups, i->Elements(i));
	  tup:=Elements(DirectProductOp(groups{[1..Size(groups)-1]},groups[1]));



	struct:=[];

	s:=sol;
		w:=[]; temp:=[];

		for j in [1..Size(f)] do Add(temp,s[j]*f[j]); od;
  	for i in mat[1] do Add(w,temp*List(i,Inverse)); od;

  	w:=w/Size(f);
		st:=[w{[2..Size(w)]},w[1]];
	 return st;

end);

##############################################################
BindGlobal("THELMA_INTERNAL_FormVectR",function(n,j)
# Arguments: n - number of variables; j - index of the first tolerance matrix;
# Output: a set of list of non-negative integers of length n-j.
	local tup, i, r, temp, s;

	r:=[];

		s:=n-j;
		tup:=IteratorOfTuples([0..j-1],s+1);
		for i in tup do
			temp:=ShallowCopy(i);
			Sort(temp);
			if Reversed(temp)=i then Add(r,i); fi;
		od;

	return r;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_MappingBoolToInt",function(a,r,j,u)
# Arguments: a - vector over GF(2); r - list of non-negative integers;
# Arguments: j - index of the first tolerance matrix; u - list of non-negative integers;
# Output: epsilon vector - list of non-negative integers.
	local i, s, output, k, n0, sum;
	output:=[];
	for i in [1..u[1]] do Add(output,Order(a[i])); od;

	n0:=2;
	while n0<=Size(u) do
		Add(output,2^(n0-1)*Order(a[i]));
		n0:=n0+1;
	od;

	sum:=0;

	for i in [1..Size(u)] do
		sum:=sum+u[i]*2^(i-1);
	od;

	k:=j;
	for i in r do Add(output,Order(a[k])*(sum-i+1)); k:=k+1; od;

	while Size(output)<Size(a) do Add(output,Order(a[i])*(sum+1)); od;

	return output;
end);
#E
##
