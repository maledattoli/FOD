{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. //ya esta creado
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
} // es decir puede tener q seguir buscando hasta encontrar el q es
program ej3;
const
     valorAlto=9999;
     n=3; //para probarlo
     //n=30;
type
    producto = record
        cod:integer;
        nom:String[30];
        descripcion:String;
        stock:integer;
        precio:real;
        sMin:integer;
    end;
    venta=record
        cod:integer;
        cantidadVendida:integer;
    end;
    detalle = file of venta;
    detalles = array[1..n] of detalle;
    reg_detalle = array[1..n] of venta; //para no teenr q ir accediendo cada vez a mem
    maestro = file of producto;

procedure crearDetalle(var det:detalle);
var
   v:venta;
   carga:text;
   nombre,ruta:string;

begin
     writeln('decime el nombre q le queres poner al detalle');
     readln(nombre);
     assign(det, nombre);
     rewrite(det);
     writeln('decime la ruta de donde sacamos los datos');
     readln(ruta);
     assign (carga, ruta);
     reset(carga);
     while(not eof(carga))do begin
         with v do begin
             readln(carga, cod, cantidadVendida);
             write(det, v);
         end;
     end;
     close(carga);
     close(det);
end;
procedure crearMaestro(var mae: maestro);
var
   carga:text;
   nombre,ruta:String;
   p:producto;
begin
    writeln('decime el nombre q le queres poner al maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    writeln('decime la ruta de donde sacamos los datos');
    readln(ruta);
    assign (carga, ruta);
    reset(carga);
    while(not eof(carga))do begin
        with p do begin
            readln(carga, cod, stock, precio, sMin, nom);
            readln(carga, descripcion);
            write(mae,p);
        end;
    end;
end;
procedure crearDetalles(var ds:detalles);
var
   i:integer;
begin
    for i:= 1 to n do begin
        crearDetalle(ds[i]);
    end;
end;
procedure imprimirMaestro(var mae:maestro);
var
p:producto;
begin
    reset(mae);
    while(not eof(mae))do begin
        read(mae, p);
        with p do begin
            writeln('el codigo es ',cod,' el stock es ',  stock,' el precio es ', precio:0:2,' el stock minimo es ', sMin,' el nombre es ', nom);
            writeln( ' la descripcion es ', descripcion);
        end;
    end;
    close(mae);
end;
procedure informarEnTexto(var mae:maestro);
var
 texto:text;
 p:producto;
begin
    reset(mae);
    assign(texto, 'reporte.txt');
    rewrite(texto);
    while(not eof(mae))do begin
        read(mae,p);
        if(p.stock < p.sMin)then begin
            writeln(texto, p.precio:0:2, ' ', p.descripcion, ' ', p.stock, ' ',p.nom);
        end;
    end;
end;
procedure leer(var d:detalle;var dato:venta);
begin
    if(not eof(d))then
        read(d, dato)
    else
        dato.cod:=valorAlto;
end;
procedure minimo(var rD:reg_detalle; var min:venta; var det:detalles);
var
   i,indice:integer;
begin
    indice:= -1;
    min.cod:=valorAlto;
    for i := 1 to n do begin
        if(rD[i].cod<min.cod)then begin
			min:=rD[i];
            indice:=i;
            
        end;
    end;
    if(min.cod <> valorAlto)then
        leer(det[indice], rD[indice]);// lee del detalle y guarda en el vector de reg
end;
procedure actualizarMae(var mae:maestro; var ds:detalles);
var
   rD:reg_detalle;
   i, cant,aux:integer;
   p:producto;
   min:venta;
begin
    reset(mae);
    for i:= 1 to n do begin
        reset(ds[i]);
        leer(ds[i], rD[i]);
    end;
    minimo(rD, min, ds);
    while(min.cod <> valorAlto)do begin
        aux:= min.cod;
        cant:=0;
        while(min.cod <> valorAlto) and (min.cod = aux)do begin
            cant:= cant + min.cantidadVendida;
            minimo(rd, min,ds);
        end;
        read(mae,p);
        while(p.cod <> aux)do begin
            read(mae, p);
        end;
        seek(mae, filePos(mae)-1);
        p.stock:= p.stock - cant;
        write(mae,p);
    end;
    informarEnTexto(mae);
    close(mae);
    for i:=1 to n do begin
        close(ds[i]);
    end;
end;
var
   mae:maestro;
   ds:detalles;
begin
    crearDetalles(ds);
    crearMaestro(mae);
    actualizarMae(mae,ds);
    imprimirMaestro(mae);
end.
