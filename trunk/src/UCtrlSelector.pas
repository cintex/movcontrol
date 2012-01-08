unit UCtrlSelector;

interface
{-----------------------------------------------------------------------------------
About box
Copyright (C) 2003  Abdelhamid MEDDEB, abdelhamid@meddeb.net

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

uses ExtCtrls,
     Windows,
     Classes,
     Forms,
     Messages,
     Registry,
     Contnrs,
     Controls;

type

  TCtrlPosLocation = (cplNone, cplLeft, cplTopLeft, cplTop, cplTopRight, cplRight,
                      cplBottomRight, cplBottom, cplBottomLeft, cplCenter);

  TCtrlProperty = record
    Name      : String;
    Left      : integer;
    Top       : integer;
    Width     : integer;
    Height    : integer;
    AnchLeft  : Boolean;
    AnchTop   : Boolean;
    AnchRight : Boolean;
    AnchBottom: Boolean;
  end;

  TCtrlParams = class
  private
    FSaveFileName : String;
    FSaveFieldName: String;
    FSoftVendorName : String;
    FAppDataFolder : String;
    FIdForm : String;
    FIsSaveToFile : boolean;
    FCtrlList : array of TCtrlProperty;
    function AddCtrlProperty : TCtrlProperty;
    function AppDataFolder : String;
    function CtrlPropertiesByName(const ACtrlName : String) : TCtrlProperty;
    function ParamFileName : String;
    function HashCode(AFormName : String = '') : string;
    function GetCtrlCount: integer;
    function GetCtrlProperty(ACtrlName: String): TCtrlProperty;
  public
    constructor Create(AForm : TForm);
    procedure AddCtrl(ACtrl : TControl);
    procedure SaveCtrlParams(ACtrlList : TObjectList);
    procedure SetCtrlParams(ACtrlList : TObjectList);
    procedure Clear;
    property CtrlCount : integer read GetCtrlCount;
    property CtrlProperties[ACtrlName : String] : TCtrlProperty read GetCtrlProperty;
    property SaveFieldName : String read FSaveFieldName write FSaveFieldName;
    property SaveFileName : String read FSaveFileName write FSaveFileName;
    property SoftVendorName : String read FSoftVendorName write FSoftVendorName;
    property IsSaveToFile : boolean read FIsSaveToFile write FIsSaveToFile;
  end;

  TCtrlSelector = class(TCustomPanel)
  private
    FCtrlParent : TWinControl;
    FCtrlSelected : TControl;
    FPosControl : TComponent;
    FCtrlCursor : TCursor;
    FCtrlAnchors : TAnchors;
    //FCtrlMouseMove : TMouseMoveEvent;
    FCurPosLocation : TCtrlPosLocation;
    FMoving : Boolean;
    FMultiSel : Boolean;
    FCurX : integer;
    FCurY : integer;
    function BevelPos : integer;
    function CurControlPos(const AX, AY : integer) : TCtrlPosLocation;
    function RectTopLeft : TRect;
    function RectTopRight : TRect;
    function RectBottomLeft : TRect;
    function RectBottomRight : TRect;
    function RectTop : TRect;
    function RectRight : TRect;
    function RectBottom : TRect;
    function RectLeft : TRect;
    procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MouseDownEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
                             X, Y: Integer);
    procedure MouseUpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
                           X, Y: Integer);
    function GetSelCtrlName: String;
    function GetLeftPosition: integer;
    function GetTopPosition: integer;
  protected
    procedure Paint; override;
  public
    constructor create(AOwner : TComponent);override;
    procedure Select(AControl : TControl; APosControl : TComponent);
    procedure UnSelect;
    procedure SetMultiSelected;
    property SelCtrlName : String read GetSelCtrlName;
    property LeftPosition : integer read GetLeftPosition;
    property TopPosition : integer read GetTopPosition;
  end;

  TPosGrid = class
  private
    FOwnerFrm : TForm;
    FStep : integer;
    FVisible : boolean;
    FOriFormPaint : TNotifyEvent;
    procedure SetStep(const Value: integer);
  protected
    procedure FormPaint(Sender : TObject);
  public
    constructor Create(AOwnerFrm : TForm);
    destructor destroy; override;
    procedure Show;
    procedure Hide;
    property Step : integer read FStep write SetStep;
  end;


