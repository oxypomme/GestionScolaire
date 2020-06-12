CREATE
/* [DEFINER = { user | CURRENT_USER }]*/
VIEW `vue_comprend_liste` AS (
    SELECT lib_court, coef, note, id_etud
    FROM NOTATION AS n
    JOIN UE ON (n.id_UE = UE.id)
)
