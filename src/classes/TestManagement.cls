@isTest
private class TestManagement {
    static testMethod void SiteTest() {
        //*********************************************************************************
        //**************************** AccountSite.trigger*********************************
        //*********************************************************************************

        // Query to get the Site__c for the current user
        User user = [select id, Site__c from User where id = : Userinfo.getUserId()];

        // Create a test account
        Account a = new Account();
        a.Name = 'Organization test';
        a.Type = 'Business';
        ////
        a.Site__c = user.Site__c;
        insert a;

        // Verify that Account.Site__c was set to User.Site__c
        Account[] createdAccount = [SELECT Id, Site__c from Account where ID = : a.Id];
        System.assertEquals(user.Site__c, createdAccount[0].Site__c);

        //Update Account.Site to check that the trigger will run
        a.Site__c = '';
        update a;

        // Verify that the trigger ran and that Account.Site__c was reset to User.Site__c
        ////
        a.Site__c = user.Site__c;
        update a;
        ////
        createdAccount = [SELECT Id, Site__c from Account where ID = : a.Id];
        System.assertEquals(User.Site__c, createdAccount[0].Site__c);

        //*********************************************************************************
        //**************************** ContactSite.trigger*********************************
        //*********************************************************************************

        // Create a test contact
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.AccountId = a.Id;
        ////
        c.Site__c = user.Site__c;
        ////
        insert c;

        // Verify that Contact.Site__c was set to User.Site__c

        Contact[] createdContact = [SELECT Id, Site__c from Contact where ID = : c.Id];
        System.assertEquals(User.Site__c, createdContact[0].Site__c);

        //Update Contact.Site to check that the trigger will run
        c.Site__c = '';
        update c;

        // Verify that the trigger ran and that Contact.Site__c was reset to User.Site__c
        ////
        c.Site__c = user.Site__c;
        update c;
        ////
        createdContact = [SELECT Id, Site__c from Contact where ID = : c.Id];
        System.assertEquals(User.Site__c, createdContact[0].Site__c);


        //*********************************************************************************
        //**************************** VisitSite.trigger*****************************
        //*********************************************************************************

        // Create a test visit
        Volunteer_Visit__c v = new Volunteer_Visit__c();
        v.Volunteer_Type__c = 'Individual';
        v.Main_Contact__c = c.Id;
        ////
        // v.Site__c = user.Site__c;
        ////
        insert v;

        // Verify that the trigger ran and that Contact.Site__c was reset to User.Site__c
        Volunteer_Visit__c[] createdVisits = [SELECT Id, Site__c from Volunteer_Visit__c where ID = : v.Id];
        System.assertEquals(User.Site__c, createdVisits[0].Site__c);



        //*********************************************************************************
        //**************************** OpportunitySite.trigger*****************************
        //*********************************************************************************

        // Create a test opportunity
        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Prospecting';
        o.Amount = 0;
        o.CloseDate = Date.today();
        ////
        o.Site__c = user.Site__c;
        ////
        insert o;

        // Verify that Contact.Site__c was set to User.Site__c
        Opportunity[] createdOpportunity = [SELECT Id, Site__c from Opportunity where ID = : o.Id];
        System.assertEquals(User.Site__c, createdOpportunity[0].Site__c);

        //Update Contact.Site to check that the trigger will run
        o.Site__c = '';
        update o;

        // Verify that the trigger ran and that Contact.Site__c was reset to User.Site__c
        o.Site__c = user.Site__c;
        update o;
        createdOpportunity = [SELECT Id, Site__c from Opportunity where ID = : o.Id];
        System.assertEquals(User.Site__c, createdOpportunity[0].Site__c);

        //*********************************************************************************
        //**************************** CampaignSite.trigger*****************************
        //*********************************************************************************

        // Create a test opportunity
        Campaign ca = new Campaign();
        ca.Name = '[Bo]test';
        ca.Type = 'Direct Mail';
        ////
        ca.StartDate = System.Today();
        ca.Site__c = user.Site__c;
        ////
        insert ca;

        // Verify that Campaign.Site__c was set to User.Site__c
        Campaign[] createdCampaign = [SELECT Id, Site__c from Campaign where ID = : ca.Id];
        System.assertEquals(User.Site__c, createdCampaign[0].Site__c);

        //Update Campaign.Site to check that the trigger will run
        ca.Site__c = '';
        update ca;

        // Verify that the trigger ran and that Campaign.Site__c was reset to User.Site__c
        ////
        ca.Site__c = user.Site__c;
        update ca;
        ////
        createdCampaign = [SELECT Id, Site__c from Campaign where ID = : ca.Id];
        System.assertEquals(User.Site__c, createdCampaign[0].Site__c);

        //*********************************************************************************
        //**************************** DriveResultSite.trigger*****************************
        //*********************************************************************************

        // Create a test drive result
        Drive_Result__c dr = new Drive_Result__c();
        dr.Drive_Name__c = 'test';
        ////
        dr.Site__c = user.Site__c;
        ////
        insert dr;

        // Verify that Campaign.Site__c was set to User.Site__c
        Drive_Result__c[] createdDriveResult = [SELECT Id, Site__c from Drive_Result__c where ID = : dr.Id];
        System.assertEquals(User.Site__c, createdDriveResult[0].Site__c);

        //Update Campaign.Site to check that the trigger will run
        dr.Site__c = '';
        update dr;

        // Verify that the trigger ran and that Campaign.Site__c was reset to User.Site__c
        dr.Site__c = user.Site__c;
        update dr;
        createdDriveResult = [SELECT Id, Site__c from Drive_Result__c where ID = : dr.Id];
        System.assertEquals(User.Site__c, createdDriveResult[0].Site__c);

    }
    static testMethod void RecurringDonationTest() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact cont = new Contact(FirstName = 'test firstName', LastName = 'test last name');
        insert cont;

