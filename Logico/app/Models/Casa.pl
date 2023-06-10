:- use_module(library(pio)).
:- use_module(library(json)).
:- use_module(library(http/json)).

:- dynamic casa/5.

casa(IdCasa, Nome, Descricao, Requisitos, Quiz) :-
    casa(IdCasa, Nome, Descricao, Requisitos, Quiz, _).

casa(IdCasa, Nome, Descricao, Requisitos, Quiz, _) :-
    json_read_file('./database/casas.json', Casas),
    member(casa(IdCasa, Nome, Descricao, Requisitos, Quiz), Casas).

getDescricaoCasa(IdCasa, Descricao) :-
    casa(IdCasa, _, Descricao, _, _).

getNomeCasa(IdCasa, Nome) :-
    casa(IdCasa, Nome, _, _, _).

getRequisitosCasa(IdCasa, Requisitos) :-
    casa(IdCasa, _, _, Requisitos, _).

getQuizCasa(IdCasa, Quiz) :-
    casa(IdCasa, _, _, _, Quiz).