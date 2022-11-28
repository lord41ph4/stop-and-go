package de.alpha_zone.experiment

import de.alpha_zone.experiment.data.Finding
import de.alpha_zone.experiment.data.Occurrence

class FindingTransformer(
	private val originalText: String,
	private val occurrences: Map<String, List<Occurrence>>
) {

	fun toHtml(): String {
		val startIndexes = mutableMapOf<Int, Finding>()
		val endIndexes = mutableMapOf<Int, Finding>()

		for (entry in occurrences) {
			for ((number, occurrence) in entry.value.withIndex()) {
				val word = entry.key
				val finding = Finding(word, number, occurrence)
				startIndexes[occurrence.position.first] = finding
				endIndexes[occurrence.position.second] = finding
			}
		}
		var page = "<html><meta charset=\"UTF-8\"><head><style>" +
				"div { background-color: rgba(201, 76, 76, 0.3); } " +
				".tooltip { position: relative; display: inline-block; } " +
				".tooltip .tooltiptext { visibility: hidden; background-color: black; color: white; text-align: center; border-radius: 1em; padding: 0em 1em; position: absolute; z-index: 1; } " +
				".tooltip:hover .tooltiptext { visibility: visible; } " +
				"</style></head><body>"

		for ((index, char) in originalText.withIndex()) {
			val start = startIndexes[index]
			if (start != null) {
				page += "<div class=\"tooltip\" id=\"${start.word}-${start.number}\">"
			}
			val end = endIndexes[index]
			if (end != null) {
				page += "<span class=\"tooltiptext\">${end.word}</span></div>"
			}
			if (char != '\n') {
				page += char
			} else {
				page += "<br />"
			}

		}

		page += "</body></html>"
		return page
	}

}