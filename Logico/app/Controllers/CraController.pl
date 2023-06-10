:- use_module(library(http/json)).
:- use_module(library(random)).

:- dynamic notas/1.

getNotasJSON(Notas) :-
    read_file_to_string('./database/notas.json', JSONString, []),
    atom_json_term(JSONString, Notas, []).

zeraNotasJSON :-
    NotasZeradas = [nota(humano, 0.0, 0), nota(bot, 0.0, 0)],
    sobrescreverNotas(NotasZeradas).

getCraByJogador(Player, [Nota | _], CRA) :-
    jogador(Nota, Player),
    cra(Nota, CRA).

getCraByJogador(Player, [_ | Resto], CRA) :-
    getCraByJogador(Player, Resto, CRA).

getNumeroDisciplinasByJogador(Player, [Nota | _], NumeroDisciplinas) :-
    jogador(Nota, Player),
    numeroDisciplinas(Nota, NumeroDisciplinas).

getNumeroDisciplinasByJogador(Player, [_ | Resto], NumeroDisciplinas) :-
    getNumeroDisciplinasByJogador(Player, Resto, NumeroDisciplinas).

removeNotaByJogador(_, [], []).
removeNotaByJogador(Player, [Nota | Resto], NotasAtualizadas) :-
    jogador(Nota, Player),
    removeNotaByJogador(Player, Resto, NotasAtualizadas).
removeNotaByJogador(Player, [Nota | Resto], [Nota | NotasAtualizadas]) :-
    removeNotaByJogador(Player, Resto, NotasAtualizadas).

aumentaCraPorJogada(Player) :-
    retract(notas(Notas)),
    getCraByJogador(Player, Notas, CRA),
    getNumeroDisciplinasByJogador(Player, Notas, NumeroDisciplinas),
    random_between(1, 3, Dado),
    NotaDado is 7.0 + Dado,
    CRAAtualizado is (CRA * NumeroDisciplinas + NotaDado) / (NumeroDisciplinas + 1),
    removeNotaByJogador(Player, Notas, NotasRestantes),
    append(NotasRestantes, [nota(Player, CRAAtualizado, NumeroDisciplinas + 1)], NotasAtualizadas),
    assertz(notas(NotasAtualizadas)),
    sobrescreverNotas(NotasAtualizadas).

aumentaCraPorCarta(Player) :-
    retract(notas(Notas)),
    getCraByJogador(Player, Notas, CRA),
    getNumeroDisciplinasByJogador(Player, Notas, NumeroDisciplinas),
    random_between(1, 3, Dado),
    Acrescimo is Dado * 0.2,
    (
        CRA + Acrescimo > 10.0 ->
        CRAAtualizado is 10.0,
        NotasAtualizadas = [nota(Player, CRAAtualizado, NumeroDisciplinas) | NotasRestantes]
    ;
        CRAAtualizado is CRA + Acrescimo,
        NotasAtualizadas = [nota(Player, CRAAtualizado, NumeroDisciplinas) | NotasRestantes]
    ),
    assertz(notas(NotasAtualizadas)),
    sobrescreverNotas(NotasAtualizadas).
diminuiCraPorCarta(Player) :-
    notas(Notas),
    getCraByJogador(Player, Notas, Cra),
    getNumeroDisciplinasByJogador(Player, Notas, NumeroDisciplinas),
    random_between(1, 3, Dado),
    Decrescimo is Dado * 0.2,
    (Cra - Decrescimo) < 0.0,
    !,
    craAtualizado(0.0, Player, NumeroDisciplinas, Notas, NotasAtualizadas),
    sobrescreverNotas(NotasAtualizadas).
    
diminuiCraPorCarta(Player) :-
    notas(Notas),
    getCraByJogador(Player, Notas, Cra),
    getNumeroDisciplinasByJogador(Player, Notas, NumeroDisciplinas),
    random_between(1, 3, Dado),
    Decrescimo is Dado * 0.2,
    CraAtualizado is Cra - Decrescimo,
    craAtualizado(CraAtualizado, Player, NumeroDisciplinas, Notas, NotasAtualizadas),
    sobrescreverNotas(NotasAtualizadas).

craAtualizado(CraAtualizado, Player, NumeroDisciplinas, Notas, NotasAtualizadas) :-
    removeNotaByJogador(Player, Notas, NotasSemPlayer),
    NotaAtualizada = nota(Player, CraAtualizado, NumeroDisciplinas),
    append(NotasSemPlayer, [NotaAtualizada], NotasAtualizadas).

sobrescreverNotas(Notas) :-
    write_file("./database/Temp.json", Notas),
    remove_file("./database/notas.json"),
    rename_file("./database/Temp.json", "./database/notas.json").
