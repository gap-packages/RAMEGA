#############################################################################
##
#W  random.gi                         Zsolt Adam Balogh <baloghzsa@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: random.gi,v 1.00 $
##
#Y  Copyright (C)  2020,  UAE University, UAE
##
#############################################################################
##
##  This file contains random methods for group algebras.
##
#############################################################################
##

#############################################################################
##
##  BasicGroup( <KG> )
##
##  Returns the basic group of the group algebra KG as a subgroup of the
##  normalized group of units.
##
InstallMethod( BasicGroup,"Group Ring" ,true, [IsGroupRing],1,
function(kg)
    local emb,g;

    if not(IsGroupRing(kg) or IsGroupAlgebra(kg)) then
	Error("Input should be a Group Ring.");
    fi;
    g:=UnderlyingGroup(kg);
    emb:=Embedding(g,kg);
    return Group(List(g,x->x^emb));
end);

#############################################################################
##
##  IsLienEngel( <KG> )
##
##  Returns true if KG is Lie n-Engel.
##  [x,y,y,...,y]=0 for all x,y where the number of y's in the Lie operator is n.
##
##
InstallMethod( IsLienEngel, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local g,ns,er,p,h;

   if not(IsGroupRing(kg)) then
	      Error("Input should be a Group Ring.");
   fi;
   er:=false;
   p:=Characteristic(kg);
   if IsPrime(p) then
      g:=UnderlyingGroup(kg);
      if not(IsAbelian(g)) and IsNilpotent(g) then
	       ns:=NormalSubgroups(g);
	       for h in ns do
#	  if ( IsPPrimePower(Order(g)/Order(h),p) and IsPGroup(DerivedSubgroup(h))  ) then
#    	  if ( IsPosInt(LogInt(Order(g)/Order(h),p)) and IsPGroup(DerivedSubgroup(h))  ) then
          if ((p^(LogInt(Order(g)/Order(h),p))=Order(g)/Order(h)) and IsPGroup(DerivedSubgroup(h))  ) then
        	   if PrimePGroup(DerivedSubgroup(h))=p then
			            er:=true;
		         fi;
	        fi;
	       od;
     fi;
   else er:=true;
   fi;
   return er;
end);


#############################################################################
##
##  GetRandomUnit( <KG> )
##
##  Returns a random unit of KG.
##
##
InstallMethod( GetRandomUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,o;
   o:=Zero(UnderlyingField(kg));
   repeat
      x:=Random(kg);
   until(x^-1<>fail);
   return x;
end);

#############################################################################
##
##  GetRandomNormalizedUnit( <KG> )
##
##  Returns a random normalized unit of the modular group algebra KG.
##
##
InstallMethod( GetRandomNormalizedUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)

   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   return RAMEGA_GetRandomNormalizedUnit(kg);
end);

#############################################################################
##
##  GetRandomUnitaryUnit( <KG> )
##
##  Returns a random unitary unit of KG related to the involution specified as second parameter.
##  If the second parameter is not specified the default involution is the canonical involution.
##
InstallMethod( GetRandomUnitaryUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,e;
   e:=One(kg);
   repeat
      x:=GetRandomUnit(kg);
   until(x*Involution(x) = e);
   return x;
end);

InstallOtherMethod( GetRandomUnitaryUnit, "Group Algebra, Involution", true, [IsGroupRing, IsMapping],2,
function(kg, sigma)
   local x,e;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*RAMEGA_InvolutionKG(x,sigma,kg) = e);
   return x;
end);

#############################################################################
##
##  GetRandomNormalizedUnitaryUnit( <KG> )
##
##  Returns a random normalized unitary unit of the modular group algebra KG related to the involution specified as second parameter.
##  If the second parameter is not specified the default involution is the canonical involution.
##
InstallMethod( GetRandomNormalizedUnitaryUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,e;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*Involution(x) = e);
   return x;
end);

InstallOtherMethod( GetRandomNormalizedUnitaryUnit, "Group Algebra, Involution", true, [IsGroupRing, IsMapping],2,
function(kg, sigma)
   local x,e;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*RAMEGA_InvolutionKG(x,sigma,kg) = e);
   return x;
end);


#############################################################################
##
##  GetRandomElementFromAugmentationIdeal( <KG> )
##
##  Returns a random nilpotent element of the modular group algebra KG.
##
##
InstallMethod( GetRandomElementFromAugmentationIdeal, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,o;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   o:=Zero(UnderlyingField(kg));
   repeat
      x:=Random(kg);
   until(Augmentation(x) = o);
   return x;
end);


