package de.alpha_zone.experiment

import java.net.URL

class StaticCrawler(url: Iterable<Pair<URL, Regex>>) {

	companion object {
		val SPLIT_WORDS = listOf(
			"Alexander",
			"Humboldt",
			"Felsen",
			"Wasser",
			"Wespen",
			"Zwerg",
			"Zipp",
			"Borsten",
			"Fuß",
			"Stadt",
			"Saat",
			"See",
			"Pfeif",
			"Sichel",
			"Schwanen",
			"Baum",
			"Bart",
			"Berg",
			"Raub",
			"Haus",
			"Klein",
			"Weiden",
			"Jagd",
			"Roh",
			"Schleier",
			"Weiß"
		)
	}

	private val urls: List<Pair<URL, Regex>> = url.toList()

	fun crawlForListElements(): Set<String> {
		val knownWords = mutableSetOf<String>()
		for (url in urls) {
			val completeContent = findPageContent(url.first)
			var find = url.second.find(completeContent)
			while (find != null) {
				val word = find.groupValues[1].trim()
				val twoInOne = word.split('/')

				val singleWords = mutableSetOf<String>()
				if (twoInOne.isNotEmpty()) {
					singleWords.addWord(twoInOne.first())
					singleWords.addWord(twoInOne.last())
				}

				val dividedWords = mutableSetOf<String>()
				for (currentWord in singleWords) {
					val splitByDivider = currentWord.split('-', ' ')
					if (splitByDivider.isNotEmpty()) {
						dividedWords.addWord(splitByDivider.last())
					}
					dividedWords.addWord(currentWord)
				}

				for (currentWord in dividedWords) {
					val splitByWord =
						currentWord.split(delimiters = SPLIT_WORDS.toTypedArray(), true)
					if (splitByWord.isNotEmpty()) {
						knownWords.addWord(splitByWord.last())
					}
					knownWords.addWord(currentWord)
				}

				find = find.next()
			}
		}
		return knownWords
	}

	private fun findPageContent(url: URL): String {
		val path =
			System.getProperty("user.home").asPath().resolve(".cachedFiles").resolve(url.host)
		var resolveUrl = url
		if (path.exists()) {
			resolveUrl = path.toUri().toURL()
		}
		val content = resolveUrl.readText()
		if (!path.exists()) {
			path.forceWriteContent(content)
		}
		return content.replace("\\s+".toRegex(), " ")
	}


}

fun MutableCollection<String>.addWord(word: String) {
	if (word.startsWith('(') || word.length < 3) {
		return
	}
	this.add(word.replace("-", "").asNoun().trim())
}

fun String.asNoun(): String {
	val chars = this.toCharArray()
	if (chars[0].isLowerCase()) {
		chars[0] = chars[0].uppercaseChar()
	}
	return String(chars)
}
