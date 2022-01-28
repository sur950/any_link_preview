# 2.0.4

- Proxy URL added for CORS issue on the web. One can pass empty if they don't get any CORS issue while running on web platform.
- Now one can disable the `onTap` action on the card by passing empty function `onTap: (){}`
- If you want to build your own UI & need just the meta data (with or without cache), then you can call the method `AnyLinkPreview.getMetadata(link: "https://google.com/")` which returns data of type `Metadata`
- One can check if the URL is valid or not by calling `AnyLinkPreview.isValidLink("https://google.com/")` which returns a boolean. `true` if `Valid`, `false` if `Invalid`.

# 2.0.3

- Multiline JSON support added
- Base64 image support is added

# 2.0.2

- 🎉 Web support added
- Now the plugin will work for most of the links (Even for dynamic links)
- Few minor bugs are closed from Github issues

# 2.0.1-rc

- Minor improvements

# 2.0.0-rc

- Migrated to null safety

# 1.0.8

- `borderRadius` giving it zero has some issue which is fixed
- `removeElevation` new param added

# 1.0.7

- Flutter V2 support upgradation

# 1.0.6

- `Border Radius`, `Color`, `Box shadow`, are now customizable.

# 1.0.5

- Twitter posts are private, so added default twitter image for the same

# 1.0.4

- Adjustment of UI

# 1.0.3

- Added the list of apps that are already using this package

# 1.0.2

- Images added to readme file

# 1.0.1

- Package is linked to the git repo & homepage url is updated

# 1.0.0

- Parse your web URL's & show preview with in your application
