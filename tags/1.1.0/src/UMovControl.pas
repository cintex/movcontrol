unit UMovControl;

interface
{-----------------------------------------------------------------------------------
movControl component core
Copyright (C) 2009  Abdelhamid MEDDEB, abdelhamid@meddeb.net

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
  Classes,
  Controls,
  Forms,
  {UToolsFrm,}
  UCtrlSelector,
  UCtrlTypes,
  UCtrlNames;

type

  TKeyControl = (kcNone, kcCtrl, kcAlt, kcShift, kc_A, kc_B, kc_C, kc_D, kc_E, kc_F, kc_G,
                 kc_H, kc_I, kc_J, kc_K, kc_L, kc_M, kc_N, kc_O, kc_P, kc_Q, kc_R, kc_S,
                 kc_T, kc_U, kc_V, kc_W, kc_X, kc_Y, kc_Z);

  TMovControl = class(TComponent)
  private
    FPosGrid : TPosGrid;
    FActive : Boolean;
    FMovActive : Boolean;
    FShowTools : Boolean;
    FShowGrid : Boolean;
    FGridAlign : Boolean;
    FControlNames : TControlNames;
    FControlTypes : TControlTypes;
    FKeyControl1 : TKeyControl;
    FKeyControl2 : TKeyControl;
    FKeyControl3 : TKeyControl;
    FOwnerForm : TForm;
    FOriKeyDown : TKeyEvent;
    //FToolsFrm : TToolsFrm;
    FCtrlSelectMgr : TCtrlSelectMgr;
    function KeyControlIsChar(AKeyControl : TKeyControl) : Boolean;
    //procedure DoShowTools(AActive : Boolean = True);
    procedure SetOwnerForm;
    procedure ReadCtrlTypes(Reader : TReader);
    procedure WriteCtrlTypes(Writer : TWriter);
    procedure ReadCtrlNames(Reader : TReader);
    procedure WriteCtrlNames(Writer : TWriter);
    procedure OwnerFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function VKToKeyControl(const AVKKey : Word) : TKeyControl;
    procedure KeyActive(const AKey : Word; AShift : TShiftState);
    procedure SetKeyControl1(const Value: TKeyControl);
    procedure SetKeyControl2(const Value: TKeyControl);
    procedure SetKeyControl3(const Value: TKeyControl);
    procedure SetActive(const Value: Boolean);
    procedure SetShowGrid(const Value: Boolean);
    property GridAlign : Boolean read FGridAlign write FGridAlign default False;
    property ShowTools : Boolean read FShowTools write FShowTools default False;
    property ShowGrid : Boolean read FShowGrid write SetShowGrid default False;
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Active : Boolean read FActive write SetActive default True;
    property ControlNames : TControlNames read FControlNames write FControlNames;
    property ControlTypes : TControlTypes read FControlTypes write FControlTypes;
    property KeyControl1 : TKeyControl read FKeyControl1 write SetKeyControl1 default kcNone;
    property KeyControl2 : TKeyControl read FKeyControl2 write SetKeyControl2 default kcNone;
    property KeyControl3 : TKeyControl read FKeyControl3 write SetKeyControl3 default kcNone;
  end;


implementation

uses Windows,
     Dialogs,
     SysUtils,
     UTextRessources;

{ TMovControl }

constructor TMovControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  SetOwnerForm;
  FActive := True;
  FMovActive := False;
  FShowTools := False;
  FShowGrid := False;
  FGridAlign := False;
  FControlNames := TControlNames.Create(FOwnerForm);
  FControlTypes := TControlTypes.Create(FOwnerForm);
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FOwnerForm) then
    begin
      FPosGrid := TPosGrid.Create(FOwnerForm);
      FOriKeyDown := FOwnerForm.OnKeyDown;
      FOwnerForm.OnKeyDown := OwnerFormKeyDown;
      FCtrlSelectMgr := TCtrlSelectMgr.Create(FOwnerForm, FControlTypes, FControlNames);
      FOwnerForm.KeyPreview := True;
    end;
  end;
end;

destructor TMovControl.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FOwnerForm) then
    begin
      FOwnerForm.OnKeyDown := FOriKeyDown;
    end;
    FOwnerForm := nil;
    FPosGrid.Free;
    FCtrlSelectMgr.Free;
  end;
  FControlTypes.Free;
  FControlNames.Free;
  inherited;
end;

procedure TMovControl.KeyActive(const AKey: Word; AShift: TShiftState);
var
  KeyControl : TKeyControl;

  function KeyCtrlInShift(const AKeyControl : TKeyControl) : Boolean;
  begin
    case AKeyControl of
      kcCtrl  : Result := (ssCtrl in AShift);
      kcAlt   : Result := (ssAlt in AShift);
      kcShift : Result := (ssShift in AShift);
      else      Result := False;
    end;
  end;

