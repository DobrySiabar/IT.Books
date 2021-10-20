
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 114/255, green: 216/255,
                                               blue: 255/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(for searchResult: Book) {
        
        bookNameLabel.text = searchResult.title
        authorNameLabel.text = searchResult.subtitle
        artworkImageView.image = UIImage()
        
        artworkImageView.image = UIImage(named: "Placeholder")
        if let smallURL = searchResult.image, let url = URL(string: smallURL) {
            downloadTask = artworkImageView.loadImage(url: url)
        }
        
    }
    
//    func configure(for searchResult: Book) {
//        bookNameLabel.text = searchResult.title
//
//        if let searchResult = searchResult.author {
//            authorNameLabel.text = String(format: "%@", searchResult)
//        } else {
//            authorNameLabel.text = "Unknown"
//        }
//        if let imageName = searchResult.imageName {
//            let filePath = applicationDocumentsDirectory.appendingPathComponent("\(imageName).jpg").path
//            if FileManager.default.fileExists(atPath: filePath) {
//                artworkImageView.image =  UIImage(contentsOfFile: filePath)
//            }
//        }
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
  
}
