Beacon Testing Readme

   - current state

This testing app let's a device be an iBeacon, or to be a range finder (Central).

To be a beacon, choose the option at the first menu, then choose a Major and Minor identifier.

	The same UUID is hard coded in both beaconviewcontroller.m and central 
	viewcontroller.m. You need to change both if you are using a different identifier.

	Major and Minor identifiers are persistent in core data. Once chose, they will 
	only change if you manually make the change or delete the app bundle.


To be a Central, just choose the option. It will automatically start looking for devices set up as beacons with the appropriate UUID.

	The range finder orders beacons by approximate distance.


-To do
	
	Get triangulation testing in the works.

	Section headers.

	