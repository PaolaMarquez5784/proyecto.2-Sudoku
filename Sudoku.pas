Program Sudoku;
uses crt, SysUtils;
const
	filas = 9;
	columnas = 9;
	cuadrantes = 3;
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
	opcion, op: integer;

//PROCEDIMIENTO PARA MOSTRAR EL TABLERO DEL JUEGO

procedure mostrarTablero(var tabSudoku: Tablero; var SolucionTab: TabResuelto; var PistasTab: PistasSudoku);
var
	i, j: integer;
begin
	textcolor(white);
	writeln('------------------------');
	
	for i := 1 to filas do
 		begin
			for j := 1 to columnas do
				begin
					if PistasTab[i,j] then //verificamos que el valor sea diferente de cero para asignarle un color a las pistas.
						textcolor(lightcyan)
						
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
end;

//PROCEDIMIENTO PARA INICIALIZAR LAS PISTAS

procedure inicioPistas(var tabSudoku: Tablero; var PistasTab: PistasSudoku);
var
	i, j, pistas: integer;
begin
	for i := 1 to filas do
		for j := 1 to columnas do
		begin
			tabSudoku[i,j] := 0;
		end;
		
	pistas := 0;
	randomize;
	
	repeat
		i := random(filas)+1;
		j := random(columnas)+1;
		
		if not PistasTab[i,j] then
			begin
				PistasTab[i,j] := true;
				pistas := pistas + 1;
				tabSudoku[i,j] := random(9) + 1; //asignamos un numero aleatorio a cada pista.
			end;
	until pistas = pistasTablero;
	
	mostrarTablero(tabSudoku, SolucionTab, PistasTab); //mostramos el tablero luego de inicializar las pistas
	
end;

//FUNCION QUE NOS PERMITE VERIFICAR QUE LOS NUMEROS INGRESADOS ESTEN DENTRO DEL RANGO PERMITIDO (DEL 1 AL 9) Y VERIFICAR SI LA CELDA SELECCIONADA NO ES UNA PISTA

function verifNumero(i, j, num: integer): boolean;
begin
	verifNumero := (num >= 1) and (num <= 9) and (tabSudoku[i,j] = 0);
end;

//FUNCION QUE NOS PERMITE VALIDAR SI LOS MOVIMIENTOS SON VALIDOS SEGUN SUS POSICIONES

function validarMovimiento(tabSudoku: Tablero; fil, col, num: integer): boolean; 
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

function solucionSudoku(var SolucionTab: TabResuelto): boolean;
var
	i, j, num: integer;
begin
	for i := 1 to 9 do
		begin
			for j := 1 to 9 do
				begin
					if SolucionTab[i,j] = 0 then
						begin
							for num := 1 to 9 do
								begin
									if validarMovimiento(SolucionTab, i, j, num) then
										begin
											SolucionTab[i,j] := num;
											
											if solucionSudoku(SolucionTab) then
												Exit(True);
											SolucionTab[i,j] := 0;
										end;
								end;
								Exit(False);
						end;
				end;
		end;
		Exit(True);
end;

//PROCEDIMIENTO QUE PERMITE BORRAR UN NUMERO DEL TABLERO
procedure modificarNumero(var tabSudoku: Tablero; var PistasTab: PistasSudoku);
var
	i, j, numero: integer;
begin
	mostrarTablero(tabSudoku, SolucionTab, PistasTab);
	
	write('Indique la fila donde esta el numero a modificar.(1-9): ');
	readln(i);
	
	write('Indique la columna donde esta el numero a modificar.(1-9): ');
	readln(j);
	
	write('Indique el nuevo numero que desea ingresar.(1-9) o marque 0 para eliminar el actual: ');
	readln(numero);
	
	if (numero >= 0) and (numero <= 9) and (PistasTab[i,j] = false) then
		begin
			tabSudoku[i,j] := numero;
			writeln('El numero ha sido eliminado/modificado exitosamente');
			Exit;
		end
		
		else
			begin
				writeln('No se puede modificar una pista, intente nuevamente');
				Exit;
			end;
end;

//FUNCION QUE PERMITE AL USUARIO TENER LA OPCION DE RENDIRSE
function rendirse(var tabSudoku: Tablero; PistasTab: PistasSudoku; var SolucionTab: TabResuelto): boolean;
var
	tableroCop : TabResuelto;
	resp: string;
