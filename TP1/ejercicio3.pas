{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y:
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program ejercicio3;
const
	fin = 'fin';
type
	cadena20 = string[20];

	empleado = record
		nroEmpleado: integer;
		nombre: cadena20;
		apellido: cadena20;
		edad: integer;
		dni: integer;
	end;

	archEmpleados = file of empleado;

// Muestra el menu principal con opciones para el usuario y le solicita el ingreso de la eleccion
procedure mostrarMenuPrincipal(var opcion: char);
begin
	writeln;		writeln;
	writeln('---------- MENU PRINCIPAL ----------');
	writeln('a: Crear un archivo de empleados');
	writeln('b: Abrir el archivo creado anteriormente');
	writeln('c: Salir del menu');
	writeln('Ingrese una opcion');
	readln(opcion);
end;

// Muestra el menu de listado con opciones para el usuario
procedure mostrarMenuDeListado();
begin
	writeln; 	writeln;
	writeln('---------- MENU PARA LISTAR ----------');
	writeln('1: Listar en pantalla los datos de empleados que tengan un nombre determinado');
	writeln('2: Listar en pantalla los datos de empleados que tengan un apellido determinado');
	writeln('3: Listar en pantalla los empleados de a uno por linea');
	writeln('4: Listar en pantalla empleados mayores de 70, proximos a jubilarse');
end;

// Carga empleados en un archivo de empleados
procedure cargarDatos(var archivo: archEmpleados);
	procedure leerEmpleado(var e: empleado);
	begin
		with e do begin
			writeln('Ingrese el apellido del empleado o "fin" si quiere terminar');
			readln(apellido);
			if (apellido <> fin) then begin
				writeln('Ingrese el nombre del empleado');
				readln(nombre);
				writeln('Ingrese el numero de empleado');
				readln(nroEmpleado);
				writeln('Ingrese la edad del empleado');
				readln(edad);
				writeln('Ingrese el DNI del empleado');
				readln(dni);
			end;
		end;
	end;
var
	e: empleado;
begin
	leerEmpleado(e);
	while (e.apellido <> fin) do begin
		write(archivo, e);
		leerEmpleado(e);
	end;
end;

// Crea un archivo de empleados, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var archivo: archEmpleados; var nombre_fisico: cadena20; var existe: boolean);
begin
	writeln('Usted eligio la opcion "crear un archivo"');
	existe := true;
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
	rewrite(archivo);
	cargarDatos(archivo);
	close(archivo);
end;

// Lista los datos de los empleados
procedure listarDatosEmpleado(e: empleado);
begin
	writeln;
	with e do begin
		write('-> NOMBRE: ', nombre, ' | ');
		write('APELLIDO: ', apellido, ' | ');
		write('NRO DE EMPLEADO: ', nroEmpleado, ' | ');
		write('EDAD: ', edad, ' | ');
		write('DNI: ', dni, ' | ');
	end;
end;

// Lista datos de los empleados que tengan un nombre determinado ingresado por el usuario
procedure listarSegunNombre(var archivo: archEmpleados);
var
	e: empleado;
	nombreABuscar: cadena20;
begin
	writeln('Ingrese el nombre a buscar');
	readln(nombreABuscar);
	writeln('EMPLEADOS CON EL NOMBRE INGRESADO: ');
	while not eof(archivo) do begin
		read(archivo, e);
		if (e.nombre = nombreABuscar) then
			listarDatosEmpleado(e);
	end;
end;

// Lista datos de los empleados que tengan un apellido determinado ingresado por el usuario
procedure listarSegunApellido(var archivo: archEmpleados);
var
	e: empleado;
	apellidoABuscar: cadena20;
begin
	writeln('Ingrese el apellido a buscar');
	readln(apellidoABuscar);
	writeln('EMPLEADOS CON EL APELLIDO INGRESADO: ');
	while not eof(archivo) do begin
		read(archivo, e);
		if (e.apellido = apellidoABuscar) then
			listarDatosEmpleado(e);
	end;
	writeln;
end;

// Lista datos de los empleados de un archivo
procedure listarEmpleados(var archivo: archEmpleados);
var
	e: empleado;
begin
	writeln('EMPLEADOS REGISTRADOS EN EL ARCHIVO: ');
	while not eof(archivo) do begin
		read(archivo, e);
		writeln;
		listarDatosEmpleado(e);
	end;
end;

// Lista datos de los empleados mayores de 70 años, próximos a jubilarse
procedure listarProximosAJubilarse(var archivo: archEmpleados);
const
	edadLimite = 70;
var
	e: empleado;
begin
	writeln('EMPLEADOS PROXIMOS A JUBILARSE: ');
	while not eof(archivo) do begin
		read(archivo, e);
		if (e.edad > edadLimite) then
			listarDatosEmpleado(e);
	end;
end;

// Abre el archivo creado anteriormente (si lo hay), muestra un menu con las operaciones disponibles y ejecuta las instrucciones correspondientes
procedure abrirArchivoCreado(var archivo: archEmpleados; nombre_fisico: cadena20; existeArchivo: boolean);
var
	opcion: char;
	nombre_arch: cadena20;
begin
	writeln('Usted eligio la opcion "abrir archivo creado anteriormente"');
	if (existeArchivo) then begin
		writeln('Ingrese el nombre del archivo que quiere abrir');
		readln(nombre_arch);
		if (nombre_arch = nombre_fisico) then begin
			writeln('Se acaba de abrir el archivo ', nombre_arch);
			reset(archivo);
			mostrarMenuDeListado;
			writeln('Ingrese una opcion');
			readln(opcion);
			case (opcion) of
				'1': listarSegunNombre(archivo);
				'2': listarSegunApellido(archivo);
				'3': listarEmpleados(archivo);
				'4': listarProximosAJubilarse(archivo);
			end;
			close(archivo);
			writeln('Se acaba de cerrar el archivo ', nombre_arch);
		end
		else
			writeln('El archivo ingresado no es el que acaba de crear');
	end
	else begin
		writeln;
		writeln('No existen archivos de empleados. Para listar informacion de empleados debe crear un archivo y cargar los datos en el mismo');
		writeln;
	end;
end;


// ---------------------------------------------------------------------
var
	opcion: char;
	arch_log: archEmpleados;
	nombre_fisico: cadena20;
	existeUnArchivo: boolean;
begin
	existeUnArchivo := false;
	mostrarMenuPrincipal(opcion);
	while (opcion <> 'c') do begin
		case (opcion) of
			'a': crearArchivo(arch_log, nombre_fisico, existeUnArchivo);
			'b': abrirArchivoCreado(arch_log, nombre_fisico, existeUnArchivo);
		end;
		mostrarMenuPrincipal(opcion);
	end;
	writeln('Usted eligio la opcion "salir del menu"');
end.
