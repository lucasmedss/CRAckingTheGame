:- module('MultiplayerController', [roda_multiplayer/4]).

:- use_module('Models/Casa', [getNomeCasa/2, getDescricaoCasa/2, getRequisitosCasa/2, isCasaComplementar/1]).
:- use_module('Models/Quiz', [getQuizCasa/3, getQuizPerguntaCasa/3, getQuizAlternativaCasa/4, getRespostaCasa/3]).
:- use_module('Models/Carta', [getNomeCarta/2, getDescricaoCarta/2, getTipoCarta/2]).
:- use_module('JogoController', [interacao/3, esperar_enter/0, roda_dado/1]).
:- use_module('MenuController', [limpar_tela/0]).
:- use_module('TabuleiroController', [exibirTabuleiro/1, modificarTabuleiro/4]).

roda_multiplayer(0, 0, _, Tabuleiro) :-
    writeln('Seja bem-vindo ao CRAcking the Game!'),
    exibirTabuleiro(Tabuleiro),
    writeln('X - Você\nY - Bot\n'),
    writeln('Você começa jogando. Rode o dado para começar!'),
    esperar_enter,
    roda_dado(Dado),
    modificarTabuleiro(Tabuleiro, "X", Dado, NovoTabuleiro),
    roda_multiplayer(Dado, 0, "X", NovoTabuleiro).

roda_multiplayer(CasaJogador, CasaBot, "X", Tabuleiro) :-
    limpar_tela,
    getDescricaoCasa(CasaJogador, DescricaoCasa),
    writeln(DescricaoCasa),
    exibirTabuleiro(Tabuleiro),
    interacao(CasaJogador, Resultado, Tabuleiro),
    (   Resultado == true ->
        roda_dado(Dado),
        NovoValor is CasaJogador + Dado
    ;   NovoValor is CasaJogador - 1
    ),
    modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
    roda_multiplayer(NovoValor, CasaBot, "Y", NovoTabuleiro).

roda_multiplayer(CasaJogador, CasaBot, "Y", Tabuleiro) :-
    limpar_tela,
    exibirTabuleiro(Tabuleiro),
    writeln('Vez do bot!'),
    roda_multiplayer(CasaJogador, CasaBot, "X", Tabuleiro).

ler_resposta(Resposta) :-
    get_single_char(Code),
    char_code(Char, Code),
    atom_chars(RespostaUsuario, [Char]),
    (   RespostaUsuario \= 'a',
        RespostaUsuario \= 'b',
        RespostaUsuario \= 'c',
        RespostaUsuario \= 'd' ->
        writeln(RespostaUsuario),
        writeln('Resposta inválida! Tente novamente.'),
        ler_resposta(Resposta)
    ;   writeln(RespostaUsuario),
        Resposta = RespostaUsuario
    ).
