:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(controllers_casa_controller, [
    getCasaByID/2,
    getCasasJSON/1,
    getQuizByID/2
]).
:- use_module(controllers_deck_controller, [
    compraCarta/1,
    getCartaById/2,
    getDeckJSON/1,
    moveCarta/0
]).
:- use_module(controllers_tabuleiro_controller, [
    exibirTabuleiro/1,
    getTabuleiro/1,
    modificarTabuleiro/3
]).

:- use_module(library(ansi_term)).

iniciaJogo(1) :-
    singlePlayer(0, [], Tabuleiro),
    getTabuleiro(Tabuleiro).
iniciaJogo(2) :-
    multiplayer(0, 0, 1, [], Tabuleiro),
    getTabuleiro(Tabuleiro).

multiplayer(0, 0, 1, Tabuleiro, Requisitos) :-
    limpaTela,
    writeln("Seja bem-vindo ao CRAcking the Game!"),
    writeln("Vamos começar!"),
    writeln(""),
    exibirTabuleiro(Tabuleiro),
    writeln("Pressione ENTER para rolar o dado"),
    read_line(_),
    rodaDado(Dado),
    writeln(""),
    writeln("Você tirou ", Dado, " no dado!"),
    writeln("Pressione ENTER para continuar"),
    read_line(_),
    limpaTela,
    modificarTabuleiro(Tabuleiro, "X", Dado, NovoTabuleiro),
    limpaTela,
    exibirTabuleiro(NovoTabuleiro),
    getCasaByID(Dado, Casas),
    interacao(NovoTabuleiro, Casas, Requisitos, Resultado),
    (
        Resultado ->
            writeln("Parabéns por ter acertado! Agora é a vez do Bot."),
            writeln("Pressione ENTER e aguarde sua vez!"),
            read_line(_),
            multiplayer(Dado, 0, 2, NovoTabuleiro, Requisitos)
        ;
            writeln("Que pena, você errou! Passou a vez para o bot jogar."),
            modificarTabuleiro(Tabuleiro, "X", (Dado - 1), TabuleiroAtualizado),
            limpaTela,
            exibirTabuleiro(TabuleiroAtualizado),
            multiplayer((Dado - 1), 0, 2, TabuleiroAtualizado, Requisitos)
    ).
multiplayer(X, Y, 1, Tabuleiro, Requisitos) :-
    limpaTela,
    getCasaByID(X, Casas),
    requisitosCasa(Casas, RequisitosCasa),
    todasAsDisciplinasCursadas(Requisitos, RequisitosCasa),
    (
        interacao(Tabuleiro, Casas, Requisitos, Resultado),
        (
            Resultado ->
            writeln('Parabéns por ter obtido sucesso!'),
            writeln('Pressione ENTER para rolar o dado.'),
            read_line(_),
            limpaTela,
            exibirTabuleiro(Tabuleiro),
            rodaDado(Dado),
            format('Você tirou ~d no dado!~nPressione ENTER para continuar.', [Dado]),
            read_line(_),
            NovoX is X + Dado,
            modificarTabuleiro(Tabuleiro, 'X', NovoX, NovoTabuleiro),
            exibirTabuleiro(NovoTabuleiro),
            writeln('Agora é a vez do Bot. Pressione ENTER e aguarde sua vez!'),
            read_line(_),
            append(Requisitos, [nome(Casas)], NovosRequisitos),
            multiplayer(NovoX, Y, 2, NovoTabuleiro, NovosRequisitos)
        ;
            writeln('aaaawwww errou, vai voltar uma casa!'),
            NovaX is X - 1,
            voltaCasaMultiplayer(NovaX, Y, 2, Tabuleiro, Requisitos)
        )
    ;
        writeln('Você não tem os requisitos para essa casa, vai voltar uma casa!'),
        NovaX is X - 1,
        append(Requisitos, RequisitosCasa, NovosRequisitos),
        voltaCasaMultiplayer(NovaX, Y, 2, Tabuleiro, NovosRequisitos)
    ).
voltaCasaMultiplayer(X, Y, Jogador, Tabuleiro, Requisitos) :-
    writeln('Voltou uma casa e agora quem joga é o bot'),
    read_line(_),
    modificarTabuleiro(Tabuleiro, 'X', X, NovoTabuleiro),
    multiplayer(X, Y, 2, NovoTabuleiro, Requisitos).

singlePlayer(0, Tabuleiro, Requisitos) :-
    limpaTela,
    writeln('Seja bem-vindo ao CRAcking the Game!'),
    writeln('Vamos começar!'),
    exibirTabuleiro(Tabuleiro),
    writeln('Pressione ENTER para rolar o dado.'),
    read_line(_),
    rodaDado(Dado),
    format('Você tirou ~d no dado!~nPressione ENTER para avançar!', [Dado]),
    read_line(_),
    modificarTabuleiro(Tabuleiro, 'X', Dado, NovoTabuleiro),
    singlePlayer(Dado, NovoTabuleiro, Requisitos).

