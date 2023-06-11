:- module('Carta', [
    getNomeCarta/2,
    getDescricaoCarta/2,
    getTipoCarta/2
    ]).

:- use_module(library(http/json)).

getCarta(IdCarta, Carta) :-
    open('../database/deck.json', read, Stream),
    json_read_dict(Stream, Cartas),
    close(Stream),
    member(Carta, Cartas),
    get_dict(idCarta, Carta, IdCarta).

getNomeCarta(IdCarta, Nome) :-
    getCarta(IdCarta, Carta),
    get_dict(nome, Carta, Nome).

getDescricaoCarta(IdCarta, Descricao) :-
    getCarta(IdCarta, Carta),
    get_dict(descricao, Carta, Descricao).

getTipoCarta(IdCarta, Tipo) :-
    getCarta(IdCarta, Carta),
    get_dict(tipo, Carta, Tipo).