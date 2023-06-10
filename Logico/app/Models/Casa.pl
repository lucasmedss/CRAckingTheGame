:- dynamic casa/5.

% Fatos
casa(casa{ idCasa: Id, nome: Nome, descricao: Descricao, requisitos: Requisitos, quiz: Quiz }) :-
    integer(Id),
    atom(Nome),
    atom(Descricao),
    is_list(Requisitos),
    is_list(Quiz),
    validateQuiz(Quiz).

% Exemplo de fatos
casa(casa{ idCasa: 1, nome: "Casa1", descricao: "Descrição1", requisitos: ["Requisito1", "Requisito2"], quiz: [quiz{...}, quiz{...}] }).
casa(casa{ idCasa: 2, nome: "Casa2", descricao: "Descrição2", requisitos: ["Requisito3", "Requisito4"], quiz: [quiz{...}, quiz{...}] }).
casa(casa{ idCasa: 3, nome: "Casa3", descricao: "Descrição3", requisitos: ["Requisito5", "Requisito6"], quiz: [quiz{...}, quiz{...}] }).

% Regra para validar a lista de quizzes
validateQuiz([]).
validateQuiz([quiz{...}|Rest]) :-
    validateQuiz(Rest).

% Recuperar o nome de uma casa específica
getNomeCasa(CasaId, NomeCasa) :-
    casa(casa{ idCasa: CasaId, nome: NomeCasa, _, _, _ }).

% Recuperar a descrição de uma casa específica
getDescricaoCasa(CasaId, DescricaoCasa) :-
    casa(casa{ idCasa: CasaId, _, descricao: DescricaoCasa, _, _ }).

% Recuperar os requisitos de uma casa específica
getRequisitosCasa(CasaId, RequisitosCasa) :-
    casa(casa{ idCasa: CasaId, _, _, requisitos: RequisitosCasa, _ }).

% Recuperar os quizzes de uma casa específica
getQuizzesCasa(CasaId, QuizzesCasa) :-
    casa(casa{ idCasa: CasaId, _, _, _, quiz: QuizzesCasa }).