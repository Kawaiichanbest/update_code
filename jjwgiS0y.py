from tkinter import *
import tkinter as tk
import random

root = tk.Tk()
    
    
root.attributes("-fullscreen", True)
root.overrideredirect(True)
root.wm_attributes("-topmost", True)
root.wm_attributes("-transparentcolor", "white")

root.config(bg='white')


photo = PhotoImage(file = r"C:\Users\anonymous\Desktop\close.png")
while True:
    a=Label(root, image=photo, fg='red', bg='white')
    a.place(x=random.randint(0, 2000), y=random.randint(0, 2000))
    root.update()



l
root.mainloop()
