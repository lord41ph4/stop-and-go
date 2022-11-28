package de.alpha_zone.experiment

import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardOpenOption
import kotlin.io.path.Path

class FileUtil {

	companion object {

		@JvmStatic
		fun home(): Path {
			val property = System.getProperty("user.home")
			return property.asPath()
		}
	}

}

fun Path.exists(): Boolean {
	return this.toFile().exists()
}

fun Path.forceWriteContent(content: String) {
	if (!this.parent.exists()) {
		val parentFile = this.parent.toFile()
		parentFile.mkdirs()
	}
	Files.write(this, listOf(content), StandardOpenOption.CREATE_NEW)
}

fun String?.asPath(): Path {
	return if (this == null) Path(".") else Path(this)
}
