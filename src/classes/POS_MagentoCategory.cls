/***************************************************************************************************************************************************
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        05/02/2012 
 * @description Class representing Category Object in Magento, contains REST call methods for the same.

Updated By  : Jonathan Freese   
Date        : 11/18/13
Story/Task  : US278/TA1627

***************************************************************************************************************************************************/

public with sharing class POS_MagentoCategory {

    static   POS_Magento_Configuration__c settings = POS_Magento_Configuration__c.getOrgDefaults();
    static   String ORDERWINDOW_CATEGORY = settings.ORDERWINDOW_CATEGORY__c; //to be used as Parent for OrderWindow category
    static   String BRAND_CATEGORY = settings.BRAND_CATEGORY__c; //to be used as Parent for Brand category
    static   String PROGRAM_CATEGORY = settings.PROGRAM_CATEGORY__c; //to be used as Parent for Program category
    static   String TYPE_ORDER_WINDOW = settings.TYPE_ORDER_WINDOW__c;
    static   String TYPE_PROGRAM = settings.TYPE_PROGRAM__c;
    static   String TYPE_BRAND = settings.TYPE_BRAND__c;

    
    @future (callout=true)
    public static void createMagentoCategoryWindow(String windowId, String categoryName, String isActive) {
        // call create category with the right Root Category
        Dom.Document doc = createMagentoCategory( ORDERWINDOW_CATEGORY, TYPE_ORDER_WINDOW, categoryName, isActive, windowId, 'Order_Window__c');    
    }
    
  
    
    @future (callout=true)
    public static void createMagentoCategoryBrand(String brandId, String parentCategoryId, String categoryName, String isActive) {
        // call create category with the right Root Category
        Dom.Document doc;
        if (parentCategoryId != null) {
             Brand__c pb = [select Magento_Id__c from Brand__c where id=:parentCategoryId];
             doc = createMagentoCategory( pb.Magento_Id__c, TYPE_BRAND, categoryName, isActive, brandId, 'Brand__c');           
        } else {
            System.debug('brandId -' + brandId);
             doc = createMagentoCategory( BRAND_CATEGORY, TYPE_BRAND, categoryName, isActive, brandId, 'Brand__c');
        }
    }    
    
    
    public static Dom.Document createMagentoCategory(String catRoot, String catType, String categoryName, 
                                                                    String isActive, String sObjId, String sObjTypeName) {
        
       String API_ARGUMENTS = '&arg2[parentId]='+ catRoot +
            '&arg2[category][name]='+ EncodingUtil.urlEncode(categoryName,'UTF-8') + 
            '&arg2[category][is_active]=' + isActive +
            '&arg2[category][diageo_category_type]=' + catType +
            '&arg2[category][include_in_menu]=1&arg2[category][available_sort_by]=name&arg2[category][default_sort_by]=name';

       try { // the whole callout and post processing needs to be handled to avoid rollback from Queue insert in case of error 
        
            // use postMagentoCallDocument when a the callout is done as part of @future method
            return POS_MagentoIntegrationUtil.postMagentoCallDocument('category.create', API_ARGUMENTS, sObjId, sObjTypeName);
            
        } catch(Exception e) {
            return null;
        }           

    }
    
    @future (callout=true)
    //Start: changes for US278/TA1627 jfreese  - add sObjId and sObjTypeName
    public static void updateMagentoCategory(String categoryId, String categoryName, String isActive, String sObjId, String sObjTypeName) {
    //End: changes for US278/TA1627 jfreese
        
        String API_ARGUMENTS = '&arg2[categoryId]='+ categoryId + 
            '&arg2[category][name]='+ EncodingUtil.urlEncode(categoryName,'UTF-8') + 
            '&arg2[category][is_active]=' + isActive +
            '&arg2[category][include_in_menu]=1&arg2[category][available_sort_by]=name&arg2[category][default_sort_by]=name';
        
        try { // the whole callout and post processing needs to be handled to avoid rollback from Queue insert in case of error
            //Start: changes for US278/TA1627 jfreese -  - add sObjId and sObjTypeName
            Dom.Document doc = POS_MagentoIntegrationUtil.postMagentoCallDocument('category.update', API_ARGUMENTS, sObjId, sObjTypeName);
            //End: changes for US278/TA1627 jfreese
            System.debug('response doc -' + doc);
            
           // Dom.XMLNode root = doc.getRootElement();
        } catch(Exception e) {
            // do nothing
        }
    }     
    
    @future (callout=true)
    public static void createMagentoCategoryProgram(Id programId, String programName, String salesChannel, String salesDriver, String isActive) {
        
        String API_ARGUMENTS = '&arg2[parentId]='+ PROGRAM_CATEGORY +
            '&arg2[category][name]='+ EncodingUtil.urlEncode(programName,'UTF-8') + 
            '&arg2[category][is_active]=' + isActive +
            '&arg2[category][diageo_category_type]=' + TYPE_PROGRAM +
            '&arg2[category][include_in_menu]=1&arg2[category][available_sort_by]=name&arg2[category][default_sort_by]=name';
            
        // sync program Sales Channel & Sales Driver Attributes
        String salesChannelArg = getSalesChannelArgString(salesChannel);
        if(salesChannelArg != '') {
            API_ARGUMENTS = API_ARGUMENTS + '&arg2[category][diageo_sales_channel]=' + salesChannelArg;
        }
        
        String salesDriverArg = getSalesDriverArgString(salesDriver);
        if(salesDriverArg != '') {
            API_ARGUMENTS = API_ARGUMENTS + '&arg2[category][diageo_sales_driver]=' + salesDriverArg;
        }
            

       try { // the whole callout and post processing needs to be handled to avoid rollback from Queue insert in case of error 
        
            // use postMagentoCallDocument when a the callout is done as part of @future method
            POS_MagentoIntegrationUtil.postMagentoCallDocument('category.create', API_ARGUMENTS, programId, 'Program__c');
            
        } catch(Exception e) {
            
        }               
    }  
        
    @future (callout=true)
    //Start: changes for US278/TA1627 jfreese  - add sObjId
    public static void updateMagentoCategoryProgram(String magentoId, String programName, String salesChannel, String salesDriver, String isActive, String sObjId) {
    //End: changes for US278/TA1627 jfreese
        
        String API_ARGUMENTS = '&arg2[categoryId]='+ magentoId + 
            '&arg2[category][name]='+ EncodingUtil.urlEncode(programName,'UTF-8') + 
            '&arg2[category][is_active]=' + isActive +
            '&arg2[category][include_in_menu]=1&arg2[category][available_sort_by]=name&arg2[category][default_sort_by]=name';
            
        // sync program Sales Channel & Sales Driver Attributes
        // Note: setting this arg even when salesChannelArg == '', this will help clear all values when updated to do so
        API_ARGUMENTS = API_ARGUMENTS + '&arg2[category][diageo_sales_channel]=' + getSalesChannelArgString(salesChannel);
        API_ARGUMENTS = API_ARGUMENTS + '&arg2[category][diageo_sales_driver]=' + getSalesDriverArgString(salesDriver);
        
        try { // the whole callout and post processing needs to be handled to avoid rollback from Queue insert in case of error
            //Start: changes for US278/TA1627 jfreese  - add sObjId
            Dom.Document doc = POS_MagentoIntegrationUtil.postMagentoCallDocument('category.update', API_ARGUMENTS, sObjId, 'Program__c');
            //End: changes for US278/TA1627 jfreese
            System.debug('response doc -' + doc);
            
           // Dom.XMLNode root = doc.getRootElement();
        } catch(Exception e) {
            // do nothing
        }
    }    
    
    @future (callout=true)
    //Start: changes for US278/TA1627 jfreese - add sObjTypeName to set batch queue priority
    public static void deleteMagentoCategory(String categoryId, String sObjTypeName) {
    //End: changes for US278/TA1627 jfreese
        String API_ARGUMENTS = '&arg2[categoryId]='+ categoryId;
            
        try { // the whole callout and post processing needs to be handled to avoid rollback from Queue insert in case of error
            //Start: changes for US278/TA1627 jfreese - add sObjTypeName to set batch queue priority
            Dom.Document doc = POS_MagentoIntegrationUtil.postMagentoCallDocument('category.delete', API_ARGUMENTS, categoryId, sObjTypeName);
            //End: changes for US278/TA1627 jfreese
            System.debug('response doc -' + doc);
            
        } catch(Exception e) {
            // do nothing
        }
    }  
    
    private static String getSalesChannelArgString(String salesChannel) {
        String salesChannelArg = '';
        if(salesChannel != null) {
            String[] salesChannels = salesChannel.split(';');
            for(String sc : salesChannels) {
                if(sc=='Execution Plan') {
                    salesChannelArg = salesChannelArg + '1,';
                } else if(sc=='Flow Visibility') {
                    salesChannelArg = salesChannelArg + '2,';
                } else if(sc=='Multicultural') {
                    salesChannelArg = salesChannelArg + '3,';
                } else if(sc=='VAP') {
                    salesChannelArg = salesChannelArg + '4,';
                }
            } 
        }
        
        if (salesChannelArg.lastIndexOf(',') != -1) {
            return salesChannelArg.substring(0, salesChannelArg.lastIndexOf(','));
        } else {
            return salesChannelArg;
        }
        
    }
    
    private static String getSalesDriverArgString(String salesDriver) {
        String salesDriverArg = '';
        if(salesDriver=='INP') {
            salesDriverArg = '1';
        } else if(salesDriver=='Distribution') {
            salesDriverArg = '2';
        } else if(salesDriver=='Display/Visibility') {
            salesDriverArg = '3';
        } else if(salesDriver=='Innovation') {
            salesDriverArg = '4';
        } else if(salesDriver=='Sustainovation') {
            salesDriverArg = '5';
        }
        
        return salesDriverArg;      
    }
    
    // to be used for initial setup of Brands in Category for the Brands that already exists in SFDC
    // Note: call to this would have to be made in 2 stages, one with NO parent Brands and the second one with parent Brands
    public static void massSyncMagentoCategoryBrand(List<Brand__c> brandList) {
    
        String isActive = '1';
        String catRoot;
        String API_ARGUMENTS;
        
        // call create category with the right Root Category
        for(Brand__c b : brandList) {
            if (b.Parent_Brand__c != null) {
                catRoot = b.Parent_Brand__r.Magento_Id__c;
            } else {
                catRoot = BRAND_CATEGORY;
            }
            
            API_ARGUMENTS = '&arg2[parentId]='+ catRoot +
                '&arg2[category][name]='+ EncodingUtil.urlEncode(b.Name,'UTF-8') + 
                '&arg2[category][is_active]=' + isActive +
                '&arg2[category][diageo_category_type]=' + TYPE_BRAND +
                '&arg2[category][include_in_menu]=1&arg2[category][available_sort_by]=name&arg2[category][default_sort_by]=name';
           
            POS_MagentoIntegrationUtil.saveMagentoCallToQueue('category.create', API_ARGUMENTS, b.Id, 'Brand__c');
         }          

    }       
    
    public static Dom.Document getMagentoCategoryInfo(String categoryId) {
        
        String API_ARGUMENTS = '&arg2[categoryId]='+ categoryId;
        Dom.Document doc = POS_MagentoIntegrationUtil.getMagentoCallDocument('category.info', '');
        
        return doc;
    }    

}