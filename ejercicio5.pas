{Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”.
Los registros correspondientes a los celulares, deben contener: código de celular, el nombre, descripción, marca, precio, stock mínimo y el stock disponible.

Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.

Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.

Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.
El archivo de texto generado podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar
el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas. En la primera se especifica:
código de celular, el precio y marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.

Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.}

program ejercicio5;
type
	cadena20 = string[20];
	cadena60 = string[60];

	celular = record
		cod: integer;
		nombre: cadena20;
		desc: cadena60;
		marca: cadena20;
		precio: real;
		stockMin: integer;
		stockDisp: integer;
	end;

	celulares = file of celular;


// Crea un archivo binario y lo carga a partir de un archivo de texto
procedure crearArchivo(var arch: celulares);
var
	c: celular;
	txt: text;
	nombre_fisico: cadena20;
begin
	writeln('Ingrese el nombre del archivo a crear');
	readln(nombre_fisico);
	assign(arch, nombre_fisico); // Asigna el nombre logico y el fisico
	rewrite(arch); // Crea el archivo binario

	assign(txt, 'celulares.txt'); // Le asigno al archivo logico el nombre del archivo fisico que ya cree (y cargue) en mi carpeta de FOD
	reset(txt); // Abre el archivo de texto

	while (not eof(txt)) do begin
		with c do begin
			readln(txt, cod, precio, marca);
			readln(txt, stockMin, stockDisp, desc);
			readln(txt, nombre);
			write(arch, c); // Escribe en el archivo binario
		end;
	end;

	close(txt);		close(arch);
	
	writeln('Se creo el archivo');
end;


// Lista los datos de un celular recibido por parametro
procedure listarDatosCelular(c: celular);
begin
	writeln;
	with c do
		writeln('-> Codigo: ', cod ,
				' | Nombre: ' , nombre ,
				' | Descripcion:' + desc ,
				' | Marca: ' , marca ,
				' | Precio: ' , precio:0:0 ,
				' | Stock minimo: ' , stockMin ,
				' | Stock disponible: ' , stockDisp);
end;


// Lista los datos de aquellos celulares que tengan un stock menor al stock mínimo
procedure listarCelularesPocoStock(var arch: celulares);
var
	c: celular;
begin
	reset(arch); // Abre el archivo

	writeln;
	writeln(' --- Celulares que tiene un stock menor al stock minimo --- ');
	while (not eof(arch)) do begin
		read(arch, c);
		if (c.stockDisp < c.stockMin) then
			listarDatosCelular(c);
	end;

	close(arch); // Cierra el archivo
end;


// Lista los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
procedure listarCelularesSegunDescripcion(var arch: celulares);
var
	c: celular;
	cadenaABuscar: cadena60;
begin
	reset(arch); // Abre el archivo

	writeln;
	writeln('Ingrese la cadena a buscar');
	readln(cadenaABuscar);
	cadenaABuscar := Concat(' ',cadenaABuscar);

	writeln(' --- Celulares que tienen la descripcion ingresada --- ');
	while (not eof(arch)) do begin
		read(arch, c);
		if (c.desc = cadenaABuscar) then
			listarDatoscelular(c);
	end;

	close(arch); // Cierra el archivo
end;


// Exporta un archivo binario a un archivo de texto
procedure exportarArchivo(var arch: celulares);
var
	txt: text;
	c: celular;
begin
	reset(arch); // Abre el archivo binario

	assign(txt, 'celulares.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, c);
		with c do begin // Escribe en el archivo de texto
			writeln(txt, cod, ' ', precio:0:0, marca);
			writeln(txt, stockDisp, ' ', stockMin, desc);
			writeln(txt, nombre);
		end;
	end;

	close(arch);	close(txt);
end;


// Muestra el menu de opciones para el usuario
procedure mostrarMenu(var opcion: char);
begin
	writeln; 	writeln;
	writeln('------------- MENU -------------');
	writeln('a: Crear archivo');
	writeln('b: Listar los datos de aquellos celulares que tengan un stock menor al stock minimo');
	writeln('c: Listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario');
	writeln('d: Exportar archivo creado a un archivo de texto con todos los celulares');
	writeln('s: Salir');
	writeln('Ingrese una opcion');
	readln(opcion);
end;


// ---------------------------------------------------------------------
var
	opcion: char;
	arch: celulares;
begin
	mostrarMenu(opcion);
	while (opcion <> 's') AND (opcion <> 'S') do begin
		case (opcion) of
			'a': crearArchivo(arch);
			'b': listarCelularesPocoStock(arch);
			'c': listarCelularesSegunDescripcion(arch);
			'd': exportarArchivo(arch);
		end;
		mostrarMenu(opcion);
	end;
end.
