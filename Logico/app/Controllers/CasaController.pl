:- use_module(library(http/json)).
:- dynamic casa/5.
:- dynamic quiz/7.

carregarCasas :-
    open('./database/casas.json', read, Stream),
    json_read_dict(Stream, Casas),
    close(Stream),
    assertCasas(Casas).

carregarQuizzes :-
    open('./database/quizzes.json', read, Stream),
    json_read_dict(Stream, Quizzes),
    close(Stream),
    assertQuizzes(Quizzes).

assertCasas([]).
assertCasas([Casa | Resto]) :-
    assertz(casa(Casa.idCasa, Casa.descricao, Casa.tipo, Casa.opcoes, Casa.resultados)),
    assertCasas(Resto).

assertQuizzes([]).
assertQuizzes([Quiz | Resto]) :-
    assertz(quiz(Quiz.idQuiz, Quiz.pergunta, Quiz.respostaA, Quiz.respostaB, Quiz.respostaC, Quiz.respostaD, Quiz.respostaCorreta)),
    assertQuizzes(Resto).

getCasaByID(ID, Casa) :-
    casa(ID, Descricao, Tipo, Opcoes, Resultados),
    Casa = casa(ID, Descricao, Tipo, Opcoes, Resultados).

getQuizByID(ID, Quiz) :-
    quiz(ID, Pergunta, RespostaA, RespostaB, RespostaC, RespostaD, RespostaCorreta),
    Quiz = quiz(ID, Pergunta, RespostaA, RespostaB, RespostaC, RespostaD, RespostaCorreta).
