SET SQL_SAFE_UPDATES = 0;

/*passage la minute carnet */
update kardex.carnets set heure_de_vol=heure_de_vol*60 where id >0 ;
/*potentiel*/
update  kardex.potentiel_machines set valeur_potentiel=valeur_potentiel*60 where idtype_potentiel=3;
/*visite protocolaire*/
update kardex.visite_protocolaires set valeur_potentiel = valeur_potentiel *60 where idtype_potentiel=3 and id > 0;
update kardex.visite_protocolaires set tolerance = tolerance *60 where idtype_potentiel=3 and id > 0;
/*idem pour les  heures n*/
update  kardex.visite_machines 
set fait_a_heure=fait_a_heure*60 
where id>0;
/*visite machine*/
update  kardex.visite_machines inner join visite_protocolaires on visite_machines.id_visite_protocolaire=visite_protocolaires.id 
set visite_machines.val_potentiel=visite_machines.val_potentiel*60 
where visite_protocolaires.idtype_potentiel=3 and visite_machines.id>0 ;
/*idem pour les potentiel variable*/
update  kardex.visite_machines inner join visite_protocolaires on visite_machines.id_visite_protocolaire=visite_protocolaires.id 
set val_nouv_pot=val_nouv_pot*60 
where visite_protocolaires.idtype_potentiel=3 and visite_machines.id>0  ;

/* CN machine*/
/*equipement*/
update kardex.potentiel_montages set valeur_potentiel_montage = valeur_potentiel_montage*60,
valeur_machine_jour_montage=60* valeur_machine_jour_montage where idtype_potentiel =3;
/*potentiel*/
update  kardex.potentiel_equipements set valeur_potentiel=valeur_potentiel*60 where idtype_potentiel=3;
/*equipement*/
update kardex.visite_protocolaire_equipements set valeur_potentiel = valeur_potentiel *60,tolerance=tolerance*60 where idtype_potentiel=3 and id > 0;

/*visite equipement*/
update  kardex.visite_equipements 
inner join visite_protocolaire_equipements on visite_equipements.id_visite_protocolaire_equipement=visite_protocolaire_equipements.id 
set val_potentiel=val_potentiel*60 
where visite_protocolaire_equipements.idtype_potentiel=3 ;
/*CN machines*/
update kardex.cn_machines set val_potentiel = val_potentiel *60 where idtype_potentiel=3;
update kardex.exec_cn_machines inner join cn_machines on cn_machines.id= exec_cn_machines.idcn_machine set val_potentiel_exec = val_potentiel_exec*60
where cn_machines.idtype_potentiel=3;
/* CN equipement*/
update kardex.cn_equipements set val_potentiel =60*val_potentiel where idtype_potentiel=3;
update kardex.exec_cn_equipements inner join cn_equipements on cn_equipements.id= exec_cn_equipements.idcn_equipement set val_potentiel_exec = val_potentiel_exec*60
where cn_equipements.idtype_potentiel=3;
/*netoyage base*/
UPDATE `kardex`.`carnets` SET `heure_de_vol`='0' WHERE `id`='1';
UPDATE `kardex`.`type_visite_equipement_lances` SET `val_pot_lancement`='2015-01-31' WHERE `id`='7';
UPDATE `kardex`.`type_visite_equipement_lances` SET `val_pot_lancement`='2015-01-31' WHERE `id`='9';
UPDATE `kardex`.`type_visite_equipement_lances` SET `val_pot_lancement`='2015-01-31' WHERE `id`='10';

/*gestion lancement*/
update  kardex.type_visite_lances inner join visite_protocolaires on type_visite_lances.type_visite_lance_id = visite_protocolaires.id 
set val_pot_lancement= val_pot_lancement*60
where idtype_potentiel=3;
update  kardex.type_visite_equipement_lances 
inner join visite_protocolaire_equipements on type_visite_equipement_lances.type_visite_equipement_lance_id = visite_protocolaire_equipements.id 
set val_pot_lancement= val_pot_lancement*60
where idtype_potentiel=3;
update  kardex.type_cn_lances
inner join cn_machines on type_cn_lances.type_cn_lance_id=cn_machines.id 
set val_pot_lancement=val_pot_lancement*60 
where idtype_potentiel=3;
update  kardex.type_cn_equipement_lances
inner join cn_equipements on type_cn_equipement_lances.type_cn_equipement_lance_id=cn_equipements.id 
set val_pot_lancement=val_pot_lancement*60 
where idtype_potentiel=3;
update kardex.bon_lancements set heure_machine=60*heure_machine;
SET SQL_SAFE_UPDATES = 1;