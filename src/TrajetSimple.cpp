/*************************************************************************
TrajetSimple  -  description
-------------------
début                : $DATE$
copyright            : (C) $YEAR$ par $AUTHOR$
e-mail               : $EMAIL$
*************************************************************************/

//---------- Réalisation de la classe <TrajetSimple> (fichier TrajetSimple.cpp) ------------

//---------------------------------------------------------------- INCLUDE

//-------------------------------------------------------- Include système
#include <iostream>
using namespace std;
//------------------------------------------------------ Include personnel
#include "TrajetSimple.h"
//----------------------------------------------------------------- PUBLIC
//----------------------------------------------------- Méthodes publiques

void TrajetSimple::Afficher() const
{
	cout << "Trajet Simple : ";
	Trajet::Afficher();
	cout << " en " << modeTransport << endl;
}

Trajet* TrajetSimple::clone() const{
	return new TrajetSimple(villeDepart,villeArrivee,modeTransport);
}

//-------------------------------------------- Constructeurs - villeDepartdestructeur

TrajetSimple::TrajetSimple (const char * villeDep, const char * villeArr, const char * modeTrans ) : Trajet(villeDep, villeArr)
{
	modeTransport = new char[strlen(modeTrans) + 1];
	strcpy(modeTransport,modeTrans);
	#ifdef MAP
	cout << "Appel au constructeur de <TrajetSimple>" << endl;
	#endif
} //----- Fin de TrajetSimple


TrajetSimple::~TrajetSimple ( )
{
	delete [] modeTransport;
	#ifdef MAP
	cout << "Appel au destructeur de <TrajetSimple>"<< endl;
	#endif
} //----- Fin de ~TrajetSimple
