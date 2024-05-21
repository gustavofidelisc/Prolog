%-------------------------------------------------------------------------
%             Unifal - Universidade Federal de Alfenas
%                BACHARELADO EM CIÊNCIA DA COMPUTAÇÃO
% Trabalho..: Árvore Binária com fatos dinâmicos
% Disciplina: Programação Lógica
% Professor.: Luiz Eduardo da Silva
% Aluno.....: Gustavo Fidelis Camilo
% Data......: 20/05/2024
%-------------------------------------------------------------------------

% no(Info, Esquerda, Direita)
:-dynamic(no/3).

%no_raiz(Info, Esquerda, Direita)
:-dynamic(no_raiz/3).

% ---------------------------- Insere ----------------------------------------

%Inserir a raiz.
inserir_raiz(X):-
    assert(no_raiz(X,[],[])).

inserir(X) :-
    no_raiz(A,E,D),
    A = [],
    retract(no_raiz(A,E,D)),
    assert(no_raiz(X,[],[])).

%Insere qualquer nó depois que a raíz existe.
inserir(X) :-
    %Seleciona o fato no_raiz
    no_raiz(A,E,D),

    %Verifica se o nó na raiz já foi inserido.
    A \= X,
    E \= X,
    D \= X,

    %Busca o pai do nó que vou inserir
    busca_pai(X, no(A,E,D), no(A1, E1,D1)),

    %Trata nó raiz ser diferente de no
    (A1 \= A, retract(no(A1,_,_)) ; retract(no_raiz(A1,_,_))),
    (A1 \= A, asserta(no(A1, E1,D1)) ; asserta(no_raiz(A1, E1,D1))),

    %Aloca o nó folha que quero inserir
    assert(no(X,[],[])).

%Para o nó a esquerda
busca_pai(X,no(A,E,D), no(A, E1,D )) :- 
    E1 is X, X < A, E = [], !.

%Para o nó a direita
busca_pai(X, no(A,E,D), no(A, E, D1)) :- 
    D1 is X, X > A , D = [], !.

%Para o nó a esquerda
busca_pai(X,no(A,E,_), no(E3, E1, D1)) :- 
    X < A, no(E, E2, D2), busca_pai(X,  no(E, E2, D2), no(E3, E1,D1)), !.

%Para o nó a direita
busca_pai(X, no(A,_,D), no(D3, E1, D1)) :- 
    X > A , no(D, E2, D2), busca_pai(X, no(D, E2,D2), no(D3, E1, D1)), !.


%----------------------------------------------------------------------------

%---------------- Pre Ordem ------------------------------------
preordem :- 
    no_raiz(A,E,D),
    assert(no(A,E,D)),
    preordemm(A), nl,
    retract(no(A,E,D)), !.

preordemm([]).
preordemm(X):- write(X), write(' '), no(X,E,D),
 preordemm(E),
 preordemm(D).

%-------------------Em Ordem ----------------------
emordem :- 
    no_raiz(A,E,D),
    assert(no(A,E,D)),
    emordemm(A), nl,
    retract(no(A,E,D)), !.

emordemm([]).
emordemm(X):-  no(X,E,D),
 emordemm(E),
 write(X), write(' '),
emordemm(D).

%-------------Pos ordem -------------------------
posordem :- 
    no_raiz(A,E,D),
    assert(no(A,E,D)),
    posordemm(A), nl,
    retract(no(A,E,D)), !.

posordemm([]).
posordemm(X):-  no(X,E,D),
 posordemm(E),
 posordemm(D),
 write(X), write(' ').
%-----------------------------------------------

% -------------------- Apagar noh ----------------------------
apagar(X) :-
    no_raiz(A,E1,D1),
    (X = A, (
        E1=[], D1 =[], apaga(no(A,E1,D1))
        ; 
        E1 \= [], E1 \= [], apaga(no(A,E1,D1)) )
        ;  
        A2 is X,   
        no(X,E,D),
        A2 = X,
        apaga(no(X,E,D))
    ), !.

busca_pai_no(X, no(A, X, D)) :-
    no(A,X, D).

