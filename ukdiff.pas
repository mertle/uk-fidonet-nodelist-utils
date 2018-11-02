{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,R-,S+,V-,X-}
{$M 4096,0,655360}
program ukdiff;

uses dos;

{$I lastrev.inc}

var
 dir:dirstr;
 name:namestr;
 ext:extstr;
 l,d,o:text;
 zone2,filespec,param1,param2,s:string;
 skipped,oldskipped,lines:longint;
 earliest,current,count,number:word;
 c,c2:char;
 writing:boolean;

procedure check;

begin
 if skipped=oldskipped then begin
  writing:=true;
  writeln(o,'; A FidoNet standard Nodelist for 2:25?/* nodes (UK) only');
  writeln(o,';');
  writeln(o,'; Produced especially for people with no disk space, or those who can''t');
  writeln(o,'; resist phoning around the world if given half the chance.');
  writeln(o,';');
  writeln(o,zone2);
  writeln(o,'; ',lines,' This line is terribly important');
 end;
end;

procedure doadd;

begin
 for count:=1 to number do begin
  readln(d,s);
  if writing then writeln(o,s) else
  if skipped<oldskipped then inc(lines);
 end;
end;

procedure dodel;

begin
 for count:=1 to number do begin
  if writing then readln(l,s) else
  if skipped<oldskipped then begin
   inc(skipped);
   check;
   dec(lines);
  end;
 end;
end;

procedure docopy;

begin
 for count:=1 to number do
  if writing then begin
   readln(l,s);
   writeln(o,s);
  end else if skipped<oldskipped then begin
   inc(skipped);
   check;
  end;
end;

begin
 writeln(#10'UkDiff v1.10 ('+lastrev+') Copyright (c) 1992 Michael E Ralphson'#10);
 if paramcount<2 then begin
  writeln('Usage: UkDiff <nodelist> <nodediff>'#13#10#10+
          'UkDiff is the companion program to UkNode. It will only process a nodelist'#13#10+
          'that was originally produced by UkNode. UkDiff applies the weekly nodediff'#13#10+
          'update file and merges it with the nodelist.');
 end else begin
  param1:=paramstr(1);
  param2:=paramstr(2);
  assign(l,param1);
  reset(l);
  if ioresult<>0 then begin
   writeln('I''d find it easier to cope if you specified the right nodelist file.');
   exit;
  end;
  assign(d,param2);
  reset(d);
  if ioresult<>0 then begin
   writeln('Do I look stupid? Why run the program if the nodediff doesn''t exist?');
   exit;
  end;
  fsplit(param1,dir,name,ext);
  filespec:=dir+name;
  fsplit(param2,dir,name,ext);
  filespec:=filespec+ext;
  assign(o,filespec);
  rewrite(o);
  if ioresult<>0 then begin
   writeln('Fatal Hardware Error. Buy a bigger hard disk and try again.');
   exit;
  end;

  for count:=1 to 6 do readln(l,s);
  zone2:=s;
  readln(l,c,c2,skipped,s);
  oldskipped:=skipped;
  lines:=skipped;
  skipped:=0;
  writing:=false;
  readln(d,s);
  repeat
   readln(d,c,number);
   case upcase(c) of
    'A':doadd;
    'D':dodel;
    'C':docopy;
    else writeln('Unknown NodeDiff command: '+c,number);
   end;
  until (eof(l)) or (eof(d));

  close(o);
  writeln('And now for something completely different...');
 end;
end.
