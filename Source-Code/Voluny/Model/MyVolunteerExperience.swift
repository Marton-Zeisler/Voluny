//
//  MyVolunteerExperience.swift
//  Voluny
//


import Foundation

class MyVolunteerExperience{
    private var _title: String
    private var _location: String
    private var _date: String
    private var _time: String
    private var _expID: String
    private var _recruiterID: String
    
    var recruiterID : String{
        return _recruiterID
    }
    
    var title: String{
        return _title
    }
    
    var location: String{
        return _location
    }
    
    var date: String{
        return _date
    }
    
    var time: String{
        return _time
    }
    
    var expID: String{
        return _expID
    }
    
    init(title: String, location: String, date: String, time: String, expID: String, recruiterID: String){
        self._title = title
        self._location = location
        self._date = date
        self._time = time
        self._expID = expID
        self._recruiterID = recruiterID
    }
    
}
