//
//  Test.swift
//  Voluny
//


import UIKit

class ReusableExperienceTableView: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView
    var experiences: [Experience]
    var experienceSearchProtocol: ExperienceSearchProtocol?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        experiences = []
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ExperienceCell", bundle: nil), forCellReuseIdentifier: "ExperienceCell")
    }
    
    func loadData(experiences: [Experience]){
        self.experiences = experiences
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
        cell.configureCell(experience: experiences[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        experienceSearchProtocol?.experienceTapped(experienceID: experiences[indexPath.row].id, indexPath: indexPath)
    }
    

}

protocol ExperienceSearchProtocol{
    func experienceTapped(experienceID: String, indexPath: IndexPath)
}
