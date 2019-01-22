function passeBasGaussien(img)

    close all;

    %lecture des images test
    if img == 0
    im = imread('imtest01.png');
    else
    im = imread('imtest02.png');
    end

    [l,c,~]=size(im);

    %creation d'un mapping couleur lin�aire sur chaque flux RGB
    map=([0:255]'/255)*[1 1 1];

    %calcul du spectre frequentiel 
    spectre_freq = fftshift(fft2(im));

    %cr�ation d'une version affichable de la repr�sentation fr�quentielle
    spectre_freq_aff = (log(abs(spectre_freq))+1);

    %initialisation du filtre
    gaussMatrix = zeros(l,c);
    
    figure('units','normalized','outerposition',[0 0 1 1]);

    for n = 0.1:0.1:5

        k = -power(10,-n)

        for u = 1:l
            for v = 1:c
                gaussMatrix(u,v)=exp(k*((u-l/2+1)^2+(v-c/2+1)^2));
            end
        end

        %filtrage fr�quentiel
        spectre_filtre = spectre_freq .* gaussMatrix;

        %version affichable
        spectre_filtre_aff = (log(abs(spectre_filtre)+1));

        %reorganisation representation frequentielle
        spectre_filtre = fftshift(spectre_filtre);

        %calcul de l'image filtr�e par transform�e de fourier inverse
        im_filtre = ifft2(spectre_filtre);

        %affichage
        subplot(2,2,1);
        image(im);
        title('Image originale')
        colormap(map);

        subplot(2,2,2);
        imagesc(spectre_freq_aff);
        title('Spectre original')

        subplot(2,2,3);
        image(abs(im_filtre));
        title('Image filtr�e')
        colormap(map);

        subplot(2,2,4);
        imagesc(spectre_filtre_aff);
        title('Spectre filtr�')
        waitforbuttonpress;

    end

    close all;
end

