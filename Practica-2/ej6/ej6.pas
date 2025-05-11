{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).} // es decir puede tener q seguir buscando hasta encontrar el q es
program ej6;
const
     valorAlto=9999;
     df=3; //para probarlo
     //df=5;
type
    archivoD= record
        codLoc:integer;
        codCepa:integer;
        casosActivos:integer;
        casosNuevos:integer;
        cantidadRecuperados:integer;
        cantidadFallecidos:integer;
        end;
    archivoM=record
        codLoc:integer;
        codCepa:integer;
        nomLoc:string;
        nomCepa:string;
        casosActivos:integer;
        casosNuevos:integer;
        cantidadRecuperados:integer;
        cantidadFallecidos:integer;
    end;
    maestro=file of archivoM;
    detalle= file of archivoD;
    detalles= array[1..dF] of detalle;
    reg_det= array[1..dF] of archivoD;

procedure leer(var d:detalle;var dato:archivoD);
begin
    if(not eof(d))then
        read(d,dato)
    else
        dato.codLoc:=valorAlto;
end;
procedure minimo(var ds:detalles; var min:archivoD;var reg:reg_det);
var
   i,pos:integer;
begin
    min.codLoc:=valorAlto;
    pos:=-1;
    for i:=1 to dF do begin
        if(reg[i].codLoc< min.codLoc) or ((reg[i].codLoc = min.codLoc) and (reg[i].codCepa < min.codCepa))then begin
            min:=reg[i];
            pos:=i;
        end;
    end;
    if(min.codLoc <> valorAlto)then
        leer(ds[pos],reg[pos]);

end;
procedure actualizarMaestro(var ds:detalles; var mae:maestro);
var
   i, cantLocalidades, cantCasosLoc:integer;
   reg_vector:reg_det;
   min:archivoD;
   rM:archivoM;
begin
    reset(mae);
    for i:=1 to df do begin
        reset(ds[i]);
        leer(ds[i], reg_vector[i]);
    end;
    minimo(ds,min,reg_vector);
    cantLocalidades:=0;
    read(mae,rM);
    while(min.codLoc<>valorAlto)do begin
          cantCasosLoc := 0;//inicio en 0 la var para sumar casos
          while(rM.codLoc <> min.codLoc)do
              read(mae,rM);
          while(rM.codLoc = min.codLoc)do begin
              while(rM.codCepa <>min.codCepa)do
                  read(mae,rM);
              while((rM.codLoc = min.codLoc) and (rM.codCepa = min.codCepa))do begin
                  rM.cantidadFallecidos:= rM.cantidadFallecidos + min.cantidadFallecidos;
                  rM.casosActivos:= min.casosActivos;
                  rM.casosNuevos:= min.casosNuevos;
                  cantCasosLoc:=cantCasosLoc + min.casosActivos;
                  minimo(ds, min, reg_vector);
              end;
              seek(mae, filePos(mae)-1);
              write(mae,rM);
          end;
          if(cantCasosLoc > 50)then
              cantLocalidades:=cantLocalidades +1;
    end;
    close(mae);
    for i:=1 to df do begin
        close(ds[i]);
    end;
end;
procedure crearMaestro(var mae:maestro);
var
   carga:text;
   r:archivoM;
begin
    assign(carga,'ArchivoMaestro.txt');
    reset(carga);
    assign(mae,'ArchivoMaestro');
    rewrite(mae);
    while(not eof(carga))do begin
        with r do begin
            read(carga,codLoc,codCepa,casosActivos, casosNuevos, cantidadRecuperados, cantidadFallecidos, nomLoc);
            read(carga, nomCepa);
            write(mae,r);
        end;

    end;
    close(mae);
    close(carga);
end;
procedure crearDetalle(var d:detalle);
var
   nombre:string;
   regD:archivoD;
   carga:text;
begin
    writeln('decime el nombre del detalle');
    readln(nombre);
    writeln('decime la ruta del detalle');
    readln(carga);
    assign(d, nombre);
    rewrite(d);
    reset(carga);
    while(not eof(carga))do begin
        with regD do begin
            readLn(carga, codLoc,codCepa, casosActivos, casosNuevos, cantidadRecuperados, cantidadFallecidos);
            write(d,regD);
        end;
    end;
    close(d);
    close(carga);

end;
procedure crearDetalles(var ds:detalles);
var
   i:integer;
begin
    for i:=1 to df do begin
        crearDetalle(ds[i]);
    end;

end;
procedure imprimirMae(var mae: maestro);
var
    infoMae: archivoM;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae,infoMae);
            writeln('localidad: ',infoMae.codLoc, ' Cepa: ', infoMae.codCepa, ' CA: ', infoMae.casosActivos, ' CN: ', infoMae.casosNuevos, ' CR: ', infoMae.cantidadRecuperados, ' CF: ', infoMae.cantidadFallecidos, ' Nombre Cepa: ', infoMae.nomCepa, ' Nombre Localidad: ', infoMae.nomLoc);
        end;
    close(mae);
end;
var
   ds:detalles;
   mae:maestro;
begin
    crearDetalles(ds);
    crearMaestro(mae);
    // me canse no voy a probarlo mas

    actualizarMaestro(ds,mae);
    imprimirMae(mae);
end.
