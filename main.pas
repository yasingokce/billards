unit main;

interface

uses PngImage, MyTypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Types, System.Generics.Collections, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    controlPanel: TPanel;
    xhizEdt: TEdit;
    baslatBtn: TButton;
    yhizEdt: TEdit;
    Timer1: TTimer;
    xYonLbl: TLabel;
    yYonLbl: TLabel;
    frictionCbox: TComboBox;
    surtunmeLbl: TLabel;
    RestartBtn: TButton;
    Image1: TImage;
    LineBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure baslatBtnClick(Sender: TObject);
    procedure RenderToBmp;
    procedure WallCollission; // toplarýn duvara çarpma durumlarý
    procedure MotionEvent; // toplarýn yavaþlama durumu
    procedure MainBallCollision; // beyaz topun diðer toplarla çarpýþma hareketi
    procedure OthersCollision; // diðer toplarýn çarpýþma durumu
    procedure GameStartStop; // bütün toplar durunca yeniden oyna
    procedure OthersBallHareket; // diðer toplarýn hareketi
    procedure HolesEntered; // top deliðe girdimi ??
    procedure BallDelete; // kaybolan toplarýn pointlerini sil
    procedure GameWin; // oyunun kazanýlma durumu
    procedure GameLoose; // oyunun kaybedilme durumu
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RestartBtnClick(Sender: TObject);
    procedure LineBtnClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    // cursor un olduðu noktayý sapta text e yaz ve line çiz
  private
    { Private declarations }
  public
    { Public declarations }
    fTbmp: TBitmap;
    fBbmp: TBitmap;
    fBallArr: TList<Tball>;
    // holes
    fholesArr: TList<THoles>;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  fBbmp := TBitmap.Create;
  fBbmp.Width := ClientWidth - 150;
  fBbmp.Height := ClientHeight;
  fBbmp.PixelFormat := pf32bit;
  // ------- toplarý oluþturma ------- //
  fBallArr := TList<Tball>.Create;
  fBallArr.Add(Tball.Create('whiteball.png', 'MainBall', 150, 60));
  fBallArr.Add(Tball.Create('blueball.png', 'blueball', 700, 150));
  fBallArr.Add(Tball.Create('greenball.png', 'greenball', 700, 200));
  fBallArr.Add(Tball.Create('redball.png', 'redball', 700, 250));
  fBallArr.Add(Tball.Create('yellowball.png', 'yellowball', 700, 300));
  // -------  deliklerin pointlerini oluþturma -------- //
  fholesArr := TList<THoles>.Create;
  fholesArr.Add(THoles.Create(40, 40));
  fholesArr.Add(THoles.Create(850 - 350, -40));
  fholesArr.Add(THoles.Create(40, 500 - 40));
  fholesArr.Add(THoles.Create(850 - 40, 500 - 40));
  fholesArr.Add(THoles.Create(((Width - 150) div 2), 40));
  fholesArr.Add(THoles.Create(((Width - 150) div 2), 500 - 40));
  frictionCbox.ItemIndex := 0;
  Timer1.Enabled := true;
end;

procedure TForm1.baslatBtnClick(Sender: TObject);
// ---- textlere yazýlan yönler sýrasýyla x ve y eksenleri ve sürtünme katsayýlarý ---- //
var
  i: integer;
begin
  if ((xhizEdt.Text <> '') and (yhizEdt.Text <> '') and
    (frictionCbox.Text <> '')) then
  begin
    fBallArr[0].FBallMotion.X := StrToInt(xhizEdt.Text);
    fBallArr[0].FBallMotion.Y := StrToInt(yhizEdt.Text);
    for i := 0 to fBallArr.Count - 1 do
    begin
      with fBallArr[i] do
      begin
        FFiriction := StrToInt(frictionCbox.Text);
      end;
    end;
    Timer1.Enabled := true;
  end
  else
  begin
    showmessage
      ('x yönüne , y yönüne ve sürtünmeye deðer verilmeli. Örneðin x yönü : 100 ,  y yönü : 20 , sürtünme : 2 deðerleri girildiðinde beyaz top sað aþþaðý doðru gidecektir.');
  end;
