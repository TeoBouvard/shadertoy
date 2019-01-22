function Grenier(  )
    close all;

    im=rgb2gray(imread('Stephane_Bres.jpg'));
    %im=imread('puissance6.png');
    [l,c,~]=size(im);
   
    %creation d'un mapping couleur lin�aire sur chaque flux RGB
    map=([0:255]'/255)*[1 1 1];

    figure(1)
    image(im)
    colormap(map)
    
    %histo
    histo = zeros(1,256);
    for L=1:l
        for C=1:c
            histo(im(L,C)+1)=histo(im(L,C)+1)+1;
        end
    end
    figure(2)
    plot(histo)
    
    neg = 255 - im;
    figure(3)
    image(neg)
    colormap(map)

    %histo
    seuil=50;
    imseuil=zeros(l,c);
    for L=1:l
        for C=1:c
            if im(L,C)>seuil
                imseuil(L,C)=255;
            end
        end
    end
    figure(4)
    image(imseuil)
    colormap(map)
    
    %recadrage
     im=double(im);
     imrec = zeros(l,c);
     maxi = max(max(im))
     mini=min(min(im))
     imrec=round((im-mini)/(maxi-mini)*255);
    
    figure(5)
    image(imrec)
    colormap(map)
    %histo
    histo2 = zeros(1,256);
    for L=1:l
        for C=1:c
            histo2(imrec(L,C)+1)=histo2(imrec(L,C)+1)+1;
        end
    end
    figure(6)
    plot(histo2)
    
    %histo cumul�
    hcum = zeros(1,256);
    hcum(1)=histo(1);
    for n=2:256
            hcum(n)=hcum(n-1)+histo(n);
    end
    hcum = (hcum /(l*c)) * 255;
    
    figure(7)
    plot(hcum)
    
    %�galisation
    imegal=zeros(l,c);
    for L=1:l
        for C=1:c
            imegal(L,C)=hcum((im(L,C)+1));
        end
    end
    figure(8)
    image(imegal)
    colormap(map)
    
    %histo �galis� dafuq ?
    histo3 = zeros(1,256);
    
    for L=1:l
        for C=1:c
            histo3(round(imegal(L,C)+1)) = histo3(round(imegal(L,C)+1))+1;
        end
    end
    
    figure(9)
    plot(histo3)
    
    
    %contraste
    K = 2;
    
    imcontr =  zeros(l,c);
    moy = mean(mean(im));
    imcontr = K*(im-moy) + moy;
    
    for L=1:l
        for C=1:c
            if(imcontr(L,C) < 0)
                imcontr(L,C)=0;
            end
            if(imcontr(L,C) > 255)
                imcontr(L,C)=255;
            end
            
        end
    end
    
    figure(10)
    image(imcontr)
    colormap(map)
 
    %Convolution
    
    imconv = zeros(l,c);
    mask=[0 1 0;1 -4 1;0 1 0];
    W=1;
    offset = 128;
    for L=2:l-1
        for C=2:c-1
            imconv(L,C)=offset + sum(sum(im(L-1:L+1,C-1:C+1).*mask))/W;
        end
    end
    
    for L=1:l
        for C=1:c
            if(imconv(L,C) < 0)
                imconv(L,C)=0;
            end
            if(imconv(L,C) > 255)
                imconv(L,C)=255;
            end
            
        end
    end
    
    figure(13)
    image(imconv)
    colormap(map)
   
     %Dilatation
    
    imdil = zeros(l,c);
    mask=[0 1 0;1 1 1;0 1 0];
    for L=2:l-1
        for C=2:c-1
            imdil(L,C)=max(max(im(L-1:L+1,C-1:C+1).*mask));
        end
    end
    
    figure(14)
    image(imdil)
    colormap(map)
    
    
end

