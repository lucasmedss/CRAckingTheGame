getTabuleiro(Tabuleiro) :-
    read_file_to_string('../database/tabuleiro.txt', TabuleiroString, []),
    split_string(TabuleiroString, "\n", "", Tabuleiro).

exibirTabuleiro(Tabuleiro) :-
    maplist(writeln, Tabuleiro).

modificarTabuleiro(Tabuleiro, Jogador, Posicao, NovoTabuleiro) :-
    (   Posicao > 33 ->
        ProximaInt = "CC"
    ;   ProximaInt = Posicao
    ),
    format(atom(ProximaPosicao), '~|~`0t~d~2+', [ProximaInt]),
    getPosicao(Tabuleiro, Jogador, 0, LinhaAtual, ColunaAtual),
    replace(Tabuleiro, LinhaAtual, ColunaAtual, " ", TabuleiroTemp),
    getPosicao(Tabuleiro, ProximaPosicao, 0, LinhaProximo, ColunaProximo),
    ProximaLinha is LinhaProximo - 1,
    (   Jogador = "X" ->
        ProximaColuna is ColunaProximo + 1
    ;   ProximaColuna is ColunaProximo
    ),
    replace(TabuleiroTemp, ProximaLinha, ProximaColuna, Jogador, NovoTabuleiro).

getPosicao([], _, _, -1, -1).
getPosicao([X|XS], Casa, Index, Linha, Coluna) :-
    (   sub_string(X, Coluna, _, _, Casa) ->
        Linha is Index
    ;   NewIndex is Index + 1,
        getPosicao(XS, Casa, NewIndex, Linha, Coluna)
    ).

replace(Tabuleiro, Linha, Coluna, Caractere, NovoTabuleiro) :-
    nth0(Linha, Tabuleiro, LinhaTabuleiro),
    replaceLinha(LinhaTabuleiro, Coluna, Caractere, NovaLinha),
    slice(Tabuleiro, 0, Linha, ParteAntes),
    append(ParteAntes, [NovaLinha], TabuleiroTemp),
    ProximaLinha is Linha + 1,
    slice(Tabuleiro, ProximaLinha, 18, ParteDepois),
    append(TabuleiroTemp, ParteDepois, NovoTabuleiro).

replaceLinha(Linha, Posicao, NovoCaractere, NovaLinha) :-
    sub_string(Linha, 0, Posicao, _, ParteAntes),
    PosicaoMaisUm is Posicao + 1,
    sub_string(Linha, PosicaoMaisUm, _, 0, ParteDepois),
    string_concat(ParteAntes, NovoCaractere, TempLinha),
    string_concat(TempLinha, ParteDepois, NovaLinha).

slice(Lista, Inicio, Fim, Slice) :-
    length(Prefixo, Inicio),
    append(Prefixo, Sufixo, Lista),
    NewFim is Fim - Inicio,
    length(Slice, NewFim),
    append(Slice, _, Sufixo).
