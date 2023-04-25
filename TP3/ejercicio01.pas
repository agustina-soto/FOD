program ejercicio01;
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


// Lee por teclado los datos de un empleado
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

// Carga empleados en un archivo de empleados
procedure cargarDatos(var arch: archEmpleados);
var
	e: empleado;
begin
	leerEmpleado(e);
	while (e.apellido <> fin) do begin
		write(arch, e);
		leerEmpleado(e);
	end;
end;

// Crea un archivo de empleados, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var arch: archEmpleados; var nombre_fisico: cadena20; var existe: boolean);
begin
	writeln('Usted eligio la opcion "crear un archivo"');
	existe := true;
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	assign(arch, nombre_fisico);
	rewrite(arch);
	cargarDatos(arch);
	close(arch);
end;

// Recibe un archivo y un numero de empleado y devuelve si ese empleado existe en el archivo
procedure existeEmpleado(var arch: archEmpleados; var e: empleado; var existe: boolean); // "e" llega con el nro de empleado a buscar, cuando existe = true en "e" queda la info del empleado
var
	num: integer;
begin
    num := e.nroEmpleado; existe := false;
    seek(arch, 0); // Se posiciona al principio del archivo para la busqueda --> ES LEGAL ESTO???????????????????? POR SI ES EOF PREGUNTO.....
	while ( (not existe) AND (not eof(arch)) ) do begin
		read(arch, e);
		if (e.nroEmpleado = num) then
			existe := true;
	end;
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
		writeln;
	end;
end;

// Lista datos de los empleados de un archivo
procedure listarEmpleados(var arch: archEmpleados);
var
	e: empleado;
begin
	writeln('EMPLEADOS REGISTRADOS EN EL ARCHIVO: ');
	while (not eof(arch))do begin
		read(arch, e);
		writeln;
		listarDatosEmpleado(e);
	end;
end;

// Lista datos de los empleados que tengan un nombre determinado ingresado por el usuario
procedure listarSegunNombre(var arch: archEmpleados);
var
	e: empleado;
	nombreABuscar: cadena20;
begin
	writeln('Ingrese el nombre a buscar');
	readln(nombreABuscar);
	writeln('EMPLEADOS CON EL NOMBRE INGRESADO: ');
	while (not eof(arch))do begin
		read(arch, e);
		if (e.nombre = nombreABuscar) then
			listarDatosEmpleado(e);
	end;
end;

// Lista datos de los empleados que tengan un apellido determinado ingresado por el usuario
procedure listarSegunApellido(var arch: archEmpleados);
var
	e: empleado;
	apellidoABuscar: cadena20;
begin
	writeln('Ingrese el apellido a buscar');
	readln(apellidoABuscar);
	writeln('EMPLEADOS CON EL APELLIDO INGRESADO: ');
	while (not eof(arch))do begin
		read(arch, e);
		if (e.apellido = apellidoABuscar) then
			listarDatosEmpleado(e);
	end;
	writeln;
end;

// Lista datos de los empleados mayores de 70 años, próximos a jubilarse
procedure listarProximosAJubilarse(var arch: archEmpleados);
const
	edadLimite = 70;
var
	e: empleado;
begin
	writeln('EMPLEADOS PROXIMOS A JUBILARSE: ');
	while (not eof(arch))do begin
		read(arch, e);
		if (e.edad > edadLimite) then
			listarDatosEmpleado(e);
	end;
end;

//Modifica la edad de un empleado
procedure modificarEdad(var arch: archEmpleados);
var
	edad: integer;
	e: empleado;
	existe: boolean;
