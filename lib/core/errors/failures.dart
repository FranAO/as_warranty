abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor. Intenta más tarde.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet.']);
}

class CameraFailure extends Failure {
  const CameraFailure([super.message = 'No se pudo acceder a la cámara.']);
}

class OCRFailure extends Failure {
  const OCRFailure([super.message = 'No se pudo leer el texto de la imagen.']);
}