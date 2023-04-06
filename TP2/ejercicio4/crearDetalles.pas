program crearDetalles;
type
	rangoSemana = 1..4;
	rangoMes = 1..12; 
	cadena20 = string[20];

	fecha = record
		semana: rangoSemana; // random(3)+1;
		mes: rangoMes; // random(12)+1;
	end;

	info_detalle = record
		cod_usuario: integer;
		fecha: fecha;
		tiempo_sesion: integer;
	end;


var
  archivo1, archivo2, archivo3, archivo4, archivo5: file of info_detalle;
  i: integer;
  info_det: info_detalle;
begin
  randomize;

  // Crear y cargar datos aleatorios en detalle1
  assign(archivo1, 'detalle_1');
  rewrite(archivo1);
  for i := 1 to 60 do begin
    info_det.cod_usuario := i; // de 1 a 60
    info_det.fecha.semana := random(3)+1; // de 1 a 4
    info_det.fecha.mes := random(12)+1; // de 1 a 12
    info_det.tiempo_sesion := random(100)+1; // en horas, de 1 a 100
    write(archivo1, info_det);
  end;
  close(archivo1);

  // Crear y cargar datos aleatorios en detalle2
  assign(archivo2, 'detalle_2');
  rewrite(archivo2);
  for i := 1 to 70 do begin
    info_det.cod_usuario := i; // de 1 a 70
    info_det.fecha.semana := random(3)+1; // de 1 a 4
    info_det.fecha.mes := random(12)+1; // de 1 a 12
    info_det.tiempo_sesion := random(100)+1; // en horas, de 1 a 100
    write(archivo2, info_det);
  end;
  close(archivo2);

  // Crear y cargar datos aleatorios en detalle3
  assign(archivo3, 'detalle_3');
  rewrite(archivo3);
  for i := 1 to 30 do begin
    info_det.cod_usuario := i; // de 1 a 30
    info_det.fecha.semana := random(3)+1; // de 1 a 4
    info_det.fecha.mes := random(12)+1; // de 1 a 12
    info_det.tiempo_sesion := random(100)+1; // en horas, de 1 a 100
    write(archivo3, info_det);
  end;
  close(archivo3);

  // Crear y cargar datos aleatorios en detalle4
  assign(archivo4, 'detalle_4');
  rewrite(archivo4);
  for i := 1 to 100 do begin
    info_det.cod_usuario := i; // de 1 a 100
    info_det.fecha.semana := random(3)+1; // de 1 a 4
    info_det.fecha.mes := random(12)+1; // de 1 a 12
    info_det.tiempo_sesion := random(100)+1; // en horas, de 1 a 100
    write(archivo4, info_det);
  end;
  close(archivo4);

// Crear y cargar datos aleatorios en detalle4
  assign(archivo5, 'detalle_5');
  rewrite(archivo5);
  for i := 1 to 100 do begin
    info_det.cod_usuario := i; // de 1 a 100
    info_det.fecha.semana := random(3)+1; // de 1 a 4
    info_det.fecha.mes := random(12)+1; // de 1 a 12
    info_det.tiempo_sesion := random(100)+1; // en horas, de 1 a 100
    write(archivo5, info_det);
  end;
  close(archivo5);

  writeln('--------------------------');
  writeln('Archivos detalle creados');
  writeln('--------------------------');

end.
