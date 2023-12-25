# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "bon_lancements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "numero", limit: 45
    t.text "piece_chgt"
    t.date "date_lancement"
    t.integer "id_machine"
    t.float "heure_machine"
    t.float "heure_moteur"
    t.float "cycle"
    t.integer "id_rn"
    t.integer "id_re"
    t.text "trav_prog"
    t.text "trav_decou"
    t.integer "id_rn_decou"
    t.integer "id_re_decou"
    t.date "date_decou"
    t.date "date_exec"
    t.date "date_exec_decou"
    t.date "date_fin_trav"
    t.index ["id_machine"], name: "BL_machine_idx"
    t.index ["id_re_decou"], name: "decou_rn"
    t.index ["id_rn"], name: "bl_re_idx"
  end

  create_table "carnets", id: :integer, charset: "utf8", force: :cascade do |t|
    t.decimal "heure_de_vol", precision: 8, scale: 2
    t.integer "nombre_cycle"
    t.decimal "heure_moteur", precision: 8, scale: 2
    t.integer "machine_idmachine", null: false
    t.date "date_releve", null: false
    t.integer "auto", limit: 1, default: 0
    t.index ["machine_idmachine"], name: "fk_carnet_machine1"
  end

  create_table "cn_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idtype_equipement"
    t.date "date_premiere_execution"
    t.string "reference", limit: 45, collation: "latin1_swedish_ci"
    t.string "service_bulletin", limit: 45, collation: "latin1_swedish_ci"
    t.boolean "est_annule", default: false
    t.integer "idtype_potentiel"
    t.float "val_potentiel"
    t.string "nom", limit: 45, collation: "latin1_swedish_ci"
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.index ["idtype_equipement"], name: "cn_equipement_type_equipement"
    t.index ["idtype_potentiel"], name: "cn_equipement_type_potentiel"
  end

  create_table "cn_machines", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idtype_machine"
    t.date "date_premiere_execution"
    t.string "reference", limit: 45, collation: "latin1_swedish_ci"
    t.string "service_bulletin", limit: 45, collation: "latin1_swedish_ci"
    t.boolean "est_annule", default: false
    t.integer "idtype_potentiel"
    t.float "val_potentiel"
    t.string "nom", limit: 45, collation: "latin1_swedish_ci"
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.index ["idtype_machine"], name: "cn_machine_type_machine"
    t.index ["idtype_potentiel"], name: "cn_machine_type_potentiel"
  end

  create_table "doc_divers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Nom", limit: 45
    t.integer "type_doc_id"
    t.string "adresse", limit: 45
    t.integer "id_entite"
    t.index ["type_doc_id"], name: "fk_doc_divers_doc_type"
  end

  create_table "equipement_vaut_pours", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "maitre_id"
    t.integer "induite_id"
    t.string "commentaire", limit: 45
    t.index ["induite_id"], name: "id_ind_vaut_pour0_idx"
    t.index ["maitre_id"], name: "id_maitre_vaut_pour0_idx"
  end

  create_table "equipements", id: :integer, charset: "utf8", comment: "liste les équipements ", force: :cascade do |t|
    t.integer "idtypeequipement"
    t.string "num_serie", limit: 45
    t.index ["idtypeequipement"], name: "equipement_type_equipement"
  end

  create_table "est_acces", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "fonction_idfonction"
    t.integer "page_acce_id", null: false
    t.boolean "page_consult"
    t.boolean "page_modif"
    t.boolean "page_new"
    t.boolean "page_suppr"
    t.index ["page_acce_id"], name: "fk_est_acces_page_php1"
  end

  create_table "est_monte_surs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idequipement"
    t.integer "idmachine"
    t.date "date_montage"
    t.date "date_retrait"
    t.index ["idequipement"], name: "fk_est_monte_sur_equipement1"
    t.index ["idmachine"], name: "fk_est_monte_sur_machine1"
  end

  create_table "exec_cn_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "id_equipement"
    t.integer "idcn_equipement"
    t.integer "idtype_potentiel"
    t.float "val_potentiel_exec"
    t.date "date_exec"
    t.boolean "non_applicable"
    t.text "commentaire"
    t.index ["id_equipement"], name: "exec_cn_equipement _equipement"
    t.index ["idcn_equipement"], name: "exec_cn_equipement"
    t.index ["idtype_potentiel"], name: "exec_cn_type_potentiel"
  end

  create_table "exec_cn_machines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "id_machine"
    t.integer "idcn_machine"
    t.integer "idtype_potentiel"
    t.float "val_potentiel_exec"
    t.date "date_exec"
    t.boolean "non_applicable"
    t.text "commentaire"
    t.index ["id_machine"], name: "exec_cn_machine"
    t.index ["idcn_machine"], name: "exec_cn_cn_machine"
    t.index ["idtype_potentiel"], name: "exec_cn_type_potentiel"
  end

  create_table "fonctions", id: :integer, charset: "latin1", comment: "fonction d'une personne", force: :cascade do |t|
    t.string "nom_fonction", limit: 45, null: false
    t.index ["id"], name: "page_acces"
  end

  create_table "ligne_carnets", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
    t.string "L_0", limit: 8
    t.string "L_1", limit: 8
    t.string "L_2", limit: 8
    t.string "L_3", limit: 8
    t.string "L_4", limit: 8
    t.string "L_5", limit: 8
    t.string "L_6", limit: 8
    t.string "L_7", limit: 8
    t.string "L_8", limit: 8
    t.string "L_9", limit: 8
    t.string "L_10", limit: 8
    t.string "L_11", limit: 8
    t.string "L_12", limit: 8
    t.string "L_13", limit: 8
    t.string "L_14", limit: 8
    t.string "L_15", limit: 8
  end

  create_table "machines", id: :integer, charset: "utf8", comment: "table des machine volantes", force: :cascade do |t|
    t.string "Immatriculation", limit: 8
    t.string "num_serie", limit: 45
    t.date "date_construct"
    t.integer "type_machine_idtype_machine", null: false
    t.boolean "vendu", default: false
    t.index ["type_machine_idtype_machine"], name: "fk_machine_type_machine1"
  end

  create_table "menu_items", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "Nom", limit: 45, collation: "latin1_swedish_ci"
    t.integer "ordre_aff"
  end

  create_table "modif_repars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "sb", limit: 45
    t.string "Objet", limit: 45
    t.string "ref", limit: 45
    t.date "date_rel"
    t.string "fait_par", limit: 45
    t.integer "id_machine"
    t.index ["id_machine"], name: "id_machine_rep"
  end

  create_table "page_acces", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Nom", limit: 45
    t.string "adresse", limit: 45
    t.integer "menu_item_id", default: 0
    t.index ["menu_item_id"], name: "fk1_page_php_menu_item"
  end

  create_table "personnes", id: :integer, charset: "latin1", comment: "liste des utilisateurs", force: :cascade do |t|
    t.string "Nom", limit: 45, null: false
    t.string "prenom", limit: 45
    t.integer "id_fonction"
    t.string "login", limit: 45, null: false
    t.string "pass", limit: 45, null: false
    t.index ["id_fonction"], name: "fk_personne_fonction1"
  end

  create_table "piece_changees", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "nom", limit: 45
    t.string "easa_form1_ref", limit: 45
    t.integer "id_bl"
    t.index ["id_bl"], name: "id_bl_piece_idx"
  end

  create_table "potentiel_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idtype_equipement"
    t.integer "idtype_potentiel"
    t.float "valeur_potentiel"
    t.index ["idtype_equipement"], name: "fk_potentiel_equipement_type_equipement"
    t.index ["idtype_potentiel"], name: "fk_potentiel_equipement_type_potentiel1"
  end

  create_table "potentiel_machines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "idtype_potentiel"
    t.integer "idtype_machine"
    t.float "valeur_potentiel"
    t.string "nom", limit: 45
    t.index ["idtype_machine"], name: "potentiel_machine_type_machine"
    t.index ["idtype_potentiel"], name: "type_potentiel_potentiel_machine"
  end

  create_table "potentiel_montages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idpotentiel_equipement"
    t.integer "idest_monte_sur"
    t.float "valeur_potentiel_montage"
    t.float "valeur_machine_jour_montage"
    t.integer "idtype_potentiel"
    t.index ["idest_monte_sur"], name: "potentiel_montage_est_monte_sur"
    t.index ["idpotentiel_equipement"], name: "pontentiel_montage_equipement"
    t.index ["idtype_potentiel"], name: "potentiel_montage_type"
  end

  create_table "type_cn_equipement_lances", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "type_cn_equipement_lance_id"
    t.integer "bon_lancement_id"
    t.string "val_pot_lancement", limit: 45
    t.integer "id_equipement"
    t.index ["bon_lancement_id"], name: "type_visite_equipement_bl_idx"
    t.index ["id_equipement"], name: "equipement_type_visite_lance_idx"
    t.index ["type_cn_equipement_lance_id"], name: "equipement_type_visite_type_visite_lance0_idx"
  end

  create_table "type_cn_lances", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "type_cn_lance_id"
    t.integer "bon_lancement_id"
    t.string "val_pot_lancement", limit: 45
    t.index ["bon_lancement_id"], name: "type_visite_lance_bl_idx"
    t.index ["type_cn_lance_id"], name: "type_visite_type_visite_lance0_idx"
  end

  create_table "type_docs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "type_long", limit: 45
    t.string "abbrev", limit: 45
  end

  create_table "type_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "nom_constructeur", limit: 45, collation: "latin1_swedish_ci"
    t.string "type_equipement", limit: 45, collation: "latin1_swedish_ci"
    t.boolean "moteur"
    t.boolean "helice"
  end

  create_table "type_machines", id: :integer, charset: "utf8", comment: "liste des types machine", force: :cascade do |t|
    t.string "Nom_constructeur", limit: 45, null: false, collation: "latin1_swedish_ci"
    t.string "type_machine", limit: 45, null: false, collation: "latin1_swedish_ci"
    t.string "ref_manuel_entretien", limit: 45
  end

  create_table "type_potentiels", id: :integer, default: nil, charset: "latin1", comment: "recence les type de potentiel", force: :cascade do |t|
    t.string "type_potentiel", limit: 45
    t.string "unitee", limit: 45
    t.string "unitee_saisie", limit: 45
  end

  create_table "type_visite_equipement_lances", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "type_visite_equipement_lance_id"
    t.integer "bon_lancement_id"
    t.string "val_pot_lancement", limit: 45
    t.integer "id_equipement"
    t.index ["bon_lancement_id"], name: "type_visite_equipement_bl_idx"
    t.index ["id_equipement"], name: "equipement_type_visite_lance_idx"
    t.index ["type_visite_equipement_lance_id"], name: "equipement_type_visite_type_visite_lance_idx"
  end

  create_table "type_visite_lances", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "type_visite_lance_id"
    t.integer "bon_lancement_id"
    t.string "val_pot_lancement", limit: 45
    t.index ["bon_lancement_id"], name: "type_visite_lance_bl_idx"
    t.index ["type_visite_lance_id"], name: "type_visite_type_visite_lance_idx"
  end

  create_table "vaut_pours", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "maitre_id"
    t.integer "induite_id"
    t.string "commentaire", limit: 45
    t.index ["induite_id"], name: "id_ind_vaut_pour_idx"
    t.index ["maitre_id"], name: "id_maitre_vaut_pour_idx"
  end

  create_table "visite_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idequipement"
    t.date "date_visite"
    t.integer "idtype_potentiel"
    t.float "val_potentiel"
    t.integer "id_visite_protocolaire_equipement"
    t.string "nom", limit: 45, collation: "latin1_swedish_ci"
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.float "fait_a_heure_moteur", default: 0.0
    t.float "fait_cycle", default: 0.0
    t.index ["id_visite_protocolaire_equipement"], name: "_protocolaire_visite_machine"
    t.index ["id_visite_protocolaire_equipement"], name: "visite_visite_equi"
    t.index ["id_visite_protocolaire_equipement"], name: "viste_visite_protocolaire"
    t.index ["idequipement"], name: "machine_visite_machine"
    t.index ["idtype_potentiel"], name: "type_potentiel_visite_machine"
  end

  create_table "visite_machines", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idmachine"
    t.date "date_visite"
    t.integer "idtype_potentiel"
    t.float "val_potentiel"
    t.integer "id_visite_protocolaire"
    t.string "nom", limit: 45, collation: "latin1_swedish_ci"
    t.float "val_nouv_pot"
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.float "fait_a_heure", default: 0.0
    t.float "fait_a_heure_moteur", default: 0.0
    t.float "fait_a_nb_cycle", default: 0.0
    t.index ["id_visite_protocolaire"], name: "_protocolaire_visite_machine"
    t.index ["idmachine"], name: "machine_visite_machine"
    t.index ["idtype_potentiel"], name: "type_potentiel_visite_machine"
  end

  create_table "visite_protocolaire_equipements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idtype_potentiel"
    t.float "valeur_potentiel"
    t.integer "idtype_equipement"
    t.string "Nom", limit: 45, collation: "latin1_swedish_ci"
    t.float "tolerance", default: 0.0
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.boolean "gv", default: false
    t.boolean "va", default: false
    t.index ["idtype_equipement"], name: "fk_potentiel"
    t.index ["idtype_equipement"], name: "visite_protocolaire_type_machine"
    t.index ["idtype_potentiel"], name: "fk_type_potentiel"
    t.index ["idtype_potentiel"], name: "visite_protocolaire_type_potentiel"
  end

  create_table "visite_protocolaires", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "idtype_potentiel"
    t.float "valeur_potentiel"
    t.integer "idtype_machine"
    t.string "Nom", limit: 45, collation: "latin1_swedish_ci"
    t.float "tolerance", default: 0.0
    t.boolean "potentiel_variable", default: false
    t.text "commentaire", collation: "latin1_swedish_ci"
    t.boolean "gv", default: false
    t.boolean "va", default: false
    t.index ["idtype_machine"], name: "fk_potentiel"
    t.index ["idtype_machine"], name: "visite_protocolaire_type_machine"
    t.index ["idtype_potentiel"], name: "fk_type_potentiel"
    t.index ["idtype_potentiel"], name: "visite_protocolaire_type_potentiel"
  end

  add_foreign_key "bon_lancements", "machines", column: "id_machine", name: "BL_machine"
  add_foreign_key "bon_lancements", "personnes", column: "id_re_decou", name: "decou_re"
  add_foreign_key "bon_lancements", "personnes", column: "id_re_decou", name: "decou_rn"
  add_foreign_key "bon_lancements", "personnes", column: "id_rn", name: "bl_re"
  add_foreign_key "bon_lancements", "personnes", column: "id_rn", name: "bl_rn"
  add_foreign_key "carnets", "machines", column: "machine_idmachine", name: "fk_carnet_machine1"
  add_foreign_key "cn_equipements", "type_equipements", column: "idtype_equipement", name: "cn_equipement_type_equipement"
  add_foreign_key "cn_equipements", "type_potentiels", column: "idtype_potentiel", name: "cn_equipement_type_potentiel"
  add_foreign_key "cn_machines", "type_machines", column: "idtype_machine", name: "cn_machine_type_machine"
  add_foreign_key "cn_machines", "type_potentiels", column: "idtype_potentiel", name: "cn_machine_type_potentiel"
  add_foreign_key "doc_divers", "type_docs", name: "fk_doc_divers_doc_type"
  add_foreign_key "equipement_vaut_pours", "visite_protocolaire_equipements", column: "induite_id", name: "id_ind_vaut_pour0"
  add_foreign_key "equipement_vaut_pours", "visite_protocolaire_equipements", column: "maitre_id", name: "id_maitre_vaut_pour0"
  add_foreign_key "equipements", "type_equipements", column: "idtypeequipement", name: "equipement_type_equipement"
  add_foreign_key "est_acces", "page_acces", name: "fk_est_acces_page_acces"
  add_foreign_key "est_monte_surs", "equipements", column: "idequipement", name: "fk_est_monte_sur_equipement1"
  add_foreign_key "est_monte_surs", "machines", column: "idmachine", name: "fk_est_monte_sur_machine1"
  add_foreign_key "exec_cn_equipements", "cn_equipements", column: "idcn_equipement", name: "exec_cn_equipement"
  add_foreign_key "exec_cn_equipements", "equipements", column: "id_equipement", name: "exec_cn_equipement _equipement"
  add_foreign_key "exec_cn_equipements", "type_potentiels", column: "idtype_potentiel", name: "exec_cn_type_potentiel"
  add_foreign_key "exec_cn_machines", "cn_machines", column: "idcn_machine", name: "exec_cn_cn_machine"
  add_foreign_key "exec_cn_machines", "machines", column: "id_machine", name: "exec_cn_machine"
  add_foreign_key "exec_cn_machines", "type_potentiels", column: "idtype_potentiel", name: "exec_cn_type_potentiels"
  add_foreign_key "fonctions", "est_acces", column: "id", name: "page_acces"
  add_foreign_key "machines", "type_machines", column: "type_machine_idtype_machine", name: "fk_machine_type_machine1"
  add_foreign_key "modif_repars", "machines", column: "id_machine", name: "id_machine_rep"
  add_foreign_key "page_acces", "menu_items", name: "fk1_page_php_menu_item"
  add_foreign_key "personnes", "fonctions", column: "id_fonction", name: "fk_personne_fonction1"
  add_foreign_key "piece_changees", "bon_lancements", column: "id_bl", name: "id_bl_piece"
  add_foreign_key "potentiel_equipements", "type_equipements", column: "idtype_equipement", name: "fk_potentiel_equipement_type_equipement"
  add_foreign_key "potentiel_equipements", "type_potentiels", column: "idtype_potentiel", name: "fk_potentiel_equipement_type_potentiel1"
  add_foreign_key "potentiel_machines", "type_machines", column: "idtype_machine", name: "potentiel_machine_type_machine"
  add_foreign_key "potentiel_machines", "type_potentiels", column: "idtype_potentiel", name: "type_potentiel_potentiel_machine"
  add_foreign_key "potentiel_montages", "est_monte_surs", column: "idest_monte_sur", name: "potentiel_montage_est_monte_sur"
  add_foreign_key "potentiel_montages", "potentiel_equipements", column: "idpotentiel_equipement", name: "pontentiel_montage_equipement"
  add_foreign_key "potentiel_montages", "type_potentiels", column: "idtype_potentiel", name: "potentiel_montage_type"
  add_foreign_key "type_cn_equipement_lances", "bon_lancements", name: "type_visite_equipement_bl0"
  add_foreign_key "type_cn_equipement_lances", "cn_equipements", column: "type_cn_equipement_lance_id", name: "equipement_type_visite_type_visite_lance0"
  add_foreign_key "type_cn_equipement_lances", "equipements", column: "id_equipement", name: "equipement_type_visite_lance0"
  add_foreign_key "type_cn_lances", "bon_lancements", name: "type_visite_lance_bl0"
  add_foreign_key "type_cn_lances", "cn_machines", column: "type_cn_lance_id", name: "type_visite_type_visite_lance0"
  add_foreign_key "type_visite_equipement_lances", "bon_lancements", name: "type_visite_equipement_bl"
  add_foreign_key "type_visite_equipement_lances", "equipements", column: "id_equipement", name: "equipement_type_visite_lance"
  add_foreign_key "type_visite_equipement_lances", "visite_protocolaire_equipements", column: "type_visite_equipement_lance_id", name: "equipement_type_visite_type_visite_lance"
  add_foreign_key "type_visite_lances", "bon_lancements", name: "type_visite_lance_bl"
  add_foreign_key "type_visite_lances", "visite_protocolaires", column: "type_visite_lance_id", name: "type_visite_type_visite_lance"
  add_foreign_key "vaut_pours", "visite_protocolaires", column: "induite_id", name: "id_ind_vaut_pour"
  add_foreign_key "vaut_pours", "visite_protocolaires", column: "maitre_id", name: "id_maitre_vaut_pour"
  add_foreign_key "visite_equipements", "equipements", column: "idequipement", name: "machine_visite_equipement"
  add_foreign_key "visite_equipements", "type_potentiels", column: "idtype_potentiel", name: "type_potentiel_visite_machine0"
  add_foreign_key "visite_equipements", "visite_protocolaire_equipements", column: "id_visite_protocolaire_equipement", name: "visite_visite_equi"
  add_foreign_key "visite_machines", "machines", column: "idmachine", name: "machine_visite_machine"
  add_foreign_key "visite_machines", "type_potentiels", column: "idtype_potentiel", name: "type_potentiel_visite_machine"
  add_foreign_key "visite_machines", "visite_protocolaires", column: "id_visite_protocolaire", name: "_protocolaire_visite_machine"
  add_foreign_key "visite_protocolaire_equipements", "type_equipements", column: "idtype_equipement", name: "visite_protocolaire_type_machine0"
  add_foreign_key "visite_protocolaire_equipements", "type_potentiels", column: "idtype_potentiel", name: "visite_protocolaire_type_potentiel0"
  add_foreign_key "visite_protocolaires", "type_machines", column: "idtype_machine", name: "visite_protocolaire_type_machine"
  add_foreign_key "visite_protocolaires", "type_potentiels", column: "idtype_potentiel", name: "visite_protocolaire_type_potentiel"
end
