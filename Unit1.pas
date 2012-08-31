unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, IniFiles, ShellAPI,
  ComCtrls, Buttons, ExtCtrls, RxGrdCpt;

type
  Tfrm = class(TForm)
    group: TComboBox;
    comment: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    name: TEdit;
    Label3: TLabel;
    actions: TGroupBox;
    visibleAll: TCheckBox;
    resList: TListBox;
    cdBrowse: TSpeedButton;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    function GetDriveInfo(VolumeName: string): string;
    procedure ReadData;
    procedure resListClick(Sender: TObject);
    procedure onClickBtn(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure cdBrowseClick(Sender: TObject);
    procedure visibleAllClick(Sender: TObject);
    procedure groupClick(Sender: TObject);
  private
    SaveHintHidePause: Integer;
    SaveHintPause: Integer;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure ShowHint(var HintStr: string;
              var CanShow: Boolean; var HintInfo: THintInfo);
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TBtn = record
    Caption: string;//заголовок кнопки
    Action: string;//действие для кнопки
    ActionCmd: string;//коммандная строка для действия
end;

type
  TRes = record
    resListIndex: integer;//номер в списке ресурсов resList,
                        //изменяется при добавлении,
                        //-1 - нет в списке
    Group: string;//группа
    Name: string;//название
    Comment: string;//комментарий
    buttons: array[0..5] of TBtn;//кнопки
end;

var
  frm: Tfrm;
  res: array of TRes;//массив с информацией о ресурсах
  resCount: cardinal;//общее кол-во ресурсов
  resActive: integer;//текущий выбранный ресурс (глобальный индекс)
  btn: array[0..5] of TSpeedButton;
  bevel: array[0..5] of TBevel;

const
  MenuItem=wm_user+1;//добавление в системное меню

implementation

{$R *.dfm}

procedure Tfrm.ShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
  ListRect, FormRect: TRect;
begin
  with HintInfo do
  begin
    if HintControl.ClassType = TListBox then
      with HintControl as TListBox do
      begin
        if (ItemAtPos(CursorPos, true) <> -1) and
          (Canvas.TextWidth(items.Strings[ItemAtPos(CursorPos, true)]) >
          ItemRect(ItemAtPos(CursorPos, true)).Right - 2) then
        begin
          HintStr := items.Strings[ItemAtPos(CursorPos, true)];
          ListRect := ClientRect;
          ListRect.Top := ListRect.Top + (ItemAtPos(CursorPos, true) - TopIndex) * ItemHeight;
          ListRect.Bottom := ListRect.Top + ItemHeight;
          CursorRect := ListRect;
          GetWindowRect(Handle, FormRect);
          HintInfo.HintPos := Point(ListRect.Left + FormRect.Left + 1,
            ListRect.Top + FormRect.Top - 1);
        end;
      end;
  end;
end;

procedure Tfrm.FormCreate(Sender: TObject);
var
i: byte;
s, iconF: string;
ini: TIniFile;
begin
AppendMenu(GetSystemMenu(Handle, FALSE), MF_SEPARATOR, 0, '');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem,'Автор: Вавилов Александр');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem+1,'e-mail: shurik83@mail.ru');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem+2,'сайт: http://www.shurik83.narod.ru/');

for i:=0 to 5 do
  begin
  bevel[i]:=TBevel.Create(self);
  bevel[i].Shape:=bsFrame;
  bevel[i].Width:=115;
  bevel[i].Height:=25;
  bevel[i].Left:=(i mod 2)*130+10;
  bevel[i].Top:=(i div 2)*40+20;
  btn[i]:=TSpeedButton.Create(self);
  btn[i].Caption:='Кнопка_'+inttostr(i);
  btn[i].Transparent:=true;
  btn[i].Flat:=true;
  btn[i].Width:=115;
  btn[i].Height:=25;
  btn[i].Left:=(i mod 2)*130+10;
  btn[i].Top:=(i div 2)*40+20;
  btn[i].ComponentIndex:=i;
  btn[i].OnClick:=onClickBtn;
  bevel[i].Visible:=false;
  btn[i].Visible:=false;
  bevel[i].Parent:=frm.actions;
  btn[i].Parent:=frm.actions;
  end;
