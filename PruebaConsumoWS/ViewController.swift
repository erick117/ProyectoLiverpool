//
//  ViewController.swift
//  PruebaConsumoWS
//
//  Created by Erick Alberto Garcia Marquez on 28/08/18.
//  Copyright © 2018 Erick Alberto Garcia Marquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var busquedasAnteriores = [String]()
    var seMostraronBusquedas = false
    var searchController : UISearchController!
    var task : URLSessionDataTask?
    var listado : [Attributes] = [Attributes]()
    var tableViewText : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(seMostraronBusquedas){
            return busquedasAnteriores.count
        }
        
        return listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(seMostraronBusquedas) {
            let celltext = tableView.dequeueReusableCell(withIdentifier: "CellText", for: indexPath)
            let texto = busquedasAnteriores[indexPath.row]
            celltext.textLabel?.text = texto
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.autoCompletar))
            celltext.addGestureRecognizer(gesture)
            
            return celltext
        }
        else
        {
            let cellItem = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
            
            let pagina : Attributes!
            
                pagina = listado[indexPath.row]
            
            
            guard let titulo = pagina.Title.first  else {
                return ItemTableViewCell()
            }
            
            guard let precio = pagina.Price.first else {
                return ItemTableViewCell()
            }
            
            cellItem.lblTitulo.text = titulo
            cellItem.lblPrecio.text = precio.formatoDePrecio()
            
            //Descarga Asincrona de la imagen
            DispatchQueue.global().async {
                let indexCell = indexPath

                print(pagina.smallImage.first!)
                if let urlImg = pagina.smallImage.first {
                    if let url = URL(string: urlImg) {
                        var imageCargada = UIImage()
                        do {
                            let datosImg = try Data(contentsOf: url)
                            imageCargada  =  UIImage(data: datosImg)!
                        }
                        catch {
                            
                        }
                        DispatchQueue.main.async {
                            if let cell = tableView.cellForRow(at: indexCell)  {
                                (cell as! ItemTableViewCell).imgView.image = imageCargada
                            }
                        }
                    }
                }
            }
            return cellItem
        }
    }
    
  
    
    func consultarDatosDe(textoABuscar:String) {
        activityIndicator.startAnimating()
        
        if( task != nil)
        {
          task?.cancel()
        }
        
        self.listado.removeAll()
        let stringUrl = "https://www.liverpool.com.mx/tienda/?s=\(textoABuscar)&d3106047a194921c01969dfdec083925=json"
        let urlEncoding = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: urlEncoding!)!
         task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let datos = data {
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(DatosPrincipal.self, from: datos)
                    
                    guard let contentMain = json.contents.first else  {
                        return
                    }
                    guard let contents =  contentMain.mainContent.last else {
                        return
                    }
                    guard let contentsInternal = contents.contents else {
                        return
                    }
                    guard let contenInternal = contentsInternal.first else {
                        return
                    }
                    guard let records = contenInternal.records else {
                        return
                    }
                    
                    self.listado = records.map{$0.attributes}
                    DispatchQueue.main.async
                    {
                       self.activityIndicator.stopAnimating()
                       self.tableView.reloadData()
                    }
                }
                catch (let error) {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        task?.resume()
        
        
    }
    
    
    @objc func autoCompletar(gesture : UITapGestureRecognizer)  {
        if( gesture.state == UIGestureRecognizerState.ended) {
            print("Autocompletar")
            let tapLocation = gesture.location(in: self.tableViewText)
            if let tapIndexPath = self.tableViewText.indexPathForRow(at: tapLocation) {
                if let cell = self.tableViewText.cellForRow(at: tapIndexPath) {
                    let text = cell.textLabel?.text
                    self.searchController.searchBar.text = text
                    consultarDatosDe(textoABuscar: text!)
                 
                    if let viewTag = self.view.viewWithTag(100)
                    {
                        (viewTag as! UITableView).delegate = nil
                        viewTag.removeFromSuperview()
                    }

                    
                    seMostraronBusquedas = false
                    searchController.searchBar.endEditing(true)
                    searchController.searchBar.resignFirstResponder()
                }
            }
        }
    }

}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
        if let viewTag = self.view.viewWithTag(100)
        {
            (viewTag as! UITableView).delegate = nil
            viewTag.removeFromSuperview()
        }
        seMostraronBusquedas = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            consultarDatosDe(textoABuscar: text)
            
            if(!busquedasAnteriores.contains(text)) {
                busquedasAnteriores.append(text)
                UserDefaults.standard.set(busquedasAnteriores, forKey: "BusquedasUsuario")
                if let viewTag = self.view.viewWithTag(100)
                {
                    (viewTag as! UITableView).delegate = nil
                    viewTag.removeFromSuperview()
                }
            }
        }
        seMostraronBusquedas = false
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(!seMostraronBusquedas) {
            
            if let arrayBusquedas =   UserDefaults.standard.array(forKey: "BusquedasUsuario") {
                busquedasAnteriores = arrayBusquedas as! [String]
                seMostraronBusquedas = true
            }
            
            tableViewText.frame = self.tableView.frame
            tableViewText.tag = 100
            tableViewText.delegate = self
            tableViewText.dataSource = self
            tableViewText.register(UITableViewCell.self, forCellReuseIdentifier: "CellText")
            self.view.addSubview(tableViewText)
            tableViewText.reloadData()
        }
    }
}





