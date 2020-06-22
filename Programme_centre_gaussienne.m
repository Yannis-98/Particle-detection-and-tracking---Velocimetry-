    %% Programme permettant de trouver le centre d'une particule 

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

    %% lecture de la premiere image, determination de sa taille
    
    I = imread(filename);
    [sx, sy] = size(I);

    %% Choix de la taille de l'image test

    Sx=33; Sy=33;
    % Initialisation de l'image
    Im=zeros(Sx,Sy);
    ImageClass='uint8'; % Encodage en 8 bits
    Imax=double(intmax(ImageClass)); %Pixel le plus lumineux est 255
    pas=1;
    sigma = 1 %parametre pixellisation 
    rdx=-5+rand*(5+5+1) %param�tre al�atoire (image non fixe)
    rdy=-5+rand*(5+5+1)
    [x,y]=meshgrid((1:pas:Sx)-Sx/2+rdx,(1:pas:Sy)-Sy/2+rdy); % cr�ation du maillage associ�
    Im=Imax.*exp(-(x.^2+y.^2)./(2*sigma^2)); %fonction gaussienne
    x0=[0.0;0.0;max(Im(:))*1.0]  %initialisation
    x0=double(x0)
    sigma=4                      % param�tre pixellisation
    [xsol]=lsqnonlin(@(x1)ecart(x1,double(Im),sigma),x0) %calcul de la position du milieu et son intensit�e lumineuse
	
    %% Affichage de l'image
    figure
    imagesc(Im)
    axis image; 
    colormap('gray') 
    hold on
    plot(+xsol(1)+Sx/2,xsol(2)+Sy/2-rdy, 'ro', 'DisplayName','Centre trouv�') %centre trouv�
    hold on
    plot(+Sx/2-rdx, +Sy/2-rdy, 'bo', 'DisplayName','Centre parfait') %centre parfait
    legend show 
    title 'Recherche du centre'