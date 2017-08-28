global  with sharing  class ManageOrderController {

	public Boolean isEnableFirst {get; set;}
	public Boolean isEnableLast {get; set;}
	public Boolean isEnablePrevious {get; set;}
	public Boolean isEnableNext {get; set;}
	public string FilterID {get; set;}
	public String OrderLevel {get; set;}
	public String UserMessage {get; set;}
	public String SiteSpecificMessage {get; set;}
	public String EnableCustomLinks {get; set;}
	public String EnableOrder {get; set;}
	public String EnableBulkOrder {get; set;}
	public Integer PageNumber {get; set;}
	public Integer TotalPages {get; set;}
	public User userDetails {get; set;}
	public List<PartnerOrderInnerClass> PartnerOrders {get; set;}
	public Portal_Configuration__c portalConfiguration {get; set;}
	public ApexPages.StandardSetController setCon {get; set;}
	private List<PartnerOrderInnerClass> lstWrapperPartnerOrders;
	private Integer iRecordIndex;
	private Integer iTotalRecords;
	private Integer iReminder;
	private final static String strStyleInline = 'inline';
	private final static String strStyleNone = 'none';
	private final static String strOrderStatusNew = 'New (not yet submitted)';
	private final static String strOrderStatusSubmitted = 'Submitted (order placed)';
	public String PartnerOrderDeleteId { get; set; }
	public String NumOfItem { get; set; }
	public Integer iNumOfItem { get; set; }

	public ManageOrderController() {
		System.debug('partnerOrder::constructors');
		PageNumber = 1;
		iReminder = 0;
		iNumOfItem = 100;
		NumOfItem = '100';
		try {
			userDetails = [SELECT Id, Contact.Account.Order_Level__c , Username, contactID, Site__c , Name, Contact.Id, IsActive,  Email, Contact.Account.Name, Contact.AccountID,  Contact.Name, Contact.FirstName, Contact.LastName, Contact.npe01__PreferredPhone__c, Contact.MobilePhone, Contact.npe01__WorkPhone__c, Contact.HomePhone, Contact.npe01__Primary_Address_Type__c , Contact.npe01__Home_Address__c, Contact.EnableBulkOrder__c, Contact.Can_order_kid_Pack__c
			               FROM User  WHERE Username = : Userinfo.getUserName() LIMIT 1];
			if (userDetails != null)
				setCon  = new ApexPages.StandardSetController(Database.getQueryLocator(
				            [SELECT Id, Name, IsBulkOrder__c, Emergency_Order__c, Child_First_Name__c, Child_Age__c, Status__c, Caregiver_s_First_name__c, Submitted_Date__c,  Contact__r.Name, Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c
				             FROM Partner_Order__c where Contact__r.AccountId = :userdetails.Contact.AccountId OR Partner__c =: userdetails.Contact.AccountId LIMIT 10000 ]));

			portalConfiguration = [SELECT Location__c, Message__c, EnableBulkOrder__c, EnableOrder__c, ProfilePageMessage__c FROM Portal_Configuration__c WHERE Location__c = : userDetails.Site__c limit 1];

		} catch (Exception e) {}
		if ( userDetails != null )
			OrderLevel = String.valueOf(userDetails.Contact.Account.Order_Level__c);
		setPartnerMessages();
		setCon.setPageSize(20);
		SetMyOrderID();
		lstWrapperPartnerOrders = new List<PartnerOrderInnerClass>();
		FillList();
		getPartnerOrders() ;
		System.debug('partnerOrder::constructor');
	}
	public void setPartnerMessages() {

		if ( portalConfiguration != null ) {
			UserMessage = portalConfiguration.Message__c;
			SiteSpecificMessage = portalConfiguration.ProfilePageMessage__c;
			if ( portalConfiguration.EnableOrder__c == True && userdetails.Contact.Can_order_kid_Pack__c == True)
				EnableOrder = strStyleInline;
			else
				EnableOrder = strStyleNone;
			if ( portalConfiguration.EnableBulkOrder__c  && userdetails.Contact.EnableBulkOrder__c == True )
				EnableBulkOrder = strStyleInline;
			else
				EnableBulkOrder = strStyleNone;
			if ( portalConfiguration.EnableOrder__c == False && portalConfiguration.EnableBulkOrder__c == False && userdetails.Contact.EnableBulkOrder__c == False )
				EnableCustomLinks = strStyleNone;
			else
				EnableCustomLinks = strStyleInline;
		}


	}
	public void SetMyOrderID() {

		System.debug('partnerOrder::SetMyOrderId');
		//FilterID = '00BM0000000adC6MAI';
		for (Selectoption option : getViews()) {
			if (option.getLabel() == 'My Orders')
				FilterID = option.getValue();

		}
		if (FilterID == null) {
			FilterID = getViews()[0].getValue();
		}

		setCon.setFilterId(FilterID);
	}
	public void FillList() {

		System.debug('partnerOrder::FillList');
		lstWrapperPartnerOrders = new   List<PartnerOrderInnerClass>();
		if ( setCon != null )
			for (Partner_Order__c porder : (List<Partner_Order__c>) setCon.getRecords()) {
				// when user.contact.account is equal to the account of parner orders contact account
				if ( userdetails.Contact.AccountID == porder.Contact__r.AccountId || userdetails.Contact.AccountID == porder.Partner__c) {
					if ( userdetails.ContactId == porder.Contact__r.ID ) {
						if ((porder.Status__c == strOrderStatusNew || porder.Status__c == strOrderStatusSubmitted) &&	porder.IsBulkOrder__c == false)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleInline, strStyleInline, strStyleNone, strStyleInline));
						if ((porder.Status__c != strOrderStatusNew || porder.Status__c != strOrderStatusSubmitted ) && porder.IsBulkOrder__c == true)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleNone, strStyleInline, strStyleInline));
						if ((porder.Status__c != strOrderStatusNew && porder.Status__c != strOrderStatusSubmitted ) &&	porder.IsBulkOrder__c == false)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleInline, strStyleNone, strStyleNone));
					} else
						lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleNone, strStyleNone, strStyleNone) );
				}
			}
		while (setcon.getHasNext() == True && lstWrapperPartnerOrders != null ) { //&& lstWrapperPartnerOrders.size() <= 500 )  commented by Pravin for all order was not getting on the page issue
			// on 28/01/2015
			setcon.next();
			for (Partner_Order__c porder : (List<Partner_Order__c>) setCon.getRecords()) {
				if ( userdetails.Contact.AccountID == porder.Contact__r.AccountId || userdetails.Contact.AccountID == porder.Partner__c) {
					if ( userdetails.ContactId == porder.Contact__r.ID ) {
						if ((porder.Status__c == strOrderStatusNew || porder.Status__c == strOrderStatusSubmitted) &&	porder.IsBulkOrder__c == false)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleInline, strStyleInline, strStyleNone, strStyleInline));
						if ((porder.Status__c != strOrderStatusNew || porder.Status__c != strOrderStatusSubmitted ) && porder.IsBulkOrder__c == true)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleNone, strStyleInline, strStyleInline));
						if ((porder.Status__c != strOrderStatusNew && porder.Status__c != strOrderStatusSubmitted ) &&	porder.IsBulkOrder__c == false)
							lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleInline, strStyleNone, strStyleNone));
					} else
						lstWrapperPartnerOrders.add(new PartnerOrderInnerClass(porder, strStyleNone, strStyleNone, strStyleNone, strStyleNone) );
				}
			}
		}
		lstWrapperPartnerOrders.sort();
		iTotalRecords = lstWrapperPartnerOrders.size() ;
		TotalPages = (iTotalRecords / iNumOfItem);
		Integer iReminder = (math.mod(iTotalRecords , iNumOfItem));
		if ( iReminder > 0 )
			TotalPages = TotalPages + 1;
		PageNumber = 1;
		iRecordIndex = 0;
	}
	public void getPartnerOrders() {
		if ( NumOfItem != null )
			iNumOfItem = Integer.valueOf(NumOfItem);
		System.debug('partnerOrder::getpartnerorders');
		PartnerOrders = new List<PartnerOrderInnerClass>();
		while ( iRecordIndex < iTotalRecords ) {
			PartnerOrders.add(lstWrapperPartnerOrders.get((iRecordIndex)));
			iRecordIndex++;
			if (( PartnerOrders.size() >= iNumOfItem ) || ( (iRecordIndex) == iTotalRecords ))
				break;
		}
		Pagination();
		System.debug('iRecordIndex value::' + iRecordIndex);
	}
	public void Pagination() {

		if ( PageNumber != TotalPages && TotalPages > 1 ) {
			isEnableFirst = isEnablePrevious = True;
			isEnableLast = isEnableNext = False;
		}
		if ( PageNumber == TotalPages && TotalPages > 1 ) {
			isEnableFirst = isEnablePrevious = False;
			isEnableLast = isEnableNext = True;
		}
		if ( PageNumber != TotalPages && TotalPages > 1 && PageNumber != 1 ) {
			isEnableFirst = isEnablePrevious = False;
			isEnableLast = isEnableNext = False;
		}
		if ( PageNumber == 1 && TotalPages == 1)
			isEnableFirst = isEnableLast = isEnablePrevious = isEnableNext = True;
		if ( PageNumber == 1 &&  TotalPages != 1 ) {
			isEnableFirst = isEnablePrevious = True;
			isEnableLast = isEnableNext = False;
		}
	}
	public List<SelectOption> getViews() {

		List<Selectoption> lstoptions = setCon.getListViewOptions();
		lstoptions.sort();
		return lstoptions;
	}
	public void getRecords() {
		System.debug('partnerOrder::getRecords');
		lstWrapperPartnerOrders = new List<PartnerOrderInnerClass>();
		setcon.first();
		setcon.setFilterId(FilterId);
		FillList();
		getPartnerOrders() ;
	}
	public PageReference first() {

		iRecordIndex = 0;
		PageNumber = 1;
		getPartnerOrders();
		System.debug('partnerOrder::first');
		return null;
	}
	public PageReference last() {

		PageNumber = TotalPages;
		iReminder = math.mod(iTotalRecords, iNumOfItem);
		if ( iReminder > 0 ) {
			iRecordIndex = (iTotalRecords - iReminder);
			getPartnerOrders() ;
		}
		System.debug('partnerOrder::last');
		return null;
	}
	public PageReference previous() {

		PageNumber--;
		if ( iReminder > 0 ) {
			iRecordIndex = iRecordIndex - (iReminder + iNumOfItem);
			iReminder = 0;
			PartnerOrders = new List<PartnerOrderInnerClass>();
			for (Integer i = 0; i < iNumOfItem; i++) {
				PartnerOrders.add(lstWrapperPartnerOrders.get((iRecordIndex)));
				iRecordIndex++;
			}
			Pagination();
		} else if ( iRecordIndex >= iNumOfItem * 2) {
			iRecordIndex = (iRecordIndex - iNumOfItem * 2);
			getPartnerOrders() ;
		} else if ( iRecordIndex < iNumOfItem * 2 ) {
			iRecordIndex = 0;
			getPartnerOrders() ;
		}
		System.debug('partnerOrder::previous');
		return null;
	}
	public PageReference next() {

		iReminder = 0;
		PageNumber++;
		getPartnerOrders() ;
		System.debug('partnerOrder::next');
		return null;
	}
	public void cancel() {
	}
	public Pagereference  DeleteOrder() {

		Partner_Order__c PartnerOrderDelete = [ select id, Name from Partner_Order__c where Id = :PartnerOrderDeleteId limit 1 ];
		if ( PartnerOrderDelete != null )
			delete PartnerOrderDelete;
		return new PageReference('/apex/manageOrder').setRedirect(True);
	}
	public PageReference Redirect() {

		if (UserInfo.getUserType() == 'Guest')
			return Network.communitiesLanding();
		else return null;
	}