end;

procedure TForm1.HolesEntered;
// -----------  topun deliðe giriþ durumu --------- //
var
  i, j: integer;
begin
  for i := 0 to fholesArr.Count - 1 do
  begin
    with fholesArr[i] do
    begin
      for j := 1 to fBallArr.Count - 1 do
      begin
        with fBallArr[j] do
        begin
          if (abs(FBallPoint.X - fHoles.X) < fball.Width) and
            (abs(FBallPoint.Y - fHoles.Y) < fball.Height) then
          begin
            FBallLife := false;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.LineBtnClick(Sender: TObject);
// ------- line çizimi ------ //
var
  endPointX, endPointY: integer;
begin
  with Canvas do
  begin
    endPointX := 0;
    endPointY := 0;
    if ((xhizEdt.Text <> '') and (yhizEdt.Text <> '')) then
    begin
      endPointX := StrToInt(xhizEdt.Text);
      endPointY := StrToInt(yhizEdt.Text);
    end;
    Canvas.Pen.Color := clWhite;
    Canvas.Pen.Width := 3;
    Canvas.MoveTo(fBallArr[0].FBallPoint.X + 16, fBallArr[0].FBallPoint.Y + 16);
    Canvas.LineTo((fBallArr[0].FBallPoint.X + 16) + endPointX * 3,
      (fBallArr[0].FBallPoint.Y + 16) + endPointY * 3);
    sleep(1000);
  end;
end;

procedure TForm1.BallDelete; // ----- kaybolan toplarýn pointlerini sil -----//
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      if FBallLife = false then
      begin
        FBallPoint.X := 0;
        FBallPoint.Y := 0;
        FBallMotion.X := 0;
        FBallMotion.Y := 0;
      end;
    end;
  end;
end;

procedure TForm1.MotionEvent;
// ---------  topun yavaþlama durumu --------- //
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      // --- xiçin yaz  ---- //
      if ((0 < FBallMotion.X) and (FBallMotion.X < 200)) then
      begin
        if FBallMotion.X < FFiriction then
        begin
          FBallMotion.X := 0;
        end
          else
        begin
          FBallMotion.X := FBallMotion.X - FFiriction;
        end;
      end;
      if ((0 > FBallMotion.X) and (FBallMotion.X > -200)) then
      begin
        if FBallMotion.X > FFiriction then
        begin
          FBallMotion.X := 0;
        end
          else
        begin
          FBallMotion.X := FBallMotion.X + FFiriction;
        end;
      end;
      // --- yiçin yaz  ---- //
      if ((0 < FBallMotion.Y) and (FBallMotion.Y < 200)) then
      begin
        if FBallMotion.Y < FFiriction then
        begin
          FBallMotion.Y := 0;
        end
          else
        begin
          FBallMotion.Y := FBallMotion.Y - FFiriction;
        end;
      end;
      if ((0 > FBallMotion.Y) and (FBallMotion.Y > -200)) then
      begin
        if FBallMotion.Y > FFiriction then
        begin
          FBallMotion.Y := 0;
        end
          else
        begin
          FBallMotion.Y := FBallMotion.Y + FFiriction;
        end;
      end;
    end;
  end;
end;

procedure TForm1.MainBallCollision;
// -------   topa çarpma hareketi ------  //
var
  i, j: integer;
  temp1, temp2: integer;
