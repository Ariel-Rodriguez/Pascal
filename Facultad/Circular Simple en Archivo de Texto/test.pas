program Test;

(*
  Genero una lista circular simple con datos numericos aleatorios ordenados ascendentemente por insercion
  y los vuelco en un archivo de texto en el mismo directorio del .exe
*)

Type 
   // lista simple circular
	TLista = ^TNodoLista;
	TNodoLista = Record
		Dato : Integer;
		Sig  : TLista;
	End;
	
	// Archivo de texto plano
	TArchivo = Text;

Procedure CrearNodo (var PNodo : TLista;Dato : Integer);
Begin
	New (PNodo);
	PNodo^.Dato := Dato;
	PNodo^.Sig := PNodo;
End;

Procedure InsertarOrdenado(var Lista : TLista;Dato : Integer);
var
	Nuevo,Cur : TLista;
Begin
	CrearNodo (Nuevo,Dato);
	If Lista = Nil then
		Lista := Nuevo
	Else
	Begin
		Cur := Lista;
		If (Lista^.Dato > Dato) then // si el nuevo dato es menor que el primero de la lista
			Begin
				While (Cur^.Sig <> Lista) do // voy hasta el final, que seria el anterior del primero (el primero es Lista)
					Cur := Cur^.Sig;
				Nuevo^.Sig := Lista;
				Cur^.Sig := Nuevo;
				Lista := Nuevo; // la lista empieza desde el menor
			End
		Else	
			Begin
				While (Cur^.Sig <> Lista) And (Cur^.Sig^.Dato < Dato) do // el nuevo dato no va a ser primero pero puede ser el ultimo
					Cur := Cur^.Sig;
				Nuevo^.Sig := Cur^.Sig;
				Cur^.Sig := Nuevo;	
			End;
	End;		
End;
	
Procedure EscribirEnArchivo(var Arch : TArchivo;Lista : TLista);
var 
	cur : Tlista;
Begin
	Assign (Arch,'resultado.txt');
	{$I-}
		Rewrite (arch);
	{$I+}
	If (ioresult <> 0) then
		writeln('Error en escribir el archivo')
	Else
	If (Lista<>Nil) then
	Begin	
		writeln(arch,lista^.dato);
		cur := Lista^.sig;
		While (lista <> cur) do begin
			writeln(arch,cur^.dato);
			cur := cur^.sig;
		End;
	 close (Arch);	
	End;
		
End;	
	
var
	Archivo : TArchivo;
	Lista : TLista;	
    c : integer;
Begin
	Randomize;
	Lista := nil;
	For c:=10 downto 1 do
		InsertarOrdenado (Lista,random(30));
	EscribirEnArchivo (Archivo,Lista);	
End.