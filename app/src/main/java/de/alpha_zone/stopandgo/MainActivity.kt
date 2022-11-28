package de.alpha_zone.stopandgo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.tooling.preview.Preview
import de.alpha_zone.stopandgo.ui.theme.StopAndGoTheme
import kotlin.time.ExperimentalTime

@ExperimentalTime
class MainActivity : ComponentActivity() {

	private val viewFactory: ViewFactory = ViewFactory()
	private val viewModel: TimerModel by viewModels()

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContent {
			StopAndGoTheme {
				// A surface container using the 'background' color from the theme
				Surface(color = MaterialTheme.colors.background) {
					MainContent(viewModel, viewFactory)
				}
			}
		}
	}
}

@ExperimentalTime
@Composable
fun MainContent(timerModel: TimerModel, viewFactory: ViewFactory) {
	val overall: Double by timerModel.overall.observeAsState(0.0)
	val cycle: Double by timerModel.currentCycle.observeAsState(0.0)
	viewFactory.generateMultiProcess(overall, cycle, passedMillis = 0)

}

@ExperimentalTime
@Preview(showBackground = true)
@Composable
fun generatePreview() {
	StopAndGoTheme {
		val timerModel = TimerModel()
		MainContent(timerModel, ViewFactory())
	}
}