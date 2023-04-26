program ejercicio3;
const
	VALOR_ALTO = -1;
type
	cadena40 = string[40];
	cadena20 = string[20];

	novela = record
		cod: integer;
		genero: cadena20;
		nombre: cadena40;
		duracion: integer;
		director: cadena20;
		precio: real;
	end;

	novelas = file of novela;


// Lee por teclado los datos de una novela
procedure leerNovela(var n: novela);
begin
	with n do begin
		writeln('Ingrese el codigo de la novela o "-1" si quiere terminar');
		readln(cod);
		if (cod <> VALOR_ALTO) then begin
			writeln('Ingrese el genero');
			readln(genero);
		{
			writeln('Ingrese el nombre');
			readln(nombre);
			writeln('Ingrese la duracion');
			readln(duracion);
			writeln('Ingrese el director');
			readln(director);
			writeln('Ingrese el precio');
			readln(precio);
		}
		end;
	end;
end;

// Carga los datos de un archivo de novelas
procedure cargarDatos(var archivo: novelas);
var
	n: novela;
begin
	n.cod := 0; n.genero := ''; n.nombre := ''; n.duracion := 0; n.director := ''; n.precio := 0; // Cabecera del archivo
	while (n.cod <> VALOR_ALTO) do begin
		write(archivo, n);
		leerNovela(n);
	end;
	writeln('Se creo un archivo de novelas');
end;

// Crea un archivo, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var archivo: novelas; var nombre_fisico: cadena20; var existe: boolean);
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

// Lee un archivo: si es eof setea en VALOR_ALTO, sino devuelve el registro que se leyo
procedure leer (var archivo: novelas; var info: novela);
begin
	if (not eof(archivo)) then
		read(archivo, info)
	else
		info.cod := VALOR_ALTO;
end;

// Recibe un archivo y un numero de novela y devuelve si existe en el archivo
procedure existeNovela(var archivo: novelas; var n: novela; var existe: boolean); // "n" llega con el cod de novela a buscar, cuando existe = true en "e" queda la info del registro
var
	num: integer;
begin
    num := e.cod; existe := false;
    seek(archivo, 0);
	while ( (not existe) AND (not eof(archivo)) ) do begin
		read(archivo, n);
		if (e.cod = num) then
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
procedure listarEmpleados(var archivo: novelas);
var
	e: empleado;
begin
	writeln('EMPLEADOS REGISTRADOS EN EL ARCHIVO: ');
	while (not eof(archivo))do begin
		read(archivo, e);
		writeln;
		listarDatosEmpleado(e);
	end;
end;


// Muestra en pantalla el menu de modificaciones que se le puede hacer a la informacion de una novela
procedure mostrarMenuModificaciones(var opcion: integer);
begin
	writeln('---- MENU: MODIFICACIONES DATOS NOVELA ---- ');
	writeln('1: Modificar genero');
	writeln('2: Modificar nombre');
	writeln('3: Modificar duracion');
	writeln('4: Modificar director');
	writeln('5: Modificar precio');
	writeln('0: salir del menu');
	writeln('Ingrese una opcion');
	readln(opcion);
end;


// Modifica la informacion de una novela recibida
procedure modificarCampos(var n: novela);
var
	opcion: integer;
begin
	mostrarMenuModificaciones(opcion);
	while (opcion <> 0) do begin
		case (opcion) of
			1: 	writeln('Ingrese el genero actualizado');
				readln(auxStr);
				n.genero := auxStr;
			2:	writeln('Ingrese el nombre actualizado');
				readln(auxStr);
				n.nombre := auxStr;
			3:	writeln('Ingrese la duracion actualizada');
				readln(auxInt);
				n.duracion := auxInt;
			4:	writeln('Ingrese el director actualizado');
				readln(auxStr);
				n.director := auxStr;
			5: 	writeln('Ingrese el precio actualizado');
				readln(auxReal);
				n.precio := auxReal;
		end;
		mostrarMenuModificaciones(opcion);
	end;
end;


//Modifica la edad de un empleado
procedure modificarDatos(var archivo: novelas);
var
	edad: integer;
	n: novela;
	existe: boolean;
begin
	writeln('Ingrese el codigo de novela de la cual quiere modificar los datos');
	readln(n.cod);

	existeNovela(archivo, n, existe);

	if (existe) then begin // Si existe, en "n" queda cargado el registro buscado y el puntero se quedo apuntando al elemento siguiente del mismo
		modificarCampos(n);
        seek(archivo, filePos(arch)-1); // Se posiciona en la posicion del registro a modificar
        write(archivo, n); // Modifica el elemento el archivo
		writeln('Se actualizo la informacion de la novela indicada');
	end
	else
		writeln('No se pudo actualizar la informacion. El codigo de novela ingresado no existe');
end;

// Agrega una novela al archivo (si esa novela no existe)
procedure agregarNovela(var archivo: novelas);
var
	n, nuevaN: novela;
	existe: boolean;
begin
	writeln('Usted eligio la opcion "Dar de alta una novela"');
	leerNovela(n);
	nuevaN := n;
	existeNovela(archivo, n, existe);
	if (existe) then
        writeln('No se pudo agregar la novela. El codigo de novela ya esta registrado')
    else begin
		// seek(arch, filePos(arch)); --> No se hace el seek porque por la busqueda el archivo quedo posicionado al final del archivo (no en el ultimo elem sino despues)
		write(archivo, nuevaN);
		writeln('Se ha agregado una novela');
	end
end;


procedure alta(var name:archivo);
var
    cabeceraLista,novela:infoArchivo;
