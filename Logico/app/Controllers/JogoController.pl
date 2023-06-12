:- module('JogoController', [roda_jogo/3, interacao/4, esperar_enter/0, roda_dado/1]).

:- use_module(library(random)).
:- use_module('Models/Casa', [getNomeCasa/2, getDescricaoCasa/2, getRequisitosCasa/2, isCasaComplementar/1]).
:- use_module('Models/Quiz', [getQuizCasa/3, getQuizPerguntaCasa/3, getQuizAlternativaCasa/4, getRespostaCasa/3]).
:- use_module('Models/Carta', [getNomeCarta/2, getDescricaoCarta/2, getTipoCarta/2]).
:- use_module('TabuleiroController', [exibirTabuleiro/1, modificarTabuleiro/4]).
:- use_module('MenuController', [limpar_tela/0]).

roda_jogo(0, Tabuleiro, _) :-
    writeln('Seja bem-vindo ao CRAcking the Game!'),
    exibirTabuleiro(Tabuleiro),
    writeln('Rode o dado para começar o jogo!'),
    esperar_enter,
    roda_dado(Dado),
    modificarTabuleiro(Tabuleiro, "X", Dado, NovoTabuleiro),
    roda_jogo(Dado, NovoTabuleiro, _).

roda_jogo(IdCasa, _, _) :-
    IdCasa =:= 33, 
    write('ACABOU O JOGO'), nl.

roda_jogo(IdCasa, Tabuleiro, CadeirasCursadas) :-
    limpar_tela,
    getDescricaoCasa(IdCasa, DescricaoCasa),
    writeln(DescricaoCasa),
    exibirTabuleiro(Tabuleiro),
    interacao(IdCasa, Resultado, Tabuleiro, CadeirasCursadas),
    (   Resultado == true ->
        roda_dado(Dado),
        NovoValor is IdCasa + Dado
    ;   NovoValor is IdCasa - 1
    ),
    modificarTabuleiro(Tabuleiro, "X", NovoValor, NovoTabuleiro),
    roda_jogo(NovoValor, NovoTabuleiro, CadeirasCursadas).

roda_dado(Resultado) :-
    random(1, 5, Resultado),
    format('Você jogou o dado e irá avançar ~w casa(s)!\n', [Resultado]),
    esperar_enter.

seleciona_quiz(IdQuiz) :-
    random(1, 4, IdQuiz).

seleciona_acao(Acao) :-
    %1 eh avancar ou voltar casa, 2 eh coisa de cra diminuir aumentar sla dps ajeitar pra (1, 2)
    random(1, 2, Acao). 

seleciona_carta(IdCarta) :-
    random(1, 13, IdCarta).

adicionar_elemento(Elemento, Lista, NovaLista) :-
    NovaLista = [Elemento | Lista].

interacao(IdCasa, Resultado, Tabuleiro, CadeirasCursadas) :-
    getDescricaoCasa(IdCasa, DescricaoCasa),
    getRequisitosCasa(IdCasa, RequisitosCasa),
    getNomeCasa(IdCasa, NomeCasa),

    cumpreRequisitos(CadeirasCursadas, RequisitosCasa, CumpriuRequisitos),
    (   CumpriuRequisitos = false ->
        adicionar_elemento(NomeCasa, CadeirasCursadas, NovasCadeiras),
        NovaPosicao is IdCasa - 1,
        modificarTabuleiro(Tabuleiro, "X", NovaPosicao, NovoTabuleiro),
        roda_jogo(NovaPosicao, NovoTabuleiro, NovasCadeiras)
        ),
    

    writeln(DescricaoCasa),
    (   IdCasa = 13 ->
        writeln('Aproveite e siga o jogo!'),
        esperar_enter,
        Resultado = true
        ;
        (   isCasaComplementar(IdCasa) ->
            seleciona_carta(IdCarta),
            esperar_enter,
            printa_carta(IdCarta),
            getTipoCarta(IdCarta, TipoCarta),
            (   TipoCarta = "positiva" ->
                acaoPositiva(IdCasa, Tabuleiro, CadeirasCursadas)
                ;   
                acaoNegativa(IdCasa, Tabuleiro, CadeirasCursadas)
            )
            ;
            seleciona_quiz(IdQuiz),
            printa_casa(IdCasa, IdQuiz),
            ler_resposta(RespostaUsuario),
            getRespostaCasa(IdCasa, IdQuiz, RespostaQuiz),
            (   RespostaUsuario = RespostaQuiz ->
                writeln('Resposta correta! Jogue o dado novamente para continuar!'),
                esperar_enter,
                Resultado = true,
                append(CadeirasCursadas, [NomeCasa], CadeirasCursadas),

            ;    writeln('Resposta incorreta! Você voltará uma casa!'),
                esperar_enter,
                Resultado = false
            )
        )
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

printa_carta(IdCarta) :-
    getNomeCarta(IdCarta, Nome),
    writeln(Nome),
    getDescricaoCarta(IdCarta, Descricao),
    writeln(Descricao).

acaoPositiva(IdCasaAtual, Tabuleiro, CadeirasCursadas) :-
    seleciona_acao(Acao),
    (   Acao == 1 ->
        IdCasaNovo is IdCasaAtual + 1,
        writeln('Você avançará uma casa!'),
        esperar_enter,
        modificarTabuleiro(Tabuleiro, "X", IdCasaNovo, NovoTabuleiro),
        roda_jogo(IdCasaNovo, NovoTabuleiro, CadeirasCursadas)
    % ; acao == 2 etcc etc   
    ).

acaoNegativa(IdCasaAtual, Tabuleiro, CadeirasCursadas) :-
    seleciona_acao(Acao),
    (   Acao == 1 ->
        IdCasaNovo is IdCasaAtual - 1,
        writeln('Você voltará uma casa!'),
        esperar_enter,
        modificarTabuleiro(Tabuleiro, "X", IdCasaNovo, NovoTabuleiro),
        roda_jogo(IdCasaNovo, NovoTabuleiro, CadeirasCursadas)
    % ; Acao == 2 etcc
    ).

esperar_enter :-
    writeln('Pressione ENTER para prosseguir.'),
    get_single_char(_),
    nl.

cumpreRequisitos(_,[ ], true).
cumpreRequisitos(CadeirasCursadas, [Requisito|OutrosRequisitos], CumpriuRequisitos) :-
    (   member(Requisito, CadeirasCursadas) ->
        cumpreRequisitos(CadeirasCursadas, OutrosRequisitos, CumpriuRequisitos)
    ;   CumpriuRequisitos = false
    ).