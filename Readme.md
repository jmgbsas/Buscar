# BUSCAR (find), sencilla tool en FreeBasic para Consola, sin flags.
```
  Absoluta es todo el nombre completo despues de "\" en windows, donde comienza un nombre.
 Parcial puede estar en cualquier parte del path, se puede adaptar en linux a la "/" de
 separacion. 
```
- Tool en Freebasic para windows, busca por Nombre o parte de el y alguna o varias 
  extensiones hasta 10, desde el lugar donde se este posicionado (2015) version 1.0 
- Imprime por pantalla el path completo, como todas las tools. Para mejor uso ponerlo 
  el cualqueir lugar del PATH.
- compiled for amd64 fbc -s console -arch amd64 -gen gcc -O 2
- La meta es buscar en una maquina sin indexacion, deshabilitada por performance.
  No es multi hilo, solo una busqueda serial usando pipe.
  En la 2da busqueda, si la 1era fue larga, parece que hace uso del cache de windows 
  y la 2da o posteriores busquedas son bastante rapidas, por eso no conviene cerrar
  la consola si se van hacer varias busquedas.
  Hace falta muchas mejoras pero es comoda, la uso bastante desde hace mucho.


