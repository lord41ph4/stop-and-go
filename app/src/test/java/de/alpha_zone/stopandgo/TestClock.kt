package de.alpha_zone.stopandgo

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlin.time.Duration
import kotlin.time.ExperimentalTime

@ExperimentalTime
class TestClock(private var time: Instant = Clock.System.now()) : Clock {

	override fun now(): Instant {
		return time
	}

	fun sync(): TestClock {
		time = Clock.System.now()
		return this
	}

	fun simulateTimePass(elapsedTime: Duration) {
		time = time.plus(elapsedTime)
	}

}