:- module('MenuController', [
    menu/0,
    limpar_tela/0
    ]).

:- use_module('TabuleiroController', [getTabuleiro/1]).
:- use_module('JogoController', [roda_jogo/2]).

menu :-
    limpar_tela,
    write("Seja bem-vindo ao CRAcking the Game!\n"),
    open_file('../database/menu.txt', read, Stream),
    ler_conteudo(Stream),
    close_file(Stream),
    opcao_valida.

ler_conteudo(Stream) :-
    repeat,
    (   at_end_of_stream(Stream) -> !
    ;   read_line_to_string(Stream, Conteudo),
        write(Conteudo), nl,
        fail
    ),
    nl.

open_file(File, Mode, Stream) :-
    open(File, Mode, Stream).

close_file(Stream) :-
    close(Stream).

opcao_valida :-
    writeln('1 - Jogar'),
    writeln('2 - Jogar contra o Bot'),
    writeln('3 - Sair'),
    get_single_char(Code),
    char_code(Char, Code),
    atom_chars(Opcao, [Char]),
    writeln(Opcao),
    processar_opcao(Opcao).

processar_opcao('1') :-
    limpar_tela,
    getTabuleiro(Tabuleiro),
    roda_jogo(0, Tabuleiro),
    menu().

processar_opcao('2') :-
    limpar_tela,
    writeln('Jogar contra o Bot'),
    menu().

processar_opcao('3') :-
    limpar_tela,
    writeln('Obrigado por jogar CRAcking the Game.\nAté mais!'),
    sleep(5),
    halt.

processar_opcao(_) :-
    writeln('Opção inválida! Tente novamente.'),
    sleep(1),
    menu().

limpar_tela :-
    write('\e[H\e[2J').