#############################################################################
##
##  RandomLienEngelLength( <KG,n> )
##
##  Returns the Lie n-Engel length of KG by random way.
##  [x,y,y,...,y]=0 for all x,y where the number of y's in the Lie operator is the Lie n-Engel length.
##
##
InstallMethod( RandomLienEngelLength, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
	local g,er,i,j,x,y,max;

	if not(IsGroupRing(kg)) then
	      Error("Input should be a Group Ring.");
	fi;
	if not(IsLienEngel(kg)) then
	      Error("The group ring is not Lie n-Engel");
	fi;
	max:=0;
    g:=BasicGroup(kg);
    for j in [1..n] do
       x:=Random(kg);
       for i in g do
         y:=i;
         er:=0;
         repeat
           y:=RAMEGA_LieComm(y,x);
           er:=er+1;
         until(y=Zero(kg));
		 if (max < er) then
		   max:=er;
		 fi;
       od;
    od;
    return max;
end);


#############################################################################
##
##  RandomExponent( <KG,m> )
##
##  Returns the Exponent of the group of normalized units in a modular group algebra by random way.
##
##
InstallMethod( RandomExponent, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local order,x,er,max;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(UnderlyingGroup(kg))) then
       Error("G should be a p group.");
   fi;
   er:=0;
   max:=1;
   order:=0;
   repeat
     x:=GetRandomNormalizedUnit(kg);
     order:=Order(x);
     er:=er+1;
	 if (max < order) then
	   max:=order;
	 fi;
   until(er = m);
   return max;
end);

#############################################################################
##
##  RandomExponentOfNormalizedUnitsCenter( <KG,m> )
##
##  Returns the exponent of the center of the group of normalized units in the modular group algebra KG by random way.
##
##
InstallMethod( RandomExponentOfNormalizedUnitsCenter, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local x,e,er,order,max,c;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(UnderlyingGroup(kg))) then
       Error("G should be a p group.");
   fi;
   er:=0;
   max:=0;
   e:=One(UnderlyingField(kg));
   c:=Center(kg);
   repeat
     x:=Random(c);
     if (Augmentation(x) = e) then
        order:=Order(x);
		if (max < order) then
		  max:=order;
		fi;
        er:=er+1;
     fi;
   until(er = m);
   return max;
end);

#############################################################################
##
##  RandomNilpotencyClass( <KG,m> )
##
##  Returns the nilpotency class of the group of normalized units of the group algebra KG by random way.
##
##
InstallMethod( RandomNilpotencyClass, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local cl,x,y,e,er,class;
   if not(IsLieNilpotent(LieAlgebra(kg))) then
	   Error("The Group Algebra is not nilpotent.");
   fi;
   e:=One(kg);
   class:=0;
   er:=1;
   while (er < m) do
     x:=GetRandomNormalizedUnit(kg);
     cl:=0;
     repeat
        y:=GetRandomNormalizedUnit(kg);
        x:=Comm(x,y);
        cl:=cl+1;
     until(x = e);
     if (class < cl) then
	   class:=cl;
	 fi;
     er:=er+1;
   od;
   return class;
end);

#############################################################################
##
##  RandomDerivedLength( <KG,m> )
##
##  Returns the derived length of the modular group algebra KG by random way.
##
##
InstallMethod( RandomDerivedLength, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local e,n,x,depth,bol;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
   fi;
   e:=One(kg);
   bol:=false;
   depth:=1;
   while(not(bol)) do
     n:=1;
     while(n < m) do
        x:=RAMEGA_GetDerivedDepthN(kg,depth);
        if (not(x=e)) then
           bol:=true;
        fi;
        n:=n+1;
     od;
     if (bol) then
        depth:=depth+1;
        bol:=false;
     else
        bol:=true;
     fi;
   od;
   return depth-1;
end);

##############################################################################
##
##  RandomCommutatorSubgroup( < G, n > )
##
##  Returns the commutator subgroup of G using random method.
##  Returns the commutator subgroup of the unit group of the group algebra KG using random method.
##
InstallMethod( RandomCommutatorSubgroup, "Group, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(KG,n)
    local i,x1,x2,A,g;
	A:=[];
	for i in [1..n] do
    x1:=GetRandomUnit(KG);
	  x2:=GetRandomUnit(KG);
	  AddSet(A,x1^-1*x2^-1*x1*x2);
	od;
	return Group(A);
end);

InstallOtherMethod( RandomCommutatorSubgroup, "Group, Number of Iterations", true, [IsGroup,IsPosInt],2,
function(G,n)
    local i,x1,x2,A,g;
	g:=Set(G);
	A:=[];
	for i in [1..n] do
      x1:=Random(g);
	  x2:=Random(g);
	  AddSet(A,Comm(x1,x2));
	od;
	return Group(A);
end);