begin
	tableroCop := SolucionTab;
	
	writeln('Estas seguro que deseas rendirte? (si/no)');
	readln(resp);
	
		if (resp = 'si') or (resp = 'SI') then
			begin
				writeln('Te has rendido, la solucion del sudoku es: ');
				solucionSudoku(tableroCop);
				tabSudoku := tableroCop;
				mostrarTablero(tabSudoku, SolucionTab, PistasTab);
				rendirse := true;
			end
			
			else 
				begin
					rendirse := false;
					clrscr;
					mostrarTablero(tabSudoku, SolucionTab, PistasTab);
				end;
end;
//PROCEDIMIENTO PARA MOSTRAR UN MENU DE OPCIONES
procedure opcionesJuego(var tabSudoku: Tablero);
var
	op: integer;
begin
	textcolor(yellow);
	gotoxy(28,7);
	writeln('||=======================================||');
	gotoxy(28,8);
	writeln('||            MENU DE OPCIONES           ||');
	gotoxy(28,9);
	writeln('||=======================================||');
	writeln();
	gotoxy(28,10);
	writeln('|| 1. Ingresar un numero                 ||');
	gotoxy(28,11);
	writeln('|| 2. Eliminar/modificar numero          ||');
	gotoxy(28,12);
	writeln('|| 3. Rendirse                           ||');
	gotoxy(28,13);
	writeln('|| 4. Salir                              ||');
	gotoxy(28,14);
	writeln('||=======================================||');
end;
	
//PROCEDIMIENTO PARA QUE EL USUARIO INGRESE NUMEROS EN LAS FILAS Y COLUMNAS

procedure introducirNumero(var tabSudoku: Tablero; PistasTab: PistasSudoku);
var
	i, j, numero: integer;
begin
	begin
		textcolor(yellow);
		writeln('');
		writeln('');
		writeln('-----------------------------------------------------------------------');
		write('* Indique la fila que desea usar.(1-9): ');
		readln(i);
		
		writeln('----------------------------------------------');
		write('* Indique la columna que desea usar.(1-9): ');
		readln(j);
		
		writeln('----------------------------------------------');
		write('* Ingrese un numero entero valido.(1-9): ');
		readln(numero);
		
		clrscr;
		
		//Confirmamos que el numero ingresado este en una posicion correcta
		
		if (PistasTab[i,j] = true) then
			begin
				textcolor(lightred);
				writeln('||*******************************************************||');
				writeln('|| No es posible modificar una pista, intente nuevamente ||');
				writeln('||*******************************************************||');
				writeln('');
				opcionesJuego(tabSudoku);
			end
			else 
				begin
					if validarMovimiento(tabSudoku, i, j, numero) and verifNumero(i, j, numero) and (tabSudoku[i,j] = 0) then
						begin
							tabSudoku[i,j] := numero;
							clrscr;
							textcolor(lightgreen);
							writeln('||******************************************||');
							writeln('|| Numero verificado e ingresado con exito. ||');
							writeln('||******************************************||');
							writeln('');
							mostrarTablero(tabSudoku, SolucionTab, PistasTab);
							opcionesJuego(tabSudoku);
						end
						else
							begin
								textcolor(lightred);
								writeln('||*****************************************************||');
								writeln('|| Movimiento invalido. Por favor, intente nuevamente. ||');
								writeln('||*****************************************************||');
								mostrarTablero(tabSudoku, SolucionTab, PistasTab);
								opcionesJuego(tabSudoku);
							end;
							
				end;
		end;
end;

//PROCEDIMIENTO PARA CONFIRMAR QUE EL TABLERO ESTE COMPLETO
procedure tabCompleto(var tabSudoku: Tablero);
var 
	i, j: integer;
	TabCompleto: boolean;
begin
	TabCompleto := true;
	for i := 1 to filas do
		for j := 1 to columnas do
			if tabSudoku[i,j] = 0 then
				tabCompleto := false;
				
			//SI EL TABLERO ESTA COMPLETO, SALE MENSAJE DE FELICITACIONES

			textcolor(lightgreen);
			writeln('==============================================');
			writeln('==============================================');
			writeln('** FELICITACIONES, HAS COMPLETADO EL SUDOKU **');
			writeln('==============================================');
			writeln('==============================================');
