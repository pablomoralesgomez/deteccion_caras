# Deteccion Caras

**AVISO importante**, para la correcta ejecución del código es necesaria la descarga de la librería CVImage y la inclusión en la carpeta de data del [modelo de detección de rostros](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818) que se puede encontrar en el repositorio del enlace.

## Introduccion

En esta práctica hemos hecho uso de la detección de gestos y caras para realizar interacciones con la imagen que muestra el programa al ejecutarse.


## Desarrollo

En este proyecto hemos hecho uso de la librería CVImage y del [modelo de detección de rostros](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818) anteriormente mencionado, para poder tener y hacer uso de un *facial landmark detection*. Concretamente hemos dedicado este trabajo a detectar cuando el usuario que está siendo grabado abre la boca.

Para la detección de la apertura de los labios hemos empleado 6 puntos del *facial landmark detection* que se encuentran justo en el centro de los mismos. Haciendo una rápida comparación de la ubicación de esos puntos entre sí, podemos discernir con bastante poco error si la boca se encuentra abierta o no.

Cuando esta se encuentra abierta se aplica un efecto a los píxeles que componen la imagen que muestra la aplicación. Actualmente solo hay dos efectos:

- RGB Maximo: que enseña el componente RGB contiene el mayor valor en el píxel.
- Umbralizado: que aplica un proceso de umbralización.

Por último, para modificar el efecto aplicado al abrir la boca se deben usar las flechas del teclado *LEFT* y *RIGHT*. Así mismo, en la esquina superior izquierda se ha incluido un pequeño slector que nos muestra el efecto que se aplicará en ese momento.


## Previsualizacion de la Aplicación

<p align="center"> <img src="animacion.gif" alt="gif animado" /> </p>
