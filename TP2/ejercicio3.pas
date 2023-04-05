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
	SUCURSALES = 30;
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
		stckDisp: integer;
		stockMin: integer;
	end;

	producto_det = record
		cod: integer;
		cantVendida: integer;
	end;

	maestro = file of producto;
	detalle = file of producto_det;

	info_sucursales = array[rango] of detalle;
	prod_det_minimos = array [rango] of producto_det;

// Asigna archivo logico con el fisico de 30 archivos detalle de productos
procedure asignarDetalles(var v: info_sucursales);
begin
	for i := 1 to SUCURSALES do
		assign(v[i], 'sucursal ' + IntToStr(i));
end;


// Crea 30 detalles de productos
procedure abrirDetalles(var v: info_sucursales);
begin
	for i := 1 to SUCURSALES do
		rewrite(v[i]);
end;


// Abre 30 detalles de productos
procedure abrirDetalles(var v: info_sucursales);
begin
	for i := 1 to SUCURSALES do
		reset(v[i]);
end;


// Cierra 30 detalles de productos
procedure cerrarDetalles(var v: info_sucursales);
var
	i: integer;
begin
	for i := 1 to SUCURSALES do
		close(v[i]);
end;


// Lee un archivo detalle: si es eof setea en valorAlto, sino devuelve el registro que se leyo
procedure leer (var det: detalle; var prod: producto_det);
begin
	if (not eof(det)) then
		read(det, prod)
	else
		prod.cod := valorAlto;
end;


// Busca los produtos minimos de todos los archivos de un vector y los almacena en un vector de productos minimos
procedure guardarMinimos(var v: info_sucursales; var vMin: productos_det_minimos);
var
	i: integer;
	prod: producto;
begin
	for i := 1 to SUCURSALES do begin
		leer(v[i], prod); //con i en 1 lee el prime producto del primer archivo, con i en 2 lee el primer producto del segundo archivo, etc
		vMin[i] := prod;
	end;
end;


// Busca el codigo de producto minimo entre los 30 archivos detalle de un vector recibido y lo devuelve en el parametro "min"
procedure minimo(var vMin: prod_det_minimos; var min: producto_det);
var
	i: integer;
	prod: producto_det;
begin
	min.cod := 9999;
	for i := 1 to SUCURSALES do
		if (vMin[i].cod <> valorAlto) then
			if (vMin[i].cod < min.cod) then begin
				min := prod;
				leer(v[i], prod); // lee un producto en el vector en la posMin
				vMin[i] := prod;
			end;
end;


// Actualiza el stock del archivo maestro a partir de 30 detalles que se reciben como parametro
procedure actualizarStock(var mae: maestro; v: info_sucursales);
var
	prodMae: producto;
	min: producto_det;
begin
	reset(mae); crearDetalles(v);

	minimo(vector, min);
	while (min.cod <> valorAlto) do begin
		read(mae, prodMae);

		while (prodMae.cod <> min.cod) do
			read(mae, prodMae);

		while (prodMae.cod = prod_det.cod) do begin
			prodMae.stockDisp := prodMae.stockDisp - min.cantVendida;
			minimo(det, min);
		end;
		
		seek(mae, filepos(mae)-1);
		write(mae, prodMae);
	end;

end;

// ---------------------------------------------------------------------
var

begin
end.
