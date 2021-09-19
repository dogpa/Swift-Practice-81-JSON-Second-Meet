//
//  ViewController.swift
//  Swift Practice # 81 JSON Second Meet
//
//  Created by Dogpa's MBAir M1 on 2021/9/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    @IBOutlet weak var singerSearchBar: UISearchBar!
    
    @IBOutlet weak var singerInfoTableView: UITableView!
    var singerDataFromASA = [SingerDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()
        singerInfoTableView.delegate = self
        singerInfoTableView.dataSource = self
        singerSearchBar.isFirstResponder
        self.hideKeyboardWhenTappedAround()
    }
    
    //自定義func取得JSON資料
    func getDetailsFromASA () {
        
        let searchIndex = (singerSearchBar.text ?? "")
        let searchAPI = "https://itunes.apple.com/search?term=\(searchIndex)&media=music"
        
        if let urlString = searchAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            if let JSONUrl = URL(string: urlString){
                
                URLSession.shared.dataTask(with: JSONUrl) { data, response, error in
                    //指派data為DATA類別
                    if let date = data {
                        
                        let decoder = JSONDecoder()
                        
                        decoder.dateDecodingStrategy = .iso8601

                        do {
                            let searchResponse = try decoder.decode(SearchResponse.self, from: date)
                            self.singerDataFromASA = searchResponse.results
                            
                            DispatchQueue.main.async {
                                self.singerInfoTableView.reloadData()
                            }
                            
                        }catch{
                            //若無法do或是失敗列印失敗原因
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    
    
    
    
    @IBAction func searchSingerInfo(_ sender: UIButton) {
        
        getDetailsFromASA()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //row的數量透過singerDataFromASA透過JSON抓到的網路數量來指派
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return singerDataFromASA.count
    }

    //TableView顯示內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //指派Cell為轉型SingerNameAndPhotoTableViewCell內的"singerDetailsCell"這個Table View
        let cell = tableView.dequeueReusableCell(withIdentifier: "singerInfo", for: indexPath) as! SingerDetailsTableViewCell
        //指派item為自定義的 singerDataFromASA[indexPath.row]（取得每一列）
        let item = singerDataFromASA[indexPath.row]
        
        //歌手Label與歌名Label的字串指派為artistName與trackName
        cell.singerNameLabl.text = item.artistName
        cell.songNameLabel.text = item.trackName
        
        //因為照片是URL格式，所以在Table再次執行從網路上抓資料取得照片後再指派給songAlbumImageView
        URLSession.shared.dataTask(with: item.artworkUrl100) { data, response , error in
        if let data = data {
            DispatchQueue.main.async {
                cell.albumImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        //回傳cell
        return cell
        
    }
    
    
}



