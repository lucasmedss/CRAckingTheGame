:- use_module(library(pio)).
:- use_module(library(json)).
:- use_module(library(http/json)).

:- dynamic nota/3.

nota(Jogador, CRA, NumeroDisciplinas) :-
    nota(Jogador, CRA, NumeroDisciplinas, _).

nota(Jogador, CRA, NumeroDisciplinas, _) :-
    json_read_file('./database/notas.json', Notas),
    member(nota(Jogador, CRA, NumeroDisciplinas), Notas).

# :- dynamic nota/3.

# % Fatos
# nota(nota{ jogador: Jogador, cra: Cra, numeroDisciplinas: NumDisciplinas }) :-
#     atom(Jogador),
#     float(Cra),
#     integer(NumDisciplinas).

# % Exemplo de fatos
# nota(nota{ jogador: "Jogador1", cra: 9.5, numeroDisciplinas: 5 }).
# nota(nota{ jogador: "Jogador2", cra: 8.7, numeroDisciplinas: 4 }).
# nota(nota{ jogador: "Jogador3", cra: 7.9, numeroDisciplinas: 3 }).

# % Recuperar o jogador de uma nota específica
# getJogador(NotaId, Jogador) :-
#     nota(nota{ jogador: Jogador, _, _ }),
#     notaId(NotaId).

# % Recuperar o CRA de uma nota específica
# getCra(NotaId, Cra) :-
#     nota(nota{ _, Cra, _ }),
#     notaId(NotaId).

# % Recuperar o número de disciplinas de uma nota específica
# getNumeroDisciplinas(NotaId, NumeroDisciplinas) :-
#     nota(nota{ _, _, NumeroDisciplinas }),
#     notaId(NotaId).