unit UVersionInfo;

{$ifdef fpc}
{$MODE Delphi}
{$endif}

interface
{-----------------------------------------------------------------------------------
Read version information from binary file
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

uses Windows, Classes, SysUtils;

type
  TFileVersion = class
  private
    FReleaseVersion: string;  // major.minor.release
    FMinorVersion: string;  // major.minor
    FMajor:   Integer;
    FMinor:   Integer;
    FRelease: Integer;
    FBuild:   Integer;
    procedure SetDefaultProperties;
    function  ReadVersionInfo(sProgram: string; Major, Minor,
                              Release, Build : pWord) :Boolean;
  public
    property    ReleaseVersion: string  read FReleaseVersion;
    property    MinorVersion: string  read FMinorVersion;
    property    Major:   Integer read FMajor   default  0;
    property    Minor:   Integer read FMinor   default  0;
    property    Release: Integer read FRelease default  0;
    property    Build:   Integer read FBuild   default  0;
    constructor Create;
    function    GetFileVersion(sFile: string): boolean;
  end;

implementation

{$ifndef fpc}
{$I UDelphiVersions.inc}
{$endif}

{********************************************************************
Function    : Create
Description : Initialize variables
Inputs      : None
Outputs     : None
********************************************************************}
constructor TFileVersion.Create;
begin
  inherited Create;
  SetDefaultProperties;
end;

{********************************************************************
Function    : GetFileVersion
Description : Get the version of an executable file
Inputs      : sfile - The path/filename of the file to get a
              version for
Outputs     : True if there was version info, else false.
              If true, the version info will be in the object
              properties.
********************************************************************}
function TFileVersion.GetFileVersion(sFile: string): boolean;
var
  Major,Minor, Release, Build : Word;
begin
  {get version information from file sFile}
  Result := ReadVersionInfo(sFile, @Major, @Minor, @Release, @Build);
  if Result then
  begin
    FMajor   := Integer(Major);
    FMinor   := Integer(Minor);
    FRelease := Integer(Release);
    FBuild   := Integer(Build);
    FReleaseVersion := IntToStr(FMajor) + '.' + IntToStr(FMinor) + '.' +IntToStr(FRelease);
    FMinorVersion := IntToStr(FMajor) + '.' + IntToStr(FMinor);
  end
  else
  begin
    SetDefaultProperties;
  end;
end;

{********************************************************************
Function    : SetDefaultProperties
Description : set the properties to their default values
Inputs      : None.
Outputs     : None.
********************************************************************}
procedure TFileVersion.SetDefaultProperties;
begin
  FReleaseVersion := '';
  FMinorVersion := '';
  FMajor :=   0;
  FMinor :=   0;
  FRelease := 0;
  FBuild :=   0;
end;

{********************************************************************
Function    : ReadVersionInfo
Description : Read the version and build info from an executable
Inputs      : sProgram - the name of the file to read
Outputs     : Major - the major version number
              Minor - the minor version number
              Release - the release number
              Build - the build number
********************************************************************}
function TFileVersion.ReadVersionInfo(sProgram: string; Major, Minor,
                                        Release, Build : pWord) :Boolean;
var
  Info:       PVSFixedFileInfo;
{$ifndef fpc}
 {$ifdef D5_ORHIGHER} {Delphi 4 definition for this differs from D2 & D3}
  InfoSize:   Cardinal;
 {$else}
  InfoSize:   UINT;
 {$endif}
{$else}
  InfoSize:   UINT;
{$endif}
  nHwnd:      DWORD;
  BufferSize: DWORD;
  Buffer:     Pointer;
begin
  BufferSize := GetFileVersionInfoSize(pchar(sProgram),nHWnd); {Get buffer size}
  Result := True;
  if BufferSize <> 0 then begin {if zero, there is no version info}
    GetMem( Buffer, BufferSize); {allocate buffer memory}
    try
      if GetFileVersionInfo(PChar(sProgram),nHWnd,BufferSize,Buffer) then begin
        {got version info}
        if VerQueryValue(Buffer, '\', Pointer(Info), InfoSize) then begin
          {got root block version information}
          if Assigned(Major) then begin
            Major^ := HiWord(Info^.dwFileVersionMS); {extract major version}
          end;
          if Assigned(Minor) then begin
            Minor^ := LoWord(Info^.dwFileVersionMS); {extract minor version}
          end;
          if Assigned(Release) then begin
            Release^ := HiWord(Info^.dwFileVersionLS); {extract release version}
          end;
          if Assigned(Build) then begin
            Build^ := LoWord(Info^.dwFileVersionLS); {extract build version}
          end;
        end else begin
          Result := False; {no root block version info}
        end;
      end else begin
        Result := False; {couldn't extract version info}
      end;
    finally
      FreeMem(Buffer, BufferSize); {release buffer memory}
    end;
  end else begin
    Result := False; {no version info at all in the file}
  end;
end;
end.


