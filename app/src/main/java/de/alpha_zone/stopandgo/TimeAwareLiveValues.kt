package de.alpha_zone.stopandgo

import androidx.lifecycle.LiveData

interface TimeAwareLiveValues {

	val millisPassed: LiveData<Long>
	val currentCycle: LiveData<Double>
	val overall: LiveData<Double>

}