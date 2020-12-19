    '#Include Once "windows.bi" 
    #include once  "file.bi"
    'Jose M Galeano pequeña Tool simple de busqueda 
    ' por nombre completo o parcial, y/o 1 o hasta 10 extensiones
    ' por consola, compilar con windows console
    ' para mayor performance usar flags de gcc
    ' puede haber nombres muy largos que no soporta 
    Dim As String text, filename, text1, extension
    Dim  filetype(1 To 10) As String
    
    Dim aop As String
    Dim Shared NRO As double
    Dim As Integer cant, i, cont, result  
    Declare Sub aviso ()        
    'Screen 20, 32, 1          
    'Color &h000040, &h008080
    do
    cls
    'locate 2, 2
    print " Buscar archivo desde donde se esta posicionado v 1.0"
    Print " un Nombre de archivo y/o hasta 10 Extensiones."
    Print " El Nombre o la/las Extension pueden estar en blanco  "
     

    Input "Entre  parte del [N]ombre : ", filename
    
    Input "Absoluto o parcial aA/Pp: ", aop
    cant=0
    Input "Entre hasta 10 [E]xtensiones de a una, nada para terminar y/o todas: ", extension
     If (filename = "")  And (extension = "") then
      Print "ingrese alguna parte de un nombre  o alguna extension"
      
     Else
      Exit do
     EndIf 
    Loop
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
    
    filename = RTrim(LTrim(UCase(filename)))
    aop     = RTrim(LTrim(UCase(aop)))
    
 'Print "len filename "; Len (filename)
 'Print "len extension "; Len (extension)
    
    If aop ="A" Then
    	 filename="\"+filename
    EndIf
 ' ===================================   
    open Pipe "dir *.* /b /s" for input as #1
    dim Shared blink as Short = 0
     
    Dim Shared As String aviso1,aviso2, aviso3 
    aviso1="/"
    aviso2="\"
    aviso3="-"
       Dim flagtype As BOOLEAN = FALSE
       Dim flagname As Boolean = FALSE
       Dim as Integer lenExtension, lenText1, posi
   Cls
   NRO = 0
   Do While Not Eof(1)
 	   Line Input #1, text1
     text1 = UCase(text1)
     If NRO >= 0  Then aviso() endif 
     If filename = "" Then ' hay solo extensiones
             For i = 1 To cant            
              posi = InStr(text1, filetype(i))
              If (posi > 0 ) Then
               lenExtension = Len(filetype(i))
               lenText1 = Len(text1)
               'verificacion si es extension
                If (lentext1 - lenExtension + 1) = posi Then
                  ' es una extension
                   Print " [E]"; text1
                   NRO = NRO + 1
                   If NRO = 50 Then
                     Print "presione para mas..."
                      NRO = 0
                     Sleep
                   EndIf
                Endif
              EndIf
             Next i 
        
     Else
     	If filetype(1) > ""  Then ' hay nombre y al menos 1 extension
            
            flagtype = FALSE
            flagname = FALSE
            If  InStr(text1, filename) > 0 Then
            	  flagname = TRUE
            EndIf
            
            For i = 1 To cant
              If InStr(text1, filetype(i) ) > 0 Then
            	    flagtype = TRUE 
              EndIf
             
            	 
              If flagname And flagtype Then
                print " [NE]"; text1
                NRO = NRO + 1
                 If aop="A" Then
                    NRO=50
                    Print "match completo nombre y extension"
                 EndIf

                If NRO = 50 Then
                  Print "presione para mas.."
                   NRO = 0
                   If aop="A" Then
                     NRO=0
                   EndIf

                  Sleep
                EndIf  
              End If
            Next i   
        
     	EndIf  
     EndIf
     
   If filetype(1) = ""  Then ' solo hay nombre 
       If InStr(text1, filename) > 0  Then
           print " [N]> "; text1
            NRO = NRO + 1
             If NRO = 50 Then
              Print "presione para 50 mas.."
              NRO = 0
              Sleep
             EndIf
       EndIf

   EndIf
Loop

    close #1

  Print "FIN => "
  print "Fin de la busqueda  Presione para salir...." 
  Print "Si termina inesperadamente antes, algun nombre tiene el caracter -> "
  Print " fin de archivo, cerca del archivo en FIN=> , renombrarlo o borrarlo "
    
    sleep
    End
 Sub aviso ()
  Dim fila As Integer
     fila = CsrLin
 	   if blink= 0 Then
   	    blink = blink + 1
   	    Locate fila -1 ,1
        Print aviso1
                 
 	   Else 
        If blink = 50 Then
           Locate fila -1 ,1
           Print aviso2
           blink=0
        Else
      	    blink = blink + 1
        End If
        If blink = 25 Then
           Locate fila -1 ,1
           Print aviso3
      	    blink = blink + 1
        End If

 	   EndIf
 
 End Sub
   