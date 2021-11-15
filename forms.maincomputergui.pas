unit forms.maincomputergui;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Skia.Vcl, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.MPlayer;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%
// %%%% Original Author:
// %%%%          Ian Barker.
// %%%%              https://about.me/IanBarker
// %%%%              https://github.com/checkdigits
// %%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%% Example of how to use SkiaForDelphi to do some cool things.
// %%%%
// %%%% Based on the Skia4Delphi VCL example here:
// %%%%   https://github.com/viniciusfbb/skia4delphi/tree/main/Samples/Basic/VCL
// %%%%
// %%%% Animations from
// %%%%            https://lottiefiles.com
// %%%% Sounds from
// %%%%            https://www.trekcore.com/audio/
// %%%% Fonts from
// %%%%       Main "Trek type" font https://fontlibrary.org/en/font/horta
// %%%%       Klingon font https://www.evertype.com/fonts/tlh/
// %%%%       license https://www.evertype.com/fonts/tlh/klingon-piqad-hasta-licence.html
// %%%%
// %%%% 'Federation' Logo from: https://kopi-svg.blogspot.com/2016/04/33-star-trek-svg-free-images.html?m=1
// %%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type Beeps = (BeepRedAlert, BeepBlaaaa, BeepBeeBop, BeepIncoming, BeepComputerWork, BeepConsoleWarning, BeepEngage);


type
  TMainComputerGUI = class(TForm)
    PlanetAnim: TSkLottieAnimation;
    CountdownAnim: TSkLottieAnimation;
    WireframeGlobeAnim: TSkLottieAnimation;
    WarpVectorAnim: TSkLottieAnimation;
    RadarSweepAnim: TSkLottieAnimation;
    HeartbeatAnim: TSkLottieAnimation;
    ScanningAnim: TSkLottieAnimation;
    FederationLogo: TSkSvg;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AlertLabel: TLabel;
    Image1: TImage;
    Timer1: TTimer;
    MediaPlayer1: TMediaPlayer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    var
      HasNotPlayedRedAlert, PlaySounds: Boolean;
    procedure WMNCHitTest(var Msg: TWMNCHitTest) ; message WM_NCHitTest;
    procedure DoSpaceText;
    function RandomLineOfNumbers: string;
    function RandomLineOfText: string;
    function RandomKlingonString(const DesiredLength: integer): string;
    procedure PlaySound(const WhichSound: Beeps);
  end;

var
  MainComputerGUI: TMainComputerGUI;

implementation
uses Skia,
     System.Types,
     System.UITypes,
     System.Math;

{$R *.dfm}

procedure TMainComputerGUI.FormActivate(Sender: TObject);
begin
  if Tag = 0 then
  begin
    Tag := 1;
    DoSpaceText;
    Timer1.Enabled := True;
    PlaySound(BeepEngage);
  end;
end;

procedure TMainComputerGUI.FormCreate(Sender: TObject);
begin
  HasNotPlayedRedAlert := True;
  PlaySounds           := True;
end;

procedure TMainComputerGUI.PlaySound(const WhichSound: Beeps);

const
  cSounds: array[BeepRedAlert..BeepEngage] of string = (
                              'alert09.mp3',
                              'alert08.mp3',
                              'communications_end_transmission.mp3',
                              'computerbeep_74.mp3',
                              'computer_work_beep.mp3',
                              'consolewarning.mp3',
                              'engage.mp3'
                             );
begin
  // We use the TMediaPlayer to play the sounds rather than sndPlaySound
  // just because MP3s are more likely to work that way and we don't need
  // asynchronous playback.

  // Only play the (very jarring) red alert sound once.
  if WhichSound = BeepRedAlert then HasNotPlayedRedAlert := False;

  // Clicking on the bottom left LCARS area toggles the sound off or on
  if PlaySounds then
  begin
    MediaPlayer1.Close;
    MediaPlayer1.FileName := '..\..\sounds\' + cSounds[WhichSound];
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
end;

function TMainComputerGUI.RandomKlingonString(const DesiredLength: integer): string;
var
  Klingon:     char;
begin
  Result := '';
  for var count := 1 to DesiredLength do
  begin
    if Random(5) mod 5 = 0 then
      Result := Concat(Result, ' ')
    else
      begin
        Klingon := Char($F8D0 + Random(25));
        Result  := Result + Klingon;
      end;
  end;
end;

function TMainComputerGUI.RandomLineOfNumbers: string;
var
  iWidth:  integer;
  iSpaces: integer;
  iIndex:  integer;

const
  cSpaces: array[0..5] of integer = (4, 6, 4, 8, 4, 4);

begin
  Result := '';
  for var iLoop := 0 to 10 do
  begin
    iSpaces := cSpaces[iLoop mod 6];
    Result  := Result + Format('%.4f%s', [Random, StringOfChar(' ', iSpaces)]);
  end;
end;

function TMainComputerGUI.RandomLineOfText: string;

const
  cChanceOfSpaces  = 4;
  cChanceOfNumbers = 3;
  cMaxLengthOfLine = 95;
begin
  Result := '';
  for var iLoop := 0 to cMaxLengthOfLine do
    if Random(cChanceOfSpaces) mod cChanceOfSpaces = 0 then
      Result := Concat(Result, ' ')
    else
      if Random(cChanceOfNumbers) mod cChanceOfNumbers = 0 then
        Result := Concat(Result, Chr(48 + Random(10)))
      else
        Result := Concat(Result, Chr(65 + Random(25)));
end;

