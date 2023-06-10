:- dynamic carta/4.

% Fatos
carta(carta{tipo: Tipo, idCarta: Id, nomeC: Nome, descricaoC: Descricao}) :-
    atom(Tipo),
    integer(Id),
    atom(Nome),
    atom(Descricao).

% Exemplo de fatos
carta(carta{tipo: "Tipo1", idCarta: 1, nomeC: "Nome1", descricaoC: "Descrição1"}).
carta(carta{tipo: "Tipo2", idCarta: 2, nomeC: "Nome2", descricaoC: "Descrição2"}).
carta(carta{tipo: "Tipo3", idCarta: 3, nomeC: "Nome3", descricaoC: "Descrição3"}).

% Recuperar o tipo de uma carta específica
getTipoCarta(CartaId, TipoCarta) :-
    carta(carta{ tipo: TipoCarta, idCarta: CartaId, _, _ }).

% Recuperar o nome de uma carta específica
getNomeCarta(CartaId, NomeCarta) :-
    carta(carta{ tipo: _, idCarta: CartaId, nomeC: NomeCarta, _ }).

% Recuperar a descrição de uma carta específica
getDescricaoCarta(CartaId, DescricaoCarta) :-
    carta(carta{ tipo: _, idCarta: CartaId, _, descricaoC: DescricaoCarta }).