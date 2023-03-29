{6. Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
 
b. Modificar el stock de un celular dado.

c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.

NOTA: Las búsquedas deben realizarse por nombre de celular.}

program ejercicio6;
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
			readln(txt, stockDisp,stockMin, desc);
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


// Escribe en el archivo de texto el celular recibido por parametro
procedure cargarDatosTxt(var txt: text; c: celular);
begin
	with c do begin
			writeln(txt, cod, ' ', precio:0:0,' ', marca);
			writeln(txt, stockDisp, ' ', stockMin,' ', desc);
			writeln(txt, nombre);
	end;
end;


// Exporta un archivo binario a un archivo de texto
procedure exportarArchivoATxt(var arch: celulares);
var
	txt: text;
	c: celular;
begin
	reset(arch); // Abre el archivo binario

	assign(txt, 'celulares.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, c);
		cargarDatosTxt(txt, c);
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
	writeln('e: Agregar un celular');
	writeln('f: Modificar stock de un celular');
	writeln('g: Exportar archivo creado a un archivo de texto con celulares sin stock');
	writeln('s: Salir');
	writeln('Ingrese una opcion');
	readln(opcion);
end;


// Lee un celular de teclado
procedure leerCelular(var c: celular);
begin
	with c do begin
		writeln('Ingrese el codigo del celular');
		readln(cod);
		writeln('Ingrese el nombre');
		readln(nombre);
		writeln('Ingrese la descripcion');
		readln(desc);
		writeln('Ingrese la marca');
		readln(marca);
		writeln('Ingrese el precio');
		readln(precio);
		writeln('Ingrese el stock minimo');
		readln(stockMin);
		writeln('Ingrese el stock disponible');
		readln(stockDisp);
	end;
end;


// Actualiza un registro de un archivo binario
procedure actualizarArchivo(var arch: celulares; c: celular);
begin
	seek(arch, filePos(arch)-1);
	write(arch, c); // Actualiza el archivo
end;


// Recibe un archivo y un nombre de celular y devuelve si ese celular existe en el archivo
procedure existeCelular(var arch: celulares; var existe: boolean; var stock: integer; nombre: cadena20);
var
	celu: celular;
begin
	while ( (not existe) AND (not eof(arch)) ) do begin
		read(arch, celu); // Lee un celular del archivo
		if (celu.nombre = nombre) then begin // Si el nombre del celular leido coincide con el leido por teclado (traido por parametro)
			existe := true;
			stock := celu.stockDisp;
		end;
	end;
end;


// Agrega un celular al archivo (si no existe; si existe actualiza el stock)
procedure agregarCelular(var arch: celulares);
var
	c: celular;
	stock: integer;
	existe: boolean;
begin
	existe := false;
	leerCelular(c);

	reset(arch); // Abro el archivo binario

	existeCelular(arch, existe, stock, c.nombre);
	if (existe) then begin
		c.stockDisp := c.stockDisp + stock;
		writeln('se actualizo el stock del celular ingresado');
    end
    else
		writeln('Se agrego el celular');

	actualizarArchivo(arch, c);

	close(arch);
end;


// Modifica el stock (elegido por el usuario) de un celular dado (elegido por el usuario)
procedure modificarStock(var arch: celulares);
var
	c: celular;
	found: boolean;
	nomABuscar: cadena20;
	nuevoStock: integer;
	// aux: integer;
begin
	writeln('Ingrese un nombre de celular para actualizar su stock');
	readln(nomABuscar);
	writeln('Ingrese el nuevo stock disponible');
	readln(nuevoStock);
	
	found := false;

	reset(arch); // Abre el archivo

	while ( (not eof(arch)) AND (not found) ) do begin
		read(arch, c);
		if (c.nombre = nomABuscar) then begin
			// aux:= c.stockDisp;
			c.stockDisp := nuevoStock;
			found := true;
		end;
	end;

	actualizarArchivo(arch, c);

	close(arch); // Cierra el archivo
end;


// Exporta un archivo binario a un archivo de texto con los celulares que tengan stock 0
procedure exportarArchivoATxtSinStock(var arch: celulares);
var
	txt: text;
	c: celular;
begin
	assign(txt, 'SinStock.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto
	reset(arch); // Abre el archivo binario

	while (not eof(arch)) do begin
		read(arch, c);
		if (c.stockDisp = 0) then
			cargarDatosTxt(txt, c);
	end;

	close(arch);	close(txt);
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
			'd': exportarArchivoATxt(arch);
			'e': agregarCelular(arch);
			'f': modificarStock(arch);
			'g': exportarArchivoATxtSinStock(arch);
		end;
		mostrarMenu(opcion);
	end;
end.
