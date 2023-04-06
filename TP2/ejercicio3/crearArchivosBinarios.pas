program crearArchivosBinarios;

type
  producto_det = record
    cod: integer;
    cant_vendida: integer;
  end;

var
  archivo1, archivo2, archivo3, archivo4: file of producto_det;
  i: integer;
  producto: producto_det;
begin
  randomize;

  // Crear y cargar datos aleatorios en detalle1
  assign(archivo1, 'detalle_sucursal_1');
  rewrite(archivo1);
  for i := 1 to 60 do begin
    producto.cod := i;
    producto.cant_vendida := random(100);
    write(archivo1, producto);
  end;
  close(archivo1);

  // Crear y cargar datos aleatorios en detalle2
  assign(archivo2, 'detalle_sucursal_2');
  rewrite(archivo2);
  for i := 1 to 70 do begin
    producto.cod := i;
    producto.cant_vendida := random(100);
    write(archivo2, producto);
  end;
  close(archivo2);

  // Crear y cargar datos aleatorios en detalle3
  assign(archivo3, 'detalle_sucursal_3');
  rewrite(archivo3);
  for i := 1 to 30 do begin
    producto.cod := i;
    producto.cant_vendida := random(100);
    write(archivo3, producto);
  end;
  close(archivo3);

  // Crear y cargar datos aleatorios en detalle4
  assign(archivo4, 'detalle_sucursal_4');
  rewrite(archivo4);
  for i := 1 to 100 do begin
    producto.cod := i;
    producto.cant_vendida := random(100);
    write(archivo4, producto);
  end;
  close(archivo4);

	writeln('Archivos detalle creados');

end.
