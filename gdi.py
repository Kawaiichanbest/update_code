import ctypes
from ctypes import wintypes

# Constants for GDI functions
SWP_NOSIZE = 0x0001
SWP_NOMOVE = 0x0002
SWP_NOZORDER = 0x0004
SWP_FRAMECHANGED = 0x0020
SWP_SHOWWINDOW = 0x0040

# Constants for SetWindowLong and GetWindowLong
GWL_EXSTYLE = -20
WS_EX_LAYERED = 0x80000
LWA_COLORKEY = 0x00000001
LWA_ALPHA = 0x00000002

# Constants for CreateSolidBrush and FillRect
COLOR_RED = 0xFF0000

class RECT(ctypes.Structure):
    _fields_ = [("left", wintypes.LONG),
                ("top", wintypes.LONG),
                ("right", wintypes.LONG),
                ("bottom", wintypes.LONG)]

def create_window():
    # Register the window class
    class_name = "GDIVisualEffect"
    wnd_class = wintypes.WNDCLASS()
    hinst = wnd_class.hInstance = ctypes.windll.kernel32.GetModuleHandleW(None)
    wnd_class.lpszClassName = class_name
    wnd_class.style = ctypes.windll.user32.CS_VREDRAW | ctypes.windll.user32.CS_HREDRAW
    wnd_class.hCursor = ctypes.windll.user32.LoadCursorW(0, 32512)  # IDC_ARROW
    ctypes.windll.user32.RegisterClassW(ctypes.byref(wnd_class))

    # Create the window
    hwnd = ctypes.windll.user32.CreateWindowExW(
        0, class_name, "GDI Visual Effect", 0,
        0, 0, 400, 300,
        0, 0, hinst, 0
    )

    # Make the window transparent and click-through
    set_window_transparent(hwnd)
    set_window_click_through(hwnd)

    # Show and update the window
    ctypes.windll.user32.ShowWindow(hwnd, 1)
    ctypes.windll.user32.UpdateWindow(hwnd)

    # Run the message loop
    msg = wintypes.MSG()
    while ctypes.windll.user32.GetMessageW(ctypes.byref(msg), 0, 0, 0) != 0:
        ctypes.windll.user32.TranslateMessage(ctypes.byref(msg))
        ctypes.windll.user32.DispatchMessageW(ctypes.byref(msg))

def set_window_transparent(hwnd):
    # Enable the window layering style
    ex_style = ctypes.windll.user32.GetWindowLongW(hwnd, GWL_EXSTYLE)
    ctypes.windll.user32.SetWindowLongW(hwnd, GWL_EXSTYLE, ex_style | WS_EX_LAYERED)

    # Make the window transparent
    ctypes.windll.user32.SetLayeredWindowAttributes(hwnd, COLOR_RED, 0, LWA_COLORKEY)

def set_window_click_through(hwnd):
    # Make the window click-through
    ex_style = ctypes.windll.user32.GetWindowLongW(hwnd, GWL_EXSTYLE)
    ctypes.windll.user32.SetWindowLongW(hwnd, GWL_EXSTYLE, ex_style | 0x80000)  # WS_EX_LAYERED

def draw_visual_effect(hwnd):
    hdc = ctypes.windll.user32.GetDC(hwnd)

    rect = RECT()
    ctypes.windll.user32.GetClientRect(hwnd, ctypes.byref(rect))

    brush = ctypes.windll.gdi32.CreateSolidBrush(COLOR_RED)
    ctypes.windll.gdi32.FillRect(hdc, ctypes.byref(rect), brush)

    ctypes.windll.gdi32.DeleteObject(brush)
    ctypes.windll.user32.ReleaseDC(hwnd, hdc)

if __name__ == "__main__":
    create_window()