CREATE DATABASE desafio3_marcelo_perez_123;

/* Crear tabla de usuarios*/

CREATE TABLE usuarios (
  id serial PRIMARY KEY,
  email varchar(50),
  nombre varchar(50),
  apellido varchar(50),
  rol varchar(50)
);

/* Crear tabla de posts*/

CREATE TABLE posts (
  id serial PRIMARY KEY,
  titulo varchar,
  contenido text,
  fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion timestamp DEFAULT CURRENT_TIMESTAMP,
  destacado boolean,
  usuario_id bigint
);


/* Crear tabla de comentarios*/

CREATE TABLE comentarios (
  id serial PRIMARY KEY,
  contenido text,
  fecha_creacion timestamp,
  usuario_id bigint,
  post_id bigint
);

/* Insertar usuarios*/

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES 
  ('correo1uno@gmail.com', 'user1', 'one', 'usuario'),
  ('correo2dos@gmail.com', 'user2', 'two', 'usuario'),
  ('correo3tres@gmail.com', 'user3', 'three', 'administrador'),
  ('correo4cuatro@gmail.com', 'user4', 'four', 'usuario'),
  ('correo5cinco@gmail.com', 'user5', 'five', 'usuario');


/* Insertar posts*/

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Hoy obtuve una guitarra', 'Debo aprender como se toca', '2023-04-19 21:01:37.364334', NOW(), true, 3),
('El mejor pedal para iniciar', 'Distorsión', '2023-04-20 21:01:37.364334', NOW(), true, 3),
('Como cuidar tu guitarra', 'tips para obtener una gran duración y sonido de tú guitarra', '2023-04-21 21:01:37.364334', NOW(), false, 4),
('Mejorar tocando', 'Ejercicios para tocar como siempre haz querido', '2023-04-22 21:01:37.364334', NOW(), false, 5),
('Mejores guitarras', 'Estás son las mejores guitarras para iniciar y para experimentados', '2023-04-23 21:01:37.364334', NOW(), false, NULL);


/* Insertar comentarios*/

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡Gran post de guitarras!', '2023-04-25 21:01:37.364334', 1, 1),
('Me encantó', '2023-04-26 21:01:37.364334', 2, 1),
('Interesante', '2023-04-27 21:01:37.364334', 3, 1),
('Gracias', '2023-04-28 21:01:37.364334', 1, 2),
('Buena información', '2023-04-29 21:01:37.364334', 2, 2);

/*2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre e email del usuario junto al título y contenido del posts.*/


SELECT a.nombre, a.email, b.titulo, b.contenido  FROM usuarios AS a INNER JOIN posts AS b ON a.id = b.usuario_id;

/* 3. Muestra el id, título y contenido de los posts de los administradores. El
administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
.*/

SELECT id AS id_post, titulo, contenido FROM posts 
WHERE usuario_id IN (SELECT id FROM usuarios WHERE rol = 'administrador');

/* 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
e email del usuario junto con la cantidad de post de cada usuario. 
*/


SELECT a.id, a.email, COUNT(b.id) AS cantidad_posts
FROM usuarios AS  a
LEFT JOIN posts b ON a.id = b.usuario_id
GROUP BY a.id, a.email;


/* 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email. 
*/

SELECT a.email FROM usuarios a
INNER JOIN ( SELECT usuario_id, COUNT(*) AS num_posts FROM posts GROUP BY usuario_id ORDER BY num_posts DESC LIMIT 1) AS b ON a.id = b.usuario_id;

/*6. Muestra la fecha del último posts de cada usuario. 
Hint: Utiliza la función de agregado MAX sobre la fecha de creación.
*/

SELECT a.nombre, a.apellido, a.email, TO_CHAR(max(b.fecha_creacion), 'DD-MM-YYYY') AS fecha_ultimo_post
FROM usuarios a
inner JOIN posts AS b ON a.id = b.usuario_id
GROUP BY a.nombre, a.apellido, a.email
ORDER BY a.apellido;


/*7. Muestra el título y contenido del posts (artículo) con más comentarios.*/

SELECT p.titulo, p.contenido, c.num_comentarios
FROM posts AS p
INNER JOIN (
    SELECT post_id, COUNT(*) AS num_comentarios
    FROM comentarios
    GROUP BY post_id
    ORDER BY num_comentarios DESC
    LIMIT 1
) AS c ON p.id = c.post_id;

/* 8. Muestra en una tabla el título de cada posts, el contenido de cada posts y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.
*/

SELECT p.titulo AS post_titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email from posts AS p
INNER JOIN comentarios AS c ON p.id=c.post_id
INNER JOIN usuarios AS u ON u.id=c.usuario_id;

/* 9. Muestra el contenido del último comentario de cada usuario.
 */

SELECT a.nombre, a.apellido, c.contenido, TO_CHAR(c.fecha_creacion, 'DD-MM-YYYY') AS fecha_ultimo_comentario
FROM comentarios AS c
INNER JOIN ( SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha FROM comentarios GROUP BY usuario_id) AS u ON c.usuario_id = u.usuario_id 
INNER JOIN usuarios AS a ON a.id=u.usuario_id
WHERE c.fecha_creacion = u.ultima_fecha
ORDER BY c.usuario_id;

/* 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
*/

SELECT a.email, COUNT(c.id) AS cantidad_comentarios
FROM usuarios a LEFT JOIN comentarios c
ON a.id = c.usuario_id
GROUP BY a.email,a.id
HAVING COUNT(c.id)=0;
