program ejercicio4;
uses
	sysutils;
const
	VALOR_ALTO = -1;
type
	cadena45 = string[45];

	reg_flor = record
		nombre: cadena45;
		codigo:integer;
	end;

	tArchFlores = file of reg_flor;
	
	vNombres = array[1..7] of cadena45;


// Carga en un vector nombres de flores para llenar el archivo
procedure cargarNombres(var n: vNombres);
begin
	n[1] := 'Margarita';
	n[2] := 'Azucena';
	n[3] := 'Azalea';
	n[4] := 'Dalia';
	n[5] := 'Hortensia';
	n[6] := 'Bugambilia';
	n[7] := 'Hibisco';
end;

// Crea un archivo, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var archivo: tArchFlores);
var
	flor: reg_flor;
begin
	assign(archivo, 'archivo_flores');
	rewrite(archivo);
	flor.codigo := 0;
	flor.nombre := ' ';
	write(archivo, flor);
	close(archivo);
end;


// Devuelve si un codigo recibido existe en el archivo
function existe(var archivo: tArchFlores; cod: integer) : boolean;
var
	found: boolean;
	f: reg_flor;
begin
	seek(archivo, 0); // Se posiciona al inicio del archivo
	found := false;
	while (not eof(archivo)) AND (not found) do begin
		read(archivo, f);
		if (f.codigo = cod) then found := true;
	end;
	existe := found;
end;



{ Abre el archivo y agrega una flor recibida como parámetro manteniendo la política }
procedure agregarFlor (var a: tArchFlores; nombre: cadena45; codigo: integer);
var
	f, cabecera, aux: reg_flor;
begin
	reset(a);
	
	if (existe(a, codigo)) then
        writeln('No se pudo agregar. El codigo ya esta registrado')
	else begin
		f.codigo := codigo; f.nombre := nombre; // Carga el registro que se va a agregar
		seek(a, 0); // Se posiciona en la cabecera
		read(a, cabecera);
		if (cabecera.codigo = 0) then begin // No hay espacios libres, hay que agregar al final
			seek(a, fileSize(a)); // Se posiciona al final del archivo
			write(a, f); // Agrega un registro
			writeln('No habia espacios libres. Se agrego al final');
		end
		else begin
			seek(a, cabecera.codigo*-1); // Se posiciona en el primer espacio libre
			read(a, aux); // Lee el contenido que hay en la posicion sobre la que va a insertar el nuevo elemento
			seek(a, 0); // Vuelve a la cabecera para actualizarla
			write(a, aux); // Escribe el nuevo primer espacio libre
			seek(a, cabecera.codigo*-1); // Vuelve al espacio libre que habia encontrado para agregar el elemento
			write(a, f);
			writeln('Se ha agregado una novela');
		end;
	end;
	
	close(a);
end;

// Elimina un registro del archivo
procedure eliminarFlor(var a: tArchFlores; florAEliminar: reg_flor);
var
	cabecera: reg_flor;
begin
	reset(a);
	read(a, cabecera); // Guarda la cabecera

	if (existe(a, florAEliminar.codigo)) then begin // Si encontró el codigo
		seek (a, filePos(a)-1 ); // Se posiciona en el archivo a eliminar
        write(a, cabecera); // Escribe en la posicion a borrar la informacion que tenia la cabecera
        cabecera.codigo := (filePos(a)-1 ) * -1; // Convierte el indice de la posicion a negativo
        seek(a, 0); // Se posiciona en la cabecera
        write(a, cabecera); // Reemplaza el registro cabecera con el del registro que se acaba de eliminar
        writeln('Se elimino la novela ingresada');
    end
    else
        writeln('No se encontro una flor con ese codigo.');

	close(a);
end;


// Lista el contendo del archivo sin tener en cuenta los registros eliminados
procedure listarFlores(var a: tArchFlores);
var
	cabecera, f: reg_flor;
begin
	reset(a);

	read(a, cabecera);
	while (not eof(a)) do begin
		read(a, f);
		if (f.codigo > 0) then writeln('- - - FLOR - - -',#10, 'Nombre: ', f.nombre, #10, 'Codigo: ', f.codigo); // codigo < 0 significa borrado
	end;

	close(a);
end;



// ---------------------------------------------------------------------
var
	a: tArchFlores;
	flor: reg_flor;
	i: integer;
	nombres: vNombres;
begin
	crearArchivo(a);
	cargarNombres(nombres);

	for i := 1 to 4 do
		agregarFlor(a, nombres[i], i);
	
	listarFlores(a);
	
	flor.codigo := 3;
	eliminarFlor(a, flor);
	
	listarFlores(a);
	
	agregarFlor(a, nombres[7], 200);

	listarFlores(a);
end.