##############################################################################
##
##  RandomCommutatorSubgroupOfNormalizedUnits( < kg, n > )
##
##  Returns the commutator subgroup of the normalized unit group of the modular group algebra KG
##  using random method.
##
InstallMethod( RandomCommutatorSubgroupOfNormalizedUnits, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local i,x1,x2,A;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
	A:=[];
	for i in [1..n] do
      x1:=GetRandomNormalizedUnit(kg);
	  x2:=GetRandomNormalizedUnit(kg);
	  AddSet(A,Comm(x1,x2));
	od;
	return Group(A);
end);

##############################################################################
##
##  RandomNormalizedUnitGroup( < KG > )
##
##  Returns the normalized group of units of the modular group algebra KG by random search.
##
##
InstallMethod( RandomNormalizedUnitGroup, "Group Ring", true, [IsGroupRing],1,
function(kg)
    local x,A,g,f,h;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
	A:=[];
	g:=UnderlyingGroup(kg);

  if not(IsPGroup(g)) then
    Error("The underlying group should be a p-group.");
  fi;

	f:=UnderlyingField(kg);
	repeat
       x:=GetRandomNormalizedUnit(kg);
	   AddSet(A,x);
	   h:=Group(A);
	until (Number(h) = Number(f)^(Number(g)-1));
	return h;
end);

##############################################################################
##
##  RandomCommutatorSeries( < kg, n > )
##
##  Returns the commutator series of the normalized unit group of a modular group algebra using random method.
##
##
InstallMethod( RandomCommutatorSeries, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local series,g;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;

    g:=UnderlyingGroup(kg);

    if not(IsPGroup(g)) then
      Error("The underlying group should be a p-group.");
    fi;

	series:=[RandomNormalizedUnitGroup(kg)];
	g:=RandomCommutatorSubgroupOfNormalizedUnits(kg,n);
	AddSet(series,g);
	repeat
	   g:=RandomCommutatorSubgroup(g,n);
	   Add(series,g);
	until IdGroup(g)=[1,1];
	return series;
end);

##############################################################################
##
##  RandomLowerCentralSeries( < kg, n > )
##
##  Returns the lower central series of the normalized unit group by random search.
##
##
InstallMethod( RandomLowerCentralSeries, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local series,g,m,x1,x2,A,i;
	if not(IsLieNilpotent(LieAlgebra(kg))) then
	   Error("The Group Algebra is not nilpotent.");
    fi;
	series:=[RandomNormalizedUnitGroup(kg)];
	g:=RandomCommutatorSubgroupOfNormalizedUnits(kg,n);
	m:=2;
	AddSet(series,g);
	repeat
	    A:=[];
	   	for i in [1..n] do
            x1:=GetRandomNormalizedUnit(kg);
	        x2:=Random(AsSet(series[m]));
	        AddSet(A,Comm(x1,x2));
	    od;
		m:=m+1;
		g:=Group(A);
	    Add(series,g);
	until IdGroup(g)=[1,1];
	return series;
end);

#############################################################################
##
##  RandomUnitaryOrder( <kg,n> )
##
##  Returns the order of unitary subgroup of normalized group of units
##  where p=char(k) and g is a finite p-group by random search. The default involution is the canonical involution.
##
InstallMethod( RandomUnitaryOrder, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)

  local x,a,b,e,k,g,order,ret,p;
  k:=UnderlyingField(kg);
  g:=UnderlyingGroup(kg);

  if not(RAMEGA_IsModularGroupAlgebra(kg)) then
    Error("Input should be a Modular Group Algebra.");
  fi;
  if not( IsPGroup(g)) then
      Error("G should be a p group.");
  fi;

  p:=Characteristic(k);
  if ( 1 < Characteristic(k) and  IsPGroup(g) ) then
order:=Number(k)^(Number(g)-1);
e:=One(kg);
a:=0;
b:=0;
while (not a = n) do
x:=GetRandomNormalizedUnit(kg);
a:=a+1;
if (x*Involution(x) = e) then
b:=b+1;
fi;
od;
  if (b=0) then
     return 0;
  fi;
  ret:=0;
  order:=order*b/a;
  while not(p^ret < order and order <= p^(ret+1)) do
    ret:=ret+1;
  od;
  if (order - p^ret > p^(ret+1)-order ) then
     ret:=ret+1;
  fi;
  return p^ret;
  else
      Error("The characteristic of Group Ring is a prime and g is a finite p-group");
      return 0;
  fi;
