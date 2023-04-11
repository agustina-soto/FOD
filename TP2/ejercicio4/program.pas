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
uses
	sysutils;
const
	MAQUINAS = 5;
	valorAlto = 9999;
type
	rango = 1..MAQUINAS;
	rangoDias = 1..30;
	rangoMes = 1..12;
	cadena20 = string[20];

	fecha = record
		dia: rangoDias; // de 1 a 30;
		mes: rangoMes; // de 1 a 12;
	end;

	sesion = record
		cod_usuario: integer;
		fecha: fecha;// infoMae.fecha := 'Dia ', i , ' del mes ', mes); --> mes := random(12)+1;
		tiempo: integer; // # x USUARIO  -->  JUAN
						 // # x DIA      -->  Dia i del mes x
						 // # x HORAS    -->  17 horas
	end;

	// Ordenados por codigo de usuario y fecha
	archivo = file of sesion; // que pongo en el campo fehca??? la fecha de hoy?????????

	detalles = array [rango] of archivo; // Uno por máquina
	usuarios_min = array [rango] of sesion; // Un minimo por archivo (cant archivos = cant maquinas)


// Abre los archivos recibidos
procedure abrirDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		reset(v[i]);
end;


// Cierra los archivos recibidos
procedure cerrarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to MAQUINAS do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en valorAlto, sino devuelve el registro que se leyo
procedure leerDetalle (var det: archivo; var info: sesion);
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
end;


function mismaFecha(f1, f2: fecha) : boolean;
begin
	mismaFecha := ( (f1.dia = f2.dia) AND (f1.mes = f2.mes) );
end;

// Recibe archivos detalle y genere un archivo maestro
procedure crearMaestro (var vSesiones: detalles; var mae: archivo);
var
	regMae, min: sesion;
	vMin: usuarios_min;
begin
	guardarMinimos(vSesiones, vMin); // Abre todos los archivos detalle de vSesiones y almacena los minimos de cada detalle en vMin
	rewrite(mae);

	minimo(vSesiones, vMin, min); // Busca el minimo en los detalles
	while (min.cod_usuario <> valorAlto) do begin // Mientras haya algun registro por procesar

		regMae.cod_usuario := min.cod_usuario; // Guarda el codigo de usuario actual
		
		while (min.cod_usuario = regMae.cod_usuario) do begin // Mientras siga con el mismo codigo de usuario

			regMae.tiempo := 0; // Inicializa contador de tiempo por fecha
			regMae.fecha := min.fecha; // Guarda la fecha del usuario actual

			while (mismaFecha(min.fecha, regMae.fecha)) do begin // Mientras siga viniendo al misma fecha
				regMae.tiempo := regMae.tiempo + min.tiempo;
				minimo(vSesiones, vMin, min);
			end; // Sale del while cuando cambia la fecha

			write(mae, regMae);
		
		end; // Sale del while cuando cambia el codigos
	
	end;

	cerrarDetalles(vSesiones); close(mae);
end;


// Exporta un archivo binario recibido a un archivo de texto
procedure exportarArchivoATxt(var arch: archivo; var txt: text);
var
	s: sesion;
begin
	reset(arch); // Abre el archivo binario
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, s);
		writeln(txt, s.cod_usuario, ' - ', s.fecha.dia,'/', s.fecha.mes, ' - ', s.tiempo); // Escribe en el archivo de texto
	end;

	close(arch);	close(txt);
end;


// Exporta los archivos binarios detalles a archivos de texto
procedure exportarDetallesATxt(v: detalles);
var
	i: integer;
	txt: text;
begin
	for i := 1 to MAQUINAS do begin
		assign (txt, 'sesiones_detalle_' + IntToStr(i) + '.txt');
		exportarArchivoATxt(v[i], txt);
	end;
end;


// ---------------------------------------------------------------------
var
	i: integer;
	mae: archivo;
	vDetalles: detalles;
	txt: text;
begin
	assign(mae, 'archivo_maestro_ej4p2'); // /var/log/'archivo_maestro_ej4p2'
	
	for i := 1 to MAQUINAS do
		assign(vDetalles[i], 'detalle_' + IntToStr(i));

	crearMaestro(vDetalles, mae);

	assign(txt, 'sesiones_maestro.txt'); // Asigna el nombre fisico con el logico
	
	exportarArchivoATxt(mae, txt);
	exportarDetallesATxt(vDetalles);

	writeln('Finalizado');
end.
