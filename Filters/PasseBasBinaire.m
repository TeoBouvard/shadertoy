function passeBasBinaire

k = 1000;

im = imread('imtest02.png');
[l,c,~]=size(im);

map=([0:255]'/255)*[1 1 1];

IM = fftshift(fft2(im));%on passe en frequentiel
IMaff = (log(abs(IM)+1));%cr�ation d'une version affichable de la repr�sentation fr�quentielle

binaryFilter = zeros(l,c); %cr�ation du filtre
IMF = zeros(l,c); %cr�ation de la repr�sentation fr�quentielle filtr�e

for u = 1:l
    for v = 1:c
        if (((u-l/2+1)^2+(v-c/2+1)^2) < k)
             binaryFilter(u,v) = 1;
        end
        IMF(u,v)=IM(u,v)*binaryFilter(u,v);
    end
end

IMFaff = (log(abs(IMF)+1));

IMF = fftshift(IMF);%reorganisation representation frequentielle
imf = ifft2(IMF);%on passe en spatial


figure('units','normalized','outerposition',[0 0 1 1]);

subplot(2,2,1);
image(im);
colormap(map);

subplot(2,2,2);
imagesc(IMaff);

subplot(2,2,3);
image(abs(imf));
colormap(map);

subplot(2,2,4);
imagesc(IMFaff);
