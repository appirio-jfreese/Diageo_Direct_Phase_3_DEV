@IsTest(SeeAllData=false)
public class WTB_GoogleCoordinatesResponse_Test{

	static testMethod void testParse() {
		String json=		'{'+
		'  "status": "OK",'+
		'  "results": [ {'+
		'    "types": [ "locality", "political" ],'+
		'    "formatted_address": "Toledo, España",'+
		'    "address_components": [ {'+
		'      "long_name": "Toledo",'+
		'      "short_name": "Toledo",'+
		'      "types": [ "locality", "political" ]'+
		'    }, {'+
		'      "long_name": "Toledo",'+
		'      "short_name": "TO",'+
		'      "types": [ "administrative_area_level_2", "political" ]'+
		'    }, {'+
		'      "long_name": "Castilla-La Mancha",'+
		'      "short_name": "CM",'+
		'      "types": [ "administrative_area_level_1", "political" ]'+
		'    }, {'+
		'      "long_name": "España",'+
		'      "short_name": "ES",'+
		'      "types": [ "country", "political" ]'+
		'    } ],'+
		'    "geometry": {'+
		'      "location": {'+
		'        "lat": 39.8567775,'+
		'        "lng": -4.0244759'+
		'      },'+
		'      "location_type": "APPROXIMATE",'+
		'      "viewport": {'+
		'        "southwest": {'+
		'          "lat": 39.7882200,'+
		'          "lng": -4.1525353'+
		'        },'+
		'        "northeast": {'+
		'          "lat": 39.9252666,'+
		'          "lng": -3.8964165'+
		'        }'+
		'      },'+
		'      "bounds": {'+
		'        "southwest": {'+
		'          "lat": 39.8105550,'+
		'          "lng": -4.1796354'+
		'        },'+
		'        "northeast": {'+
		'          "lat": 39.9250920,'+
		'          "lng": -3.8147915'+
		'        }'+
		'      }'+
		'    }'+
		'  } ]'+
		'}';
		WTB_GoogleCoordinatesResponseWrapper.parse(json);
	}
    
    static testmethod void testSubClasses() {
        WTB_GoogleCoordinatesResponseWrapper.cls_results c = new WTB_GoogleCoordinatesResponseWrapper.cls_results();
        WTB_GoogleCoordinatesResponseWrapper.cls_address_components a = new WTB_GoogleCoordinatesResponseWrapper.cls_address_components();
        WTB_GoogleCoordinatesResponseWrapper.cls_geometry g = new WTB_GoogleCoordinatesResponseWrapper.cls_geometry();
        WTB_GoogleCoordinatesResponseWrapper.cls_location l = new WTB_GoogleCoordinatesResponseWrapper.cls_location();
        WTB_GoogleCoordinatesResponseWrapper.cls_viewport v = new WTB_GoogleCoordinatesResponseWrapper.cls_viewport();
        WTB_GoogleCoordinatesResponseWrapper.cls_southwest s = new WTB_GoogleCoordinatesResponseWrapper.cls_southwest();
        WTB_GoogleCoordinatesResponseWrapper.cls_northeast n = new WTB_GoogleCoordinatesResponseWrapper.cls_northeast();
        WTB_GoogleCoordinatesResponseWrapper.cls_bounds b = new WTB_GoogleCoordinatesResponseWrapper.cls_bounds();  
		WTB_GoogleCoordinatesResponseWrapper.cls_results[] results = new WTB_GoogleCoordinatesResponseWrapper.cls_results[10];
    }
}