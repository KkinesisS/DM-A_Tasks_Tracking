using System;
using System.Windows.Forms;
using System.Threading;

class Program {
    [STAThread]
    static void Main() {
        var wb = new WebBrowser();
        wb.ScriptErrorsSuppressed = false;
        
        wb.DocumentCompleted += (s, e) => {
            Console.WriteLine("Loaded.");
            Application.Exit();
        };

        var path = "file:///" + System.IO.Path.GetFullPath("index.html").Replace("\\", "/");
        wb.Navigate(path);

        // Run message loop for up to 5 seconds
        DateTime start = DateTime.Now;
        while (wb.ReadyState != WebBrowserReadyState.Complete && (DateTime.Now - start).TotalSeconds < 5) {
            Application.DoEvents();
            Thread.Sleep(10);
        }
    }
}