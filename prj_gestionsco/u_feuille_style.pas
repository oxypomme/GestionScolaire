unit u_feuille_style;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Controls, ExtCtrls,
  Grids,
  StdCtrls, Graphics;

type
    Tfeuille_style = CLASS
          procedure fonte_defaut    (ctrl : TControl);
          procedure panel_defaut    (pnl  : TPanel);
          procedure panel_selection (pnl  : TPanel);
          procedure panel_travail   (pnl  : TPanel);
          procedure panel_bouton    (pnl  : TPanel);
          procedure grille          (grid : TStringGrid);
          procedure label_titre     (lbl  : TLabel);
          procedure label_erreur    (lbl : TLabel);
          procedure combo           (cbo  : TComboBox);
    END;

var
   style : Tfeuille_style;

implementation

// fonte par défaut
procedure Tfeuille_style.fonte_defaut (ctrl : TControl);
begin
   ctrl.Font.Name  := 'Calibri';
   ctrl.Font.Size  := 11;
   ctrl.Font.Color := $00000000;
end;

// panel par défaut
procedure Tfeuille_style.panel_defaut (pnl : TPanel);
begin
   pnl.Color      := $00EBEBEB;
   pnl.BorderStyle:= bsNone;
   pnl.BevelOuter := bvNone;
   pnl.Alignment  := taLeftJustify;
   fonte_defaut(pnl);
end;

// panel sélection (fil d'Ariane, titre, ...)
procedure Tfeuille_style.panel_selection (pnl : TPanel);
begin
   panel_defaut(pnl);
   pnl.Color      := $00505050;
   pnl.Font.Color := $00FFFFFF;
end;

// panel zone de travail
procedure Tfeuille_style.panel_travail (pnl : TPanel);
begin
   panel_defaut(pnl);
   pnl.Color      := $00FFFFFF;
end;

// panel aspect bouton et comportement bouton
procedure Tfeuille_style.panel_bouton (pnl : TPanel);
begin
   panel_defaut(pnl);
   pnl.BorderStyle:= bsSingle;
end;

procedure Tfeuille_style.grille (grid : TStringGrid);
begin
   fonte_defaut (grid);
// affichage lignes de la barre de titres des colonnes, sélection ligne complète
   grid.Options          := [goFixedHorzLine, goRowSelect, goColSizing, goSmoothScroll];
   grid.Flat             := true;
   grid.BorderStyle      := bsnone;
   grid.FixedColor       := $00EBEBEB;
   grid.AlternateColor   := $00EBEBEB;
   grid.SelectedColor    := $00505050;
   grid.RowCount         := 1;
   grid.ColumnClickSorts := true;
end;

procedure Tfeuille_style.label_titre (lbl : TLabel);
begin
   fonte_defaut (lbl);
   lbl.color      := $005B5B5B;
   lbl.font.color := $00FFFFFF;
   lbl.font.style := [fsBold];
end;

procedure Tfeuille_style.label_erreur (lbl : TLabel);
begin
   fonte_defaut (lbl);
   lbl.font.size  := lbl.font.size -1;
   lbl.transparent:= true;
   lbl.font.color := $000000FF;
   lbl.font.style := [fsItalic];
end;

procedure Tfeuille_style.combo (cbo : TComboBox);
begin
   fonte_defaut (cbo);
   cbo.color        := $00FFFFFF;
   cbo.Style        := csOwnerDrawFixed;    // couleur de fond prise en compte
   cbo.sorted       := true;
   cbo.AutoComplete := true;                // auto complétion
end;


end.

