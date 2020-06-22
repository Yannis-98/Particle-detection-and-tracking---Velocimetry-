%% Programme permettant de trouver les vecteurs associées à chauqe particule
% Le temps d'execution est assez conséquant
clc
clear all
close all

%% Importation des images

[filename, pathname] = uigetfile({'*.tiff;*.png'},'Select ... images ','MultiSelect','on');
                       
if isequal(filename,0)
    disp('User selected Cancel')
    return 
end
cd(pathname);
%% Interaction avec l'utilisateur pour savoir quel vecteur affiché à la fin
% Si on entre 1, alors le vecteur vitesse correspondra à l'image 1

Q=-1

% Permet de controler si Q est bien un entier acceptable
while ((Q>=size(filename,2))|(Q<0)|(Q-floor(Q))~=0) 
    Q=input('Quel vecteur vitesse voulez vous afficher à la fin du programme ?\n')
end


%% Boucle sur toute les images
for j=1:size(filename,2)
    %% lecture de la premiere image, determination de sa taille
    
    I = imread(filename{j});
    [sx, sy] = size(I);

    %% Recherche des milieux sur l'image I

    % dilatation des particules
    se=strel('sphere',3); 
    dilate=imdilate(I, se);
    k=find(I==dilate); %comparaison entre particule dilatée ou non, k est un l'indice des points répondant à la comparaison

    % double conditions, filtrage
    I1=I(k); %filtrage de l'image I
    k1=find(I1>20); % on regarde les particules ayant une intensité supérieur à 20
    k2=k(k1);       
    I2=I(k2);
    [Row,Col]=ind2sub(size(I),k2); % indice des candidats
    I2=I; %image clone de I
    len=4; %on prend un décalage de 4
    P=4 %décalage 
    I2=wextend(2,'zpd',I2,len); %On prolonge l'image, afin d'analyser les particules aux bords
    for i=1:size(Row,1)
            M=I2(len + Row(i)-P:len + Row(i)+P,+len + Col(i)-P:len + Col(i)+P);
            M=double(M);
            x0=[0.0;0.0;max(M(:))*1.0];
            x0=double(x0);
            sigma2=1; %paramètre pixellisation
            [x2sol]=lsqnonlin(@(x1)ecart(x1,M,sigma2),x0); % Positions des centres
            abs(i,j)=x2sol(1)+Col(i); %Stockage des positions des centres 
            ord(i,j)=x2sol(2)+Row(i);
    end
end

%% champs de vecteurs

    dmax=30 % rayon de recherche
    
% boucle sur les images
    for j=1:(size(filename,2)-1)
        
        %% recherche des particules correspondantes entre l'image t-1 et t
        
        for (p=1:size(abs,1))
            x0=abs(p,j); %particule à T
            y0=ord(p,j); %particule à T
            [distance2, indice2]=fonction_sort(x0,y0,6, abs(:,j), ord(:,j)); % on cherche les particules les plus proches dans un rayon de recherche
            R0=corr2(distance2,distance2); % corrélation = 1 car même distance
            R0_min=1000000;
            for (i=1:size(abs,1))
                if (sqrt((abs(i,j+1)-x0)^2+(ord(i,j+1)-y0)^2) < dmax) % critère : si la particule se situe dans le rayon de recherche
                    x0_2=abs(i,j+1);    % particules t ième images
                    y0_2=ord(i,j+1);
                    [distance2_2, indice2_2]=fonction_sort(x0_2,y0_2,6,abs(:,j+1),ord(:,j+1)); % calcule de la distance entre particule T et T+1
                    R0_2=corr2(distance2,distance2_2); % corrélation entre t-1 et t                  
                    if ((R0-R0_2)<R0_min)                  % si corrélation la plus grande alors     
                         R0_min=R0-R0_2; % actualisation du minimum
                         xf=x0_2; % coordonnées de la particule choisi
                         yf=y0_2;
                         i_f=i; % sauvegarde des paramètres de l'élu                         
                    end
                end
            end
            POS(p)=i_f; % sauvegarde des particules cherchées à instant t
        end

        %% Création des vecteurs vitesses
       
        for k=1:size(abs,1)    
            dX(k,j)=abs(POS(k),j+1)-abs(k,j); % calcul des vecteurs positions
            dY(k,j)=ord(POS(k),j+1)-ord(k,j);
        end
    end
  
%% affichage des resultats

    [xq,yq]=meshgrid(0:1:size(I,2),0:1:size(I,1));
    dxq=griddata(abs(:,Q),ord(:,Q),dX(:,Q),xq,yq);
    dyq=griddata(abs(:,Q),ord(:,Q),dY(:,Q),xq,yq);
    figure;
    quiver(xq,yq,dxq,dyq)
    hold on
    plot(abs(:,Q), ord(:,Q),'r.', 'DisplayName',['Centre image ',num2str(Q)])
    hold on
    plot(abs(:,Q+1), ord(:,Q+1),'r.', 'DisplayName',['Centre image ',num2str(Q+1)])
    title (['Vecteurs vitesse pour image ',num2str(Q)]) 
    legend show
    axis image

%% sauvegarde des resultats

save Vecteurs_Vitesse.mat