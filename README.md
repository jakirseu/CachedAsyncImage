
## SwiftUI Image view for loading remote image with caching  feature.
The AsyncImage view in SwiftUI doesn't cache image. This CachedAsyncImage is built on top of AsyncImage view with caching mechanism. 
**Using the Package**:
-   Go to **File > Swift Packages > Add Package Dependency**.
-   Enter this URL:  https://github.com/jakirseu/CachedAsyncImage

**Usages:** 

    CachedAsyncImage(url: imageURL)

**For example:** 

    CachedAsyncImage(url: URL(string: "https://picsum.photos/id/42/600") )
