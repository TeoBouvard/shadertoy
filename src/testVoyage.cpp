/*************************************************************************
testVoyage  -  description
-------------------
début                : $DATE$
copyright            : (C) $YEAR$ par $AUTHOR$
e-mail               : $EMAIL$
*************************************************************************/

//---------- Réalisation du module <testVoyage> (fichier testVoyage.cpp) ---------------

/////////////////////////////////////////////////////////////////  INCLUDE
//-------------------------------------------------------- Include système
#include <iostream>
#include <cstring>
//------------------------------------------------------ Include personnel
#include "Trajet.h"
#include "Collection.h"
#include "TrajetSimple.h"
#include "TrajetCompose.h"

///////////////////////////////////////////////////////////////////  PRIVE
//------------------------------------------------------------- Constantes

//------------------------------------------------------------------ Types

//---------------------------------------------------- Variables statiques

//------------------------------------------------------ Fonctions privées

//////////////////////////////////////////////////////////////////  PUBLIC
//---------------------------------------------------- Fonctions publiques
int main()
{
	Collection* C1 = new Collection;

	TrajetSimple* TS1 = new TrajetSimple("Lyon","Bordeaux","Train");
	TrajetSimple* TS2 = new TrajetSimple("Bordeaux","Brest","Voiture");
	//TrajetSimple* TS3 = new TrajetSimple("Brest","Lille","Train");

	C1->Ajouter(TS1);
	C1->Ajouter(TS2);
	//C1->Ajouter(TS3);
	//C1->Afficher();

	TrajetCompose* TC1 = new TrajetCompose(C1);

	TC1->Afficher();

	delete TC1;

	delete C1; //delete les trajets contenus dans la collection
	//delete TS3;

	//TrajetCompose TC2("Paris","Marseille",1,tc2);
	//TS1.Afficher();

	return 0;
}
