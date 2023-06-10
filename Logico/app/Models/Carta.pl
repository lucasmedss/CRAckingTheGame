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

getDescricaoCarta(positiva, IdCarta, Descricao) :-
    carta(positiva, IdCarta, _, Descricao, _).

getDescricaoCarta(negativa, IdCarta, Descricao) :-
    carta(negativa, IdCarta, _, Descricao, _).

getIdCarta(positiva, IdCarta) :-
    carta(positiva, IdCarta, _, _, _).

getIdCarta(negativa, IdCarta) :-
    carta(negativa, IdCarta, _, _, _).

getNomeCarta(positiva, IdCarta, Nome) :-
    carta(positiva, IdCarta, Nome, _, _).

getNomeCarta(negativa, IdCarta, Nome) :-
    carta(negativa, IdCarta, Nome, _, _).
