unit u_notes_list;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, u_liste;

type

  { Tf_notes_list }

  Tf_notes_list = class(TF_liste)
    procedure Init;
    procedure affi_total (lbl : TLabel);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_notes_list: Tf_notes_list;

implementation

{$R *.lfm}

uses u_feuille_style;

{ Tf_notes_list }

procedure  Tf_notes_list.Init;
begin
   style.panel_travail(pnl_titre);
   style.panel_travail(pnl_btn);
   style.panel_travail(pnl_affi);
   style.grille (sg_liste);
   sg_liste.Columns[2].Alignment:=taRightJustify;
   pnl_titre.Hide;
   pnl_btn_page.Hide;
   pnl_btn_ligne.Hide;
end;

procedure  Tf_notes_list.affi_total (lbl : TLabel);
begin
   lbl.caption := '  Relevé de Notes : ' +floattostrF(f_notes_list.SumColumn('tarif'),FFFixed,7,2) +' €' + '  ';
end;

end.

