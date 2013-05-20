Program Balance;


Type
	
	TRecFecha = Record
		Tiempo  :  LongInt; //
	End;
	
	TArbol = ^TNodoArbol;
	TNodoArbol = Record
		Fecha   : TRecFecha;
		Izq,Der : TArbol;
	End;	

Procedure GenerarFecha (var Fecha:TRecFecha;D,M,A:Byte);
Begin
	Fecha.Tiempo := D + M * 31 + (A) * 365;
End;
	
Procedure AgregarNodoListaSimple(Var Lista : TArbol;Nodo:TArbol);
Begin
	IF (Lista=NIL) then
		Lista := Nodo
	Else
		AgregarNodoListaSimple(Lista^.Der,Nodo);
End;	
	
Procedure GenerarListaSimple (var Lista : TArbol;Cant : Integer);
var
	C : Byte;
	Nuevo : TArbol;
Begin
	For c:=1 to Cant do
		Begin
			New (Nuevo);
			GenerarFecha(Nuevo^.Fecha,13 + C,3,011);
			Nuevo^.Der := NIL;
			AgregarNodoListaSimple (Lista,Nuevo);
		End;
End; 

// Devuelve
// Si hay 4 elementos en la lista y es dedse 1 hasta 4 devuelve el 3 elemento
Function NodoDeMitad (Desde,Hasta:Integer;Lista:TArbol):TArbol;
Begin
	Hasta := (Hasta - Desde) div 2+1; 
	While (Lista<>NIL) and (Desde > 1) do
	Begin
		Dec(Desde);
		Lista := Lista^.Der;
	End;
//	Desde := 0;
	While (Lista<>NIL) and (Desde < Hasta) do
	Begin
		Inc(Desde);
		Lista := Lista^.Der;
	End;
	NodoDeMitad := Lista;
End;


Procedure CrearNuevoNodo(var Nodo:TArbol;Fecha:TRecFecha);
Begin
	New (Nodo);
	Nodo^.Fecha := Fecha;
	Nodo^.Der := NIL;
	Nodo^.Izq := NIL;
End;

Procedure GenerarArbolBalanceado (Var Arbol:TArbol;Desde,Hasta:Integer;Lista:TArbol);
var
	Absoluto : Integer;
Begin
	Absoluto := Hasta - Desde; //abs(desde - hasta)
	If (Absoluto > 1) Then
	Begin
		CrearNuevoNodo (Arbol,NodoDeMitad(Desde,Hasta,Lista)^.Fecha);	
		GenerarArbolBalanceado (Arbol^.Izq,Desde,Desde + Absoluto Div 2 - 1,Lista);
		GenerarArbolBalanceado (Arbol^.Der,Desde + Absoluto Div 2 +1,Hasta,Lista);
	End
		Else
		Begin
		CrearNuevoNodo (Arbol,NodoDeMitad(Desde,Desde,Lista)^.Fecha);
		If (Absoluto = 1) then
			CrearNuevoNodo (Arbol^.Der,NodoDeMitad(Hasta,Hasta,Lista)^.Fecha);	
		End;
End;

Procedure ImprimirLista (Lista:TArbol);
Begin
	While(Lista<>NIL) do
		Begin
			Writeln(Lista^.Fecha.Tiempo);
			Lista := Lista^.Der;
		End;
End;

Procedure ImprimirArbol(Arbol:TArbol);
Begin
 If (Arbol<>NIL) Then
 Begin
	ImprimirArbol (Arbol^.Izq);
	Writeln(Arbol^.Fecha.Tiempo);
	ImprimirArbol(Arbol^.Der);
End;
End;

var
	Arbol,ListaSimple : TArbol;

Begin
	ListaSimple := NIL;
	GenerarListaSimple (ListaSimple,8);
	Writeln('** Generando lista con 8 elementos **');
	ImprimirLista(ListaSimple);
	Writeln('** Mostrar la lista a partir de la mitad **');
	ImprimirLista(NodoDeMitad(1,8,ListaSimple));
	Arbol := NIL;
	writeln('*** De la lista Solo cargar en forma balanceada desde el elemnto 2 hasta el 6 **');
	GenerarArbolBalanceado (Arbol,2,6,ListaSimple);
	ImprimirArbol(Arbol);
End.



