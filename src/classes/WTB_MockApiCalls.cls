public with sharing class WTB_MockApiCalls {
public static HttpResponse getGoogleCoordinateMockResponse()
    {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody('{"status": "OK",'+
  '"results": [ {'+
    '"types": [ "locality", "political" ],'+
    '"formatted_address": "Toledo, España",'+
    '"address_components": [ {'+
      '"long_name": "Toledo",'+
      '"short_name": "Toledo",'+
      '"types": [ "locality", "political" ]'+
    '}, {'+
      '"long_name": "Toledo",'+
      '"short_name": "TO",'+
      '"types": [ "administrative_area_level_2", "political" ]'+
    '}, {'+
      '"long_name": "Castilla-La Mancha",'+
      '"short_name": "CM",'+
      '"types": [ "administrative_area_level_1", "political" ]'+
    '}, {'+
      '"long_name": "España",'+
      '"short_name": "ES",'+
      '"types": [ "country", "political" ]'+
    '} ],'+
    '"geometry": {'+
      '"location": {'+
        '"lat": 29.3832222,'+
        '"lng": 79.11474559999999'+
      '},'+
      '"location_type": "APPROXIMATE",'+
      '"viewport": {'+
        '"southwest": {'+
          '"lat": 39.7882200,'+
          '"lng": -4.1525353'+
        '},'+
        '"northeast": {'+
          '"lat": 39.9252666,'+
          '"lng": -3.8964165'+
        '}'+
      '},'+
      '"bounds": {'+
        '"southwest": {'+
          '"lat": 39.8105550,'+
          '"lng": -4.1796354'+
        '},'+
        '"northeast": {'+
          '"lat": 39.9250920,'+
          '"lng": -3.8147915'+
        '}'+
      '}'+
    '}'+
  '} ]}');
        return httpResponse;
    }
}