implementation

uses Graphics,
     UMovControl,
     StdCtrls,
     FileCtrl,
     IniFiles,
     SysUtils;

const
  FORMS_PARAMS_TAG = 'FormsParms_';
  TOP_TAG = 'Top';
  LEFT_TAG = 'Left';
  HEIGHT_TAG = 'Height';
  WIDTH_TAG = 'Width';
  RGSTRKEY_USER_APPDATA = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';

{ TCtrlSelector }

function TCtrlSelector.BevelPos: integer;
begin
  Result := 5;
end;

constructor TCtrlSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TWinControl then Parent := AOwner as TWinControl;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  FMoving := False;
  Caption := '';
  OnMouseMove := MouseMoveEvent;
  OnMouseDown := MouseDownEvent;
  OnMouseUp := MouseUpEvent;
end;

function TCtrlSelector.CurControlPos(const AX, AY: integer): TCtrlPosLocation;
begin
  if (RectTopLeft.Left <= AX) and (RectTopLeft.Right >= AX) and
     (RectTopLeft.Top <= AY) and (RectTopLeft.Bottom >= AY) then
  begin
    Result := cplTopLeft;
  end
  else
  if (RectTopRight.Left <= AX) and (RectTopRight.Right >= AX) and
     (RectTopRight.Top <= AY) and (RectTopRight.Bottom >= AY) then
  begin
    Result := cplTopRight;
  end
  else
  if (RectBottomLeft.Left <= AX) and (RectBottomLeft.Right >= AX) and
     (RectBottomLeft.Top <= AY) and (RectBottomLeft.Bottom >= AY) then
  begin
    Result := cplBottomLeft;
  end
  else
  if (RectBottomRight.Left <= AX) and (RectBottomRight.Right >= AX) and
     (RectBottomRight.Top <= AY) and (RectBottomRight.Bottom >= AY) then
  begin
    Result := cplBottomRight;
  end
  else
  if (RectTop.Left <= AX) and (RectTop.Right >= AX) and
     (RectTop.Top <= AY) and (RectTop.Bottom >= AY) then
  begin
    Result := cplTop;
  end
  else
  if (RectRight.Left <= AX) and (RectRight.Right >= AX) and
     (RectRight.Top <= AY) and (RectRight.Bottom >= AY) then
  begin
    Result := cplRight;
  end
  else
  if (RectBottom.Left <= AX) and (RectBottom.Right >= AX) and
     (RectBottom.Top <= AY) and (RectBottom.Bottom >= AY) then
  begin
    Result := cplBottom;
  end
  else
  if (RectLeft.Left <= AX) and (RectLeft.Right >= AX) and
     (RectLeft.Top <= AY) and (RectLeft.Bottom >= AY) then
  begin
    Result := cplLeft;
  end
  else Result := cplNone;
end;

procedure TCtrlSelector.Select(AControl: TControl; APosControl : TComponent);
begin
  Width := AControl.Width + 2 * BevelPos;
  Height := AControl.Height + 2 * BevelPos;
  Left := AControl.Left - BevelPos;
  Top := AControl.Top - BevelPos;
  FCtrlAnchors := AControl.Anchors;
  FCtrlParent := AControl.Parent;
  FCtrlCursor := AControl.Cursor;
  AControl.Parent := Self;
  AControl.Top := BevelPos;
  AControl.Left := BevelPos;
  AControl.Anchors := [akLeft, akRight, akTop, akBottom];
  Screen.Cursor := crSizeAll;
  AControl.Cursor := crSizeAll;
  FCtrlSelected := AControl;
  if APosControl is TMovControl then FPosControl := APosControl as TMovControl;
