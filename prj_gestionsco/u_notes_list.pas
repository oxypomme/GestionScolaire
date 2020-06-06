unit u_notes_list;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, u_liste;

type

  { Tf_notes_list }

  Tf_notes_list = class(TF_liste)
    lbl_titre: TLabel;
    lbl_notes_total: TLabel;
    procedure Init (affi : boolean);
    procedure affi_total;
    procedure btn_line_deleteClick(Sender: TObject);
    procedure btn_line_addClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_notes_list: Tf_notes_list;

implementation

{$R *.lfm}

uses u_feuille_style, u_notes_ajout;

{ Tf_notes_list }

procedure  Tf_notes_list.Init (affi : boolean);
begin
   style.panel_travail(pnl_titre);
   style.panel_travail(pnl_btn);
   style.panel_travail(pnl_affi);
   style.label_titre  (lbl_notes_total);
   style.grille (sg_liste);
   sg_liste.Columns[2].Alignment:=taRightJustify;
   lbl_notes_total.caption := '';
   pnl_btn_page.Hide;
   btn_line_detail.Hide;
   btn_line_edit.hide;
   pnl_btn_ligne.visible := NOT affi;
end;

procedure  Tf_notes_list.affi_total;
begin
   lbl_notes_total.caption := '  ' +floattostrF(f_notes_list.SumColumn('tarif'),FFFixed,7,2) +' €';
end;

procedure Tf_notes_list.btn_line_deleteClick(Sender: TObject);
begin
   f_notes_ajout.delete;
end;

procedure Tf_notes_list.btn_line_addClick(Sender: TObject);
begin
   pnl_btn_ligne.visible := false;
   f_notes_ajout.add;
end;

end.