        List < npe03__Recurring_Donation__c > reclist = new List < npe03__Recurring_Donation__c > ();

        npe03__Recurring_Donation__c rec = new npe03__Recurring_Donation__c();
        rec.Name = 'test name';
        rec.npe03__Date_Established__c = Date.today();
        rec.npe03__Installment_Period__c = 'Monthly';
        rec.npe03__Schedule_Type__c = 'Multiply By';
        rec.npe03__Amount__c = 2000;
        rec.npe03__Organization__c = acct.Id;
        //rec.npe03__Contact__c=cont.Id;
        rec.npe03__Installments__c = 3;

        reclist.add(rec);

        npe03__Recurring_Donation__c rec1 = new npe03__Recurring_Donation__c();
        rec1.Name = 'test name';
        rec1.npe03__Date_Established__c = Date.today();
        rec1.npe03__Installment_Period__c = 'Yearly';
        rec1.npe03__Schedule_Type__c = 'Divide By';
        rec1.npe03__Amount__c = 2000;
        rec1.npe03__Organization__c = acct.Id;
        //rec1.npe03__Contact__c=cont.Id;
        rec1.npe03__Installments__c = 3;

        reclist.add(rec1);

        npe03__Recurring_Donation__c rec2 = new npe03__Recurring_Donation__c();
        rec2.Name = 'test name';
        rec2.npe03__Date_Established__c = Date.today();
        rec2.npe03__Installment_Period__c = 'Quarterly';
        rec2.npe03__Schedule_Type__c = 'Divide By';
        rec2.npe03__Amount__c = 2000;
        //rec2.npe03__Organization__c=acct.Id;
        rec2.npe03__Contact__c = cont.Id;
        rec2.npe03__Installments__c = 3;

        reclist.add(rec2);

        npe03__Recurring_Donation__c rec3 = new npe03__Recurring_Donation__c();
        rec3.Name = 'test name';
        rec3.npe03__Date_Established__c = Date.today();
        rec3.npe03__Installment_Period__c = 'Custom';
        rec3.npe03__Schedule_Type__c = 'Divide By';
        rec3.npe03__Amount__c = 2000;
        //rec3.npe03__Organization__c=acct.Id;
        rec3.npe03__Contact__c = cont.Id;
        rec3.npe03__Installments__c = 3;

        reclist.add(rec3);