begin
  // ------- beyaz topla diðer toplarýn çarpýþma hareketi -------- //
  for i := 1 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
      if (abs(fBallArr[0].FBallPoint.X - FBallPoint.X) < fball.Width) and
        (abs(fBallArr[0].FBallPoint.Y - FBallPoint.Y) < fball.Height) then
      begin
        if (fBallArr[0].FBallPoint.X > FBallPoint.X) then
        begin
          temp1 := fBallArr[0].FBallMotion.X;
          temp2 := fBallArr[0].FBallMotion.Y;
          FBallMotion.X := temp1;
          FBallMotion.Y := temp2;
          fBallArr[0].FBallMotion.X := -(temp1 div 2);
          fBallArr[0].FBallMotion.Y := -(temp2 div 2);
        end
          else
        begin
          temp1 := fBallArr[0].FBallMotion.X;
          temp2 := fBallArr[0].FBallMotion.Y;
          FBallMotion.X := temp1;
          FBallMotion.Y := temp2;
          fBallArr[0].FBallMotion.X := -(temp1 div 2);
          fBallArr[0].FBallMotion.Y := -(temp2 div 2);
        end;
      end;
  end;
end;

// ------- toplarýn hareketi --------//
procedure TForm1.OthersBallHareket;
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      FBallPoint.X := FBallPoint.X + FBallMotion.X;
      FBallPoint.Y := FBallPoint.Y + FBallMotion.Y;
    end;
  end;
end;

procedure TForm1.OthersCollision;
// ------ diðer toplarýn çarpýþma durumu ---------- //
var
  i, j, temp1, temp2: integer;
begin
  for i := 1 to fBallArr.Count - 1 do
  begin
    for j := 1 to fBallArr.Count - 1 do
    begin
      if i <> j then
      begin
        if (abs(fBallArr[i].FBallPoint.X - fBallArr[j].FBallPoint.X) <
          fBallArr[j].fball.Width) and
          (abs(fBallArr[i].FBallPoint.Y - fBallArr[j].FBallPoint.Y) <
          fBallArr[j].fball.Height) then
        begin
          if (fBallArr[i].FBallPoint.X > fBallArr[j].FBallPoint.X) then
          begin
            temp1 := fBallArr[i].FBallMotion.X;
            temp2 := fBallArr[i].FBallMotion.Y;
            fBallArr[j].FBallMotion.X := temp1;
            fBallArr[j].FBallMotion.Y := temp2;
            fBallArr[i].FBallMotion.X := -(temp1 div 2);
            fBallArr[i].FBallMotion.Y := -(temp2 div 2);
          end
            else
          begin
            temp1 := fBallArr[i].FBallMotion.X;
            temp2 := fBallArr[i].FBallMotion.Y;
            fBallArr[j].FBallMotion.X := temp1;
            fBallArr[j].FBallMotion.Y := temp2;
            fBallArr[i].FBallMotion.X := -(temp1 div 2);
            fBallArr[i].FBallMotion.Y := -(temp2 div 2);
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.WallCollission;
// -------   toplarýn duvara çarpma durumu  -------- //
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      if (FBallPoint.X > (ClientWidth - 150) - fball.Width) then
      begin
        FBallMotion.X := -abs(FBallMotion.X);
      end
        else if FBallPoint.X < 0 then
      begin
        FBallMotion.X := abs(FBallMotion.X);
      end;
      if (FBallPoint.Y > ClientHeight - fball.Height) then
      begin
        FBallMotion.Y := -abs(FBallMotion.Y);
      end
        else if FBallPoint.Y < 0 then
      begin
        FBallMotion.Y := abs(FBallMotion.Y);
      end;
    end;
  end;
end;

procedure TForm1.RenderToBmp;
var
  i: integer;
  LineX, LineY, moveX, MoveY: integer;
begin
  with fBbmp, Canvas do
  begin
    Brush.Color := clGreen;
    FillRect(Rect(0, 0, Width, Height));
    for i := 0 to fBallArr.Count - 1 do
    begin
      with fBallArr[i] do
        if FBallLife = true then // --- top yaþýyorsa bastýr. ------ //
        begin
          Draw(FBallPoint.X, FBallPoint.Y, fball);
        end;
    end;
    // ------ deliklerin çizimi -------//
    Brush.Color := clblack;
    Ellipse(-40, -40, 40, 40); // sol üst delik
    Ellipse(850 + 40, -40, 850 - 40, 40); // sað üst delik
    Ellipse(40, 500 - 40, -40, 500 + 40); // sol alt delik
    Ellipse(850 - 40, 500 - 40, 850 + 40, 500 + 40); // sað alt delik
    Ellipse((Width div 2) - 40, -40, (Width div 2) + 40, 40); // orta üst delik
    Ellipse((Width div 2) - 40, Height + 40, (Width div 2) + 40, Height - 40);
  end;
