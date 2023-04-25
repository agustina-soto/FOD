{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita incorporar datos al archivo.
Los números son ingresados desde teclado. El nombre del archivo debe ser proporcionado por el usuario desde teclado.
La carga finaliza cuando se ingrese el número 30000, que no debe incorporarse al archivo. }

program ejercicio1;
const
	fin = 30000; // lectura limite, no debe incluirse
type
	archivo_enteros = file of integer; // Definicion de un archivo binario

var
	archivo_logico: archivo_enteros;
	nombre_fisico: string[15]; // Es proporcionado por el usuario desde teclado
	num: integer;
begin
	// Ingreso del nombre fisico del archivo
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	
	// Hay que hacer el enlace entre el nombre que se ingreso y el logico
	assign(archivo_logico, nombre_fisico);
	
	// Apertura del archivo para creacion del mismo
	rewrite(archivo_logico);
	
	// Comienza la carga de datos
	writeln('Ingrese un numero');
	readln(num);
	while (num <> fin) do begin
		write (archivo_logico, num); // agregar dato al archivo
		writeln('Ingrese un numero'); // leer otro numero
		readln(num);
	end;
	
	// Cierre del archivo
	close (archivo_logico);
end.
