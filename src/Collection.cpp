/*************************************************************************
Collection  -  description
-------------------
début                : $DATE$
copyright            : (C) $YEAR$ par $AUTHOR$
e-mail               : $EMAIL$
*************************************************************************/

//---------- Réalisation de la classe <Collection> (fichier Collection.cpp) ------------

//---------------------------------------------------------------- INCLUDE
//-------------------------------------------------------- Include système
#include <iostream>
using namespace std;
//------------------------------------------------------ Include personnel
#include "Collection.h"
#define underline "\033[4m"
#define stopu "\033[0m"
//------------------------------------------------------------- Constantes
const int TAILLE_INITIALE = 5; //doit être différent de 0 pour Resize()
//----------------------------------------------------------------- PUBLIC
//----------------------------------------------------- Méthodes publiques
void Collection::Resize()
{
	int newSize = 2*tailleTableau;
	Trajet** resized_arr = new Trajet* [newSize];

	for(int i = 0; i < tailleTableau; i++){
		resized_arr[i] = elements[i];
	}
	tailleTableau = newSize;

	delete[] elements;
	elements = resized_arr;
}

void Collection::AfficherCollection() const
{
	for (int i = 0; i < nbElements; i++){
		cout << "\t" << underline <<"Trajet " << i + 1 << stopu << endl;
		elements[i]->Afficher();
		cout << endl;
	}
}

Trajet* Collection::getElement(int i) const
{
	return elements[i];
}

int Collection::getNbElements() const
{
	return nbElements;
}

void Collection::Ajouter(Trajet * t)
{
	//ajout d'un nouveau trajet si la taille le permet
	if (nbElements < tailleTableau){
		elements[nbElements++] = t;
	}
	//sinon redimensionnement du tableau dynamique
	else{
		Collection::Resize();
		elements[nbElements++] = t;

		#ifdef MAP2
		cout << "Nouveau nbElements " << nbElements << endl;
		cout << "Nouveau TailleTableau " << tailleTableau << endl;
		#endif
	}
}
//-------------------------------------------- Constructeurs - destructeur
Collection::Collection ()
{
	nbElements = 0;
	elements = new Trajet* [TAILLE_INITIALE];
	tailleTableau = TAILLE_INITIALE;
	#ifdef MAP
	cout << "Appel au constructeur de <Collection>" << endl;
	#endif
} //----- Fin de Collection

Collection* Collection::cloneCollection() const{
	Collection* c = new Collection;
	for (int i = 0; i < nbElements; i++){
		c->Ajouter(elements[i]->clone());
	}
	return c;
}

Collection::~Collection ()
{
	for (int i = 0; i < nbElements; i++){
		delete elements[i];
	}
	delete [] elements;
	#ifdef MAP
	cout << "Appel au destructeur de <Collection>" << endl;
	#endif

}//----- Fin de ~Collection
