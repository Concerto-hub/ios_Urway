//
//  ReceptViewController.swift
//  UrwayDemoApp
//

import UIKit
import Urway

protocol IReceptViewController: class {
	var router: IReceptRouter? { get set }
}

class ReceptViewController: UIViewController {
	var interactor: IReceptInteractor?
	var router: IReceptRouter?

    var model: PaymentResultData? = nil
    
    var dict: [String: String] = [:]
    
    @IBOutlet var receptTableview: UITableView!
    
    var titles: [String] = ["Amount" , "PaymentID" , "Response" , "Transaction ID"  , "RESULT" , "Token Code"]
    
    var values: [String] = []
    
	override func viewDidLoad() {
        super.viewDidLoad()
		// do someting...
        
        self.title = "RECEPT"
        
    
        
        values.append(model?.amount ?? "nil")
        values.append(model?.paymentID ?? "nil")
        values.append(model?.responceCode ?? "nil")
        values.append(model?.transID ?? "nil")
        values.append(model?.result ?? "nil")
        values.append(model?.tockenID ?? "")
        
        
        receptTableview.register(UINib(nibName: "ReceptCell", bundle: nil), forCellReuseIdentifier: "ReceptCell")
        receptTableview.dataSource = self
        receptTableview.delegate = self
        receptTableview.reloadData()
    }
}

extension ReceptViewController: IReceptViewController {
	// do someting...
}

extension ReceptViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptCell") as! ReceptCell
        let key = titles[indexPath.row]
        let value = values[indexPath.row]
        cell.setTitle(title: "\(key)  :  \(value)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReceptViewController {
	// do someting...
}
