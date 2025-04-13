{2. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los  // ya esta generado x eso es con un text
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
- Ambos archivos están ordenados por código de producto.
- Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
- El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}
program ej2;
const
     valorAlto=999;
type
    producto = record
         cod:integer;
         nom:string;
         precio:real;
         stock:integer;
         sMin:integer;
    end;
    maestro= file of producto;
    venta= record
         cod:integer;
         cant:integer;
    end;
    detalle= file of venta;
procedure crearDetalle(var d:detalle; var carga:text);
var
   v:venta;
   nombre:string;
begin
	 reset(carga);
     writeln('Ingrese un nombre para el archivo detalle');
     readln(nombre);
     assign (d, nombre);
     rewrite(d);
     
     while(not eof(carga))do begin
          with v do begin
               readln(carga, cod, cant); 
               write(d,v);
          end;
     end;
     writeln('archivo detalle creado');
     close(d);
     close(carga)
end;
procedure crearMaestro(var m:maestro;var carga : text);
var
   nomb:string;
   p:producto;
begin
    reset(carga);
    writeln('decime un nomre para el archivo maestro');
    readln(nomb);
    assign (m, nomb);
    rewrite(m);
    while(not eof(carga))do begin
         with p do
         begin 
              readln(carga, cod, precio, stock, sMin, nom);
			  write(m, p);// guardo en el maestro los datos guardados
		 end;
    end;
    writeln('archivo maestro creado');
    close(m);
    close(carga);
end;
procedure informarMenu(var op:integer);
begin
     writeln('MENU DE OPCIONES');
     writeln('-----------------------------------------------------------------------');
     writeln('1. Generar archivos binarios maestro y detalle de txt');
     writeln('2. Actualizar el archivo maestro con el archivo detalle');
     writeln('3. Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual esta por debajo del stock minimo permitido');
     writeln('4. Salir del menu de opciones');
     writeln('-----------------------------------------------------------------------');
     readln(op);
end;
procedure leer(var d:detalle;var v:venta);
begin
     if(not eof(d))then
          read(d,v)
     else
         v.cod:=valorAlto;
end;
procedure actualizarMaestro(var m:maestro;var d:detalle);
var
   v:venta;
   p:producto;
begin
     reset(m);
     reset(d);
     leer(d, v);
     while(v.cod <> valorAlto)do begin
          read(m, p);//aca leo
          while(p.cod <> v.cod)do// while xq tenes q avanzar hasta encontrar el maestro a modificar
               read(m,p);// y aca
          while(p.cod = v.cod) do begin
               if(v.cant <= p.stock)then
                    p.stock:=p.stock - v.cant
                else
                    p.stock:=0;
                leer(d, v);
          end;
          seek(m, filePos(m)-1);// cada vez q leo se mueve el puntero tengo q reacomodarlo para escribir
          write(m,p);
     end;
     close(m);
     close(d);
end;
procedure imprimirMae(var m:maestro);
var
   p:producto;
begin
     reset(m);
     while(not eof(m))do begin
          read(m,p);
           with p do
           begin
                writeln('para la venta ', cod, 'que sale ', precio:0:2, ' els tock es: ', stock);
           end;
     end;
end;
procedure pasarAText(var m:maestro);
var
   p:producto;
   sM:text;
begin
      reset(m);
      assign(sM, 'stock_Minino.txt');
      rewrite(sM);
      while(not eof(m))do begin
           read(m, p);
           if(p.stock < p.sMin)then
                with p do
                      writeln(sM, 'Codigo: ', cod, ' precio: ', precio, ' stock: ', stock, ' stock minimo: ', sMin, ' nombre: ', nom);
      end;
      close(m);
      close(sM);
end;
procedure menu();
var
     op:integer;
     det:detalle;
     mae: maestro;
     cargaM, cargaD: text;
begin
	        
     informarMenu(op);
     while(op <> 4)do begin
          case op of
             1:begin 
               assign(cargaD, 'detalle.txt');
               crearDetalle(det, cargaD);
               assign(cargaM, 'maestro.txt');
               crearMaestro(mae, cargaM);
             end;
             2: begin
                actualizarMaestro(mae, det);
                imprimirMae(mae);
                end;
             3: pasarAText(mae);
             else
                 writeln('pusiste cualquier cosa era 1, 2, 3 o 4');
          end;
          informarMenu(op);
     end;
end;
   
begin

     menu();
     readln();
end.
