    '#Include Once "windows.bi" 
    #include once  "file.bi"
    'Jose M Galeano pequeña Tool simple de busqueda 
    ' por nombre completo o parcial, y/o 1 o hasta 10 extensiones
    ' por consola, compilar con windows console
    ' para mayor performance usar flags de gcc
    ' puede haber nombres muy largos que el pipe  no soporta 

    Dim As String text, filename, text1, extension,com, barra,tipo
    Dim  filetype(1 To 10) As String
    
    Dim  As BOOLEAN carpeta, encontro
        
    Dim Shared NRO As UInteger<64>
    Dim As UInteger<64> nume, control
    Dim As Integer cant, i, cont, result
     
      
            
    'Screen 20, 32, 1          
    'Color &h000040, &h008080
    do
    cls
    'locate 2, 2
    print " Buscar archivo desde donde se esta posicionado v 1.2"
    Print " un Nombre completo o parcial de archivo y/o hasta 10 Extensiones."
    Print " El Nombre o la/las Extension pueden estar en blanco  "
     

    Input "Entre [N]ombre : ", filename
     
    print " Si es nombre completo o primeras letras del nombnre siga,"
    Input " si no entre cualquier letra ", com 
    

    cant=0
    Input "Entre hasta 10 [E]xtensiones de a una, Nada para terminar : ", extension
     If (filename = "")  And (extension = "") then
      Print "ingrese alguna parte de un nombre  o alguna extension"
      
     Else
      Exit do
     EndIf 
    Loop
    Dim anv As String 
  
    Do
      If extension > "" Then
      	extension = "."+ RTrim(LTrim(UCase(extension)))
      	cant=cant + 1
      	filetype(cant) = extension
         Print "Entre Extension "; cant + 1 ; " : ";
         Input  extension
         print
      Else
        Exit Do
      EndIf    
    Loop
    Input "archivo nuevo [N/n] o viejo [V/v] ", anv
    anv=UCase(RTrim(LTrim(anv)))
    
    filename = RTrim(LTrim(UCase(filename)))

    
 ' ===================================   
    Dim comBus As String
    ' nombre completo o comienzo de nombre CON extensiones 
    If com =""  And filename > "" And filetype(1) > "" Then 
       For i = 1 To cant
        combus= combus + filename + "*" + filetype(i) + " "
       Next
      tipo="[NE]"
    EndIf
    ' nombre completo o comienzo de nombre incompleto SIN extensiones
    If com =""  And filename > "" And filetype(1) = "" Then 
        combus= filename + "*" 
        tipo="[N]"
    EndIf

    ' nombre incompleto, No es comienzo, CON extension 
     
    If com <> ""  And filename > "" And filetype(1) > "" Then 
       For i = 1 To cant
        combus= combus + "*" +filename + "*" + filetype(i) + " "
       Next
       tipo="[NE]"
    EndIf
    ' es elcaso de nombre de carpeta
    ' nombre incompleto, No es comienzo, SIN extension 
    If com <>"" And filename >"" And filetype(1) = "" Then 
        combus= "*" + filename + "*" 
        tipo="[N]"
    EndIf

    ' si hay nombre y no hay extensiones ordena por nombre
    If filename > "" And filetype(1) = "" Then
        comBus= combus + " /ON"
    EndIf
    ' si hay nombre y hay extensiones ordena por extension
    If filename >= "" And filetype(1) > "" Then
     comBus = combus + " /OE" 
    EndIf
    ' si es archivo mas nuevo ordenar ascendente 
    If anv =  "N" Then
     comBus = comBus + " /-D"
    EndIf
    ' si es archivo mas viejo ordenar descendente
    If anv > "V" Then
     comBus = comBus + " /D"
    EndIf
    
' --------- open PIPE -------  
    comBus = "dir /b /s " + comBus
    
    open Pipe comBus  For input as #1
    
    Dim flagtype As BOOLEAN = FALSE
    Dim flagname As Boolean = FALSE
    Dim as uInteger lenExtension, lenText1,lenfilename
    Dim As UInteger posif,posib, posie
    Dim USER As String
     
   Cls
   'Print comBus
   NRO = 0
   lenfilename = len(filename)
   ' ======== LOOP =============
   Do While Not Eof(1)
 	   Line Input #1, text1
 	   'evitar C:\$Recycle.Bin 
 	   If InStr(text1,"C:\$Recycle.Bin") > 0 Then
 	     Continue do
 	   EndIf
 	   ' evitamos directorios de programas inicio con punto.
 	   If InStr(text1,"C:\.") > 0 Then
 	     Continue do
 	   EndIf
 	   USER=Environ("USERPROFILE")
 	   USER=USER +"\."
 	   If InStr(text1, USER) > 0 Then
 	     Continue do
 	   EndIf

 	   nume= nume + 1
 	   control = control + 1
 	   If control=500000 Then
 	     Print "cantidad analizados "; nume
 	      control = 0
 	   EndIf
 	   
 	     Print tipo + text1
       
   Loop

    Close #1

  Print "FIN => "
  print "Fin de la busqueda  Presione para salir...." 
  Print "Si termina inesperadamente antes, algun nombre tiene el caracter -> "
  Print " fin de archivo, cerca del archivo en FIN=> , renombrarlo o borrarlo "
  Print "cantidad de archivos barridos "; nume
    
    sleep
    End
   