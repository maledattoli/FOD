{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente informaci�n:
c�digo de producto, nombre comercial, precio de venta, stock actual y stock m�nimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: c�digo de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
- Ambos archivos est�n ordenados por c�digo de producto.
- Cada registro del maestro puede ser actualizado por 0, 1 � m�s registros del
archivo detalle.
- El archivo detalle s�lo contiene registros que est�n en el archivo maestro.
b. Listar en un archivo de texto llamado �stock_minimo.txt� aquellos productos cuyo
stock actual est� por debajo del stock m�nimo permitido.
}
program ej7;
const
     valorAlto=9999;
     df=3; //para probarlo
     //df=5;
type
   producto= record
       nom:string;
       cod:integer;
       precio:real;
       stock:integer;
       stockM;integer;
   end;
   venta= record
       cod:integer;
       unidades:integer;
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
