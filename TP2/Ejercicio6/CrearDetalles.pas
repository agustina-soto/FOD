program crearDetalles;

type
  cadena40 = string[40];
  rango = 1..3;

  contadorCasos = record
    cant_activos: integer;
    cant_nuevos: integer;
    cant_recuperados: integer;
    cant_fallecidos: integer;
  end;

  municipio = record
    cod_localidad: integer;
    cod_cepa: integer;
    cont: contadorCasos;
  end;

  detalle = file of municipio;

var
  archivo1, archivo2, archivo3, archivo4: detalle;
  i, j: integer;
  m: municipio;

procedure generarDatosAleatorios(var m: municipio);
begin
  // Generar cantidades aleatorias de casos para el municipio
  m.cont.cant_activos := Random(100);
  m.cont.cant_nuevos := Random(50);
  m.cont.cant_recuperados := Random(1000);
  m.cont.cant_fallecidos := Random(50);
end;

begin
  // Asignar nombres y rutas a los archivos detalle
  Assign(archivo1, 'detalle_municipio_1');
  Assign(archivo2, 'detalle_municipio_2');
  Assign(archivo3, 'detalle_municipio_3');
  Assign(archivo4, 'detalle_municipio_4');

  // Abrir los archivos detalle
  Rewrite(archivo1);
  Rewrite(archivo2);
  Rewrite(archivo3);
  Rewrite(archivo4);

  // Generar y escribir datos aleatorios en cada archivo detalle
  for i := 1 to 10 do begin
    for j := 1 to 3 do begin
      m.cod_localidad := i;
      m.cod_cepa := j;
      generarDatosAleatorios(m);
      case j of
        1: write(archivo1, m);
        2: write(archivo2, m);
        3: write(archivo3, m);
      end;
    end;
    // Escribir en el cuarto archivo detalle
    m.cod_localidad := i;
    m.cod_cepa := 4;
    generarDatosAleatorios(m);
    write(archivo4, m);
  end;

  // Cerrar los archivos detalle
  Close(archivo1);
  Close(archivo2);
  Close(archivo3);
  Close(archivo4);
  
  writeln('DETALLES CREADOS');
end.