s:=extractFileDrive(application.ExeName)+'\'; //корневая директория диска
frm.Caption:=GetDriveInfo(S)+' - Shell Universal';
{читать путь к значку из файла autorun.inf}
ini:=TIniFile.Create(s+'autorun.inf');
iconF:=ini.ReadString('Autorun','icon','icon.ico');
if fileexists(s+iconF) then
                      application.Icon.LoadFromFile(s+iconF);
ini.Free;
resActive:=-1;
ReadData;
if resCount=0 then
  begin
  showmessage('Нет данных по ресурсам диска!');
  visibleAll.Enabled:=false;
  end;
end;

function Tfrm.GetDriveInfo(VolumeName: string): string;
var
VolLabel, FileSysName :array [0..255] of char;
SerNum :pdword;
MaxCompLen, FileSysFlags :dword;
begin
New(SerNum);
GetVolumeInformation(PChar(VolumeName), VolLabel, 255, SerNum,
                      MaxCompLen, FileSysFlags, FileSysName, 255);
Dispose(SerNum);
result:=VolLabel;
end;

procedure Tfrm.onClickBtn(Sender: TObject);
var btnCur: cardinal;
fullpath, cmd, s: string;
begin
btnCur:=(sender as tspeedbutton).ComponentIndex;
s:=extractfiledrive(application.ExeName)+'\';
fullpath:='"'+s+res[resActive].buttons[btnCur].Action+'"';
cmd:='"'+s+res[resActive].buttons[btnCur].ActionCmd+'"';
shellexecute(handle,'open',pansichar(fullpath),pansichar(cmd),nil,sw_showdefault);
end;

procedure Tfrm.ReadData;
var
ADir, curGrp: string;
SearchRec: TSearchRec;
i, j, j2, resCur: cardinal;
files, sec: TStringList;
ini: TIniFile;
added: boolean;
label
exclF,
exclF2;
begin
ADir:=extractFileDrive(application.ExeName)+'\(shell universal)';
files:=TStringList.Create;//список ini файлов
sec:=TStringList.Create;//ресурсы в файле

if FindFirst(ADir+'\*.ini', faArchive+faHidden+faReadOnly, SearchRec) = 0 then
  repeat
    files.Add(SearchRec.Name);
  until FindNext(SearchRec)<>0;
FindClose(SearchRec);

if files.Count=0 then exit;

