using CoreGraphics;
using Foundation;
using UIKit;
using WebKit;
using Microsoft.Maui;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Platform;
using BrowserFramework;
using System.Timers;
using MAUIProject.Platforms.iOS;

namespace MAUIProject;

[Register("AppDelegate")]
public class AppDelegate : MauiUIApplicationDelegate
{
    protected override MauiApp CreateMauiApp() => MauiProgram.CreateMauiApp();


    public override bool FinishedLaunching(UIApplication application, NSDictionary launchOptions)
    {
        _ = base.FinishedLaunching(application, launchOptions);

        Window = application.KeyWindow;
        var vc = new MyViewController();
        var nav = new UINavigationController(vc);
        Window.RootViewController = nav;
        Window.MakeKeyAndVisible();


        return true;
    }

    public class MyViewController : UIViewController
    {

        private System.Timers.Timer timer;
        private float count;
        string title = "按钮";

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();

            // 设置视图控制器的背景颜色
            View.BackgroundColor = UIColor.Yellow;

            var frame = new Rect(x: 100, y: 200, width: 30, height: 20);
            var button = new UIButton(frame: frame);
            button.BackgroundColor = UIColor.Red;
            button.TouchUpInside += Button_TouchUpInside;
            View.AddSubview(button);

            timer = new System.Timers.Timer(1000);
            timer.Elapsed += onTimedEvent;

            
        }

        private void OnValueChanged22(NSString value) => title = (string)value;

        private void Button_TouchUpInside(object sender, EventArgs e)
        {
            //var sec = new UIViewController();
            //sec.View.BackgroundColor = UIColor.White;
            //string str = "Hello World!";
            //byte[] bytes = System.Text.Encoding.UTF8.GetBytes(str);
            //var data = Foundation.NSData.FromArray(bytes);
            //manager = new DownloadAppManager(data: data, isLoaded: false, isUpdate: false);
            //var swiftView = manager.DownloadView;
            //swiftView.Frame = sec.View.Bounds;
            //sec.View.AddSubview(swiftView);


            //manager.ClickDownloadActionWithCallback((dict) =>
            //{
            //    Console.WriteLine(dict);
            //    timer.Start();
            //});

            var sec = new FirstViewController();
            this.NavigationController.PushViewController(sec, true);


        }

        private void onTimedEvent(object sender, ElapsedEventArgs e)
        {
            //count = (float)(count + 0.05);
            //manager.OnListenProgressWithProgress(count);
            //if (count >= 1.0)
            //{
            //    manager.DownloadComplete();
            //}
        }

        private void OnValueChanged(NSString value)
        {
            title = (string)value;
        }

        public void PrintString(NSString input)
        {
            Console.WriteLine(input);
        }

    }
}
    

