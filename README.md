
## SwiftUI Image view for loading remote images with caching  feature.
The AsyncImage view in SwiftUI doesn't cache the image. This CachedAsyncImage is built on top of the AsyncImage view with the caching mechanism. 

**Using the Package**:
-   Go to **File > Swift Packages > Add Package Dependency**.
-   Enter this URL:  https://github.com/jakirseu/CachedAsyncImage

**Usages:** 

    CachedAsyncImage(url: imageURL)

**For example:** 

    CachedAsyncImage(url: URL(string: "https://picsum.photos/id/42/600") )
