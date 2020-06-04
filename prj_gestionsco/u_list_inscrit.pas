unit u_list_inscrit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, u_liste;

type

  { Tf_list_inscrit }

  Tf_list_inscrit = class(TF_liste)
    procedure btn_line_addClick(Sender: TObject);
    procedure btn_line_deleteClick(Sender: TObject);
    procedure btn_line_detailClick(Sender: TObject);
    procedure btn_line_editClick(Sender: TObject);
    procedure Init;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_list_inscrit: Tf_list_inscrit;

implementation

{$R *.lfm}


{ Tf_list_inscrit }

uses u_feuille_style, u_detail_inscrit;

procedure Tf_list_inscrit.btn_line_addClick(Sender: TObject);
begin
   f_detail_inscrit.add;
end;

procedure Tf_list_inscrit.btn_line_deleteClick(Sender: TObject);
begin
   f_detail_inscrit.delete (sg_liste.cells[0,sg_liste.row]);
end;

procedure Tf_list_inscrit.btn_line_detailClick(Sender: TObject);
begin
   f_detail_inscrit.detail (sg_liste.cells[0,sg_liste.row]);
end;

procedure Tf_list_inscrit.btn_line_editClick(Sender: TObject);
begin
   f_detail_inscrit.edit (sg_liste.cells[0,sg_liste.row]);
end;

procedure Tf_list_inscrit.Init;
begin
   style.panel_travail(pnl_titre);
   style.panel_travail(pnl_btn);
   style.panel_travail(pnl_affi);
   style.grille (sg_liste);
end;


end.

