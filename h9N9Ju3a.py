import commctrl as cc
import win32gui as wgui
import random

search_criteria=(
 (0, "Progman", None),
        (0, "SHELLDLL_DefView", None),
        (0, "SysListView32", None),

    )

wnd = 0
for crit in search_criteria:
    wnd = wgui.FindWindowEx(wnd,*crit)
icon=int(wgui.SendMessage(wnd, cc.LVM_GETITEMCOUNT))
while True:
    

    random_module = (random.randint(0,1000) << 16) | random.randint(0,1000)
    wgui.SendMessage(wnd,cc.LVM_SETITEMPOSITION,random.randint(0,icon),random_module)
    










    
    
