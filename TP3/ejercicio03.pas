program ejercicio3;
const
	VALOR_ALTO = -1;
type
	cadena20 = string[20];

	novela = record
		cod: integer;
		genero: cadena20;
		nombre: cadena20;
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
	n.cod := 0; n.genero := '...'; n.nombre := '...'; n.duracion := 0; n.director := '...'; n.precio := 0; // Cabecera del archivo
	while (n.cod <> VALOR_ALTO) do begin
		write(archivo, n);
		leerNovela(n);
	end;
	writeln('Se creo un archivo de novelas');
end;

// Crea un archivo, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var archivo: novelas; var nombre_fisico: cadena20; var existe: boolean);
begin
	writeln('Eligio la opcion "crear un archivo"');
	existe := true;
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
	rewrite(archivo);
	cargarDatos(archivo);
	close(archivo);
end;

// Uso este modulo?????? 
//
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
    num := n.cod; existe := false;
    seek(archivo, 0);
	while ( (not existe) AND (not eof(archivo)) ) do begin
		read(archivo, n);
		if (n.cod = num) then
			existe := true;
	end;
end;


// Muestra en pantalla el menu de modificaciones que se le puede hacer a la informacion de una novela
procedure mostrarMenuModificaciones(var opcion: char);
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
	opcion: char;
begin
	mostrarMenuModificaciones(opcion);
	while (opcion <> '0') do begin
		writeln('Ingrese la informacion actualizada');
		case (opcion) of
			'1': readln(n.genero);
			'2': readln(n.nombre);
			'3': readln(n.duracion);
			'4': readln(n.director);
			'5': readln(n.precio);
		end;
		mostrarMenuModificaciones(opcion);
	end;
end;


//Modifica la edad de un empleado
procedure modificarDatos(var archivo: novelas);
var
	n: novela;
	existe: boolean;
begin
	writeln('Ingrese el codigo de novela de la cual quiere modificar los datos');
	readln(n.cod);

	existeNovela(archivo, n, existe);

	if (existe) then begin // Si existe, en "n" queda cargado el registro buscado y el puntero se quedo apuntando al elemento siguiente del mismo
		modificarCampos(n);
        seek(archivo, filePos(archivo)-1); // Se posiciona en la posicion del registro a modificar
        write(archivo, n); // Modifica el elemento el archivo
		writeln('Se actualizo la informacion de la novela indicada');
	end
	else
		writeln('No se pudo actualizar la informacion. El codigo de novela ingresado no existe');
end;


// Es maso lo mismo que el proceso existeNovela, tendria q haber adaptado el codigo viejo para usar esta funcion pero me dio paja :)
function existe(var archivo: novelas; cod: integer) : boolean;
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


// Agrega una novela al archivo (si esa novela no existe)
procedure agregarNovela(var archivo: novelas);
var
	n, cabecera, aux: novela;
begin
	writeln('Eligio la opcion "Dar de alta una novela"');
	leerNovela(n);

	if (existe(archivo, n.cod)) then
        writeln('No se pudo agregar la novela. El codigo de novela ya esta registrado')
    else begin
		seek(archivo, 0); // Se posiciona en la cabecera
		read(archivo, cabecera);
		
		if (cabecera.cod = 0) then begin // No hay espacios libres, hay que agregar al final
			seek(archivo, fileSize(archivo)); // Se posiciona al final del archivo
			write(archivo, n); // Agrega un registro
			writeln('No habia espacios libres. Se agrego al final');
		end
		else begin
			seek(archivo, cabecera.cod*-1); // Se posiciona en el primer espacio libre
			read(archivo, aux); // Leo el contenido que hay en la posicion sobre la que voy a insertar el nuevo elemento
			seek(archivo, 0); // Vuelvo a la cabecera para actualizarla
			write(archivo, aux); // Escribe el nuevo primer espacio libre
			seek(archivo, cabecera.cod*-1);
			write(archivo, n);

			writeln('Se ha agregado una novela');
		end;
	end;
end;


// Carga los datos de un empleado en el archivo de texto traido por parametro
procedure cargarArchivoTxt(var txt: text; n: novela);
begin
	with n do
		writeln(txt, ' Cod novela: ' , cod , ' | Genero: ' , genero); // Escribe en el archivo de texto
end;

// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoTxt(var archivo: novelas);
var
	n: novela;
	txt: text;
begin
	assign(txt, 'novelas.txt');
	rewrite(txt); // Crea el archivo de texto
	while (not eof(archivo))do begin
		read(archivo, n); // Lee un elemento del archivo binario
		cargarArchivoTxt(txt, n);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt);
end;


// Elimina un registro del archivo
procedure eliminarNovela(var archivo: novelas);
var
	cabecera: novela;
	codAEliminar: integer;
begin
	writeln('Ingrese el codigo de novela que quiere eliminar');
	readln(codAEliminar);

	// ESTO DEBERIA IR ADENTRO DEL IF O ES IRRELEVANTE?
	read(archivo, cabecera); // Guarda la cabecera

	if (existe(archivo, codAEliminar)) then begin // Si encontró el codigo de novela
		seek (archivo, filePos(archivo)-1 ); // Se posiciona en el archivo a eliminar
        write(archivo, cabecera); // Escribe en la posicion a borrar la informacion que tenia la cabecera
        cabecera.cod := (filePos(archivo)-1 ) * -1; // Convierte el indice de la posicion a negativo
        seek(archivo, 0); // Se posiciona en la cabecera
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
		'4': exportarArchivoTxt(archivo);
	end;
end;

// Abre el archivo creado anteriormente (si lo hay), muestra un menu con las operaciones disponibles y ejecuta las instrucciones correspondientes
procedure abrirArchivoCreado(var archivo: novelas; nombre_fisico: cadena20; existeArchivo: boolean);
var
	opcion: char;
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
			seek(archivo, 0);
			writeln;
			writeln('¿QUIERE VOLVER AL MENU PRINCIPAL?'); writeln('S: Si'); writeln('N: No');
			readln(opcion);
		end;
		close(archivo);
	end
	else begin
		writeln;
		writeln('Aun no se creo un archivo de novelas.');
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
