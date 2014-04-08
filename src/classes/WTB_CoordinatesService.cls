/*
* @author Neeraj Sharma
* @date 07/09/2013
* @description : This class implements a Rest service which takes some input 
					parameters and executes Google Geocoding API to get the 
					geo co-ordinates and returns as a service response.
*/

@RestResource(urlMapping='/coordinates/*')
global class WTB_CoordinatesService {
	@HttpGet
	global static WTB_CoordinateResponseMain doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		WTB_CoordinateResponseMain result = null;
		try{
			GPS_LocatorUtil.setGlobalConstants();
			String wtbAPIUser = req.headers.get(WTB_Constants.WTBAPIUSERID);
			if(String.isNotBlank(wtbAPIUser) && wtbAPIUser.equalsIgnoreCase(WTB_Constants.WTBAPIUSERVALUE)){
				WTB_CoordinatesRequestWrapper input = new WTB_CoordinatesRequestWrapper();
				input.zipCode = req.params.get('zipCode');
				input.address = req.params.get('address');
				input.city = req.params.get('city');
				input.state = req.params.get('state');
				input.country = req.params.get('country');
				result = getCoordinates(input); 
			}
			else{
				result = new WTB_CoordinateResponseMain();
				result.statusCode = WTB_Constants.ACCESS_DENIED_MESSAGE;
			}			
		}
		catch(Exception e){
			system.debug(e.getStackTraceString());
		}
		return result;
		
	}
	/*
	@description: method to get the coordinates for given input values. 
	This method internally calls google geo api to get the coordinate details.
	*/
	public static WTB_CoordinateResponseMain getCoordinates(WTB_CoordinatesRequestWrapper input){
		WTB_CoordinateResponseMain result = null;
		list<WTB_CoordinatesResponseWrapper> results = null;
		WTB_GoogleCoordinatesResponseWrapper gResult = GoogleCoordinateService.getCoordinates(input);
		result = processResult(gResult);
		return result;
	}
	/*
	@description: processes the google geocode api response and returns required values
	*/
	public static WTB_CoordinateResponseMain processResult(WTB_GoogleCoordinatesResponseWrapper gResult){
		system.debug('gresult:'+gResult);
		list<WTB_CoordinatesResponseWrapper> results = new list<WTB_CoordinatesResponseWrapper>();
		WTB_CoordinatesResponseWrapper result = null;
		WTB_CoordinateResponseMain mainResult = new WTB_CoordinateResponseMain();
		system.debug('gResult.results:'+gResult.results.size());
		
		if(gResult != null && gResult.status == WTB_Constants.STATUS_OK){
			for(WTB_GoogleCoordinatesResponseWrapper.cls_results res : gResult.results){ 
				result = new WTB_CoordinatesResponseWrapper();
				result.validResult = true;
				result.statusCode = gResult.status;
				result.locationType = res.geometry.location_type;
				result.longitude = res.geometry.location.lng;
				result.latitude = res.geometry.location.lat;
				results.add(result);
			}
			mainResult.results = results;
		}
		else{
			mainResult.statusCode = gResult.status;
		}
		system.debug('resuts:'+results);
		return mainResult;
	}
	/*
	@description: Wrapper class used to store Coordinates url response
	*/
	global class WTB_CoordinatesResponseWrapper{
		public boolean validResult;
		public String statusCode;
		public Double latitude;
		public Double longitude;
		public String errorMsg;
		public String locationType;
	}
	/*
	@description: Wrapper class used to store Coordinates url request
	*/
	global class WTB_CoordinatesRequestWrapper{
		public String address;
		public String city;
		public String state;
		public String zipCode;
		public String country;
	}
	/*
	@description: Wrapper class used to store list of coordinates response
	*/
	global class WTB_CoordinateResponseMain{
		public list<WTB_CoordinatesResponseWrapper> results;		
		public String statusCode = WTB_Constants.STATUS_OK;
	}	
}