
import UIKit
import CoreData

class FavouriteViewController: UIViewController {
        
    var managedObjectContext: NSManagedObjectContext!
    let coreDataStack = CoreDataSaver()

    var books = [FavouriteBook]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = coreDataStack.managedObjectContext
        
        fetchBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBooks()
    }
    
    func fetchBooks() {
        do {
            self.books = try managedObjectContext.fetch(FavouriteBook.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeTheBook" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let book = books[indexPath.row]
            detailViewController.bookId = book.isbn13 ?? ""
            detailViewController.segue = "SeeTheBook"
            
        }
    }
    
   
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let book = books[indexPath.row]
        
        cell.textLabel?.text = book.title
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "SeeTheBook", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath
        
    }
}
