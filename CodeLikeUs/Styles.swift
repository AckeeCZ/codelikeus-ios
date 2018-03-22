import UIKit

extension UILabel {
    func makeDescription() {
        makeSmall()
        textColor = .black
    }
    func makeSmall() {
        font = UIFont.systemFont(ofSize: 13)
    }
}
extension UITextField {
    func makeDefault() {
        makeRounded()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height:0))
        leftViewMode = .always
        font = .systemFont(ofSize: 30)
    }
}
extension UIView {
    func makeRounded(radius: CGFloat = 4.0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}