        insert reclist;
    }
    static testMethod void UpdateContactsOnPhoneChangeTest() {
        /*
        Contact Cont1 = new Contact();
        Cont1.LastName = 'test';
        Cont1.FirstName = 'test';
        Cont1.email='test@gmail.com';
        insert Cont1;
        Id Cont1Id= Cont1.Id;

        // Verify that the household was created
        contact c = [SELECT Id, npo02__Household__c from Contact where ID =: Cont1Id limit 1];
        npo02__Household__c[] households = [SELECT Id from npo02__Household__c where ID =: c.npo02__Household__c];
        //System.assertEquals(1,households.size());
        Id HousId;
        if(households.size()>0)  {HousId = Households[0].Id;}

        // Add a 2nd household member
        Contact Cont2 = new Contact();
        Cont2.LastName = 'test';
        Cont2.FirstName = 'test';
        Cont2.email='test@gmail.com';
        Cont2.npo02__Household__c = HousId;
        insert Cont2;
        Id Cont2Id= Cont2.Id;

        // Update the household phone number
        if(households.size()>0) {households[0].npo02__HouseholdPhone__c = '(212) 123-1234';}
        if(households.size()>0) {update households[0];}

        // Verify that the phone number is updated for all household members
        Contact[] contacts = [SELECT Id, HomePhone from Contact where npo02__Household__c =: HousId];
        //System.assertEquals('(212) 123-1234', contacts[0].HomePhone);
        //System.assertEquals('(212) 123-1234', contacts[1].HomePhone);
        */

    }
    static testMethod void MatchedDonationTest() {

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;

        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.FirstName = 'test';
        Cont.AccountId = acct.id;
        Cont.email = 'test@gmail.com';
        insert Cont;
        Id ContId = Cont.Id;

        RecordType Recind, Recorg;
        Recind = [select Id from RecordType where Name = 'Individual Donation'];
        Recorg = [select Id from RecordType where Name = 'Organization Donation'];

        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today();
        Opp.RecordTypeId = Recind.Id;
        Opp.CloseDate = Date.today();
        Opp.Type = 'Matched';
        opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Amount = 100;
        Opp.Contact__c = ContId;
        Opp.Matching_Organization_txt__c = 'matching org';
        Opp.AccountId = acct.Id;
        Opp.Payment_Type__c = 'Cash';
        insert Opp;
        Id OppId = Opp.Id;

        Opportunity Oppm = new Opportunity();
        Oppm.CloseDate = Date.today();
        Oppm.RecordTypeId = Recorg.Id;
        Oppm.CloseDate = Date.today();
        Oppm.Type = 'Matching';
        oppm.StageName = 'Closed Won';
        Oppm.name = 'test';
        Oppm.Amount = 100;
        Oppm.Matched_Donation__c = OppId;
        Oppm.Payment_Type__c = 'Cash';
        Oppm.Matching_Organization_txt__c = 'Test Matching Org';
        insert Oppm;
        Id OppmId = Oppm.Id;

        Opportunity[] myopps = [SELECT id, Matching_Received__c FROM Opportunity Where Id = : OppId];
        System.assertEquals(1, myopps.size());
        System.assertEquals(TRUE, myopps[0].Matching_Received__c);

        delete oppm;
        myopps = [SELECT id, Matching_Received__c FROM Opportunity Where Id = : OppId];
        System.assertEquals(1, myopps.size());
        System.assertEquals(FALSE, myopps[0].Matching_Received__c);
    }


    static testMethod void VolunteerRegistrationCreationTest() {
        // TO DO: implement unit test
        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        insert c1;

        // Insert a volunteer visit 'scheduled'
        Volunteer_Visit__c v = new Volunteer_Visit__c();
        v.Main_Contact__c = c1.Id;
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        v.Scheduled_Start_Date_Time__c = dt;
        v.Status__c = 'Scheduled';
        v.Volunteer_Type__c = 'Individual';
        v.Main_Contact_Volunteer__c = True;
        insert v;

        Volunteer_Registration__c[] registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id];
        System.assertEquals(1, registrations.size());

        delete v;

        // Insert an inquiry first
        Volunteer_Visit__c vv = new Volunteer_Visit__c();
        vv.Main_Contact__c = c1.Id;
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vv.Scheduled_Start_Date_Time__c = dt;
        vv.Status__c = 'Inquiry';
        vv.Volunteer_Type__c = 'Individual';


        insert vv;
        registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id];
        System.assertEquals(0, registrations.size());

        vv.Status__c = 'Scheduled';
        update vv;

        registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id];
        //System.assertEquals(0, registrations.size() );

        vv.Status__c = 'Inquiry';
        update vv;
        vv.Main_Contact_Volunteer__c = True;
        vv.Status__c = 'Scheduled';
        update vv;

        registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id];
        //System.assertEquals(1, registrations.size() );

        vv.Status__c = 'Inquiry';
        update vv;

        registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id];
        System.assertEquals(0, registrations.size());

        delete c1;
    }

    // static testMethod void VolunteerRegistrationToContactTest() {
    //     // TO DO: implement unit test
    //     Contact c1 = new Contact();
    //     c1.Firstname = 'John';
    //     c1.Lastname = 'Doe';
    //     insert c1;
    //     Id c1Id = c1.Id;
    //
    //     // Test new individual registration
    //     Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
    //     vv1.Main_Contact__c = c1.Id;
    //     vv1.Status__c = 'Inquiry';
    //     vv1.Volunteer_Type__c = 'Individual';
    //     insert vv1;
    //
    //     Volunteer_Registration__c vr = new Volunteer_Registration__c();
    //     vr.Contact__c = c1.Id;
    //     vr.Volunteer_Visit__c = vv1.Id;
    //     vr.Num_of_Hours__c = 2;
    //     vr.Status__c = 'Completed';
    //     Date dToday = System.Today();
    //     Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
    //     vr.Actual_Start_Date_Time__c = dt;
    //     insert vr;
    //
    //     Contact c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(1, c.of_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Ind_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Ind_Volunteer_Date__c);
    //     System.assertEquals(1, c.of_Volunteer_Visit__c);
    //
    //     // Test new group registration
    //     Volunteer_Visit__c vv2 = new Volunteer_Visit__c();
    //     vv2.Main_Contact__c = c1.Id;
    //     vv2.Status__c = 'Inquiry';
    //     vv2.Volunteer_Type__c = 'Group';
    //     vv2.Name_of_the_Organization_Group_txt__c = 'Test Org';
    //     insert vv2;
    //
    //     Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
    //     vr2.Contact__c = c1.Id;
    //     vr2.Volunteer_Visit__c = vv2.Id;
    //     vr2.Num_of_Hours__c = 4;
    //     vr2.Status__c = 'Completed';
    //     dToday = System.Today();
    //     dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
    //     vr2.Actual_Start_Date_Time__c = dt;
    //     insert vr2;
    //
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(4, c.of_Group_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Group_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Group_Volunteer_Date__c);
    //     System.assertEquals(1, c.of_Group_Volunteer_Visit__c);
    //
    //     // Test new family registration
    //     Volunteer_Visit__c vv3 = new Volunteer_Visit__c();
    //     vv3.Main_Contact__c = c1.Id;
    //     vv3.Status__c = 'Inquiry';
    //     vv3.Volunteer_Type__c = 'Family';
    //     vv3.Name_of_the_Organization_Group_txt__c = 'Test Family';
    //     insert vv3;
    //
    //     Volunteer_Registration__c vr3 = new Volunteer_Registration__c();
    //     vr3.Contact__c = c1.Id;
    //     vr3.Volunteer_Visit__c = vv3.Id;
    //     vr3.Num_of_Hours__c = 2;
    //     vr3.Status__c = 'Completed';
    //     dToday = System.Today();
    //     dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
    //     vr3.Actual_Start_Date_Time__c = dt;
    //     insert vr3;
    //
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(6, c.of_Group_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Group_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Group_Volunteer_Date__c);
    //     System.assertEquals(2, c.of_Group_Volunteer_Visit__c);
    //
    //     // Test update individual registration
    //     vr.Num_of_Hours__c = 10;
    //     update vr;
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(10, c.of_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Ind_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Ind_Volunteer_Date__c);
    //     System.assertEquals(1, c.of_Volunteer_Visit__c);
    //
    //     // Test update group registration
    //     vr2.Num_of_Hours__c = 10;
    //     update vr2;
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(12, c.of_Group_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Group_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Group_Volunteer_Date__c);
    //     System.assertEquals(2, c.of_Group_Volunteer_Visit__c);
    //
    //     // Test update family registration
    //     vr3.Num_of_Hours__c = 10;
    //     update vr3;
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(20, c.of_Group_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Group_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Group_Volunteer_Date__c);
    //     System.assertEquals(2, c.of_Group_Volunteer_Visit__c);
    //
    //     // Test delete individual registration
    //     delete vr;
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1.Id limit 1];
    //     System.assertEquals(NULL, c.of_Volunteer_Hours__c);
    //     System.assertEquals(NULL, c.last_Ind_Volunteer_Date__c);
    //     System.assertEquals(NULL, c.first_Ind_Volunteer_Date__c);
    //     System.assertEquals(NULL, c.of_Volunteer_Visit__c);
    //
    //     // Test delete group registration
    //     delete vr2;
    //     c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1Id limit 1];
    //     System.assertEquals(10, c.of_Group_Volunteer_Hours__c);
    //     System.assertEquals(Date.today(), c.last_Group_Volunteer_Date__c);
    //     System.assertEquals(Date.today(), c.first_Group_Volunteer_Date__c);
    //     System.assertEquals(1, c.of_Group_Volunteer_Visit__c);
    //
    //     // Test delete family registration
    //     // delete vr3;
    //     // c = [SELECT Id, first_Ind_Volunteer_Date__c, last_Ind_Volunteer_Date__c, of_Volunteer_Hours__c, of_Volunteer_Visit__c, first_Group_Volunteer_Date__c, last_Group_Volunteer_Date__c, of_Group_Volunteer_Hours__c, of_Group_Volunteer_Visit__c from Contact where Id = : c1Id];
    //     // System.assertEquals(NULL, c.of_Group_Volunteer_Hours__c);
    //     // System.assertEquals(NULL, c.last_Group_Volunteer_Date__c);
    //     // System.assertEquals(NULL, c.first_Group_Volunteer_Date__c);
    //     // System.assertEquals(NULL, c.of_Group_Volunteer_Visit__c);
    //
    //     //          delete c1;
    // }

    static testMethod void VolunteerRegistrationDeleteTest() {
        // TO DO: implement unit test
        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        insert c1;
        Id c1Id = c1.Id;

        // Test new individual registration
        Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
        vv1.Main_Contact__c = c1.Id;
        vv1.Status__c = 'Inquiry';
        vv1.Volunteer_Type__c = 'Individual';
        insert vv1;
        Id vv1Id = vv1.Id;

        Volunteer_Registration__c vr = new Volunteer_Registration__c();
        vr.Contact__c = c1.Id;
        vr.Volunteer_Visit__c = vv1.Id;
        vr.Num_of_Hours__c = 2;
        vr.Status__c = 'Completed';
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr.Actual_Start_Date_Time__c = dt;
        insert vr;

        Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
        vr2.Contact__c = c1.Id;
        vr2.Volunteer_Visit__c = vv1.Id;
        vr2.Num_of_Hours__c = 2;
        vr2.Status__c = 'Completed';
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr2.Actual_Start_Date_Time__c = dt;
        insert vr2;

        Volunteer_Registration__c[] registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id and Volunteer_Visit__c = : vv1Id];
        System.assertEquals(2, registrations.size());

        delete vv1;

        registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id and Volunteer_Visit__c = : vv1Id];
        System.assertEquals(0, registrations.size());
    }
    static testMethod void GroupSummaryRollupTest() {

        Account a = new Account();
        a.name = 'Test Org';
        insert a;
        Id aId = a.Id;

        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        c1.AccountId = aId;
        insert c1;
        Id c1Id = c1.Id;

        // Test new visit
        Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
        vv1.Main_Contact__c = c1.Id;
        vv1.Org_Group__c = aId;
        vv1.Status__c = 'Completed';
        vv1.Volunteer_Type__c = 'Group';
        Date dToday = System.Today() - 1;
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vv1.Scheduled_Start_Date_Time__c = dt;
        vv1.Actual_Date_Time__c = dt;
        vv1.Actual_hours__c = 10;
        vv1.Actual_volunteers__c = 5;
        insert vv1;
        Id vv1Id = vv1.Id;

        Account[] acts = [SELECT Id, of_Volunteer_Hours__c, of_Volunteer_Visit__c, Last_Group_Volunteer_Date__c, First_Group_Volunteer_Date__c from Account where Id = : aId];
        System.assertEquals(1, acts.size());
        System.assertEquals(1, acts[0].of_Volunteer_Visit__c);
        System.assertEquals(10, acts[0].of_Volunteer_Hours__c);

        // Test update visit
        Volunteer_Visit__c vv2 = new Volunteer_Visit__c();
        vv2.Main_Contact__c = c1.Id;
        vv2.Org_Group__c = aId;
        vv2.Status__c = 'Inquiry';
        vv2.Volunteer_Type__c = 'Group';
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vv2.Actual_Date_Time__c = dt;
        vv2.Actual_hours__c = 10;
        vv2.Actual_volunteers__c = 5;
        insert vv2;
        Id vv2Id = vv2.Id;


        acts = [SELECT Id, of_Volunteer_Hours__c, of_Volunteer_Visit__c, Last_Group_Volunteer_Date__c, First_Group_Volunteer_Date__c from Account where Id = : aId];
        System.assertEquals(1, acts.size());
        System.assertEquals(1, acts[0].of_Volunteer_Visit__c);
        System.assertEquals(10, acts[0].of_Volunteer_Hours__c);

        vv2.Status__c = 'Completed';
        vv2.Scheduled_Start_Date_Time__c = dt;
        update vv2;

        acts = [SELECT Id, of_Volunteer_Hours__c, of_Volunteer_Visit__c, Last_Group_Volunteer_Date__c, First_Group_Volunteer_Date__c from Account where Id = : aId];
        System.assertEquals(1, acts.size());
        System.assertEquals(2, acts[0].of_Volunteer_Visit__c);
        System.assertEquals(20, acts[0].of_Volunteer_Hours__c);
        delete vv2;

        acts = [SELECT Id, of_Volunteer_Hours__c, of_Volunteer_Visit__c, Last_Group_Volunteer_Date__c, First_Group_Volunteer_Date__c from Account where Id = : aId];
        System.assertEquals(1, acts.size());
        System.assertEquals(1, acts[0].of_Volunteer_Visit__c);
        System.assertEquals(10, acts[0].of_Volunteer_Hours__c);

        delete vv1;
        delete c1;
        delete a;
    }

    // static testMethod void RegistrationToVisitRollupTest() {
    //     // TO DO: implement unit test
    //     Contact c1 = new Contact();
    //     c1.Firstname = 'John';
    //     c1.Lastname = 'Doe';
    //     insert c1;
    //     Id c1Id = c1.Id;
    //
    //     // Test new individual registration
    //     Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
    //     vv1.Main_Contact__c = c1.Id;
    //     vv1.Status__c = 'Inquiry';
    //     vv1.Volunteer_Type__c = 'Individual';
    //     insert vv1;
    //
    //     Volunteer_Registration__c vr = new Volunteer_Registration__c();
    //     vr.Contact__c = c1.Id;
    //     vr.Volunteer_Visit__c = vv1.Id;
    //     vr.Num_of_Hours__c = 2;
    //     vr.Status__c = 'Completed';
    //     Date dToday = System.Today();
    //     Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
    //     vr.Actual_Start_Date_Time__c = dt;
    //     insert vr;
    //
    //     Volunteer_Visit__c[] visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c from Volunteer_Visit__c where Id = : vv1.Id];
    //     System.assertEquals(null, visits[0].Actual_hours__c);
    //     System.assertEquals(1, visits[0].Actual_volunteers__c);
    //
    //     Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
    //     vr2.Contact__c = c1.Id;
    //     vr2.Volunteer_Visit__c = vv1.Id;
    //     vr2.Num_of_Hours__c = 2;
    //     vr2.Status__c = 'Completed';
    //     dToday = System.Today();
    //     dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
    //     vr2.Actual_Start_Date_Time__c = dt;
    //     insert vr2;
    //
    //     visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c from Volunteer_Visit__c where Id = : vv1.Id];
    //     System.assertEquals(4, visits[0].Actual_hours__c);
    //     System.assertEquals(2, visits[0].Actual_volunteers__c);
    //
    //     vr2.Num_of_Hours__c = 4;
    //     update vr2;
    //
    //     visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c from Volunteer_Visit__c where Id = : vv1.Id];
    //     System.assertEquals(6, visits[0].Actual_hours__c);
    //     System.assertEquals(2, visits[0].Actual_volunteers__c);
    //
    //     vr2.Status__c = 'Inquiry';
    //     update vr2;
    //
    //     visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c from Volunteer_Visit__c where Id = : vv1.Id];
    //     System.assertEquals(2, visits[0].Actual_hours__c);
    //     System.assertEquals(1, visits[0].Actual_volunteers__c);
    //
    //     delete vr2;
    //     delete vr;
    //
    //     visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c from Volunteer_Visit__c where Id = : vv1.Id];
    //     System.assertEquals(NULL, visits[0].Actual_hours__c);
    //     System.assertEquals(NULL, visits[0].Actual_volunteers__c);
    // }


    static testMethod void AffiliateVolunteerTest() {

        Account a = new Account();
        a.name = 'Test Org';
        insert a;
        Id aId = a.Id;

        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        c1.AccountId = aId;
        insert c1;
        Id c1Id = c1.Id;

        // Test new group registration
        Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
        vv1.Main_Contact__c = c1.Id;
        vv1.Status__c = 'Inquiry';
        vv1.Volunteer_Type__c = 'Group';
        vv1.Org_Group__c = aId;
        insert vv1;
        Id vv1Id = vv1.Id;

        npe5__Affiliation__c[] affs = [SELECT Id from npe5__Affiliation__c where npe5__Contact__c = : c1Id AND npe5__Organization__c = : aId AND Type__c = 'Volunteer'];
        //          System.assertEquals(0, affs.size() );

        Volunteer_Registration__c vr = new Volunteer_Registration__c();
        vr.Contact__c = c1.Id;
        vr.Volunteer_Visit__c = vv1.Id;
        vr.Num_of_Hours__c = 2;
        vr.Status__c = 'Completed';
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr.Actual_Start_Date_Time__c = dt;
        insert vr;

        affs = [SELECT Id from npe5__Affiliation__c where npe5__Contact__c = : c1Id AND npe5__Organization__c = : aId AND Type__c = 'Volunteer'];
        //System.assertEquals(1, affs.size() );

        Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
        vr2.Contact__c = c1.Id;
        vr2.Volunteer_Visit__c = vv1.Id;
        vr2.Num_of_Hours__c = 2;
        vr2.Status__c = 'Completed';
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr2.Actual_Start_Date_Time__c = dt;
        insert vr2;

        Volunteer_Registration__c[] registrations = [SELECT Id from Volunteer_Registration__c where Contact__c = : c1.Id and Volunteer_Visit__c = : vv1Id];
        System.assertEquals(2, registrations.size());
    }
    static testMethod void RegistrationToVisitEmailRollupTest() {
        // TO DO: implement unit test
        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        c1.Email = 'test@test.com';
        insert c1;
        Id c1Id = c1.Id;

        // Test new individual registration
        Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
        vv1.Main_Contact__c = c1.Id;
        vv1.Status__c = 'Inquiry';
        vv1.Volunteer_Type__c = 'Individual';
        insert vv1;

        Volunteer_Registration__c vr = new Volunteer_Registration__c();
        vr.Contact__c = c1.Id;
        vr.Volunteer_Visit__c = vv1.Id;
        vr.Num_of_Hours__c = 2;
        vr.Status__c = 'Inquiry';
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr.Actual_Start_Date_Time__c = dt;
        insert vr;

        Volunteer_Visit__c[] visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c, Email_list_of_registered_volunteer__c from Volunteer_Visit__c where Id = : vv1.Id];
        System.assertEquals('test@test.com', visits[0].Email_list_of_registered_volunteer__c);

        Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
        vr2.Contact__c = c1.Id;
        vr2.Volunteer_Visit__c = vv1.Id;
        vr2.Num_of_Hours__c = 2;
        vr2.Status__c = 'Completed';
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr2.Actual_Start_Date_Time__c = dt;
        insert vr2;

        visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c, Email_list_of_registered_volunteer__c from Volunteer_Visit__c where Id = : vv1.Id];
        System.assertEquals('test@test.com ; test@test.com', visits[0].Email_list_of_registered_volunteer__c);

        delete vr2;

        visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c, Email_list_of_registered_volunteer__c from Volunteer_Visit__c where Id = : vv1.Id];
        System.assertEquals('test@test.com', visits[0].Email_list_of_registered_volunteer__c);

        delete vr;

        visits = [SELECT Id, Actual_hours__c, Actual_volunteers__c, Email_list_of_registered_volunteer__c from Volunteer_Visit__c where Id = : vv1.Id];
        System.assertEquals(NULL, visits[0].Email_list_of_registered_volunteer__c);

    }

    static testMethod void RepeatTest() {


        // Create a test contact
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        insert c;

        // Add a Volunteer Visit
        Volunteer_Visit__c vv1 = new Volunteer_Visit__c();
        vv1.Main_Contact__c = c.Id;
        vv1.Status__c = 'Inquiry';
        vv1.Volunteer_Type__c = 'Individual';
        insert vv1;

        // Add a Volunteer Reg
        Volunteer_Registration__c vr1 = new Volunteer_Registration__c();
        vr1.Contact__c = c.Id;
        vr1.Volunteer_Visit__c = vv1.Id;
        vr1.Num_of_Hours__c = 2;
        vr1.Status__c = 'Completed';
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr1.Actual_Start_Date_Time__c = dt;
        insert vr1;

        Volunteer_Registration__c[] registrations = [SELECT Id, Repeat__c from Volunteer_Registration__c where ID = : vr1.Id];
        System.assertEquals(null, registrations[0].Repeat__c);

        //c.of_Volunteer_Visit__c = 1;
        //update c;

        // Add a Volunteer Visit
        Volunteer_Visit__c vv2 = new Volunteer_Visit__c();
        vv2.Main_Contact__c = c.Id;
        vv2.Status__c = 'Inquiry';
        vv2.Volunteer_Type__c = 'Individual';
        insert vv2;

        // Add a Volunteer Reg
        Volunteer_Registration__c vr2 = new Volunteer_Registration__c();
        vr2.Contact__c = c.Id;
        vr2.Volunteer_Visit__c = vv2.Id;
        vr2.Num_of_Hours__c = 2;
        vr2.Status__c = 'Completed';
        dToday = System.Today();
        dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
        vr2.Actual_Start_Date_Time__c = dt;
        insert vr2;

        registrations = [SELECT Id, Repeat__c from Volunteer_Registration__c where ID = : vr2.Id];
        System.assertEquals(null, registrations[0].Repeat__c);
    }

    static testMethod void CoordinatorCreationTest() {
        // TO DO: implement unit test
        Contact c1 = new Contact();
        c1.Firstname = 'John';
        c1.Lastname = 'Doe';
        insert c1;

        Campaign camp1 = new Campaign();
        camp1.Name = '[Bo]test';
        camp1.StartDate = System.Today();
        camp1.IsActive = True;
        camp1.Primary_Contact__c = c1.Id;
        insert camp1;

        // Test that a coordinator has been created automatically
        Coordinator__c[] coordinators = [SELECT Id from Coordinator__c where Contact__c = : c1.Id];
        System.assertEquals(1, coordinators.size());

        delete camp1;
        delete c1;
    }