procedure TMainComputerGUI.Shape1MouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
begin
  // Clicking on the bottom left LCARS area toggles the sound off or on
  PlaySounds := Not PlaySounds;
  if PlaySounds then AlertLabel.Caption := 'ALERTS ON' else AlertLabel.Caption := 'ALERTS OFF';
end;

procedure TMainComputerGUI.Timer1Timer(Sender: TObject);
begin
  // Cause the random text to be repainted every 1.5 seconds
  Timer1.Enabled := False;
  DoSpaceText;
  Timer1.Enabled := True;
end;

procedure TMainComputerGUI.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  // We have no title bar - so we need to check for click and hold mouse
  // movements to trigger the form dragging but only if it's near the top
  // border shape.
  inherited;
  if Msg.Result = htClient then
  begin
    var Pt := ScreenToClient(SmallPointToPoint(Msg.Pos));
    if Pt.Y < (Shape22.Height + Shape22.Top) then Msg.Result := htCaption;
  end;
end;

procedure TMainComputerGUI.DoSpaceText;
var
  LBitmap: TBitmap;
const
  cYellowText = $FFFBD768;
  cWhiteText  = TAlphaColors.White;
  cBackground = TAlphaColors.Black;
begin
  LBitmap := TBitmap.Create;
  try
    LBitmap.SetSize(745, 202);
    LBitmap.SkiaDraw(
      procedure (const ACanvas: ISkCanvas)
      var
        LTypeface: ISkTypeface;
        LFont: ISkFont;
        LPaint: ISkPaint;
      begin
        // Create the drawing surface for the text
        ACanvas.Clear(cBackground);
        LPaint := TSkPaint.Create;

        // Now load a custom 'Klingon' font and use that to print some random Klingon
        const FontFolder = '..\..\fonts\';
        LTypeface      := TSkTypeface.MakeFromFile(FontFolder + 'Klingon-pIqaD-HaSta.ttf');
        LFont          := TSkFont.Create(LTypeface, 28);
        LFont.Typeface := LTypeface;
        LFont.Size     := 28;
        LPaint.Color   := TAlphaColors.Tomato;
        LPaint.Style   := TSkPaintStyle.Fill; // Fills can be grad fills for cool text!
        ACanvas.DrawSimpleText(RandomKlingonString(19), 10, 25, LFont, LPaint);

        // Now to load a "Trek" type font to emulate the computer interface's text
        LTypeface    := TSkTypeface.MakeFromFile(FontFolder + 'LCARS.ttf');
        LFont        := TSkFont.Create(LTypeface, 16);
        LPaint.Color := TAlphaColor(cYellowText);
        LPaint.Style := TSkPaintStyle.Fill; // Solid fill

        // First some random 'planetary' statistics in yellow
        ACanvas.DrawSimpleText(Format('Saturation %d%%   Lead %d%%', [Random(100), Random(100)]), 500, 25, LFont, LPaint);
        ACanvas.DrawSimpleText(Format('Titanium   %d%%    Ore  %d%%', [Random(100), Random(100)]), 500, 45, LFont, LPaint);
        ACanvas.DrawSimpleText(Format('Cadnium    %d%%', [Random(100)]), 500, 65, LFont, LPaint);
        ACanvas.DrawSimpleText('Planet Class: M', 500, 85, LFont, LPaint);

        // Now a few rows of random numbers - the movies like screenfuls of junky numbers :)
        for var i := 0 to 3 do
          ACanvas.DrawSimpleText(RandomLineOfText, 10, 45 + (i * 20), LFont, LPaint);
        LPaint.Color  := cWhiteText;
        for var iRow := 4 to 7 do
        begin
          ACanvas.DrawSimpleText(RandomLineOfNumbers, 10, 45 + (iRow * 20), LFont, LPaint);
        end;

        // Now let's show some worrying command text from The Main Bridge
        LTypeface := TSkTypeface.MakeFromFile(FontFolder + 'Horta demo.otf');
        LFont := TSkFont.Create(LTypeface, 32);
        LPaint.Style := TSkPaintStyle.Fill;
        var CaptainsOrders1, CaptainsOrders2: string;
        if Random(2) Mod 2 = 0 then
          begin
            CaptainsOrders1 := 'RED ALERT';
            CaptainsOrders2 := 'ALL CREW TO STATIONS';
            LPaint.Color   := TAlphaColors.Crimson;
            if HasNotPlayedRedAlert then PlaySound(BeepRedAlert);
          end
        else
          begin
            CaptainsOrders1 := 'ENSIGN BARKER';
            CaptainsOrders2 := 'REPORT TO THE BRIDGE';
            LPaint.Color   := TAlphaColors.Cadetblue; // Starfleet Cadet Blue ;)
            if Random(3) Mod 3 = 0 then PlaySound(Beeps(RandomRange(Ord(BeepIncoming), Ord(BeepEngage))));
          end;

        ACanvas.DrawSimpleText(Format(CaptainsOrders1, [Random(100), Random(100)]), 500, 145, LFont, LPaint);
        ACanvas.DrawSimpleText(Format(CaptainsOrders2, [Random(100), Random(100)]), 500, 175, LFont, LPaint);
      end);
    Image1.Width := Ceil(LBitmap.Width {$IF CompilerVersion >= 33}/ Image1.ScaleFactor{$ENDIF});
    Image1.Height := Ceil(LBitmap.Height {$IF CompilerVersion >= 33}/ Image1.ScaleFactor{$ENDIF});
    Image1.Picture.Bitmap := LBitmap;
  finally
    LBitmap.Free;
  end;
end;

end.
