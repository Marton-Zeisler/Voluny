//
//  Notification.swift
//  Voluny
//


import Foundation

class ExperienceNotification{
    private var _status: String
    private var _date: String
    private var _title: String
    private var _expID: String
    private var _nsDate: Date
    
    var nsDate: Date{
        return _nsDate
    }
    
    var status: String {
        return _status
    }
    
    var date: String{
        return _date
    }
    
    var title: String{
        return _title
    }
    
    var expID: String{
        return _expID
    }
    
    init(status: String, date: String, title: String, expID: String, nsDate: Date) {
        self._status = status
        self._date = date
        self._title = title
        self._expID = expID
        self._nsDate = nsDate
    }
    
}

