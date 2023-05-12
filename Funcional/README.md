# 🎮 CRAcking The Game

<p align="justify">
  Jogo desenvolvido em Haskell para aplicar conceitos aprendidos ao longo da disciplina de Paradigmas de Linguagem de Programação, ministrada pelo Prof. Dr. Everton Leandro Galdino Alves, no Curso Ciência da Computação, do UFCG - Campus Campina Grande, em 2023. O jogo consiste em trilhar as disciplinas obrigatórias de CC para caminhar pelo tabuleiro, passando pelos requistos do caminho.
</p>

## 🚀 Iniciando Paradigma Funcional
1. É necessário ter uma versão de [Haskell](https://www.haskell.org/ "Página inicial de Haskell") com cabal instalada em sua máquina
  > 💡 recomendamos instalar através do intalador universal [GHCup](https://www.haskell.org/ghcup/ "Página inicial do instalador")
2. Baixe o repositório
 - Usando Git
  ```
  git clone https://github.com/lucasmedss/CRAckingTheGame.git
  ```
  - Usando GitHub CLI
  ```
  gh repo clone lucasmedss/CRAckingTheGame
  ```
  > 💡 ou da maneira que você preferir

3. Execute o arquivo 
  - Abra o prompt de comando de sua máquina
  - Tenha certeza de que está no diretório `CRAckingTheGame/Funcional`
  - Inicie a execução com o comando `cabal run`
  ```
  cd CRAckingTheGame/Funcional
  cabal run
  ```

---

### ⚙️ Possível erro de codificação no Windows
<p align="justify">
  Caso esteja executando o código no Windows, é possível que os caracteres especiais, como acentos, não sejam exibidos corretamente. Isso não afeta a execução do jogo, mas é uma experiência visualmente ruim. Para corrigir isso, basta alterar a codificação do Windows para UTF-8 seguindo os passos abaixo.
</p>

1. Abra o Painel de Controle;
2. Selecione "Relógio e Região";
3. Selecione "Região";
4. Na guia "Administrativo", clique no botão "Alterar localidade do sistema";
5. Ative a opção "Usar Unicode UTF-8 para suporte de linguagem mundial";
