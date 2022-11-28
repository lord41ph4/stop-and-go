package de.alpha_zone.experiment

class WordFinder {

	companion object {

		val text =
			"Liebe Evi!\n\nJuhu, wir haben Winterferien und senden dir nach Falkenstein herzliche Grüße. Dank starker Schneeketten sind wir gut angekommen. Nur einmal waren wir in den Graben gerutscht. Es gab eine kleine Beule. Es war dunkel und dichter Nebel, Sterne sah man nicht und die Luft war ganz eisig. Dafür bereitete uns Stau beinahe keine Probleme. Uns blockierte zwar ein Kran, ich dachte aber wir stehen länger. Astor, Christines Hund, benahm sich heute mustergültig. Er schlief in Katrins Arm. Bei der Kurverei herauf auf die Berge und dem Eis ein Wunder. Wir sind wieder am selben Hotel 'beim Stadler' abgestiegen. Schön, dass Papa Geiz nicht kennt. Gleich am ersten Abend gab es Sekt, Schokolade und Paranüsse. Das verdient ein Lob! Papi rollt gerade mit Astor auf dem Teppich rum.\n\nSo das war es für heute!"


		@JvmStatic
		fun main(args: Array<String>) {
			val textScanner = TextScanner(text)
			val dictionary = Dictionary()
			val words = dictionary.getAllWords()
			val found = textScanner.findAllPositions(words)
			val representation = FindingTransformer(text, found).toHtml()
			println("${found.size} - ${found.keys}")
			println(representation)
		}
	}
}