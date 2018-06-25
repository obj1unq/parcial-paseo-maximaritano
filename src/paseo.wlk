// Nota 4 (cuatro): Serios problemas con el manejo del efecto.

// 1) Mal. Intenta manejar la comodidad en un atributo y asignarla con efectos acumulativos en lugar de calcularla en el momento que se consulta.
// 2) R-. Usa mensajes como valores asignables. Falta manejo de excepciones.
// 3) MB-. 
// 4) MB.
// 5) R. No redefine correctamente la validación de cantidad de prendas.
// 6) R. Mal manejo de colecciones, confunde filter con map.
// 7) MB-. Define subtarea esMenorDe4, pero el nombre es incorrecto, no constituye una abstracción.
// 8) Mal. Serios problemas en el manejo del efecto.

// Tests no andan!
class Prenda {

	var property talle = null
	var comodidad = 0 // No es necesario tener una variable, debería calcularse.
	var property desgaste = 0
	var abrigo = 0

	method abrigo() = abrigo

	method nivelCalidad() = self.nivelDeComodidad() + self.abrigo()

	method nivelDeDesgaste() = desgaste

	// ¿Quién llama este método? ¿Cómo es el flujo para que influya en el cálculo de la comodidad?
	method probarPrenda(ninio) {
		if (ninio.talle() == self.talle()) comodidad = comodidad + 8
	}

	method comodidad() = comodidad

	method nivelDeComodidad() {
		if (self.nivelDeDesgaste() > 3)
			// Este código parece intentar producir un efecto, pero en realidad compara igualdad
			// Sería imposible asignar el 3 al valor de retorno de un método. 
			self.nivelDeDesgaste() == 3
			
		return self.comodidad() - self.nivelDeDesgaste()
	}

}

class PrendaDeAPares inherits Prenda {

	var property elementoDerecho
	var property elementoIzquierdo

	method asignarElementoDerecho(elemento) {
		elementoDerecho = elemento
	}

	method nivelDeDesgasteDerecho() = elementoDerecho.nivelDeDesgaste()

	method nivelDeDesgasteIzquierdo() = elementoIzquierdo.nivelDeDesgaste()

	method nivelDeAbrigoDerecho() = elementoDerecho.abrigo()

	method nivelDeAbrigoIzquierdo() = elementoIzquierdo.abrigo()

	override method nivelDeDesgaste() {
		return ((self.nivelDeDesgasteDerecho() + self.nivelDeDesgasteIzquierdo()) / 2)
	}

	// Sería mejor llamarlo esPequenio, así no constituye una abstracción real.
	method esMenorDe4(ninio) {
		// ¿Esto es una orden? ¿En qué momento se ejecuta esta orden?
		if (ninio.edad() < 4) comodidad = comodidad - 1
	}

	override method abrigo() {
		return self.nivelDeAbrigoDerecho() + self.nivelDeAbrigoIzquierdo()
	}

	method intercambiar(prenda) {
		var elementoDerecho1 = self.elementoDerecho()
		var elementoDerecho2 = prenda.elementoDerecho()
		if (self.talle() == prenda.talle()) self.elementoDerecho() == elementoDerecho2
		
		// Intenta asignar un valor usando el operador incorrecto y un valor de retorno, no asignable.
		prenda.elementoDerecho() == elementoDerecho1
		
		// Debería tirar excepcion en caso de fallar la validación.
	}

	method usar() {
		// Esto no tiene sentido, gran confusión.
		elementoDerecho.nivelDeDesgaste() + 1.2 and elementoIzquierdo.nivelDeDesgaste() + 0.8
	}

}

object default {

	method nivelDeDesgaste() = 0

	method abrigo() = 1 // ¿Cuándo se usa eso?

}

class PrendaLiviana inherits Prenda {

	var property nivelDeDesgaste = desgasteLiviano.nivelDeDesgaste() // ¿Por qu

	override method abrigo() = abrigoLiviano.nivelDeAbrigo()

	override method comodidad() = super() + 2

	method usar() {
		// No es posible modificar el desgaste de esta manera
		self.nivelDeDesgaste() + 1
	}

}

// ¿Por qué necesito este objeto
object desgasteLiviano {
	method nivelDeDesgaste() = 0

}

object abrigoLiviano {
	method nivelDeAbrigo() = 1

}

class PrendaPesada inherits Prenda {

	var property nivelDeDesgaste = desgastePesado.nivelDeDesgaste()

	override method abrigo() = 3 // Debería ser sólo el valor inicial

	method usar() {
		// No es posible modificar el desgaste de esta manera
		// Además el código está repetidos
		self.nivelDeDesgaste() + 1
	}

}

// ¿Por qué necesito este objeto
object desgastePesado {

	method nivelDeDesgaste() = 0

}

class Ninio {

	var property edad = null
	var property talle = null
	var property prendas = #{}

	method estaListoParaPasear() {
		return (self.prendas().size() >= 5) and self.tienePrendaConAbrigoMayorOIgualA3() and self.promedioCalidadMayorA8()
	}

	method tienePrendaConAbrigoMayorOIgualA3() {
		return self.prendas().any({ prenda => prenda.abrigo() >= 3 })
	}

	method promedioCalidad() {
		return self.prendas().sum({ prenda => prenda.nivelCalidad() }) / self.prendas().size()
	}

	method promedioCalidadMayorA8() {
		return self.promedioCalidad() > 8
	}

	method prendaMaximaCalidad() {
		return self.prendas().max({ prenda => prenda.nivelCalidad() })
	}

	method esMenorDe4() {
		return self.edad() < 4
	}

	method usarPrenda() {
		self.prendas().forEach({ prenda => prenda.usar()})
	}

}

class NinioProblematico inherits Ninio {

	var juguete = null

	override method estaListoParaPasear() {
		// Debería redefinir la validación de cantidad de prendas, de esta manera no respeta el enunciado.
		return (self.prendas().size() >= 4) and (self.edad().between(juguete.min(), juguete.max())) and super()
	}

}

class Juguete {

	var property min = null
	var property max = null

}

class Familia {

	var property ninios = #{}

	method infaltables() {
		// Debería usar map.
		return self.ninios().filter({ ninio => ninio.prendaMaximaCalidad() }).asSet()
	}

	method chiquitos() {
		return self.ninios().filter({ ninio => ninio.esMenorDe4() }).asSet()
	}

	method pasear() {
		if (self.ninios().all({ ninio => ninio.estaListoParaPasear() })) self.ninios().forEach({ ninio => ninio.usarPrenda() })
		// Debería tirar excepcion si no cumple la validación.
	}

}

//Objetos usados para los talles
object xs {

}

object s {

}

object m {

}

object l {

}

object xl {

}

