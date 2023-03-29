program ejercicio2;
const
	fin = 30000; // lectura limite, no debe incluirse
	limite = 1500; // nros menores (estricto) a 1500
type
	archivo_enteros = file of integer;


function calcularPromedio(suma, cant: integer) : real;
begin
	calcularPromedio := suma/cant;
end;


function esMenor(num: integer) : boolean;
begin
	esMenor := (num < limite);
end;


procedure cargarDatos(var arch_log: archivo_enteros);
var
	num: integer;
begin
	writeln('Ingrese un numero');
	readln(num);
	while (num <> fin) do begin
		write (arch_log, num); // agregar dato al archivo
		writeln('Ingrese un numero'); // leer otro numero
		readln(num);
	end;
end;


procedure recorrerArchivo(var arch_logico: archivo_enteros);
var
	num, sumaNum, cantMenoresA1500: integer; // Variable sobre la cual se van a leer los elementos del archivo
begin
	sumaNum := 0;	cantMenoresA1500 := 0;

	reset(arch_logico); // Abre el archivo existente

	// Recorre el archivo
	while not eof(arch_logico) do begin // Mientras no llegue al final del archivo
		read(arch_logico, num); // Lee un elemento
		write(num); // Imprime el elemento en pantalla
		sumaNum := sumaNum + num; // Actualiza contadores
		if (esMenor(num)) then cantMenoresA1500 := cantMenoresA1500 + 1;
	end;

	writeln('Cantidad de numeros menores a 1500: ' , cantMenoresA1500);
	writeln('Promedio de los numeros ingresados: ' , calcularPromedio(sumaNum, fileSize(arch_logico)):2:2);
	
	close(arch_logico); // Cierra el archivo
end;


// ---------------------------------------------------------------------
var
	archivo_logico: archivo_enteros;
	nombre_fisico, arch_a_procesar: string[15];
begin
	// Ingreso del nombre fisico del archivo
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	
	// Hay que hacer el enlace entre el nombre que se ingreso y el logico
	assign(archivo_logico, nombre_fisico);
	
	rewrite(archivo_logico); // Crea el archivo
	cargarDatos(archivo_logico);
	close (archivo_logico); // Cierre del archivo
	
	writeln('Ingrese el nombre del archivo a procesar');
	readln(arch_a_procesar);
	if (arch_a_procesar = nombre_fisico) then
		recorrerArchivo (archivo_logico)
	else
		writeln('El nombre ingresado no coincide con ningun archivo');
end.
