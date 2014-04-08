/*
* @author Neeraj Sharma
* @date 07/09/2013
* @description : This class executes Google Geocoding API to get the 
                    geo co-ordinates and returns as a service response.
*/
public with sharing class GoogleCoordinateService {
/*
    @description: executes coordinates url and returns the result
    */
    public static WTB_GoogleCoordinatesResponseWrapper getCoordinates(WTB_CoordinatesService.WTB_CoordinatesRequestWrapper inputParams){
        WTB_GoogleCoordinatesResponseWrapper coordinateInfo = null;
        String componentParamValue = '';
        if(inputParams != null){
            
            String callingUrl =  '';//WTB_Constants.GOOGLE_GEOCODE_URL;
            if(String.isNotBlank(inputParams.address)){
                callingUrl += (inputParams.address+'+');
            }
            if(String.isNotBlank(inputParams.city)){
                callingUrl += (inputParams.city+'+');
                componentParamValue += ('administrative_area_level_2:'+inputParams.city);
            }
            if(String.isNotBlank(inputParams.state)){
                callingUrl += (inputParams.state+'+');
                if(String.isNotBlank(componentParamValue)){
                    componentParamValue+='|';
                }
                componentParamValue += ('administrative_area_level_1:'+inputParams.state);
            }
            if(String.isNotBlank(inputParams.zipCode)){
                callingUrl += (inputParams.zipCode+'+');
                if(String.isNotBlank(componentParamValue)){
                    componentParamValue+='|';
                }
                componentParamValue += ('postal_code:'+inputParams.zipCode);
            }
            if(String.isNotBlank(inputParams.country)){
                callingUrl += (inputParams.country);
                if(String.isNotBlank(componentParamValue)){
                    componentParamValue+='|';
                }
                componentParamValue += ('country:'+inputParams.country);
            }
            if(String.isNotBlank(componentParamValue)){
                callingUrl+=('&components='+componentParamValue);
            }
            callingUrl = WTB_Constants.GOOGLE_GEOCODE_URL+EncodingUtil.urlEncode(callingUrl, 'UTF-8');
            if(String.isNotBlank(WTB_Constants.CLIENT_ID)){
            	callingUrl +='&client='+WTB_Constants.CLIENT_ID;
            }
            if(String.isNotBlank(WTB_Constants.SIGNATURE)){
            	callingUrl +='&signature='+WTB_Constants.SIGNATURE;
            }
            system.debug('url:'+callingUrl);
            HttpResponse coordinateResponse = HttpCallout.publicCallout(callingUrl);
            system.debug('response:'+coordinateResponse.getBody());
            coordinateInfo = (WTB_GoogleCoordinatesResponseWrapper)JSON.deserialize(coordinateResponse.getBody(), WTB_GoogleCoordinatesResponseWrapper.Class);
            system.debug('coordinateinfo:'+coordinateInfo);
        }
        return coordinateInfo;
    }   
        
}