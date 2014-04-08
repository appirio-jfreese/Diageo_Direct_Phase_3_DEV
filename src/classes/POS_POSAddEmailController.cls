/**
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        07/03/2012
 * @description Controller to add/remove Customers to a OrderWindow
 **/
public with sharing class POS_POSAddEmailController {
    
    public List<CustomerWrapper> availableCustomers{get; set;}
    public List<Order_Window_Customer__c> existingCustomers{get; set;}
    public Order_Window__c orderWindow {get; set;}
    
    public String selectedProfile {get; set;}
    public List<Profile> profileItems{get; set;}
    public String name {get; set;}
    public String accountName {get; set;}
    public string type {get; set;}
    public Boolean openAndBeyond {get; set;}

    /**** Variables for custom Email author ****/
    public Boolean ShowCustomEmailAuthor  {get; set;}
    public String fromAddress             {get; set;}
    public String toAddress               {get; set;} 
    
    public Boolean ShowJavascript  {get; set;}   
    
    public POS_POSAddEmailController(ApexPages.StandardController controller) {
        ShowJavascript=false;
        String owId = ApexPages.currentPage().getParameters().get('owId');
        type = ApexPages.currentPage().getParameters().get('type');
        ShowCustomEmailAuthor  = false;
        
        orderWindow = [Select o.Id, o.Type__c, o.Status__c, o.Name, o.Magento_Id__c, o.Fiscal_Year__c 
                        From Order_Window__c o where o.Id = :owId][0];
        if(orderWindow.Status__c == 'Open' || orderWindow.Status__c == 'Closed' || orderWindow.Status__c == 'Completed' || orderWindow.Status__c == 'Archived') {
            openAndBeyond = true;
        } else {
            openAndBeyond = false;
        }                       
                        
        profileItems = [Select p.UserType, p.Name, p.Id From Profile p];
                                
        existingCustomers = [Select o.Id, o.Magento_Id__c, o.Customer__c, o.Open_For_Shopping__c From Order_Window_Customer__c o where o.Order_Window__c=:orderWindow.Id];
    
    }
    
    public PageReference searchUsers() {
        
        String queryStr = 'Select u.Username, u.UserType, u.UserRole.Name, u.Profile.Name, ' +
             'u.Contact.Account.Name, u.Contact.Account.ShippingState, ' +
             'u.POS_Access__c, u.Name, u.Magento_Id__c, u.LastName, u.LastLoginDate, u.IsPortalSelfRegistered, ' +
             'u.IsPortalEnabled, u.IsActive, u.Id, u.FirstName, u.Email, u.AccountId From User u ' +
             'where u.IsActive=true and u.POS_Access__c=true ';
             // and u.Id not in :existingUserIds
             
        String nameLike = '%';
        if(name != null && name.trim() != '') {
            nameLike = nameLike + name + '%';
            queryStr = queryStr + ' and u.Name LIKE :nameLike';
        }

        String accountNameLike = '%';
        if(accountName != null && accountName.trim() != '') {
            accountNameLike = accountNameLike + accountName + '%';
            queryStr = queryStr + ' and u.Contact.Account.Name LIKE :accountNameLike';
        }
        
        if(selectedProfile != null && selectedProfile != 'ALL') {
            queryStr = queryStr + ' and u.Profile.Id = :selectedProfile';
        }   
        System.debug('selectedProfile = ' + selectedProfile);   
        
        // order by User Name
        queryStr = queryStr + ' order by u.Name';           
        List<User> availableUsers = Database.query(queryStr); 
            
        availableCustomers = new List<CustomerWrapper>();   
        for(User u : availableUsers) {
              // create a new wrapper by passing User for construction
              CustomerWrapper cw = new CustomerWrapper(u);
              for(Order_Window_Customer__c owc : existingCustomers) {
                if(owc.Customer__c==u.Id) {
                    //cw.checked = true;
                    cw.canShop = owc.Open_For_Shopping__c;
                    break;
                }
              }
              
              // add the wrapper to the results
              availableCustomers.add(cw);
        }           
            
        return null;
    }    
    
    public PageReference renderEmailAuthor() {
    fromAddress = [Select Id,Email from User where Id = :UserInfo.getUserId()].Email;
    toAddress   = '';
         for (CustomerWrapper cw : availableCustomers) {
                if (cw.checked) 
                 toAddress +=  cw.usr.Email + ';';    
        }    
     ShowJavascript=true;
     ShowCustomEmailAuthor = true;
     return null;
    }
    
    public PageReference saveOWCAssignments() {
        
        List<Order_Window_Customer__c> owcAddList = new List<Order_Window_Customer__c>();
        List<Order_Window_Customer__c> owcRemoveList = new List<Order_Window_Customer__c>();
 
        // add the selected Customer to a new List
        Boolean openForShopping;
        for (CustomerWrapper cw : availableCustomers) {
            if (cw.checked) {
                Boolean recordAdded = true;
                for(Order_Window_Customer__c owc : existingCustomers) {
                    if(owc.Customer__c==cw.usr.Id) {
                        recordAdded = false;
                        break;
                    }
                }
                
                if(recordAdded) {
                    if(orderWindow.Status__c=='Open') { openForShopping = true; } else { openForShopping = false; }
                    owcAddList.add(new Order_Window_Customer__c(Customer__c=cw.usr.id, Order_Window__c=orderWindow.Id, Open_For_Shopping__c=openForShopping));
                }

            } else {
                Order_Window_Customer__c removedOWC = null;
                for(Order_Window_Customer__c owc : existingCustomers) {
                    if(owc.Customer__c==cw.usr.Id) {
                        removedOWC = owc;
                        break;
                    }
                }  
                
                if(removedOWC != null) {
                    owcRemoveList.add(removedOWC);
                }                           
            }
        }
        
        try {
            if (owcAddList.size() > 0) {
                insert owcAddList;
            } 
            
            if (owcRemoveList.size() > 0) {
                delete owcRemoveList;
            }   
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
            return null;
        }      
        
        return new PageReference('/'+ orderWindow.Id);    
 
    }        

    
    public PageReference back() {
        return new PageReference('/'+ orderWindow.Id);
    }           
    
    public class CustomerWrapper {
     
        public Boolean checked { get; set; }
        public Boolean canShop { get; set; }
        public User usr { get; set;}
     
        public CustomerWrapper(){
            usr = new User();
        }
     
        public CustomerWrapper(User u){
            usr = u;
        }
     
    }    

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('ALL', '-- All Profiles --'));
        for(Profile p:profileItems) {
            options.add(new SelectOption(p.Id,p.Name));
        }

        return options;
    }   
  

}