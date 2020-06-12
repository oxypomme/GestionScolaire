unit u_detail_inscrit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  { Tf_detail_inscrit }

  Tf_detail_inscrit = class(TForm)
    btn_valider: TButton;
    btn_annuler: TButton;
    cbo_civilite: TComboBox;
    cbo_filiere: TComboBox;
    edt_mel: TEdit;
    edt_portable: TEdit;
    edt_codepostal: TEdit;
    edt_commune: TEdit;
    edt_prenom: TEdit;
    edt_nom: TEdit;
    lbl_fillib_court: TLabel;
    lbl_fillib_milong: TLabel;
    lbl_mel_erreur: TLabel;
    lbl_mel: TLabel;
    lbl_portable: TLabel;
    lbl_codepostal_erreur: TLabel;
    lbl_commune_erreur: TLabel;
    lbl_prenom_erreur: TLabel;
    lbl_nom_erreur: TLabel;
    lbl_prenom: TLabel;
    lbl_nom: TLabel;
    lbl_filiere_erreur: TLabel;
    lbl_notes_erreur: TLabel;
    lbl_telephone_erreur: TLabel;
    lbl_num_erreur: TLabel;
    lbl_notes: TLabel;
    lbl_adresse_erreur: TLabel;
    pnl_notes_vide: TPanel;
    pnl_notes_list: TPanel;
    pnl_notes: TPanel;
    lbl_filiere: TLabel;
    pnl_notes_titre: TPanel;
    pnl_filiere: TPanel;
    lbl_ident: TLabel;
    pnl_ident: TPanel;
    pnl_adresse: TPanel;
    edt_adresse: TEdit;
    edt_num: TEdit;
    lbl_num: TLabel;
    lbl_adresse: TLabel;
    pnl_contact: TPanel;
    btn_retour: TButton;
    edt_telephone: TEdit;
    lbl_contact: TLabel;
    lbl_telephone: TLabel;
    pnl_detail: TPanel;
    pnl_btn: TPanel;
    pnl_titre: TPanel;
    procedure btn_retourClick(Sender: TObject);
    procedure btn_validerClick(Sender: TObject);
    procedure cbo_filiereChange(Sender: TObject);
    procedure init   ( idins : string; affi : boolean);
    procedure detail ( idins : string);
    procedure edit   ( idins : string);
    procedure add;
    procedure delete ( idins : string);
    procedure edt_Enter (Sender : TObject );

  private
    procedure affi_page;
    procedure all_readonly (bool : boolean);
    procedure lib_filiere_disp;
    function  affi_erreur_saisie (erreur : string; lbl : TLabel; obj : TObject) : boolean;

    { private declarations }
  public
    { public declarations }
  end;

var
  f_detail_inscrit: Tf_detail_inscrit;

implementation


{$R *.lfm}

uses	u_feuille_style, u_list_inscrit, u_notes_list, u_modele, u_loaddataset;

{ Tf_detail_inscrit }

var
   oldvaleur : string;	// utilisée dans la modification pour comparer l’ancienne valeur avec la saisie
   id  : string;	// variable active dans toute l'unité, contenant l'id inscrit affichée

procedure Tf_detail_inscrit.Init   ( idins : string;	affi : boolean);
//  ajout nouvel inscrit : id est vide
// affichage détail d'un inscrit : affi est vrai sinon affi est faux
begin
   style.panel_travail (pnl_titre);
   style.panel_travail (pnl_btn);
   style.panel_travail (pnl_detail);
   style.panel_travail (pnl_ident);
	style.label_titre  (lbl_ident);
        style.label_erreur (lbl_num_erreur);     lbl_num_erreur.caption := '';
        style.combo (cbo_civilite);
        style.label_erreur (lbl_nom_erreur);     lbl_nom_erreur.caption := '';
        style.label_erreur (lbl_prenom_erreur);  lbl_prenom_erreur.caption := '';
   style.panel_travail (pnl_adresse);
	style.label_titre  (lbl_adresse);
	style.label_erreur (lbl_adresse_erreur);      lbl_adresse_erreur.caption := '';
        style.label_erreur (lbl_codepostal_erreur);   lbl_codepostal_erreur.caption := '';
        style.label_erreur (lbl_commune_erreur);      lbl_commune_erreur.caption := '';
   style.panel_travail (pnl_contact);
	style.label_titre  (lbl_contact);
	style.label_erreur (lbl_telephone_erreur);  lbl_telephone_erreur.caption := '';
        style.label_erreur (lbl_mel_erreur);        lbl_mel_erreur.caption := '';
   style.panel_travail (pnl_filiere);
	style.label_titre  (lbl_filiere);
        style.combo (cbo_filiere);
	style.label_erreur (lbl_filiere_erreur);   lbl_filiere_erreur.caption := '';
        lbl_fillib_court.caption := ' ';
        lbl_fillib_milong.caption := ' ';
   style.panel_travail (pnl_notes);
	style.panel_travail (pnl_notes_titre);
		style.label_titre  (lbl_notes);
		style.label_erreur (lbl_notes_erreur);     lbl_notes_erreur.caption := '';
	style.panel_travail (pnl_notes_list);
	style.panel_travail (pnl_notes_vide);
   edt_num.ReadOnly	:= affi;

   btn_retour.visible	:=affi;  // visible quand affichage détail
   btn_valider.visible	:=NOT  affi;    // visible quand ajout/modification inscrit
   btn_annuler.visible	:=NOT  affi;    // visible quand ajout/modification inscrit


   show;

   id  := idins;
   IF  NOT  ( id = '')   // affichage/modification inscrit
   THEN
   BEGIN
     affi_page;
     lbl_notes_erreur.Caption  :='';
     pnl_notes_list.show;
     f_notes_list.borderstyle  := bsNone;
     f_notes_list.parent       := pnl_notes_list;
     f_notes_list.align	       := alClient;
     lbl_notes.autosize := true;
     f_notes_list.init;
     f_notes_list.show;
     f_notes_list.affi_data(modele.inscrit_notes(id));
     lbl_notes.caption := '  Relevé de Notes - '
                       + 'Moyenne étudiant : ' + modele.moy_inscrit(id) + ' - '
                       + 'Moyenne filière : ' + modele.moy_filiere(cbo_filiere.text)
                       + '  ';
   END
   ELSE
   BEGIN
     pnl_notes_list.hide;
     lbl_notes.autosize := false;
     lbl_notes.width := 140;
     lbl_notes.Caption := '  Relevé de Notes';
   end;

