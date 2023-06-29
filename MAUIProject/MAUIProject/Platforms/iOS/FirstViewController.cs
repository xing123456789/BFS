using System;
using System.Timers;
using BrowserFramework;
using CoreGraphics;
using UIKit;
using WebKit;

namespace MAUIProject.Platforms.iOS
{
	public class FirstViewController : UIViewController
	{

        private System.Timers.Timer timer;
        private float count;

        public FirstViewController()
		{
		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();
            //this.NavigationController.NavigationBarHidden = true;
            this.View.BackgroundColor = UIColor.White;
            //string str = "Hello World!";
            //byte[] bytes = System.Text.Encoding.UTF8.GetBytes(str);
            //var data = Foundation.NSData.FromArray(bytes);
            //manager = new DownloadAppManager(data: data, isLoaded: false, isUpdate: false);
            //var swiftView = manager.DownloadView;
            //swiftView.Frame = this.View.Bounds;
            //this.View.AddSubview(swiftView);

            timer = new System.Timers.Timer(1000);
            timer.Elapsed += onTimedEvent;

      

            BrowserViewManager.WebviewGeneratorCallbackWithCallback(configuration =>
            {
                return new WKWebView(frame: new CGRect(0, 0, 300, 500), new WKWebViewConfiguration());
            });

            var manager = new BrowserViewManager();
            var swiftView = manager.BrowserView;
            swiftView.Frame = this.View.Bounds;
            this.View.AddSubview(swiftView);

            manager.ClickAppActionWithCallback( value => {
                Console.WriteLine(value);
            });
        }

        private void onTimedEvent(object sender, ElapsedEventArgs e)
        {
            //count = (float)(count + 0.05);
            //manager.OnListenProgressWithProgress(count);
            //if (count >= 1.0)
            //{
            //    timer.Stop();
            //    manager.DownloadComplete();
            //}
        }
    }
}

