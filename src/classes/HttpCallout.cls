/*
* @author Neeraj Sharma
* @date 05/09/2013
* @description Utility class to make http callouts
*/
public class HttpCallout {
	/*
	@description: executes public callout without any authentication
	*/
	public static HTTPResponse publicCallout(String URL){
		HttpRequest req = new HttpRequest();
		HTTPResponse res = null;
		req.setEndpoint(URL);
		req.setMethod('GET');
		Http http = new Http();
		try{
			if(!test.isRunningTest()){
				res = http.send(req);
			}
			else{
				res = WTB_MockApiCalls.getGoogleCoordinateMockResponse();
			}
		}
		catch(Exception exp){
			system.debug(exp.getStackTraceString());
		}
		return res;
	}   
}