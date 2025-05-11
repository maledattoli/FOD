{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información se encuentra ordenada por código de provincia y código de
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