begin

	writeln('Ingrese el nro de empleado del cual quiere modificar la edad');
	readln(e.nroEmpleado);

	existeEmpleado(arch, e, existe);

	if (existe) then begin // Si el empleado existe, en "e" queda cargado el empleado buscado y el puntero se quedo apuntando al elemento siguiente del mismo
		writeln('Ingrese la edad que quiere asignar');
		readln(edad);
		e.edad := edad; // Modifica el contenido del registro
        seek(arch, filePos(arch)-1); // Se posiciona en la posicion del empleado a modificar
        write(arch, e); // Modifica el elemento el archivo
		writeln('Se modifico la edad del empleado');
	end
	else
		writeln('No se pudo modificar la edad. El nro de empleado ingresado no existe');
end;

// Agrega un empleado al archivo (si no existe)
procedure agregarEmpleado(var arch: archEmpleados);
var
	e, nuevoEmp: empleado;
	existe: boolean;
begin
	writeln('Usted eligio la opcion "Agregar empleado"');
	leerEmpleado(e);
	nuevoEmp := e; // Como hago para no necesitar las dos variables leyendo el empleado una sola vez? :(
	existeEmpleado(arch, e, existe);
	if (existe) then
        writeln('No se pudo agregar el empleado. El numero de empleado ya esta registrado')
    else begin
		// seek(arch, filePos(arch)); --> No se hace el seek porque por la busqueda el archivo quedo posicionado al final del archivo (no en el ultimo elem sino despues)
		write(arch, nuevoEmp);
		writeln('Se ha agregado un empleado');
	end
end;

// Carga los datos de un empleado en el archivo de texto traido por parametro
procedure cargarArchivoTxt(var txt: text; emp: empleado);
begin
	with emp do
		writeln(txt, ' Nro Empleado: ' , nroEmpleado , ' | Apellido: ' , apellido , ' | Nombre: ' , nombre , ' | DNI: ' , dni , ' | Edad: ' , edad); // Escribe en el archivo de texto
end;

// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoTxt(var arch: archEmpleados);
var
	emp: empleado;
	txt: text;
begin
	assign(txt, 'todos_empleados.txt');
	rewrite(txt); // Crea el archivo de texto “todos_empleados.txt”
	while (not eof(arch))do begin
		read(arch, emp); // Lee un elemento del archivo binario
		cargarArchivoTxt(txt, emp);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt);
end;

// Crea un archivo de texto a partir de un archivo binario con los empleados sin DNI
procedure exportarArchivoTxtSinDNI(var arch: archEmpleados);
var
	emp: empleado;
	txt: text;
begin
	assign(txt, 'faltaDNIEmpleado.txt');
	rewrite(txt); // Crea el archivo de texto “faltaDNIEmpleado.txt”
	while (not eof(arch))do begin
		read(arch, emp); // Lee un elemento del archivo binario
		if (emp.dni = 00) then
			cargarArchivoTxt(txt, emp);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt);
end;


// Elimina un empleado del archivo
procedure eliminarEmpleado(var arch: archEmpleados);
var
	e, ultEmpleado: empleado;
	existe: boolean;
	pos: integer;
begin
	writeln('Ingrese el nro de empleado que quiere eliminar');
	readln(e.nroEmpleado);
	existeEmpleado(arch, e, existe);
	if (existe) then begin
		pos := filePos(arch)-1; // Guarda la posicion sobre la que hay que eliminar

		seek(arch, fileSize(arch)-1); // Se posiciona al final del archivo
		read(arch, ultEmpleado); // Guarda el ultimo empleado
		seek(arch, filePos(arch)-1); // Se posiciona en el ultimo empleado para marcarlo como eof
		truncate(arch);

		seek(arch, pos); // Se poiciona en el registro que hay que eliminar
		if (fileSize(arch) > 0) then write(arch, ultEmpleado); // Sobreescribe el registro a eliminar
		
		writeln('Se elimino un empleado');
	end
	else writeln('El nro de empleado ingresado no existe');
end;


