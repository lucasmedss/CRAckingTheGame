:- module('Casa', [
    getNomeCasa/2,
    getDescricaoCasa/2,
    getRequisitosCasa/2,
    isCasaComplementar/1
    ]).

:- use_module(library(http/json)).

getCasa(IdCasa, Casa) :-
    open('../database/casas.json', read, Stream),
    json_read_dict(Stream, Casas),
    close(Stream),
    member(Casa, Casas),
    get_dict(idCasa, Casa, IdCasa).

getNomeCasa(IdCasa, Nome) :-
    getCasa(IdCasa, Casa),
    get_dict(nome, Casa, Nome).

getDescricaoCasa(IdCasa, Descricao) :-
    getCasa(IdCasa, Casa),
    get_dict(descricao, Casa, Descricao).

getRequisitosCasa(IdCasa, Requisitos) :-
    getCasa(IdCasa, Casa),
    get_dict(requisitos, Casa, Requisitos).

isCasaComplementar(IdCasa):-
    getCasa(IdCasa, Casa),
    get_dict(quiz, Casa, Quiz),
    (   Quiz = [] ->
        true
    ;   false
    ).
