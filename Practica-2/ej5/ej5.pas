{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
 Cada archivo detalle está ordenado por cod_usuario y fecha.
 Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
 El archivo maestro debe crearse en la siguiente ubicación física: /var/log.} // es decir puede tener q seguir buscando hasta encontrar el q es
program ej5;
const
     valorAlto=9999;
     df=3; //para probarlo
     //df=5;
type
    reg= record
    cod:integer;
    fecha:string;
    tiempo:real;
    end;
    detalle = file of reg;
    maestro=file of reg;
    detalles = array [1..df] of detalle;
    vecReg = array [1..df] of reg;
procedure leer(var det:detalle; var r:reg);
begin
    if(not eof(det))then
        read(det,r)
    else
        r.cod:=valorAlto;
end;
procedure minimo(var ds:detalles; var vR:vecReg;var min:reg);
var
   i,posicion:integer;
begin
    min.cod:=valorAlto;
    min.fecha:='zzz';
    posicion:=-1;
    for i :=1 to df do begin
        if( vR[i].cod<min.cod)or ((vR[i].cod = min.cod)and(vR[i].fecha < min.fecha))then begin
            min:=vr[i];
            posicion:=i;
        end;
    end;
    if(min.cod<>valorAlto)then
        leer(ds[posicion], vr[posicion]);
end;
procedure crearDetalle(var d:detalle);
var
   r:reg;
   carga:text;
   nombre:string;
begin
    writeln('donde queres guardar el detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('decime de donde saco el detalle');
    readln(nombre);
    assign(d, nombre);
    rewrite(d);
    while(not eof(d))do begin
        with r do begin
            read(carga,cod,tiempo, fecha);
            write(d,r);
        end;
    end;
    close(d);
    close (carga);
end;
procedure crearDetalles(var ds:detalles);
var
   i:integer;
begin
     for i:=1 to df do begin
         crearDetalle(ds[i]);
     end;
end;
procedure imprimirMaestro(var mae: maestro);
var
    r:reg;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, r);
            writeln('codigo: ', r.cod, ' fecha: ', r.fecha, ' Tiempo: ', r.tiempo:0:2);
        end;
    close(mae);
end;
procedure crearMaestro(var mae:maestro;var ds:detalles);
var
   //nombre:string;
   i:integer;
   vR:vecReg;
   min,aux:reg;
begin
    assign(mae, 'ArchMae');
    rewrite(mae);
    for i:=1 to df do begin
        reset(ds[i]);
        leer(ds[i],vR[i]);
    end;
    minimo(ds,vR,min);
    while(min.cod <> valorAlto)do begin
        aux.cod:=min.cod;
        while(min.cod = aux.cod)do begin
            aux.fecha:=min.fecha;
            aux.tiempo:=0;
            while (aux.cod = min.cod)and(aux.fecha = min.fecha)do begin
                aux.tiempo:=aux.tiempo + min.tiempo;
                minimo(ds,vR,min);
            end;
            write(mae,aux);
        end;
    end;
    close(mae);
    for i:=1 to df do begin
        close(ds[i]);
    end;
end;
var
   ds:detalles;
   mae:maestro;
begin
    crearDetalles(ds);
    crearMaestro(mae,ds);
    imprimirMaestro(mae);
end.

