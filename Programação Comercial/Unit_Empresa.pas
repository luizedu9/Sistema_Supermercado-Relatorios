unit Unit_Empresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.Mask, Vcl.ComCtrls, Unit_Persistencia, Unit_Util, StrUtils;

type
  TForm_DadosEmpresa = class(TForm)
    Panel1: TPanel;
    btn_sair: TBitBtn;
    btn_gravar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_limpar: TBitBtn;
    btn_editar: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    edit_RazaoSocial: TLabeledEdit;
    edit_nomeFantasia: TLabeledEdit;
    edit_endereco: TLabeledEdit;
    edit_cnpj: TMaskEdit;
    label_cnpj: TLabel;
    edit_telefone: TMaskEdit;
    label_tel: TLabel;
    edit_Lucro: TSpinEdit;
    Label3: TLabel;
    Edit_InscricaoEstadual: TLabeledEdit;
    Edit_Email: TLabeledEdit;
    edit_NomeResponsavel: TLabeledEdit;
    edit_telefoneResponsavel: TMaskEdit;
    label_telefoneResponsavel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btn_editarClick(Sender: TObject);
    procedure btn_limparClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);

    procedure HabilitaTela(Habilita: Boolean);
    procedure HabilitaBotoes(Quais: String);
    procedure LimpaTela;
    procedure Preenche_Componentes;
    function Coleta_Dados: Dados_Empresa;
    function Validado: Boolean;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_DadosEmpresa: TForm_DadosEmpresa;

implementation

{$R *.dfm}

procedure TForm_DadosEmpresa.HabilitaBotoes(Quais: String);
begin
    if(Quais[1] = '0')
      then btn_editar.Enabled:= False
      else btn_editar.enabled:= True;
    if(Quais[2] = '0')
      then btn_limpar.Enabled:= False
      else btn_limpar.enabled:= True;
    if(Quais[3] = '0')
      then btn_cancelar.Enabled:= False
      else btn_cancelar.enabled:= True;
    if(Quais[4] = '0')
      then btn_gravar.Enabled:= False
      else btn_gravar.enabled:= True;
    if(Quais[5] = '0')
      then btn_sair.Enabled:= False
      else btn_sair.enabled:= True;
end;

procedure TForm_DadosEmpresa.HabilitaTela(Habilita: Boolean);
begin
    edit_nomeFantasia.Enabled:= Habilita;
    edit_RazaoSocial.Enabled:=  Habilita;
    Edit_InscricaoEstadual.Enabled:=  Habilita;
    edit_cnpj.Enabled:=         Habilita;
    label_cnpj.Enabled:=        Habilita;
    edit_endereco.Enabled:=     Habilita;
    edit_Lucro.Enabled:=        Habilita;
    edit_telefone.Enabled:=     Habilita;
    label_tel.Enabled:=         Habilita;
    edit_email.Enabled:=     Habilita;
    edit_NomeResponsavel.Enabled:=     Habilita;
    edit_telefoneResponsavel.Enabled:= Habilita;
    label_telefoneResponsavel.Enabled:= Habilita;

end;

procedure TForm_DadosEmpresa.LimpaTela;
begin
    edit_nomeFantasia.Clear;
    edit_RazaoSocial.Clear;
    Edit_InscricaoEstadual.Clear;
    edit_cnpj.Clear;
    edit_endereco.Clear;
    edit_Lucro.Clear;
    edit_telefone.Clear;
    edit_email.Clear;
    edit_NomeResponsavel.Clear;
    edit_TelefoneResponsavel.Clear;
end;

procedure TForm_DadosEmpresa.btn_limparClick(Sender: TObject);
begin
    if(Application.MessageBox('Deseja realmente limpar todos os campos?', 'Limpar Campos', MB_ICONQUESTION+MB_YESNO) = mrYes)
      then begin
              LimpaTela;
              edit_RazaoSocial.SetFocus;
      end;
end;

procedure TForm_DadosEmpresa.btn_sairClick(Sender: TObject);
begin
    Form_DadosEmpresa.Close;
end;

procedure TForm_DadosEmpresa.btn_cancelarClick(Sender: TObject);
begin
    if(Application.MessageBox('Deseja realmente cancelar?', 'Cancelar', MB_ICONQUESTION+MB_YESNO) = mrYes)
      then begin
              LimpaTela;
              HabilitaBotoes('10001');
              HabilitaTela(False);
      end;
end;

procedure TForm_DadosEmpresa.btn_editarClick(Sender: TObject);
begin
    HabilitaTela(True);
    HabilitaBotoes('01110');
end;

procedure TForm_DadosEmpresa.btn_gravarClick(Sender: TObject);
var Temp: Dados_Empresa;

begin
    if Validado
      then begin
        HabilitaBotoes('10001');
        Temp := Coleta_Dados;
        Grava_Dados_Empresa(Temp);
        HabilitaTela(False);
      end;
end;

procedure TForm_DadosEmpresa.FormShow(Sender: TObject);
begin
    PageControl1.ActivePageIndex:= 0;
    Preenche_Componentes;
