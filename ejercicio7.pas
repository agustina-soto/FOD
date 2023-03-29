{Realizar un programa que permita:

a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”

b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

program ejercicio7;
type
	cadena20 = string[20];
	cadena30 = string[30];

	novela = record
		cod: integer;
		precio: real;
		genero: cadena20;
		nombre: cadena30;
	end;

	novelas = file of novela;


// Lee una novela de teclado
procedure leerNovela(var n: novela);
begin
	with n do begin
		writeln('Ingrese el codigo de la novela');
		readln(cod);
		writeln('Ingrese el nombre de la novela');
		readln(nombre);
		writeln('Ingrese el precio de la novela');
		readln(precio);
		writeln('Ingrese el genero de la novela');
		readln(genero);
	end;
end;


// Crea un archivo binario y lo carga a partir de un archivo de texto
procedure crearArchivo(var arch: novelas);
var
	n: novela;
	txt: text;
	nombre_fisico: cadena20;
begin
	writeln('Ingrese el nombre del archivo a crear');
	readln(nombre_fisico);
	assign(arch, nombre_fisico); // Asigna el nombre logico y el fisico
	rewrite(arch); // Crea el archivo binario
	
	assign(txt, 'novelas.txt');
	reset(txt); // Abre el archivo de texto

	while (not eof(txt)) do begin
		with n do begin
			readln(txt, cod, precio, genero);
			readln(txt, nombre);
			write(arch, n); // Escribe en el archivo binario
		end;
	end;

	close(txt);		close(arch);
	
	writeln('Se creo el archivo');
end;


// Muestra el menu de opciones para el usuario
procedure mostrarMenu(var opcion: char);
begin
	writeln; 	writeln;
	writeln('------------- MENU -------------');
	writeln('a: Agregar novela');
	writeln('b: Modificar novela');
	writeln('s: Salir');
	writeln('Ingrese una opcion');
	readln(opcion);
end;


// Actualiza un registro de un archivo binario
procedure actualizarArchivo(var arch: novelas; n: novela);
begin
	seek(arch, filePos(arch)-1);
	write(arch, n); // Actualiza el archivo
end;


// Recibe un archivo y un codigo de novela y devuelve si esa novela existe en el archivo
procedure existeNovela(var arch: novelas; var existe: boolean; cod: integer);
var
	n: novela;
begin
	while ( (not existe) AND (not eof(arch)) ) do begin
		read(arch, n); // Lee una novela del archivo
		if (n.cod = cod) then begin // Si el cod de la novela leida coincide con la leido por teclado (traido por parametro)
			existe := true;
		end;
	end;
end;


// Agrega una novela al archivo recibido
procedure agregarNovela(var arch: novelas);
var
	n: novela;
	existe: boolean;
begin
	existe := false;
	leerNovela(n);

	reset(arch); // Abro el archivo binario

	existeNovela(arch, existe, n.cod);
	if (existe) then
		writeln('No se pudo agregar la novela, ya esta registrada en el archivo')
    else begin
		write(arch, n);
		writeln('Se agrego la novela');
	end;

	close(arch);
end;


// Modifica el precio de una novela (info ingresada por el usuario)
procedure modificarNovela(var arch: novelas);
var
	n: novela;
	found: boolean;
	codABuscar: integer;
	nuevoPrecio: real;
begin
	writeln('Ingrese un codigo de novela para actualizar');
	readln(codABuscar);
	writeln('Ingrese el nuevo precio');
	readln(nuevoPrecio);

	found := false;

	reset(arch); // Abre el archivo

	while ( (not eof(arch)) AND (not found) ) do begin
		read(arch, n);
		if (n.cod = codABuscar) then begin
			n.precio := nuevoPrecio;
			found := true;
		end;
	end;


	actualizarArchivo(arch, n);

	close(arch); // Cierra el archivo

	writeln('Se modifico una novela');
end;


// Escribe en el archivo de texto el celular recibido por parametro
procedure cargarDatosTxt(var txt: text; n: novela);
begin
	with n do begin
			writeln(txt, cod, ' ', precio:0:0,' ', genero);
			writeln(txt, nombre);
	end;
end;


// Exporta un archivo binario a un archivo de texto
procedure exportarArchivoATxt(var arch: novelas);
var
	txt: text;
	n: novela;
begin
	reset(arch); // Abre el archivo binario

	assign(txt, 'novelas.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, n);
		cargarDatosTxt(txt, n);
	end;

	close(arch);	close(txt);
end;



// ---------------------------------------------------------------------
var
	opcion: char;
	arch: novelas;
begin
	crearArchivo(arch);
	mostrarMenu(opcion);
	while (opcion <> 's') AND (opcion <> 'S') do begin
		case (opcion) of
			'a': agregarNovela(arch);
			'b': modificarNovela(arch);
		end;
		mostrarMenu(opcion);
	end;
	exportarArchivoATxt(arch);
end.
