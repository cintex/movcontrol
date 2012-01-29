{-----------------------------------------------------------------------------------
set define for Delphi versions
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


{$IFNDEF VER80} { If not Delphi 1 }
  {$DEFINE D2_ORHIGHER}
  {$IFNDEF VER90} { If not Delphi 2 }
    {$DEFINE D3_ORHIGHER}
    {$IFNDEF VER100} { If not Delphi 3 }
      {$DEFINE D4_ORHIGHER}
      {$IFNDEF VER120} { If not Delphi 4 }
        {$DEFINE D5_ORHIGHER}
        {$IFNDEF VER130} { If not Delphi 5 }
          {$DEFINE D6_ORHIGHER}
          {$IFNDEF VER140} { If not Delphi 6 }
            {$DEFINE D7_ORHIGHER}
            {$IFNDEF VER150} { If not Delphi 7 }
              {$DEFINE D8_ORHIGHER}
              {$IFNDEF VER160} { If not Delphi 8 }
                {$DEFINE D2005_ORHIGHER}
                {$IFNDEF VER170} { If not Delphi 2005 }
                  {$DEFINE D2006_ORHIGHER}
                  {$IFNDEF VER180} { If not Delphi 2006 }
                    {$DEFINE D2007_ORHIGHER}
                    {$IFNDEF VER185}
                      {$DEFINE D2007_ORHIGHER}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}