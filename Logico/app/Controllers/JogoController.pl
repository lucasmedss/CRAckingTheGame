:- module('JogoController', [roda_jogo/2]).

:- use_module(library(random)).
:- use_module('Models/Casa', [getNomeCasa/2, getDescricaoCasa/2, getRequisitosCasa/2, isCasaComplementar/1]).
:- use_module('Models/Quiz', [getQuizCasa/3, getQuizPerguntaCasa/3, getQuizAlternativaCasa/4, getRespostaCasa/3]).
:- use_module('TabuleiroController', [exibirTabuleiro/1, modificarTabuleiro/4]).
:- use_module('MenuController', [limpar_tela/0]).

roda_jogo(0, Tabuleiro) :-
    writeln('Seja bem-vindo ao CRAcking the Game!'),
    exibirTabuleiro(Tabuleiro),
    writeln('Rode o dado para começar o jogo!'),
    esperar_enter,
    roda_dado(Dado),
    format('Você jogou o dado e irá avançar ~w casas!\n', [Dado]),
    esperar_enter,
    modificarTabuleiro(Tabuleiro, "X", Dado, NovoTabuleiro),
    roda_jogo(Dado, NovoTabuleiro).

roda_jogo(IdCasa, _) :-
    IdCasa =:= 33, 
    write('ACABOU O JOGO'), nl.

roda_jogo(IdCasa, Tabuleiro) :-
    limpar_tela,
    getDescricaoCasa(IdCasa, DescricaoCasa),
    writeln(DescricaoCasa),
    exibirTabuleiro(Tabuleiro),
    interacao(IdCasa, Resultado),
    (Resultado == true ->
        roda_dado(Dado),
        NovoValor is IdCasa + Dado,
        modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
        roda_jogo(NovoValor, NovoTabuleiro)
    ;   NovoValor is IdCasa-1,
        modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
        roda_jogo(NovoValor, NovoTabuleiro)
    ).

roda_dado(Resultado) :-
    random(1, 5, Resultado).

seleciona_quiz(IdQuiz) :-
    random(1, 4, IdQuiz).

interacao(IdCasa, Resultado) :-
    %isCasaComplementar(IdCasa)
    %Lógica de casa complementar
    %(Quiz == "" ->
    %    Resultado is Interacao).! #Break
    seleciona_quiz(IdQuiz),
    printa_casa(IdCasa, IdQuiz),
    ler_resposta(RespostaUsuario),
    getRespostaCasa(IdCasa, IdQuiz, RespostaQuiz),
    (   RespostaUsuario = RespostaQuiz ->
        writeln('Resposta correta!'),
        Resultado = true
    ;   writeln('Resposta incorreta! Você voltará uma casa!'),
        esperar_enter,
        Resultado = false
    ).

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

printa_casa(IdCasa, IdQuiz) :-
    getQuizPerguntaCasa(IdCasa, IdQuiz, Pergunta),
    writeln(Pergunta),
    getQuizAlternativaCasa(IdCasa, IdQuiz, a, AlternativaA),
    writeln(AlternativaA),
    getQuizAlternativaCasa(IdCasa, IdQuiz, b, AlternativaB),
    writeln(AlternativaB),
    getQuizAlternativaCasa(IdCasa, IdQuiz, c, AlternativaC),
    writeln(AlternativaC),
    getQuizAlternativaCasa(IdCasa, IdQuiz, d, AlternativaD),
    writeln(AlternativaD).

esperar_enter :-
    writeln('Pressione ENTER para prosseguir.'),
    get_single_char(_),
    nl.
