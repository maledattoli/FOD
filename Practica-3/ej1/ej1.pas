{
  Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.

}

program ej4;
type
   empleado = record
            nro: integer;
            ap: string[50];
            nom:string[50];
            edad: integer;
            dni: string;
    end;
    archivo = file of empleado;
procedure imprimo(empleadito:empleado);
begin
     writeln('numeo de empleado: ',empleadito.nro);
     writeln('apellido: ',empleadito.ap);
     writeln('nombre: ',empleadito.nom);
     writeln('edad',empleadito.edad);
     writeln('dni',empleadito.dni);
end;
procedure leerEmpleado(var e:empleado);
begin
     writeln('Ingresa el aprllido');
     readln(e.ap);
     if(e.ap <> 'fin')then begin
          writeln('nombre');
          readln(e.nom);
          writeln('edad');
          readln(e.edad);
          writeln('numero de empleado');
          readln(e.nro);
          writeln('dni');
          readln(e.dni);
     end;
end;// a i
procedure mostrarCodigosDeterminados(var archLog:archivo);
var
   nomOAp:string[50];
   aux:empleado;
begin
     reset(archLog);
     writeln('decime el nombre o apellido a buscar');
     readln(nomOAp);
     while(not eof(archLog))do begin
         read(archLog, aux);
         if(aux.ap = nomOAp) or (aux.nom = nomOAp)then
                   imprimo(aux);
     end;

end;
procedure mostrarEmpleadosPorLine(var arch:archivo);
var
   e:empleado;
begin
     reset(arch);
     while(not eof(arch))do begin
          read(arch,e);
          imprimo(e);
     end;
     close(arch);
end;
procedure mostarrProximosAJubilacion(var archLog:archivo);
var
   emple:empleado;
begin
     reset(archLog);
     while not eof(archLog)do begin
          read(archLog,emple);
          if(emple.edad > 70)then
               imprimo(emple);
     end;
     close(archLog);
end;
function controlUnicidad(var a:archivo;nro:integer):boolean;
var
   aux:boolean;//para saber si se puede o no guardar
   e:empleado;
begin
     aux:= true;
     while( not eof(a)and aux)do begin
            read(a,e);
            if(nro = e.nro)then
                      aux:= false;
     end;
     controlUnicidad:= aux;
end;
procedure aniadirEmpleado(var archLog:archivo);
var
   e:empleado;
begin
     writeln('que empleado queres agregar');
     leerEmpleado(e);
     reset(archLog);
     while(e.ap <> 'fin')do begin
          if(controlUnicidad(archLog, e.nro))then begin
               seek(archLog, fileSize(archLog));{para que se agregue al final}
               write(archLog, e);
          end;
          leerEmpleado(e);
     end;
     close(archLog);
end;
procedure modificarEdad(var archLog:archivo);
var
   nro,edad:integer;
   encon:boolean;
   e:empleado;
begin
     reset(archLog);
     writeln('de que empleado queres cambiar la edad');
     readln(nro);
     encon:=false;
     while (not eof(archlog)and not encon)do begin
          read(archLog,e);{leo el empleado actual}
          if(e.nro =  nro)then begin
               encon:=true;
               writeln('decime la edad nuva');
               readln(edad);
               e.edad:=edad;
               seek(archLog, filePos(archLog)-1);{se avanzo el puntero x eso se retrocede xq despues quiero escribir en ese no en el sifguiente}
               write(archLog,e); {escribo el empleado}
          end;
     end;
     if(encon)then writeln('existia el empleado')
     else writeln('no existia el empleado');
     close(archlog);
end;
procedure exportarAotroArch(var archLog:archivo);
var
   e:empleado;
   todos_empleados:text;
begin
     assign(todos_empleados, 'todos_empleados.txt');
     reset(archLog);
     rewrite(todos_empleados);{creo el archivo}
     while(not eof(archLog))do begin
          read(archLog, e);
          with e do{para no tener q escribir e.}
               writeln(todos_empleados, ' nro: ',nro, ' apellido: ', ap, ' nombre: ', nom, ' edad: ', edad, 'dni: ', dni);
     end;
     close(archLog);
     close(todos_empleados);
end;
procedure exportarEmpleadosSinDni(var archLog:archivo);
var
   e:empleado;
   falta_dni:text;
begin
     assign(falta_dni, 'faltaDNIEmpleado.txt');
          reset(archLog);
          rewrite(falta_dni);{creo el archivo}
          while(not eof(archLog))do begin
               read(archLog, e);
               if(e.dni = '00')then begin
                    with e do{para no tener q escribir e.}
                         writeln(falta_dni, ' nro: ',nro, ' apellido: ', ap, ' nombre: ', nom, ' edad: ', edad, 'dni: ', dni);
               end;
          end;
     close(archLog);
     close(falta_dni);
end;
procedure realizarBaja(var a:archivo);
var
   numero:integer;
   aux,emp:empleado;
   ok:boolean;
begin
    writeln('iingrese el numero de empleado a eliminar');
    ok:=false;
    reset(a);
    seek(a,fileSize(a)-1);
    read(a,aux);
    seek(a,0);
    readln(numero);
    while(not eof(a) and not (ok)) do begin
        read(a, emp);
        if(emp.nro = numero)then begin
            ok:=true;
            seek(a,filePos(a)-1);
            write(a, aux);
            seek(a, fileSize(a)-1);
            truncate(a);
        end;
    end;
    close(a);
end;
procedure menu(var opcion:integer);
begin
     writeln('decime la opcion que queres');
     writeln();
     writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido terminado, el cual se proporciona desde el teclado');
     writeln('2. Listar en pantalla los empleados de a uno por línea');
     writeln('3. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse');
     writeln('4. Añadir empleado');
     writeln('5. modificar edad de empleado dado');
     writeln('6. Exportar el archivo a otro archivo de texto');
     writeln('7. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI');
     writeln('8. Realizar baja.');
     writeln('9. Salir');
     writeln(' La opcion es: ');
     readln(opcion);
     writeln();
end;
procedure seleccionB(var archLog: archivo);
var
   opcion:integer;
begin
     menu(opcion);
     while(opcion <> 9)do begin
                  case opcion of
                       1: mostrarCodigosDeterminados(archLog);
                       2: mostrarEmpleadosPorLine(archLog);
                       3: mostarrProximosAJubilacion(archLog);
                       4: aniadirEmpleado(archLog);
                       5: modificarEdad(archLog);
                       6: exportarAotroArch(archLog);
                       7: exportarEmpleadosSinDni(archLog);
                       8: realizarBaja(archLog);
                       else
                           writeln('opcion invalida');
                       end;
                  menu(opcion);
     end;
end;
var
   nombre: string[20];
   arch:archivo;
begin
     writeln('ingrese el nombre del archivo');
     readln(nombre);
     assign(arch,nombre);
     rewrite(arch);
     aniadirEmpleado(arch);
     seleccionB(arch);

end.
