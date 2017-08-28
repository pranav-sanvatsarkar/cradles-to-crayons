trigger VolunteerRegistrationToContact on Volunteer_Registration__c (after delete, after insert, after undelete, 
after update) {

    set<ID> IndConIDs = new Set<ID>();
    set<ID> GrpConIDs = new Set<ID>();
    
    if(Trigger.isInsert || Trigger.isUnDelete) {
        for(Volunteer_Registration__c vol : System.Trigger.new){
                if(vol.Status__c == 'Completed' && vol.Inquiry_Type__c == 'Individual') {
                    IndConIDs.add(vol.Contact__c);}
                if(vol.Status__c == 'Completed' && (vol.Inquiry_Type__c == 'Group' || vol.Inquiry_Type__c == 'Family')) {
                            GrpConIDs.add(vol.Contact__c);}
            }
    if(IndConIDs.size()>0){RollupToContact.DoIndVisit(IndConIDs);}
    if(GrpConIDs.size()>0){RollupToContact.DoGroupVisit(GrpConIDs);}    
    }   

    if( Trigger.isUpdate ) {
        
        for (integer i = 0; i<Trigger.new.size(); i++) {
                if((Trigger.old[i].Status__c == 'Completed' || Trigger.new[i].Status__c == 'Completed') && Trigger.new[i].Inquiry_Type__c == 'Individual')
                    {IndConIDs.add(Trigger.new[i].Contact__c);}
                //Handles the case of Volunteer_Registration__c.Contact__c being changed
                if(Trigger.old[i].Contact__c <> Trigger.new[i].Contact__c && Trigger.new[i].Inquiry_Type__c == 'Individual')
                    {IndConIDs.add(Trigger.new[i].Contact__c);}
                
                if((Trigger.old[i].Status__c == 'Completed' || Trigger.new[i].Status__c == 'Completed') && (Trigger.new[i].Inquiry_Type__c == 'Group' ||Trigger.new[i].Inquiry_Type__c == 'Family' ))
                    {GrpConIDs.add(Trigger.new[i].Contact__c);}
                //Handles the case of Volunteer_Registration__c.Contact__c being changed
                if(Trigger.old[i].Contact__c <> Trigger.new[i].Contact__c && (Trigger.new[i].Inquiry_Type__c == 'Group' ||Trigger.new[i].Inquiry_Type__c == 'Family' ))
                    {GrpConIDs.add(Trigger.new[i].Contact__c);} 
                
            }
    if(IndConIDs.size()>0){RollupToContact.DoIndVisit(IndConIDs);}
    if(GrpConIDs.size()>0){RollupToContact.DoGroupVisit(GrpConIDs);}
                
    }
    if(Trigger.isDelete) {
        for(Volunteer_Registration__c vol : System.Trigger.old){
                if(vol.Status__c == 'Completed' && vol.Inquiry_Type__c == 'Individual')
                    {IndConIDs.add(vol.Contact__c);}
                if(vol.Status__c == 'Completed' && (vol.Inquiry_Type__c == 'Group' || vol.Inquiry_Type__c == 'Family'))
                    {GrpConIDs.add(vol.Contact__c);}
            }
        
	if(IndConIDs.size()>0){RollupToContact.DoIndVisit(IndConIDs);}
    if(GrpConIDs.size()>0){RollupToContact.DoGroupVisit(GrpConIDs);}
    }       
}