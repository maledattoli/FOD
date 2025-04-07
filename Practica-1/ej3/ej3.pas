program ej3;
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
// a i
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
procedure menu(var opcion:integer);
begin
     writeln('decime la opcion que queres');
     writeln();
     writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido terminado, el cual se proporciona desde el teclado');
     writeln('2. Listar en pantalla los empleados de a uno por línea');
     writeln('3. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse');
     writeln('4. Salir');
     writeln(' La opcion es: ');
     readln(opcion);
     writeln();
end;
procedure seleccionB(var archLog: archivo);
var
   opcion:integer;
begin
     menu(opcion);
     while(opcion <> 4)do begin
                  case opcion of
                       1: mostrarCodigosDeterminados(archLog);
                       2: mostrarEmpleadosPorLine(archLog);
                       3: mostarrProximosAJubilacion(archLog);
                       else
                           writeln('opcion invalida');
                       end;
                  menu(opcion);
     end;
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
end;
procedure elA(var archLog: archivo);
var
   empleado:empleado;
begin
     leerEmpleado(empleado);
     while(empleado.ap <> 'fin')do begin
          write(archLog, empleado);
          leerEmpleado(empleado);
     end;
     close(archLog);
end;
var
   arch:archivo;
   nombre: string[20];
begin
     writeln('ingrese el nombre del archivo');
     readln(nombre);//pone algo.txt
     assign(arch,nombre);
     rewrite(arch);
     elA(arch);
     seleccionB(arch);

end.
