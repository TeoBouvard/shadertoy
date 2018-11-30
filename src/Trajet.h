/*************************************************************************
Trajet  -  description
-------------------
début                : $DATE$
copyright            : (C) $YEAR$ par $AUTHOR$
e-mail               : $EMAIL$
*************************************************************************/

//---------- Interface de la classe <Trajet> (fichier Trajet.h) ----------------
#ifndef Trajet_H
#define Trajet_H

//--------------------------------------------------- Interfaces utilisées
#include <cstring>
using namespace std;

//------------------------------------------------------------- Constantes

//------------------------------------------------------------------ Types

//------------------------------------------------------------------------
// Rôle de la classe <Trajet>
//
//
//------------------------------------------------------------------------

class Trajet
{
	//----------------------------------------------------------------- PUBLIC

public:
	//----------------------------------------------------- Méthodes publiques

	virtual void Afficher() const = 0;
	//-------------------------------------------------- Surcharge d'opérateurs
	//Trajet & operator = ( const Trajet & unTrajet );

	//-------------------------------------------- Constructeurs - destructeur
	Trajet ( const Trajet & unTrajet );
	Trajet (const char * villeDep, const char * villeArr);
	virtual ~Trajet ( );

	//------------------------------------------------------------------ PRIVE

protected:
	//----------------------------------------------------- Méthodes protégées

	//----------------------------------------------------- Attributs protégés
	char * villeDepart;
	char * villeArrivee;
};

#endif // Trajet_H
