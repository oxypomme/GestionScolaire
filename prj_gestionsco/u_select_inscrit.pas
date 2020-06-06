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
    edt_immat: TEdit;
    edt_nomcom: TEdit;
    edt_insee: TEdit;
    edt_num: TEdit;
    edt_nomcond: TEdit;
    edt_permis: TEdit;
    lbl_dtdeb: TLabel;
    lbl_dtfin: TLabel;
    lbl_nomcom: TLabel;
    lbl_insee: TLabel;
    lbl_nomcond: TLabel;
    lbl_permis: TLabel;
    pnl_cond_btn: TPanel;
    pnl_immat_btn: TPanel;
    pnl_titre: TPanel;
    pnl_rechercher: TPanel;
    pnl_tous_edit: TPanel;
    pnl_periode_btn: TPanel;
    pnl_tous_btn: TPanel;
    pnl_num_btn: TPanel;
    pnl_com_btn: TPanel;
    pnl_com_edit: TPanel;
    pnl_cond_edit: TPanel;
    pnl_num_edit: TPanel;
    pnl_immat_edit: TPanel;
    pnl_periode_edit: TPanel;
    pnl_tous: TPanel;
    pnl_periode: TPanel;
    pnl_immat: TPanel;
    pnl_cond: TPanel;
    pnl_num: TPanel;
    pnl_choix: TPanel;
    pnl_com: TPanel;
    edt_dtdeb: TDateTimePicker;
    edt_dtfin: TDateTimePicker;

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
   else if  pnl_num_edit.visible  then
        f_list_inscrit.affi_data(modele.inscrit_liste_num(edt_num.text))
   else if  pnl_periode_edit.visible  then
        f_list_inscrit.affi_data(modele.inscrit_liste_periode(DateToStr(edt_dtdeb.date)
				,DateToStr(edt_dtfin.date)))
   else if  pnl_immat_edit.visible  then
        f_list_inscrit.affi_data(modele.inscrit_liste_immat(edt_immat.text))
   else if  pnl_cond_edit.visible  then
        f_list_inscrit.affi_data(modele.inscrit_liste_cond(edt_permis.text,edt_nomcond.text))
   else if pnl_com_edit.visible  then
        f_list_inscrit.affi_data(modele.inscrit_liste_com(edt_insee.text,edt_nomcom.text));
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
   NonSelectionPanel (pnl_tous);	NonSelectionPanel (pnl_num);
   NonSelectionPanel (pnl_periode);	NonSelectionPanel (pnl_immat);
   NonSelectionPanel (pnl_cond);	NonSelectionPanel (pnl_com);
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

