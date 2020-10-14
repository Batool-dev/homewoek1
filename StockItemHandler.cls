/**
* A Utility class to process Stock Item records from the Stock Item Handler
*/
public with sharing class StockItemHandler {
    
    /**
* Class constructor.
*/
    public StockItemHandler() {
        
    }
    //beforeInsertMethod starts here.
    public static void beforeInsertMethod(List<Stock_Item__c> stockItemList){
        List<String> nameList = new List<String>();
        List<Stock_Item__c> existingStockItemList = new List<Stock_Item__c>();
        Map<String ,Stock_Item__c> nameStockMap = new Map<String,Stock_Item__c>();
        //Collect the name of new stock items.
        if(!stockItemList.isEmpty()){
            for(Stock_Item__c stockObj : stockItemList){
                nameList.add(stockObj.Item_Name__c);
            }
        }
        if(!nameList.isEmpty()){
            //Fetch the existing stock item with the same name.
            existingStockItemList = [select id,Item_Name__c from Stock_Item__c where Item_Name__c=:nameList];
            Map<String ,Account> mapNameWiseAccount = new Map<String,Account>();
            for(Stock_Item__c stockObj : existingStockItemList){
                nameStockMap.put(stockObj.Item_Name__c ,stockObj);
            }
            //Add a error if the stock item name is existing.
            for(Stock_Item__c stockObj : stockItemList){
                if(nameStockMap.get(stockObj.Item_Name__c) != null){
                    stockObj.addError('Stock name can not be duplicated.'); 
                }
            }
        }
    }
    ////beforeInsertMethod ends here.
    
    //beforeDeleteMethod starts here
    public static void beforeDeleteMethod(List<Stock_Item__c> stockItemList){
        List<Case> casesList = new List<Case>();
        //Create a case for stock item with stock in hand not equal to 0 
        for (Stock_Item__c stockItem: stockItemList) {
            if (stockItem.Stock_on_Hand__c != 0) {
                Case c = new Case();
                c.Description = 'Case related to Stock Id '+stockItem.Id+' and stock in hand is '+string.valueOf(stockItem.Stock_on_Hand__c);
                c.Subject = 'Stock Item Case';
                casesList.add(c);
            }
        }
        if(!casesList.isEmpty())
        	insert casesList;
    }
    //beforeDeleteMethod ends here
    
    //getLowStockItems method starts here
    public static List<Stock_Item__c> getLowStockItems() {
        //Query and return list of stock item with Item stock level low
        List<Stock_Item__c> stockItemList = [SELECT Id, Item_Name__c, Item_Stock_is_Low__c, Minimum_Stock_Level__c, Stock_on_Hand__c
            FROM Stock_Item__c WHERE Item_Stock_is_Low__c = true];

        return stockItemList;
    }
    //getLowStockItems method ends here
    
    //Create methods here to handle the before insert, before delete and utility processes described in the requirements
    //They should accept lists of Stock_Item__c records from the trigger
    
    
}