busca_pai_no(X, no(A, E, X)) :-
    no(A,E, X).

%apaga a raiz sem filhos

apaga(no(X,E,D)) :-
    no_raiz(A,E,D),
    X=A,
    E=[],
    D=[],
    retract(no_raiz(A,E,D)),
    assert(no_raiz([],[],[])).


%apaga no sem filhos
apaga(no(X,E,D)) :- 
    E=[],
    D=[],
    no_raiz(A,E1,D1),
    assert(no(A,E1,D1)),
    busca_pai_no(X, no(A2,E2,D2)),
    ( A = A2 , (
            X = E2, retract(no(A,E1,D1)) ,retract(no_raiz(A,E1,D1)), assert(no_raiz(A2, [], D2))
            ; 
            retract(no(A,E1,D1)) ,retract(no_raiz(A,E1,D1)), assert(no_raiz(A2,E2,[]))
        ) ;

        ( 
            X = E2, retract(no(A,E1,D1)), retract(no(A2,E2,D2)), assert(no(A2, [], D2))
            ; 
            retract(no(A,E1,D1)), retract(no(A2,E2,D2)), assert(no(A2,E2,[]))
        )
        
    ),
    retract(no(X, E, D)).

%apaga no com um filho a esquerda
apaga(no(X,E,D)) :-
    D=[],
    E\=[],
    no_raiz(A1, E1,D1),
    assert(no(A1,E1,D1)),
    retract(no(X, E,D)),
    busca_pai_no(X, no(A2, E2,D2)),
    (A2 = A1, 
        retract(no_raiz(A1,E1,D1)),
        assert(no_raiz(A2,E,D2)),
        retract(no(A1,E1,D1))
        ;
        retract(no(A2, E2,D2)),
        assert(no(A2,E,D2)),
        retract(no(A1,E1,D1))
    ).
    

%apaga no com filho a direita
apaga(no(X,E,D)) :-
    E =[],
    D \=[],
    no_raiz(A1, E1,D1),
    assert(no(A1,E1,D1)),
    retract(no(X, E,D)),
    busca_pai_no(X, no(A2, E2,D2)),
    (A2 = A1,
        retract(no_raiz(A1,E1,D1)),
        assert(no_raiz(A2,E2,D)),
        retract(no(A1,E1,D1))
        ;
        retract(no(A2, E2,D2)),
        assert(no(A2,E2,D)),
        retract(no(A1,E1,D1))
    ).

%apaga a raiz com dois filhos
apaga(no(X,_,_)) :-
    no_raiz(A1, E1, D1),
    X = A1,
    assert(no(A1,E1,D1)),
    retract(no_raiz(A1,E1,D1)),
    no(E1,E2, D2),
    busca_maior_esq(no(E1,E2, D2), no(A3,E3, D3)),
    busca_pai_no(A3, no(A4,E4,D4)),
    (A4 = A1, 
        retract(no(A3,E3,D3)),
        retract(no(A1,E1,D1)),
        assert(no_raiz(A3, E2,D1))
        ;
        busca_maior_esq(no(D2,E4,D4), no(A5,E5, D5)),
        busca_pai_no(A5, no(A6,E6,D6)),
        retract(no(A5,E5,D5)),
        assert(no_raiz(A5, E1,D1)),
        retract(no(A1,E1,D1)),
        retract(no(A6,E6,D6)),
        assert(no(A6, E6, E5))
     ).



%apagar nó com dois filhos Lado Direito da Arvore
apaga(no(X,E,D)) :-
    no_raiz(A1,E1,D1),
    X > A1,
    assert(no(A1,E1,D1)),
    busca_pai_no(X, no(A2,E2,D2)),
    no(D,E4,D4),
    busca_menor_dir(no(D,E4,D4), no(A3,E3,D3)),

    (A2 \= A1,
        retract(no(A2,E2,D2)),
        assert(no(A2,E2 ,A3)),
        retract(no(X,E,D)),
        assert(no(A3,E,D3)),
        retract(no(D,E4,D4)), 
        assert(no(D, E3,D4)),
        retract(no(A3,E3,D3)), 
        retract(no(A1,E1,D1))
        ;

        retract(no_raiz(A1,E1,D1)),
        assert(no_raiz(A1,E1,A3)),
        retract(no(X,E,D)),
        assert(no(A3,E,D3)),
        retract(no(D,E4,D4)), 
        assert(no(D, E3,D4)),
        retract(no(A3,E3,D3)), 
        retract(no(A1,E1,D1))
    ).

   

