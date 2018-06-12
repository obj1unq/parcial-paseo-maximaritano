class Prenda{
	var property talle = null
	var comodidad = 0
	var property desgaste = 0
	var abrigo = 0
	
	method abrigo() = abrigo
	
	method nivelCalidad() = self.nivelDeComodidad() + self.abrigo()
	
	method nivelDeDesgaste() = desgaste
		
	method probarPrenda(ninio){
		if (ninio.talle() == self.talle()) comodidad = comodidad + 8
	}
	
	method comodidad() = comodidad
	
	method nivelDeComodidad(){
		if (self.nivelDeDesgaste()>3) self.nivelDeDesgaste() == 3
		return self.comodidad() - self.nivelDeDesgaste()
	}
}

class PrendaDeAPares inherits Prenda{
	var property elementoDerecho 
	var property elementoIzquierdo
	
	method asignarElementoDerecho(elemento){
		elementoDerecho = elemento
	}
	
	method nivelDeDesgasteDerecho() = elementoDerecho.nivelDeDesgaste()
	method nivelDeDesgasteIzquierdo() = elementoIzquierdo.nivelDeDesgaste()
	method nivelDeAbrigoDerecho() = elementoDerecho.abrigo()
	method nivelDeAbrigoIzquierdo() = elementoIzquierdo.abrigo()
	
	override method nivelDeDesgaste(){
		return ((self.nivelDeDesgasteDerecho() + self.nivelDeDesgasteIzquierdo()) / 2)
	}
	
	method esMenorDe4(ninio){
	 	if (ninio.edad() < 4) comodidad = comodidad - 1
	}
	
	override method abrigo(){
		return self.nivelDeAbrigoDerecho() + self.nivelDeAbrigoIzquierdo() 
	}
	
	method intercambiar(prenda){
		var elementoDerecho1 = self.elementoDerecho()
		var elementoDerecho2 = prenda.elementoDerecho()
		
		if (self.talle() == prenda.talle()) self.elementoDerecho() == elementoDerecho2 
		prenda.elementoDerecho() == elementoDerecho1
	}
	
	method usar(){
		elementoDerecho.nivelDeDesgaste() + 1.2 and elementoIzquierdo.nivelDeDesgaste() + 0.8
	}
}

object default{
	method nivelDeDesgaste() = 0
	
	method abrigo() = 1
}

class PrendaLiviana inherits Prenda{
	var property nivelDeDesgaste = desgasteLiviano.nivelDeDesgaste()
	override method abrigo() = abrigoLiviano.nivelDeAbrigo()
	
	override method comodidad() = super() + 2
	
	method usar(){
		self.nivelDeDesgaste() + 1
	}
}

object desgasteLiviano{
	method nivelDeDesgaste() = 0
}

object abrigoLiviano{
	method nivelDeAbrigo() = 1
}

class PrendaPesada inherits Prenda{
	var property nivelDeDesgaste = desgastePesado.nivelDeDesgaste()
	
	override method abrigo() = 3
	
	method usar(){
		self.nivelDeDesgaste() + 1
	}
}

object desgastePesado{
	method nivelDeDesgaste() = 0
}

class Ninio{
	var property edad = null
	var property talle = null
	var property prendas = #{}
	
	method estaListoParaPasear(){
		return (self.prendas().size() >= 5) and self.tienePrendaConAbrigoMayorOIgualA3()
		and self.promedioCalidadMayorA8()
		
	}
	method tienePrendaConAbrigoMayorOIgualA3(){
		return self.prendas().any({prenda => prenda.abrigo() >= 3})
	}
	
	method promedioCalidad(){
		return self.prendas().sum({prenda => prenda.nivelCalidad()}) / self.prendas().size()
	}
	
	method promedioCalidadMayorA8(){
		return self.promedioCalidad() > 8
	}
	
	method prendaMaximaCalidad(){
		return self.prendas().max({prenda => prenda.nivelCalidad()})
	}
	
	method esMenorDe4(){
		return self.edad() < 4
	}
	
	method usarPrenda(){
		self.prendas().forEach({prenda => prenda.usar()})
	}
}

class NinioProblematico inherits Ninio{
	var juguete = null
	
	override method estaListoParaPasear(){
		return (self.prendas().size() >= 4) and 
		(self.edad().between(juguete.min(), juguete.max())) and super()
	}
}

class Juguete{
	var property min = null
	var property max = null
}

class Familia{
	var property ninios = #{}
	
	method infaltables(){
		return self.ninios().filter({ninio => ninio.prendaMaximaCalidad()}).asSet()
	}
	
	method chiquitos(){
		return self.ninios().filter({ninio => ninio.esMenorDe4()}).asSet()
	}
	
	method pasear(){
		if (self.ninios().all({ninio => ninio.estaListoParaPasear()})) 
		self.ninios().forEach({ninio => ninio.usarPrenda()})
	}
}

//Objetos usados para los talles
object xs {
}

object s {
}
object m {
	
}
object l{
	
}
object xl{
	
}