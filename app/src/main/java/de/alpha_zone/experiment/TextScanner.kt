package de.alpha_zone.experiment

import de.alpha_zone.experiment.data.Occurrence

class TextScanner(private val text: String) {

	fun findAllPositions(words: Set<String>): Map<String, List<Occurrence>> {
		val positions =
			mutableMapOf<String, MutableList<Occurrence>>()
		for ((index, c) in text.withIndex()) {
			for (word in words) {
				if (c.equals(word[0], true)) {
					var foundPosition = findFollowingOccurrenceOf(word, index)
					var reverse = false
					if (foundPosition == null) {
						foundPosition = findFollowingOccurrenceOf(word.reversed(), index)
						reverse = true
					}
					if (foundPosition != null) {
						var mutableList = positions[word]
						if (mutableList == null) {
							mutableList = mutableListOf()
							positions[word] = mutableList
						}
						mutableList.add(Occurrence(foundPosition, reverse))
					}
				}
			}
		}
		return positions.toMap()
	}

	private fun findFollowingOccurrenceOf(word: String, index: Int): Pair<Int, Int>? {
		val regex = "[a-zäüöß]".toRegex()
		var justChars = ""
		var textPosition = index
		var wordIndex = 0
		while (justChars.length < word.length && textPosition < text.length) {
			val c = text[textPosition].lowercaseChar()
			if (c.toString().matches(regex)) {
				justChars += c
				if (!c.equals(word[wordIndex], true)) {
					return null
				}
				wordIndex++
			}
			textPosition++
		}
		if (wordIndex != word.length) {
			return null
		}
		return Pair(index, textPosition)
	}

}