end;

function  Tf_detail_inscrit.affi_erreur_saisie (erreur : string; lbl : TLabel; obj : TObject) : boolean;
begin
   lbl.caption := erreur;
   if  NOT (erreur = '')
   then begin
	TEdit(obj).setFocus;
	result := false;
   end
   else result := true;
end;

procedure Tf_detail_inscrit.all_readonly (bool : boolean);
begin
   edt_nom.readonly := bool;
   edt_prenom.readonly := bool;
   edt_adresse.readonly := bool;
   edt_codepostal.readonly := bool;
   edt_commune.readonly := bool;
   edt_telephone.readonly := bool;
   edt_portable.readonly := bool;
   edt_mel.readonly := bool;
end;

procedure Tf_detail_inscrit.affi_page;
var
   flux : Tloaddataset;
begin
   edt_telephone.text	:= '';
   edt_portable.text	:= '';

   flux   := modele.inscrit_num(id);
   flux.read;
   edt_num.text	        := flux.Get('id');
   edt_nom.text 	:= flux.Get('nom');
   cbo_civilite.text    := flux.Get('civ');
   edt_prenom.text	:= flux.Get('prenom');
   edt_adresse.text	:= flux.Get('adresse');
   edt_codepostal.text	:= flux.Get('cp');
   edt_commune.text	:= flux.Get('ville');
   edt_telephone.text	:= flux.Get('telephone');
   edt_portable.text	:= flux.Get('portable');
   edt_mel.text	        := flux.Get('mel');
   cbo_filiere.text	:= flux.Get('filiere');
   lib_filiere_disp;

   flux.destroy;
end;

procedure Tf_detail_inscrit.detail (idins : string);
begin
   init (idins, true);    // mode affichage
   pnl_titre.caption	:= 'Détail d''une inscrit';
   all_readonly(true);
   edt_num.enabled	 := true;
   cbo_civilite.enabled	 := false;
   cbo_filiere.enabled   := false;
   lib_filiere_disp;
   btn_retour.setFocus;
end;

procedure Tf_detail_inscrit.edit (idins : string);
begin
   init (idins, false);
   all_readonly(false);
   pnl_titre.caption	 := 'Modification d''un inscrit';
   edt_num.enabled	 := false;
   cbo_civilite.enabled	 := true;
   cbo_filiere.enabled   := false;
end;

procedure Tf_detail_inscrit.add;
begin
   init ('',false);   // pas de numéro d'inscrit
   all_readonly(false);
   pnl_titre.caption   := 'Nouvel inscription';
   edt_num.text	        := '';
   edt_nom.text 	:= '';
   edt_prenom.text	:= '';
   edt_adresse.text	:= '';
   edt_codepostal.text	:= '';
   edt_commune.text	:= '';
   edt_telephone.text	:= '';
   edt_portable.text	:= '';
   edt_mel.text	        := '';
   edt_num.enabled	 := true;
   cbo_civilite.enabled	 := true;      cbo_civilite.itemindex := 0;
   cbo_filiere.enabled   := true;      cbo_filiere.itemindex := -1;
   lib_filiere_disp;
   edt_num.setFocus;
end;

procedure Tf_detail_inscrit.delete (idins : string);
begin
   IF   messagedlg ('Demande de confirmation'
	,'Confirmez-vous la suppression de l''inscrit n°' + idins
	,mtConfirmation, [mbYes,mbNo], 0, mbNo) = mrYes
   THEN BEGIN
	modele.inscrit_note_delete (idins);
	modele.inscrit_delete (idins);

        f_list_inscrit.line_delete;
   END;
