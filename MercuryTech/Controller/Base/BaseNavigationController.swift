
import UIKit


class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        addPanGesture(viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            return NavigationPopTransition()
        }else{
            return nil
        }
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: NavigationPopTransition.self) {
            return interactivePopTransition
        }else{
            return nil
        }
    }
    
    private func addPanGesture(_ viewController: UIViewController){
        let popRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer:)))
        viewController.view.addGestureRecognizer(popRecognizer)
    }
    
    @objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer){
        var progress = recognizer.translation(in: self.view).x / self.view.bounds.size.width
        progress = min(1, max(0, progress))
        print(progress)
        if recognizer.state == .began {
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.popViewController(animated: true)
        }else if recognizer.state == .changed {
            interactivePopTransition.update(progress)
        }else if recognizer.state == .ended || recognizer.state == .cancelled {
            if progress > 0.2 {
                interactivePopTransition.finish()
            }else{
                interactivePopTransition.cancel()
            }
            interactivePopTransition = nil
        }
    }
}
