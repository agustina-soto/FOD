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
	valorAlto = -1;// chequear si no tengo q poner valor alto en serio aca
type
	rango = 1..MAQUINAS;
	cadena20 = string[20];

	fecha = record
		dia: rangoSemana; // random(30)+1;
		mes: rangoMes; // random(12)+1;
	end;

	sesion = record
		cod_usuario: integer;
		fecha: fecha;// semana --> infoMae.fecha := 'Semana ', i , ' del mes ', mes); --> mes := random(12)+1;
		tiempo: integer; // # x USUARIO  -->  JUAN
						 // # x DIA      -->  Semana 1 del mes 4
						 // # x HORAS    -->  17 horas	
	end;

	// Ordenados por codigo de usuario y fecha
	detalle = file of sesion;
	maestro = file of sesion;

	detalles = array of [rango] of detalle; // Uno por máquina
	usuarios_min = array of [rango] of sesion; // Un minimo por archivo (cant archivos = cant maquinas)


// Asigna archivos logicos con los fisicos (ya creados) de 5 archivos detalle de sesion
procedure asignarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		assign(v[i], 'detalle_' + IntToStr(i));
end;


// Cierra los detalles de sesion
procedure cerrarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en valorAlto, sino devuelve el registro que se leyo
procedure leerDetalle (var det: detalle; var info: sesion);
begin
	if (not eof(det)) then
		read(det, info)
	else
		info.cod_usuario := valorAlto;
end;


// Busca los codigos de usuario minimos entre todos los archivos y los almacena en un vector
procedure guardarMinimos(var vSesiones: detalles; var vMin: usuarios_min);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do begin
		reset(vSesiones[i]);
		leerDetalle(vSesiones[i], vMin[i]);
	end;
end;


// Busca el codigo de usuario minimo entre los 5 archivos detalle de un vector recibido y lo devuelve en el parametro "min"
procedure minimo(var vSesiones: detalles; var vMin: usuarios_min; var min: sesion);
var
	i: integer;
	posMin: integer;
begin
	min := vMin[1];
	posMin := 1;
	for i := 2 to MAQUINAS do begin
		if (vMin[i].cod_usuario < min.cod_usuario) then begin
			min := vMin[i];
			posMin := i;
		end;
	end;
	leerDetalle(vSesiones[posMin], vMin[posMin]);
	writeln('MINIMO ACTUALIZADO');
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