// Muestra el menu principal con opciones para el usuario y le solicita el ingreso de la eleccion
procedure mostrarMenuPrincipal(var opcion: char);
begin
	writeln;
	writeln('---------- MENU PRINCIPAL ----------');
	writeln('a: Crear un archivo de empleados');
	writeln('b: Abrir el archivo creado anteriormente');
	writeln('s: Salir del menu');
	writeln('Ingrese una opcion');
	readln(opcion);
end;

// Muestra el menu de operaciones con opciones para el usuario y le solicita el ingreso de la eleccion
procedure mostrarMenuDeOperaciones(var opcion: char);
begin
	writeln; 	writeln;
	writeln('---------- MENU OPERACIONES ----------');
	writeln('1: Agregar un empleado');
	writeln('2: Listar en pantalla los datos de empleados que tengan un nombre determinado');
	writeln('3: Listar en pantalla los datos de empleados que tengan un apellido determinado');
	writeln('4: Listar en pantalla los empleados de a uno por linea');
	writeln('5: Listar en pantalla empleados mayores de 70, proximos a jubilarse');
	writeln('6: Modificar la edad de un empleado');
	writeln('7: Exportar el contenido del archivo a un archivo de texto todos_empleados.txt.');
	writeln('8: Exportar a un archivo de texto faltaDNIEmpleado.txt los empleados que no tengan cargado el DNI (DNI en 00)');
	writeln('9: Eliminar un empleado');
	writeln('Ingrese una opcion');
	readln(opcion);
end;

// Ejecuta la opcion elegida por el usuario
procedure operacionesDelArchivo(var arch: archEmpleados);
var
	opcion: char;
begin
	mostrarMenuDeOperaciones(opcion);
	case (opcion) of
		'1': agregarEmpleado(arch);
		'2': listarSegunNombre(arch);
		'3': listarSegunApellido(arch);
		'4': listarEmpleados(arch);
		'5': listarProximosAJubilarse(arch);
		'6': modificarEdad(arch);
		'7': exportarArchivoTxt(arch);
		'8': exportarArchivoTxtSinDNI(arch);
		'9': eliminarEmpleado(arch);
	end;
end;

// Abre el archivo creado anteriormente (si lo hay), muestra un menu con las operaciones disponibles y ejecuta las instrucciones correspondientes
procedure abrirArchivoCreado(var arch: archEmpleados; nombre_fisico: cadena20; existeArchivo: boolean);
var
	opcion: char;
	nombre_arch: cadena20;
begin
	writeln('Eligio la opcion "abrir archivo creado anteriormente"');
	if (existeArchivo) then begin
		writeln('Ingrese el nombre del archivo que quiere abrir');
		readln(nombre_arch);
		if (nombre_arch = nombre_fisico) then begin
			reset(arch);
			writeln('Se acaba de abrir el archivo ', nombre_arch);
			operacionesDelArchivo(arch);
			writeln;
			writeln('¿QUIERE CERRAR EL ARCHIVO?'); writeln('S: Si'); writeln('N: No');
			readln(opcion);
			while ( (opcion <> 'S') and (opcion <> 's') ) do begin
				operacionesDelArchivo(arch);
				seek(arch, filePos(arch) - fileSize(arch)); // vuelve al inicio del archivo )? chequeado, lo hace
				writeln;
				writeln('¿QUIERE VOLVER AL MENU PRINCIPAL?'); writeln('S: Si'); writeln('N: No');
				readln(opcion);
			end;
			close(arch);
			writeln('Se acaba de cerrar el archivo ', nombre_arch);
		end
		else
			writeln('El archivo ingresado no es el que acaba de crear');
	end
	else begin
		writeln;
		writeln('Aun no se creo un archivo de empleados.');
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
	while (opcion <> 's') do begin
		case (opcion) of
			'a': crearArchivo(arch_log, nombre_fisico, existeUnArchivo);
			'b': abrirArchivoCreado(arch_log, nombre_fisico, existeUnArchivo);
		end;
		mostrarMenuPrincipal(opcion);
	end;
	writeln('Eligio la opcion "salir del menu"');
end.
