DROP PROCEDURE IF EXISTS sp_etudiant_update; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_update`(e_id INT, e_civ varchar(4), e_nom varchar(25), e_prenom varchar(25), e_adresse varchar(50), e_cp varchar(5), e_ville varchar(25), e_portable varchar(25), e_tel varchar(10), e_mel varchar(60), OUT erreur INT)
BEGIN
    UPDATE ETUDIANT
    SET civ = e_civ,
    nom = e_nom,
    prenom = e_prenom,
    adresse = e_adresse,
    cp = e_cp,
    ville = e_ville,
    portable = e_portable,
    telephone = e_tel,
    mel = e_mel
    WHERE id = e_id;
    SET erreur := 0;
END
