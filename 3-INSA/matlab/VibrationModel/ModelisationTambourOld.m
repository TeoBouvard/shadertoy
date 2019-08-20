function [] = ModelisationTambour(valPropreChoisie)

%nValMax = 20;
nValMin = valPropreChoisie;                                                 %pour ne calculer que les valeurs n�c�ssaires

altitudeFixe = 1;

surfaceT = zeros(15,40);                                                    %mesh de la surface du tambour
[m,n] = size(surfaceT);

%initialisation du laplacien (m*n = 600)
laplacien = -4*eye(m*n);

laplacien(1,1) = altitudeFixe; %point fixe en haut � gauche

for i = 15*m+1:m:n*m %semi-bord haut
    laplacien(i,i) = altitudeFixe;
end
for i = m*(n-1):m*n %bord droit
    laplacien(i,i) = altitudeFixe;
end
for i = m:m:m*(n-1) %bord bas
    laplacien(i,i) = altitudeFixe;
end
for i = (10*m)+6:(10*m)+10 %barre fixe 1
    laplacien(i,i) = altitudeFixe;
end
for i = (25*m)+6:(25*m)+10 %barre fixe 2
    laplacien(i,i) = altitudeFixe;
end

%discr�tisation du laplacien

%point normaux
for i = m+1:m*(n-1)
    if (laplacien(i,i) == -4)
        laplacien(i,i-1) = 1;
        laplacien(i,i+1) = 1;
        laplacien(i,i+m) = 1;
        laplacien(i,i-m) = 1;
    end
end

%bord haut non contraint
for i = m+1:m:13*(m+1)
   laplacien(i,i) = -3;
   laplacien(i,i-1) = 0;
end

%bord gauche non contraint
for i = 1:m
    if (laplacien(i,i) == -4)
        laplacien(i,i) = -3;
        laplacien(i,i-1) = 1;
        laplacien(i,i+1) = 1;
        laplacien(i,i+m) = 1;
    end
end

invLaplacien = inv(laplacien);                                              %division de la recherche des valeurs propres
                                                                            %am�liore le temps d'�x�cution
%[ valPropresMax , vectPropresMax ] = Deflation(laplacien, nValMax);
[ valPropresMin , vectPropresMin ] = Deflation(invLaplacien, nValMin);

for i = 1:nValMin
    valPropresMin(i,1) = (1/valPropresMin(i,1));
    vectPropresMin(:,i) = vectPropresMin(:,i);
end

vectorT = vectPropresMin(:,valPropreChoisie);                               %on attribue � chaque maille la composante du vecteur propre associ�

surfaceT = reshape(vectorT,m,n);

surf(surfaceT);

end

