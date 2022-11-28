package de.alpha_zone.experiment

import java.net.URL

class Dictionary {

	private val cache = FileUtil.home().resolve(".dict").resolve("data.csv")

	fun getAllWords(): Set<String> {
		if (cache.exists()) {
			return cache.toUri().toURL().readText().split(',').map { it.trim() }.toSet()
		}

		val crawlUrls = mutableListOf<Pair<URL, Regex>>()
		crawlUrls += Pair(
			URL("https://www.birds-online.ch/index.php?cat=1&order=73"),
			"<li>\\s*<a[^<>]*>([^<>]+)".toRegex()
		)
		crawlUrls += Pair(
			URL("https://nafoku.de/birds/namen_de.htm"),
			"<li>\\s*<a[^<>]*>([^<>]+)".toRegex()
		)
		crawlUrls += Pair(
			URL("https://www.volker-schlaer.de/vögel-von-a-bis-z/"),
			"<p>\\s*<a[^<>]*>\\s*<span [^<>]+>([^<>]+)".toRegex()
		)
		crawlUrls += Pair(
			URL("https://www.nabu.de/tiere-und-pflanzen/voegel/portraets/index.html"),
			"<div class=\"bird-name\\s*\">\\s*([^<]+)".toRegex()
		)
		crawlUrls += Pair(
			URL("https://de.wikipedia.org/wiki/Liste_der_V%C3%B6gel_Deutschlands"),
			"<td><a href=[^>]+>([^<>]+)</a></td>\\s*<td><i>".toRegex()
		)

		val baseCrawler = StaticCrawler(crawlUrls)
		val words = baseCrawler.crawlForListElements().toMutableSet()
		words.addWord("Ara")
		words.addWord("Beo")
		words.addWord("Tukan")
		words.addWord("Papagei")
		words.addWord("Kiwi")
		words.addWord("Ammer")
		words.addWord("Specht")
		words.addWord("Kleiber")
		words.addWord("Dole")
		words.addWord("Emu")
		cache.forceWriteContent(words.sorted().joinToString { it })
		return words
	}


}