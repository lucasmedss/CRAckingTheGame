:- use_module(library(pio)).
:- use_module(library(json)).
:- use_module(library(http/json)).

:- dynamic quiz/7.

quiz(IdQuiz, Pergunta, A, B, C, D, Resposta) :-
    quiz(IdQuiz, Pergunta, A, B, C, D, Resposta, _).

quiz(IdQuiz, Pergunta, A, B, C, D, Resposta, _) :-
    json_read_file('./database/quizzes.json', Quizzes),
    member(quiz(IdQuiz, Pergunta, A, B, C, D, Resposta), Quizzes).

getPerguntaQuiz(IdQuiz, Pergunta) :-
    quiz(IdQuiz, Pergunta, _, _, _, _, _).

getRespostaQuiz(IdQuiz, Resposta) :-
    quiz(IdQuiz, _, _, _, _, _, Resposta).

getAQuiz(IdQuiz, A) :-
    quiz(IdQuiz, _, A, _, _, _, _).

getBQuiz(IdQuiz, B) :-
    quiz(IdQuiz, _, _, B, _, _, _).

getCQuiz(IdQuiz, C) :-
    quiz(IdQuiz, _, _, _, C, _, _).
    
getDQuiz(IdQuiz, D) :-
    quiz(IdQuiz, _, _, _, _, D, _).
