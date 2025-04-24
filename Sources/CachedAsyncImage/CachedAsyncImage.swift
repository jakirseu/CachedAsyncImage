import SwiftUI

public struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    @State private var image: Image? = nil
    @State private var isLoading = false
    private let content: (Image) -> Content
    private let placeholder: () -> Content

    public init<I: View, P: View>(
        url: URL?, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P
    ) where Content == AnyView {
        self.url = url
        self.content = { image in AnyView(content(image)) }
        self.placeholder = { AnyView(placeholder()) }
    }

    public init(url: URL?) where Content == AnyView {
        self.url = url
        self.content = { image in AnyView(image) }
        self.placeholder = { AnyView(ProgressView()) }
    }

    public init(url: URL?, scale: CGFloat = 1.0) where Content == AnyView {
        self.url = url
        self.content = { image in AnyView(image.resizable().scaledToFit()) }
        self.placeholder = { AnyView(ProgressView()) }
    }

    public init<I: View>(url: URL?, @ViewBuilder content: @escaping (Image) -> I) where Content == AnyView {
        self.url = url
        self.content = { image in AnyView(content(image)) }
        self.placeholder = { AnyView(ProgressView()) }
    }

    public var body: some View {
        Group {
            if let image = image {
                content(image)
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            await loadImage()
                        }
                    }
            }
        }
    }

    private func loadImage() async {
        guard let url = url, !isLoading else { return }

        // Ensure state updates are isolated to the main actor
        isLoading = true

        // Check if the image is already cached
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
            let cachedImage = UIImage(data: cachedResponse.data)
        {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }

        // Fetch the image from the network
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Cache the image
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)

            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            // Handle any errors here (e.g., network failure)
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
