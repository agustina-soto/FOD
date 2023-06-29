{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}

program ejercicio6;
uses sysutils;
const
	CANT_DETALLES = 4; // 10;
	VALOR_ALTO = 9999;
type
	cadena40 = string[40];
	rango = 1..CANT_DETALLES;

	contadorCasos = record
		cant_activos: integer;
		cant_nuevos: integer;
		cant_recuperados: integer;
		cant_fallecidos: integer;
	end;

	municipio = record
		cod_localidad: integer;
		cod_cepa: integer;
		cont: contadorCasos;
	end;
	
	info_mae = record
		cod_localidad: integer;
		nombre_localidad: cadena40;
		cod_cepa: integer;
		nombre_cepa: cadena40;
		cont: contadorCasos;
	end;
	
// ORDENADOS POR CODIGO DE LOCALIDAD Y CODIGO DE CEPA
detalle = file of municipio;
maestro = file of info_mae;

detalles = array [rango] of detalle;
municipios_minimos = array [rango] of municipio; // [rango] porque tendra tantos minimos como cantidad de archvos (1 min x archivo)



// Asigna los nombres logicos con los fisicos (ya cargados) de un archivo maestro y varios detalles recibidos
procedure asignarArchivos(var mae: maestro; var vDetalles: detalles);
var
	i: integer;
begin
	assign(mae, 'maestro_municipios_covid');
	for i := 1 to CANT_DETALLES do
		assign(vDetalles[i], 'detalle_municipio_' + IntToStr(i));
end;


// Abre los archivos recibidos
procedure abrirDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to CANT_DETALLES do
		reset(v[i]);
end;


// Cierra los archivos recibidos
procedure cerrarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to CANT_DETALLES do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en VALOR_ALTO, sino devuelve el registro que se leyo
procedure leerDetalle (var det: detalle; var info: municipio);
begin
	if (not eof(det)) then
		read(det, info)
	else
		info.cod_localidad := VALOR_ALTO;
end;


// Genera un vector de minimos entre todos los archivos recibidos que estan ordenados por codigo de localidad
procedure generarMinimos(var vDetalles: detalles; var vMin: municipios_minimos);
var
	i: integer;
begin
	for i := 1 to CANT_DETALLES do begin
		reset(vDetalles[i]);
		leerDetalle(vDetalles[i], vMin[i]);
	end;
end;


// Busca el codigo de localidad minimo entre los archivos detalle de un vector recibido y lo devuelve en "min"
procedure minimo(var vDetalles: detalles; var vMin: municipios_minimos; var min: municipio);
var
	i, posMin: integer;
begin
	posMin := 0;
	min.cod_localidad := VALOR_ALTO;
	for i := 1 to CANT_DETALLES do begin
		if (vMin[i].cod_localidad < min.cod_localidad) then begin
			min := vMin[i];
			posMin := i;
		end;
	end;
	if (posMin <> 0) then leerDetalle(vDetalles[posMin], vMin[posMin]);
end;
	

// Actualiza los datos de un registro de un archivo maestro
procedure actualizarDatos(var regMae: info_mae; min: municipio);
begin
	regMae.cont.cant_activos := min.cont.cant_activos;
	regMae.cont.cant_nuevos := min.cont.cant_nuevos;
	regMae.cont.cant_recuperados := regMae.cont.cant_recuperados + min.cont.cant_recuperados;
	regMae.cont.cant_fallecidos := regMae.cont.cant_fallecidos + min.cont.cant_fallecidos;
end;

// Lee un archivo maestro: si es eof setea en VALOR_ALTO, sino devuelve el registro que se leyo
procedure leerMaestro (var mae: maestro; var info: info_mae);
begin
	if (not eof(mae)) then
		read(mae, info)
	else
		info.cod_localidad := VALOR_ALTO;
end;
	
// Actualiza el maestro recibido con los detalles recibidos
procedure actualizarMaestro(var mae: maestro; var vDetalles: detalles);
var
	regMae: info_mae;
	min: municipio;
	vMinimos: municipios_minimos;