end);

InstallOtherMethod(RandomUnitaryOrder, "Group Ring, Involution, Number of Iterations", true, [IsGroupRing,IsMapping,IsPosInt],3,
function(kg,sigma,n)
    local x,a,b,e,k,g,order,ret,p;
    k:=UnderlyingField(kg);
    g:=UnderlyingGroup(kg);

    if not(RAMEGA_IsModularGroupAlgebra(kg)) then
      Error("Input should be a Modular Group Algebra.");
    fi;
    if not( IsPGroup(g)) then
        Error("G should be a p group.");
    fi;

    p:=Characteristic(k);
    if ( 1 < Characteristic(k) and  IsPGroup(g) ) then
  order:=Number(k)^(Number(g)-1);
  e:=One(kg);
  a:=0;
  b:=0;
  while (not a = n) do
  x:=GetRandomNormalizedUnit(kg);
  a:=a+1;
  if (x*RAMEGA_InvolutionKG(x,sigma,kg) = e) then
  b:=b+1;
  fi;
  od;
    if (b=0) then
       return 0;
    fi;
    ret:=0;
    order:=order*b/a;
    while not(p^ret < order and order <= p^(ret+1)) do
      ret:=ret+1;
    od;
    if (order - p^ret > p^(ret+1)-order ) then
       ret:=ret+1;
    fi;
    return p^ret;
    else
        Error("The characteristic of Group Ring is a prime and g is a finite p-group");
        return 0;
    fi;

end);

#############################################################################
##
##  GetRandomCentralNormalizedUnit( <KG> )
##
##  Returns a central normalized unit of the modular group algebra KG by random way.
##
##
InstallMethod( GetRandomCentralNormalizedUnit, "Group Ring", true, [IsGroupRing],1,
function(kg)
   local x,e,c;
   	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
   c:=Center(kg);
   e:=One(UnderlyingField(kg));
   repeat
      x:=Random(c);
   until(Augmentation(x) = e);
   return x;
end);


#############################################################################
##
##  RandomUnitarySubgroup( <KG,n> )
##
##  Returns the group of normalized unitary units of the modular group algebra KG by random search.
##
##
InstallMethod( RandomUnitarySubgroup, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local A,i,x;
   	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
    A:=[];
   	for i in [1..n] do
        x:=GetRandomNormalizedUnitaryUnit(kg);
	    AddSet(A,x);
    od;
	return Group(A);
end);

#############################################################################
##
##  RandomDihedralDepth( <KG,n> )
##
##  Returns the dihedral depth of a group or a group algebra in a random way.
##
##