end;

procedure Tf_detail_inscrit.btn_retourClick(Sender: TObject);
begin
   close;
end;

procedure Tf_detail_inscrit.btn_validerClick(Sender: TObject);
var
    flux : TLoadDataSet;
    saisie, erreur : string;
    valide  : boolean;
begin
    valide := true;

    erreur := '';
    saisie := edt_nom.text;
    if  saisie = ''  then  erreur := 'Le nom doit être rempli.';
    valide := affi_erreur_saisie (erreur, lbl_nom_erreur, edt_nom)  AND  valide;

    erreur := '';
    saisie := edt_prenom.text;
    if  saisie = ''  then  erreur := 'Le prénom doit être rempli.';
    valide := affi_erreur_saisie (erreur, lbl_prenom_erreur, edt_prenom)  AND  valide;

    erreur := '';
    saisie := edt_adresse.text;
    if  saisie = ''  then  erreur := 'L''adresse doit être remplie.';
    valide := affi_erreur_saisie (erreur, lbl_adresse_erreur, edt_adresse)  AND  valide;

    erreur := '';
    saisie := edt_codepostal.text;
    if  saisie = ''  then  erreur := 'Le codepostal doit être rempli.';
    valide := affi_erreur_saisie (erreur, lbl_codepostal_erreur, edt_codepostal)  AND  valide;

    erreur := '';
    saisie := edt_commune.text;
    if  saisie = ''  then  erreur := 'La commune doit être remplie.';
    valide := affi_erreur_saisie (erreur, lbl_commune_erreur, edt_commune)  AND  valide;

    erreur := '';
    saisie := edt_telephone.text + edt_portable.text;
    if  saisie = ''  then  erreur := 'Le téléphone ou le portable doit être rempli.';
    valide := affi_erreur_saisie (erreur, lbl_telephone_erreur, edt_telephone)  AND  valide;

    erreur := '';
    saisie := edt_mel.text;
    if  saisie = ''  then  erreur := 'L''adresse mel doit être remplie.';
    valide := affi_erreur_saisie (erreur, lbl_mel_erreur, edt_mel)  AND  valide;


    erreur := '';
    saisie := cbo_filiere.text;
    if  saisie = ''  then  erreur := 'La filière doit être renseignée.';

    valide := affi_erreur_saisie (erreur, lbl_filiere_erreur, cbo_filiere)  AND  valide;

    if  id = ''
    then begin
	 erreur := '';
	 saisie := edt_num.text;
	 if  saisie = ''   then  erreur := 'Le numéro doit être rempli.'
	 else begin
	      flux := modele.inscrit_liste_etu(saisie, '');
	      if  NOT  flux.endOf
	      then  erreur := 'Le numéro existe déjà';
	 end;
	 valide := affi_erreur_saisie (erreur, lbl_num_erreur, edt_num)  AND  valide;
    end;


    if  NOT  valide then
        messagedlg ('Erreur enregistrement inscrit', 'La saisie est incorrecte.' +#13 +'Corrigez la saisie et validez à nouveau.', mtWarning, [mbOk], 0)
    else  begin
          if  id = '' then
              modele.inscrit_insert(edt_num.text, cbo_civilite.text, edt_nom.text, edt_prenom.text, edt_adresse.text, edt_codepostal.text, edt_commune.text, edt_portable.text, edt_telephone.text, edt_mel.text, cbo_filiere.text)
	  else  begin
	      modele.inscrit_update(id, cbo_civilite.text, edt_nom.text, edt_prenom.text, edt_adresse.text, edt_codepostal.text, edt_commune.text, edt_portable.text, edt_telephone.text, edt_mel.text);
	  end;
   	  if id = '' then
              f_list_inscrit.line_add(modele.inscrit_liste_etu(edt_num.text, ''))
   	  else
              f_list_inscrit.line_edit(modele.inscrit_liste_etu(id, ''));
   	  close;
    end;
end;

procedure Tf_detail_inscrit.cbo_filiereChange(Sender: TObject);
begin
  lib_filiere_disp;
end;

procedure Tf_detail_inscrit.lib_filiere_disp();
var
   flux : Tloaddataset;
begin
     if NOT (cbo_filiere.Text = '') THEN
     begin
     flux := modele.filiere_code(cbo_filiere.Text);
     flux.read;
       lbl_fillib_court.caption	 := flux.Get('lib_court');
       lbl_fillib_milong.caption := flux.Get('lib_milong');
     flux.destroy;
     end
     ELSE
     begin
       lbl_fillib_court.caption	 := 'Filière non identifiée';
       lbl_fillib_milong.caption := '';
     end;
end;

procedure Tf_detail_inscrit.edt_Enter(Sender : TObject);
begin
   oldvaleur := TEdit(Sender).text;
end;


end.

