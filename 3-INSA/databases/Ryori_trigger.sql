CREATE OR REPLACE TRIGGER TRIGGER_FK_STOCK_EUN
AFTER INSERT OR UPDATE ON STOCK_EUN
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM tverny.PRODUITS@LINKTODB13
WHERE REF_PRODUIT=:NEW.REF_PRODUIT;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'ce produit n�existe pas dans la table produits');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_STOCK_AUTRE
AFTER INSERT OR UPDATE ON STOCK_AUTRE
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM tverny.PRODUITS@LINKTODB13
WHERE REF_PRODUIT=:NEW.REF_PRODUIT;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'ce produit n�existe pas dans la table produits');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_STOCK_ALLEMAGNE
AFTER INSERT OR UPDATE ON STOCK_ALLEMAGNE
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM tverny.PRODUITS@LINKTODB13
WHERE REF_PRODUIT=:NEW.REF_PRODUIT;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'ce produit n�existe pas dans la table produits');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_COMMANDES_EUN_EMPLOYES
AFTER INSERT OR UPDATE ON COMMANDES_EUN
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM MELKARCHOU.EMPLOYES@LINKTODB14
WHERE NO_EMPLOYE=:NEW.NO_EMPLOYE;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'cet employ� n existe pas');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_COMMANDES_AUTRE_EMPLOYES
AFTER INSERT OR UPDATE ON COMMANDES_AUTRE
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM MELKARCHOU.EMPLOYES@LINKTODB14
WHERE NO_EMPLOYE=:NEW.NO_EMPLOYE;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'cet employ� n�existe pas');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_DETAILS_COMMANDES_EUN_PRODUITS
AFTER INSERT OR UPDATE ON DETAILS_COMMANDES_EUN
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM TVERNY.PRODUITS@LINKTODB13
WHERE REF_PRODUIT=:NEW.REF_PRODUIT;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'ce produit n�existe pas dans la table produits');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_DETAILS_COMMANDES_AUTRE_PRODUITS
AFTER INSERT OR UPDATE ON DETAILS_COMMANDES_AUTRE
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM TVERNY.PRODUITS@LINKTODB13
WHERE REF_PRODUIT=:NEW.REF_PRODUIT;
IF (compteur = 0) THEN
RAISE_APPLICATION_ERROR(-20001,'ce produit n�existe pas dans la table produits');
END IF;
END;

/

CREATE OR REPLACE TRIGGER TRIGGER_FK_FOURNISSEURS
AFTER UPDATE OR DELETE ON FOURNISSEURS
FOR EACH ROW
DECLARE compteur NUMBER(5);

BEGIN
SELECT COUNT(*) INTO compteur
FROM TVERNY.PRODUITS@LINKTODB13
WHERE NO_FOURNISSEUR=:NEW.NO_FOURNISSEUR;
IF (compteur != 0) THEN
RAISE_APPLICATION_ERROR(-20001,'Ce fournisseur est associ� � un produit');
END IF;
END;