%% Programme permettant de créer une particule et d'extraire une particule de l'image original
% On renvoie la figure GVG (figure suivant la loi gaussienne) et VG qui est
% une particule venant de l'image I

    clc
    clear all
    close all

    %% Importation des images du répertoire courant, ne prendre qu'une image ici !
    
    [filename, pathname] = uigetfile({'*.tiff;*.png'},'Select ... images ','MultiSelect','on');

    if isequal(filename,0)
        disp('User selected Cancel')
        return 
    end
    cd(pathname);

    %% lecture et parametrage de la premiere image
    
    I = imread(filename);
    ImageClass='uint8'; % Encodage en 8 bits
    Imax=double(intmax(ImageClass)); %Pixel le plus lumineux est 255
    
    %% Extraction d'une sous matrice autour de la particule
    sigma = 1
    N=4*sigma                       %parametre pixellisation 
    [maxI,posI] = max(I(:));        %indice linéraire du max du signal, et sa position
    [rowI,colI] = ind2sub(size(I),posI) % position dans le tableau
    vg = I(rowI-N:rowI+N,colI-N:colI+N); % Extraction sous matrice de l'Image de réference


    %% Création de GVG, une particule avec distribution gaussienne

    [xvg,yvg] = meshgrid(-N:N,-N:N); % creation maillage
    gvg = Imax.*exp(-(xvg.^2+yvg.^2)./(2*sigma^2)); %fonction gaussienne

    %% affichage des figures
    
    %affichage de vg
    figure;
    imagesc(vg); 
    axis image; 
    colormap('gray') 
    title 'Image vg, particule image I'
    
    %affichage de gvg
    figure;
    imagesc(gvg);
    axis image; 
    colormap('gray') 
    title 'GVG Particule Gaussienne'