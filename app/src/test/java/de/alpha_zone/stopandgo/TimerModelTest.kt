package de.alpha_zone.stopandgo

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import org.hamcrest.CoreMatchers.`is`
import org.hamcrest.CoreMatchers.equalTo
import org.hamcrest.CoreMatchers.notNullValue
import org.hamcrest.CoreMatchers.nullValue
import org.hamcrest.MatcherAssert.assertThat
import org.junit.BeforeClass
import org.junit.Rule
import org.junit.Test
import kotlin.time.Duration.Companion.seconds
import kotlin.time.ExperimentalTime

@ExperimentalTime
class TimerModelTest {

	companion object {

		@BeforeClass
		@JvmStatic
		fun setup() {
		}

	}


	@Rule
	@JvmField
	val instantTaskExecutorRule = InstantTaskExecutorRule()

	@Test
	fun `can be constructed`() {
		TimerModel()
	}

	@Test
	fun `a countdown can be set`() {
		val underTest = TimerModel()
		underTest.set(CountDown(2.seconds, 2))
		underTest.start()

		assertThat(underTest.currentCycle.value, `is`(notNullValue()))
	}

	@Test
	fun `a countdown can be unset`() {
		val underTest = TimerModel()
		underTest.set(null)

		assertThat(underTest.currentCycle.value, `is`(nullValue()))
	}

	@Test
	fun `has start time when is started`() {
		val underTest = TimerModel()
		underTest.start()

		assertThat(underTest.millisPassed.value, `is`(notNullValue()))
	}

	@Test
	fun `has no start time when is stopped`() {
		val underTest = TimerModel()
		underTest.stop()

		assertThat(underTest.millisPassed.value, `is`(nullValue()))
	}

	@Test
	fun `passed seconds is incremented by one when one second is passed and check() is called`() {
		val clock = TestClock()
		val underTest = TimerModel(clock)
		underTest.set(CountDown(10.seconds))
		underTest.start()
		clock.simulateTimePass(1.seconds)
		underTest.onTick()

		assertThat(underTest.millisPassed.value, `is`(equalTo(1000)))
	}

}