{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente informaci�n: c�digo de
provincia, c�digo de localidad, n�mero de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuaci�n:
C�digo de Provincia
C�digo de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
C�digo de Provincia
C�digo de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
����������������������..
Total General de Votos: ___
NOTA: La informaci�n se encuentra ordenada por c�digo de provincia y c�digo de
localidad
}
program ej7;
const
     valorAlto=9999;
     df=3; //para probarlo
     //df=5;
type


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
