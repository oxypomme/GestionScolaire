DROP PROCEDURE IF EXISTS sp_note_delete; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_note_delete`(IN n_etud INT, OUT erreur INT)
BEGIN
    DELETE FROM NOTATION WHERE id_etud = n_etud;
    SET erreur := 0;
END
