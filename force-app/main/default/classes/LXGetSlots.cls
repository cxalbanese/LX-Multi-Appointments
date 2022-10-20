public with sharing class LXGetSlots {

    @invocableMethod(label='LX Get Slots' description='Get Slots')
    public static list<returnPayload> LXGetSlots(list<payloadIn> payloadList ){
        if(payloadList == null || payloadList.size() <> 1) return null;
        payloadIn pl = payloadList[0];
        integer horizon=7;
        integer numSlots=3;
        if(pl.horizon!=null && pl.horizon > 0) horizon=pl.horizon;
        if(pl.numSlots!=null && pl.numSlots > 0) numSlots=pl.numSlots;
        if(pl.accountId.left(3)!='001') pl.accountId=null;
        lxscheduler.GetAppointmentCandidatesInput input = new lxscheduler.GetAppointmentCandidatesInputBuilder()
            .setWorkTypeGroupId(pl.workTypeGroupId)
            .setTerritoryIds(new List<String>{pl.serviceTerritoryId})
            .setStartTime(pl.startDateTime.format('yyyy-MM-dd\'T\'HH:mm:ssZ'))
            .setEndTime(pl.startDateTime.addDays(horizon).format('yyyy-MM-dd\'T\'HH:mm:ssZ'))
            .setAccountId(pl.accountId)
            .setSchedulingPolicyId(pl.schedulingPolicyId)
            .setApiVersion(Double.valueOf('50.0'))
            .build();
        //call the Apex Method - no REST API authentication or API user needed!!!
        String response = lxscheduler.SchedulerResources.getAppointmentCandidates(input);
        if(response==null) return null;
        list<schedulerCandidates> allslots = schedulerCandidates.parse(response);
        string htmlTemplate = '<div style="display:none;">|SlotNumber|</div><span class="slds-text-heading--small">Date</span><br/><span class="slds-text-heading--medium">Time</span><br/><span class="slds-text-title">Select for 1st Appointment</span>';        
        list<string> listoutputSlotText = new list<string>();
        integer slotCounter=0;
        if(allslots!=null && allslots.size()>0) {
            for (schedulerCandidates thisslot : allslots) {
                string thisoutputSlot = htmlTemplate.replace('SlotNumber','SlotNumber'+slotCounter.format()+'ResourceId'+thisslot.resources[0]+'Start'+thisslot.startTime+'End'+thisslot.endTime);
                thisoutputSlot = thisoutputSlot.replace('Time',thisslot.startTime.format('h:mm a'));
                thisoutputSlot = thisoutputSlot.replace('Date',thisslot.startTime.format('EEE, MMM d'));
                thisoutputSlot = thisoutputSlot.replace('1st',pl.apptNumber);
                listoutputSlotText.add(thisoutputSlot);
                slotCounter++;
                if(slotCounter>=numSlots) break;
            }
        }

        returnPayload rp = new returnPayload();
        list<returnPayload> rpList = new List<returnPayload>();
        rp.textListSlots = listoutputSlotText;
        rp.numSlotsReturned = slotCounter;
        rpList.add(rp);
        return new list<returnPayload>{rp};
    }
    public class payloadIn{
        @invocableVariable(required=true)
        public string workTypeGroupId;
        @invocableVariable(required=true)
        public string serviceTerritoryId;
        @invocableVariable(required=true)
        public string schedulingPolicyId;
        @invocableVariable(required=true)
        public datetime startDateTime;
        @invocableVariable(required=true)
        public integer horizon;
        @invocableVariable(required=true)
        public integer numSlots;
        @invocableVariable(required=false)
        public string accountId;
        @invocableVariable(required=true)
        public string apptNumber;
    }
    public class returnPayload {
        @InvocableVariable
        public List<string> textListSlots;   
        @InvocableVariable
        public Integer numSlotsReturned;
    }

}