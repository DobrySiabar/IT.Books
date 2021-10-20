
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var books: [Book] = []
    var bookTitle = ""
    var bookAuthor = ""
    var imageUrl = ""
    var smallImageUrl = ""
    var bookRating = 0.0
    var id = 0
    var imageName = ""
    
    var eName = ""
    var hasSearched = false
    var isLoading = false
    
    var resultsEnd = 0
    var totalResults = 200
    var currentResult = 0
    var pageNumber = 1
    var lastPage = true
    var titleId = false
    var searchedText = ""
    
    var dataTask: URLSessionDataTask?
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Register new cells
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        tableView.rowHeight = 80
        tableView.reloadData()
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for a book"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let book = books[indexPath.row]
            detailViewController.bookId = book.isbn13 ?? ""
            detailViewController.segue = "ShowDetail"
        }
    }
    
    // Make URL
    func makeURL(searchText: String, pageNumber: Int) -> URL {
        let escapedSearchText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      //  let urlString = String(format: "https://www.goodreads.com/search/index.xml?page=%@&key=l4kB49iPjOOqVecSReNA&q=%@", String(pageNumber), escapedSearchText)
        let urlString = String(format: "https://api.itbook.store/1.0/search/\(escapedSearchText)")
        let url = URL(string: urlString)
        return url!
    }
    
    
    // Start parsing
    func parsing(withText text: String) {
        dataTask?.cancel()
        isLoading = true
        hasSearched = true
        searchedText = text
        let url = makeURL(searchText: text, pageNumber: pageNumber)
        Network.fetchFile(url: url) { [unowned self] file in
            self.books = file.books
            self.totalResults = self.books.count
            DispatchQueue.main.async {
                self.hasSearched = false
                self.isLoading = false
                self.tableView.reloadData()
                if (self.totalResults == 0) {
                    return
                }
                if !(self.resultsEnd == self.totalResults) {
                    self.pageNumber += 1
                    self.isLoading = false
                    self.lastPage = false
                } else {
                    self.lastPage = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func performInserting() {
        let indexPaths = (0 ..< books.count).map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .none)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        books = []
        pageNumber = 1
        let text = searchBar.text!
        parsing(withText: text)
        tableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalResults == 0 {
            return 1
        } else if !lastPage {
            return books.count + 1
        } else if isLoading {
            return 1
        } else {
            return books.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allRows = tableView.numberOfRows(inSection: 0)
        let indexes = (0 ..< allRows).map { $0 }
        if totalResults == 0 {
            print("totalResults == 0")
            let cell = tableView.dequeueReusableCell(withIdentifier:
                TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            return cell
        } else
        if isLoading {
            print("isLoading")
            let cell = tableView.dequeueReusableCell(withIdentifier:
                TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if (!isLoading || indexes.contains(books.count)), (books.count != indexPath.row) {
            print("!isLoading || indexes.contains(books.count)")
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell,
                for: indexPath) as! SearchResultCell
            let book = books[indexPath.row]
            cell.configure(for: book)
            return cell
        } else {
            print("else")
            let cell = tableView.dequeueReusableCell(withIdentifier:
                TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            return cell
        }
    }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if books.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
}
