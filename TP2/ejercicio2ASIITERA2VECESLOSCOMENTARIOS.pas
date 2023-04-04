{1. Se dispone de un archivo con información de los alumnos de la Facultad de Informática.

	Por cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
	(cursadas) aprobadas sin final y cantidad de materias con final aprobado.

	Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
	(esta información indica si aprobó la cursada o aprobó el final).

	Todos los archivos están ordenados por código de alumno y en el archivo detalle puede haber 0, 1 ó más 
	registros por cada alumno del archivo maestro.

	Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
	i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
	ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez. }

program ejercicio2;
const
	valorAlto = -1;
type
	cadena60 = string[60];
	rango = 0..1;

	alumno = record
		cod: integer;
		nomYape: cadena60;
		cantCursadasAprobadas: integer;
		cantFinalesAprobados: integer;
	end;

	alumnoDet = record
		cod: integer;
		aproboFinal: rango; // 0 = final aprobado ; 1 = cursada aprobada
	end;

	// Odenados por código de alumno
	maestro = file of alumno;
	detalle = file of alumnoDet; // Puede haber 0, 1 ó más registros por cada alumno del archivo maestro

// Crea y carga un archvo binario maestro a partir de un archivo de texto
procedure crearArchivoMaestro(var mae: maestro);
var
	a: alumno;
	txt: text;
begin
	assign(txt, 'alumnos_maestro.txt');
	reset(txt); // Abre el archivo de texto

	assign(mae, 'archivo_maestro_alumnos');
	rewrite (mae);

	while (not eof(txt)) do begin
		with a do begin
			readln(txt, cod, cantCursadasAprobadas, cantFinalesAprobados);
			readln(txt, nomYape);
			write(mae, a); // Escribe en el archivo binario
		end;
	end;

	close(txt);	close(mae);
end;


// Crea y carga un archvo binario detalle a partir de un archivo de texto
procedure crearArchivoDetalle(var det: detalle);
var
	a_det: alumnoDet;
	txt: text;
begin
	writeln('entro a crear archivo detalle');
	
	assign(txt, 'alumnos_detalle.txt');
	reset(txt);

	assign(det, 'archivo_detalle_alumnos');
	rewrite(det);

	while (not eof(txt)) do begin
		with a_det do begin
			readln(txt, cod, aproboFinal);
			write(det, a_det);
		end;
	end;

	close(txt);	close (det);
end;


procedure leer(var det: detalle; var a_det: alumnoDet);
begin
	if (not eof(det)) then
		read(det, a_det)
	else
		a_det.cod := valorAlto;
end;

// Actualiza los datos de un registro de un archivo maestro
procedure actualizarDatos(var a: alumno; finalAprobado: integer);
begin
	if (finalAprobado = 0) then
		a.cantFinalesAprobados := a.cantFinalesAprobados + 1
	else
		a.cantCursadasAprobadas := a.cantCursadasAprobadas + 1;
end;


// Actualiza el archivo maestro a partir del archivo detalle
procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
	a: alumno;
	a_det: alumnoDet;
begin
	writeln('entro a actualizar maestro');
	
	reset(mae); reset(det);

	leer(det, a_det); // Lee un registro del archivo detalle
	while(a_det.cod <> valorAlto) do begin
		read(mae, a); // Lee un registro del archivo maestro

		while (a.cod <> a_det.cod) do begin
			if (not eof(mae)) then // me tiraba runtime error 100 hasta que le agregue esto... por que?????????????
				read(mae, a); // Mientras no encuentre al alumno a.cod se lo sigue buscando en el maestro (por definicion existe en él, no va a llegar a eof)
		end;

		writeln('salio del while que busca el maestro');

		while (a.cod = a_det.cod) do begin // Se queda en el cod del maestro hasta que no se encuentre mas ese mismo codigo en el detalle
			actualizarDatos(a, a_det.aproboFinal);
			leer(det, a_det);
		end;

		writeln('salio del while que busca todos los alumnos detalle con un codigo especifico');

		seek (mae, filepos(mae)-1 ); // Reubica el puntero: cuando se buscaba el cod del maestro el puntero quedo avanzado
		
		writeln('hizo el seek');

		write(mae, a); // Escribe la actualizacion en el archivo maestro
		
		writeln('saliendo del while porque cambio el codigo detalle');

		if (eof(mae)) then
			writeln('maestro en eof');
		if (eof(det)) then
			writeln('detalleen eof');
		if (a_det.cod = valorAlto) then
			writeln('codigo de detalle = valor alto');
	end;

	writeln('salio del while porque cod = valor alto');

	close(mae); close(det);
	
	writeln('salio de actualizar maestro');
end;


// Lista los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final
Procedure listarAlumnos(var mae: maestro);
var
	txt: text;
	a: alumno;
begin
	writeln('entro a listar alumnos');

	assign(txt,'alumnos_con_mas_de_4_cursadas.txt');
	rewrite(txt);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae, a);
		if (a.cantCursadasAprobadas > 4) then
			writeln(txt,'Codigo de alumno: ',a.cod,' - Nombre y apellido: ',a.nomYape,' - Cantidad de cursadas aprobadas: ',a.cantCursadasAprobadas,' - Cantidad de finales aprobados: ',a.cantFinalesAprobados);
	end;
	close(txt); close(mae);
end;



// ---------------------------------------------------------------------
var
	mae: maestro;
	det: detalle;
begin

	crearArchivoMaestro(mae);
	crearArchivoDetalle(det);
	actualizarMaestro(mae, det);
	listarAlumnos(mae);
end.
