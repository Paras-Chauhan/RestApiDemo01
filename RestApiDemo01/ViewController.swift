
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UIImageView!
    
    @IBOutlet weak var SearchTextField: UITextField!
    @IBAction func searchBar(_ sender: UITextField) {
        
    }
   
   
    @IBAction func searchButton(_ sender: UIButton) {
        if SearchTextField.text == ""{
            let addAlertView = UIAlertController(title: "New Prescription", message: "Please enter what you want to search", preferredStyle: UIAlertControllerStyle.alert)
            
            addAlertView.addAction(UIAlertAction(title: "Cancel",
                                                 style: UIAlertActionStyle.default,
                                                 handler: nil))
            
            addAlertView.addAction(UIAlertAction(title: "Save",
                                                 style: UIAlertActionStyle.default,
                                                 handler: nil))
            
            addAlertView.addTextField(configurationHandler: {textField in self.SearchTextField.placeholder = "Title"})
            
            
            self.present(addAlertView, animated: true, completion: nil)
            

        }
        parseData()
        self.mainTableView.reloadData()
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    var fetchCountry = [Country]()
    
   override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        parseData()
       // searchBar()
    }

    
    var name=[String?]()
    var address=[String?]()
    
    
    func parseData()  {
        
        fetchCountry = []
        
        let text = SearchTextField.text!.replacingOccurrences(of: " ", with: "+")
        let url : String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(text)&key=AIzaSyDzILKc-ztA4QsBGDB5_MbfLSBHQ2iCHfI"
       
        var request = URLRequest(url : URL(string:url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration:configuration,delegate : nil,delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print (error!)
            }
            else {
                do{
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    //print (fetchData ?? "")
                    for (attribute,value) in fetchData as! [String:Any] {
                        print(attribute)
                        if attribute == "results" {
                            //let myStruct = FetchedData()
                            let v = value as? [[String:Any]]
                            for array in v! {
                                for (key,val) in array {
                                    if key == "formatted_address" {
                                        self.address.append(val as? String)
                                        print(val)
                                        
                                    }
                                    else if key == "name" {
                                        print(val)
                                        self.name.append(val as? String)
                                        
                                    } }
                                
                            }
                    //self.mainTableView.reloadData()
                }
                    }
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
 
}

class Country {
    var name:String
    var location:String
    
    init(name:String,location:String){
        self.name = name
        self.location = location
    }
}
extension ViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        cell.textLabel?.text = name[indexPath.row]
        
        cell.detailTextLabel?.text = address[indexPath.row]
        
        //MARK:- For shadows on Cells.
        
        cell.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = shadowPath2.cgPath
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

}

