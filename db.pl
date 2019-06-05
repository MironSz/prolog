graph([ node(v0, [v1], [v2]),
      node(v1, [v2], [v3]),
      node(v2, [v3], [v0]),
      node(v3, [], [v1]) ]).

e(V1,V2) :-
    graph(L),
    member(node(V1,_,EEDGES),L),
    member(V2,EEDGES).

f(V1,V2) :-
    graph(L),
    member(node(V1,FEDGES,_),L),
    member(V2,FEDGES).
ef(V1,V2) :- e(V1,V2);f(V1,V2).

remove_node(V,graph(G),graph(G_removed)) :-
    not(member(node(V,_,_),G_removed)),
    (
        member(node(V2,E,F),G),V2 \= V ->
            delete(E,V,E_removed),
            delete(F,V,F_removed),
            member(node(V2,E_removed,F_removed),G_removed)
    ).


is_in_graph(V1,[node(V,_,_)|L]) :- V1=V.
is_in_graph(V1,[node(V,_,_)|L]) :- is_in_graph(V1,L).
