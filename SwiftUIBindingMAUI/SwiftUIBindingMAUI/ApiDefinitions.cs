using System;
using CoreData;
using Foundation;
using ObjCRuntime;
using UIKit;
using WebKit;

namespace BrowserFramework
{
	
	// @interface BrowserViewManager : NSObject
	[BaseType (typeof(NSObject))]
	interface BrowserViewManager
	{
		// @property (nonatomic, strong) UIView * _Nullable browserView;
		[NullAllowed, Export ("browserView", ArgumentSemantic.Strong)]
		UIView BrowserView { get; set; }

		// +(void)webviewGeneratorCallbackWithCallback:(WKWebView * _Nonnull (^ _Nonnull)(WKWebViewConfiguration * _Nullable))callback;
		[Static]
		[Export ("webviewGeneratorCallbackWithCallback:")]
		void WebviewGeneratorCallbackWithCallback (Func<WKWebViewConfiguration, WKWebView> callback);

		// -(void)clickAppActionWithCallback:(void (^ _Nonnull)(NSString * _Nonnull))callback;
		[Export ("clickAppActionWithCallback:")]
		void ClickAppActionWithCallback (Action<NSString> callback);
	}

	
}
