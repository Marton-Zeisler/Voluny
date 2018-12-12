//
//  Experience.swift
//  Voluny
//


import Foundation

class Experience{
    
    private var _city: String
    private var _location: String
    private var _title: String
    private var _rating: Double
    private var _shortDescription: String
    private var _longDescription: String
    private var _date: String
    private var _preciseLocation: String
    private var _category: String
    private var _ageGroup: String
    private var _iconPhoto: String
    private var _bannerPhoto: String
    private var _id: String
    private var _time: String
    private var _recruiter: String
    
    var recruiter: String{
        return _recruiter
    }
    
    var city: String{
        return _city
    }
    
    var location: String{
        return _location
    }
    
    var title: String{
        return _title
    }
    
    var rating: Double{
        return _rating
    }
    
    var shortDescription: String{
        return _shortDescription
    }
    
    var longDescription: String{
        return _longDescription
    }
    
    var date: String{
        return _date
    }
    
    var preciseLocation: String{
        return _preciseLocation
    }
    
    var category: String{
        return _category
    }
    
    var ageGroup: String{
        return _ageGroup
    }
    
    var iconPhoto: String{
        return _iconPhoto
    }
    
    var bannerPhoto: String{
        return _bannerPhoto
    }
    
    var id: String{
        return _id
    }
    
    var time: String{
        return _time
    }

    init(city: String, location: String, title: String, rating: Double, shortDescription: String, longDescription: String, date: String, preciseLocation: String, category: String, ageGroup: String, iconPhoto: String, bannerPhoto: String, id: String, time: String, recruiter: String) {
        self._city = city
        self._location = location
        self._title = title
        self._rating = rating
        self._shortDescription = shortDescription
        self._longDescription = longDescription
        self._date = date
        self._preciseLocation = preciseLocation
        self._category = category
        self._ageGroup = ageGroup
        self._iconPhoto = iconPhoto
        self._bannerPhoto = bannerPhoto
        self._id = id
        self._time = time
        self._recruiter = recruiter
    }
    
    
    
    
}
