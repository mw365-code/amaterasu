from tkinter import Tk
from config import WIDTH, HEIGHT
from controllers.navigation_controller import NavigationController
from models.app_state import AppState

def main():
    root = Tk()
    root.title("Travel Phrase App")
    root.geometry(f"{WIDTH}x{HEIGHT}")
    root.resizable(False, False)

    state = AppState()
    controller = NavigationController(root, state)
    controller.show("home")

    root.mainloop()

if __name__ == "__main__":
    main()