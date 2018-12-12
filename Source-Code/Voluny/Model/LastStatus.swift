//
//  LastStatus.swift
//  Voluny
//


import Foundation

class LastStatus{
    private var _title: String
    private var _status: String
    
    var title: String{
        return _title
    }
    
    var status: String{
        return _status
    }
    
    init(title: String, status: String) {
        self._title = title
        self._status = status
    }
    
    
}
