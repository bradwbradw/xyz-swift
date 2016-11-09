//
//  TableViewController.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/1/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit

class SpaceTableViewController: UITableViewController {

    var spaces:[AnyObject] = []
    
    var newSpace:Space?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let spaceView = segue.destination as? DotViewController {
            spaceView.space = self.newSpace
            
        }
        
    }
    
    func loadSpaces(){
        let filter:String = "{\"where\":{\"public\":true},\"include\":[\"songs\"]}"
        let spaceApiUrl:String = "https://xyz.gs/api/spaces?filter="+filter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlObj: URL = URL(string: spaceApiUrl)!
        let urlRequest: URLRequest = URLRequest(url: urlObj as URL)
        print("the url is....");
        print(urlObj);
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("spaces downloaded successfully.")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                    func processData(arr: [AnyObject]){
                        self.spaces = [];
                        for space in arr {
                                print("found a space: \(space["name"]) ")
                                self.spaces.append(space);
                        }
                    }
                    var results:[AnyObject] = [];
                    if let spacesFromJson = json as [AnyObject]? {
                        results += spacesFromJson
                    }
                    processData(arr: results)
                    self.tableView.reloadData();
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSpaces();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath ) {
        //CODE TO BE RUN ON CELL TOUCH
        print(spaces[indexPath.row]["name"]! ?? "no spaces loaded");
        
        guard let name = spaces[indexPath.row]["name"] as? String else {
            print("could not get space name")
            return
        }
        self.newSpace =  Space(name: name)
        self.performSegue(withIdentifier: "goToSpace", sender: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spaces.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = spaces[indexPath.row]["name"] as? String
        // Configure the cell...

        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
