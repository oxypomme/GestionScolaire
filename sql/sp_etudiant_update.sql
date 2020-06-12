DROP PROCEDURE IF EXISTS sp_etudiant_update; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_update`(e_id INT, e_civ varchar(4), e_nom varchar(25), e_prenom varchar(25), e_adresse varchar(50), e_cp varchar(5), e_ville varchar(25), e_portable varchar(25), e_tel varchar(10), e_mel varchar(60), f_code varchar(10), OUT erreur INT)
BEGIN
    DECLARE fil_id int(11);

    SELECT id INTO fil_id
    FROM FILIERE 
    WHERE code LIKE f_code COLLATE latin1_general_cs;

    UPDATE ETUDIANT
    SET civ = e_civ,
    nom = e_civ,
    prenom = e_prenom,
    adresse = e_adresse,
    cp = e_cp,
    ville = e_ville,
    portable = e_portable,
    telephone = e_telephone,
    mel = e_mel,
    id_fil = fil_id
    WHERE id = e_id;
    SET erreur := 0;
END
