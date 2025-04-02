Program ej2;
type
   archivo= File of integer;
var
   arch:archivo;
   nomFis: String;
   num, total, menores: integer;
   prom:real;

begin
     prom:= 0;
     total:=0;
     menores:=0;
     writeln('decime el nobre del archivo');
     readln(nomFis);
     assign(arch, nomFis);{inicioo el archivo}
     reset(arch);
     while(not EOF(arch))do begin
               read(arch,num);
               if(num < 1500)then
                      menores := menores +1;
               total:= total +1;
               prom:= prom + num;
               writeln(num);{escribo en pantalla el numero}
     end;
     writeln('el promedio es: ', prom/total:0:2);
     writeln('la cantidad de numeros es: ', total);
     close(arch);
     writeln('presione enter para salir de la consola');
     readln();{para ver el resultado}
end.
