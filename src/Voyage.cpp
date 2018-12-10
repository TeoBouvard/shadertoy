/*************************************************************************
Voyage  -  description
-------------------
début                : Novembre 2018
copyright            : Mathis Guilhin & Téo Bouvard
*************************************************************************/

//---------- Réalisation du module <Voyage> (fichier Voyage.cpp) ---------------

/////////////////////////////////////////////////////////////////  INCLUDE
//-------------------------------------------------------- Include système
#include <iostream>
#include <cstring>
using namespace std;
//------------------------------------------------------ Include personnel
#include "Voyage.h"
#include "Catalogue.h"
#include "TrajetSimple.h"
#include "TrajetCompose.h"
///////////////////////////////////////////////////////////////////  PRIVE
//------------------------------------------------------------- Constantes
const int TAILLE_MAX_STRING = 20;
#define BIGNUMBER 999999
//------------------------------------------------------------------ Types
//---------------------------------------------------- Variables statiques

//------------------------------------------------------ Fonctions privées

static void affichageMenu(){
  cout << "Afficher le catalogue : 0 | Ajouter un trajet : 1 | Rechercher un trajet : 2 | Rechercher un trajet (avancé) : 3 | Quitter l'application : 9" << endl << endl;
}

static Trajet* creerTrajetSimple(){
  char* ville1 = new char[TAILLE_MAX_STRING];
  char* ville2 = new char[TAILLE_MAX_STRING];
  char* mdTransport = new char[TAILLE_MAX_STRING];

  cout << "Ville de départ ?"<< endl;
  cin >> ville1;
  cout << "Ville d'arrivée ?"<< endl;
  cin >> ville2;
  cout << "Mode de Transport ?"<< endl;
  cin >> mdTransport;

  Trajet* trajet = new TrajetSimple(ville1, ville2, mdTransport);

  delete [] ville1;
  delete [] ville2;
  delete [] mdTransport;

  return trajet;
}

static void creationTrajet(Collection * c, int option){
  if(option == 1){
    c->Ajouter(creerTrajetSimple());
  } else if(option == 2){
    int nEscales;
    cout << "Nombre d'escales ?" << endl;
    while(!(cin >> nEscales)){
			cin.clear();
			cin.ignore(BIGNUMBER, '\n');
			cout << "Entrée invalide. Réessayez" << endl;
		}
    Collection* collectionTrajets = new Collection;
    for(int i = 0 ; i < nEscales; i++){
      cout << "Escale n°" << i+1 << endl;
      cout << "Trajet simple : 1 | Trajet composé : 2" << endl;
      int choix;
      cin >> choix;
      creationTrajet(collectionTrajets,choix);
    }

    //on vérifie que le trajet ajouté est valide
    bool valide = true;
    for(int i = 0; i < collectionTrajets->getNbElements() - 1; i++){
      if (strcmp(collectionTrajets->getElement(i)->getVille(1),collectionTrajets->getElement(i+1)->getVille(0)) != 0){
        valide = false;
      }
    }
    if (valide){
      TrajetCompose* trajet = new TrajetCompose(collectionTrajets);
      c->Ajouter(trajet);
      cout << "Trajet ajouté au catalogue" << endl;
    }
    else{
      cout << "Saisie de trajet non valide !" << endl;
      delete collectionTrajets;
    }
  }
}


int main(){
  int lecture;
  char* ville1 = new char[TAILLE_MAX_STRING];
  char* ville2 = new char[TAILLE_MAX_STRING];
  Catalogue catalogue;
  Collection c;

  cout << endl << "Bienvenue dans le Gestionnaire de Trajets" << endl << endl;
  affichageMenu();
  while(!(cin >> lecture)){
    cin.clear();
    cin.ignore(BIGNUMBER, '\n');
    cout << "Entrée invalide. Réessayez" << endl;
  }

  while(lecture != 9){

    switch (lecture){

      case 0 :
      catalogue.AfficherCatalogue();
      break;

      case 1 :
      cout << endl << "Trajet simple : 1 | Trajet composé : 2" << endl;
      cin >> lecture;
      creationTrajet(catalogue.getCollection(),lecture);
      break;

      case 2 :
      cout << "Ville de départ ?"<< endl;
      cin >> ville1;
      cout << "Ville d'arrivée ?"<< endl;
      cin >> ville2;
      cout << endl;
      catalogue.RechercherTrajet(ville1, ville2);
      catalogue.RaZ_nbOption();
      break;

      case 3 :
      cout << "Ville de départ ?"<< endl;
      cin >> ville1;
      cout << "Ville d'arrivée ?"<< endl;
      cin >> ville2;
      cout << endl;
      catalogue.RechercherTrajetAvance(ville1, ville2,0,&c);
      catalogue.RaZ_nbOption();
      break;

      default :
      cout << "Entrée invalide. Réessayez" << endl;
      break;

    }

    affichageMenu();
    while(!(cin >> lecture)){
			cin.clear();
			cin.ignore(BIGNUMBER, '\n');
			cout << "Entrée invalide. Réessayez" << endl;
		}
  }

  cout << "Au revoir !" << endl << endl;

  delete [] ville1;
  delete [] ville2;


  return 0;
}
