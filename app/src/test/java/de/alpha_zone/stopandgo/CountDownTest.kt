package de.alpha_zone.stopandgo

import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.Month
import org.hamcrest.CoreMatchers.`is`
import org.hamcrest.CoreMatchers.not
import org.hamcrest.CoreMatchers.nullValue
import org.hamcrest.MatcherAssert.assertThat
import org.hamcrest.Matchers.containsInAnyOrder
import org.junit.Test
import kotlin.time.Duration.Companion.seconds
import kotlin.time.ExperimentalTime


@ExperimentalTime
class CountDownTest {

	@Test
	fun `can be created when duration is given`() {
		CountDown(20.seconds)
	}

	@Test
	fun `has start time when it is started`() {
		val underTest = CountDown(20.seconds)
		underTest.start()

		assertThat(underTest.start, `is`(not(nullValue())))
	}

	@Test
	fun `contains correct end times when it is started`() {
		val cycles = 2
		val countDown = CountDown(20.seconds, cycles)
		countDown.start()
		val startTime = countDown.start!!
		assertThat(
			countDown.timers,
			containsInAnyOrder(
				Pair(1, startTime + 20.seconds),
				Pair(2, startTime + 40.seconds)
			)
		)
	}

	@Test
	fun `can calculate passed seconds when it is started and sync time is known`() {
		val cycles = 1
		val countDown = CountDown(20.seconds, cycles)
		val clock = TestClock()
		countDown.start(clock)
		clock.simulateTimePass(1.seconds)
		countDown.sync(clock)
		assertThat(countDown.secondsPassed, `is`(1L))
	}

	@Test
	fun `can calculate start time when end time and seconds left are known`() {
		val endTime = LocalDateTime(2022, Month.JUNE, 7, 7, 13, 22)
		val startTime = endTime - 2.seconds
		assertThat(startTime, `is`(LocalDateTime(2022, Month.JUNE, 7, 7, 13, 20)))
	}

	@Test
	fun `cyclesDone is 50 when 1 second out of 2 cycles each 1 second is passed`() {
		val cycles = 2
		val countDown = CountDown(1.seconds, cycles)
		val clock = TestClock()
		countDown.start(clock)
		clock.simulateTimePass(1.seconds)
		countDown.sync(clock)
		assertThat(countDown.cyclesDone, `is`(50.0))
	}

	@Test
	fun `cyclesDone is 50 when 1 second out of 2 cycles each 2 seconds is passed`() {
		val cycles = 2
		val countDown = CountDown(2.seconds, cycles)
		val clock = TestClock()
		countDown.start(clock)
		clock.simulateTimePass(1.seconds)
		countDown.sync(clock)
		assertThat(countDown.cycleDone, `is`(50.0))
	}

	@Test
	fun `second 1 of cycle with interval of 5 lies in cycle 0`() {
		assertThat(1.toCycle(5), `is`(0.2))
	}

	@Test
	fun `second 6 of cycle with interval of 5 lies in cycle 1`() {
		assertThat(6.toCycle(5), `is`(1.2))
	}

	@Test
	fun `second 3 of inner cycle with interval of 3 is 3`() {
		assertThat(3.toInnerCycle(3), `is`(3L))
	}

	@Test
	fun `second 4 of inner cycle with interval of 3 is 1`() {
		assertThat(4.toInnerCycle(3), `is`(1L))
	}

}