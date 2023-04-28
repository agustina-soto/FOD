program crear_maestro_y_detalle;
uses
	sysutils;
const
	DIMF = 20;
type
	cadena50 = string[50];
	cadena100 = string[100];

	info_mae = record
		cod: integer;
		descripcion: cadena50;
		colores: cadena100;
		tipo_prenda: cadena50;
		stock: integer;
		precio_unitario: real;
	end;

	maestro = file of info_mae; // No esta ordenado

	info_det = record
		cod: integer;
	end;

	detalle = file of info_det;

	codigosAsignados = array[0..DIMF] of boolean;



// Inicializar la lista de códigos asignados como falsa
procedure inicializarCodigosOcupados(var v: codigosAsignados); 
var
	i: integer;
begin
	for i := 0 to DIMF do
		v[i] := false;
end;


// Carga un archivo maestro con datos aleatorios no ordenados
procedure cargarMaestro(var mae: maestro; var v: codigosAsignados);
var
	i: integer;
	reg: info_mae;
begin
	randomize; // Inicializar el generador de números aleatorios

	// Generar y escribir registros aleatorios en el archivo maestro
	for i := 1 to 8 do begin
		repeat
			reg.cod := random(20)+1; // Generar un número aleatorio UNICO entre 1 y 20 para el código
		until not v[reg.cod];
	
		// Marcar el código como asignado
		v[reg.cod] := true;
		reg.descripcion := 'Prenda ' + IntToStr(i); // Descripción aleatoria
		reg.colores := 'Rojo, Azul, Verde'; // Colores aleatorios
		reg.tipo_prenda := 'Tipo ' + IntToStr(random(15)+1); // Tipo aleatorio entre 1 y 15
		reg.stock := random(130); // Stock aleatorio entre 0 y 99
		reg.precio_unitario := random(10000) / 10; // Precio aleatorio entre 0 y 99.9

		write(mae, reg); // Escribir el registro en el archivo maestro
	end;
end;


// Carga un archivo detalle a partir de los codigos asignados por el maestro
procedure cargarDetalle(var det: detalle; v: codigosAsignados);
var
	pos, cant: integer;
	reg: info_det;
begin
	pos := 1; cant := 0;
	while ( (pos < DIMF) AND (cant < 4) ) do begin // cant < 4 porque quiero hasta 4 actualizaciones para el maestro
		if (v[pos]) then begin // Si el codigo esta ocupado (osea que el maestro lo asignó)
			reg.cod := pos;
			write(det, reg);
			cant := cant + 1;
		end;
		pos := pos + 1;
	end;
end;

// ---------------------------------------------------------------------
var
	mae: maestro;
	det: detalle;
	v: codigosAsignados;
begin
	inicializarCodigosOcupados(v);

	assign(mae, 'archivo_maestro');
	rewrite(mae);
	cargarMaestro(mae, v);
	close(mae);
	writeln('Maestro creado');

	assign(det, 'archivo_detalle');
	rewrite(det);
	cargarDetalle(det, v);
	close(det);
	writeln('Detalle creado');
end.
