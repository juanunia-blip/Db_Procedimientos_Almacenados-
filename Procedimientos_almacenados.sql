-- Ejercicio Procedimientos Almacenados

-- Contexto:
-- Una plataforma de cursos en línea necesita gestionar la información sobre cursos, estudiantes, inscripciones y calificaciones.
-- Se requiere el diseño de la base de datos y la implementación de procedimientos almacenados para la gestión de datos.

-- Creación de las tablas
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion INT -- duración en horas
);

CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion INT,
    nota DECIMAL(5,2),
    fecha_evaluacion DATE,
    FOREIGN KEY (id_inscripcion) REFERENCES Inscripciones(id_inscripcion)
);

-- Inserción de datos (10 registros por tabla)
INSERT INTO Cursos (nombre, descripcion, duracion) VALUES
('SQL Básico', 'Curso introductorio sobre SQL', 10),
('Python para Data Science', 'Aprendizaje de Python enfocado en análisis de datos', 20),
('Fundamentos de Redes', 'Conceptos básicos de redes de computadoras', 15),
('Java Avanzado', 'Curso avanzado de Java', 25),
('Cálculo I', 'Introducción al cálculo diferencial', 40),
('Machine Learning', 'Curso introductorio sobre aprendizaje automático', 30),
('Diseño Web con CSS', 'Aprendizaje de CSS para diseño web', 15),
('Administración de Bases de Datos', 'Curso sobre gestión de bases de datos', 25),
('Estructuras de Datos', 'Curso sobre estructuras de datos en programación', 35),
('Seguridad Informática', 'Fundamentos de ciberseguridad', 20);

INSERT INTO Estudiantes (nombre, correo) VALUES
('Juan Pérez', 'juan.perez@example.com'),
('María López', 'maria.lopez@example.com'),
('Carlos Ramírez', 'carlos.ramirez@example.com'),
('Ana Torres', 'ana.torres@example.com'),
('Luis Fernández', 'luis.fernandez@example.com'),
('Elena Díaz', 'elena.diaz@example.com'),
('Pedro Gómez', 'pedro.gomez@example.com'),
('Marta Ruiz', 'marta.ruiz@example.com'),
('Jorge Herrera', 'jorge.herrera@example.com'),
('Sofía Sánchez', 'sofia.sanchez@example.com');

INSERT INTO Inscripciones (id_estudiante, id_curso, fecha_inscripcion) VALUES
(1, 1, '2025-01-10'),
(2, 2, '2025-01-15'),
(3, 3, '2025-01-20'),
(4, 4, '2025-01-25'),
(5, 5, '2025-02-01'),
(6, 6, '2025-02-05'),
(7, 7, '2025-02-10'),
(8, 8, '2025-02-15'),
(9, 9, '2025-02-20'),
(10, 10, '2025-02-25');

INSERT INTO Calificaciones (id_inscripcion, nota, fecha_evaluacion) VALUES
(1, 85.5, '2025-03-01'),
(2, 90.0, '2025-03-02'),
(3, 75.8, '2025-03-03'),
(4, 88.2, '2025-03-04'),
(5, 92.5, '2025-03-05'),
(6, 80.3, '2025-03-06'),
(7, 85.0, '2025-03-07'),
(8, 78.9, '2025-03-08'),
(9, 88.6, '2025-03-09'),
(10, 91.2, '2025-03-10');

-- Procedimientos Almacenados


DELIMITER $$

-- 1. Procedimiento para inscribir un estudiante en un curso
CREATE PROCEDURE inscribir_estudiante(
    IN p_id_estudiante INT,
    IN p_id_curso INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO Inscripciones (id_estudiante, id_curso, fecha_inscripcion)
    VALUES (p_id_estudiante, p_id_curso, p_fecha);
END$$

-- 2. Procedimiento para calcular el promedio de notas de un estudiante
CREATE PROCEDURE promedio_estudiante(
    IN p_id_estudiante INT
)
BEGIN
    SELECT e.nombre, AVG(ca.nota) AS promedio
    FROM Estudiantes e
    JOIN Inscripciones i ON e.id_estudiante = i.id_estudiante
    JOIN Calificaciones ca ON i.id_inscripcion = ca.id_inscripcion
    WHERE e.id_estudiante = p_id_estudiante
    GROUP BY e.nombre;
END$$

-- 3. Procedimiento para obtener la lista de cursos de un estudiante
CREATE PROCEDURE cursos_estudiante(
    IN p_id_estudiante INT
)
BEGIN
    SELECT e.nombre AS estudiante, c.nombre AS curso, i.fecha_inscripcion
    FROM Estudiantes e
    JOIN Inscripciones i ON e.id_estudiante = i.id_estudiante
    JOIN Cursos c ON i.id_curso = c.id_curso
    WHERE e.id_estudiante = p_id_estudiante;
END$$

-- 4. Procedimiento para actualizar la calificación de un estudiante en un curso
CREATE PROCEDURE actualizar_calificacion(
    IN p_id_inscripcion INT,
    IN p_nueva_nota DECIMAL(5,2)
)
BEGIN
    UPDATE Calificaciones
    SET nota = p_nueva_nota, fecha_evaluacion = CURDATE()
    WHERE id_inscripcion = p_id_inscripcion;
END$$

-- 5. Procedimiento para eliminar la inscripción de un estudiante en un curso
CREATE PROCEDURE eliminar_inscripcion(
    IN p_id_inscripcion INT
)
BEGIN
    DELETE FROM Calificaciones WHERE id_inscripcion = p_id_inscripcion;
    DELETE FROM Inscripciones WHERE id_inscripcion = p_id_inscripcion;
END$$

DELIMITER ;


CALL inscribir_estudiante(1, 2, '2024-03-15');
CALL promedio_estudiante(1);
CALL cursos_estudiante(2);
CALL actualizar_calificacion(1, 45.0);
CALL eliminar_inscripcion(3);
