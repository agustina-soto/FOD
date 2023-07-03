{
     IMPORTANTE:
                *La primera vez que se corre funciona bien.
                * Para la 2da el nombre del archivo maestro ya fue modificado, por lo que hay que correr de nuevo el programa para crear el archivo
                maestro; sino al principio del programa cuando se hace el assign del archivo maestro (para acceder a los datos que se cargaron en el
                programa crear_y_cargar_maestro) va a tirar codigo de error poque ese archivo no existe más. 
}

program ejercicio6;
type
	cadena50 = string[50];
	cadena100 = string[100];

	info_mae = record
		cod: integer;
		descripcion: cadena50;
		colores: cadena100;
		tipo_prenda: cadena50;
		stock: integer;
		precio_unitario: real;
	end;
	
	maestro = file of info_mae; // No esta ordenado

	info_det = record
		cod: integer; // Codigo de las prendas que quedaran obsoletas
	end;

	detalle = file of info_det;


procedure imprimirMaestro(var mae: maestro);
var
    info: info_mae;
begin
	reset(mae);
	writeln('MAESTRO:');
	while (not eof(mae)) do begin
		read(mae, info);
		writeln('Codigo de prenda: ',info.cod,' | Descripcion: ',info.descripcion,' | Colores: ',info.colores,' | Tipo de prenda: ',info.tipo_prenda,' | Stock: ',info.stock,' | Precio: ',info.precio_unitario:2:2);
	writeln('----------------------------------------------------------------------------------------------------------------------');
	end;
	close(mae);    
end;

procedure imprimirDetalle(var det: detalle);
var
	info: info_det;
begin
	reset(det);
	writeln('DETALLE:');
	while (not eof(det)) do begin
		read(det, info);
		writeln('Codigo de prenda obsoleta: ',info.cod);
		writeln('----------------------------------------------------------------------------------------------------------------------');
	end;
	close(det);
end;

// Realiza la baja logica de las prendas de un maestro que se indican en un detalle. Para ello se modifica el stock correspondiente a valor negativo
procedure bajaLogica(var mae: maestro; var det: detalle);
var
	infoDet: info_det;
	infoMae: info_mae;
begin
	reset(mae); reset(det);
	while (not eof(det)) do begin
		read(det, infoDet);
		seek(mae, 0);
		read(mae, infoMae);
		while (infoMae.cod <> infoDet.cod) do
			read(mae, infoMae);
		// Sale cuando encuentra el codigo del detalle en el maestro
		infoMae.stock := infoMae.stock * -1; // El valor negativo indica que el registro esta borrado
		seek(mae, filePos(mae)-1);
		write(mae, infoMae);	
	end;
	close(mae); close(det);
end;


// Realiza la baja fisica de todas las prendas marcadas como borradas. Devuelve el archivo "limpio" y crea otro que contiene el original
procedure bajaFisica(var mae, aux: maestro);
var
	info: info_mae;
begin
	reset(mae); rewrite(aux);

	while (not eof(mae)) do begin
		read(mae, info);
		if (info.stock > 0) then
			write(aux, info); // Copio el registro validado en el archivo auxiliar
	end;

	close(mae); close(aux);
	rename(mae, 'archivo_actualizado');
end;
{ Deberia haber hecho esto no?:
	erase(mae);
	rename(aux,'archivo_maestro');}



// ---------------------------------------------------------------------
var
	mae, aux: maestro;
	det: detalle;
begin
	// Los archivos binarios ya estan creados y cargados, solo les estoy asignando el nombre a mis variables del programa para que puedan usarlos
	assign(mae, 'archivo_maestro'); assign(det, 'archivo_detalle');

	imprimirMaestro(mae); readln;
	imprimirDetalle(det); readln;

	bajaLogica(mae, det); writeln('Baja logica finalizada');

	imprimirMaestro(mae); readln;
	
	assign(aux, 'archivo_auxiliar');
	bajaFisica(mae, aux);

	writeln('MAESTRO ACTUALIZADO:');
	imprimirMaestro(aux);
end.
