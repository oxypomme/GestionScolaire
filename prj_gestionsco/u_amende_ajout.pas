unit u_amende_ajout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { Tf_amende_ajout }

  Tf_amende_ajout = class(TForm)
    cbo_delit_nature: TComboBox;
    cbo_delit_num: TComboBox;
    lbl_delit_nature: TLabel;
    lbl_delit_num: TLabel;
    pnl_detail: TPanel;
    pnl_titre: TPanel;

    procedure Init;
    procedure add;
    procedure delete;
    procedure add_delit_to_amende (cle : string; cbo : TComboBox);
    procedure cbo_delit_numCloseUp(Sender: TObject);
    procedure cbo_delit_natureCloseUp(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_amende_ajout: Tf_amende_ajout;

implementation

{$R *.lfm}

{ Tf_amende_ajout }

uses u_feuille_style, u_amende_list, u_modele, u_loaddataset;

var
    flux_delit : TLoadDataSet;

procedure Tf_amende_ajout.Init;
begin
   style.panel_selection (pnl_titre);
   style.panel_travail  (pnl_detail);
         style.combo (cbo_delit_num);
         style.combo (cbo_delit_nature);
   cbo_delit_num.Clear;
   cbo_delit_nature.clear;

   flux_delit := modele.inscrit_delit_tous;
end;
procedure Tf_amende_ajout.delete;
begin
   f_amende_list.line_delete;
   f_amende_list.affi_total;
end;

procedure Tf_amende_ajout.add;
var   i : integer;
begin
   init;

   cbo_delit_num.items := flux_delit.COlumn('num');
   i := cbo_delit_num.Items.Count;
   while (i > 0)
   do begin
      i := i -1;
      if  f_amende_list.sg_liste.Cols[0].IndexOf(cbo_delit_num.items[i]) > -1
      then cbo_delit_num.Items.Delete(i);
   end;
// faire de même pour ‘nature’, colonne 1 dans sg_liste
   cbo_delit_nature.items := flux_delit.COlumn('nature');
   i := cbo_delit_nature.Items.Count;
   while (i > 0)
   do begin
      i := i -1;
      if  f_amende_list.sg_liste.Cols[1].IndexOf(cbo_delit_nature.items[i]) > -1
      then cbo_delit_nature.Items.Delete(i);
   end;

   show;
end;

procedure Tf_amende_ajout.add_delit_to_amende (cle : string; cbo : TComboBox);
begin
   if cbo.ItemIndex > -1
   then begin
            flux_delit.Position (cle,cbo.items[cbo.itemindex]);
        // T := flux_delit.Read;
        // f_amende_list.line_add(['num',T.Valeur['num'],'nature',T.Valeur['nature'], 'tarif', T.valeur['tarif']]);
        // ou
            f_amende_list.line_add(flux_delit.Read);

            f_amende_list.affi_total;
   end;
   f_amende_list.pnl_btn_ligne.visible := true;
   close;
end;

procedure Tf_amende_ajout.cbo_delit_natureCloseUp(Sender: TObject);
begin
   add_delit_to_amende ('nature',cbo_delit_nature);
end;

procedure Tf_amende_ajout.cbo_delit_numCloseUp(Sender: TObject);
begin
   add_delit_to_amende ('num',cbo_delit_num);
end;

end.

