Program Sudoku;
uses crt;
const
	filas = 9;
	columnas = 9;
	cuadrantes = 3;
	solucion = 81;
	pistasTablero = 22;
type
	Tablero = array[1..filas, 1..columnas] of integer;
	PistasSudoku = array[1..filas, 1..columnas] of boolean;
	TabResuelto = array[1..filas, 1..columnas] of integer;
	cuadrante = array[1..3, 1..3] of integer;
var
	tabSudoku: Tablero;
	PistasTab: PistasSudoku;
	SolucionTab: TabResuelto;
	nombre, apellido, NickName: string;
	opcion: integer;
	
procedure mostrarTablero(var tabSudoku: Tablero; var PistasTab: PistasSudoku);
var
	i, j: integer;
begin
	writeln('------------------------');
	for i := 1 to filas do
		for j := 1 to columnas do
			begin
				if PistasTab[i,j] then //verificamos que el valor sea diferente de cero para asignarle un color a las pistas.
					textcolor(lightgray)
					
				else if tabSudoku[i,j] = 0 then
						textcolor(white)
				else
					textcolor(white);
					write(tabSudoku[i,j], ' ');
					
					if j mod cuadrantes = 0 then
						write('| ');
			end;
		writeln;
		if i mod cuadrantes = 0 then
			writeln('------------------------');
end;

procedure inicioPistas(var tabSudoku: Tablero; var PistasTab: PistasSudoku);
var
	i, j, pistasGen: integer;
begin
	for i := 1 to filas do
		for j := 1 to columnas do
		begin
			tabSudoku[i,j] := 0;
		end;
		
	pistasGen := 0;
	randomize;
	
	repeat
		i := random(filas)+1;
		j := random(columnas)+1;
		
		if not PistasTab[i,j] then
			begin
				PistasTab[i,j] := true;
				pistasGen := pistasGen+1;
			end;
	until pistasGen = pistasTablero;
end;

function validarMovimiento(tabSudoku: Tablero; fil, col, num: integer): boolean; //x = filas, y = columnas
var
	i, j, cuadrantFila, cuadrantColumna: integer;
begin
	for i := 1 to filas do
			for j := 1 to columnas do
				begin
					if (tabSudoku[fil,j] = num) or (tabSudoku[i, col] = num) then
					begin
						validarMovimiento := false;
						Exit;
					end;
				end;
				
	cuadrantFila := cuadrantes * ((fil-1) div cuadrantes)+1;
	cuadrantColumna := cuadrantes * ((col-1) div cuadrantes)+1;
	
	for i := cuadrantFila to cuadrantFila + cuadrantes - 1 do
		for j := cuadrantColumna to cuadrantColumna + cuadrantes - 1 do
			if tabSudoku[i,j] = num then 
				begin
					validarMovimiento := false;
					Exit;
				end;
			validarMovimiento := true;	
end;



BEGIN
	mostrarTablero(tabSudoku,PistasTab);
	inicioPistas(tabSudoku, PistasTab);
END.
