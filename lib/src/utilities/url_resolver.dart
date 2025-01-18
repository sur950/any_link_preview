String resolveImageUrl(String baseUrl, String proxyUrl, String imageUrl) {
  try {
    // Parse the base and proxy URLs
    final baseUri = Uri.parse(baseUrl);
    final proxyUri = Uri.parse(proxyUrl);

    // Resolve the relative image URL with the base URL
    final resolvedUri = baseUri.resolve(imageUrl);

    // Combine the proxy URL with the resolved URI
    return proxyUri.resolve(resolvedUri.toString()).toString();
  } catch (e) {
    // Return the original image URL if resolution fails
    return imageUrl;
  }
}
