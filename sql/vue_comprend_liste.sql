CREATE
/* [DEFINER = { user | CURRENT_USER }]*/
VIEW `vue_comprend_liste` AS
    (SELECT 
        `UE`.`lib_court` AS `lib_court`,
        `UE`.`coef` AS `coef`,
        `NOTATION`.`note` AS `note`,
        `NOTATION`.`id_etud` AS `id_etud`
    FROM
        (`NOTATION`
        JOIN `UE` ON (`NOTATION`.`id_UE` = `UE`.`id`)))
