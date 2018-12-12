//
//  NoCityFoundView.swift
//  Voluny
//


import UIKit

class NoCityFoundView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var cities = [String]()
    
    var noCityFoundProtocol: NoCityFoundProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("NoCityFoundView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorInset = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: -30)
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "NoCityFoundCell", bundle: nil), forCellReuseIdentifier: "NoCityFoundCell")
    }
    
    
    
    func loadData(data: [String]){
        cities = data
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoCityFoundCell", for: indexPath) as! NoCityFoundCell
        cell.cityLabel.text = cities[indexPath.row]
        
        if (cell.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        if (cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if (cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        noCityFoundProtocol?.didReceiveCity(city: cities[indexPath.row])
    }
    
    
}

protocol NoCityFoundProtocol{
    func didReceiveCity(city: String)
}
