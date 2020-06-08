unit u_select_inscrit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn, DateTimePicker;

type

  { Tf_select_inscrit }

  Tf_select_inscrit = class(TForm)
    btn_rechercher: TButton;
    edt_numetu: TEdit;
    edt_nometu: TEdit;
    edt_codefiliere: TEdit;
    lbl_codefiliere: TLabel;
    lbl_numetu: TLabel;
    lbl_nometu: TLabel;
    pnl_titre: TPanel;
    pnl_rechercher: TPanel;
    pnl_tous_edit: TPanel;
    pnl_tous_btn: TPanel;
    pnl_filiere_btn: TPanel;
    pnl_etu_btn: TPanel;
    pnl_etu_edit: TPanel;
    pnl_filiere_edit: TPanel;
    pnl_tous: TPanel;
    pnl_filiere: TPanel;
    pnl_choix: TPanel;
    pnl_etu: TPanel;

    procedure btn_rechercherClick(Sender: TObject);
    procedure init;
    procedure NonSelectionPanel (pnl : TPanel);
    procedure AucuneSelection;
    procedure pnl_choix_btnClick (Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_select_inscrit: Tf_select_inscrit;


implementation

{$R *.lfm}

uses u_feuille_style, u_list_inscrit, u_modele;

{ Tf_select_inscrit }
var
   pnl_actif : TPanel;

procedure Tf_select_inscrit.Init;
begin
    style.panel_defaut (pnl_choix);
    style.panel_selection (pnl_titre);
    style.panel_defaut(pnl_rechercher);
    pnl_choix_btnClick(pnl_tous_btn);
end;

procedure Tf_select_inscrit.btn_rechercherClick(Sender: TObject);
begin
   btn_rechercher.visible := false;
   pnl_actif.enabled := false;
   if  pnl_tous_edit.Visible  then
       f_list_inscrit.affi_data(modele.inscrit_liste_tous)
   else if pnl_etu_edit.visible  then
       f_list_inscrit.affi_data(modele.inscrit_liste_etu(edt_numetu.text, edt_nometu.text))
   else if  pnl_filiere_edit.visible  then
       f_list_inscrit.affi_data(modele.inscrit_liste_fil(edt_codefiliere.text))
   ;

end;

procedure   Tf_select_inscrit.pnl_choix_btnClick (Sender : TObject);
var
   pnl : TPanel;
begin
   AucuneSelection;
   pnl := TPanel(Sender);
   style.panel_selection (pnl);
   pnl	:= TPanel(pnl.Parent);	style.panel_selection (pnl);
   pnl	:= TPanel(f_select_inscrit.FindComponent(pnl.name +'_edit'));
   style.panel_selection (pnl);
   pnl.show;
   pnl_actif := pnl;     pnl_actif.enabled := true;
   btn_rechercher.visible := true;
end;

procedure   Tf_select_inscrit.AucuneSelection;
begin
   NonSelectionPanel (pnl_tous);
   NonSelectionPanel (pnl_filiere);
   NonSelectionPanel (pnl_etu);
end;

procedure  Tf_select_inscrit.NonSelectionPanel (pnl : TPanel);
var
   pnl_enfant : TPanel;
begin
   style.panel_defaut(pnl);
   pnl_enfant	:= TPanel(f_select_inscrit.FindComponent(pnl.name +'_btn'));
   style.panel_bouton(pnl_enfant);
   pnl_enfant	:= TPanel(f_select_inscrit.FindComponent(pnl.name +'_edit'));
   pnl_enfant.Hide;
end;

end.