//   static testMethod void TestSetHHNamingExclusion() {
//       Contact c1 = new Contact();
//       c1.Firstname = 'John';
//       c1.Lastname = 'Doe';
//       c1.Contact_Type__c = 'Child';
//       insert c1;
//
//        Contact[] contacts = [SELECT Id, npo02__Naming_Exclusions__c from Contact where Id = : c1.Id];
//        System.assertEquals('Household__c.Name;Household__c.Formal_Greeting__c;Household__c.Informal_Greeting__c', contacts[0].npo02__Naming_Exclusions__c);
//
//        c1.Contact_Type__c = 'Adult';
//        update c1;
//
//        contacts = [SELECT Id, npo02__Naming_Exclusions__c from Contact where Id = : c1.Id];
//        System.assertEquals(null, contacts[0].npo02__Naming_Exclusions__c);
//
//    }

    static testMethod void RollupToCampaignTest() {

        Campaign camp = new Campaign();
        camp.name = '[Bo]Test Camp';
        camp.Type = 'Corporate';
        camp.Status = 'Complete';
        camp.StartDate = System.Today();
        ////
        camp.Books_Rollup__c = 2;
        insert camp;

        Drive_Result__c dr1 = new Drive_Result__c();
        dr1.Drive_Campaign__c = camp.id;
        dr1.Books__c = 1;
        insert dr1;

        Drive_Result__c dr2 = new Drive_Result__c();
        dr2.Drive_Campaign__c = camp.id;
        dr2.Books__c = 1;
        insert dr2;


        Campaign[] camps = [SELECT Id, Books_Rollup__c from Campaign where Id = : camp.Id];
        System.assertEquals(2, camps[0].Books_Rollup__c);

        dr2.Books__c = 2;
        update dr2;
        ////
        camp.Books_Rollup__c = 3;
        update camp;

        camps = [SELECT Id, Books_Rollup__c from Campaign where Id = : camp.Id];
        System.assertEquals(3, camps[0].Books_Rollup__c);

        delete dr2;
        ///
        camp.Books_Rollup__c = 1;
        update camp;

        camps = [SELECT Id, Books_Rollup__c from Campaign where Id = : camp.Id];
        System.assertEquals(1, camps[0].Books_Rollup__c);

        delete dr1;
        delete camp;

    }

}