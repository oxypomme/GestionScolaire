DROP PROCEDURE IF EXISTS sp_etudiant_insert; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_insert`(e_id INT, e_civ varchar(4), e_nom varchar(25), e_prenom varchar(25), e_adresse varchar(50), e_cp varchar(5), e_ville varchar(25), e_portable varchar(25), e_tel varchar(10), e_mel varchar(60), f_code varchar(10), OUT erreur INT)
BEGIN
    DECLARE f_id int(11);

    SELECT id INTO f_id
    FROM FILIERE 
    WHERE code LIKE f_code COLLATE latin1_general_cs;

    INSERT INTO ETUDIANT(id, civ, nom, prenom, adresse, cp, ville, portable, telephone, mel, id_fil)
    VALUES (e_id, e_civ, e_nom, e_prenom, e_adresse, e_cp, e_ville, e_portable, e_tel, e_mel, f_id);
    SET erreur := 0;
END
