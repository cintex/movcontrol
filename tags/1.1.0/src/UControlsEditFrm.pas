unit UControlsEditFrm;

interface
{-----------------------------------------------------------------------------------
Controls types and names properties editor for movControl
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
$Id$
$Rev$
-------------------------------------------------------------------------------------}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  TCtrlEdit = (ctedType, ctedName);

  TControlsEditFrm = class(TForm)
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
    FCtrlEdit : TCtrlEdit;
  public
    procedure EditType(ACtrlEdit : TCtrlEdit);
  end;

var
  ControlsEditFrm: TControlsEditFrm;

implementation

uses UTextRessources;

{$R *.dfm}

procedure TControlsEditFrm.btnSelectClick(Sender: TObject);
var
  idxSel : integer;
begin
  idxSel := lstBoxUnselected.ItemIndex;
  if idxSel >= 0 then
  begin
    lstBoxSelected.Items.Add(lstBoxUnselected.Items[idxSel]);
    lstBoxUnselected.Items.Delete(idxSel);
  end;
end;

procedure TControlsEditFrm.FormShow(Sender: TObject);
begin
{$ifdef FRENCH}
  btnCancel.Caption := rsBtnCancel;
{$endif}
end;

procedure TControlsEditFrm.btnUnselectClick(Sender: TObject);
var
  idxSel : integer;
begin
  idxSel := lstBoxSelected.ItemIndex;
  if idxSel >= 0 then
  begin
    lstBoxUnselected.Items.Add(lstBoxSelected.Items[idxSel]);
    lstBoxSelected.Items.Delete(idxSel);
  end;
end;

procedure TControlsEditFrm.btnSelectAllClick(Sender: TObject);
var
  i : integer;
begin
  for i:=lstBoxUnselected.Items.Count-1 downto 0 do
  begin
    lstBoxSelected.Items.Add(lstBoxUnselected.Items[i]);
    lstBoxUnselected.Items.Delete(i);
  end;
end;

procedure TControlsEditFrm.btnUnselectAllClick(Sender: TObject);
var
  i : integer;
begin
  for i:=lstBoxSelected.Items.Count-1 downto 0 do
  begin
    lstBoxUnselected.Items.Add(lstBoxSelected.Items[i]);
    lstBoxSelected.Items.Delete(i);
  end;
end;

procedure TControlsEditFrm.EditType(ACtrlEdit: TCtrlEdit);
begin
  FCtrlEdit := ACtrlEdit;
  case FCtrlEdit of
    ctedType : begin
                lblUnselected.Caption := rsCtrlTypesPresent;
                lblSelected.Caption := rsActiveCtrlTypes;
                Caption := rsCtrlTypesEditorTitle;
               end;
    ctedName:  begin
                lblUnselected.Caption := rsCtrlNamesPresent;
                lblSelected.Caption := rsActiveCtrlNames;
                Caption := rsCtrlNamesEditorTitle;
               end;
  end;
end;

end.