end;

procedure TCtrlSelector.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  if FMoving then
  begin
    case FCurPosLocation of
      cplRight   :  begin
                      Width := Width + X - FCurX;
                      FCurX := X;
                    end;
      cplLeft    :  begin
                      Width := Width - (X - FCurX);
                      Left := Left + (X - FCurX);
                    end;
      cplTop     :  begin
                      Height := Height - (Y - FCurY);
                      Top := Top + (Y - FCurY);
                    end;
      cplBottom  :  begin
                      Height := Height + Y - FCurY;
                      FCurY := Y;
                    end;
      cplTopLeft :  begin
                      Height := Height - (Y - FCurY);
                      Top := Top + (Y - FCurY);
                      Width := Width - (X - FCurX);
                      Left := Left + (X - FCurX);
                    end;
      cplTopRight : begin
                      Height := Height - (Y - FCurY);
                      Top := Top + (Y - FCurY);
                      Width := Width + X - FCurX;
                      FCurX := X;
                    end;
      cplBottomRight : begin
                         Height := Height + Y - FCurY;
                         FCurY := Y;
                         Width := Width + X - FCurX;
                         FCurX := X;
                       end;
      cplBottomLeft :  begin
                         Height := Height + Y - FCurY;
                         FCurY := Y;
                         Width := Width - (X - FCurX);
                         Left := Left + (X - FCurX);
                       end;
      else          begin
                      if FMultiSel and Assigned(FPosControl) then
                      begin
                        (FPosControl as TMovControl).MoveAllSelCtrls(X - FCurX, Y - FCurY);
                      end
                      else
                      begin
                        Left := Left + (X - FCurX);
                        Top := Top + (Y - FCurY);
                      end;
                    end;
    end;
  end
  else if not FMultiSel then
  begin
    FCurPosLocation := CurControlPos(X, Y);
    case FCurPosLocation of
      cplLeft,
      cplRight       : Cursor := crSizeWE;
      cplTopLeft,
      cplBottomRight : Cursor := crSizeNWSE;
      cplTop,
      cplBottom      : Cursor := crSizeNS;
      cplTopRight,
      cplBottomLeft  : Cursor := crSizeNESW;
      else Cursor := crSizeAll;
    end;
  end;
end;

procedure TCtrlSelector.Paint;
begin
  inherited;
  if FMultiSel then Canvas.Brush.Color := clGray
               else Canvas.Brush.Color := clBlack;
  Canvas.FillRect(RectTopLeft);
  Canvas.FillRect(RectTopRight);
  Canvas.FillRect(RectBottomRight);
  Canvas.FillRect(RectBottomLeft);
  Canvas.FillRect(RectTop);
  Canvas.FillRect(RectRight);
  Canvas.FillRect(RectBottom);
  Canvas.FillRect(RectLeft);
end;

function TCtrlSelector.RectBottom: TRect;
var
  Middle : integer;
begin
  Middle := Round(Width / 2) - Round(BevelPos / 2);
  Result := Rect(Middle, Height - BevelPos, Middle + BevelPos, Height);
end;

function TCtrlSelector.RectBottomLeft: TRect;
begin
  Result := Rect(0, Height - BevelPos, BevelPos, Height);
end;

function TCtrlSelector.RectBottomRight: TRect;
begin
  Result := Rect(Width - BevelPos, Height - BevelPos, Width, Height);
end;

function TCtrlSelector.RectLeft: TRect;
var
  Middle : integer;
begin
  Middle := Round(Height / 2) - Round(BevelPos / 2);
  Result := Rect(0, Middle, BevelPos, Middle + BevelPos);
end;

function TCtrlSelector.RectRight: TRect;
var
  Middle : integer;
begin
  Middle := Round(Height / 2) - Round(BevelPos / 2);
  Result := Rect(Width - BevelPos, Middle, Width, Middle + BevelPos);
end;

function TCtrlSelector.RectTop: TRect;
var
  Middle : integer;
