package de.alpha_zone.stopandgo

import kotlinx.datetime.Clock
import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toInstant
import kotlinx.datetime.toLocalDateTime
import kotlin.math.max
import kotlin.time.Duration
import kotlin.time.Duration.Companion.ZERO
import kotlin.time.Duration.Companion.seconds
import kotlin.time.ExperimentalTime

@ExperimentalTime
class CountDown(
	duration: Duration,
	private val cycles: Int = 1,
	private val localZone: TimeZone = TimeZone.currentSystemDefault()
) {
	private val interval = duration.inWholeSeconds
	private var startedAt: LocalDateTime? = null
	val start: LocalDateTime? get() = startedAt

	private val allTimes: MutableList<Pair<Int, LocalDateTime>> = mutableListOf()
	val timers: List<Pair<Int, LocalDateTime>> get() = allTimes
	val unfinishedTimers: List<Pair<Int, LocalDateTime>>
		get() = allTimes.filter {
			it.second > localZone.now()
		}

	private var duration: Duration = ZERO
	val millisPassed: Long get() = duration.inWholeMilliseconds
	val secondsPassed: Long get() = duration.inWholeSeconds
	val secondsToFinish: Long get() = max(0, (interval * cycles) - secondsPassed)
	val finished: Boolean get() = secondsToFinish <= 0
	val notFinished: Boolean get() = !finished
	val onTimer: Boolean get() = secondsPassed > 0 && interval > 0L && secondsPassed % interval == 0L

	val cycle: Int get() = secondsPassed.toCycle(interval).toInt()
	val cyclesDone: Double
		get() = if (finished) 100.0 else secondsPassed.toCycleRelative(
			interval,
			cycles
		)
	val cycleDone: Double
		get() = if (finished) 100.0 else secondsPassed.toInnerCycleRelative(
			interval
		)

	private var modifiableSyncCount = 0L
	val syncCount: Long get() = modifiableSyncCount

	fun start(clock: Clock = Clock.System) {
		val now = localZone.now(clock = clock)
		startedAt = now
		for (i in 1..cycles) {
			allTimes.add(Pair(i, now + (interval * i).seconds))
		}
	}

	fun sync(clock: Clock = Clock.System) {
		modifiableSyncCount++
		startedAt?.let {
			duration = localZone.now(clock = clock) - it
		}
	}

}

fun TimeZone.now(clock: Clock = Clock.System): LocalDateTime {
	return clock.now().toLocalDateTime(
		this
	)
}

@ExperimentalTime
operator fun LocalDateTime.plus(duration: Duration): LocalDateTime {
	val timeZone = TimeZone.currentSystemDefault()
	return (this.toInstant(timeZone) + duration).toLocalDateTime(timeZone)
}

@ExperimentalTime
operator fun LocalDateTime.minus(duration: Duration): LocalDateTime {
	val timeZone = TimeZone.currentSystemDefault()
	return (this.toInstant(timeZone) - duration).toLocalDateTime(timeZone)
}

@ExperimentalTime
operator fun LocalDateTime.minus(localDate: LocalDateTime): Duration {
	val timeZone = TimeZone.currentSystemDefault()
	return this.toInstant(timeZone) - localDate.toInstant(timeZone)
}

fun Number.toCycle(size: Long): Double {
	return (this.toDouble() / size)
}

fun Number.toCycleRelative(size: Long, cycles: Int): Double {
	return (this.toCycle(size) / cycles) * 100
}

fun Number.toInnerCycle(size: Long): Long {
	val part = this.toLong() % size
	return when {
		this.toLong() <= 0L -> 0
		part == 0L -> size
		else -> part
	}
}

fun Number.toInnerCycleRelative(size: Long): Double {
	return (this.toInnerCycle(size).toDouble() / size) * 100
}