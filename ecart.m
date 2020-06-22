function [evalecart] = ecart(x1,M,sig)
n=4*sig;
[X,Y] = meshgrid(-n:n,-n:n); % Génération du maillage associé à la fonction evalecar
evalecart=x1(3)*exp(-((X-x1(1)).^2+(Y-x1(2))^2)/(2*sig)) -M;
