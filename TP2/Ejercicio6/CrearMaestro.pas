program crearMaestro;
uses
	sysutils;
type
  cadena40 = string[40];
  contadorCasos = record
    cant_activos: integer;
    cant_nuevos: integer;
    cant_recuperados: integer;
    cant_fallecidos: integer;
  end;

  info_mae = record
    cod_localidad: integer;
    nombre_localidad: cadena40;
    cod_cepa: integer;
    nombre_cepa: cadena40;
    cont: contadorCasos;
  end;

  maestro = file of info_mae;

var
  archivo: maestro;
  i, j: integer;
  m: info_mae;

procedure generarDatosAleatorios(var m: info_mae);
begin
  // Generar cantidades aleatorias de casos para el municipio y la cepa
  m.cont.cant_activos := Random(100);
  m.cont.cant_nuevos := Random(50);
  m.cont.cant_recuperados := Random(1000);
  m.cont.cant_fallecidos := Random(50);

  // Asignar nombres aleatorios para la localidad y la cepa
  m.nombre_localidad := 'Localidad ' + IntToStr(m.cod_localidad);
  m.nombre_cepa := 'Cepa ' + IntToStr(m.cod_cepa);
end;


begin
  // Asignar nombre y ruta al archivo maestro
  Assign(archivo, 'maestro_municipios_covid');

  // Abrir el archivo maestro en modo escritura
  Rewrite(archivo);

  // Generar y escribir datos aleatorios en el archivo maestro
  for i := 1 to 4 do begin
    for j := 1 to 3 do begin
      m.cod_localidad := i; // 1 //1 //1 //2 //2
      m.cod_cepa := j;     // 1 //2 //3 // 1 //2
      generarDatosAleatorios(m);
      write(archivo, m);
    end;
    // Escribir en el archivo maestro para la cuarta cepa
    m.cod_localidad := i;
    m.cod_cepa := 4;
    generarDatosAleatorios(m);
    write(archivo, m);
  end;

  // Cerrar el archivo maestro
  Close(archivo);
  
  writeln('MAESTRO CREADO');
end.
