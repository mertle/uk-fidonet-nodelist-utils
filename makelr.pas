{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,P-,Q-,R-,S+,T-,V-,X+}
{$M 16384,0,0}

uses
 dos,utility;

var
 dt:datetime;
 dummy:word;
 thyme:longint;
 s,temp:string;
 f:text;

begin
 if paramcount=0 then exit;

 temp:=paramstr(1);
 assign(f,temp);
 rewrite(f);
 writeln(f,'Const');

 with dt do begin
  getdate(year,month,day,dummy);
  gettime(hour,min,sec,dummy);

  writeln(f,' LastRev=''',itos(day,2),'/',itos(month,2),'/',itos(year mod 100,2),''';');
  writeln(f,' Compile=''',itos(hour,2),':',itos(min,2),':',itos(sec,2),''';');
 end;

 packtime(dt,thyme);
 writeln(f,' ComTime=',thyme,';');

 close(f);
 if ioresult<>0 then write(#7);
end.