unit UMovControl;

interface

uses
  SysUtils, Classes,
  Controls, Contnrs, Forms, UToolsFrm, UCtrlSelector;

type

  TKeyControl = (kcNone, kcCtrl, kcAlt, kcShift, kc_A, kc_B, kc_C, kc_D, kc_E, kc_F, kc_G,
                 kc_H, kc_I, kc_J, kc_K, kc_L, kc_M, kc_N, kc_O, kc_P, kc_Q, kc_R, kc_S,
                 kc_T, kc_U, kc_V, kv_W, kc_X, kc_Y, kc_Z);

  TMovControl = class(TComponent)
  private
    FPosGrid : TPosGrid;
    FActive : Boolean;
    FShowTools : Boolean;
    FShowGrid : Boolean;
    FGridAlign : Boolean;
    FKeyControl1 : TKeyControl;
    FKeyControl2 : TKeyControl;
    FKeyControl3 : TKeyControl;
    FCtrlList : TObjectList;
    FSelectorList : TObjectList;
    FCurCtrlSel : TCtrlSelector;
    FMultiSelect : Boolean;
    FMoving : Boolean;
    FXStart : Integer;
    FYStart : Integer;
    FOwnerForm : TForm;
    FOriKeyDown : TKeyEvent;
    FOriMouseDown : TMouseEvent;
    FOriMouseUp : TMouseEvent;
    FOriMouseMove : TMouseMoveEvent;
    FOriFormShow : TNotifyEvent;
    FToolsFrm : TToolsFrm;
    FCtrlParams : TCtrlParams;
    function CtrlSelected(AControl : TControl) : Boolean;
    function IsMultiSelect : Boolean;
    function IsControlReferred(ACtrl: TControl) : Boolean;
    function KeyControlIsChar(AKeyControl : TKeyControl) : Boolean;
    function ControlByPos(const X, Y : integer) : TControl;
    procedure DoShowTools(AActive : Boolean = True);
    procedure SetOwnerForm;
    procedure OwnerFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OwnerFormMouseDown(Sender : TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
    procedure OwnerFormMouseUp(Sender : TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
    procedure OwnerFormMouseMove(Sender : TObject; Shift: TShiftState; X, Y: Integer);
    procedure OwnerFormShow(Sender : TObject);
    function VKToKeyControl(const AVKKey : Word) : TKeyControl;
    procedure SetActiveCtrls(AActive : Boolean);
    procedure SelectControl(AControl : TControl; AShift: TShiftState; const X, Y: Integer);
    procedure SetMovingOn(const AButton : TMouseButton; X, Y : Integer);
    procedure SetMovingOff(const AButton : TMouseButton; X, Y : Integer);
    procedure ShowCtrlPos;
    procedure KeyActive(const AKey : Word; AShift : TShiftState);
    procedure ClearCtrlSelection;
    procedure SetKeyControl1(const Value: TKeyControl);
    procedure SetKeyControl2(const Value: TKeyControl);
    procedure SetKeyControl3(const Value: TKeyControl);
    procedure SetActive(const Value: Boolean);
    procedure SetShowGrid(const Value: Boolean);
    {$ifdef DEMO}
    procedure SaveCtrlParams;
    procedure FillCtrlList;
    property Active : Boolean read FActive write SetActive;
    property GridAlign : Boolean read FGridAlign write FGridAlign default False;
    property ShowTools : Boolean read FShowTools write FShowTools default False;
    property ShowGrid : Boolean read FShowGrid write SetShowGrid default False;
    property MultiSelect : Boolean read FMultiSelect write FMultiSelect default True;
    {$endif}
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure MoveAllSelCtrls(const AdX, AdY : integer);
    {$ifndef DEMO}
    procedure SaveCtrlParams;
    procedure FillCtrlList;
    {$endif}
  published
    {$ifndef DEMO}
    property Active : Boolean read FActive write SetActive;
    property GridAlign : Boolean read FGridAlign write FGridAlign default False;
    property ShowTools : Boolean read FShowTools write FShowTools default False;
    property ShowGrid : Boolean read FShowGrid write SetShowGrid default False;
    property MultiSelect : Boolean read FMultiSelect write FMultiSelect default True;
    {$endif}
    property KeyControl1 : TKeyControl read FKeyControl1 write SetKeyControl1 default kcNone;
    property KeyControl2 : TKeyControl read FKeyControl2 write SetKeyControl2 default kcNone;
    property KeyControl3 : TKeyControl read FKeyControl3 write SetKeyControl3 default kcNone;
  end;

procedure Register;

implementation

uses Windows, StdCtrls, Dialogs, UTextRessources;

{ TMovControl }

function TMovControl.ControlByPos(const X, Y: integer): TControl;
var
  idx : integer;
  c : TControl;
begin
  Result := nil;
  for idx := 0 to FCtrlList.Count - 1 do
  begin
    c := FCtrlList.Items[idx] as TControl;
    if (X >= c.Left) and (X <= (c.Left + c.Width)) and
       (Y >= c.Top) and (Y <= (c.Top + c.Height)) then
    begin
      Result := c;
      Break;
    end;
  end;
end;

constructor TMovControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  SetOwnerForm;
  FCtrlParams := TCtrlParams.Create(FOwnerForm);
  FActive := False;
  FShowTools := False;
  FShowGrid := False;
  FGridAlign := False;
  FMultiSelect := True;
  if not (csDesigning in ComponentState) then
  begin
    FCtrlList := TObjectList.Create(False);
    if Assigned(FOwnerForm) then
    begin
      FPosGrid := TPosGrid.Create(FOwnerForm);
      FOriKeyDown := FOwnerForm.OnKeyDown;
      FOriMouseDown := FOwnerForm.OnMouseDown;
      FOriMouseUp := FOwnerForm.OnMouseUp;
      FOriMouseMove := FOwnerForm.OnMouseMove;
      FOriFormShow := FOwnerForm.OnShow;
      FOwnerForm.OnKeyDown := OwnerFormKeyDown;
      FOwnerForm.OnMouseDown := OwnerFormMouseDown;
      FOwnerForm.OnMouseUp := OwnerFormMouseUp;
      FOwnerForm.OnMouseMove := OwnerFormMouseMove;
      FOwnerForm.OnShow := OwnerFormShow;
      FOwnerForm.KeyPreview := True;
    end;
    FSelectorList := TObjectList.Create;
  end;
end;

destructor TMovControl.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FOwnerForm) then
    begin
      FOwnerForm.OnKeyDown := FOriKeyDown;
      FOwnerForm.OnMouseDown := FOriMouseDown;
      FOwnerForm.OnMouseUp := FOriMouseUp;
      FOwnerForm.OnMouseMove := FOriMouseMove;
    end;
    FOwnerForm := nil;
    FCtrlList.Free;
    FSelectorList.Free;
    FPosGrid.Free;
  end
  else FCtrlParams.Free;
  inherited;
end;

procedure TMovControl.FillCtrlList;
var
  idx : integer;
  Ctrl : TControl;
begin
  for idx := 0 to FOwnerForm.ControlCount - 1 do
  begin
    Ctrl := FOwnerForm.Controls[idx] as TControl;
    if ((Ctrl is TEdit) or
       (Ctrl is TLabel) or
       (Ctrl is TListBox) or
       (Ctrl is TMemo))
       and
       not IsControlReferred(Ctrl) then
    begin
      FCtrlList.Add(Ctrl);
    end;
  end;
end;

procedure TMovControl.SetActiveCtrls(AActive : Boolean);
var
  idx : integer;
begin
  for idx := 0 to FCtrlList.Count - 1 do
  begin
    (FCtrlList.Items[idx] as TControl).Enabled := not AActive;
  end;
end;

procedure TMovControl.SetMovingOff(const AButton: TMouseButton; X, Y: Integer);
var
  dX, dY : integer;
begin
  if (not FActive) or (AButton <> mbLeft) or (not Assigned(FCurCtrlSel)) then Exit;
  dX := X - FXStart;
  dY := Y - FYStart;
  FCurCtrlSel.Left := FCurCtrlSel.Left + dX;
  FCurCtrlSel.Top := FCurCtrlSel.Top + dY;
  FCurCtrlSel := nil;
  FMoving := False;
end;

procedure TMovControl.SetMovingOn(const AButton : TMouseButton; X, Y : Integer);
begin
  if (not FActive) or (AButton <> mbLeft) then Exit;
  if Assigned(FCurCtrlSel) then
  begin
    FXStart := X;
    FYStart := Y;
    FMoving := True;
    ShowCtrlPos;
  end
  else FMoving := False;
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
  if (FKeyControl1 = kcNone) and (FKeyControl2 = kcNone) and (KeyControl3 = kcNone) then Exit;
  KeyControl := VKToKeyControl(AKey);
  if KeyControl = kcNone then Exit;
  //4 cases ..
  //1st case : 011
  if (FKeyControl1 = kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl2) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl2));
    end
    else FActive := FActive xor (KeyCtrlInShift(FKeyControl2) and KeyCtrlInShift(FKeyControl3));
  end;

  //2nd case : 101
  if (FKeyControl1 <> kcNone) and (FKeyControl2 = kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl1));
    end
    else FActive := FActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl3));
  end;

  //3rd case : 110
  if (FKeyControl1 <> kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 = kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl2));
    end
    else
    if KeyControlIsChar(FKeyControl2) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl1));
    end
    else FActive := FActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl2));
  end;

  //4rd case : 111
  if (FKeyControl1 <> kcNone) and (FKeyControl2 <> kcNone) and (KeyControl3 <> kcNone) then
  begin
    if KeyControlIsChar(FKeyControl1) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl1) and KeyCtrlInShift(FKeyControl2)
                              and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl2) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl2) and KeyCtrlInShift(FKeyControl1)
                              and KeyCtrlInShift(FKeyControl3));
    end
    else
    if KeyControlIsChar(FKeyControl3) then
    begin
      FActive := FActive xor ((KeyControl = FKeyControl3) and KeyCtrlInShift(FKeyControl1)
                              and KeyCtrlInShift(FKeyControl2));
    end
    else FActive := FActive xor (KeyCtrlInShift(FKeyControl1) and KeyCtrlInShift(FKeyControl2)
                                 and KeyCtrlInShift(FKeyControl3));
  end;

  if not FActive then
  begin
    DoShowTools(False);
    ClearCtrlSelection;
  end;  
  SetActiveCtrls(FActive);
