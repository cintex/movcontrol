unit UCtrlTypes;

{$ifdef fpc}
{$MODE Delphi}
{$endif}

interface
{-----------------------------------------------------------------------------------
Manager of Control types used by movControl
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

uses Forms,
     Classes;

type

  TControlTypes = class(TPersistent)
  private
    FOwnerForm : TForm;
    FCtrlTypeList : TStringList;
    function GetCount: integer;
    function GetName(index: integer): String;
  public
    constructor Create(AOwnerForm : TForm);
    destructor Destroy; override;
    procedure Add(ACtrlType : String);
    procedure Availables(ACtrlTypeNames : TStrings);
    procedure Clear;
    property Names[index: integer] : String read GetName;
    property Count : integer read GetCount;
  end;

implementation

uses SysUtils,
     ExtCtrls,
     ComCtrls,
     StdCtrls,
     Controls;

{ TControlTypes }

procedure TControlTypes.Add(ACtrlType: String);
begin
  FCtrlTypeList.Add(ACtrlType);
end;

procedure TControlTypes.Availables(ACtrlTypeNames: TStrings);
var
  i : integer;
  ChildCtrl : TControl;
  function AlreadyExists(const ACtrlTypeName : String) : Boolean;
  var
    j : integer;
  begin
    Result := False;
    for j:=0 to ACtrlTypeNames.Count - 1 do
    begin
      Result := UpperCase(ACtrlTypeName) = UpperCase(ACtrlTypeNames.Strings[j]);
      if Result then Exit;
    end;
  end;
begin
  if not Assigned(ACtrlTypeNames) then Exit;
  ACtrlTypeNames.Clear;
  for i := 0 to FOwnerForm.ComponentCount - 1 do
  begin
    if (FOwnerForm.Components[i] is TControl) then
    begin
      ChildCtrl := FOwnerForm.Components[i] as TControl;
      if not(ChildCtrl is TPanel) and
         not(ChildCtrl is TGroupBox) and
         not(ChildCtrl is TPageControl) and
         not AlreadyExists(ChildCtrl.ClassName) then ACtrlTypeNames.Add(ChildCtrl.ClassName);
    end;
  end;
end;

procedure TControlTypes.Clear;
begin
  FCtrlTypeList.Clear;
end;

constructor TControlTypes.Create(AOwnerForm : TForm);
begin
  FOwnerForm := AOwnerForm;
  FCtrlTypeList := TStringList.Create;
end;

destructor TControlTypes.Destroy;
begin
  FCtrlTypeList.Free;
  inherited;
end;

function TControlTypes.GetCount: integer;
begin
  Result := FCtrlTypeList.Count;
end;

function TControlTypes.GetName(index: integer): String;
begin
  Result := FCtrlTypeList.Strings[index];
end;

end.
