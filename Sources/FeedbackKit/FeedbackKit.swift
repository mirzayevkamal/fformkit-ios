import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// The main entry point for the FeedbackKit Swift SDK.
///
/// **SwiftUI usage (recommended):**
/// ```swift
/// @State private var showFeedback = false
///
/// var body: some View {
///     Button("Send Feedback") { showFeedback = true }
///         .feedbackSheet(apiKey: "fb_live_...", isPresented: $showFeedback)
/// }
/// ```
///
/// **Inline SwiftUI view:**
/// ```swift
/// FeedbackView(apiKey: "fb_live_...")
/// ```
///
/// **UIKit usage:**
/// ```swift
/// FeedbackKit.present(from: self, apiKey: "fb_live_...") { id in
///     print("Feedback submitted:", id)
/// }
/// ```
public enum FeedbackKit {

    #if canImport(UIKit)
    /// Present the feedback form modally from a `UIViewController`.
    ///
    /// - Parameters:
    ///   - viewController: The presenting view controller.
    ///   - apiKey: Your FeedbackKit project API key.
    ///   - onSubmit: Called with the feedback ID on successful submission.
    ///   - onError: Called with the error if submission fails.
    public static func present(
        from viewController: UIViewController,
        apiKey: String,
        onSubmit: ((String) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        let feedbackView = FeedbackView(apiKey: apiKey, onSubmit: { id in
            viewController.dismiss(animated: true)
            onSubmit?(id)
        }, onError: onError)

        let hostingController = UIHostingController(rootView: NavigationStack {
            feedbackView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewController.dismiss(animated: true)
                        }
                    }
                }
        })

        hostingController.modalPresentationStyle = .formSheet
        viewController.present(hostingController, animated: true)
    }
    #endif
}
