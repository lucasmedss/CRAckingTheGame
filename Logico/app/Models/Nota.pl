:- use_module(library(pio)).
:- use_module(library(json)).
:- use_module(library(http/json)).

:- dynamic nota/3.

nota(Jogador, CRA, NumeroDisciplinas) :-
    nota(Jogador, CRA, NumeroDisciplinas, _).

nota(Jogador, CRA, NumeroDisciplinas, _) :-
    json_read_file('./database/notas.json', Notas),
    member(nota(Jogador, CRA, NumeroDisciplinas), Notas).

getCRA(Jogador, CRA) :-
    nota(Jogador, CRA, _, _).

getNumeroDisciplinas(Jogador, NumeroDisciplinas) :-
    nota(Jogador, _, NumeroDisciplinas, _).
