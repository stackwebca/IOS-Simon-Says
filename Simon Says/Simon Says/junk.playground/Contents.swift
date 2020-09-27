import UIKit

var btnPresses 0

func showChallenge () {
    
    switch (newChallenge.count > 0) {
    case 1 == 1:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            print("num1 show")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            print("num1 hide")
            btnPresses - 1
        }
        break;
    case 2 == 2:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            print("num2 show")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            print("num2 hide")
        }
        break;
    case 3 == 3:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            print("num3 show")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            print("num3 hide")
        }
        break;
    case 4 == 4:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            print("num4 show")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            print("num4 hide")
        }
        break;
    default:
        break;
    }    
}
