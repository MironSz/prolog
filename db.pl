example([node(v984, [v998], [v998]), node(v998, [v1012], [v1012]), node(v1012, [], [v998])]).
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
    (\+((
        member(node(_,Edge,_),G),
        member(V,Edge)
      ))).

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

jestSucc(_,Lista1,Lista2) :-
    Lista1=[].


jestSucc(G,Lista1,Lista2) :-
    [V|Rest1] = Lista1,
    [W|Rest2] = Lista2,
    V @< W,
    f(V,W,G),
    jestSucc(G,Rest1,Rest2).





















