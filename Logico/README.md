# 🎮 CRAcking The Game

<p align="justify">
  Jogo desenvolvido em Prolog para aplicar conceitos aprendidos ao longo da disciplina de Paradigmas de Linguagem de Programação, ministrada pelo Prof. Dr. Everton Leandro Galdino Alves, no Curso Ciência da Computação, do UFCG - Campus Campina Grande, em 2023. O jogo consiste em trilhar as disciplinas obrigatórias de CC para caminhar pelo tabuleiro, passando pelos requistos do caminho.
</p>

## 🚀 Iniciando Paradigma Lógico
1. É necessário ter uma versão de [Prolog](https://www.swi-prolog.org/ "Página inicial de Prolog") com SWI-PROLOG instalada em sua máquina
  > 💡 Na página de Downloads, há especificaçãod e como instalar em cada sistema  operacional. [SWI-Prolog/Downloads](https://www.swi-prolog.org/Download.html "Página inicial do instalador")

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
  - Tenha certeza de que está no diretório `CRAckingTheGame/Logico/app`
  - Inicie a execução com o comando `swipl -o -f Main.pl`
  ```
  cd CRAckingTheGame/Logico/app
  swipl -o -f Main.pl
  ```
  > 💡 ou pela própria interface gráfica do SWI-PROLOG
  - Utilize seu Gerenciador de Arquivos para achar o arquivo [app/Main.pl](./app/Main.pl)

  - Clique com Botão Direito e abra com o aplicativo SWI-PROLOG baixado.

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