begin
    leerNovela(novela);
    if (not existeNovela(name,novela.codigo)) then begin
        reset(name);
        read(name,cabeceraLista);
        if (cabeceraLista.codigo=0) then begin // si el primer registro es 0, es porque no hay espacio libre y agrego al final
            seek(name,filesize(name));
            write(name,novela);        
        end
        else begin
            seek(name,(cabeceraLista.codigo*-1)); // me posiciono en el espacio libre de la lista. Por ejemplo, si el codigo de la cabecera es -4: -4*-1:4 -> me posiciono en el 4
            read(name,cabeceraLista); //leo lo que habia en el espacio libre: indice hacia la siguiente posicion libre
            seek(name,filepos(name)-1); //vuelvo al espacio libre
            write(name,novela); // escribo en el espacio libre la novela
            seek(name,0); //voy al principio
            write(name,cabeceraLista);//guardo el indice a la siguiente posicion libre en la cabecera de la lista
        end;
        writeln('Novela dada de alta.');
        close(name);
    end
    else begin
        writeln('Ya existe una novela con ese codigo.');
    end;
end;





// Carga los datos de un empleado en el archivo de texto traido por parametro
procedure cargarArchivoTxt(var txt: text; emp: empleado);
begin
	with emp do
		writeln(txt, ' Nro Empleado: ' , nroEmpleado , ' | Apellido: ' , apellido , ' | Nombre: ' , nombre , ' | DNI: ' , dni , ' | Edad: ' , edad); // Escribe en el archivo de texto
end;

// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoTxt(var archivo: novelas);
var
	emp: empleado;
	txt: text;
begin
	assign(txt, 'todos_empleados.txt');
	rewrite(txt); // Crea el archivo de texto “todos_empleados.txt”
	while (not eof(archivo))do begin
		read(archivo, emp); // Lee un elemento del archivo binario
		cargarArchivoTxt(txt, emp);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt);
end;


// Es maso lo mismo que el proceso existeNovela, tendria q haber adaptado el codigo viejo para usar esta funcion pero me dio paja :)
function existe(var archivo: novelas; cod: integer) : boolean
var
	found: boolean;
	n: novela;
begin
	found := false;
	while (not eof(archivo)) AND (not found) do begin
		read(archivo, n);
		if (n.cod = cod) then found := true;
	end;
	existe := found;
end;


// Elimina un registro del archivo
procedure eliminarNovela(var archivo: novelas);
var
	n, cabecera: novela;
	codAEliminar: integer;
	found: boolean;
begin
	writeln('Ingrese el codigo de novela que quiere eliminar');
	readln(codAEliminar);
	found := false;
	
	read(archivo, cabecera); // Guarda la cabecera
    while (not eof(archivo)) AND (not found) do begin
        read(archivo, n);
        if (n.cod = codAEliminar) then found := true;
    end;

	if (found) then begin // Si encontró el codigo de novela
		seek (archivo, filePos(archivo)-1 ); // Se posiciona en el archivo a eliminar
        write(archivo, cabecera); // Escribe en la posicion a borrar la informacion que tenia la cabecera
        cabecera.cod := (filePos(archivo)-1 ) * -1; // Convierte el indice de la posicion a negativo
        seek(name, 0); // Se posiciona en la cabecera
        write(archivo, cabecera); // Reemplaza el registro cabecera con el del registro que se acaba de eliminar
        writeln('Se elimino la novela ingresada');
    end
    else
        writeln('No se encontro una novela con ese codigo.');
end;


// Muestra el menu principal con opciones para el usuario y le solicita el ingreso de la eleccion
procedure mostrarMenuPrincipal(var opcion: char);
begin
	writeln;
	writeln('---------- MENU PRINCIPAL ----------');
	writeln('a: Crear un archivo de novelas');
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
	writeln('1: Dar de alta una novela');
	writeln('2: Modificar los datos de una novela');
	writeln('3: Eliminar una novela');
	writeln('4: Listar en un archivo de texto todas las novelas');
	writeln('Ingrese una opcion');
	readln(opcion);
end;

// Ejecuta la opcion elegida por el usuario
procedure operacionesDelArchivo(var archivo: novelas);
var
	opcion: char;
begin
	mostrarMenuDeOperaciones(opcion);
	case (opcion) of
		'1': agregarNovela(archivo);
		'2': modificarDatos(archivo);
		'3': eliminarNovela(archivo);
		'4': listar....(archivo); // COMPLETAR ESTA LINEA CON LO QUE COREEPSONDAAAAA!!!!
	end;
end;

// Abre el archivo creado anteriormente (si lo hay), muestra un menu con las operaciones disponibles y ejecuta las instrucciones correspondientes
procedure abrirArchivoCreado(var archivo: novelas; nombre_fisico: cadena20; existeArchivo: boolean);
var
	opcion: char;
	nombre_arch: cadena20;
begin
	writeln('Eligio la opcion "abrir archivo creado anteriormente"');
	if (existeArchivo) then begin
		reset(archivo);
		operacionesDelArchivo(archivo);
		writeln;
		writeln('¿QUIERE CERRAR EL ARCHIVO?'); writeln('S: Si'); writeln('N: No');
		readln(opcion);
		while ( (opcion <> 'S') and (opcion <> 's') ) do begin
			operacionesDelArchivo(archivo);
			seek(archivo, filePos(archivo) - fileSize(archivo));
			writeln;
			writeln('¿QUIERE VOLVER AL MENU PRINCIPAL?'); writeln('S: Si'); writeln('N: No');
			readln(opcion);
		end;
		close(archivo);
	end
	else begin
		// writeln; // CHEQUEAR SI ACA FUNCIONA EL #10!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		writeln(#10, 'Aun no se creo un archivo de novelas.');
		writeln;
	end;
end;


// ---------------------------------------------------------------------
var
	opcion: char;
	arch_log: novelas;
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