%apagar nó com dois filhos Lado Esquerdo da Arvore

apaga(no(X,E,D)) :-
    no_raiz(A1,E1,D1),
    X < A1,
    %aloca no raiz aos nos
    assert(no(A1,E1,D1)),
    busca_pai_no(X, no(A2,E2,D2)),
    no(E,E4,D4),
    busca_maior_esq(no(D,E4,D4), no(A3,E3,D3)),
    (
        A2 \= A1,
        %desaloca o nó pai do que vai ser apagada
        retract(no(A2,E2,D2)),
        %Aloca pai corretamente
        assert(no(A2,A3,D2)),
        %Remove o no que deve ser retirado
        retract(no(X,E,D)),
        %atualiza o no que deve ser retirado
        assert(no(A3,E,D3)),
        retract(no(E,E4,D4)), 
        %aloca fato  pai do que será apagado
        assert(no(E, E4,D3)),
        %apaga nó folha
        retract(no(A3,E3,D3)), 
        %apaga cópia do nó raiz.
        retract(no(A1,E1,D1))
        ;
        %desaloca o nó pai do que vai ser apagada
        retract(no_raiz(A1,E1,D1)),
        %Aloca pai corretamente
        assert(no_raiz(A1,A3,D1)),
        %Remove o no que deve ser retirado
        retract(no(X,E,D)),
        %atualiza o no que deve ser retirado
        assert(no(A3,E,D3)),
        retract(no(E,E4,D4)), 
        %aloca fato  pai do que será apagado
        assert(no(E, E4,D)),
        %apaga nó folha
        retract(no(A3,E3,D3)), 
        %apaga cópia do nó raiz.
        retract(no(A1,E1,D1))
    ).
    


busca_menor_dir(no(A1,E1,D1), no(A1,E1,D1)) :-
    E1 = [].

busca_menor_dir(no(_,E1,_), no(A2,E2,D2)) :-
    E1 \= [],
    no(E1, E3,D3),
    busca_menor_dir(no(E1, E3,D3), no(A2,E2,D2)).

busca_maior_esq(no(A1,E1,D1), no(A1,E1,D1)) :-
    D1 = [].

busca_maior_esq(no(_,_,D1), no(A2,E2,D2)) :-
    D1 \= [],
    no(D1, E3,D3),
    busca_menor_dir(no(D1, E3,D3), no(A2,E2,D2)).


menu :-
    writeln('1 - Inserir noh raiz'),
    read(X),
    inserir_raiz(X),
    repeat,
    writeln('Escolha uma opção:'),
    writeln('1 - Inserir noh'),
    writeln('2 - Remover noh'),
    writeln('3 - Exibir arvore em pre-ordem'),
    writeln('4 - Exibir arvore em em-ordem'),
    writeln('5 - Exibir arvore em pos-ordem'),
    writeln('6 - Sair'),

    read(Opcao),
    executar_opcao(Opcao) ,
  ( Opcao == 6 -> ! ; fail).

%encontrar raiz

% Executar a opção selecionada pelo usuário
    
executar_opcao(1) :-
    write('Digite o valor do noh a ser inserido: '),
    read(Valor),
    inserir(Valor), !.

executar_opcao(2) :-
    write('Digite o noh a ser removido: '),
    read(Valor),
    apagar(Valor), !.

executar_opcao(3) :-
   preordem, !.

executar_opcao(4) :-
   emordem, !.

executar_opcao(5) :-
   posordem, !.

executar_opcao(6) :-
    limpa,
    write('Saindo...') ,!.

lista_nos:-
 no(X,E,D),
 writeln(X, E, D),
 fail.

lista_nos.	

limpa :- abolish(no/3), abolish(no_raiz/3).