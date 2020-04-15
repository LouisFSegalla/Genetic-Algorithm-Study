clc;
clear;
close all;

%%  Definição do problema
problem.CostFunction = @(x) sphere(x);
problem.nVar = 3;%% resolvendo o problema para X variáveis 

%limites inferiores e superiores do problema
problem.varMin = [-10 -10 -10];
problem.varMax = [ 10  10  10];

problem.tol    = 0.01;

%% Parâmetros do algoritmo genético
param.nPop = 50;
param.maxIteration = 100;

param.pC = 1;
param.mu = 0.01;
param.beta = 1;
param.sigma = 0.1;
param.gamma = 0.1;
%% Rodar o algoritmo
out = runGA(problem,param);

%% Resultados

figure;
plot(out.bestCost,'linewidth',3);
%semilogy(out.bestCost,'linewidth',3);
xlabel('Iterations');
ylabel('Best Cost');
grid on;