end;

procedure TForm1.GameStartStop;
// --------- oyundaki bütün toplarýn hýzý 0 olduðunda sonraki atýþ yapýlabilir. -------- //
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      if (FBallMotion.X = 0) and (FBallMotion.Y = 0) then
      begin
        baslatBtn.Enabled := true;
      end
        else
      begin
        baslatBtn.Enabled := false;
      end;
    end;
  end;
end;

procedure TForm1.GameLoose;
// ---------  beyaz top deliðe girerse --------//
var
  i: integer;
begin
  for i := 0 to fholesArr.Count - 1 do
  begin
    with fholesArr[i] do
    begin
      if (abs(fBallArr[0].FBallPoint.X - fHoles.X) < fBallArr[0].fball.Width)
        and (abs(fBallArr[0].FBallPoint.Y - fHoles.Y) < fBallArr[0].fball.Height)
      then
      begin
        fBallArr[0].FBallLife := false;
        Form1.Caption := '......kaybettiniz.....';
        Timer1.Enabled := false;
        showmessage('KAYBETTÝNÝZ....');
      end;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  OthersCollision;
  GameLoose;
  GameWin;
  BallDelete;
  GameStartStop;
  HolesEntered;
  OthersBallHareket;
  MainBallCollision;
  MotionEvent;
  WallCollission;
  RenderToBmp;
  Canvas.Draw(0, 0, fBbmp);
end;

procedure TForm1.RestartBtnClick(Sender: TObject);
// -------- restart ------- //
var
  i: integer;
begin
  for i := 0 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      FBallLife := true;
      FBallMotion.X := 0;
      FBallMotion.Y := 0;
    end;
  end;
  fBallArr[0].FBallPoint.X := 150;
  fBallArr[0].FBallPoint.Y := 60;
  fBallArr[1].FBallPoint.X := 700;
  fBallArr[1].FBallPoint.Y := 150;
  fBallArr[2].FBallPoint.X := 700;
  fBallArr[2].FBallPoint.Y := 200;
  fBallArr[3].FBallPoint.X := 700;
  fBallArr[3].FBallPoint.Y := 250;
  fBallArr[4].FBallPoint.X := 700;
  fBallArr[4].FBallPoint.Y := 300;
  Timer1.Enabled := true;
  xhizEdt.Text := IntToStr(90);
  yhizEdt.Text := IntToStr(30);
  frictionCbox.ItemIndex := 0;
end;

procedure TForm1.GameWin;
// ------- renkli toplarýn deliðe girdiði durum ------- //
var
  i, life: integer;
begin
  life := 0;
  for i := 1 to fBallArr.Count - 1 do
  begin
    with fBallArr[i] do
    begin
      if FBallLife = false then
      begin
        inc(life);
        if life = 4 then
        begin
          Form1.Caption := '.....Kazandýnýz....';
          Timer1.Enabled := false;
          showmessage('KAZANDINIZ   TEBRÝKLER....');
        end;
      end;
    end;
  end;
end;

// ---- ekranýn x y noktasýný al ---- //
procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  endPointX, endPointY: integer;
begin
  xhizEdt.Text := IntToStr(((X) - fBallArr[0].FBallPoint.X) div 7);
  yhizEdt.Text := IntToStr(((Y) - fBallArr[0].FBallPoint.Y) div 7);
  LineBtn.click;
end;

// -------   form close and destroy ------ //
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  Form1.Close;
  Form1 := nil;
  fBallArr.Free;
  fholesArr.Free;
end;

end.
