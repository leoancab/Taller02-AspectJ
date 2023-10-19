import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.bettinghouse.User;

public aspect Logger {
	private SimpleDateFormat fecha = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy");
	pointcut registerUser() : call(* com.bettinghouse.BettingHouse.successfulSignUp(..));
	after() returning : registerUser() {
		User user = (User)thisJoinPoint.getArgs()[0];
		recordAction("Register.txt", user, "Usuario registrado");
		}
	private void recordAction(String fileName, User user, String actionType) {
		File file = new File(fileName);
		String time = fecha.format(Calendar.getInstance().getTime());

		try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
		String message;
		if (actionType.equals("Usuario registrado")) {
		message = actionType + ": [nickname=" + user.getNickname() + ", password=" + user.getPassword() + "] Fecha: [" + time + "]";
		} else {
		message = actionType + " por usuario: [" + user.getNickname() + "] Fecha: [" + time + "]";
		}
		System.out.println(message);
		out.println(message);
		} catch (IOException e) {
		e.printStackTrace();
		}
	}
	pointcut loginAndLogoutUser() : (call(* com.bettinghouse.BettingHouse.effectiveLogIn(..)) || call(* com.bettinghouse.BettingHouse.effectiveLogOut(..)));
	after() returning : loginAndLogoutUser() {
		User user = (User)thisJoinPoint.getArgs()[0];
		if (thisJoinPoint.getSignature().getName().equals("effectiveLogIn")) {
			recordAction("Log.txt", user, "Sesión iniciada");
		} else if (thisJoinPoint.getSignature().getName().equals("effectiveLogOut")) {
			recordAction("Log.txt", user, "Sesión cerrada");
		}
	}

}



