package com.example.any_link_preview;
import java.util.HashMap;
import java.util.Map;

public class MetaData {
    private String url = null;
    private String imageurl = null;
    private String title = null;
    private String description = null;
    private String sitename = null;
    private String mediatype = null;
    private String favicon = null;

    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
    public String getImageurl() {
        return imageurl;
    }
    public void setImageurl(String imageurl) {
        this.imageurl = imageurl;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getWebsiteName() {
        return sitename;
    }
    public void setWebsiteName(String sitename) {
        this.sitename = sitename;
    }
    public String getMediatype() {
        return mediatype;
    }
    public void setMediatype(String mediatype) {
        this.mediatype = mediatype;
    }
    public String getFavicon() {
        return favicon;
    }
    public void setFavicon(String favicon) {
        this.favicon = favicon;
    }
    public Map<String, Object> toJSON(){
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("url", this.url);
        parameters.put("imageUrl", this.imageurl);
        parameters.put("title", this.title);
        parameters.put("desc", this.description);
        parameters.put("websiteName", this.sitename);
        parameters.put("mediaType", this.mediatype);
        parameters.put("favicon", this.favicon);
        return parameters;
    }
}