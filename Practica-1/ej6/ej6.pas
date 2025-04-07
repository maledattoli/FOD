program ej6;
uses crt, SysUtils;
type
     celular = record
      cod:integer;
      nom:string[50];
      descripcion:string[50];
      marca:string[50];
      precio: real;
      sMin:integer;
      stock: integer;
     end;
     archivito = file of celular;
//aaaaaaa
procedure crearArchivo(var a:archivito; var carga:text);
var
   celu:celular;
   nombre:string;
begin
     reset(carga);
     writeln('decime el nombre del archivo ');
     readln(nombre);
     assign(a, nombre);
     rewrite(a);

     while (not eof(carga))do begin
           with celu do
           begin
                readln(carga, cod, precio, marca);//ultimo el string
                readln(carga, stock, sMin, descripcion);
                readln(carga, nom);
           end;
           write(a, celu);

     end;
     writeln('cargado');
     writeln;
     close(a);
     close(carga);
end;
//bbbbbb
procedure imprimir(c: celular);
begin
     with c do begin
          writeln('nombre',nom);
          writeln('descripcion',descripcion);
          writeln('marca',marca);
          writeln('precio',precio);
          writeln('stock minimo',sMin);
          writeln('stock total',stock);
     end;
end;
procedure listarmenorMin(var a:archivito);
var
   aux:celular;
begin
     reset(a);
     while(not eof(a))do begin
          read(a,aux);
          if(aux.stock < aux.sMin)then
               imprimir(aux);
     end;
     close(a);
end;
//cccccc
procedure listarDCadena(var a :archivito);
var
   aux:celular;
   cadena:string;
   cadenaIgual:boolean;
begin
     reset(a);
     writeln('decime una descripcion');
     readln(cadena);
     cadena:= ' ' + cadena; //CUANDO LEO LA CADENA DEL TXT LE AGREGA UN ESPACIO AL INICIO para no usar el trim
     cadenaIgual:=false;
     while(not eof(a))do begin
          read(a,aux);
          if(cadena = aux.descripcion)then begin
              imprimir(aux);
              cadenaIgual:=true;
          end;
     end;
     if(not cadenaIgual)then
            writeln('no hubo ninguna cadena que coincida');
     close(a);
end;
//// ddddddd
procedure exportarArchivo(var a:archivito; var carga:text);
var
   celuAux:celular;
begin
     reset(a);
     rewrite(carga);// voy a escribir en carga x eso rewrite
     while(not eof(a))do begin
          read(a,celuAux);
          with celuAux do begin
               writeln(carga, cod, ' ', precio:0:2, ' ', marca);
               writeln(carga, stock, ' ', sMin, ' ', descripcion);
               writeln(carga, nom);
          end;
     end;
     close(a);
     close(carga);
end;
////menu
procedure opciones(var o:integer);
begin
     writeln('-------------------------------');
     writeln('menuuuu');
     writeln('-------------------------------');
     writeln('1. Crear un archivo de registros no ordenados de celulares');
     writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo');
     writeln('3. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario');
     writeln('4.Exportar el archivo respetando regla');
     writeln('5.Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
     writeln('6.Modificar el stock de un celular dado.');
     writeln('7.Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.');
     writeln('8. Salir del menu y terminar las opercaciones');
     writeln('escribe el numero de la opcion');
     writeln('-------------------------------');
     readln(o);

end;
//6 aaaaaaaaaaaaaaaaaa
procedure leerCelu(var c:celular);
begin
     with c do begin
		write ('codigo: '); readln (cod);
		if (cod <> 0) then begin
			write ('precio: '); readln (precio);
			write ('marca: '); readln (marca);
			write ('stock disponible: '); readln (stock);
			write ('stock minimo: '); readln (sMin);
			write ('descripcion: '); readln (descripcion);
			write ('nombre del celu: '); readln (nom);
		end;
		writeln ('');
	end;
end;

procedure aniadirCelus(var a:archivito);
var
   c:celular;
begin
     writeln('que celulito queres agragar');
     leerCelu(c);
     reset(a);
     seek(a, Filesize(a)); {para agregar al final}
     while(c. cod <>0)do begin
          write(a, c);
          leerCelu(c);
     end;
     close(a);
end;
//bbbbbbb
procedure modificarStock(var a:archivito);
var
   c:celular;
   nombre:string[50];
   s:integer;
   encontre:boolean;
begin
     reset(a);
     encontre:=false;
     writeln('decime  el nombre delcelular a modificar');
     readln(nombre);
     while(not eof(a) and not encontre)do begin
          read(a, c);
          if(c.nom = nombre)then begin
               encontre:=true;
               writeln('decime el nuevo stock');
               readln(s);
               c.stock:=s;
               seek(a, filePos(a)-1);
               write(a,c);
          end;
     end;
     if(not encontre)then
            writeln('no hay un celu con ese nombre');
     close(a);
end;
//cccccccccccc
procedure exportarStock0(var a:archivito; var stockito:text);
var
   c:celular;
begin
     reset(a);
     rewrite(stockito);
     while(not eof(a))do begin
          read(a, c);
          if(c.stock = 0)then begin
              with c do
              begin
                   writeln(stockito, cod, ' ', precio:0:2, ' ', marca);
                   writeln(stockito, stock, ' ', sMin, ' ', descripcion);
                   writeln(stockito, nom);
              end;
          end;
     end;
     close(a);
     close(stockito);
end;
procedure menu(var a:archivito; var carga:text;var stockito:text);
var
   opcion:integer;
begin
     opciones(opcion);
     while(opcion <> 8)do begin
          case opcion of
               1: crearArchivo(a,carga);
               2: listarmenorMin(a);
               3: listarDCadena(a);
               4: exportarArchivo(a,carga);
               5: aniadirCelus(a);
               6: modificarStock(a);
               7: exportarStock0(a, stockito);
          else
              writeln('pusiste cualquier cosa era 1, 2, 3, 4 o 5');
          end;

          opciones(opcion);
     end;
end;
var
   a:archivito;
   carga:text;
   stockito:text;
begin
      assign(carga, 'C:\facufacu\FOD\Practica-1\ej5\celulares.txt');// puse la ruta directa xq no me funcionaba 
      assign(stockito,'SinStock.txt');
      menu(a,carga, stockito);

end.
