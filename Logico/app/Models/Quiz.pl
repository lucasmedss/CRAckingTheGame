:- dynamic quiz/7.

% Fatos
quiz(quiz{ idQuiz: Id, pergunta: Pergunta, a: A, b: B, c: C, d: D, resposta: Resposta }) :-
    integer(Id),
    atom(Pergunta),
    atom(A),
    atom(B),
    atom(C),
    atom(D),
    atom(Resposta).

% Exemplo de fatos
quiz(quiz{ idQuiz: 1, pergunta: "Pergunta1", a: "A1", b: "B1", c: "C1", d: "D1", resposta: "A" }).
quiz(quiz{ idQuiz: 2, pergunta: "Pergunta2", a: "A2", b: "B2", c: "C2", d: "D2", resposta: "B" }).
quiz(quiz{ idQuiz: 3, pergunta: "Pergunta3", a: "A3", b: "B3", c: "C3", d: "D3", resposta: "C" }).

% Recuperar a pergunta de um quiz específico
getPerguntaQuiz(QuizId, Pergunta) :-
    quiz(quiz{ idQuiz: QuizId, pergunta: Pergunta, _, _, _, _, _ }).

% Recuperar opções de resposta de um quiz específico
getOpcoesQuiz(QuizId, Opcoes) :-
    quiz(quiz{ idQuiz: QuizId, _, a: A, b: B, c: C, d: D, _ }),
    Opcoes = [A, B, C, D].

% Recuperar a resposta correta de um quiz específico
getRespostaQuiz(QuizId, Resposta) :-
    quiz(quiz{ idQuiz: QuizId, _, _, _, _, _, resposta: Resposta }).