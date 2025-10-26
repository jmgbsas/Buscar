
#include once "windows.bi"
' se agrega opcion de grabar archivo em directorio local o si estamos en raiz c:
' grabar en un archivo dentro de una directoio dado
' agregamos busqueda por tamaño  compilado para amd64 v3
'   fbc64 -gen gas64 -t 65536 -fpu SSE -arch amd64 -exx    nuevo
'   fbc64 -gen gcc -t 65536 -fpu SSE -arch amd64    viejo  
 #include once  "file.bi"
#Include "foro/window9.bi"

    'Jose M Galeano pequeña Tool simple de busqueda 
    ' por nombre completo o parcial, y/o 1 o hasta 10 extensiones y/o size
    ' por consola, compilar con windows console
    ' para mayor performance usar flags de gcc
    ' puede haber nombres muy largos que no soporta 
   ''' Print FileLen("C:\IT64\BUSCAR")
 ''''End
 ' falta recorer las extensiones en algunos casos SEGUIR

    Dim As String text, filename,  extension, directorio
    Dim  filetype(1 To 10) As String
    Dim Shared As String directorios(1 To 10)
    Dim aop As String
    Dim Shared NRO As UInteger<64>
    Dim nume As UInteger<64>
    Dim Shared As Integer cant, i, cont, tamdesde, tamhasta, longitud, grabar=0,paginado=0,dires=0   
    Declare Sub tama ()        
    Dim Shared As String tipo, text1, lugar
    dim Shared blink as Short = 0
    'Screen 20, 32, 1          
    'Color &h000040, &h008080
 Do

    Cls
    'locate 2, 2
    print " Buscar archivo desde donde se esta posicionado v 2.0 por nombre extension o size"
    Print " un Nombre de archivo y/o hasta 10 Extensiones."
    Print " El Nombre o la/las Extension pueden estar en blanco  "
    Print " Un tamaño sugerido a partir del cual mostrar  y otro donde no mostrar mas " 
    Print "Autor:Jose M Galeano Bs As argentina"
    Print "En la raiz de C:\ el sistema no suele dejar grabar, si no trabaja en raiz no habra problema"
    Print " para buscar desde la raiz de C:\ y grabar ingresaremos un archivo y el path"
    Input "Entre  parte del [N]ombre : ", filename
    
    Input "Absoluto o parcial aA/Pp: ", aop
    cant=0
    Input "Entre hasta 10 [E]xtensiones de a una, nada para terminar y/o todas: ", extension
    Input "Entre tamaño 1 desde ", tamdesde
    Input "Entre tamaño 2 hasta ", tamhasta
    Input "Graba el resultado en Veo.txt ? 1 si 0 o enter no ", grabar
    Input "paginado por pantalla ? 1 si 0 o enter no ", paginado
    Input "Selecciona hasta 10 directorios en los cuales buscar ? Cantidad en numero, si, 0 ó enter, no ",dires

    If grabar=1 Then
       Input "directorio donde grabar, solo si  estamos en raiz ", directorio
       If directorio > "" Then
          directorio=Trim(directorio) 
          Open "c:\" + directorio + "\Veo.txt" For Output As 2
       Else
          Open "Veo.txt" For Output As 2
       EndIf 
    EndIf
    If dires >0  Then
       Dim As String nameCurDir="c:\" ''''CurDir
''' lugar=ShellFolder("SELECCION DE CARPETA", nameCurDir, BIF_RETURNONLYFSDIRS Or BIF_USENEWUI)
'''   DirEjecSinBarra=lugar
'' falta una funcion que me deje seleccionar varias carpetas y me devuelva un
'' array con los path de los directorios
Print 
For i = 1 To dires 
directorios(i) = ShellFolder( "Seleccionar Carpeta de Cancion", nameCurDir)
 Print i,directorios(i)
Next i
    EndIf

    If (filename = "")  And (extension = "") And tamdesde=0 And tamhasta=0 Then
        Print "ingrese alguna parte de un nombre  o alguna extension o tamaño"
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
         Print
      Else
         Exit Do     
      EndIf    
    Loop

    Input "archivo nuevo [N/n] o viejo [V/v] ", anv
    anv=UCase(RTrim(LTrim(anv)))
    
    filename = RTrim(LTrim(UCase(filename)))
    aop     = RTrim(LTrim(UCase(aop)))
    
 'Print "len filename "; Len (filename)
 'Print "len extension "; Len (extension)
    
    If aop ="A" Then
    	 filename="\"+filename
    EndIf
 ' ===================================
Dim j2 As integer
     
    Dim As String comBus
    
For j2 = 1 To dires 
    Print "directorio ", directorios(j2)
    directorio=directorios(j2)
    Shell "cd " + directorio
    If filename > "" And filetype(1) = "" Then ' solo nombre
        comBus="dir *.* /b /s /ON"
    EndIf
    If filename >= "" And filetype(1) > "" Then  ' puede o no haber nombre y si hay extension
     comBus = "dir *.* /b /s /OE" 
    EndIf
    If filename = "" And filetype(1) = "" Then ' nada
        comBus="dir *.* /b /s /O-S"
    EndIf

    If anv =  "N" Then
     comBus = comBus + " /-D"
    EndIf
    If anv > "V" Then
     comBus = comBus + " /D"
    EndIf
    Print "ORDEN: "; comBus
    ChDir directorios(j2)
    Sleep 100
    open Pipe comBus  for input as 1

     
    Dim flagtype As BOOLEAN = FALSE
    Dim flagname As Boolean = FALSE
    Dim as Integer lenExtension, lenText1, posi
    Dim USER As String
   ''-----cls no va
   NRO = 0
