:- module(tabuleiro, [
    getTabuleiro/1,
    exibirTabuleiro/1,
    getLinha/3,
    getColuna/3,
    getPosicao/3,
    modificarTabuleiro/4,
    replaceChar/4
]).

:- use_module(library(lists)).
:- use_module(library(system)).

getTabuleiro(Tabuleiro) :-
    read_file_to_codes('./database/tabuleiro.txt', TabuleiroCodes),
    string_codes(TabuleiroString, TabuleiroCodes),
    split_string(TabuleiroString, "\n", "", Tabuleiro).

exibirTabuleiro(Tabuleiro) :-
    atomic_list_concat(Tabuleiro, '\n', TabuleiroString),
    writeln(TabuleiroString).

getLinha([], _, _, -1).
getLinha([X | XS], Casa, Index, Linha) :-
    (   sub_string(X, _, _, _, Casa) ->
        Linha = Index
    ;   NextIndex is Index + 1,
        getLinha(XS, Casa, NextIndex, Linha)
    ).

getColuna(Linha, Casa, 0) :-
    sub_string(Linha, 0, _, _, Casa).
getColuna(Linha, Casa, Coluna) :-
    sub_string(Linha, 1, _, _, Resto),
    getColuna(Resto, Casa, NextColuna),
    (   NextColuna \= -1 ->
        Coluna is NextColuna + 1
    ;   Coluna = -1
    ).

getPosicao(Tabuleiro, Casa, (Linha, Coluna)) :-
    getLinha(Tabuleiro, Casa, 0, Linha),
    nth0(Linha, Tabuleiro, LinhaTabuleiro),
    getColuna(LinhaTabuleiro, Casa, Coluna).

modificarTabuleiro(Tabuleiro, Jogador, Posicao, NovoTabuleiro) :-
    (   number_string(PosicaoNum, Posicao),
        PosicaoNum > 33 ->
        ProximaPosicao = "CC"
    ;   ProximaPosicao = Posicao
    ),
    getPosicao(Tabuleiro, Jogador, Atual),
    nth0(0, Atual, LinhaAtual),
    nth0(1, Atual, ColunaAtual),
    replaceChar(LinhaAtual, ColunaAtual, ' ', LinhaTabuleiro, NovaLinha),
    replace(Tabuleiro, LinhaAtual, NovaLinha, TabuleiroAtualizado),
    getPosicao(TabuleiroAtualizado, ProximaPosicao, Proximo),
    nth0(0, Proximo, LinhaProximo),
    nth0(1, Proximo, ColunaProximo),
    (   Jogador = "X" ->
        PosicaoJogador is ColunaProximo + 1
    ;   PosicaoJogador = ColunaProximo
    ),
    replaceChar(LinhaProximo, PosicaoJogador, Jogador, LinhaTabuleiroProximo, NovaLinhaProximo),
    replace(TabuleiroAtualizado, LinhaProximo, NovaLinhaProximo, NovoTabuleiro).

replaceChar(Index, Char, String, NewString) :-
    sub_string(String, 0, Index, _, Substring1),
    sub_string(String, _, Index, 0, Substring2),
    string_concat(Substring1, Char, Temp),
    string_concat(Temp, Substring2, NewString).