//
//  RecruiterNotification.swift
//  Voluny
//


import Foundation

class RecruiterNotification{
    private var _title: String
    private var _date: String
    private var _expID: String
    private var _volunteer: String
    private var _nsDate: Date

    
    var nsDate: Date{
        return _nsDate
    }
    
    var volunteer: String{
        return _volunteer
    }

    var expID: String{
        return _expID
    }
    
    var title: String{
        return _title
    }
    
    var date: String{
        return _date
    }
    
    init(title: String, date: String, expID: String, volunteer: String, nsDate: Date) {
        self._title = title
        self._date = date
        self._expID = expID
        self._volunteer = volunteer
        self._nsDate = nsDate
    }
}
