//
//  DataParser.swift
//  KisanHub
//
//  Created by akshay bansal on 12/4/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

import Foundation

class DataParser: Operation {
    let data: String
    
    init(data: String) {
        self.data = data
    }
    
    override func main () {
        if self.isCancelled {
            return
        }
        
        findHeadingIndexes()
        parseData(data: data , keys:keys)
    }
    
    let headingString = "Year    JAN    FEB    MAR    APR    MAY    JUN    JUL    AUG    SEP    OCT    NOV    DEC     WIN    SPR    SUM    AUT     ANN"
    var headingIndexes = [Int]()
    var keys = [String]()
    
    func findHeadingIndexes(){
        let headingArray = headingString.components(separatedBy: "    ").map{  $0.replacingOccurrences(of: " ", with: "") }
        keys = Array(headingArray[1..<headingArray.count])
        for headingdata in headingArray{
            if let range = headingString.range(of: headingdata) {
                let startPos = headingString.distance(from: headingString.startIndex, to: range.lowerBound)
                headingIndexes.append(startPos)
            }
        }
    }
    
    func emptyFieldCheck(string : inout String ) -> Void{
        
        for index in headingIndexes{
            if index > string.count {
                string = string + "   ---"
            }
            else
            {
                let lowerBound = String.Index(encodedOffset: index)
                let upperBound = String.Index(encodedOffset: index + 3)
                let data = string[lowerBound..<upperBound]
                if data == "   " {
                    let range: Range = lowerBound..<upperBound
                    string.replaceSubrange(range, with: "---")
                }
            }
        }
    }
    
    

    func parseData(data : String , keys:[String])
    {
        
        let datalines = data.components(separatedBy: .newlines).filter { $0 != ""
        }

        
        /*--finding country and wheather--*/
        let firstLine = datalines[0].components(separatedBy:" ").map{  $0.replacingOccurrences(of: " ", with: "") }.filter{$0 != ""}
        let country = firstLine[0]
        let wheather : String = ["Minimum Temperature","Rainfall","Sunshine","Mean Temperature","Maximum Temperature"].filter({(item: String) -> Bool in
            if item.lowercased().range(of: firstLine[1].lowercased()) != nil {
                return true
            }
            return false
        })[0]
        
        
        /*---fing the index of Heading-*/
        guard let headingIndex =  datalines.index(of: headingString) else {
            print("Header didnot Found")
            return
        }
        
        var lines = Array(datalines[(headingIndex+1)..<datalines.count])
        print("\(index)")
        
        let coreFuncs = CoreFunctionalities()
        for i in lines.startIndex..<lines.endIndex {
            emptyFieldCheck(string: &lines[i])
            let values = lines[i].components(separatedBy:"  ").map{  $0.replacingOccurrences(of: " ", with: "") }.filter{$0 != ""}.map{ $0 == "---" ? "N/A" : $0 }
            let year = values[0]
            DispatchQueue.main.async{
                let keyValues =  coreFuncs.addKeyValues(year: year, keys: keys, values: Array(values[1..<values.count]))
                coreFuncs.addWheatherStatistics(country: country, wheather: wheather, values: keyValues)
                ad.saveContext()
            }
        }
    }
    
    
    
}


