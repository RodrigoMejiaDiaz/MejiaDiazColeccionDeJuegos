//
//  ViewController.swift
//  MejiaDiazColeccionDeJuegos
//
//  Created by MacBook Pro on 17/05/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var juegos: [Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
            
        let editButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.leftBarButtonItem = editButton
    }
    
    @objc func editButtonTapped(){
        if tableView.isEditing {
            tableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Editar"
        } else {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Hecho"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.detailTextLabel?.text = juego.categoria
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegosSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = juegos[sourceIndexPath.row]
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(movedObject, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }

    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Obtén el objeto a eliminar de CoreData según el indexPath.row
            let juego = juegos[indexPath.row]
            
            // Elimina el objeto del contexto
            context.delete(juego)
            
            do {
                // Guarda los cambios en el contexto
                try context.save()
                
                // Elimina la fila de la tabla
                juegos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                // Maneja cualquier error al guardar el contexto
                print("Error al guardar el contexto: \(error)")
            }
        }
    }
}