end;

procedure TForm_DadosEmpresa.Preenche_Componentes;
var Temp: Dados_Empresa;
begin
    Temp:= Retorna_Dados_Empresa;
    edit_nomeFantasia.text:= Temp.NomeFantasia;
    edit_RazaoSocial.text:= Temp.RazaoSocial;
    Edit_InscricaoEstadual.text:= Temp.InscricaoEstadual;
    edit_cnpj.text:= Temp.CNPJ;
    edit_endereco.text:= Temp.Endereco;
    edit_Lucro.value:= Temp.Lucro;
    edit_telefone.text:= Temp.Telefone;
    Edit_Email.text:= Temp.Email;
    edit_NomeResponsavel.text:= Temp.NomeResponsavel;
    edit_telefoneResponsavel.text:= Temp.telefoneResponsavel;
end;

function TForm_DadosEmpresa.Coleta_Dados: Dados_Empresa;
var Temp: Dados_Empresa;
begin
    Temp.NomeFantasia:= edit_nomeFantasia.Text;
    Temp.RazaoSocial:= edit_RazaoSocial.Text;
    Temp.InscricaoEstadual:= Edit_InscricaoEstadual.Text;
    Temp.CNPJ:= edit_cnpj.Text;
    Temp.Endereco:= edit_endereco.Text;
    Temp.Lucro:= edit_Lucro.Value;
    Temp.Telefone:= edit_telefone.Text;
    Temp.Email:= Edit_Email.Text;
    Temp.NomeResponsavel:= edit_NomeResponsavel.Text;
    Temp.telefoneResponsavel:= edit_telefoneResponsavel.Text;

    Result:= Temp;
end;

function TForm_DadosEmpresa.Validado: Boolean;
Var Temp_CNPJ : String;
begin
    if(trim(edit_nomeFantasia.text) = '')
      Then Begin
         Application.MessageBox('O Campo de Nome Fantasia � obrigatorio',
                                'Informe o Nome Fantasia',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_nomeFantasia.SetFocus;
         Exit;
      End;
    if(trim(edit_RazaoSocial.text) = '')
      Then Begin
         Application.MessageBox('O Campo de raz�o social � obrigatorio',
                                'Informe a Raz�o Social',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex := 0;
         edit_RazaoSocial.SetFocus;
         Exit;
      End;
    if(trim(Edit_InscricaoEstadual.text) = '')
      Then Begin
         Application.MessageBox('O Campo de inscri��o estadual � obrigatorio',
                                'Informe a inscri��o estadual',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex := 0;
         edit_RazaoSocial.SetFocus;
         Exit;
      End;
    if(AnsiPos(' ', edit_cnpj.text) <> 0)
      Then Begin
         Application.MessageBox('O Campo de cnpj � obrigatorio',
                                'Informe o CNPJ',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_cnpj.SetFocus;
         Exit;
      End;
    Temp_CNPJ:= edit_cnpj.Text;
    Temp_CNPJ := AnsiReplaceStr(Temp_CNPJ,'.','');
    Temp_CNPJ := AnsiReplaceStr(Temp_CNPJ,'-','');
    Temp_CNPJ := AnsiReplaceStr(Temp_CNPJ,'/','');
    if not (isCNPJ(Temp_CNPJ))
      then begin
         Application.MessageBox('O Campo de cnpj � invalido',
                                'Informe um CNPJ valido',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_cnpj.SetFocus;
         Exit;
      end;
    if(trim(edit_endereco.text) = '')
      Then Begin
         Application.MessageBox('O Campo de endere�o � obrigatorio',
                                'Informe o Endere�o',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_endereco.SetFocus;
         Exit;
      End;
    if(edit_Lucro.value = 0)
      Then Begin
         Application.MessageBox('O Campo de lucro � obrigatorio',
                                'Informe o lucro',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 1;
         edit_Lucro.SetFocus;
         Exit;
      End;
    if(AnsiPos(' ', edit_telefone.text) <> 0)
      Then Begin
         Application.MessageBox('O Campo de telefone � obrigatorio',
                                'Informe o Telefone',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_telefone.SetFocus;
         Exit;
      End;
    if(AnsiPos(' ', edit_email.text) <> 0)
      Then Begin
         Application.MessageBox('O Campo de email � obrigatorio',
                                'Informe o email',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_email.SetFocus;
         Exit;
      End;
    if(trim(edit_NomeResponsavel.text) = '')
      Then Begin
         Application.MessageBox('O Campo de nome do responsavel � obrigatorio',
                                'Informe o nome do responsavel',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_NomeResponsavel.SetFocus;
         Exit;
      End;
    if(AnsiPos(' ', edit_telefoneResponsavel.text) <> 0)
      Then Begin
         Application.MessageBox('O Campo de telefone do responsavel � obrigatorio',
                                'Informe o Telefone do responsavel',
                                MB_ICONERROR+MB_OK);
         Result:= false;
         PageControl1.ActivePageIndex:= 0;
         edit_telefoneResponsavel.SetFocus;
         Exit;
      End;
    result:= true;
end;

end.
