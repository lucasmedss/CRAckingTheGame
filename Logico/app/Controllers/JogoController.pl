:- use_module(library(random)).
:- consult('Models/Casa').
:- consult('Models/Quiz').
:- consult('Controllers/TabuleiroController').

roda_jogo(IdCasa, Tabuleiro) :-
    IdCasa =:= 33, 
    write('ACABOU O JOGO'), nl.

roda_jogo(IdCasa, Tabuleiro) :-
    %limpar_tela,
    exibirTabuleiro(Tabuleiro),
    interacao(IdCasa, Resultado),
    (Resultado == true ->
        roda_dado(Dado),
        NovoValor is IdCasa + Dado,
        modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
        roda_jogo(NovoValor, NovoTabuleiro)
    ;   
        NovoValor is IdCasa-1,
        modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
        roda_jogo(NovoValor, NovoTabuleiro)
    ).

roda_dado(Resultado) :-
    random(0, 5, Resultado).

seleciona_quiz(IdQuiz) :-
    random(1, 4, IdQuiz).

interacao(IdCasa, Resultado) :-
    getDescricaoCasa(IdCasa, DescricaoCasa),
    write(DescricaoCasa),
    %isCasaComplementar(IdCasa)
    %Lógica de casa complementar
    %(Quiz == "" ->
    %    Resultado is Interacao).! #Break
    seleciona_quiz(IdQuiz),
    writeln(IdQuiz),
    getQuizPerguntaCasa(IdCasa, IdQuiz, Pergunta),
    printa_casa(IdCasa, IdQuiz),
    read(RespostaUsuario),
    getRespostaCasa(IdCasa, IdQuiz, Resposta),
    atom_string(RespostaQuiz, Resposta),
    (   RespostaUsuario = RespostaQuiz ->
        write("Resposta correta!"),
        Resultado = true
    ;   write("Resposta incorreta!"),
        Resultado = false
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