////////////

	public List<SelectOption> getItems() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('100', 'View 100'));
		options.add(new SelectOption('50', 'View 50'));
		options.add(new SelectOption('25', 'View 25'));
		return options;
	}




	public void ItemsPerPage() {
		if (NumOfItem != null)
			iNumOfItem = Integer.valueOf(NumOfItem);
		getRecords();
	}

/////////////
	global class PartnerOrderInnerClass implements Comparable {
		public Partner_Order__c PartnerOrder {get; set;}
		public string VisibilityEdit {get; set;}
		public string VisibilityClone {get; set;}
		public String VisibilityBulkClone {get; set;}
		public String  VisibilityDelete {get; set;}
		public	PartnerOrderInnerClass(Partner_Order__c PartnerOrder, string VisibilityEdit, string VisibilityClone, string VisibilityBulkClone, string VisibilityDelete) {
			this.PartnerOrder = PartnerOrder;
			this.VisibilityEdit = VisibilityEdit;
			this.VisibilityClone = VisibilityClone;
			this.VisibilityBulkClone = VisibilityBulkClone;
			this.VisibilityDelete = VisibilityDelete;
		}
		global Integer compareTo(Object compareTo) {

			PartnerOrderInnerClass compareToporder = ( PartnerOrderInnerClass )compareTo;
			Integer returnValue = 0;
			if ( partnerOrder.Name < compareToporder.partnerOrder.Name )
				returnValue = 1;
			else if ( partnerOrder.Name > compareToporder.partnerOrder.Name )
				returnValue = -1;
			return returnValue;
		}
	}
}