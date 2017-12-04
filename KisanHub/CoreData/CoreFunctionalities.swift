//
//  CoreFunctionality.swift
//  KisanHub
//
//  Created by akshay bansal on 12/3/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

import UIKit
import CoreData


 class CoreFunctionalities {

    func addWheatherStatistics(country : String, wheather : String,values : Set<KeyValue>){
    
        let managedContext = context
        
        if #available(iOS 10.0, *) {
            let userData = WheatherStatistics(context: managedContext)
            userData.country = country
            userData.wheather = wheather
            userData.values = values as NSSet
            
        } else {
            // Fallback on earlier versions
            
            let entityDesc = NSEntityDescription.entity(forEntityName: "WheatherStatistics", in: managedContext)
            let userData = WheatherStatistics(entity: entityDesc!, insertInto: managedContext)
            userData.country = country
            userData.wheather = wheather
            userData.values = values as NSSet
        }

    }
    
    func addKeyValues(year : String, keys : [String],  values : [String]) -> Set<KeyValue> {
        var valuesSet  = Set<KeyValue>()
        for i in 0..<values.count
        {
            valuesSet.insert(addKeyValueData(year: year, key: keys[i], value: values[i]))
        }
        return valuesSet
    }
    
    
    func addKeyValueData(year : String, key : String,  value : String) -> KeyValue {
        
        let managedContext = context
        var data : KeyValue
        if #available(iOS 10.0, *) {
            data = KeyValue(context: managedContext)
            data.year = year
            data.key = key
            data.value = value

        } else {
            let entityDesc = NSEntityDescription.entity(forEntityName: "KeyValue", in: managedContext)
            data = KeyValue(entity: entityDesc!, insertInto: managedContext)
            data.year = year
            data.key = key
            data.value = value
        }

        return data
    }
    
    func deleteAllRecords() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WheatherStatistics")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    
    
}
