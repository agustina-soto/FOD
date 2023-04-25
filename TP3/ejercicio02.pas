{Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program ejercicio02;
uses
	sysutils;
const
	CANT_ASISTENTES = 4;
	NRO_MIN_ASISTENTE = 1000;
type
	asistente = record
		nro_asistente: integer;
		apellido: string;
		nombre: string;
		email: string;
		telefono: string;
		dni: string;
	end;

	asistentes = file of asistente;

// Carga datos por teclado en un archivo de asistentes
procedure cargarDatos(var archivo: asistentes);
var
	i: integer;
	a: asistente;
begin
	rewrite(archivo);
	for i := 1 to CANT_ASISTENTES do begin
		a.nro_asistente := 997+i;
		a.dni := IntToStr(i);
		a.nombre := IntToStr(i+1234) ;
		{
		writeln('Ingrese el nro de asistente');
		readln(a.nro_asistente);
		writeln('Ingrese el dni');
		readln(a.dni);
		writeln('Ingrese el nombre');
		readln(a.nombre);
		writeln('Ingrese el apellido');
		readln(a.apellido);
		writeln('Ingrese el email');
		readln(a.email);
		writeln('Ingrese el telefono');
		readln(a.telefono);
		}
		write(archivo, a);
	end;
	close(archivo);
end;


// Baja logica de todos los asistentes con nro_asistente menor a 1000
procedure bajaLogica(var archivo: asistentes);
var
	a: asistente;
begin
	reset(archivo);
	seek(archivo, 0);
	while (not eof(archivo)) do begin
		read(archivo, a);
		if (a.nro_asistente < NRO_MIN_ASISTENTE) then begin
			a.dni := '***';
			seek(archivo, filePos(archivo)-1);
			write(archivo, a);
			writeln('Se dio de baja un empleado');
		end;
	end;
	close(archivo);
end;


// Carga los datos de un empleado en el archivo de texto traido por parametro
procedure cargarArchivoTxt(var txt: text; a: asistente);
begin
	with a do
		writeln(txt, ' Nro Asistente: ' , nro_asistente , ' | DNI: ' , dni , ' | Nombre: ' , nombre); // Escribe en el archivo de texto
end;


// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoTxt(var archivo: asistentes; nombreTxt: string);
var
	a: asistente;
	txt: text;
begin
	assign(txt, nombreTxt);
	rewrite(txt);
	reset(archivo);
	while (not eof(archivo))do begin
		read(archivo, a);
		cargarArchivoTxt(txt, a);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt); close(archivo);
end;

// ---------------------------------------------------------------------
var
	archivo: asistentes;
begin
	assign(archivo, 'asistentes');
	cargarDatos(archivo);
	exportarArchivoTxt(archivo, 'asistentes_congreso_completo.txt');
	bajaLogica(archivo);
	exportarArchivoTxt(archivo, 'asistentes_congreso_con_bajas.txt');
end.
