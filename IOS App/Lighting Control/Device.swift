//
//  Device.swift
//  Lighting Control
//
//  Created by Toan Nguyen Dinh on 12/8/16.
//  Copyright © 2016 tabvn. All rights reserved.
//

import UIKit


import FirebaseDatabase

class Device: NSObject{
    
    var id: String = ""
    var chipId: String = ""
    var title: String = ""
    var state: Bool = false
   
    override func setValue(_ value: Any?, forKey key: String) {
        
        if(key == "state"){
            
            var defaultState: Bool = true;
            
            if let sValue: Bool = value as! Bool?{
                
                if sValue == false{
                    
                   defaultState = false
                }
            }
            
            self.setValue(defaultState, forKey: "state")
        }else{
            
            self.setValue(value, forKey: key)
        }
    }
    
    func updateState(){
    
    
        let ref = FIRDatabase.database().reference()
        //123/states/001 = true
        ref.child("\(self.chipId)/states/\(self.id)").setValue(state)
    
    
    }
    
}
