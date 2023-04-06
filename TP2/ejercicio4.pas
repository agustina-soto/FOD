{
        NO ESTARIA ENTENDIENDO QUE DATOS DECLARAR :) lpm
}

{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central.

Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas
por cada usuario en cada terminal y por cuánto tiempo estuvo abierta.
 
Cada archivo detalle contiene los siguientes campos: cod_usuario, fecha, tiempo_sesion.

Debe realizar un procedimiento que reciba los archivos detalle y genere un archivo maestro
con los siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log. }

program ejercicio4;
const
	MAQUINAS = 5;
	valorAlto = -1;
type
	rango = 1..MAQUINAS;
	cadena20 = string[20];

	info_detalle = record
		cod_usuario: integer;
		fecha: cadena20; // nro de semana??
		tiempo_sesion: integer; // en segundos? horas?
	end;
	
	info_maestro = record // despues borrar este registro y hacer el maestro de tipo file of info_detalle (cambiarle el nombre)
		cod_usuario: integer;
		fecha: cadena20; // semana --> infoMae.fecha := 'Semana ', i , ' del mes ', mes); --> mes := random(12)+1;
		tiempo_total_de_sesiones_abiertas: integer; // sumo el tiempo de sesion del usuario cod_usuario. osea que me va a quedar:
													// # x USUARIO  -->  JUAN
													// # x DIA      -->  Semana 1 del mes 4
													// # x HORAS    -->  17 horas
	end;

	// Ordenados por codigo de usuario y fecha
	detalle = file of info_detalle;
	maestro = file of info_maestro;


	detalles = array of [rango] of detalle;


// Asigna archivos logicos con los fisicos (ya creados) de 5 archivos detalle de info_detalle
procedure asignarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		assign(v[i], 'detalle_' + IntToStr(i));
end;


// Cierra los detalles de info_detalle
procedure cerrarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en valorAlto, sino devuelve el registro que se leyo
procedure leerDetalle (var det: detalle; var info: info_detalle);
begin
	if (not eof(det)) then
		read(det, info)
	else
		info.cod_usuario := valorAlto;
end;



// Recibe archivos detalle y genere un archivo maestro
procedure (var v: detalles; var mae: maestro);
var
	infoMae: info_maestro;
begin


end;




// ---------------------------------------------------------------------
var
	mae: maestro;
	vDetalles: detalles;
begin
	assign(mae, '/var/log/archivo_maestro_ej4p2');
	asignarDetalles(vDetalles);
	
	
end.