for i:=0 to files.Count-1 do
  begin
  ini:=TIniFile.Create(ADir+'\'+files.Strings[i]);
  if ini.ReadString('_CONFIG_ Shell Universal','Ver','?')='?' then goto exclF;
  sec.Clear;
  ini.ReadSections(sec);
  sec.Delete(0);
  {чтение групп, заполнение списка}
  for j:=0 to sec.Count-1 do
    begin
    curGrp:=ini.ReadString(sec[j],'Group','< По умолчанию >');
    added:=true;
    for j2:=0 to group.Items.Count-1 do
      if uppercase(curGrp)=uppercase(group.Items[j2]) then added:=false;
    if added=true then group.Items.Add(curGrp);
    end;
  resCount:=resCount+sec.Count;//всего ресурсов
  exclF:
  ini.Free;
  end;

{чтение и заполнение массива}
SetLength(res,resCount);
resCur:=0;
for i:=0 to files.Count-1 do
  begin
  ini:=TIniFile.Create(ADir+'\'+files.Strings[i]);
  if ini.ReadString('_CONFIG_ Shell Universal','Ver','?')='?'
                                                  then goto exclF2;
  ini.ReadSections(sec);
  sec.Delete(0);//удаление 1 секции
  for j:=0 to sec.Count-1 do
    begin
    res[resCur].Group:=ini.ReadString(sec[j],'Group','< По умолчанию >');
    res[resCur].Name:=ini.ReadString(sec[j],'Name','< Безымянный >');
    resList.Items.Add(res[resCur].Name);
    res[resCur].resListIndex:=resCur;
    res[resCur].Comment:=ini.ReadString(sec[j],'Comment','');
    for j2:=0 to 5 do
      begin
      res[resCur].buttons[j2].Caption:=ini.ReadString(sec[j],'ButtonCaption'+inttostr(j2+1),'');
      res[resCur].buttons[j2].Action:=ini.ReadString(sec[j],'ButtonAction'+inttostr(j2+1),'');
      res[resCur].buttons[j2].ActionCmd:=ini.ReadString(sec[j],'ButtonActionCmd'+inttostr(j2+1),'')
      end;
    inc(resCur);//глобальный индекс ресурса
    end;
  exclF2:
  ini.Free;
  end;

files.Free;
sec.Free;
end;

procedure Tfrm.resListClick(Sender: TObject);
var i, j: cardinal;
label findOk;
begin
for i:=0 to resCount-1 do
  if res[i].resListIndex=resList.ItemIndex then
    begin
    resActive:=i;
    goto findOk;
    end;
findOk:
name.Text:=res[i].Name;
name.Hint:=res[i].Name;
comment.Text:=res[i].Comment;
for j:=0 to 5 do
  if res[i].buttons[j].Caption<>'' then
    begin
    bevel[j].Visible:=true;
    btn[j].Caption:=res[i].buttons[j].Caption;
    btn[j].Visible:=true;
    end
    else
    begin
    bevel[j].Visible:=false;
    btn[j].Visible:=false;
    end;

end;

procedure Tfrm.FormActivate(Sender: TObject);
begin
  Application.OnShowHint := ShowHint;
  SaveHintHidePause := Application.HintHidePause;
  SaveHintPause := Application.HintPause;
  Application.HintHidePause := 5000;
  Application.HintPause := 300;
end;

procedure Tfrm.FormDeactivate(Sender: TObject);
begin
 Application.HintHidePause := SaveHintHidePause;                       
// Восстанавливаем начальные значения.
 Application.HintPause := SaveHintPause;
end;

procedure Tfrm.cdBrowseClick(Sender: TObject);
begin
shellexecute(handle,'open',pansichar(extractfiledrive(application.ExeName)+'\')
                                                  ,nil,nil,sw_showdefault);
if resCount=0 then application.Terminate;
end;

procedure Tfrm.visibleAllClick(Sender: TObject);
var i: cardinal;
begin
group.Enabled:=not visibleAll.Checked;
resList.Clear;
name.Clear;
comment.Clear;
for i:=0 to 5 do
  begin
  btn[i].Visible:=false;
  bevel[i].Visible:=false;
  end;
if visibleAll.Checked then
  begin
  group.ItemIndex:=-1;
  for i:=0 to resCount-1 do
    begin
    resList.Items.Add(res[i].Name);
    res[i].resListIndex:=resList.Count-1;
    end;
  end
  else
  begin
  for i:=0 to resCount-1 do
    begin
    group.ItemIndex:=0;
    res[i].resListIndex:=-1;
    if res[i].Group=group.Text then
      begin
      resList.Items.Add(res[i].Name);
      res[i].resListIndex:=resList.Count-1;
      end;
    end;
  end;

end;

procedure Tfrm.groupClick(Sender: TObject);
var
i: Cardinal;
begin
resList.Clear;
name.Clear;
comment.Clear;
for i:=0 to 5 do
  begin
  btn[i].Visible:=false;
  bevel[i].Visible:=false;
  end;
for i:=0 to resCount-1 do
  begin
  res[i].resListIndex:=-1;
  if res[i].Group=group.Text then
    begin
    resList.Items.Add(res[i].Name);
    res[i].resListIndex:=resList.Count-1;
    end;
  end;
end;

procedure Tfrm.WMSysCommand(var Msg: TWMSysCommand);
begin
case Msg.CmdType of
MenuItem, MenuItem+1: shellexecute(0,'open','mailto:shurik83@mail.ru',nil,nil,sw_showdefault);
MenuItem+2: shellexecute(0,'open','http://www.shurik83.narod.ru/',nil,nil,sw_showdefault);
else
inherited;
end;

end;

end.
