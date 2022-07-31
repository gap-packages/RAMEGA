#############################################################################
##
#W  ramega_internal.gi                         Zsolt Adam Balogh <baloghzsa@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#Y  Copyright (C)  2020,  UAE University, UAE
##
#############################################################################
##
##  This file contains internal functions used by RAMEGA.
##
#############################################################################
##



#############################################################################
##
##  LieComm( <x,y> )
##
##  Returns the Lie commutator [x,y]=xy-yx.
##
##
BindGlobal("RAMEGA_LieComm",function(x,y)
   return x*y-y*x;
end);


#############################################################################
##
##  GetDerivedDepthN( <KG> )
##
##  Gives an element with depth n, (x,y) has dept 2, if x,y have depth 1..
##
##
BindGlobal("RAMEGA_GetDerivedDepthN", function(kg,n)
   local e,full,tomb,er,counter,x,c,calc,elem;
   e:=One(kg);
   full:=[];
   tomb:=[];
   er:=0;
   counter:=2^(n-1);
   if (n=1) then
      return GetRandomNormalizedUnit(kg);
   fi;
   while (er < counter) do
     x:=GetRandomNormalizedUnit(kg);
     Add(tomb,x);
     er:=er+1;
   od;
   Add(full,tomb);
   c:=1;
   repeat
      x:=full[c];
      tomb:=[];
      calc:=1;
      while(calc<Size(x)) do
         elem:=Comm(x[calc],x[calc+1]);
         Add(tomb,elem);
         calc:=calc+2;
      od;
      Add(full,tomb);
      c:=c+1;
   until(c=n);
   return tomb[1];
end);

#############################################################################
##
##  GetRandomNormalizedUnit( <KG> )
##
##  Returns the nilpotency class of V by random way.
##
##
BindGlobal("RAMEGA_GetRandomNormalizedUnit", function(kg)
   local x,e;
   e:=One(UnderlyingField(kg));
   repeat
      x:=Random(kg);
   until(Augmentation(x) = e);
   return x;
end);


#############################################################################
##
##  IsModularGroupAlgebra( <KG> )
##
##  Returns true if the group algebra KG is modular
##
##
BindGlobal( "RAMEGA_IsModularGroupAlgebra", function(kg)
    local k,g,ter;
	k:=UnderlyingField(kg);
	g:=UnderlyingGroup(kg);
    return Size(g) mod Characteristic(k) = 0;
end);

BindGlobal("RAMEGA_RandomCentralUnitaryOrder_next", function(kg)
  local x,a,b,e,ret;
  e:=One(kg);
  ret:=0;
  b:=0;
  while (b = 0) do
    x:=GetRandomCentralNormalizedUnit(kg);
    ret:=ret+1;
    if (x*Involution(x) = e) then
  	    b:=b+1;
	fi;
  od;
  return ret;
end);


#############################################################################
##
##  RandomUnitaryOrder_next( <KG> )
##
##  Returns .
##
##
BindGlobal("RAMEGA_RandomUnitaryOrder_next", function(kg)
  local x,a,b,e,ret;
  e:=One(kg);
  ret:=0;
  b:=0;
  while (b = 0) do
    x:=GetRandomNormalizedUnit(kg);
    ret:=ret+1;
    if (x*Involution(x) = e) then
  	    b:=b+1;
	fi;
  od;
  return ret;
end);


#############################################################################
##
#M  Involution( <x>, <mapping_sigma> )
##
##  Computes the image of the element x = \sum alpha_g g under the mapping
##  \sum alpha_g g  -> \sum alpha_g * sigma(g)
##
BindGlobal("RAMEGA_InvolutionKG",function(x, sigma, KG)
#    "LAGUNA: for a group ring element and a group endomapping of order 2",
    local g;
    if Order(sigma)<>1 and not(IsPrimePowerInt(Order(sigma)) and not(IsOddInt(Order(sigma)))) then
        Error("Order of the involution should be a power of 2.");
    fi;
    if not(IsElementOfMagmaRingModuloRelations(x) and IsMagmaRingObjDefaultRep(x)) then
        Error("The first entry has to be a Group Ring element");
    fi;
    if not(IsMapping(sigma)) then
        Error("The first entry has to be a mapping");
    fi;
    if Source(sigma) <> Range(sigma) then
        Error("Involution: Source(sigma) <> Range (sigma)");
    else
        if IsAbelian(UnderlyingGroup(KG)) then
                                  return ElementOfMagmaRing( FamilyObj(x),
                                   ZeroCoefficient(x),
                                   CoefficientsBySupport(x),
                                   List(Support(x), g -> (g^sigma)))  ;
        else
          return ElementOfMagmaRing( FamilyObj(x),
           ZeroCoefficient(x),
           CoefficientsBySupport(x),
           List(Support(x), g -> (g^sigma)^(-1)))  ;
        fi;
    fi;
end);


BindGlobal("RAMEGA_IsDihedralGroup", function(G)
local p,m,exponent;

    if ( IsPGroup(G) and not(IsAbelian(G)) ) then
      p:=PrimePGroup(G);
      if p<>2 then
        # Error("The Group should be a non abelian 2-group.");
        return false;
      fi;
      exponent:=Lcm(Set((List(Elements(G),j->Order(j)))));
      if exponent=Size(G)/2 then
        if Size(Filtered(Elements(G),j->Order(j)<=2))=exponent+2 then
          return true;
        else
          return false;
        fi;
      else return false;
      fi;
    else
      return false;
    fi;
end);




BindGlobal("RAMEGA_IsGeneralisedQuaternionGroup", function(G)
local p,m,exponent,x;

    if ( IsPGroup(G) and not(IsAbelian(G)) ) then
	    p:=PrimePGroup(G);
		if not(PrimePGroup(G)=2) then
		   # Error("The Group should be a non abelian 2-group.");
			return false;
		fi;
    #exponent:=Lcm(Set(List(Elements(G),j->Order(j))));  
		if Exponent(G)=Size(G)/2 then
		    m:=Filtered(G,x->Order(x)=2);
			if Size(m) = 1 then
			   return true;
			else
			   return false;
			fi;
    else return false;
    fi;
	else
		return false;
    fi;
end);

BindGlobal("RAMEGA_IsLieNilpotent",function(L)
      local p,G;
      Info(LAGInfo, 1, "LAGUNA package: Checking Lie nilpotency ..." );
      p:=Characteristic(L);
      G:=UnderlyingGroup(L);
      if p=0 or IsAbelian(G) then
        return IsLieAbelian(L);
      fi;
      return
        [p]=Set(Factors(Size(DerivedSubgroup(G))))
        and IsNilpotent(G);
    end);
