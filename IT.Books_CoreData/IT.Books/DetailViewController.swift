
import UIKit
import CoreData

class DetailViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var book: BookDetail!
    var descriptionText = ""
    var eName: String = String()
    var bookId = "0"
    var imageName = ""
    var bookPrice = "0.0"
    var savedBook = false
    var date = Date()
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    
    var segue = ""
    
    var managedObjectContext: NSManagedObjectContext!
    let coreDataStack = CoreDataSaver()
    
    let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    @IBOutlet weak var addToFavourite: UIButton!
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        let favBook = FavouriteBook(context: managedObjectContext)
        favBook.title = book.title
        favBook.subtitle = book.subtitle
        favBook.isbn13 = book.isbn13
        favBook.price = book.price
        favBook.image = book.image
        favBook.url = book.url
        coreDataStack.saveContext()
        addToFavourite.setImage(UIImage(named: "filledStar"), for: .normal) 
    }
    
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = coreDataStack.managedObjectContext
        
        let url = makeURL(searchId: bookId)
        Network.fetchDetail(url: url) { detail in
            self.book = detail
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        if segue == "SeeTheBook" {
            addToFavourite.isHidden = true
        }
        
      //  tableView.separatorStyle = .none
        descriptionLabel.isHidden = true
        view.tintColor = UIColor(red: 114/255, green: 216/255, blue: 255/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    // Make URL
    func makeURL(searchId: String) -> URL {
        let urlString = String(format: "https://api.itbook.store/1.0/books/\(searchId)")
        let url = URL(string: urlString)
        return url!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    func updateUI() {
        bookNameLabel.text = book.title
        authorNameLabel.text = book.subtitle
        if book.desc != nil {
            descriptionLabel.isHidden = false
            descriptionTextField.text = book.desc!
        }
        if book.price != nil {
            priceLabel.text = book.price!
        }
        if let largeURL = book.image, let url = URL(string: largeURL) {
            downloadTask = artworkImageView.loadImage(url: url)
        }
    }
    
    deinit {
        downloadTask?.cancel()
    }
    
    func removeTags() {
        descriptionText = descriptionText.deleteTags(tag: descriptionText)
    }

}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController)  -> UIPresentationController? {
        return DimmingPresentationController(
            presentedViewController: presented, presenting: presenting)
    }
    
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension String {
    func deleteTags(tag: String) -> String {
        var textWithoutTags = ""
        textWithoutTags = self.replacingOccurrences(of: "<br /><br />", with: "\n\n", options: .regularExpression, range: nil)
        textWithoutTags = textWithoutTags.replacingOccurrences(of: "<i>", with: "", options: .regularExpression, range: nil)
        textWithoutTags = textWithoutTags.replacingOccurrences(of: "</i>", with: "", options: .regularExpression, range: nil)
        return textWithoutTags
    }

}
