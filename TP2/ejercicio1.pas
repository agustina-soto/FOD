{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program ejercicio1;
uses
    sysutils;
const
	valorAlto = -1;
type
	cadena20 = string[20];
	
	empleado = record
		cod: integer;
		nombre: cadena20;
		montoComision: real;
	end;

	empleados = file of empleado; // ordenado por codigo de empleado, cada empleado puede aparecer mas de una vez 

	empleadoConTotal = record
		cod: integer;
		monto: real;
	end;

	empConTotal = file of empleadoConTotal; // ordenado por codigo de empleado, cada empleado puede aparecer una vez


// Lee un empleado
procedure leerEmpleado(var e: empleado);
begin
	with e do begin
		writeln('Codigo - ', cod);
		if (cod <> 50) then begin
			nombre := concat ( 'Nombre - ', IntToStr (cod));
			montoComision := cod + 1000;
			writeln('Monto comision - $', montoComision:2:2);
		end;
	end;
end;


// Carga datos de empleados en el archivo de empleados
procedure cargarDatosArch(var arch: empleados);
var
	i: integer;
	e: empleado;
begin
	e.cod := 0;
	{leerEmpleado(e);
	while (e.cod <> 50) do begin
		write(arch, e);
		e.cod := e.cod + 1;
		leerEmpleado(e);
	end;}
	// la chanchada de abajo es para probar si hacia bien al totalizar los montos
	for i := 0 to 10 do begin
		leerEmpleado(e);
		write(arch, e);
	end;
	e.cod := e.cod + 1;
	for i := 0 to 10 do begin
		leerEmpleado(e);
		write(arch, e);
	end;
	e.cod := e.cod + 1;
	for i := 0 to 10 do begin
		leerEmpleado(e);
		write(arch, e);
	end;
end;


// Crea un archivo de empleados
procedure crearArchivoEmpleados(var arch: empleados);
begin
	assign(arch, 'archivo empleados');
	rewrite(arch); // Crea el archivo
	cargarDatosArch(arch); // Carga el archivo
	close(arch); // Cierra el archivo
end;


// Carga los datos de un empleado en el archivo de texto traido por parametro
procedure cargarArchivoTxt(var txt: text; emp: empleado);
begin
	with emp do
		writeln(txt,' Cod. Empleado: ', cod ,' | Nombre: ', nombre ,' | Monto por comision: ', montoComision:2:2); // Escribe en el archivo de texto
end;


// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoATxt(var arch: empleados);
var
	emp: empleado;
	txt: text;
begin
	assign(txt, 'empleados.txt');
	rewrite(txt); // Crea el archivo de texto “todos_empleados.txt”
	reset(arch);
	while (not eof(arch))do begin
		read(arch, emp); // Lee un elemento del archivo binario
		cargarArchivoTxt(txt, emp);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt);		close(arch);
end;


// Lee un empleado; si llego al EOF devuelve un valor de error
procedure leer (var arch: empleados; var e: empleado);
begin
	if (not(eof(arch))) then
		read (arch, e)
    else 
		e.cod := valoralto;
end;


// Compacta un archivo recibido como parametro para que cada empleado aparezca una unica vez con el total de sus comisiones
procedure compactarArchivo(var arch: empleados; var archTotal: empConTotal);
var
	e: empleado;
	aux: empleadoConTotal;
	codActual: integer;
	sumaComisiones: real;
begin
	assign(archTotal, 'archivo empleados con total');
	rewrite(archTotal);  reset(arch);

	leer(arch, e);
	while (e.cod <> valorAlto) do begin
		codActual := e.cod;		sumaComisiones := 0;
		while (e.cod = codActual) do begin
			sumaComisiones := sumaComisiones + e.montoComision;
			leer(arch, e);
		end;
		aux.cod := codActual;	aux.monto := sumaComisiones;
		write(archTotal, aux); // Escribe en el archivo totalizador el empleado con el total de sus comisiones
	end;

	close(archTotal);    close(arch);
end;


// Carga los datos de un empleado con montos totalizados en el archivo de texto traido por parametro
procedure cargarArchivoTxtConTotales(var txt: text; emp: empleadoConTotal);
begin
	with emp do
		writeln(txt,' Cod. Empleado: ', cod ,'| Monto total: ', monto:2:2); // Escribe en el archivo de texto
end;


// Crea un archivo de texto a partir de un archivo binario
procedure exportarArchivoATxtConTotales(var arch: empConTotal);
var
	emp: empleadoConTotal;
	txt: text;
begin
	assign(txt, 'empleados con totales.txt');
	rewrite(txt); // Crea archivo
	reset(arch);
	while (not eof(arch))do begin
		read(arch, emp);
		cargarArchivoTxtConTotales(txt, emp);
	end;
	writeln('Se cargo el archivo de texto');
	close(txt); 	close(arch); // Cierra archivos
end;


// ---------------------------------------------------------------------
var
	archEmp: empleados;
	archEmpTotal: empConTotal;
begin
	crearArchivoEmpleados(archEmp);
	exportarArchivoATxt(archEmp);
	compactarArchivo(archEmp, archEmpTotal);
	exportarArchivoATxtConTotales(archEmpTotal);
end.
