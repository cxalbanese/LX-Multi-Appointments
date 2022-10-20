@isTest(SeeAllData=true)
public with sharing class TestUtility {
    public TestUtility() {

    }

    public static WorkType createWorktype(String worktypeName, Double estDuration, String durationType){

        WorkType testWorkType = new WorkType(Name = worktypeName,
                                            EstimatedDuration = estDuration,
                                            DurationType = durationType);

        insert testWorkType;                            
        return testWorkType;

    }
    public static Account createAccount(String acctName){

        Account testAccount = new Account(Name = acctName);

        insert testAccount;                            
        return testAccount;

    }

    public static Asset createAsset(String assetName,String accountId){

        Asset testAsset = new Asset(Name = assetName,AccountId=accountId);

        insert testAsset;                            
        return testAsset;

    }
    public static WorkTypeGroup createWorktypeGroup(String worktypeGroupName, Boolean isActive){

        WorkTypeGroup testWorkTypeGroup = new WorkTypeGroup(Name = worktypeGroupName,
                                            isActive = isActive);

        insert testWorkTypeGroup;                            
        return testWorkTypeGroup;

    }


    public static OperatingHours createOperatingHours(String ohName){

        OperatingHours testOperatingHours = new OperatingHours(Name = ohName);
        
        insert testOperatingHours;
        return testOperatingHours;

    }

    public static TimeSlot createTimeSlot(String OHId){
        TimeSlot testTimeSlot = new TimeSlot(OperatingHoursId=OHId,Type='Normal',DayofWeek='Monday',StartTime=Time.newInstance(08, 0, 0, 0),EndTime=Time.newInstance(14, 0, 0, 0));

        insert testTimeSlot;
        return testTimeSlot;

    }


    public static OperatingHours createOperatingHours(String ohName, String tz){

        OperatingHours testOperatingHours = new OperatingHours(Name = ohName, 
                                                               TimeZone = tz);
        
        insert testOperatingHours;
        return testOperatingHours;

    }


    public static ServiceTerritory createServiceTerritory(String territoryName,Boolean active, String opHoursId){

        ServiceTerritory testServiceTerritory = new ServiceTerritory(Name = territoryName,
                                                                     IsActive = active,
                                                                     OperatingHoursId = opHoursId);

        insert testServiceTerritory;
        return testServiceTerritory;

    }


    public static ServiceResource createServiceResource(String resourceName, Boolean active, String relatedRecord, String resourceType){

        ServiceResource testServiceResource = new ServiceResource(Name = resourceName,
                                                                  IsActive = active,
                                                                  AssetId = relatedRecord,
                                                                  ResourceType = resourceType);

        insert testServiceResource;
        return testServiceResource;

    }


    public static ServiceTerritoryMember createServiceTerritoryMember(String resourceId, String territoryId, Datetime startDate){

        ServiceTerritoryMember testStm = new ServiceTerritoryMember(ServiceResourceid = resourceId,
                                                                    ServiceTerritoryId = territoryId,
                                                                    EffectiveStartDate = startDate);

        insert testStm;
        return testStm;

    }
    public static WorkTypeGroupMember createWorkTypeGroupMember(String wtgId, String wtId){

        WorkTypeGroupMember testWTGWTM = new WorkTypeGroupMember(WorkTypeGroupId = wtgId,
                                                                    WorkTypeId = wtId);

        insert testWTGWTM;
        return testWTGWTM;

    }    

    public static ServiceTerritoryWorkType createServiceTerritoryWorkType(String wtId, String stId){

        ServiceTerritoryWorkType testServiceTerritoryWorkType = new ServiceTerritoryWorkType(WorkTypeId = wtId,
                                                                    ServiceTerritoryId = stId);

        insert testServiceTerritoryWorkType;
        return testServiceTerritoryWorkType;

    }    

    public static Map<String,SObject> createSingleTestResource(){

        String objectName = '';
        Map<String, SObject> testResourceObjectMap = new Map<String, SObject>();
        String userId = UserInfo.getUserId();
        String testName = 'test' + String.valueOf(Crypto.getRandomInteger());

        WorkType testWorkType = createWorkType(testName, 1, 'hours');
        objectName = 'WorkType';
        testResourceObjectMap.put(objectName, testWorkType);

        WorkTypeGroup testWorkTypeGroup = createWorkTypeGroup(testName, true);
        objectName = 'WorkTypeGroup';
        testResourceObjectMap.put(objectName, testWorkTypeGroup);

        OperatingHours testOh = createOperatingHours(testName);
        objectName = 'OperatingHours';
        testResourceObjectMap.put(objectName, testOh);

        TimeSlot testTimeSlot = createTimeSlot(testOh.Id);
        objectname = 'TimeSlot';
        testResourceObjectMap.put(objectName,testTimeSlot);

        ServiceTerritory testTerritory = createServiceTerritory(testName, true, testOh.Id);
        objectName = 'ServiceTerritory';
        testResourceObjectMap.put(objectName, testTerritory);

        Account testAccount = createAccount('test account');
        objectName = 'Account';     
        testResourceObjectMap.put(objectName, testAccount);

        Asset testAsset = createAsset('test asset',testAccount.Id);
        objectName = 'Asset';     
        testResourceObjectMap.put(objectName, testAsset);        

        ServiceResource testResource = createServiceResource(testName, true, testAsset.Id, 'S');
        objectName = 'ServiceResource';
        testResourceObjectMap.put(objectName, testResource);

        ServiceTerritoryMember testSTM = createServiceTerritoryMember(testResource.Id, testTerritory.Id, datetime.now());
        objectName = 'ServiceTerritoryMember';     
        testResourceObjectMap.put(objectName, testSTM);

        ServiceTerritoryWorkType testServiceTerritoryWorkType = createServiceTerritoryWorkType(testWorkType.id,testTerritory.Id);
        objectName = 'ServiceTerritoryWorkType';     
        testResourceObjectMap.put(objectName, testServiceTerritoryWorkType);

        WorkTypeGroupMember testWorkTypeGroupMember = createWorkTypeGroupMember(testWorkTypeGroup.id,testWorkType.id);
        objectName = 'WorkTypeGroupMember';     
        testResourceObjectMap.put(objectName, testWorkTypeGroupMember);

        return testResourceObjectMap;
    }


}