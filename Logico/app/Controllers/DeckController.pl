:- use_module(library(http/json)).
:- use_module(library(random)).

:- dynamic deck/1.

getDeckJSON(Deck) :-
    read_file_to_string('./database/deck.json', JSONString, []),
    atom_json_term(JSONString, Deck, []).

getCartaById(_, [], Carta) :-
    Carta = carta('', -1, '', '').

getCartaById(Id, [Carta | _], Carta) :-
    idCarta(Carta, Id).

getCartaById(Id, [_ | Resto], Carta) :-
    getCartaById(Id, Resto, Carta).

moveCarta :-
    retract(deck(Deck)),
    Deck = [Carta | Resto],
    append(Resto, [Carta], NovoDeck),
    assertz(deck(NovoDeck)),
    sobrescreverDeck(NovoDeck).

compraCarta(Carta) :-
    deck([Carta | _]).

embaralharDeck :-
    retract(deck(Deck)),
    random_permutation(Deck, DeckEmbaralhado),
    assertz(deck(DeckEmbaralhado)),
    sobrescreverDeck(DeckEmbaralhado).

sobrescreverDeck(Deck) :-
    open('./database/Temp.json', write, Stream),
    json_write(Stream, Deck),
    close(Stream),
    delete_file('./database/deck.json'),
    rename_file('./database/Temp.json', './database/deck.json').

:- initialization (getDeckJSON(Deck), assertz(deck(Deck))).