end;
//PROGRAMA PRINCIPAL
BEGIN
	textcolor(lightmagenta);
	gotoxy(10,5);
	writeln('||************************************************||');
	gotoxy(10,6);
	writeln('||             BIENVENIDO A SudokuMania           ||');
	gotoxy(10,7);
	writeln('||                "Desafia tu Mente!"             ||');
	gotoxy(10,8);
	writeln('||************************************************||');

	writeln();
	textcolor(white);
	gotoxy(10,9);
	writeln('||================================================||');
	gotoxy(10,10);
	writeln('|| Ingrese su nombre y presione ENTER             ||');
	gotoxy(10,11);
	write('|| NOMBRE: ');
	readln(nombre);
	gotoxy(10,12);
	writeln('||------------------------------------------------||');
	gotoxy(10,13);
	writeln('|| Ingrese su apellido y presione ENTER           ||');
	gotoxy(10,14);
	write('|| APELLIDO: ');
	readln(apellido);
	gotoxy(10,15);
	writeln('||------------------------------------------------||');
	gotoxy(10,16);
	writeln('|| Ingrese el NickName que desee y presione ENTER ||');
	gotoxy(10,17);
	write('|| NICKNAME: ');
	readln(NickName);
	gotoxy(10,18);
	writeln('||================================================||');
	
	clrscr;
	gotoxy(10,20);
	writeln('||================================================||');
	gotoxy(10,21);
	writeln('||              VERIFIQUE SUS DATOS               ||');
	gotoxy(10,22);
	writeln('||================================================||');
	gotoxy(10,23);
	writeln('|| NOMBRE: ', nombre);
	gotoxy(10,24);
	writeln('||------------------------------------------------||');
	gotoxy(10,25);
	writeln('|| APELLIDO: ', apellido);
	gotoxy(10,26);
	writeln('||------------------------------------------------||');
	gotoxy(10,27);
	writeln('|| NICKNAME: ', NickName);
	gotoxy(10,28);
	writeln('||================================================||');
	clrscr;
	
	repeat
		gotoxy(10,2);
		writeln('||================================================||');
		gotoxy(10,3);
		writeln('||                 ELIJA UNA OPCION               ||');
		gotoxy(10,4);
		writeln('||------------------------------------------------||');
		gotoxy(10,5);
		writeln('|| 1. Iniciar juego                               ||');
		gotoxy(10,6);
		writeln('|| 2. Salir                                       ||');
		gotoxy(10,7);
		writeln('||------------------------------------------------||');
		gotoxy(10,8);
		write('|| Indique su opcion y presione ENTER: ');
		readln(opcion);
		clrscr;
		
		if opcion=1 then
			begin
				textcolor(lightblue);
				gotoxy(11,1);
				writeln('||================================================||');
				gotoxy(11,2);
				writeln('||       HORA DE DESAFIAR TU MENTE AL MAXIMO      ||');
				gotoxy(11,3);
				writeln('||      QUE LA SUERTE ESTE SIEMPRE DE SU LADO!    ||');
				gotoxy(11,4);
				writeln('||================================================||');
				delay(3000);
				textcolor(white);
				inicioPistas(tabSudoku, PistasTab);
				
				repeat
					opcionesJuego(tabSudoku);
					gotoxy(28,15);
					write('|| Indique su opcion y presione ENTER: ');
					readln(op);
					case op of
						1: begin
							introducirNumero(tabSudoku, PistasTab);
							if solucionSudoku(tabSudoku) then
								begin
									tabCompleto(tabSudoku);
									Break;
								end;
						end;
						
						2: begin
							modificarNumero(tabSudoku, PistasTab);
						end;
						
						3: begin
							rendirse(tabSudoku, PistasTab, SolucionTab);
						end;
					end;
				until (op = 4);

			end
			else 
				if opcion <> 2 then
					writeln('|| Opcion invalida, seleccione una opcion valida. ||');
	until (opcion = 2);
	
	begin
		textcolor(yellow);
		writeln('||================================================||');
		writeln('||      GRACIAS POR SU VISITA, VUELVA PRONTO.     ||');
		writeln('||================================================||');
	end;
END.


{Elaborado por:
* Paola Márquez. C.I: 27.125.784
* Enderson Velasquez. C.I: 30.141.384}
