
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public aspect Logger {
pointcut signUpPointcut(): execution(* your.package.UserRegistrationService.registerUser(..));
pointcut logInPointcut(): execution(* your.package.UserAuthenticationService.logIn(..));
pointcut logOutPointcut(): execution(* your.package.UserAuthenticationService.logOut(..));

after() returning: signUpPointcut() {
logAction("Registrar usuario");
}

after() returning: logInPointcut() {
logAction("Iniciar sesión");
}

after() returning: logOutPointcut() {
logAction("Cerrar sesión");
}

private void logAction(String actionType) {
try {
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = dateFormat.format(new Date());

String logMessage = actionType + " - Usuario: " + getUsername() + " - Hora: " + currentTime;

// Cambiar las rutas de archivo según sea necesario
String logFilePath = "path/to/Log.txt";

BufferedWriter writer = new BufferedWriter(new FileWriter(logFilePath, true));
writer.write(logMessage);
writer.newLine();
writer.close();
} catch (Exception e) {
e.printStackTrace();
}
}

private String getUsername() {
// Lógica para obtener el nombre de usuario actual
// Reemplaza esto con tu forma de obtener el nombre de usuario
return "usuarioEjemplo";
}
}