begin
  if (csDesigning in ComponentState) then Exit;
  if (FKeyControl1 = kcNone) and (FKeyControl2 = kcNone) and (KeyControl3 = kcNone) then Exit;
  KeyControl := VKToKeyControl(AKey);
  if KeyControl = kcNone then Exit;
  //4 cases ..
  //1st case : 011
  if (FKeyControl1 = kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl2) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl2));
    end
    else FMovActive := FMovActive xor (KeyCtrlInShift(FKeyControl2) and KeyCtrlInShift(FKeyControl3));
  end;

  //2nd case : 101
  if (FKeyControl1 <> kcNone) and (FKeyControl2 = kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl1));
    end
    else FMovActive := FMovActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl3));
  end;

  //3rd case : 110
  if (FKeyControl1 <> kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 = kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl2));
    end
    else
    if KeyControlIsChar(FKeyControl2) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl1));
    end
    else FMovActive := FMovActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl2));
  end;

  //4rd case : 111
  if (FKeyControl1 <> kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl2)
                              and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl2) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl1)
                              and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FMovActive := FMovActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl1)
                              and KeyCtrlInShift(FKeyControl2));
    end
    else FMovActive := FMovActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl2)
                                 and KeyCtrlInShift(FKeyControl3));
  end;
  if not (csDesigning in ComponentState) then
  begin
    if not FMovActive then
    begin
      //DoShowTools(False);
      FCtrlSelectMgr.ClearCtrlSelection;
    end;
    FCtrlSelectMgr.SetActiveCtrls(FMovActive);
  end;
end;

{procedure TMovControl.DoShowTools(AActive: Boolean);
begin
  if AActive then
  begin
    if not Assigned(FToolsFrm) then
    begin
      FToolsFrm := TToolsFrm.Create(FOwnerForm);
      FToolsFrm.Show;
      FOwnerForm.SetFocus;
    end;
  end
  else FreeAndNil(FToolsFrm);
end;}

