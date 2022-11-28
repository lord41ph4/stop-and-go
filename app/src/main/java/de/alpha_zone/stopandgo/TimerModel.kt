package de.alpha_zone.stopandgo

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations
import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.datetime.Clock
import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.TimeZone
import javax.inject.Inject
import kotlin.time.ExperimentalTime


@ExperimentalTime
@HiltViewModel
class TimerModel(
	private val clock: Clock,
	private val timeZone: TimeZone = TimeZone.currentSystemDefault()
) : ViewModel(), TimeAwareLiveValues {

	private var startTime = MutableLiveData(null as LocalDateTime?)

	private var countDown = MutableLiveData<CountDown?>()
	override val currentCycle: LiveData<Double> = Transformations.distinctUntilChanged(
		Transformations.map(countDown) { countDown -> countDown?.cycleDone ?: 0.0 }
	)
	override val overall: LiveData<Double> = Transformations.distinctUntilChanged(
		Transformations.map(countDown) { countDown -> countDown?.cyclesDone ?: 0.0 }
	)
	override val millisPassed: LiveData<Long> = Transformations.distinctUntilChanged(
		Transformations.map(countDown) { countDown -> countDown?.millisPassed ?: 0 }
	)

	@Inject
	constructor() : this(Clock.System)

	fun onTick() {
		countDown.value?.sync(clock)
	}

	fun set(newCountDown: CountDown?) {
		countDown.value = newCountDown
	}

	fun start() {
		startTime.value = timeZone.now(clock)
		countDown.value?.start(clock)
	}

	fun stop() {
		startTime.value = null
	}

}