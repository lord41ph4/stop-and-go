package de.alpha_zone.stopandgo

import kotlinx.datetime.Clock
import javax.inject.Inject
import kotlin.time.ExperimentalTime

@ExperimentalTime
class Scheduler(private val clock: Clock = Clock.System) {

	@Inject
	constructor() : this(Clock.System)


}