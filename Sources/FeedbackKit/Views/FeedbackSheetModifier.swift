import SwiftUI

struct FeedbackSheetModifier: ViewModifier {
    let apiKey: String
    @Binding var isPresented: Bool
    var onSubmit: ((String) -> Void)?
    var onError: ((Error) -> Void)?

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            NavigationStack {
                FeedbackView(apiKey: apiKey, onSubmit: { id in
                    isPresented = false
                    onSubmit?(id)
                }, onError: onError)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { isPresented = false }
                    }
                }
            }
        }
    }
}

public extension View {
    /// Present a FeedbackKit feedback sheet.
    ///
    /// ```swift
    /// Button("Send Feedback") { showFeedback = true }
    ///     .feedbackSheet(apiKey: "fb_live_...", isPresented: $showFeedback)
    /// ```
    func feedbackSheet(
        apiKey: String,
        isPresented: Binding<Bool>,
        onSubmit: ((String) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> some View {
        modifier(FeedbackSheetModifier(
            apiKey: apiKey,
            isPresented: isPresented,
            onSubmit: onSubmit,
            onError: onError
        ))
    }
}
