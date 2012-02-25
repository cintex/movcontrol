unit UCtrlTypesFrm;

interface
{-----------------------------------------------------------------------------------
Controls types properties editor for movControl
Copyright (C) 2012  Abdelhamid MEDDEB, abdelhamid@meddeb.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------------
------------------------- Current file revision ------------------------------------
------------------------------------------------------------------------------------
$Id: $
$Rev: $
-------------------------------------------------------------------------------------}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCtrlTypeFrm = class(TForm)
    lstBoxUnselected: TListBox;
    lstBoxSelected: TListBox;
    btnOk: TButton;
    btnCancel: TButton;
    btnSelect: TButton;
    btnSelectAll: TButton;
    btnUnselect: TButton;
    btnUnselectAll: TButton;
    lblUnselected: TLabel;
    lblSelected: TLabel;
    procedure btnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUnselectClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnUnselectAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CtrlTypeFrm: TCtrlTypeFrm;

implementation

uses UTextRessources;

{$R *.dfm}

procedure TCtrlTypeFrm.btnSelectClick(Sender: TObject);
var
  idxSel : integer;
begin
  idxSel := lstBoxUnselected.ItemIndex;
  if idxSel >= 0 then
  begin
    lstBoxSelected.Items.Add(lstBoxUnselected.Items[idxSel]);
    //lstBoxUnselected.DeleteSelected;
    lstBoxUnselected.Items.Delete(idxSel);
  end;
end;

procedure TCtrlTypeFrm.FormShow(Sender: TObject);
begin
  lblUnselected.Caption := rsCtrlTypesPresent;
  lblSelected.Caption := rsActiveCtrlTypes;
  Caption := rsCtrlTypesEditorTitle;
{$ifdef FRENCH}
  btnCancel.Caption := rsBtnCancel;
{$endif}
end;

procedure TCtrlTypeFrm.btnUnselectClick(Sender: TObject);
var
  idxSel : integer;
begin
  idxSel := lstBoxSelected.ItemIndex;
  if idxSel >= 0 then
  begin
    lstBoxUnselected.Items.Add(lstBoxSelected.Items[idxSel]);
    //lstBoxSelected.DeleteSelected;
    lstBoxSelected.Items.Delete(idxSel);
  end;
end;

procedure TCtrlTypeFrm.btnSelectAllClick(Sender: TObject);
var
  i : integer;
begin
  for i:=lstBoxUnselected.Items.Count-1 downto 0 do
  begin
    lstBoxSelected.Items.Add(lstBoxUnselected.Items[i]);
    lstBoxUnselected.Items.Delete(i);
  end;
end;

procedure TCtrlTypeFrm.btnUnselectAllClick(Sender: TObject);
var
  i : integer;
begin
  for i:=lstBoxSelected.Items.Count-1 downto 0 do
  begin
    lstBoxUnselected.Items.Add(lstBoxSelected.Items[i]);
    lstBoxSelected.Items.Delete(i);
  end;
end;

end.
