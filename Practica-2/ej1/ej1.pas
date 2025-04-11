program ej1;
const
     valorAlto = 9999;
type
    empleado = record
         cod:integer;
         nom:string;
         monto:real;
    end;
    eCompacto = record
         cod : integer;
         totalM:double;
    end;
    detalle = file of empleado;//Datos específicos, repetitivos o temporales
    //DETALLE se recorre para actualizar el maestro
    //MAESTRO se actualiza a partir del detalle
    maestro = file of eCompacto;//info resumida justamente mas compacta
procedure leerArchivo(var a:detalle; var dato:empleado);
begin
     if(not eof(a))then // no se hace un while con el eof
          read(a,dato)
     else
         dato.cod:= valorAlto;//para poder terminar de leer cuando se lee el final
end;
procedure leerEmpleado(var e:empleado);
begin
     writeln('decime el codigo');
     readln(e.cod);
     if(e.cod <> -1)then begin
          writeln('decime el nombre');
          readln(e.nom);
          writeln('decime el monto');
          readln(e.monto);
     end;
end;
procedure crearDetalle(var a:detalle);
var
   e:empleado;
begin
     rewrite(a);
     leerEmpleado(e);
     while(e.cod <> -1)do begin
          write(a, e); // para escribir write ayuda estoy muy quemada (no se de que hablaba)
          leerEmpleado(e);
     end;
     close(a);
end;

procedure compactar(var det:detalle; var mae:maestro);
var
   e:empleado;
   eC: eCompacto;
   codActual:integer;
begin
     reset(det);
     rewrite(mae);
     leerArchivo(det,e);
     while(e.cod <> valorAlto)do begin
          codActual:= e.cod;
          eC.totalM:=0;
          while(e.cod = codActual)do begin
               eC.totalM:=eC.totalM + e.monto;
               leerArchivo(det, e);
          end;
          eC.cod:= codActual;//asigno despues del while es decir cuando cambia
          write(mae,eC);
     end;
     close(det);
     close(mae);
end;
procedure informarMaestro(var m:maestro);
var
   c:eCompacto;
begin
     reset(m);
     while(not eof(m))do begin
          read(m, c);
          writeln('INFORMANDO MAESTRO');
          writeln('el codigo es ',c.cod);
          writeln('el monto total es ',c.totalM:0:2);
     end;
end;
var
   det:detalle;
   mae:maestro;
begin
    assign(det,'archivoEmpleado');
    assign(mae, 'archivoCompacto');
    crearDetalle(det);
    //informarDetalle(det); no me dio ganas de hacerlo
    compactar(det, mae);
    informarMaestro(mae);
end.
