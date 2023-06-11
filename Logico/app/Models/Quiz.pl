:- module('Quiz', [
    getQuizCasa/3,
    getQuizPerguntaCasa/3,
    getQuizAlternativaCasa/4,
    getRespostaCasa/3]).

:- use_module(library(http/json)).

getCasa(IdCasa, Casa) :-
    open('../database/casas.json', read, Stream),
    json_read_dict(Stream, Casas),
    close(Stream),
    member(Casa, Casas),
    get_dict(idCasa, Casa, IdCasa).

getQuizCasa(IdCasa, IdQuiz, Quiz) :-
    getCasa(IdCasa, Casa),
    get_dict(quiz, Casa, QuizCasa),
    member(Quiz, QuizCasa),
    get_dict(idQuiz, Quiz, IdQuiz).

getQuizPerguntaCasa(IdCasa, IdQuiz, Pergunta) :-
    getQuizCasa(IdCasa, IdQuiz, Quiz),
    get_dict(pergunta, Quiz, Pergunta).

getQuizAlternativaCasa(IdCasa, IdQuiz, Letra, Alternativa) :-
    getQuizCasa(IdCasa, IdQuiz, Quiz),
    get_dict(Letra, Quiz, Alternativa).

getRespostaCasa(IdCasa, IdQuiz, Resposta) :-
    getQuizCasa(IdCasa, IdQuiz, Quiz),
    get_dict(resposta, Quiz, Resposta).
