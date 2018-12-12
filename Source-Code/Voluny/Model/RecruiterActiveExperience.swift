//
//  RecruiterActiveExperience.swift
//  Voluny
//


import Foundation

class RecruiterActiveExperience{
    private var _title: String
    private var _date: String
    private var _time: String
    private var _accepted: String
    private var _pending: String
    private var _imageURL: String
    private var _expID: String
    private var _bannerPhotoURL: String
    private var _organisation: String
    private var _rating: Double
    private var _age: String
    private var _location: String
    private var _category: String
    private var _city: String
    private var _description: String
    
    var city: String{
        return _city
    }
    
    var description: String{
        return _description
    }
    
    var category: String{
        return _category
    }
    
    var bannerPhotoURL: String{
        return _bannerPhotoURL
    }
    
    var organisation: String{
        return _organisation
    }
    
    var rating: Double{
        return _rating
    }
    
    var age: String{
        return _age
    }
    
    var location: String{
        return _location
    }
    
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
    
    var pending: String{
        return _pending
    }
    
    var imageURL: String{
        return _imageURL
    }
    
    var expID: String{
        return _expID
    }
    
    init(title: String, date: String, time: String, accepted: String, pending: String, imageURL: String, expID: String, organisation: String, bannerURL: String, rating: Double, age: String, location: String, category: String, city: String, description: String) {
        self._title = title
        self._date = date
        self._time = time
        self._accepted = accepted
        self._pending = pending
        self._imageURL = imageURL
        self._expID = expID
        self._organisation = organisation
        self._bannerPhotoURL = bannerURL
        self._rating = rating
        self._age = age
        self._location = location
        self._category = category
        self._city = city
        self._description = description
    }
    
    
}
