:- use_module(library(random)).
:- consult('mode/casa.pl').

roda_jogo(X) :-
    X =:= 31, % Verifica se X é igual a 31
    write('ACABOU O JOGO'), nl.

roda_jogo(X) :-
    interacao(X, Resultado),
    (Resultado == true ->
        roda_dado(Dado),
        NovoValor is X + Dado,
        roda_jogo(NovoValor)
    ;   
        NovoValor is X-1,
        roda_jogo(NovoValor)
    ).

roda_dado(Resultado) :-
    random(0, 5, Resultado).

seleciona_quiz(Quiz) :-
    random(0, 2, Resultado),

interacao(X, Resultado) :-
    getDescricaoCasa(X, DescricaoCasa),
    write(DescricaoCasa),
    getQuiz(X, Enunciado, Resposta, Interacao), #METODO NÃO EXISTENTE
    write(Enunciado),
    (Enunciado == "" ->
        Resultado is Interacao).! #Break
    read(RespostaUsuario),
    (RespostaUsuario == Resposta ->
        write("Resposta correta!"),
        Resultado is true
    ;
        write("Resposta incorreta!"),
        Resultado is false
    ).
