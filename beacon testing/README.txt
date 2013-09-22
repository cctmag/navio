Beacon Testing Readme

   - current state

	There are two projects here:
		Navio-beacon and a "customized" version of the AirLocate example

	Navio-beacon features:

		When you launch the app for the first time (and acknowledge the 
		"Be a Beacon" button), it will generate a UUID for your device for the
		purposes of this app. This will be saved in the app bundle for future
		reference, and you will continue to have the same UUID until you either
		A) delete the app and reinstall, or B) choose to generate a new UUID
		with the button at the bottom.

		There is an option to email your UUID directly from within the app
		(for convenience…)

		When you toggle the switch, you will begin advertising your device.
		Currently, there is no "major or minor" identifiers, only your UUID.

	Custom AirLocate features:

		To save some time, (and for controlled testing) I just updated the
		existing table-view-range-finder to search for only one device at a time.
		
		YOU WILL NEED TO HARDCODE A UUID FOR NOW.
			Launch the other app (Navio-beacon) and get a UUID on a peripheral
			device before you do anything with AirLocate.

			Open the included AirLocate project, and head to the ALRangingViewController.m

			Near the top, in the "initWithStyle" method, there is a UUID property.
			Just change the @"xxxxxxxxxxxxx" to include the UUID you will be
			searching for.

		Now launch the AirLocate app on a separate device to test.


	The next step is to choose "Range" from the AirLocate menu, and then to toggle on the beacon
	switch in the Navio-beacon app. You should be able to measure RSSI strength between the devices
	at 1 second intervals.



    - moving forward - next few steps

	Next step is probably to get rid of the AirLocate app, and have a database of UUIDs and
	range finder in the Navio-beacon app.

	Then we need to be able to find multiple devices at once, and set up and store relative 
	locations for stationary devices.

	Then we can add triangulation to get a user's relative position.