:- consult('Controllers/TabuleiroController').
:- consult('Models/Casa').
:- consult('Controllers/JogoController').

main :-
    menu().

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
    write("Escolha uma opção:\n"),
    write("1 - Jogar\n"),
    write("2 - Jogar contra o Bot\n"),
    write("3 - Sair\n"),
    get_single_char(Code),
    char_code(Char, Code),
    atom_chars(Opcao, [Char]),
    writeln(Opcao),
    processar_opcao(Opcao).

processar_opcao('1') :-
    limpar_tela,
    write("Jogar\n"),
    getTabuleiro(Tabuleiro),
    roda_jogo(1, Tabuleiro),
    menu().

processar_opcao('2') :-
    limpar_tela,
    write("Jogar contra o Bot\n"),
    menu().

processar_opcao('3') :-
    limpar_tela,
    write("Obrigado por jogar CRAcking the Game\nAté mais!"), halt.

processar_opcao(_) :-
    write("Opção inválida\n"),
    sleep(1),
    menu().

limpar_tela :-
    write('\e[H\e[2J').

esperar_enter :-
    write('Pressione ENTER para prosseguir.'),
    get_char(_),
    nl.

