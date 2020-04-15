function out = runGA(problem,param)

  %Problem | talvez assim não esteja mt legal pq ocupa mt memória
  CostFunc = problem.CostFunction;
  nVar     = problem.nVar;
  varMin   = problem.varMin;
  varMax   = problem.varMax;
  varSize  = [1,nVar];
  tol      = problem.tol;
  
  %Parâmetros
  maxIt = param.maxIteration;
  nPop  = param.nPop;
  pC    = param.pC;
  nC    = round(pC*nPop/2)*2;%garante que seja um inteiro multiplo de 2
  mu    = param.mu;
  beta  = param.beta;
  sigma = param.sigma;
  gamma = param.gamma;
  
  %%Template do individuo
  empty_individual.Position = [];
  empty_individual.Cost     = [];  
 
  %% Melhor solução encontrada
  bestSolution.Cost = inf;
 
  %% INICIALIZAÇÃO
  pop = repmat(empty_individual,nPop,1);
  for i = 1:nPop
    
    %Gera uma solução aleatória
    pop(i).Position = unifrnd(varMin,varMax,varSize);
    
    %Avalia a solução aleatória
    pop(i).Cost     = CostFunc(pop(i).Position);
    
    %Compara a solução com a melhor solução já encontrada
    if pop(i).Cost < bestSolution.Cost 
      bestSolution.Cost = pop(i).Cost;
      bestSolution = pop(i);
    end
  end
  
  % Melhor custo por iteração
  bestCost = nan(maxIt,1);
  
  
  %% LOOP PRINCIPAL
  for it = 1:maxIt
    
    %Probabilidade de seleção
    c = [pop.Cost];
    avgc = mean(c);
    if avgc ~= 0
      c = c/avgc; 
    end 
    probs = exp(-beta*c);
    
    %Inicializa a população de filhos
    popc = repmat(empty_individual,nC/2,2);
    
    %Cruzamento
    for k = 1:nC/2
      %%Seleciona os pais | seleção aleatória
      %q = randperm(nPop);%gera uma permutação aleatória com o número de elementos da população
      %p1 = pop(q(1));%pega o primeiro elemento da permutação. Estes elementos do cruzamento precisam ser diferentes
      %p2 = pop(q(2));
      
      
      %Seleciona os pais | Seleção por roleta
      p1 = pop(roulletWheelSelection(probs));
      p2 = pop(roulletWheelSelection(probs));

      
      %Faz o cruzamento      
      [popc(k,1).Position, popc(k,2).Position] = uniformCrossover(p1.Position,p2.Position,gamma);
      
    end
    
    %converte popc para uma matriz de uma só coluna
    popc = popc(:);
    
    %Mutação
    for l = 1:nC
        %Faz a mutação
        popc(l).Position = Mutate(popc(l).Position,mu, sigma);
        
        %Checa o limite inferior
        popc(l).Position = max(popc(l).Position,varMin);
        
        %Checa o limite superior
        popc(l).Position = min(popc(l).Position,varMax);
        
        
        %avalia a solução
        popc(l).Cost = CostFunc(popc(l).Position);
        
        if popc(l).Cost < bestSolution.Cost 
          bestSolution.Cost = popc(l).Cost;
          bestSolution = popc(l);
        end
        
    end
    
    % Merge populations
    pop = [pop;popc];
    
    %Ordena a população
    [~,sOrder] = sort([pop.Cost]);
    pop = pop(sOrder);
    
    %Remove os valores extras 
    pop = pop(1:nPop);
    
    %Atualiza o melhor custo encontrado nesta iteração
    bestCost(it) = bestSolution.Cost;
    
    %Mostra informações por iteração
    disp(['Iteration ' num2str(it) ': Best cost = ' num2str(bestCost(it))]);
 
 end
  
  %% Resultados
  out.pop = pop;
  out.bestSolution = bestSolution;
  out.bestCost = bestCost;
  
  
end