procedure TMovControl.OwnerFormKeyDown(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
var
  CurActive : Boolean;
begin
  CurActive := FMovActive;
  KeyActive(Key, Shift);

  if FShowTools then FShowTools := not (Key = VK_F4)
                else FShowTools := (Key = VK_F4);
  FShowTools := FShowTools and FMovActive;
  //DoShowTools(FShowTools);
  if CurActive <> FMovActive then if FMovActive and FShowGrid then FPosGrid.Show
                                                              else FPosGrid.Hide;
  if not (csDesigning in ComponentState) then
  begin
    if not FMovActive then FCtrlSelectMgr.SaveCtrlParams;
    if Assigned(FOriKeyDown) then FOriKeyDown(Sender, Key, Shift);
  end;
end;

procedure TMovControl.SetOwnerForm;
var
  cOwner : TComponent;
begin
  if Owner is TForm then
  begin
    FOwnerForm := Owner as TForm;
    Exit;
  end;
  cOwner := Owner;
  repeat
    cOwner := cOwner.Owner;
    if cOwner is TForm then FOwnerForm := cOwner as TForm;
  until (cOwner = nil) or (cOwner is TForm);
end;

procedure TMovControl.SetKeyControl1(const Value: TKeyControl);
begin
  if (Value = kcNone) then
  begin
    FKeyControl1 := Value;
    Exit;
  end;
  if (Value = FKeyControl2) or (Value = FKeyControl3) then
  begin
    ShowMessage(rsKeyCtrlMustDifferent);
    FKeyControl1 := kcNone;
  end
  else if KeyControlIsChar(Value) and
         (KeyControlIsChar(FKeyControl2) or KeyControlIsChar(FKeyControl3)) then
  begin
    ShowMessage(rsKeyCtrlOneChar);
    FKeyControl1 := kcNone;
  end
  else FKeyControl1 := Value;
end;

procedure TMovControl.SetKeyControl2(const Value: TKeyControl);
begin
  if (Value = kcNone) then
  begin
    FKeyControl1 := Value;
    Exit;
  end;
  if (Value = FKeyControl1) or (Value = FKeyControl3) then
  begin
    ShowMessage(rsKeyCtrlMustDifferent);
    FKeyControl2 := kcNone;
  end
  else if KeyControlIsChar(Value) and
         (KeyControlIsChar(FKeyControl1) or KeyControlIsChar(FKeyControl3)) then
  begin
    ShowMessage(rsKeyCtrlOneChar);
    FKeyControl1 := kcNone;
  end
  else FKeyControl2 := Value;
end;

procedure TMovControl.SetKeyControl3(const Value: TKeyControl);
begin
  if (Value = kcNone) then
  begin
    FKeyControl1 := Value;
    Exit;
  end;
  if (Value = FKeyControl1) or (Value = FKeyControl2) then
  begin
    ShowMessage(rsKeyCtrlMustDifferent);
    FKeyControl1 := kcNone;
  end
  else if KeyControlIsChar(Value) and
         (KeyControlIsChar(FKeyControl1) or KeyControlIsChar(FKeyControl2)) then
  begin
    ShowMessage(rsKeyCtrlOneChar);
    FKeyControl3 := kcNone;
  end
  else FKeyControl3 := Value;
end;

function TMovControl.VKToKeyControl(const AVKKey: Word): TKeyControl;
begin
  case AVKKey of
    VK_CONTROL         : Result := kcCtrl;
    VK_MENU            : Result := kcAlt;
    VK_SHIFT           : Result := kcShift;
    Ord('A'), Ord('a') : Result := kc_A;
    Ord('B'), Ord('b') : Result := kc_B;
    Ord('C'), Ord('c') : Result := kc_C;
    Ord('D'), Ord('d') : Result := kc_D;
    Ord('E'), Ord('e') : Result := kc_E;
    Ord('F'), Ord('f') : Result := kc_F;
    Ord('G'), Ord('g') : Result := kc_G;
    Ord('H'), Ord('h') : Result := kc_H;
    Ord('I'), Ord('i') : Result := kc_I;
    Ord('J'), Ord('j') : Result := kc_J;
    Ord('K'), Ord('k') : Result := kc_K;
    Ord('L'), Ord('l') : Result := kc_L;
    Ord('M'), Ord('m') : Result := kc_M;
    Ord('N'), Ord('n') : Result := kc_N;
    Ord('O'), Ord('o') : Result := kc_O;
    Ord('P'), Ord('p') : Result := kc_P;
    Ord('Q'), Ord('q') : Result := kc_Q;
    Ord('R'), Ord('r') : Result := kc_R;
    Ord('S'), Ord('s') : Result := kc_S;
    Ord('T'), Ord('t') : Result := kc_T;
    Ord('U'), Ord('u') : Result := kc_U;
    Ord('V'), Ord('v') : Result := kc_V;
    Ord('W'), Ord('w') : Result := kc_W;
    Ord('X'), Ord('x') : Result := kc_X;
    Ord('Y'), Ord('y') : Result := kc_Y;
    Ord('Z'), Ord('z') : Result := kc_Z;
    else                 Result := kcNone;
  end;
end;

function TMovControl.KeyControlIsChar(AKeyControl : TKeyControl): Boolean;
begin
  Result := AKeyControl in [kc_A, kc_B, kc_C, kc_D, kc_E, kc_F, kc_G, kc_H, kc_I, kc_J,
                            kc_K, kc_L, kc_M, kc_N, kc_O, kc_P, kc_Q, kc_R, kc_S, kc_T,
                            kc_U, kc_V, kc_W, kc_X, kc_Y, kc_Z];
end;

procedure TMovControl.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if not (csDesigning in ComponentState) then
  begin
    FCtrlSelectMgr.SetActiveCtrls(FMovActive);
  end;
end;

procedure TMovControl.SetShowGrid(const Value: Boolean);
begin
  FShowGrid := Value;
  if not (csDesigning in ComponentState) then
  begin
    if FShowGrid then FPosGrid.Show
                 else FPosGrid.Hide;
  end;
end;

procedure TMovControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('CtrlTypes', ReadCtrlTypes, WriteCtrlTypes, True);
  Filer.DefineProperty('CtrlNames', ReadCtrlNames, WriteCtrlNames, True);
end;

procedure TMovControl.WriteCtrlTypes(Writer: TWriter);
var
  i: integer;
begin
  Writer.WriteListBegin;
  for i:=0 to FControlTypes.Count - 1 do
  begin
    Writer.WriteString(FControlTypes.Names[i]);
  end;
  Writer.WriteListEnd;
end;

procedure TMovControl.ReadCtrlTypes(Reader: TReader);
begin
  FControlTypes.Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    FControlTypes.Add(Reader.ReadString);
  end;
  Reader.ReadListEnd;
end;

procedure TMovControl.ReadCtrlNames(Reader: TReader);
begin
  FControlNames.Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    FControlNames.Add(Reader.ReadString);
  end;
  Reader.ReadListEnd;
end;

procedure TMovControl.WriteCtrlNames(Writer: TWriter);
var
  i: integer;
begin
  Writer.WriteListBegin;
  for i:=0 to FControlNames.Count - 1 do
  begin
    Writer.WriteString(FControlNames.Names[i]);
  end;
  Writer.WriteListEnd;
end;

end.