Print "directorio " ,directorio
Print "combus ",combus
   Do While Not Eof(1)
 	   Line Input #1, text1
 	   'evitar C:\$Recycle.Bin 
 	   If InStr(text1,"C:\$Recycle.Bin") > 0 Or InStr(text1,"C:\$WINDOWS") > 0 Then
 	     Continue do
 	   EndIf
 	   ' evitamos directorios de programas
 	   ''If InStr(text1,"C:\.") > 0 Then
 	   ''  Continue do
 	   ''EndIf
 	   USER=Environ("USERPROFILE")
 	   USER=USER +"\."
 	   If InStr(text1, USER) > 0 Then
 	     Continue do
 	   EndIf

     nume= nume + 1
     text1 = UCase(text1)
     'If tamano1 > 0 Or tamano2 > 0 Then
        'interesa mostrar filtrado por tamaño  
     'EndIf
     If filename = "" And filetype(1) > "" Then '  no hay nombre y hay al menos 1 extension  
             For i = 1 To cant  'barro todas las extensiones          
              posi = InStr(text1, filetype(i))
              If (posi > 0 ) Then
               lenExtension = Len(filetype(i))
               lenText1 = Len(text1)
               'verificacion si es extension
                If (lentext1 - lenExtension + 1) = posi  Then
                 ' Print " es una extension ", tamdesde ,tamhasta
                   If tamdesde > 0 Or tamhasta > 0 Then
                  '    Print "tamdesde, tamhasta  ",tamdesde , tamhasta
                      longitud=FileLen(text1)
                      tipo= "" 
                      If tamdesde > 0 And longitud >= tamdesde And tamhasta=0 Then
                         tipo = " [ET1]"
                      EndIf 
                      If tamdesde > 0 And tamhasta > 0 And longitud >= tamdesde And longitud <= tamhasta Then
                         tipo = " [ET12]"
                      EndIf 
                   Else
                      longitud=0
                      tipo = " [E]"
                   EndIf 
                   If  tipo > "" Then 
                       tama()
                   EndIf 
                Endif
              EndIf
             Next i 
        
     EndIf
     If filename > "" And filetype(1) > ""  Then ' hay nombre y al menos 1 extension
            
            flagtype = FALSE
            flagname = FALSE
            If  InStr(text1, filename) > 0 Then
            	  flagname = TRUE
            EndIf
            
            For i = 1 To cant
              If InStr(text1, filetype(i) ) > 0 Then
                 posi = InStr(text1, filetype(i))
                 If (posi > 0 ) Then
                    lenExtension = Len(filetype(i))
                    lenText1 = Len(text1)
                  'verificacion si es extension
                    If (lentext1 - lenExtension + 1) = posi  Then
                       flagtype = TRUE
                    EndIf 
                 EndIf        
              EndIf     	 
              If flagname And flagtype  Then
                 tipo= "" 
                 ''Print "flagname And flagtype trues"
                If tamdesde=0 And tamhasta=0 Then
                   longitud=0
                   tipo = " [NE]"
                Else
                   longitud=FileLen(text1)
                   If tamdesde > 0 And longitud >= tamdesde And tamhasta=0 Then
                     tipo=" [NET1]"
                   EndIf
                   If tamdesde > 0 And tamhasta > 0 And longitud >= tamdesde And longitud <= tamhasta Then
                     tipo=" [NET12]"
                   EndIf 
                EndIf
                If tipo > "" Then
                   tama() 
                EndIf 
              EndIf
            Next i   
     EndIf 
     If filename="" And filetype(1) = ""  Then ' ni nombre ni extension
          If tamdesde > 0 Or tamhasta > 0 Then
         '    Print "tamdesde, tamhasta  ",tamdesde , tamhasta
             longitud=FileLen(text1)
             tipo = "" 
             If tamdesde > 0 And longitud >= tamdesde And tamhasta=0 Then
                tipo = " [T1]"
             EndIf 
             If tamdesde > 0 And tamhasta > 0 And longitud >= tamdesde And longitud <= tamhasta Then
                tipo = " [T12]"
             EndIf
             If tipo > "" Then
                tama() 
             EndIf 

          EndIf 
     EndIf   

     If InStr(text1, filename) > 0  And filetype(1) = "" Then
            
         If tamdesde > 0 Or tamhasta > 0 Then
         '    Print "tamdesde, tamhasta  ",tamdesde , tamhasta
               longitud=FileLen(text1)
               tipo = "" 
               If tamdesde > 0 And longitud >= tamdesde And tamhasta=0 Then
                tipo = " [NT1]"
               EndIf 
               If tamdesde > 0 And tamhasta > 0 And longitud >= tamdesde And longitud <= tamhasta Then
                tipo = " [NT12]"
               EndIf
         Else
          longitud=0
             tipo = " [N]"
         EndIf
         If tipo > "" Then
           tama() 
         EndIf
  
 	  EndIf  
    
     
   Loop
Close 1
Next j2
If grabar=1 Then
 Close 2
EndIf
   
     '' si pongo los numeros close 1,2 aborta la puta que te pario freebasic jajajaj 
''Next j2

  Print "FIN => "
  print "Fin de la busqueda  Presione para salir...." 
  Print "Si termina inesperadamente antes, algun nombre tiene el caracter -> "
  Print " fin de archivo, cerca del archivo en FIN=> , renombrarlo o borrarlo "
  Print "cantidad de archivos barridos "; nume
  Print "Pulse para cerrar "  
    Sleep
    End
Sub tama()
    Print tipo; text1
    If grabar=1 Then
       Print #2, text1 
    EndIf
    If  longitud> 0 Then 
       Print " ";longitud
    EndIf  
    NRO = NRO + 1
    If NRO = 20 Then
       If paginado=1 Then
         Sleep
         Print "presione para mas..."
       EndIf
       NRO = 0
    EndIf

End Sub   
