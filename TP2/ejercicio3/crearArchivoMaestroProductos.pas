{
	Crea un archivo maestro con 100 productos de tipo producto ordenado por codigo de producto y cargado con valores aleatorios
}

program crearArchivoMaestroProductos;
uses sysutils;
type
  producto = record
    cod: integer;
    nombre: string[30];
    descripcion: string[60];
    precio: real;
    stockDisp: integer;
    stockMin: integer;
  end;

var
  f: file of producto;
  p: producto;
  i: integer;

begin
  randomize;
  assign(f, 'productos maestro');
  rewrite(f);
  for i := 1 to 100 do
  begin
    p.cod := i; // los codigos van de 1 a 100
    p.nombre := 'Producto ' + IntToStr(i);
    p.descripcion := 'Descripcion del producto ' + IntToStr(i);
    p.precio := Random(1000) + Random;
    p.stockDisp := Random(3000);
    p.stockMin := Random(50);
    write(f, p);
  end;
  close(f);
  
  writeln('Archivo maestro creado');
  
end.
