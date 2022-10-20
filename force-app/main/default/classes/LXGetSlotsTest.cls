@isTest
public class LXGetSlotsTest{

    static testMethod void validateLXGetSlots() {
       String expectedResponse = '[' +
        '  {' +
        '    \"startTime\": \"2021-03-18T16:00:00.000+0000\",' +
        '    \"endTime\": \"2021-03-18T17:00:00.000+0000\",' +
        '    \"resources\": [' +
        '      \"0HnRM0000000Fxv0AE\"' +
        '    ],' +
        '    \"territoryId\": \"0HhRM0000000G8W0AU\"' +
        '  },' +
        '  {' +
        '    \"startTime\": \"2021-03-18T19:00:00.000+0000\",' +
        '    \"endTime\": \"2021-03-18T20:00:00.000+0000\",' +
        '    \"resources\": [' +
        '      \"0HnRM0000000Fxv0AE\"' +
        '    ],' +
        '    \"territoryId\": \"0HhRM0000000G8W0AU\"' +
        '  }' +
        ']';
        lxscheduler.SchedulerResources.setAppointmentCandidatesMock(expectedResponse); 
        Test.startTest();
        Map<String,SObject> testResourceMap = TestUtility.createSingleTestResource();
        LXGetSlots.payloadIn payload = new LXGetSlots.payloadIn();
        payload.workTypeGroupId = ((WorkTypeGroup)testResourceMap.get('WorkTypeGroup')).Id;
        payload.serviceTerritoryId = ((ServiceTerritory)testResourceMap.get('ServiceTerritory')).Id;
        payload.schedulingPolicyId = [select Id from AppointmentSchedulingPolicy where IsOrgDefault=true limit 1].Id;
        payload.startDateTime = datetime.now();
        payload.horizon=10;
        payload.numSlots=3;
        payload.accountId = ((Account)testResourceMap.get('Account')).Id;
        payload.apptNumber='1st';
        list<LXGetSlots.payloadIn> inputList = new list<LXGetSlots.payloadIn>{payload};
        list<LXGetSlots.returnPayload> outputList = LXGetSlots.LXGetSlots(inputList);
        System.Assert.areNotEqual(0, outputList[0].numSlotsReturned, 'Should return more than 0 records');
        test.stopTest();
        }

}