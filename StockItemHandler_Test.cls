@isTest
private class StockItemHandler_Test {
    
    @isTest static void testBeforeInsertFunctionality() {
        // Implement test code
        List<Stock_Item__c> stockItemList = new List<Stock_Item__c>();
        Stock_Item__c stockObj = new Stock_Item__c();
        stockObj.Item_Name__c = 'test item';
        insert stockObj;
        for(Integer i=0;i<20;i++){
            Stock_Item__c stockDuplicateObj = new Stock_Item__c();
            stockDuplicateObj.Item_Name__c = 'test item';
            stockItemList.add(stockDuplicateObj);
        }
        test.startTest();
        try{
        	insert stockItemList;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  (e.getMessage().contains('Stock name can not be duplicated.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        test.stopTest();
    } 
    
    @isTest static void testBeforeDeleteFunctionality() {
        // Implement test code
        List<Stock_Item__c> stockItemList = new List<Stock_Item__c>();
        for(Integer i=0;i<20;i++){
            Stock_Item__c stockDuplicateObj = new Stock_Item__c();
            stockDuplicateObj.Item_Name__c = 'test item'+i;
            stockDuplicateObj.Stock_on_Hand__c = 10;
            stockItemList.add(stockDuplicateObj);
        }
        insert stockItemList;
        test.startTest();
        delete stockItemList;
        system.assertEquals(20,[select id from case where subject='Stock Item Case'].size());
        test.stopTest();
    }
    
    @isTest static void testGetLowStockItems() {
        // Implement test code
        List<Stock_Item__c> stockItemList = new List<Stock_Item__c>();
        for(Integer i=0;i<20;i++){
            Stock_Item__c stockObj = new Stock_Item__c();
            stockObj.Item_Name__c = 'test item'+i;
            stockObj.Stock_on_Hand__c = 1;
            stockObj.Minimum_Stock_Level__c = 5;
            stockItemList.add(stockObj);
        }
        insert stockItemList;
        test.startTest();
        List<Stock_Item__c> returnList = StockItemHandler.getLowStockItems();
        system.assertEquals(20, returnList.size());
        test.stopTest();
    }
    
    @isTest static void packageUploadCoverage() {
        Stock_Item__c item = new Stock_Item__c();
        item.Item_Name__c = 'Test';
        item.Description__c = 'Test';
        item.Minimum_Stock_Level__c =3;
        
        insert item;
        
    }
    
}