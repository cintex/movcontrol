unit UCtrlNames;

{$ifdef fpc}
{$MODE Delphi}
{$endif}

interface
{-----------------------------------------------------------------------------------
Manager of Control names used by movControl
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
$Id $
$Rev $
-------------------------------------------------------------------------------------}

uses Forms,
     Classes;

type

  TControlNames = class(TPersistent)
  private
    FOwnerForm : TForm;
    FCtrlNameList : TStringList;
    function GetCount: integer;
    function GetName(index: integer): String;
  public
    constructor Create(AOwnerForm : TForm);
    destructor Destroy; override;
    procedure Add(ACtrlName : String);
    procedure Availables(ACtrlNames : TStrings);
    procedure Clear;
    property Names[index: integer] : String read GetName;
    property Count : integer read GetCount;
  end;

implementation

uses Controls,
     ComCtrls,
     StdCtrls,
     ExtCtrls;

{ TControlNames }

procedure TControlNames.Add(ACtrlName: String);
begin
  FCtrlNameList.Add(ACtrlName);
end;

procedure TControlNames.Availables(ACtrlNames: TStrings);
var
  i : integer;
  ChildCtrl : TControl;
begin
  if not Assigned(ACtrlNames) then Exit;
  ACtrlNames.Clear;
  for i := 0 to FOwnerForm.ComponentCount - 1 do
  begin
    if (FOwnerForm.Components[i] is TControl) then
    begin
      ChildCtrl := FOwnerForm.Components[i] as TControl;
      if not(ChildCtrl is TPanel) and
         not(ChildCtrl is TGroupBox) and
         not(ChildCtrl is TPageControl) then ACtrlNames.Add(ChildCtrl.Name);
    end;
  end;
end;

procedure TControlNames.Clear;
begin
  FCtrlNameList.Clear;
end;

constructor TControlNames.Create(AOwnerForm: TForm);
begin
  FOwnerForm := AOwnerForm;
  FCtrlNameList := TStringList.Create;
end;

destructor TControlNames.Destroy;
begin
  FCtrlNameList.Free;
  inherited;
end;

function TControlNames.GetCount: integer;
begin
  Result := FCtrlNameList.Count;
end;

function TControlNames.GetName(index: integer): String;
begin
  Result := FCtrlNameList.Strings[index];
end;

end.
