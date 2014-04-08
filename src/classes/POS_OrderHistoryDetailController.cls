public class POS_OrderHistoryDetailController extends Controller_Base {

	private Id currentUser {get;set;}
	public List<POS_BreadCrumb> breadCrumbs {get;set;}
	public Cart__c cart {get;set;}
	public List<OrderHistoryLineItem> lineItems {get;set;}
	public List<OrderHistoryLineItem> lineItemsToDisplay {get;set;}
	
	public Map<Id,String> shipToStatusMap {get;set;}
	
	public Integer rowNumber {get;set;}
	public Integer rowLimit {get;set;}
	public Integer maxRows {get;set;}
	
	public static Integer SHIPTOS_PER_PAGE=5;
	
	public POS_OrderHistoryDetailController () {
		
		currentUser = UserInfo.getUserId(); 
		
		String cartId = Apexpages.currentPage().getParameters().get('id');
		
		cart = [Select c.Last_Submitted__c From Cart__c c where id = :cartId  ];
		
		List<Cart_Item__c> cartItems = [
			Select Item__r.Name, Item__r.Status__c, Ship_To__r.Name, Quantity__c, Status__c, Carrier__c, 
		  Item__r.Program__r.Name, Tracking_Code__c, Total_Spend__c
		  From Cart_Item__c 
		  	where Cart__c=:cartId
		  	order by Ship_To__r.Name ASC, Item__r.Program__r.Name ASC, Item__r.Name ASC
		];
		  
		String lastShipTo = null;
		lineItems=new List<OrderHistoryLineItem>();
		
		boolean hasShipped=false;
		boolean hasUnshipped=false;
		boolean hasCancelled=false;
		
		shipToStatusMap = new Map<Id,String>();
		
		/*
		To get the shipTo status, we need to look at the individual items and determine
		whether there are shipped and unshipped items.  We use the above boolean flags
		to determine that.  
		*/
		maxRows=0;
		for (Cart_Item__c cartItem:cartItems) {
			OrderHistoryLineItem lineItem = new OrderHistoryLineItem();
			lineItems.add(lineItem);
			lineItem.cartItem=cartItem;
			if (cartItem.Item__r.Status__c!='Cancelled') {
				lineItem.status=cartItem.Status__c;
			}
			else {
				lineItem.status=cartItem.Item__r.Status__c;
			}
			if (lastShipTo==null || lastShipTo!=cartItem.Ship_To__c) {
				if (lastShipTo!=null) {
					//This is another shipTo, so set the status of previous one
					System.debug('ShipTo:'+ lastShipTo);
					System.debug('Has shipped: '+hasShipped);
					System.debug('Has unshipped: '+hasUnshipped);
					System.debug('Has cancelled: '+hasCancelled);
					
					setShipToStatus(lastShipTo,hasShipped,hasUnshipped,hasCancelled);
					
					//reset flags
					hasShipped=false;
					hasUnshipped=false;
					hasCancelled=false;
					
					maxRows++;
				}
				lastShipTo = cartItem.Ship_To__c;
				lineItem.newShipTo=true;
				
			}
			else {
				lineItem.newShipTo=false;
			}
			System.debug('Status: '+lineItem.status);
			
			if (lineItem.status=='Shipped') {
				hasShipped=true;
			}
			else if (lineItem.status=='Cancelled') {
				hasCancelled=true;
			}
			else {
				hasUnshipped=true;
			}

		}
		//Need to handle the last record 
		setShipToStatus(lastShipTo,hasShipped,hasUnshipped,hasCancelled);
		
		
		
		
		//Initialize pagination.  Start with row 0 and limit to 5 shipTo records
		rowNumber=0;
		rowLimit=SHIPTOS_PER_PAGE;
		
		setLineItemsToDisplay();
		
       	
       	breadCrumbs = new List<POS_BreadCrumb>();
       	breadCrumbs.add(new POS_BreadCrumb('POS','POS_OrderWindowView'));
       	breadCrumbs.add(new POS_BreadCrumb('Order History','POS_OrderHistory'));
       	breadCrumbs.add(new POS_BreadCrumb('Tracking','#'));
		
	}
	
	private void setLineItemsToDisplay () {
		lineItemsToDisplay = new List<OrderHistoryLineItem>();
		Integer shipTosIntoSet = rowNumber;
		Integer shipTosLeftToAdd = rowLimit;
		Integer shipTosIterated = 0;
		
		String lastShipToId = null;
		for (OrderHistoryLineItem lineItem:lineItems) {
			if (lastShipToId==null || lineItem.cartItem.Ship_To__c!=lastShipToId) {
				//Ship to is different so handle it
				shipTosIterated++;
				lastShipToId = lineItem.cartItem.Ship_To__c;
			}
			
			System.debug('Ship to count: '+shipTosIterated+'/'+shipTosLeftToAdd+'/'+shipTosIntoSet);
			System.debug('Test 1: '+(shipTosIterated>shipTosLeftToAdd+shipTosIntoSet));
			System.debug('Test 2: '+(shipTosIntoSet<shipTosIterated));
			System.debug('Ship to: '+lineItem.cartItem.Ship_To__r.Name);
			
			//We've iterated through enough shipTos, so bail out
			if (shipTosIterated>shipTosLeftToAdd+shipTosIntoSet) {
				break;
			}
			//We're in the set of shipTos we need to be adding
			if (shipTosIntoSet<shipTosIterated) {
				lineItemsToDisplay.add(lineItem);
				System.debug('Added: '+lineItem);
			}
		}
	}
	
	private void setShipToStatus (String lastShipTo, boolean hasShipped, boolean hasUnshipped, boolean hasCancelled) {
		System.debug('Has shipped: '+hasShipped);
		System.debug('Has unshipped: '+hasUnshipped);
		System.debug('Has unshipped: '+hasCancelled);
		
		if (hasShipped && hasUnshipped) {
			shipToStatusMap.put(lastShipTo,'PARTIAL');
		}
		else if (hasShipped && !hasUnshipped) {
			shipToStatusMap.put(lastShipTo,'SHIPPED');
		}
		else if (!hasShipped && !hasUnshipped && hasCancelled){
			shipToStatusMap.put(lastShipTo,'CANCELLED');
		}
		else {
			shipToStatusMap.put(lastShipTo,'NOT SHIPPED');
		}
	}
	
	public PageReference nextOrders () {
		rowNumber=rowNumber+rowLimit;
		setLineItemsToDisplay();
		return null;
	}
	
	public PageReference previousOrders () {
		rowNumber=rowNumber-rowLimit;
		setLineItemsToDisplay();
		return null;
	}
	
	public class OrderHistoryLineItem {
		public boolean newShipTo {get;set;}
		public Cart_Item__c cartItem {get;set;}
		public String status {get;set;}
	}
}