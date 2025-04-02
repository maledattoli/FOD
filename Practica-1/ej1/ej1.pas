program ej1;
type
  archivo = File of integer;
var
   arch_logico:archivo;
   nro:integer;
   arch_fisico:string[12];

begin
     writeln('ingrese el nombre del archivo');
     readln( arch_fisico );                         {se obtiene el nombre del archivo}
     assign( arch_logico, arch_fisico );
     rewrite( arch_logico );{se cereea el archivo}
     read(nro);
     while nro <> 30000 do begin
           write( arch_logico, nro );
           writeln('ingrese el nombre del archivo');       {se escribe en el archivo cada numero}
           readln( nro );
     end;
     close( arch_logico );
     writeln('Proceso terminado. Presione Enter para salir.');
     readln();  {?? Esto mantiene la consola abierta hasta que presiones Enter}
end.
