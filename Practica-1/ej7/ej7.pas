program ej7;
type
    novela = record
        cod:integer;
        nom:String;
        genero:string;
        precio:real;
    end;
    archivo = file of novela;
procedure crearBinario(var a:archivo; var nove:text); ///DE TEXT A BINARIO READLN Y WRITE
var
   n:novela;
   nombre:string;
begin
     reset(nove);
     writeln('decime el nombre del archivo');
     readln(nombre);
     assign(a,nombre);
     rewrite(a);
     while(not eof(nove))do begin
           with n do begin  //en n guardo
                readln(nove, cod, precio, genero);  // saco de carga n.cod n.precio y n.genero
                readln(nove,nombre);  //saco de carga y congo en n.nombre
                write(a,n);
           end;
     end;
     writeln('termino la carga');
     close(a);
     close(nove);
end;
procedure menuWrite(var opcion:integer);
begin
    writeln('----------------------------------------------------');
    writeln('menuuuuu');
    writeln('1. crear bienario a partir de novelas.txt');
    writeln('2. agregar novela');
    writeln('3. modificar novela');
    writeln('4. exportar a texto el binario');
    writeln('5. Salir del menu');
    writeln('-----------------------------------------------------');
    writeln('escribi el numero de la opcion');
    writeln('-----------------------------------------------------');
    readln(opcion);
end;
procedure leerNovela(var n:novela);
begin
    writeln('decime el codigo');
    readln(n.cod);
    if(N.cod <>-1)then begin
         writeln('decime el nombre');
         readln(n.nom);
         writeln('decime el genero');
         readln(n.genero);
         writeln('decime el precio');
         readln(n.precio);
    end;
end;
procedure leerNovelaSinCod(var n:novela);
begin
     writeln('decime el nombre');
     readln(n.nom);
     writeln('decime el genero');
     readln(n.genero);
     writeln('decime el precio');
     readln(n.precio);

end;
procedure agregarNovelas(var a :archivo);
var
   n:novela;
begin
     reset(a);
     leerNovela(n);
     seek(a, fileSize(a));//pongo el puntero al final SEEK PARA MOVER EL PUNTERO
     while (n.cod <>-1)do begin
          write(a, n);
          leerNovela(n);
     end;
     close(a);//SIEMPRE ME ACUERDO DE CERRAR LOS ARCHIVOS
end;
procedure modificarNovelas(var a:archivo);
var
   encontre:boolean;
   codABuscar:integer;
   n:novela;
begin
     encontre:= false;
     reset(a);
     writeln('que codigo queres modificar?');
     readln(codABuscar);
     while(not eof(a))and (not encontre)do begin
          read(a,n);
          if(codABuscar = n.cod)then begin
               encontre:=true;
               leerNovelaSinCod(n);
               seek(a, filePos(a)-1); //para agregar al final se usa seek para mover el puntero
               write(a,n);
          end;
     end;
     if(not encontre)then writeln('no hay un archivo llamado asi');
     close(a);
end;
procedure exportarATexto(var a:archivo; var nove:text);//DE BINI A TEXT CON WRITELN
var
   n:novela;
begin
     reset(a);
     rewrite(nove);//borro todo para poder volver a escribirlo
     while(not eof(a))do begin
          read(a,n);
          with n do begin
              writeln(nove, cod, ' ', precio:0:2, ' ', genero);
              writeln(nove, nom);
          end;
     end;
end;
procedure menu(var a:archivo; var nove:text);
var
   opcion:integer;
begin
    menuWrite(opcion);
    while(opcion <> 5)do begin
         case opcion of
             1: crearBinario(a,nove);
             2: agregarNovelas(a);
             3: modificarNovelas(a);
             4: exportarATexto(a,nove);
         else
             writeln('opcion incorrecta pone 1,2,3,4 o 5');
         end;
         menuWrite(opcion);
    end;
end;
var
   nove:text;
   a:archivo;
begin
     assign(nove, 'C:\facufacu\FOD\Practica-1\ej7\novelas.txt');
     menu(a,nove);
end.
