//
//  RecruiterPastExperience.swift
//  Voluny
//


import Foundation

class RecruiterPastExperience{
    private var _title: String
    private var _date: String
    private var _time: String
    private var _imageURL: String
    private var _expID: String
    private var _accepted: String
    
    var title: String{
        return _title
    }
    
    var date: String{
        return _date
    }
    
    var time: String{
        return _time
    }
    
    var accepted: String{
        return _accepted
    }
    

    
    var imageURL: String{
        return _imageURL
    }
    
    var expID: String{
        return _expID
    }
    
    init(title: String, date: String, time: String, imageURL: String, expID: String, accepted: String) {
        self._title = title
        self._date = date
        self._time = time
        self._imageURL = imageURL
        self._expID = expID
        self._accepted = accepted
    }
    
}
