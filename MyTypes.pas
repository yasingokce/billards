unit MyTypes;

interface

uses
  Graphics, Classes, PngImage, System.Types, Winapi.Windows, System.SysUtils;

type
  TBall = class
  private
  public
    FBall: TPngImage;
    FBallName: string;
    FBallLife: boolean;
    FBallPoint: TPoint;
    FBallMotion: TPoint;
    FFiriction: integer;
    constructor Create(fFilepath: string; ballname: string; xPosition: integer;
      yPosition: integer);
    destructor Destroy; override;
    procedure Git; virtual; abstract;

  end;

type
  THoles = class
  private
  public
    fHoles: TPoint;
    constructor Create(xPosition: integer; yPosition: integer);
    destructor Destroy; override;
  end;

implementation

{ TBall }

constructor TBall.Create(fFilepath, ballname: string;
  xPosition, yPosition: integer);
begin
  FBall := TPngImage.Create;
  FBall.LoadFromFile(ExtractFilePath(paramstr(0)) + fFilepath);
  FBallName := ballname;
  FBallPoint := Point(xPosition, yPosition);
  FBallLife := true;

end;

destructor TBall.Destroy;
begin
  FBall.Free;
  inherited;
end;

{ THoles }

constructor THoles.Create(xPosition: integer; yPosition: integer);
begin
  fHoles.X := xPosition;
  fHoles.Y := yPosition;

end;

destructor THoles.Destroy;
begin

  inherited;
end;

end.
