unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Label2: TLabel;
    LabelRate: TLabel;
    Layout2: TLayout;
    EditAmount: TEdit;
    EditFrom: TEdit;
    EditTo: TEdit;
    Button1: TButton;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    Label4: TLabel;
    LabelResult: TLabel;
    NetHTTPClient1: TNetHTTPClient;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  API_KEY = 'API_ACCESS_KEY';

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.JSON;

procedure TForm1.Button1Click(Sender: TObject);
begin
  var AAmount := EditAmount.Text.ToDouble;
  var AFrom := EditFrom.Text;
  var ATo := EditTo.Text;

  var LResponse := NetHTTPClient1.Get
    ('http://data.fixer.io/api/convert?access_key=' + API_KEY + '&from=' +
    AFrom + '&To=' + ATo + '&amount=' + AAmount.ToString);

  if LResponse.StatusCode = 200 then
  begin
    var LResponseContent := LResponse.ContentAsString(TEncoding.UTF8);
    var LJSONVal := TJSONObject.ParseJSONValue(LResponseContent);
    try
      if LJSONVal is TJSONObject then
      begin
        var LJSONObj := LJSONVal as TJSONObject;
        if LJSONObj.GetValue('success').Value.ToBoolean then
        begin
          var LResult := LJSONObj.GetValue('result').Value;
          LabelResult.Text := LResult;
          LabelRate.Text := FloatToStr(LResult.ToDouble / AAmount);
        end
        else
          raise Exception.Create('API request was not successful.');
      end
      else
        raise Exception.Create('Unexpected server response.');
    finally
      LJSONVal.Free;
    end;
  end;

end;

end.
