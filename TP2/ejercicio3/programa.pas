{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.

De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena.
Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad vendida.

Además, se deberá informar en un archivo de texto: nombre de producto, descripción, stock disponible
y precio de aquellos productos que tengan stock disponible por debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos.
En cada detalle puede venir 0 o N registros de un determinado producto.}

program ejercicio3;
uses sysutils;
const
	SUCURSALES = 4;//30;
	valorAlto = -1;
type
	cadena30 = string[30];
	cadena60 = string[60];
	rango = 1..SUCURSALES;

	producto = record
		cod: integer;
		nombre: cadena30;
		descripcion: cadena60;
		precio: real;
		stockDisp: integer;
		stockMin: integer;
	end;

	producto_det = record
		cod: integer;
		cantVendida: integer;
	end;

	info_producto = record
		nombre: cadena30;
		descripcion: cadena60;
		stockDisp: integer;
		precio: real;
	end;

	maestro = file of producto;
	detalle = file of producto_det;

	detalles = array[rango] of detalle;
	prod_minimos = array [rango] of producto_det;


// Asigna archivos logicos con los fisicos (ya creados) de 30 archivos detalle de productos
procedure asignarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to SUCURSALES do
		assign(v[i], 'detalle_sucursal_' + IntToStr(i));
end;


// Cierra 30 detalles de productos
procedure cerrarDetalles(var v: detalles);
var
	i: integer;
begin
	for i := 1 to SUCURSALES do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en valorAlto, sino devuelve el registro que se leyo
procedure leerDetalle (var det: detalle; var prod: producto_det);
begin
	if (not eof(det)) then
		read(det, prod)
	else
		prod.cod := valorAlto;
end;


// Busca los produtos minimos de todos los archivos de un vector y los almacena en un vector de productos minimos
procedure guardarMinimos(var vSucursales: detalles; var vMin: prod_minimos);
var
	i: integer;
begin
	for i := 1 to SUCURSALES do begin
		reset(vSucursales[i]);
		leerDetalle(vSucursales[i], vMin[i]); // Lee (sobre el archivo que acaba de abrir) el primer producto y lo carga en vMin[posDondeSeLeyo]
									  // Con i en 1 lee el prime producto del primer archivo, con i en 2 lee el primer producto del segundo archivo, etc
	end;
end;


// Busca el codigo de producto minimo entre los 30 archivos detalle de un vector recibido y lo devuelve en el parametro "min"
procedure minimo(var vSucursales: detalles; var vMin: prod_minimos; var min: producto_det);
var
	i: integer;
	posMin: integer;
begin
	min := vMin[1]; // Agarra el primer producto del primer detalle -- > que pasa si es eof? es legal agarrar v[i]?
	posMin := 1; // Agarra la posicion donde se encuentra el producto min
	for i := 2 to SUCURSALES do begin // Compara el min contra todos los primeros productos de todos los detalles
		if (vMin[i].cod < min.cod) then begin
			min := vMin[i];
			posMin := i;
		end;
	end;
	writeln('EL MINIMO ESTA EN EL ARCHIVO - Sucursal ',posMin, ' -');
	leerDetalle(vSucursales[posMin], vMin[posMin]); // Repone el producto leido en el vector de minimos y el otro queda guardado en min
end;


// Agrega la informacion de un producto al archivo de texto
procedure agregarAtxt(var txt: text; prod: producto);
var
	infoProd: info_producto;
begin
	with prod do begin
		infoProd.nombre := nombre;
		infoProd.descripcion := descripcion;
		infoProd.stockDisp := stockDisp;
		infoProd.precio := precio;
	end;
	with infoProd do begin
		writeln(txt, 'Nombre del producto: ', nombre);
		writeln(txt, 'Stock disponible: ', stockDisp, ' | Precio: ', precio:2:2, '| Descripcion: ', descripcion);
		writeln('----------------------------');
	end;
end;


// Actualiza el stock del archivo maestro a partir de 30 detalles que se reciben como parametro
procedure actualizarMaestro(var mae: maestro; var vSucursales: detalles);// var txt: text);
var
	prodMae: producto;
	min: producto_det;
	vMin: prod_minimos;
	txt: text;
begin
	assign(txt, 'productos_stockDisp_menor_stockMin.txt');
	rewrite(txt); // Crea el archivo txt --> lo hace una sola vez, va cargandolo en el modulo actualizarStock

	guardarMinimos(vSucursales, vMin); // Abre todos los archivos detalle de vSucursales y almacena los minimos de cada detalle en vMin
	reset(mae);

	minimo(vSucursales, vMin, min);
	while (min.cod <> valorAlto) do begin // Mientras hay prod por procesar (cod solo es valorAlto cuando no hay mas productos en ningun detalle)
		read(mae, prodMae);

		while (prodMae.cod <> min.cod) do // Sale del while cuando encuentra en el maestro el mismo codigo de producto que se leyo en el detalle
			read(mae, prodMae);

		while (prodMae.cod = min.cod) do begin // Sale del while cuando cambia el codigo de producto de min (se acabaron las actualizaciones para ese producto)
			prodMae.stockDisp := prodMae.stockDisp - min.cantVendida;
			minimo(vSucursales, vMin, min); // Busca otro codigo de producto minimo entre todos los detalles
		end;

		if (prodMae.stockDisp < prodMae.stockMin) then
			agregarAtxt(txt, prodMae); // Actualiza el stock disponible

		seek(mae, filepos(mae)-1);
		write(mae, prodMae);
	end;

	cerrarDetalles(vSucursales); close(mae); close(txt);
end;



// ---------------------------------------------------------------------
var
	mae: maestro;
	vSucursales: detalles; // tiene los detalles
begin
	assign(mae, 'productos maestro'); // Abre y cierra el maestro en el modulo
	asignarDetalles(vSucursales);
	actualizarMaestro(mae, vSucursales); // En este modulo se carga el vector de minimos
end.
