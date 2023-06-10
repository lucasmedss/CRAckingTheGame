:- use_module(library(pio)).
:- use_module(library(json)).
:- use_module(library(http/json)).

:- dynamic carta/4.

carta(positiva, IdCarta, Nome, Descricao) :-
    carta(positiva, IdCarta, Nome, Descricao, _).

carta(positiva, IdCarta, Nome, Descricao, _) :-
    json_read_file('./database/cartas.json', Cartas),
    member(carta(positiva, IdCarta, Nome, Descricao), Cartas).

carta(negativa, IdCarta, Nome, Descricao) :-
    carta(negativa, IdCarta, Nome, Descricao, _).

carta(negativa, IdCarta, Nome, Descricao, _) :-
    json_read_file('./database/cartas.json', Cartas),
    member(carta(negativa, IdCarta, Nome, Descricao), Cartas).
