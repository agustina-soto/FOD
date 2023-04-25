{Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program ejercicio02;
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
	for i := 1 to CANT_ASISTENTES do begin
		writeln('Ingrese el nro de asistente');
		readln(a.nro_asistente);
		writeln('Ingrese el dni');
		readln(a.dni);
		writeln('Ingrese el nombre');
		readln(a.nombre);
		{
		writeln('Ingrese el apellido');
		readln(a.apellido);
		writeln('Ingrese el email');
		readln(a.email);
		writeln('Ingrese el telefono');
		readln(a.telefono);
		}
		write(archivo, a);
	end;
end;


// Baja logica de todos los asistentes con nro_asistente menor a 1000
procedure bajaLogica(var archivo: asistentes);
var
	a: asistente;
begin
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
end;


// ---------------------------------------------------------------------
var
	archivo: asistentes;
begin
	assign(archivo, 'asistentes');
	rewrite(archivo);
	cargarDatos(archivo);
	bajaLogica(archivo);
	close(archivo);
end.
