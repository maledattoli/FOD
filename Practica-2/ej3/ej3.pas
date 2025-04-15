{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.} // es decir puede tener q seguir buscando hasta encontrar el q es
program ej3;
const
     valorAlto='ZZZ';
type
    datosM=record
        nom:string;
        cantA:integer;
        total:integer;
    end;
    datosD=record
        nom:string;
        cod:integer;
        cantA:integer;
        total:integer;
    end;
    maestro= file of datosM;
    detalle= file of datosD;

procedure leer(var det:detalle;var d:datosD);
begin
    if (not eof(det))then
       read(det,d)
    else
        d.nom:=valorAlto;
end;
procedure min(var r1,r2,min:datosD; var d1,d2:detalle);
begin
    if(r1.nom <= r2.nom)then begin
        min:=r1;
        leer(d1,r1);
    end
    else
    begin
        min:=r2;
        leer(d2,r2);
    end;
end;
procedure imprimirMae(var mae:maestro);
var
   d:datosM;
begin
    reset(mae);
    while(not eof(mae))do begin
        read(mae,d);
        with d do
             writeln('el nombre es ', nom, 'la cantidad de alfabetizadoes es ', cantA, 'el total de encuesttados es ', total);
    end;
    close(mae);
end;
procedure crearDetalle(var d:detalle; var carga: text); //leo de carga
var
   nombre:string;
   datos:datosD;
begin
    reset(carga);
    writeln('decime un nombre para el archivo binario');
    readln(nombre);
    assign(d, nombre);
    rewrite(d);
    while(not eof(carga))do begin
        with datos do begin
            readln(carga,cod,cantA,total,nom);//lo saco de carga y luego lo escribo
            write(d,datos);
        end;
    end;
    close(d);
    close(carga);
end;
procedure crearMaestro(var m:maestro;var carga:text);
var
   nombre:string;
   datos:datosM;
begin
    reset(carga);
    writeln('decime un nombre para el archivo');
    readln(nombre);
    assign(m,nombre);
    rewrite(m);
    while(not eof(m))do begin
        with datos do begin
            readln(carga, cantA, total, nom);
            write(m, datos);
        end;
    end;
end;
procedure actualizarMaestro(var d1,d2:detalle; var m:maestro);
var
   r1,r2,minimo:datosD;
   datos:datosM;
begin
    reset(m);
    reset(d1);
    reset(d2);
    leer(d1,r1);
    leer(d2,r2);
    min(r1, r2, minimo, d1, d2);
    while(minimo.nom <> valorAlto)do begin
        read(m, datos);
        while(datos.nom <> minimo.nom)do
            read(m,datos);
        while(datos.nom = minimo.nom)do begin
            datos.cantA:=datos.cantA + minimo.cantA;
            datos.total:=datos.total + minimo.total;
            min(r1,r2,minimo,d1,d2);
        end;
        seek(m, filePos(m)-1);
        write(m,datos);
    end;
    close(d1);
    close(d2);
    close(m);
end;
var
   det1,det2: detalle;
   cargaD1,cargaD2,cargaM:text;
   mae:maestro;
begin
    assign(cargaD1,'detalle1.txt');
    assign(cargaM, 'maestro.txt');
    assign(cargaD2,'detalle2.txt');
    crearMaestro(mae,cargaM);
    crearDetalle(det1,cargaD1);
    crearDetalle(det2,cargaD2);
    imprimirMae(mae);//el maestro original
    actualizarMaestro(det1,det2,mae);
    imprimirMae(mae);//maestro modificado
end.