begin
  Middle := Round(Width / 2) - Round(BevelPos / 2);
  Result := Rect(Middle, 0, Middle + BevelPos, BevelPos);
end;

function TCtrlSelector.RectTopLeft: TRect;
begin
  Result := Rect(0, 0, BevelPos, BevelPos);
end;

function TCtrlSelector.RectTopRight: TRect;
begin
  Result := Rect(Width - BevelPos, 0, Width, BevelPos);
end;

procedure TCtrlSelector.UnSelect;
begin
  FCtrlSelected.Top := Top + BevelPos;
  FCtrlSelected.Left := Left + BevelPos;
  FCtrlSelected.Anchors := FCtrlAnchors;
  FCtrlSelected.Parent := FCtrlParent;
  FCtrlSelected.Cursor := FCtrlCursor;
  FCtrlSelected := nil;
  FMultiSel := False;
end;

procedure TCtrlSelector.MouseDownEvent(Sender: TObject; Button: TMouseButton;
                                       Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FMoving := True;
    FCurX := X;
    FCurY := Y;
  end;
end;

procedure TCtrlSelector.MouseUpEvent(Sender: TObject; Button: TMouseButton;
                                     Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FMoving := False;
end;

function TCtrlSelector.GetSelCtrlName: String;
begin
  if Assigned(FCtrlSelected) then Result := FCtrlSelected.Name
                             else Result := '';
end;

procedure TCtrlSelector.SetMultiSelected;
begin
  FMultiSel := True;
  Invalidate;
end;

function TCtrlSelector.GetLeftPosition: integer;
begin
  Result := Left + BevelPos;
end;

function TCtrlSelector.GetTopPosition: integer;
begin
  Result := Top + BevelPos;
end;

{ TCtrlParams }

procedure TCtrlParams.AddCtrl(ACtrl: TControl);
var
  gCtrl : TGraphicControl;
  wCtrl : TWinControl;
  CtrlProp : TCtrlProperty;
begin
  CtrlProp := CtrlPropertiesByName(ACtrl.Name);
  if Trim(CtrlProp.Name) = '' then CtrlProp := AddCtrlProperty;
  if ACtrl is TWinControl then
  begin
    wCtrl := ACtrl as TWinControl;
    CtrlProp.Left := wCtrl.Left;
    CtrlProp.Top := wCtrl.Top;
    CtrlProp.Width := wCtrl.Width;
    CtrlProp.Height := wCtrl.Height;
    if akLeft in wCtrl.Anchors then CtrlProp.AnchLeft := True
                               else CtrlProp.AnchLeft := False;
    if akTop in wCtrl.Anchors then CtrlProp.AnchTop := True
                              else CtrlProp.AnchTop := False;
    if akRight in wCtrl.Anchors then CtrlProp.AnchRight := True
                                else CtrlProp.AnchRight := False;
    if akBottom in wCtrl.Anchors then CtrlProp.AnchBottom := True
                                 else CtrlProp.AnchBottom := False;
  end
  else if ACtrl is TGraphicControl then
  begin
    gCtrl := ACtrl as TGraphicControl;
    CtrlProp.Left := gCtrl.Left;
    CtrlProp.Top := gCtrl.Top;
    CtrlProp.Width := gCtrl.Width;
    CtrlProp.Height := gCtrl.Height;
    if akLeft in gCtrl.Anchors then CtrlProp.AnchLeft := True
                               else CtrlProp.AnchLeft := False;
    if akTop in gCtrl.Anchors then CtrlProp.AnchTop := True
                              else CtrlProp.AnchTop := False;
    if akRight in gCtrl.Anchors then CtrlProp.AnchRight := True
                                else CtrlProp.AnchRight := False;
    if akBottom in gCtrl.Anchors then CtrlProp.AnchBottom := True
                                 else CtrlProp.AnchBottom := False;
  end;
end;

function TCtrlParams.AddCtrlProperty : TCtrlProperty;
var
  NewListLength : integer;
begin
  NewListLength := Length(FCtrlList) + 1;
  SetLength(FCtrlList, NewListLength);
  Result := FCtrlList[NewListLength - 1];
  Result.Top := 5;
  Result.Left := 5;
  Result.Height := 20;
  Result.Width := 50;
end;

function TCtrlParams.ParamFileName: String;
var
  StrParamFileName : String;
  StrExePath : String;
begin
  StrParamFileName := ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  if Trim(FAppDataFolder) = '' then
  begin
    StrExePath := ExtractFilePath(Application.ExeName);
    if Copy(StrExePath, Length(StrExePath), 1) <> '\' then StrExePath := Concat(StrExePath, '\');
    Result := Concat(StrExePath, FORMS_PARAMS_TAG, StrParamFileName);
  end
  else Result := Concat(FAppDataFolder, FORMS_PARAMS_TAG, StrParamFileName);
end;

procedure TCtrlParams.Clear;
begin
  SetLength(FCtrlList, 0);
end;

constructor TCtrlParams.Create(AForm : TForm);
begin
  FIsSaveToFile := True;
  SetLength(FCtrlList, 0);
  FIdForm := '';
  if Assigned(AForm) then FIdForm := Concat(ExtractFileName(Application.ExeName),AForm.Name)
                     else FIdForm := ExtractFileName(Application.ExeName);
  FAppDataFolder := AppDataFolder;
end;

function TCtrlParams.CtrlPropertiesByName(const ACtrlName: String): TCtrlProperty;
var
  idx : integer;
begin
  for idx := Low(FCtrlList) to High(FCtrlList) do
  begin
    if UpperCase(Trim(ACtrlName)) = UpperCase(FCtrlList[idx].Name) then
    begin
      Result := FCtrlList[idx];
      Break;
    end;
  end;
end;

function TCtrlParams.GetCtrlCount: integer;
begin
  Result := Length(FCtrlList);
end;

function TCtrlParams.GetCtrlProperty(ACtrlName: String): TCtrlProperty;
begin
  Result := CtrlPropertiesByName(ACtrlName);
end;

function TCtrlParams.HashCode(AFormName: String = ''): string;

  function HashStr(AStr : PChar) : integer;
  asm
    mov  ecx,eax
    xor  eax,eax
    @loop:
    mov  dl,[ecx]
    test dl,dl
    jz   @Out
    rol  eax,5
    xor  al,dl
    inc  ecx
    jmp  @loop
    @Out:
  end;
var
  IdForm : String;
  IdHashCode : integer;
begin
  IdForm := FIdForm + AFormName;
  IdHashCode := HashStr(Pchar(IdForm));
  Result := IntToHex(IdHashCode, 8);
end;

procedure TCtrlParams.SetCtrlParams(ACtrlList: TObjectList);
var
  IniFile : TIniFile;
  idx : integer;
  Value : Integer;
  CtrlId : String;
begin
  IniFile := TIniFile.Create(ParamFileName);
  try
    for idx := 0 to ACtrlList.Count -1 do
    begin
      CtrlId := Concat(FIdForm, (ACtrlList.Items[idx] as TControl).Name);
      CtrlId := HashCode(CtrlId);
      Value := IniFile.ReadInteger(CtrlId, TOP_TAG, -1);
      if Value > 0 then (ACtrlList.Items[idx] as TControl).Top := Value;
      Value := IniFile.ReadInteger(CtrlId, LEFT_TAG, -1);
      if Value > 0 then (ACtrlList.Items[idx] as TControl).Left := Value;
      Value := IniFile.ReadInteger(CtrlId, WIDTH_TAG, -1);
      if Value > 0 then (ACtrlList.Items[idx] as TControl).Width := Value;
      Value := IniFile.ReadInteger(CtrlId, HEIGHT_TAG, -1);
      if Value > 0 then (ACtrlList.Items[idx] as TControl).Height := Value;
    end;
  finally
    IniFile.Free;
  end;

end;

function TCtrlParams.AppDataFolder: String;
var
  Registry : TRegistry;
  Buffer : PChar;
const
  MaxPathLength = 400;
begin
  Result := '';
  Buffer := StrAlloc(MaxPathLength);
  Registry := TRegistry.Create;
  try
    if Registry.OpenKey(RGSTRKEY_USER_APPDATA, False) then
    begin
      Result := Registry.ReadString('AppData');
    end;
    if Trim(Result) = '' then //Older os use temp path
    begin
      GetTempPath(MaxPathLength, Buffer);
      Result := Buffer;
    end;
    if Copy(Result, Length(Result), 1) <> '\' then
    begin
      Result := Concat(Result, '\', ChangeFileExt(ExtractFileName(Application.ExeName), ''), '\');
    end
    else Result := Concat(Result, ChangeFileExt(ExtractFileName(Application.ExeName), ''), '\');
    if not DirectoryExists(Result) then CreateDir(Result);
  finally
    Registry.Free;
    StrDispose(Buffer);
  end;
end;

procedure TCtrlParams.SaveCtrlParams(ACtrlList: TObjectList);
var
  IniFile : TIniFile;
  idx: integer;
  {$ifdef DEMO}
  idxDemo : integer;
  {$endif}
  CtrlId : String;
begin
  IniFile := TIniFile.Create(ParamFileName);
  try
    {$ifdef DEMO}
    idxDemo := 1;
    {$endif}
    for idx := 0 to ACtrlList.Count -1 do
    begin
      CtrlId := Concat(FIdForm, (ACtrlList.Items[idx] as TControl).Name);
      CtrlId := HashCode(CtrlId);
      IniFile.WriteInteger(CtrlId, TOP_TAG, (ACtrlList.Items[idx] as TControl).Top);
      IniFile.WriteInteger(CtrlId, LEFT_TAG, (ACtrlList.Items[idx] as TControl).Left);
      IniFile.WriteInteger(CtrlId, WIDTH_TAG, (ACtrlList.Items[idx] as TControl).Width);
      IniFile.WriteInteger(CtrlId, HEIGHT_TAG, (ACtrlList.Items[idx] as TControl).Height);
      {$ifdef DEMO}
      Inc(idxDemo);
      if idxDemo = 5 then break;
      {$endif}
    end;
  finally
    IniFile.Free;
  end;
end;

{ TPosGrid }

constructor TPosGrid.Create(AOwnerFrm: TForm);
begin
  FOwnerFrm := AOwnerFrm;
  FOriFormPaint := FOwnerFrm.OnPaint;
  FStep := 10;
  FVisible := False;
  FOwnerFrm.OnPaint := FormPaint;
end;

destructor TPosGrid.destroy;
begin
  FOwnerFrm.OnPaint := FOriFormPaint;
  inherited;
end;

procedure TPosGrid.FormPaint(Sender: TObject);
var
  x, y : integer;
  c : TCanvas;
begin
  if (not FVisible) or (not Assigned(FOwnerFrm)) then Exit;
  x := FStep;
  y := FStep;
  c := FOwnerFrm.Canvas;
  c.Brush.Color := clBlack;
  while x < FOwnerFrm.Width do
  begin
    while y < FOwnerFrm.Height do
    begin
      c.FillRect(Rect(x, y, x + 1, y + 1));
      Inc(y, FStep);
    end;
    Inc(x, FStep);
    y := FStep;
  end;
  if Assigned(FOriFormPaint) then FOriFormPaint(FOwnerFrm);
end;

procedure TPosGrid.Hide;
begin
  FVisible := False;
  FOwnerFrm.Invalidate;
end;

procedure TPosGrid.SetStep(const Value: integer);
begin
  if Value < 1 then Exit;
  FStep := Value;
  FOwnerFrm.Invalidate;
end;

procedure TPosGrid.Show;
begin
  FVisible := True;
  FOwnerFrm.Invalidate;
end;

end.