end;

procedure TMovControl.DoShowTools(AActive: Boolean);
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
end;

procedure TMovControl.OwnerFormKeyDown(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
var
  CurActive : Boolean;
begin
  CurActive := FActive;
  KeyActive(Key, Shift);
  {$ifdef DEMO}
  FShowTools := False;
  {$else}
  if FShowTools then FShowTools := not (Key = VK_F4)
                else FShowTools := (Key = VK_F4);
  FShowTools := FShowTools and FActive;
  DoShowTools(FShowTools);
  if CurActive <> FActive then if FActive and FShowGrid then FPosGrid.Show
                                                        else FPosGrid.Hide;
  {$endif}
  if not FActive then FCtrlParams.SaveCtrlParams(FCtrlList);
  if Assigned(FOriKeyDown) then FOriKeyDown(Sender, Key, Shift);
end;

procedure TMovControl.OwnerFormMouseDown(Sender: TObject; Button: TMouseButton;
                                         Shift: TShiftState; X, Y: Integer);
var
  CurCtrl : TControl;
begin
  CurCtrl := ControlByPos(X,Y);
  SelectControl(CurCtrl, Shift, X, Y);
  SetMovingOn(Button, X, Y);
  if Assigned(FOriMouseDown) then FOriMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TMovControl.OwnerFormMouseMove(Sender: TObject; Shift: TShiftState;
                                         X, Y: Integer);
var
  dX, dY : integer;
begin
  dX := X - FXStart;
  dY := Y - FYStart;
  if (not FActive) or ((dX = 0) and (dY = 0)) then Exit;
  if FMoving and Assigned(FCurCtrlSel) then
  begin
    if FShowGrid then
    begin
      FCurCtrlSel.Left := FCurCtrlSel.Left + dX;
      if (FCurCtrlSel.Left mod FPosGrid.Step) > 0 then
      begin
        if dX > 0 then FCurCtrlSel.Left := ((FCurCtrlSel.Left div FPosGrid.Step) + 1) * FPosGrid.Step
                  else FCurCtrlSel.Left := (FCurCtrlSel.Left div FPosGrid.Step) * FPosGrid.Step;
      end;
      FCurCtrlSel.Top := FCurCtrlSel.Top + dY;
      if (FCurCtrlSel.Top mod FPosGrid.Step) > 0 then
      begin
        if dY > 0 then FCurCtrlSel.Top := ((FCurCtrlSel.Top div FPosGrid.Step) + 1) * FPosGrid.Step
                  else FCurCtrlSel.Top := (FCurCtrlSel.Top div FPosGrid.Step) * FPosGrid.Step;
      end;
    end
    else
    begin
      FCurCtrlSel.Left := FCurCtrlSel.Left + dX;
      FCurCtrlSel.Top := FCurCtrlSel.Top + dY;
    end;
    ShowCtrlPos;
    FXStart := X;
    FYStart := Y;
  end;
end;

procedure TMovControl.OwnerFormMouseUp(Sender: TObject; Button: TMouseButton;
                                       Shift: TShiftState; X, Y: Integer);
begin
  SetMovingOff(Button, X, Y);
  Screen.Cursor := crDefault;
  if Assigned(FOriMouseUp) then FOriMouseUp(Sender, Button, Shift, X, Y);
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
    else                 Result := kcNone;
  end;
end;

function TMovControl.KeyControlIsChar(AKeyControl : TKeyControl): Boolean;
begin
  Result := AKeyControl in [kc_A, kc_B, kc_C, kc_D, kc_E, kc_F, kc_G, kc_H, kc_I, kc_J,
                            kc_K, kc_L, kc_M, kc_N, kc_O, kc_P, kc_Q, kc_R, kc_S, kc_T,
                            kc_U, kc_V, kv_W, kc_X, kc_Y, kc_Z];
end;

procedure TMovControl.SelectControl(AControl: TControl; AShift: TShiftState;
                                    const X, Y: Integer);
begin
  if (not FMultiSelect) or (not (ssShift in AShift)) or
     (not Assigned(AControl)) then ClearCtrlSelection;
  if Assigned(AControl) and (not CtrlSelected(AControl)) then
  begin
    FCurCtrlSel := TCtrlSelector.Create(FOwnerForm);
    FCurCtrlSel.Select(AControl, Self);
    FSelectorList.Add(FCurCtrlSel);
    if IsMultiSelect then
    begin
      FCurCtrlSel.SetMultiSelected;
      (FSelectorList.Items[0] as TCtrlSelector).SetMultiSelected;
    end;
  end;
end;

function TMovControl.IsMultiSelect: Boolean;
begin
  Result := FSelectorList.Count > 1;
end;

procedure TMovControl.ClearCtrlSelection;
var
  idx : integer;
begin
  for idx := 0 to FSelectorList.Count - 1 do
  begin
    (FSelectorList.Items[idx] as TCtrlSelector).UnSelect;
  end;
  FSelectorList.Clear;
end;

procedure TMovControl.SetActive(const Value: Boolean);
begin
  FActive := Value;
  SetActiveCtrls(FActive);
end;

function TMovControl.CtrlSelected(AControl: TControl): Boolean;
var
  idx : integer;
begin
  Result := False;
  for idx := 0 to FSelectorList.Count - 1 do
  begin
     Result := UpperCase((FSelectorList.Items[idx] as TCtrlSelector).SelCtrlName) =
               UpperCase(AControl.Name);
     if Result then Break;
  end;
end;

procedure TMovControl.MoveAllSelCtrls(const AdX, AdY: integer);
var
  idx : integer;
  SelCtrl : TCtrlSelector;
begin
  if not FMultiSelect then Exit;
  for idx := 0 to FSelectorList.Count - 1 do
  begin
    SelCtrl := FSelectorList.Items[idx] as TCtrlSelector;
    SelCtrl.Left := SelCtrl.Left + AdX;
    SelCtrl.Top := SelCtrl.Top + AdY;
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

procedure TMovControl.ShowCtrlPos;
begin
  if not FShowTools or not Assigned(FToolsFrm) or not Assigned(FCurCtrlSel) then Exit;
  FToolsFrm.lblXY.Caption := IntToStr(FCurCtrlSel.LeftPosition) + ':' + IntToStr(FCurCtrlSel.TopPosition);
end;

procedure TMovControl.SaveCtrlParams;
begin
  FCtrlParams.SaveCtrlParams(FCtrlList);
end;

procedure TMovControl.OwnerFormShow(Sender: TObject);
begin
  FillCtrlList;
  FCtrlParams.SetCtrlParams(FCtrlList); //set controls parameters
end;

function TMovControl.IsControlReferred(ACtrl: TControl): Boolean;
var
  idx : integer;
  Ctrl : TControl;
begin
  Result := False;
  if FCtrlList.Count = 0 then Exit;
  for idx := 0 to FCtrlList.Count - 1 do
  begin
    Ctrl := FCtrlList.Items[idx] as TControl;
    Result := ACtrl.Name = Ctrl.Name;
    if Result then Break;
  end;
end;

procedure Register;
begin
  RegisterComponents('AMComponents', [TMovControl]);
end;

end.
