example([node(v984, [v998], [v998]), node(v998, [v1012], [v1012]), node(v1012, [], [v998])]).
example2([node(v1926, [], []), node(v1940, [v1926, v1926],[])]).
example3([node(v1,[v3],[v2]),node(v2,[v4],[v1]),node(v3,[],[v4]),node(v4,[],[v3])]).
example4([node(v1,[v2],[v2]),node(v2,[v3,v4],[v3,v4]),node(v3,[],[]),node(v4,[],[v2])]).
e(V1,V2,L) :-
    member(node(V1,_,EEDGES),L),
    member(V2,EEDGES).

f(V1,V2,L) :-
    member(node(V1,FEDGES,_),L),
    member(V2,FEDGES).

ef(V1,V2,L) :- e(V1,V2,L);f(V1,V2,L).

fedge(V,V2,G) :-
    member(node(V2,_,Fedge),G),
    member(V,Fedge).

występujeWGrafie(V,L):-
    member(node(V,_,_),L).

eJestPoprawne(Edge,_) :- Edge=[].
eJestPoprawne(Edge,G) :-
    [V|L] =Edge,
    member(node(V,_,_),G),
    eJestPoprawne(L,G).

fJestPoprawne(_,Fedge,_) :- Fedge =[].
fJestPoprawne(V,Fedge,G) :-
    [V2|L] =Fedge,
    member(node(V2,_,F),G),
    member(V,F),
    fJestPoprawne(V,L,G).

występujeTylkoRaz(G) :- G=[].
występujeTylkoRaz(G) :- G=[_].
występujeTylkoRaz(G) :-
    [node(V,_,_)|T] = G,
    \+ member(node(V,_,_),T),
    występujeTylkoRaz(T).

jestEFGrafemRec(G,_) :- G = [].
jestEFGrafemRec(G,G2) :-
    [node(V,Edge,Fedge)|L] = G,
    fJestPoprawne(V,Fedge,G2),
    eJestPoprawne(Edge,G2),
    jestEFGrafemRec(L,G2).

jestEFGrafem(G) :-
    występujeTylkoRaz(G),
    jestEFGrafemRec(G,G).


jestŹródłem(V,G) :-
    member(node(V,_,_),G),
    \+ (
        member(node(_,Edge,_),G),
        member(V,Edge)
     ).

jestUjściem(V,G) :-
    member(node(V,Edge,_),G),
    Edge=[].

nieSpełniaPierwszegoZałożenia(V,V1,W1,G) :-
 \+ spełniaPierwszeZałożenie(V,V1,W1,G).

spełniaPierwszeZałożenie(V,V1,W1,G) :-
    (\+ ((e(V,V1,G),f(V,W1,G))))
    ;
    (
        member(node(U,_,_),G),
        e(W1,U,G),
        f(V1,U,G)
        ;
        jestUjściem(W1,G)
    ).

nieSpełniaDrugiegoZałożenia(V,V1,W1,G) :-
 \+ spełniaDrugieZałożenie(V,V1,W1,G).


spełniaDrugieZałożenie(V,V1,W1,G) :-
    (\+ ((e(V1,V,G),f(V,W1,G))))
    ;
    (
        member(node(U,_,_),G),
        e(W1,U,G),
        f(V1,U,G)
        ;
        jestŹródłem(V1,G)
    ).

kontrprzykładPermutowalności(G) :-
    member(node(V,_,_),G),
    member(node(V1,_,_),G),
    member(node(W1,_,_),G),
    (
        nieSpełniaDrugiegoZałożenia(V,V1,W1,G);
        nieSpełniaPierwszegoZałożenia(V,V1,W1,G)
    ).

jestDobrzePermutujacy(G) :-
   \+kontrprzykładPermutowalności(G).

jestSucc(_,Lista1,_) :-
    Lista1=[].


jestSucc(G,Lista1,Lista2) :-
    [V|Rest1] = Lista1,
    [W|Rest2] = Lista2,
    V @< W,
    f(V,W,G),
    jestSucc(G,Rest1,Rest2).


istniejeŚcieżka(Od,Do,_,_) :- Od=Do.
istniejeŚcieżka(Od,Do,Odwiedzone,G) :-
    e(Od,Następny,G),
    ( \+ member(Następny,Odwiedzone)),
    istniejeŚcieżka(Następny,Do,[Następny|Odwiedzone],G).


listyTakieSame(X,Y) :-
    intersection(X,Y,Z),
    dif(Z,[]).

same_length([],[]).
same_length([_|L1],[_|L2]) :- same_length(L1, L2).
not_member(_, []).
not_member(X, [Head|Tail]) :-
     X \= Head,
    not_member(X, Tail).

v(L,G) :- same_length(L,G),vRec(L,G).

vRec(L,G) :- L=[],G=[].
vRec(L,G) :-
    L=[V|Rest1],
    G=[node(V,_,_)|Rest2],
    vRec(Rest1,Rest2).


nieJestŹródłemAniUjściem(V,G) :-
    \+jestŹródłem(V,G),
    \+jestUjściem(V,G).

dobraPermutacjaRec(Permutacja,_,G) :-
    Permutacja = [Ujście],
    jestUjściem(Ujście,G).

dobraPermutacjaRec(Permutacja,Permutacja2,G) :-
    listyTakieSame(Permutacja,Permutacja2),
    Permutacja = [Żródło|Reszta],
    jestŹródłem(Żródło,G),
    dobraPermutacjaRec(Reszta,Permutacja2,G).

dobraPermutacjaRec(Permutacja,Permutacja2,G) :-
    Permutacja = [V1|[V2|Rest]],
    nieJestŹródłemAniUjściem(V1,G),
    istniejeŚcieżka(V1,V2,[],G),
    dobraPermutacjaRec([V2|Rest],Permutacja2,G).
    

dobraPermutacja(Permutacja,G) :-
%    v(Wierzchołki,G),
%    listyTakieSame(Permutacja,Wierzchołki),
    dobraPermutacjaRec(Permutacja,Permutacja,G).



stopienMaks3(G) :-
    ( \+ (
            member(node(V,_,_),G),
            member(node(V1,_,Fedge1),G),
            member(V,Fedge1),
            member(node(V2,_,Fedge2),G),
            member(V,Fedge2),
            member(node(V3,_,Fedge3),G),
            member(V,Fedge3),
            member(node(V4,_,Fedge4),G),
            member(V,Fedge4),
            V1 \= V2,
            V1 \= V3,
            V1 \= V4,
            V2 \= V3,
            V2 \= V4,
            V3 \= V4
    )).
tylkoJednoŹródło(G):-
    \+ (
        member(node(V1,_,_),G),
        jestŹródłem(V1,G),
        member(node(V2,_,_),G),
        jestŹródłem(V2,G),
        V1 \=V2
    ).

tylkoJednoUjście(G):-
    \+ (
        member(node(V1,_,_),G),
        jestUjściem(V1,G),
        member(node(V2,_,_),G),
        jestUjściem(V2,G),
        V1 \=V2

    ).

jestDobrzeUlozony(G) :-
   v(Wierzchołki,G),
   stopienMaks3(G),
   tylkoJednoUjście(G),
   tylkoJednoŹródło(G),
   !,
   permutation(Wierzchołki,Permutacja),
   dobraPermutacja(Permutacja,G).






