singlePlayer(X, Tabuleiro, Requisitos) :-
    X >= 33 ->
    modificarTabuleiro(Tabuleiro, 'X', 'CC', NovoTabuleiro),
    limpaTela,
    exibirTabuleiro(NovoTabuleiro),
    writeln('Você chegou ao final do tabuleiro! Parabéns!'),
    writeln('Pressione ENTER para voltar para o menu principal.'),
    read_line(_),
    true
  ;
    limpaTela,
    getCasaByID(X, CasasJSON, Casa),
    Models.Casa.requisitos(Casa, RequisitosCasa),
    forall(member(Req, RequisitosCasa), member(Req, Requisitos)),
    resultado(Tabuleiro, Casa, Requisitos, Resultado),
    (
        Resultado ->
        writeln('Parabéns por ter obtido sucesso!'),
        writeln('Pressione ENTER para rolar o dado.'),
        read_line(_),
        limpaTela,
        exibirTabuleiro(Tabuleiro),
        rodaDado(Dado),
        NovaPosicao is X + Dado,
        format('Você tirou ~d no dado!~nPressione ENTER para avançar!', [Dado]),
        read_line(_),
        modificarTabuleiro(Tabuleiro, 'X', NovaPosicao, NovoTabuleiro),
        limpaTela,
        exibirTabuleiro(NovoTabuleiro),
        singlePlayer(NovaPosicao, NovoTabuleiro, [nome(Casa)|Requisitos])
    ;
        NovoTabuleiroErro is X - 1,
        modificarTabuleiro(Tabuleiro, 'X', NovoTabuleiroErro, NovoTabuleiroErro),
        limpaTela,
        exibirTabuleiro(NovoTabuleiroErro),
        writeln('Infelizmente você errou e voltou uma casa!'),
        writeln('Pressione ENTER para continuar.'),
        read_line(_),
        limpaTela,
        singlePlayer(NovoTabuleiroErro, NovoTabuleiroErro, Requisitos)
    ).

resultado(Tabuleiro, Casa, Requisitos, Resultado) :-
    interacao(Tabuleiro, Casa, Requisitos, Resultado).

interacao(Tabuleiro, Casa, Requisitos, Resultado) :-
    limpaTela,
    writeln(descricao(Casa)),
    exibirTabuleiro(Tabuleiro),
    nome(Casa, NomeCasa),
    (
        NomeCasa = "Casa Complementar" ->
        rodaDadoCarta(Dado),
        getCartaById(Dado, DeckJSON, CartaComprada),
        format('Você comprou a carta: ~w~n~w~nPressione ENTER para continuar!', [nome(CartaComprada), descricaoC(CartaComprada)]),
        read_line(_),
        (
            tipo(CartaComprada) = "positiva" ->
            NovoIdCasa is idCasa(Casa) + 1,
            avancaCasa(NovoIdCasa, Tabuleiro, Requisitos),
            Resultado = true
        ;
            NovoIdCasa is idCasa(Casa) - 1,
            voltaCasa(NovoIdCasa, Tabuleiro, Requisitos),
            Resultado = true
        )
    ;
        quiz(Casa, QuizCasa),
        (
            QuizCasa = [] ->
            writeln('Não tem quiz'),
            Resultado = true
        ;
            executaQuiz(QuizCasa, Resultado)
        )
    ).

executaQuiz(Quiz) :-
    random_between(1, 3, Seleciona),
    getQuizByID(Seleciona, Quiz, QuizSelecionado),
    format('~w~n~w~n~w~n~w~n~w~n', [pergunta(QuizSelecionado), a(QuizSelecionado), b(QuizSelecionado), c(QuizSelecionado), d(QuizSelecionado)]),
    read_line(Input),
    (
        Input \= "a",
        Input \= "b",
        Input \= "c",
        Input \= "d" ->
        writeln('Resposta inválida, tente novamente!'),
        executaQuiz(Quiz)
    ;
        (
            Input = resposta(QuizSelecionado) ->
            true
        ;
            false
        )
    ).

limpaTela :-
    clearScreen,
    setCursorPosition(0, 0).

voltaCasa(X, Tabuleiro, Requisitos) :-
    modificarTabuleiro(Tabuleiro, 'X', X, NovoTabuleiroErro),
    limpaTela,
    exibirTabuleiro(NovoTabuleiroErro),
    writeln('Você voltou uma casa!'),
    writeln('Pressione ENTER para jogar o dado novamente.'),
    read_line(_),
    rodaDado(Dado),
    format('Você tirou ~d no dado!~nPressione ENTER para avançar!', [Dado]),
    read_line(_),
    NovoIdCasa is X + Dado,
    modificarTabuleiro(NovoTabuleiroErro, 'X', NovoIdCasa, NovoTabuleiro),
    singlePlayer(NovoIdCasa, NovoTabuleiro, Requisitos).

rodaDado(Dado) :-
    random_between(1, 4, Dado).

rodaDadoCarta(Dado) :-
    random_between(1, 13, Dado).

avancaCasa(X, Tabuleiro, Requisitos) :-
    modificarTabuleiro(Tabuleiro, "X", X_Str, NovoTabuleiroErro),
    limpaTela,
    exibirTabuleiro(NovoTabuleiroErro),
    writeln("Você avançou uma casa!"),
    read_line(_),
    rodaDado(Dado),
    format("Você tirou ~w no dado!~nPressione ENTER para avançar.", [Dado]),
    read_line(_),
    NovoX is X + Dado,
    number_string(NovoX, NovoX_Str),
    modificarTabuleiro(NovoTabuleiroErro, "X", NovoX_Str, NovoTabuleiro),
    singlePlayer(NovoX, NovoTabuleiro, Requisitos).

