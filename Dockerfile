# 1. Imagen base ligera de Python
FROM python:3.9-slim

# 2. Directorio de trabajo dentro del contenedor
WORKDIR /app

# 3. Copiamos todos los archivos del repositorio al contenedor
# (app.py, test_app.py, etc.)
COPY . .

# 4. Instalamos las dependencias necesarias
# Instalamos flask para la app y pytest para que Jenkins pueda testear
RUN pip install --no-cache-dir flask pytest

# 5. Informamos que la app usará el puerto 5000
EXPOSE 5000

# 6. COMANDO DEFINITIVO: Arranca el servidor Flask
# Usamos el flag --host=0.0.0.0 para que sea accesible desde fuera del contenedor
CMD ["python", "app.py"]
