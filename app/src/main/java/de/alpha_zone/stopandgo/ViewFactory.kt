package de.alpha_zone.stopandgo

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.ProgressIndicatorDefaults
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import de.alpha_zone.stopandgo.ui.theme.StopAndGoTheme
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.ExperimentalTime

@ExperimentalTime
class ViewFactory {

	@Composable
	fun generateMultiProcess(timerModel: TimeAwareLiveValues) {
		val overallCycle by timerModel.overall.observeAsState(0.0)
		val currentCycle by timerModel.currentCycle.observeAsState(0.0)
		val currentMilliSeconds by timerModel.millisPassed.observeAsState(0)

		generateMultiProcess(overallCycle, currentCycle, passedMillis = currentMilliSeconds)
	}

	@Composable
	fun generateMultiProcess(
		vararg processes: Number,
		passedMillis: Long,
		strokeSize: Dp = ProgressIndicatorDefaults.StrokeWidth
	) {
		Box(
			modifier = Modifier
				.fillMaxSize()
				.padding(strokeSize),
			contentAlignment = Alignment.Center
		) {
			processes.forEachIndexed { index, process ->
				CircularProgressIndicator(
					strokeWidth = strokeSize,
					progress = process.toFloat(),
					modifier = Modifier
						.padding((index * (strokeSize.value + 2)).dp)
						.fillMaxSize()
						.aspectRatio(1f)
				)
			}
			Box(
				contentAlignment = Alignment.Center, modifier = Modifier
					.fillMaxSize()
					.aspectRatio(1f)
			) {
				Text(
					text = passedMillis.asDurationString(),
				)
			}

		}
	}

	@Preview(showBackground = true)
	@Composable
	fun generatePreview() {
		StopAndGoTheme {
			//
			val duration by remember {
				mutableStateOf(35L)
			}
			generateMultiProcess(.7f, .5f, passedMillis = duration, strokeSize = 20.dp)
		}
	}

	private fun Long.asDurationString(format: String = "%02d:%02d:%03d"): String {
		val duration = this.milliseconds
		return format.format(
			duration.inWholeMinutes,
			duration.inWholeSeconds,
			duration.inWholeMilliseconds
		)
	}
}