InstallMethod( RandomDihedralDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(KG,n)
    local a,b,dd,g,s,k,i,j,exp;
    if not( IsPGroup(UnderlyingGroup(KG))) then
        Error("G should be a p group.");
    fi;

    k:=0;
    for i in [1..n] do
      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
        g:=Group(a,b); s:=Size(g);
       if RAMEGA_IsDihedralGroup(g) and s>k then
           k:=s;
       fi;
      fi;
    od;

    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#InstallMethod( RandomDihedralDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
#function(KG,n)
#local a,b,dd,g,s,k,i,j,exp;
#if not( IsPGroup(UnderlyingGroup(KG))) then
#    Error("G should be a p group.");
#fi;
#    k:=0;
#    for i in [1..n] do
#      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
#      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
#        g:=Group(a,b); s:=Size(g);
    #    Print(s,"  ",Exponent(g),"\n");
#        exp:= Lcm(Set(List(Elements(g),j->Order(j))));
#        if s/exp=2 then
#          if Size(Filtered(Elements(g),j->Order(j)<=2))>=s/2+2 and s>k then k:=s; fi;
#        fi;
#      fi;
#    od;

#    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
#end);

#############################################################################
##
##  RandomDihedralDepth( <G,n> )
##
##  Returns the dihedral depth of a group or a group algebra in a random way.
##
##
InstallOtherMethod( RandomDihedralDepth, "Group, Number of iterations", true, [IsGroup, IsPosInt],2,
function(G,n)
local a,b,k,s,g,i;
if not( IsPGroup(G)) then
    Error("G should be a p group.");
fi;
    k:=0;
    if IsAbelian(G) then
  Error("The Group should be a non abelian p-group.");
    fi;
    for i in [1..n] do
       a:=Random(Elements(G)); b:=Random(Elements(G));
       g:=Group(a,b);
  s:=Number(g);
       if RAMEGA_IsDihedralGroup(g) and s>k then
           k:=s;
       fi;
    od;
    if k>0 then return LogInt(k,2)-1; else return 0; fi;
end);


#############################################################################
##
##  RandomQuaternionDepth( <KG,n> )
##
##  Returns the quaternion depth of a group or a group algebra in a random way.
##
##
InstallMethod( RandomQuaternionDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(KG,n)
    local a,b,dd,g,s,k,i,j,exp;
    if not( IsPGroup(UnderlyingGroup(KG))) then
        Error("G should be a p group.");
    fi;
    k:=0;
    for i in [1..n] do
      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
        g:=Group(a,b); s:=Size(g);
        exp:= Lcm(Set(List(Elements(g),j->Order(j))));

        if s/exp=2 then
          if Size(Filtered(Elements(g),j->Order(j)<=2))=2 and s>k then k:=s; fi;
        fi;
      fi;
    od;

    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#############################################################################
##
##  RandomQuaternionDepth( <G,n> )
##
##  Returns the quaternion depth of a group or a group algebra in a random way.
##
##
InstallOtherMethod( RandomQuaternionDepth, "Group, Number of iterations", true, [IsGroup, IsPosInt],2,
function(G,n)
local a,b,k,s,g,i;
if not( IsPGroup(G)) then
    Error("G should be a p group.");
fi;
    k:=0;
   	if IsAbelian(G) then
	   Error("The Group should be a non abelian p-group.");
    fi;
    for i in [1..n] do
       a:=Random(G); b:=Random(G);
       g:=Group(a,b);
	     s:=Number(g);
       if RAMEGA_IsGeneralisedQuaternionGroup(g) and s>k then
           k:=s;
       fi;
    od;
    if k>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#############################################################################
##
##  RandomOmega( <KG,m,n> )
##
##
##  Returns the subgroup of V(KG), that is generated by the elements g for which g^{p^m}=1,
##  where G is a finite p-group by random search.
##
InstallMethod( RandomOmega, "Group Algebra, Power of p, Number of iterations", true, [IsGroupRing, IsPosInt, IsPosInt],3,
function(kg,m,n)
    local e,i,A,x,p,k,G;
    G:=BasicGroup(kg);
    if not( IsPrimePowerInt(Size(G))) then
        Error("G should be a p group.");
    fi;
    e:=One(G);
  A:=[];
    if ( IsPGroup(G) ) then
   p:=PrimePGroup(G);
        for i in [1..n] do
           x:=GetRandomNormalizedUnit(kg);
  if (x^(p^m) = e) then
      AddSet(A,x);
  fi;
od;
    fi;
return Group(A);
end);

InstallOtherMethod( RandomOmega, "Group, Power of p, Number of iterations", true, [IsGroup, IsPosInt, IsPosInt],3,
function(G,m,n)
    local e,i,A,x,p,k;
    e:=One(G);

    if not( IsPGroup(G)) then
        Error("G should be a p group.");
    fi;

    A:=[];
    if ( IsPGroup(G) ) then
   p:=PrimePGroup(G);
        for i in [1..n] do
           x:=Random(Elements(G));
  if (x^(p^m) = e) then
      AddSet(A,x);
  fi;
od;
    fi;
return Group(A);
end);
#############################################################################
##
##  RandomAgemo( <KG,m,n> )
##
##
##  Returns the subgroup of V(KG), that is generated by the elements g^{p^m},
##  where G is a finite p-group by random search.
##
InstallMethod( RandomAgemo, "Group Algebra, Power of p, Number of iterations", true, [IsGroupRing, IsPosInt, IsPosInt],3,
function(kg,m,n)
    local i,A,x,p,k,g,e,G;
    G:=BasicGroup(kg);
    e:=One(G);

    if not( IsPrimePowerInt(Size(G))) then
        Error("G should be a p group.");
    fi;

A:=[];
    if ( IsPGroup(G) ) then
       p:=PrimePGroup(G);
        for i in [1..n] do
           x:=GetRandomNormalizedUnit(kg);
      AddSet(A,x^(p^m));
   od;
    fi;
return Group(A);
end);

InstallOtherMethod( RandomAgemo, "Group, Power of p, Number of iterations", true, [IsGroup, IsPosInt, IsPosInt],3,
function(G,m,n)
    local i,A,x,p,k,g,e;
    e:=One(G);
    if not( IsPGroup(G)) then
        Error("G should be a p group.");
    fi;

  A:=[];
    if ( IsPGroup(G) ) then
       p:=PrimePGroup(G);
        for i in [1..n] do
           x:=Random(Elements(G));
      AddSet(A,x^(p^m));
   od;
    fi;
return Group(A);
end);

#E
##
