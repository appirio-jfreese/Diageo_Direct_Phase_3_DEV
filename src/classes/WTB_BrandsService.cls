/*
* @author Neeraj Sharma
* @date 10/09/2013
* @description : This class implements a Rest service which takes some input 
					parameters and returns the brand & their product list on the basis of given values
*/

@RestResource(urlMapping='/brands/*')
global class WTB_BrandsService {
	
	@HttpGet
	global static WTB_BrandsResponseMain doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		WTB_BrandsResponseMain result = new WTB_BrandsResponseMain();
		list<WTB_BrandsResponseWrapper> brands = null;
		try{
			GPS_LocatorUtil.setGlobalConstants();
			String wtbAPIUser = req.headers.get(WTB_Constants.WTBAPIUSERID);
			if(String.isNotBlank(wtbAPIUser) && wtbAPIUser.equalsIgnoreCase(WTB_Constants.WTBAPIUSERVALUE)){
				WTB_BrandsService.WTB_BrandsRequestWrapper input = new WTB_BrandsService.WTB_BrandsRequestWrapper();
				input.brandId = req.params.get('brandId');
				input.includeProducts = req.params.get('includeProducts');
				input.locale = req.params.get('locale');
				if(String.isBlank(input.locale)){
					input.locale = WTB_Constants.DEFAULT_LOCALE;
				}
				if(String.isNotBlank(input.brandId)){
					input.includeProducts = 'true';
				}
				system.debug('input:'+input);
				brands = getBrands(input);
				result.results = brands; 
				result.statusCode = WTB_Constants.STATUS_OK;
			}
			else{
				result.statusCode = WTB_Constants.ACCESS_DENIED_MESSAGE;
			}
		}
		catch(Exception e){
			system.debug(e.getStackTraceString());
		}
		return result;
		
	}
	/* 
	@description: return the brand lists and their products
	*/
	public static list<WTB_BrandsResponseWrapper> getBrands(WTB_BrandsService.WTB_BrandsRequestWrapper input){
		list<WTB_BrandsResponseWrapper> brandWrappers = null;
		//Select d.Name, d.Brand_Category__c, d.API_External_ID__c, (Select Name, API_External_ID__c, Category__c From Diageo_Products__r) From Diageo_Brand__c d
		
		String query = 'Select Name, Brand_Category__c, API_External_ID__c';
		if(String.isNotBlank(input.includeProducts) && input.includeProducts == 'true'){
			query += ', (Select Name, API_External_ID__c, Category__c From Diageo_Products__r)';
		}
		query += ' From Diageo_Brand__c Where Locale__c = \''+input.locale+'\'';
		
		if(String.isNotBlank(input.brandId)){
			query+= ' and API_External_ID__c = \''+input.brandId+'\'';
		}
		system.debug('query:'+query);
		List<Diageo_Brand__c> brands = (List<Diageo_Brand__c>)database.query(query);
		brandWrappers = processResult(brands);
		return brandWrappers;
	}
	/* 
	@description: processes the google geocode api response and returns required values
	*/
	public static list<WTB_BrandsResponseWrapper> processResult(List<Diageo_Brand__c> brandList){
		system.debug('brandList:'+brandList);
		list<WTB_BrandsResponseWrapper> brands = new list<WTB_BrandsResponseWrapper>();
		WTB_BrandsResponseWrapper brand = null;
		system.debug('brandList:'+brandList.size());
		
		if(brandList != null && brandList.size() > 0){
			for(Diageo_Brand__c dBrand : brandList){ 
				brand = new WTB_BrandsResponseWrapper();
				brand.brandId = dBrand.API_External_ID__c;
				brand.salesforceId = dBrand.API_External_ID__c;
				brand.brandName = dBrand.Name;
				brand.brandCategory = dBrand.Brand_Category__c;
				if(dBrand.Diageo_Products__r != null){
					list<BrandProduct> products = new list<BrandProduct>();
					BrandProduct product = null;
					for(Diageo_Product__c dProduct: dBrand.Diageo_Products__r){
						product = new BrandProduct();
						product.productId = dProduct.API_External_ID__c;
						product.salesforceId = dProduct.API_External_ID__c;
						product.productName = dProduct.Name;
						products.add(product);
					}
					brand.products = products;
				}
				brands.add(brand);
			}
		}
		system.debug('brands:'+brands);
		return brands;
	}
	/*
	@description: Wrapper class used to store Brands url response
	*/
	global class WTB_BrandsResponseWrapper{
		global String brandId;
		global String salesforceId;
		global String brandName;
		global String brandCategory;
		global list<BrandProduct> products;
	}
	/*
	@description: Wrapper class used to store Products for a brand
	*/
	global class BrandProduct{
		global String productId;
		global String salesforceId;
		global String productName;
	}
	/*
	@description: Wrapper class used to store Brands url request
	*/
	global class WTB_BrandsRequestWrapper{
		global String includeProducts;
		global String locale = WTB_Constants.DEFAULT_LOCALE;
		global String brandId;
	}
	global class WTB_BrandsResponseMain{
		global list<WTB_BrandsResponseWrapper> results;		
		global String statusCode = WTB_Constants.STATUS_OK;
	}
	
}