begin
	generarMinimos(vDetalles, vMinimos); // Genera un vector de minimos

	reset(mae);
	minimo(vDetalles, vMinimos, min); // Busca el minimo del vector de minimos

	while (min.cod_localidad <> VALOR_ALTO) do begin
		leerMaestro(mae, regMae);

		while ( (regMae.cod_localidad <> VALOR_ALTO) AND (regMae.cod_localidad <> min.cod_localidad) AND (regMae.cod_cepa <> min.cod_cepa) ) do
			leerMaestro(mae, regMae);
		// Sale del while cuando encuentra el registro del maestro con el codigo de localidad y de cepa que busco actualizar, o cuando el codigo de localidad del maestro devuelve VALOR_ALTO

		 // Pregunta por qué salió del while
		if (regMae.cod_localidad <> VALOR_ALTO) then begin
			actualizarDatos(regMae, min);
			seek(mae, filePos(mae)-1);
			write(mae, regMae);
		end;

		minimo(vDetalles, vMinimos, min);

	end;

	close(mae); cerrarDetalles(vDetalles);
end;


// Contabiliza las localidades con más de 50 casos activos
function buscarLocalidades(var mae: maestro) : integer;
var
	cant: integer;
	regMae: info_mae;
begin
	cant := 0; // Inicializa contador
	
	reset(mae);

	leerMaestro(mae, regMae);
	while (regMae.cod_localidad <> VALOR_ALTO) do begin
		if (regMae.cont.cant_activos > 50) then
			cant := cant + 1;
		leerMaestro(mae, regMae);
	end;

	close(mae);

	buscarLocalidades := cant;
end;



// Exporta un archivo binario recibido a un archivo de texto
procedure exportarArchivoATxt(var arch: maestro; var txt: text);
var
	reg: info_mae;
begin
	reset(arch); // Abre el archivo binario
	assign(txt, 'maestro_municipios_covid.txt');
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, reg);
		writeln(txt,'COD LOCALIDAD: ', reg.cod_localidad, ' COD CEPA: ', reg.cod_cepa, ' -  CANT ACTIVOS: ', reg.cont.cant_activos,
					' - CANT NUEVOS: ', reg.cont.cant_nuevos, ' - CANT RECUPERADOS: ', reg.cont.cant_recuperados,
					' - CANT FALLECIDOS: ', reg.cont.cant_fallecidos); // Escribe en el archivo de texto
	end;

	close(arch);	close(txt);
end;

// Exporta los archivos binarios detalles a archivos de texto
procedure exportarDetallesATxt(var v: detalles);
var
	i: integer;
	txt: text;
	reg: municipio;
begin
	for i := 1 to CANT_DETALLES do begin
		assign (txt, 'detalle_municipio_' + IntToStr(i) + '.txt');
		rewrite(txt); reset(v[i]);
		while (not eof(v[i])) do begin
			read(v[i], reg);
			writeln(txt, 'COD LOCALIDAD: ', reg.cod_localidad, ' - COD CEPA: ', reg.cod_cepa, ' -  CANT ACTIVOS: ', reg.cont.cant_activos,
						' - CANT NUEVOS: ', reg.cont.cant_nuevos, ' - CANT RECUPERADOS: ', reg.cont.cant_recuperados,
						' - CANT FALLECIDOS: ', reg.cont.cant_fallecidos); // Escribe en el archivo de texto
		end;
		 close(txt);
	end;
	cerrarDetalles(v);
end;




// ---------------------------------------------------------------------
var
	mae: maestro;
	vDetalles: detalles;
	txt: text;
begin
	asignarArchivos(mae, vDetalles);

	actualizarMaestro(mae, vDetalles);

	exportarArchivoATxt(mae, txt);
	exportarDetallesATxt(vDetalles);

	writeln('Cantidad de localidades superando los 50 casos activos: ', buscarLocalidades(mae));

	writeln('Finalizado');
end.
