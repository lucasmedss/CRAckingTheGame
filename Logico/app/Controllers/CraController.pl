:- module('CraController', [inicia_cra/1, aumentaCra/2, diminuiCra/2]).

:- use_module(library(random)).

inicia_cra(0.0).

aumentaCra(0.0, CRAAtualizado) :-
    CRAAtualizado is 7.0.

aumentaCra(CRA, CRAAtualizado) :-
    random_between(4, 10, Incremento),  % Gera um número aleatório entre 4 e 10
    Temp is CRA + (Incremento / 10),
    (Temp > 10.0 -> CRAAtualizado is 10.0 ; CRAAtualizado = Temp).

diminuiCra(CRA, CRAAtualizado) :-
    random_between(6, 10, Decremento),  % Gera um número aleatório entre 4 e 10
    Temp is CRA - (Decremento / 10),
    (Temp < 0.0 -> CRAAtualizado is 0.0 ; CRAAtualizado = Temp).