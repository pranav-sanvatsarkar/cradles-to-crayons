public class PartnerOrderStep1Controller {
    public User userdetails{get;set;}
    public Partner_Order__c partnerOrder{get;set;}
    public Partner_Order_Item__c PartnerOrderItem{get;set;}
    private Partner_Order__c clonePartnerOrder;
    public String OrderLevel{get;set;}
    public String UserMessage{get;set;}
    public String EnableCustomLinks{get;set;}
    public String EnableOrder{get;set;}
    public String EnableBulkOrder{get;set;}
    public List<SelectOption>ClothingItems{get;set;}
    public List<SelectOption>footWearItems{get;set;}
    public List<SelectOption>SeasonalFootWearItems{get;set;}
    public List<SelectOption>OuterwearItems{get;set;}
    public List<SelectOption>OuterwearAccItems{get;set;}
    public List<SelectOption>BooksItems{get;set;}
    public List<SelectOption>ArtsCraftsItems{get;set;}
    public List<SelectOption>ToysItems{get;set;}
    public List<SelectOption>NurseryItems{get;set;}
    public List<SelectOption>BedItems{get;set;}
    public List<SelectOption>CarSearItems{get;set;}
    public List<SelectOption>StrollerItems{get;set;}
    public List<SelectOption>TempItems{get;set;}
    public List<SelectOption>SeatsSwingsItems{get;set;}
    public List<SelectOption>LargeToysItems{get;set;}
    public List<Partner_Order_Item__c>PartnerOrderItems{get;set;}
    private List < Partner_Order_Item__c > lstOldPartnerOrderItem;
    private List < Partner_Order_Item__c > lstFinalStandardPartnerItem;
    private List < Partner_Order_Item__c > lstFinalbabyGearPartnerItem;
    public List < Item__c > lstItems;
    private List < PartnerOrderItemWrapperClass > lstwrPartnerOrderStandardItem;
    private List < PartnerOrderItemWrapperClass > lstwrPartnerOrderBabyGearItem;
    public String ClothingItemId{get;set;}
    public String FootWearItemId{get;set;}
    public String SeasonalFootWearItemId{get;set;}
    public String OuterWearItemId{get;set;}
    public String OuterWearAccItemId{get;set;}
    public String BooksItemId{get;set;}
    public String ArtsCraftsItemId{get;set;}
    public String ToysItemId{get;set;}
    public String NurseryItemId{get;set;}
    public String BedItemId{get;set;}
    public String CarSearItemId{get;set;}
    public String StrollerItemId{get;set;}
    public String BoosterSeatItemId{get;set;}
    public String PacknPlayItemId{get;set;}
    public String BouncyItemId{get;set;}
    public String HighChairItemId{get;set;}
    public String BassiNetItemId{get;set;}
    public String IndoorSwingItemId{get;set;}
    public String SafteyGateItemId{get;set;}
    public String BedRailsItemId{get;set;}
    public String TempItemId{get;set;}
    public String seatsSwingsItemId{get;set;}
    public String BirthdayGiftItemId{get;set;}
    public String LargeToysItemId{get;set;}
    public String BirthdayItemId{get;set;}
    public String ClothingItemComment{get;set;}
    public String FootWearItemComment{get;set;}
    public String SeasonalFootWearItemComment{get;set;}
    public String OuterWearItemComment{get;set;}
    public String OuterWearAccItemComment{get;set;}
    public String BooksItemComment{get;set;}
    public String ArtsCraftsItemComment{get;set;}
    public String ToysItemComment{get;set;}
    public String NurseryItemComment{get;set;}
    public String BedItemComment{get;set;}
    public String CarSearItemComment{get;set;}
    public String StrollerItemComment{get;set;}
    public String TempItemComment{get;set;}
    public String SeatsSwingsItemComment{get;set;}
    public String birthdayGiftItemComment{get;set;}
    public String LargeToysItemComment{get;set;}
    public String BirthdayItemComment{get;set;}
    public Boolean[]IsAddItem{get;set;}
    private string strEditPartnerOrderId;
    private string strClonePartnerOrderId;
    private Boolean isCheckInsertPartnerOrder;
    private set < id > setStandardItemId;
    private set < id > setBabyGearItemId;
    private Boolean isCheckUserStep2Back;
    private Boolean isCheckUserStep3Back;
    private String strChildAge;
    private String strChildGender;
    private Boolean isBabyGearItemDelete = True;
    private Boolean isStandardItemDelete = True;
    public Item__c birthdayItem;
    private final static String strStyleInline = 'inline';
    private final static String strStyleNone = 'none';
    private Map < id, Item__c > MapItems;
    public Portal_Configuration__c portalConfiguration{get;set;}
    public List<PartnerOrderNurseryWrapperClass>WrapperNurseryItems{get;set;}
    public boolean IsAddItem8Visible{get;set;}
    public PartnerOrderNurseryWrapperClass objSupersoucer{get;set;}
    public PartnerOrderNurseryWrapperClass objBoosterSeat{get;set;}
    public PartnerOrderNurseryWrapperClass objPacknPlay{get;set;}
    public PartnerOrderNurseryWrapperClass objBouncy{get;set;}
    public PartnerOrderNurseryWrapperClass objHighChair{get;set;}
    public PartnerOrderNurseryWrapperClass objBassinet{get;set;}
    public PartnerOrderNurseryWrapperClass objIndoorSwing{get;set;}
    public PartnerOrderNurseryWrapperClass objSafteyGate{get;set;}
    public PartnerOrderNurseryWrapperClass objBedRails{get;set;}
    private Boolean IsFirstComplete{get;set;}
    private Boolean IsBackUser{get;set;}
    // code added for Order Summary page
    public class reviewOrderItems {
        public string itemName {get; set;}
        public string orderStatus {get; set;}
        public Decimal orderQty {get; set;}
        public Decimal orderfullfill {get; set;}
        public string Comment {get; set;}
    }
    public List<reviewOrderItems> reviewItems {get; set;}
    public List<Item__c> ItemList {get; set;}
    public static List<Partner_Order_Item__c> PartnerOrderItemList {get; set;}
    public List<Partner_Order_Item__c> PartnerOrderItemList2 {get; set;}
    public Integer OrderCount {get; set;}
    public List<reviewOrderItems> rOrderItem {get; set;}
    public Id POrderId {get; set;}
    public Boolean isBulkOrder {get; set;}  // this will be used to identify an order whether is Bulk(Speciality) or KidPack
    public String PartnerOrderStatus {get; set;}
    public PartnerOrderStep1Controller() {
        IsFirstComplete = false;
        IsBackUser = false;
        objSupersoucer = new PartnerOrderNurseryWrapperClass();
        objBoosterSeat = new PartnerOrderNurseryWrapperClass();
        objPacknPlay = new PartnerOrderNurseryWrapperClass();
        objBouncy = new PartnerOrderNurseryWrapperClass();
        objHighChair = new PartnerOrderNurseryWrapperClass();
        objBassinet = new PartnerOrderNurseryWrapperClass();
        objIndoorSwing = new PartnerOrderNurseryWrapperClass();
        objSafteyGate = new PartnerOrderNurseryWrapperClass();
        objBedRails = new PartnerOrderNurseryWrapperClass();
        MapItems = new Map < id, Item__c > ();
        WrapperNurseryItems = new List < PartnerOrderNurseryWrapperClass > ();
        WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
        WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
        WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
        strChildAge = null;
        strChildGender = null;
        setStandardItemId = new Set < id > ();
        setBabyGearItemId = new Set < id > ();
        isCheckUserStep3Back = False;
        isCheckUserStep2Back = False;
        isCheckInsertPartnerOrder = False;
        strEditPartnerOrderId = null;
        strClonePartnerOrderId = null;
        IsAddItem = new Boolean[] {
            False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False
        };
        strEditPartnerOrderId = System.currentPagereference().getParameters().get('EditId');
        strClonePartnerOrderId = System.currentPagereference().getParameters().get('cloneId');
        PartnerOrderItem = new Partner_Order_Item__c();
        //////test Begin/////
        Id POId ;
        integer i = 0;
        list<Partner_Order__c> isBulPartnerOrder;
        if (strEditPartnerOrderId != null || strClonePartnerOrderId!= null) {
            POId = Id.valueOf(strEditPartnerOrderId == null ? strClonePartnerOrderId : strEditPartnerOrderId);
            PartnerOrderItemList2 = [SELECT Id, Item__c, comment__c, Partner_Order_Status__c, Qty_Fulfilled__c, Qty_Ordered__c, Partner_Order__c from Partner_Order_Item__c WHERE Partner_Order__c = : POId];
            OrderCount = PartnerOrderItemList2.size();
            isBulPartnerOrder = [SELECT IsBulkOrder__c FROM Partner_Order__c WHERE Id = : POId limit 1];
            isBulkOrder = Boolean.valueOf(isBulPartnerOrder[0].IsBulkOrder__c);
            for (Partner_Order_Item__c PartnerItem : PartnerOrderItemList2) {
                system.Debug('PartnerItem  :: ' + PartnerItem.Item__c + ' Counter ::: ' + i++);
                PartnerOrderStatus = PartnerItem.Partner_Order_Status__c;
            }
        }
 
        //////test End/////
        InitalizeLists();
        if (strEditPartnerOrderId != null) {
            try {
                partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c, Contact__c, Emergency_Order__c, Emergency_Other__c, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c, Picked_Up_Date__c, Who_will_pick_up_phone__c, Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c, Who_will_pick_up__c, Partner_Email__c, Location__c, Site__c
                FROM Partner_Order__c WHERE id = : strEditPartnerOrderId LIMIT 1];
                strChildAge = partnerOrder.Child_Age__c;
                strChildGender = partnerOrder.Child_Gender__c;
                lstOldPartnerOrderItem = [SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c
                FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
            } catch (Exception EditPartnerOrderException) {
                System.debug('PartnerOrderController :: Contructor :: EditPartnerOrder ::Exception ::' + EditPartnerOrderException);
            }
        } else if (strClonePartnerOrderId != null) {
            try {
                clonePartnerOrder = new Partner_Order__c();//Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c,Emergency_Order__c,Site__c, Emergency_Other__c,Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c,, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c,
                partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Contact__c,  Picked_Up_Date__c, Who_will_pick_up_phone__c,  Who_will_pick_up__c, Partner_Email__c, Location__c
                FROM Partner_Order__c WHERE id = : strClonePartnerOrderId LIMIT 1];
                lstOldPartnerOrderItem = new List<Partner_Order_Item__c>(); //[SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
            } catch (Exception ClonePartnerOrderException) {
                System.debug('PartnerOrderController :: Contructor :: ClonePartnerOrder ::Exception ::' + ClonePartnerOrderException);
            }
        } else if (partnerOrder == null) partnerOrder = new Partner_Order__c();

        try {
            userdetails = [SELECT ID, name, Phone, Site__c, ContactId, username, Contact.AccountId, Contact.Account.Order_Level__c, Contact.Phone, Contact.EnableBulkOrder__c, Contact.Email
            FROM USER WHERE username = : UserInfo.getUserName() LIMIT 1];
            portalConfiguration = [SELECT Location__c, Message__c, EnableBulkOrder__c, EnableOrder__c FROM Portal_Configuration__c WHERE Location__c = : userdetails.Site__c LIMIT 1];
        } catch (Exception UserDetailsException) {
            System.debug('PartnerOrderController :: Contructor :: UserDetails ::Exception ::' + UserDetailsException);
        }
        if (userdetails != null) OrderLevel = String.valueOf(userDetails.Contact.Account.Order_Level__c);
        setPartnerMessages();
        partnerOrder.Contact__c = userdetails.ContactId;
        partnerOrder.Who_will_pick_up_phone__c = userdetails.Contact.Phone;
        partnerOrder.Who_will_pick_up__c = userdetails.name;
        partnerOrder.Partner_Email__c = userdetails.Contact.Email;
        //
        partnerOrder.Site__c = userdetails.Site__c;
    }
    public void setPartnerMessages() {
        if (portalConfiguration != null) {
            if (portalConfiguration.Message__c != null) UserMessage = portalConfiguration.Message__c;
            else UserMessage = '';
            if (portalConfiguration.EnableOrder__c == True) EnableOrder = strStyleInline;
            else EnableOrder = strStyleNone;
            if (portalConfiguration.EnableBulkOrder__c == True && userdetails.Contact.EnableBulkOrder__c == True) EnableBulkOrder = strStyleInline;
            else EnableBulkOrder = strStyleNone;
            if (portalConfiguration.EnableOrder__c == False && portalConfiguration.EnableBulkOrder__c == False && userdetails.Contact.EnableBulkOrder__c == False) EnableCustomLinks = strStyleNone;
            else EnableCustomLinks = strStyleInline;
        }
    }

    List < SelectOption > footWearItemsMatchingAgeGender = new List < SelectOption > ();
    List < SelectOption > seasonalItemsMatchingAgeGender = new List < SelectOption > ();

    public void getItems() {

        InitalizeLists();
        try {
            lstItems = new List < Item__c > ([SELECT Id, Name, Ages__c, Category__c, Container_Type__c, Gender__c, Season__c, Shopping_Location__c, Size__c, SKU__c, Type_Sub_Category__c, BabyGearType__c, Site__c, Available_As_Kid_Pack_Item__c, Available_As_Bulk_Item__c
            FROM Item__c WHERE Site__c = : userdetails.Site__c ORDER BY Size_Reporting_Order__c LIMIT 10000]);
        } catch (Exception ItemsException) {
            System.debug('PartnerOrderController :: GetItems :: Exception ::' + ItemsException);
        }

        if (lstItems.size() > 0) for (Item__c item: lstItems) {

            if (!MapItems.containsKey(item.Id)) MapItems.put(item.Id, item);

            if (item.Available_As_Kid_Pack_Item__c == 'Active' && item.Available_As_Bulk_Item__c == null) {
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Super Saucer') {
                    System.debug('Edit and Clone:: Super Saucer::' + objSupersoucer);
                    objSupersoucer.SelectedItemId = item.Id;
                    //objSupersoucer.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Booster Seat - Table (6-12 mos.)') {
                    objBoosterSeat.SelectedItemId = item.Id;
                    //objBoosterSeat.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Pack n Play (portable)') {
                    objPacknPlay.SelectedItemId = item.Id;
                    //objPacknPlay.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bouncy Seat (Infant)') {
                    objBouncy.SelectedItemId = item.Id;
                    //objBouncy.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'High Chair (6 mos. - 2yrs)') {
                    objHighChair.SelectedItemId = item.Id;
                    //objHighChair.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bassinet (Infant)') {
                    objBassinet.SelectedItemId = item.Id;
                    //objBassinet.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Indoor Swing') {
                    objIndoorSwing.SelectedItemId = item.Id;
                    //objIndoorSwing.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Safety Gate') {
                    objSafteyGate.SelectedItemId = item.Id;
                    //objSafteyGate.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bed Rails') {
                    objBedRails.SelectedItemId = item.Id;
                    //objBedRails.IsselectedItem = false;
                }

                if (item.Category__c == 'Clothing' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ClothingItems.add(new SelectOption(item.Id, item.Name));

                if (item.Category__c == 'Everyday Footwear') {
                    if ((item.Ages__c != null && item.Gender__c != null)) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if (setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c.contains(partnerOrder.Child_Gender__c)) {
                            footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                        }

                    }
                    if (item.Ages__c != null && item.Gender__c == null) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if (setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == null) {
                            footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                        }

                    }
                    if (item.Ages__c == null && item.Gender__c != null && partnerOrder.Child_Gender__c != null) {
                        if (item.Gender__c.contains(partnerOrder.Child_Gender__c) && item.Ages__c == null) footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if (item.Ages__c == null && item.Gender__c == null) {
                        footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }

                }

                if (item.Category__c == 'Seasonal Footwear') {
                    if ((item.Ages__c != null && item.Gender__c != null)) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if ((setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == partnerOrder.Child_Gender__c)) {
                            seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                        }

                    }
                    if (item.Ages__c != null && item.Gender__c == null) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if (setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == null) seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if ((item.Ages__c == null && item.Gender__c != null && partnerOrder.Child_Gender__c != null)) {
                        if (item.Gender__c.contains(partnerOrder.Child_Gender__c) && item.Ages__c == null) seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if (item.Ages__c == null && item.Gender__c == null) {
                        seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                }

                if (item.Category__c == 'Outerwear' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) OuterwearItems.add(new SelectOption(item.Id, item.Name));

                if (item.Category__c == 'Outerwear Accessories' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) OuterwearAccItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Books') BooksItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Arts & Crafts' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ArtsCraftsItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Toys' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ToysItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Nursery') NurseryItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bed') BedItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Car Seat') CarSearItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Stroller') StrollerItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Temporary Available Items') TempItems.add(new SelectOption(item.Id, item.Name));
            } //end of if
            else if (item.Available_As_Kid_Pack_Item__c == 'Active' && item.Available_As_Bulk_Item__c == 'Active') {
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Super Saucer') {
                    objSupersoucer.SelectedItemId = item.Id;
                    //objSupersoucer.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Booster Seat - Table (6-12 mos.)') {
                    objBoosterSeat.SelectedItemId = item.Id;
                    //objBoosterSeat.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Pack n Play (portable)') {
                    objPacknPlay.SelectedItemId = item.Id;
                    //objPacknPlay.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bouncy Seat (Infant)') {
                    objBouncy.SelectedItemId = item.Id;
                    //objBouncy.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'High Chair (6 mos. - 2yrs)') {
                    objHighChair.SelectedItemId = item.Id;
                    //objHighChair.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bassinet (Infant)') {
                    objBassinet.SelectedItemId = item.Id;
                    //objBassinet.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Indoor Swing') {
                    objIndoorSwing.SelectedItemId = item.Id;
                    //objIndoorSwing.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Safety Gate') {
                    objSafteyGate.SelectedItemId = item.Id;
                    //objSafteyGate.IsselectedItem = false;
                }

                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bed Rails') {
                    objBedRails.SelectedItemId = item.Id;
                    //objBedRails.IsselectedItem = false;
                }

                if (item.Category__c == 'Clothing' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ClothingItems.add(new SelectOption(item.Id, item.Name));

                if (item.Category__c == 'Everyday Footwear') {
                    if ((item.Ages__c != null && item.Gender__c != null)) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if ((setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == partnerOrder.Child_Gender__c)) {
                            footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                        }

                    }
                    if (item.Ages__c != null && item.Gender__c == null) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if (setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == null) {
                            footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                        }
                    }
                    if (item.Ages__c == null && item.Gender__c != null) {
                        if (item.Gender__c.equals(partnerOrder.Child_Gender__c) && item.Ages__c == null) footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if (item.Ages__c == null && item.Gender__c == null) {
                        footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }

                }

                if (item.Category__c == 'Seasonal Footwear') {
                    if ((item.Ages__c != null && item.Gender__c != null)) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if ((setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == partnerOrder.Child_Gender__c)) seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));

                    }
                    if (item.Ages__c != null && item.Gender__c == null) {
                        Set < String > setAges = new Set < String > ();
                        setAges.addAll(item.Ages__c.split(';'));
                        if (setAges.contains(partnerOrder.Child_Age__c) && item.Gender__c == null) seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if (item.Ages__c == null && item.Gender__c != null) {
                        if (item.Gender__c.equals(partnerOrder.Child_Gender__c) && item.Ages__c == null) seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                    if (item.Ages__c == null && item.Gender__c == null) {
                        seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                    }
                }

                if (item.Category__c == 'Outerwear' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) OuterwearItems.add(new SelectOption(item.Id, item.Name));

                if (item.Category__c == 'Outerwear Accessories' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) OuterwearAccItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Books') BooksItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Arts & Crafts' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ArtsCraftsItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Toys' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) ToysItems.add(new SelectOption(item.Id, item.Name));
                //// 
                if (item.Category__c == 'Nursery') NurseryItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Bed') BedItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Car Seat') CarSearItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Stroller') StrollerItems.add(new SelectOption(item.Id, item.Name));
                if (item.Category__c == 'Baby Gear' && item.BabyGearType__c == 'Temporary Available Items') TempItems.add(new SelectOption(item.Id, item.Name));
            } //end of else if

        } //end for loop

        if (footWearItemsMatchingAgeGender.size() > 0) {
            footWearItems.addAll(footWearItemsMatchingAgeGender);
            footWearItemsMatchingAgeGender.clear();

        }

        if (seasonalItemsMatchingAgeGender.size() > 0) {
            SeasonalFootWearItems.addAll(seasonalItemsMatchingAgeGender);
            seasonalItemsMatchingAgeGender.clear();

        }
        try {
            birthdayItem = [SELECT Id, Name, Category__c, Container_Type__c, Site__c
            FROM Item__c WHERE Category__c = : 'Birthday Gift'
            AND Available_As_Kid_Pack_Item__c = : 'Active'
            AND Available_As_Bulk_Item__c = : null AND Site__c = : userdetails.Site__c AND Ages__c = : null AND Container_Type__c = : null AND Gender__c = : null AND Season__c = : null AND Shopping_Location__c = : null AND Size__c = : null AND SKU__c = : null AND Type_Sub_Category__c = : null AND BabyGearType__c = : null LIMIT 1];

        } catch (Exception BirthdayItemException) {
            System.debug('PartnerOrderController :: GetItems :: BirthdayItemException :: Exception ::' + BirthdayItemException);
        }
        if (strEditPartnerOrderId != null || strClonePartnerOrderId != null) {


            if (lstOldPartnerOrderItem.size() > 0) {
                WrapperNurseryItems = new List < PartnerOrderNurseryWrapperClass > ();

                for (Partner_Order_Item__c PartnerItem: lstOldPartnerOrderItem) {
                    if (PartnerItem != null) {
                        Item__c selectedItem;
                        Id stritemid = PartnerItem.Item__c;
                        try {
                            selectedItem = MapItems.get(PartnerItem.Item__c);
                        } catch (Exception selectedItemException) {
                            System.debug('PartnerOrderController :: GetItems :: Edit or clone partnerOrder :: Exception ::' + selectedItemException);
                        }

                        if (selectedItem != null) {
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Super Saucer') {
                                objSupersoucer.SelectedItemId = selectedItem.Id;
                                objSupersoucer.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Booster Seat - Table (6-12 mos.)') {
                                objBoosterSeat.SelectedItemId = selectedItem.Id;
                                objBoosterSeat.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Pack n Play (portable)') {
                                objPacknPlay.SelectedItemId = selectedItem.Id;
                                objPacknPlay.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Bouncy Seat (Infant)') {
                                objBouncy.SelectedItemId = selectedItem.Id;
                                objBouncy.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'High Chair (6 mos. - 2yrs)') {
                                objHighChair.SelectedItemId = selectedItem.Id;
                                objHighChair.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Bassinet (Infant)') {
                                objBassinet.SelectedItemId = selectedItem.Id;
                                objBassinet.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Indoor Swing') {
                                objIndoorSwing.SelectedItemId = selectedItem.Id;
                                objIndoorSwing.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Safety Gate') {
                                objSafteyGate.SelectedItemId = selectedItem.Id;
                                objSafteyGate.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Bed Rails') {
                                objBedRails.SelectedItemId = selectedItem.Id;
                                objBedRails.IsSelectedItem = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Clothing' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                ClothingItemId = selectedItem.id;
                                IsAddItem[0] = True;
                                ClothingItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Ages__c != null) { ////
                                if (selectedItem.Category__c == 'Everyday Footwear' && selectedItem.Ages__c.contains(partnerOrder.Child_Age__c) && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                    FootWearItemId = selectedItem.id;
                                    IsAddItem[1] = True;
                                    FootWearItemComment = PartnerItem.Comment__c;
                                    setStandardItemId.add(PartnerItem.id);
                                } /////
                            }
                            if (selectedItem.Category__c == 'Seasonal Footwear' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {

                                SeasonalFootWearItemId = selectedItem.id;
                                IsAddItem[2] = True;
                                SeasonalFootWearItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Outerwear' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                OuterWearItemId = selectedItem.id;
                                IsAddItem[3] = True;
                                OuterWearItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Outerwear Accessories' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                OuterWearAccItemId = selectedItem.id;
                                IsAddItem[8] = True;
                                OuterWearAccItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Books') {
                                BooksItemId = selectedItem.id;
                                IsAddItem[4] = True;
                                BooksItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Arts & Crafts' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                ArtsCraftsItemId = selectedItem.id;
                                IsAddItem[5] = True;
                                ArtsCraftsItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Toys' && selectedItem.Gender__c == partnerOrder.Child_Gender__c) {
                                ToysItemId = selectedItem.id;
                                IsAddItem[6] = True;
                                ToysItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }

                            if (birthdayItem != null) if (birthdayItem.Id == selectedItem.Id) {
                                BirthdayItemId = selectedItem.id;
                                IsAddItem[7] = True;
                                BirthdayItemComment = PartnerItem.Comment__c;
                                setStandardItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Nursery') {

                                System.debug('Edit and Clone:: Nursery:: Wrapper ::' + WrapperNurseryItems);
                                PartnerOrderNurseryWrapperClass Nursery = new PartnerOrderNurseryWrapperClass();
                                Nursery.SelectedItemId = selectedItem.id;
                                Nursery.PartnerOrderItemId = PartnerItem.Id;
                                Nursery.IsSelectedItem = True;
                                Nursery.Comment = PartnerItem.Comment__c;
                                WrapperNurseryItems.add(Nursery);
                                setBabyGearItemId.add(PartnerItem.id);
                                System.debug('Edit and Clone:: Nursery:: Wrapper ::' + WrapperNurseryItems);
                            }
                            /////
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Bed') {
                                BedItemId = selectedItem.id;
                                IsAddItem[9] = True;
                                BedItemComment = PartnerItem.Comment__c;
                                setBabyGearItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Car Seat') {
                                CarSearItemId = selectedItem.id;
                                IsAddItem[10] = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Stroller') {
                                StrollerItemId = selectedItem.id;
                                IsAddItem[13] = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Temporary Available Items') {
                                TempItemId = selectedItem.id;
                                IsAddItem[14] = True;
                                setBabyGearItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Large Toys') {
                                LargeToysItemId = selectedItem.id;
                                IsAddItem[11] = True;
                                LargeToysItemComment = PartnerItem.Comment__c;
                                setBabyGearItemId.add(PartnerItem.id);
                            }
                            if (selectedItem.Category__c == 'Baby Gear' && selectedItem.BabyGearType__c == 'Seats & Swings') {
                                seatsSwingsItemId = selectedItem.id;
                                IsAddItem[12] = True;
                                SeatsSwingsItemComment = PartnerItem.Comment__c;
                                setBabyGearItemId.add(PartnerItem.id);
                            }

                            selectedItem = null;
                        }
                    }
                }
            }
            lstOldPartnerOrderItem.clear();
        }
        if ((IsBackUser == False && (strEditPartnerOrderId != null || strClonePartnerOrderId != null)) || IsBackUser != False) {
            if (WrapperNurseryItems.size() == 0) {
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
            }
            if (WrapperNurseryItems.size() == 1) {
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
            }

            if (WrapperNurseryItems.size() == 2) {
                WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
            }
        }
        if (OuterwearAccItems != null) {
            if (OuterwearAccItems.size() > 1) IsAddItem8Visible = true;
        }
    }

    public void saveNextStep1() {
        Contact contactUpdate = [SELECT id, name, FirstName, npe01__PreferredPhone__c, Phone FROM contact WHERE id = : userdetails.ContactId LIMIT 1];
        if (contactUpdate.npe01__PreferredPhone__c == null) {
            contactUpdate.Phone = partnerOrder.Who_will_pick_up_phone__c;
            System.Database.update(contactUpdate);
        } else {
            if (contactUpdate.Phone != partnerOrder.Who_will_pick_up_phone__c) {
                contactUpdate.Phone = partnerOrder.Who_will_pick_up_phone__c;
                System.Database.update(contactUpdate);
            }
        }
        if (isCheckInsertPartnerOrder == False) {
            isCheckInsertPartnerOrder = True;
            if (strClonePartnerOrderId == null && strEditPartnerOrderId == null) {
                //insert fresh porder
                partnerOrder.Status__c = 'New (not yet submitted)';
                partnerOrder.Submitted_Date__c = Datetime.now();
                partnerOrder.Partner__c = userdetails.Contact.AccountId;
                partnerOrder.Contact__c = userdetails.Contactid;
                partnerOrder.Site__c = userdetails.Site__c;
                if (!IsFirstComplete) Database.insert(partnerOrder);

            } else if (strEditPartnerOrderId != null) {
                // edit existing porder with items..
                Database.update(partnerOrder);
                if (strChildAge != partnerOrder.Child_Age__c || strChildGender != partnerOrder.Child_Gender__c) {
                    deleteStandardItems();
                }
            } else if (strClonePartnerOrderId != null) {
                // clone existing  partner child info and porder items.. 
                clonePartnerOrder.Caregiver_s_First_name__c = partnerOrder.Caregiver_s_First_name__c;
                clonePartnerOrder.Caregiver_s_Last_name__c = partnerOrder.Caregiver_s_Last_name__c;
                clonePartnerOrder.Child_s_Story__c = partnerOrder.Child_s_Story__c;
                clonePartnerOrder.Child_Age__c = partnerOrder.Child_Age__c;
                clonePartnerOrder.Child_Birthdate__c = partnerOrder.Child_Birthdate__c;
                clonePartnerOrder.Child_First_Name__c = partnerOrder.Child_First_Name__c;
                clonePartnerOrder.Child_Gender__c = partnerOrder.Child_Gender__c;
                clonePartnerOrder.Child_Home_Zip_Code__c = partnerOrder.Child_Home_Zip_Code__c;
                clonePartnerOrder.Child_Last_Name__c = partnerOrder.Child_Last_Name__c;
                clonePartnerOrder.Emergency_Order__c = partnerOrder.Emergency_Order__c;
                clonePartnerOrder.Emergency_Type__c = partnerOrder.Emergency_Type__c;
                clonePartnerOrder.Picked_Up_Date__c = partnerOrder.Picked_Up_Date__c;
                clonePartnerOrder.Who_will_pick_up_phone__c = partnerOrder.Who_will_pick_up_phone__c;
                //
                clonePartnerOrder.Location__c = partnerOrder.Location__c;
                clonePartnerOrder.Site__c = partnerOrder.Site__c;
                //
                clonePartnerOrder.Emergency_Reason__c = partnerOrder.Emergency_Reason__c;
                clonePartnerOrder.Submitted_Date__c = Datetime.now();
                clonePartnerOrder.Who_will_pick_up__c = partnerOrder.Who_will_pick_up__c;
                clonePartnerOrder.Partner_Email__c = partnerOrder.Partner_Email__c;
                clonePartnerOrder.Submitted_Date__c = Datetime.now();
                clonePartnerOrder.Partner__c = userdetails.Contact.AccountId;
                clonePartnerOrder.Contact__c = userdetails.Contactid;
                clonePartnerOrder.Status__c = 'New (not yet submitted)';

                Database.insert(clonePartnerOrder);
                try {
                    partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c, Contact__c, Emergency_Order__c, Emergency_Other__c, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c, Picked_Up_Date__c, Who_will_pick_up_phone__c, Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c, Who_will_pick_up__c, Partner_Email__c, Location__c, Site__c
                    FROM Partner_Order__c WHERE id = : clonePartnerOrder.Id LIMIT 1];

                } catch (Exception ClonePartnerOrderException) {
                    System.debug('PartnerOrderController :: saveNextStep1 :: clone partnerOrder :: Exception ::' + ClonePartnerOrderException);
                }

            }

        } else { //update Porder;
            update partnerOrder;
            if (strClonePartnerOrderId == null) if (strChildAge != partnerOrder.Child_Age__c || strChildGender != partnerOrder.Child_Gender__c) {
                deleteStandardItems();
                strChildAge = partnerOrder.Child_Age__c;
                strChildGender = partnerOrder.Child_Gender__c;
            }

        }
        getItems();
        PageReference newPageReference = Apexpages.currentPage();
        IsFirstComplete = true;

    }

    public PageReference returnNetPage() {
    	system.debug('Inside returnNetPage: '+Page.PartnerOrderStep2);
        return Page.PartnerOrderStep2;
    }


    private void deleteStandardItems() {
        List < Partner_Order_Item__c > lstItemDelete = new List < Partner_Order_Item__c > ();
        List < Partner_Order_Item__c > lstOldPartnerOrderStandardItems;
        try {
            lstOldPartnerOrderStandardItems = [SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
        } Catch(Exception deleteStandardItemException) {
            System.debug('PartnerOrderController :: deleteStandardItems :: Exception ::' + deleteStandardItemException);
        }
        if (lstOldPartnerOrderStandardItems.size() > 0) for (Partner_Order_Item__c PartnerItem: lstOldPartnerOrderStandardItems) {
            if (PartnerItem != null) {
                try {
                    Id itemId = PartnerItem.Item__c;
                    Item__c selectedItem = [SELECT Id, Name, Ages__c, Category__c, Container_Type__c, Gender__c, Season__c, Shopping_Location__c, Size__c, SKU__c, Type_Sub_Category__c, BabyGearType__c, Site__c
                    FROM Item__c WHERE id = : itemId LIMIT 1];
                    if (selectedItem != null) {

                        if (selectedItem.Category__c == 'Clothing' && selectedItem.Gender__c != partnerOrder.Child_Gender__c) lstItemDelete.add(PartnerItem);
                        if (selectedItem.Category__c == 'Everyday Footwear') lstItemDelete.add(PartnerItem);
                        if ((selectedItem.Category__c == 'Seasonal Footwear')) lstItemDelete.add(PartnerItem);
                        ///// 
                        if (selectedItem.Category__c == 'Outerwear' && selectedItem.Gender__c != partnerOrder.Child_Gender__c) lstItemDelete.add(PartnerItem);
                    }
                } catch (Exception deleteStandardSelectedItemException) {
                    System.debug('PartnerOrderController :: deleteStandardItems ::selectedItem ::Exception ::' + deleteStandardSelectedItemException);
                }
            }
        }
        Database.delete(lstItemDelete);
        FootWearItemId = SeasonalFootWearItemId = null;
    }
    public PageReference saveNextStep2() {

        if (strEditPartnerOrderId != null && isStandardItemDelete == True) {
            isStandardItemDelete = False;
            List < Partner_Order_Item__c > lstPartnerItemDelete;
            try {
                lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE id in : setStandardItemId];

            } catch (Exception deletePartnerOrderItemException) {
                System.debug('PartnerOrderController :: saveNextStep2 ::strEditPartnerOrderId ::Exception ::' + deletePartnerOrderItemException);
            }

            if (lstPartnerItemDelete != null) if (lstPartnerItemDelete.size() > 0) {
                System.Database.delete(lstPartnerItemDelete);
                setStandardItemId.clear();
            }
        }
        lstwrPartnerOrderStandardItem = new List < PartnerOrderItemWrapperClass > ();
        if (IsAddItem[0] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, ClothingItemId, ClothingItemComment, 1));
        if (IsAddItem[1] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, FootWearItemId, FootWearItemComment, 1));
        if (IsAddItem[2] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, SeasonalFootWearItemId, SeasonalFootWearItemComment, 1));
        if (IsAddItem[3] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, OuterWearItemId, OuterWearItemComment, 1));
        if (IsAddItem[4] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, BooksItemId, BooksItemComment, 1));
        if (IsAddItem[5] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, ArtsCraftsItemId, ArtsCraftsItemComment, 1));
        if (IsAddItem[6] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, ToysItemId, ToysItemComment, 1));

        if (IsAddItem[7] == True) {
            if (birthdayItem != null) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, birthdayItem.Id, BirthdayItemComment, 1));
        }
        if (IsAddItem[8] == True) lstwrPartnerOrderStandardItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, OuterWearAccItemId, OuterWearAccItemComment, 1));
        lstFinalStandardPartnerItem = new List < Partner_Order_Item__c > ();
        for (PartnerOrderItemWrapperClass PartnerOrderItemwrapper: lstwrPartnerOrderStandardItem)
        lstFinalStandardPartnerItem.add(PartnerOrderItemwrapper.ParnerOrderItem);

        Database.insert(lstFinalStandardPartnerItem);
        if (isCheckUserStep2Back == True) {
            List < Partner_Order_Item__c > lstPartnerItemDelete;
            try {
                lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE id in : setStandardItemId];
            } catch (Exception deletePartnerOrderStadardItemException) {
                System.debug('PartnerOrderController :: saveNextStep2 ::deletePartnerOrderStadardItem ::Exception ::' + deletePartnerOrderStadardItemException);
            }
            Database.delete(lstPartnerItemDelete);
            setStandardItemId.clear();
        }
        isCheckUserStep2Back = false;
        return new PageReference('/apex/PartnerOrderStep3').setRedirect(false);
    }

    public PageReference saveNextStep3() {
        if (strEditPartnerOrderId != null && isBabyGearItemDelete == True) {
            isBabyGearItemDelete = False;
            List < Partner_Order_Item__c > lstPartnerItemDelete;
            try {
                lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE Id in : setBabyGearItemId];
                system.debug('***Babygear Item' + lstPartnerItemDelete);
            } Catch(Exception deletePartnerOrderBabyGrearItemException) {
                System.debug('PartnerOrderController :: saveNextStep3 ::Editpartnerorder :: deletePartnerOrderBabyGrearItem ::Exception ::' + deletePartnerOrderBabyGrearItemException);
            }
            if (lstPartnerItemDelete != null) if (lstPartnerItemDelete.size() > 0) {
                system.Database.delete(lstPartnerItemDelete);
                setBabyGearItemId.clear();
            }
        }
        lstwrPartnerOrderBabyGearItem = new List < PartnerOrderItemWrapperClass > ();
        //code for Nursery
        set < Id > SetNurseryItemDelete = new set < Id > ();
        for (PartnerOrderNurseryWrapperClass objNursery: WrapperNurseryItems) {
            if (objNursery.IsSelectedItem == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objNursery.SelectedItemId, objNursery.Comment, null));

        }
        if (objSupersoucer.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objSupersoucer.SelectedItemId, '', null));
        if (objBoosterSeat.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objBoosterSeat.SelectedItemId, '', null));
        if (objPacknPlay.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objPacknPlay.SelectedItemId, '', null));
        if (objBouncy.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objBouncy.SelectedItemId, '', null));
        if (objHighChair.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objHighChair.SelectedItemId, '', null));
        if (objBassinet.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objBassinet.SelectedItemId, '', null));
        if (objIndoorSwing.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objIndoorSwing.SelectedItemId, '', null));
        if (objSafteyGate.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objSafteyGate.SelectedItemId, '', null));
        if (objBedRails.IsSelectedItem) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, objBedRails.SelectedItemId, '', null));

        if (IsAddItem[9] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, BedItemId, BedItemComment, null));
        if (IsAddItem[10] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, CarSearItemId, CarSearItemComment, null));
        if (IsAddItem[13] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, StrollerItemId, StrollerItemComment, null));
        if (IsAddItem[11] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, LargeToysItemId, LargeToysItemComment, null));
        if (IsAddItem[12] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, seatsSwingsItemId, SeatsSwingsItemComment, null));
        if (IsAddItem[14] == True) lstwrPartnerOrderBabyGearItem.add(new PartnerOrderItemWrapperClass(partnerOrder.Id, TempItemId, TempItemComment, null));
        lstFinalbabyGearPartnerItem = new List < Partner_Order_Item__c > ();
        for (PartnerOrderItemWrapperClass PartnerOrderItemwrapper: lstwrPartnerOrderBabyGearItem)
        lstFinalbabyGearPartnerItem.add(PartnerOrderItemwrapper.ParnerOrderItem);
        Database.insert(lstFinalbabyGearPartnerItem);


        if (isCheckUserStep3Back == True) {
            List < Partner_Order_Item__c > lstPartnerItemDelete;
            try {
                lstPartnerItemDelete = [SELECT Id, name FROM Partner_Order_Item__c WHERE id in : setBabyGearItemId];
            } catch (Exception deletePartnerOrderBabyGrearItemsException) {
                System.debug('PartnerOrderController :: saveNextStep3 ::deletePartnerOrderBabyGrear ::Exception ::' + deletePartnerOrderBabyGrearItemsException);
            }
            Database.delete(lstPartnerItemDelete);
        }
        isCheckUserStep3Back = false;
        PartnerOrderItems = new List < Partner_Order_Item__c > ();
        if (lstFinalStandardPartnerItem != null) PartnerOrderItems.addAll(lstFinalStandardPartnerItem);
        if (lstFinalbabyGearPartnerItem != null) PartnerOrderItems.addAll(lstFinalbabyGearPartnerItem);
        return new PageReference('/apex/PartnerOrderReviewStep').setRedirect(False);
    }
    public PageReference cancel() {

        return new PageReference('/apex/ManageOrder').setRedirect(True);
    }
    public PageReference Back() {
        IsBackUser = True;
        return new PageReference('/apex/PartnerOrderStep1').setRedirect(False);
    }
    public PageReference Step2Back() {

        strChildAge = partnerOrder.Child_Age__c;
        strChildGender = partnerOrder.Child_Gender__c;
        return new PageReference('/apex/PartnerOrderStep1').setRedirect(False);
    }
    public PageReference Step3Back() {

        isCheckUserStep2Back = true;
        setStandardItemId = new Set < id > ();
        for (Partner_Order_Item__c PartnerItemUnCheckd: lstFinalStandardPartnerItem)
        setStandardItemId.add(PartnerItemUnCheckd.id);
        return new PageReference('/apex/PartnerOrderStep2').setRedirect(False);
    }

    public PageReference reviewStepBack() {

        setBabyGearItemId = new Set < Id > ();
        isCheckUserStep3Back = true;
        for (Partner_Order_Item__c PartnerItemUnCheckd: lstFinalbabyGearPartnerItem)
        setBabyGearItemId.add(PartnerItemUnCheckd.id);
        for (PartnerOrderNurseryWrapperClass objNursery: WrapperNurseryItems)
        if (objNursery.IsSelectedItem == False) setBabyGearItemId.add(objNursery.PartnerOrderItemId);
        return new PageReference('/apex/PartnerOrderStep3').setRedirect(False);
    }
    public PageReference submit() {
        if (portalConfiguration.EnableOrder__c) {
            partnerOrder.Status__c = 'Submitted (order placed)';
            partnerOrder.Submitted_Date__c = Datetime.now();
            System.Database.update(partnerOrder);

        }
        return new PageReference('/apex/ManageOrder').setRedirect(True);


    }
    public PageReference submitNew() {
        if (portalConfiguration.EnableOrder__c) {
            partnerOrder.Status__c = 'Submitted (order placed)';
            partnerOrder.Submitted_Date__c = Datetime.now();
            System.Database.update(partnerOrder);
        }
        PageReference pageRef = new PageReference('/apex/PartnerOrderStep1').setRedirect(True);
        pageRef.getParameters().put('newOrder', partnerOrder.id);
        return pageRef;

    }
    private void InitalizeLists() {

        ClothingItems = new List < SelectOption > ();
        ClothingItems.add(new SelectOption('--None--', '--None--'));
        footWearItems = new List < SelectOption > ();
        footWearItems.add(new SelectOption('--None--', '--None--'));
        SeasonalFootWearItems = new List < SelectOption > ();
        SeasonalFootWearItems.add(new SelectOption('--None--', '--None--'));
        OuterwearItems = new List < SelectOption > ();
        OuterwearItems.add(new SelectOption('--None--', '--None--'));
        OuterwearAccItems = new List < SelectOption > ();
        OuterwearAccItems.add(new SelectOption('--None--', '--None--'));
        BooksItems = new List < SelectOption > ();
        BooksItems.add(new SelectOption('--None--', '--None--'));
        ArtsCraftsItems = new List < SelectOption > ();
        ArtsCraftsItems.add(new SelectOption('--None--', '--None--'));
        ToysItems = new List < SelectOption > ();
        ToysItems.add(new SelectOption('--None--', '--None--'));
        NurseryItems = new List < SelectOption > ();
        NurseryItems.add(new SelectOption('--None--', '--None--'));
        BedItems = new List < SelectOption > ();
        BedItems.add(new SelectOption('--None--', '--None--'));
        CarSearItems = new List < SelectOption > ();
        CarSearItems.add(new SelectOption('--None--', '--None--'));
        StrollerItems = new List < SelectOption > ();
        StrollerItems.add(new SelectOption('--None--', '--None--'));
        TempItems = new List < SelectOption > ();
        TempItems.add(new SelectOption('--None--', '--None--'));
        SeatsSwingsItems = new List < SelectOption > ();
        SeatsSwingsItems.add(new SelectOption('--None--', '--None--'));
        LargeToysItems = new List < SelectOption > ();
        LargeToysItems.add(new SelectOption('--None--', '--None--'));
        IsAddItem8Visible = false;
        footWearItemsMatchingAgeGender.clear();
        seasonalItemsMatchingAgeGender.clear();
    }
    public PageReference Redirect() {

        if (UserInfo.getUserType() == 'Guest') return Network.communitiesLanding();
        else return null;
    }
    class PartnerOrderItemWrapperClass {
        public Partner_Order_Item__c ParnerOrderItem {
            get;
            set;
        }
        public PartnerOrderItemWrapperClass(string strPartnerOrderID, String strItemID, String strItemComment, INTEGER strItemQtyFullFilled) {

            this.ParnerOrderItem = New Partner_Order_Item__c();
            this.ParnerOrderItem.Partner_Order__c = strPartnerOrderID;
            this.ParnerOrderItem.Item__c = strItemID;
            this.ParnerOrderItem.Comment__c = strItemComment;
            this.ParnerOrderItem.Qty_Ordered__c = 1;
            this.ParnerOrderItem.Qty_Fulfilled__c = strItemQtyFullFilled;

        }
    }

    public void AddNurseryRow() {
        WrapperNurseryItems.add(new PartnerOrderNurseryWrapperClass());
    }

    public class PartnerOrderNurseryWrapperClass {
        public String Comment{get;set;}
        public Boolean IsSelectedItem{get;set;}
        public String SelectedItemId{get;set;}
        public string PartnerOrderItemId{get;set;}
        public PartnerOrderNurseryWrapperClass(){this.IsSelectedItem=False;}
    }
}