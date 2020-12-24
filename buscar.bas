    '#Include Once "windows.bi" 
    #include once  "file.bi"
    'Jose M Galeano pequeña Tool simple de busqueda 
    ' por nombre completo o parcial, y/o 1 o hasta 10 extensiones
    ' por consola, compilar con windows console
    ' para mayor performance usar flags de gcc
    ' puede haber nombres muy largos que no soporta 
    Declare Sub aviso ()
    Dim As String text, filename, text1, extension,com, barra
    Dim  filetype(1 To 10) As String
    
    Dim aop As String
    Dim Shared NRO As UInteger<64>
    Dim nume As UInteger<64>
    Dim As Integer cant, i, cont, result
     
      
            
    'Screen 20, 32, 1          
    'Color &h000040, &h008080
    do
    cls
    'locate 2, 2
    print " Buscar archivo desde donde se esta posicionado v 1.1"
    Print " un Nombre completo o parcial de archivo y/o hasta 10 Extensiones."
    Print " El Nombre o la/las Extension pueden estar en blanco  "
     

    Input "Entre [N]ombre : ", filename
     
    Input " Si es nombre completo o es parte del comienzo siga, si no entre cualquier letra ", com 
    
'    Input "Absoluto o parcial aA/Pp: ", aop
    cant=0
    Input "Entre hasta 10 [E]xtensiones de a una, nada para terminar y/o todas: ", extension
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
    ' aop     = RTrim(LTrim(UCase(aop)))
    
 'Print "len filename "; Len (filename)
 'Print "len extension "; Len (extension)
    
    If com = "" Then
    	 filename="\"+filename
    EndIf
 ' ===================================   
    Dim comBus As String 
    If filename > "" And filetype(1) = "" Then
        comBus="dir *.* /b /s /ON"
    EndIf
    If filename >= "" And filetype(1) > "" Then
     comBus = "dir *.* /b /s /OE" 
    EndIf
    If anv =  "N" Then
     comBus = comBus + " /-D"
    EndIf
    If anv > "V" Then
     comBus = comBus + " /D"
    EndIf
    open Pipe comBus  for input as #1
    dim Shared blink as Short = 0
     
    Dim Shared As String aviso1,aviso2, aviso3 
    aviso1="/"
    aviso2="\"
    aviso3="-"
       Dim flagtype As BOOLEAN = FALSE
       Dim flagname As Boolean = FALSE
       Dim as Integer lenExtension, lenText1, posif,posib,lenfilename,posie
       Dim USER As String
     
   Cls
   NRO = 0
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
     text1 = UCase(text1)

     If filename = "" Then ' hay solo extensiones
             For i = 1 To cant            
              posie = InStrRev(text1, filetype(i))
              If (posie > 0 ) Then
               lenExtension = Len(filetype(i))
               lenText1 = Len(text1)
               'verificacion si es extension
                If (lentext1 - lenExtension + 1 = posie) Then
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
      posif = InStrRev(text1,filename)
      If posif > 0 Then
         flagname = true
      EndIf
     	If filetype(1) > "" And posif > 0  Then ' hay nombre y al menos 1 extension
            'Print "DBG>";text1
            flagtype = FALSE
            
            ' existe pero podria ser del path no del archivo
            ' buscamos el separodor \ si es el ultimo o no
            ' verificamos que este al final del path antes de 
            ' la extension archivo
            lenText1 = Len(text1)
                 
            posib=InStrRev(Text1,"\")
            if posif <> posib  And com =""  Then 
               flagname=FALSE  

            EndIf
                 
              
            
           
            For i = 1 To cant
              If InStr(text1, filetype(i) ) > 0 Then
                 lenExtension = Len(filetype(i))
                posie = InStrRev(text1, filetype(i)) 
               'verificacion si es extension
                If (lentext1 - lenExtension + 1 = posie) Then
             	    flagtype = TRUE 
                EndIf
              EndIf
             
            	 
              If flagname And flagtype Then
                print " [NE]"; text1
                NRO = NRO + 1

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
            flagname = FALSE

            posif = InStrRev(text1,filename)     
            posib=InStrRev(Text1,"\")
      
               If posif = i Then 
                   flagname=TRUE
               endif   
            

       If flagname  Then
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
  Print "cantidad de archivos barridos "; nume
    
    sleep
    End
Sub aviso ()
  ' baja la performance se congela de a ratos no usar
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
   