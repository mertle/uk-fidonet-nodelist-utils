{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,R-,S+,V-,X-}
{$M 4096,0,655360}

{$I lastrev.inc}

var
 i,o:text;
 s,t,zonelook,regionlook:string;
 inzone,writing:boolean;
 skipped:longint;
 endnow:boolean;
 buffer:array [1..8192] of byte;

begin
 writeln(#10'UkNode v1.10 (',lastrev,') Copyright (c) 1992 Michael E Ralphson'#10);
 if paramcount<2 then begin
  writeln('Usage: UkNode <full-nodelist> <uk-nodelist>'#13#10#10+
          'UkNode takes a full FidoNet standard nodelist and produces a sub-list from'#13#10+
          'it that contains only those nodes situated in Region 25 (the United Kingdom).');
  exit;
 end;
 writeln('NB: Due to EEC EuroProgram restrictions UkNode will not work beyond 1992!'#10);
 inzone:=false;
 endnow:=false;
 skipped:=0;
 zonelook:='Zone,2';
 regionlook:='Region,25';
 assign(i,paramstr(1));
 settextbuf(i,buffer,8192);
 assign(o,paramstr(2));
 reset(i);
 if ioresult<>0 then writeln('Are you having me on? There isn''t any ',paramstr(1)) else begin
  rewrite(o);
  if ioresult<>0 then writeln('Whoops! Can''t create ',paramstr(2)) else begin
   writeln('Humming and drumming fingers...'#10);
   writing:=false;
   writeln(o,'; A FidoNet standard Nodelist for 2:25?/* nodes (UK) only');
   writeln(o,';');
   writeln(o,'; Produced especially for people with no disk space, or those who can''t');
   writeln(o,'; resist phoning around the world if given half the chance.');
   writeln(o,';');
   repeat
    readln(i,s);
    if copy(s,1,6)=zonelook then begin
     writeln('Bienvenu, wilcommen and welcome to EUROPE!'#10);
     writeln(o,s);
     inzone:=true;
    end else if copy(s,1,4)='Zone' then begin
     inzone:=false;
     writing:=false;
     writeln('I don''t think we''ll bother with zone '+copy(s,6,1)+#10);
    end;
    if inzone and (copy(s,1,9)=regionlook) then begin
     writing:=true;
     writeln('Land of hope and glory!'#10);
     writeln(o,'; ',skipped,' This line is terribly important');
    end else if copy(s,1,6)='Region' then begin
     if writing then begin
      writeln('The rest of the nodelist doesn''t look that interesting, let''s skip it.');
      endnow:=true;
     end;
     writing:=false;
    end;
    if writing then writeln(o,s) else inc(skipped);
   until endnow;
   close(i);
   close(o);
  end;
 end;
end.
