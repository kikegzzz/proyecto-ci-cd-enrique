FROM python:3.9-slim

# Evita problemas de buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Carpeta de trabajo
WORKDIR /home/alumno/Documentos/proyecto-ci-cd-enrique

# Copiar dependencias primero (mejor caché)
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir flask pytest

# Puerto de la app
EXPOSE 5000

# Ejecutar aplicación
CMD ["python", "app.py"]
