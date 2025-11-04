solucao_otimizada(Fila) :-
    
    % 1. Definição do Domínio Completo
    Mulheres    = [viviane, marcela, luana, renata, angela],
    Idades      = [29, 36, 43, 48, 55], 
    Profissoes  = [biologa, editora, professora, delegada, sociologa],
    Livros      = [animais, natureza, mandalas, gatos, flores], 
    Precos      = [15, 20, 25, 30, 35], 
    Bolsas      = [amarela, branca, verde, azul, vermelho], 

    % 2. Geração da Estrutura (5 elementos na Fila)
    Fila = [
        mulher(M1, I1, P1, L1, Pr1, B1),
        mulher(M2, I2, P2, L2, Pr2, B2),
        mulher(M3, I3, P3, L3, Pr3, B3),
        mulher(M4, I4, P4, L4, Pr4, B4),
        mulher(M5, I5, P5, L5, Pr5, B5)
    ],

    % 3. ATRIBUIÇÃO E RESTRIÇÕES FORTES
    
    % Bióloga (P1), Natureza (L1), Delegada (P2), Mandalas (L2), 36 anos (I4), Professora (P4)
    P1 = biologa, L1 = natureza, 
    P2 = delegada, L2 = mandalas, 
    I4 = 36, P4 = professora,

    % Atribui valores do domínio
    % atributos que têm posições fixas ou fortes restrições
    member(P3, Profissoes), member(P5, Profissoes),
    member(L3, Livros), member(L4, Livros), member(L5, Livros),

    % Garante que os valores fixos e atribuídos sejam únicos
    alldifferent([P1, P2, P3, P4, P5], Profissoes),
    alldifferent([L1, L2, L3, L4, L5], Livros),
    
    % A Editora está em uma das pontas.
    ( P5 = editora ; fail ),  % P1 já é Bióloga, então P5 é Editora.
    % Renata está ao lado da mulher Natureza (L1). Natureza na P1 -> Renata na P2.
    M2 = renata,
    
    % 4. Aplicação das Restrições de Vizinhança e Ordem (Otimizadas)
    
    % A dona da bolsa Azul está exatamente à esquerda da mulher de 36 anos (I4).
    B3 = azul,
    % Ângela está em algum lugar entre a Delegada (P2) e a mulher de 36 anos (I4).
    M3 = angela,

    % Marcela está usando uma bolsa Branca. (M_pos = B_pos)
    em_posicao(marcela, m, branca, b, Fila),
    % Viviane está ao lado da mulher da bolsa Amarela.
    ao_lado(viviane, m, amarela, b, Fila),
    
    % --- Atribuições Restantes ---
    
    member(M1, Mulheres), member(M4, Mulheres), member(M5, Mulheres),
    alldifferent([M1, M2, M3, M4, M5], Mulheres),
    
    member(B1, Bolsas), member(B2, Bolsas), member(B4, Bolsas), member(B5, Bolsas),
    alldifferent([B1, B2, B3, B4, B5], Bolsas),
    
    member(I1, Idades), member(I2, Idades), member(I3, Idades), member(I5, Idades),
    alldifferent([I1, I2, I3, I4, I5], Idades),

    member(Pr1, Precos), member(Pr2, Precos), member(Pr3, Precos), member(Pr4, Precos), member(Pr5, Precos),
    alldifferent([Pr1, Pr2, Pr3, Pr4, Pr5], Precos),

    % --- Restrições de Pontas e Ordem ---

    % A cliente mais nova (29) está em uma das pontas. ";" refere-se ao operador OU
    ( I1 = 29 ; I5 = 29 ), 
    % Em uma das pontas está a mulher que vai comprar o livro de colorir de Gatos.
    ( L1 = gatos ; L5 = gatos ),
    % A mulher que comprará o livro de colorir de R$ 25 está em uma das pontas.
    ( Pr1 = 25 ; Pr5 = 25 ),
    
    % A dona da bolsa Branca está em algum lugar entre a dona da bolsa Verde e a Luana, nessa ordem.
    entre(b, verde, b, branca, m, luana, Fila),
    % Quem gastará R$ 20 está em algum lugar entre quem gastará R$ 25 e quem gastará R$ 15, nessa ordem.
    entre(pr, 25, pr, 20, pr, 15, Fila),
    % Quem comprará o livro mais caro (35) está em algum lugar entre quem escolheu o
    % livro de Animais e quem gastará R$ 30, nessa ordem.
    entre(l, animais, pr, 35, pr, 30, Fila),
    % A mulher de 48 anos está em algum lugar entre a Bióloga e a mulher de 43 anos, nessa ordem.
    entre(p, biologa, i, 48, i, 43, Fila), 
    % A dona da bolsa Amarela está em algum lugar entre a mulher mais velha (55) e a Socióloga, nessa ordem.
    entre(i, 55, b, amarela, p, sociologa, Fila).

% ------------------------------------------------
% Predicados de Ajuda
% ------------------------------------------------

% qual_posicao(+Atributo, +Tipo, +Fila, -Posicao)
% Tipo: m (mulher), i (idade), p (profissao), l (livro), pr (preco), b (bolsa)
qual_posicao(A, m, Fila, Pos) :- nth1(Pos, Fila, mulher(A, _, _, _, _, _)).
qual_posicao(A, i, Fila, Pos) :- nth1(Pos, Fila, mulher(_, A, _, _, _, _)).
qual_posicao(A, p, Fila, Pos) :- nth1(Pos, Fila, mulher(_, _, A, _, _, _)).
qual_posicao(A, l, Fila, Pos) :- nth1(Pos, Fila, mulher(_, _, _, A, _, _)).
qual_posicao(A, pr, Fila, Pos) :- nth1(Pos, Fila, mulher(_, _, _, _, A, _)).
qual_posicao(A, b, Fila, Pos) :- nth1(Pos, Fila, mulher(_, _, _, _, _, A)).

% ao_lado(+A1, +Tipo1, +A2, +Tipo2, +Fila)
ao_lado(A1, Tipo1, A2, Tipo2, Fila) :-
    qual_posicao(A1, Tipo1, Fila, Pos1),
    qual_posicao(A2, Tipo2, Fila, Pos2),
    ( Pos1 is Pos2 - 1 ; Pos1 is Pos2 + 1 ).

% entre(+TipoB1, +B1, +TipoA, +A, +TipoB2, +B2, +Fila)
entre(TipoB1, B1, TipoA, A, TipoB2, B2, Fila) :-
    qual_posicao(B1, TipoB1, Fila, PosB1),
    qual_posicao(A, TipoA, Fila, PosA),
    qual_posicao(B2, TipoB2, Fila, PosB2),
    PosB1 < PosA,
    PosA < PosB2.

% em_posicao(+A, +TipoA, +B, +TipoB, +Fila) - Coincidência de Posição
em_posicao(A, TipoA, B, TipoB, Fila) :-
    qual_posicao(A, TipoA, Fila, Pos),
    qual_posicao(B, TipoB, Fila, Pos).

% Predicado para garantir que todos os elementos em L sejam únicos e façam parte do Domínio.
% É um substituto para all_different/1 do clpfd. (BIBLIOTECA QUE AINDA NÃO FOI VISTA EM LABORATÓRIO DE PLIA)
alldifferent(L, Domain) :-
    subset(L, Domain),
    not_duplicates(L).

subset([], _).
subset([H|T], Domain) :- member(H, Domain), subset(T, Domain).

not_duplicates(L) :- sort(L, Sorted), length(L, Len), length(Sorted, Len).