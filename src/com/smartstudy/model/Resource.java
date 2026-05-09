package com.smartstudy.model;

public class Resource {
    private int    id;
    private String title;
    private String fileName;
    private String filePath;
    private String fileType;
    private String subject;
    private int    uploadedBy;
    private String uploaderName;
    private String uploadDate;

    public Resource() {}

    // Getters
    public int    getId()           { return id; }
    public String getTitle()        { return title; }
    public String getFileName()     { return fileName; }
    public String getFilePath()     { return filePath; }
    public String getFileType()     { return fileType; }
    public String getSubject()      { return subject; }
    public int    getUploadedBy()   { return uploadedBy; }
    public String getUploaderName() { return uploaderName; }
    public String getUploadDate()   { return uploadDate; }

    // Setters
    public void setId(int id)                     { this.id = id; }
    public void setTitle(String title)            { this.title = title; }
    public void setFileName(String fileName)      { this.fileName = fileName; }
    public void setFilePath(String filePath)      { this.filePath = filePath; }
    public void setFileType(String fileType)      { this.fileType = fileType; }
    public void setSubject(String subject)        { this.subject = subject; }
    public void setUploadedBy(int uploadedBy)     { this.uploadedBy = uploadedBy; }
    public void setUploaderName(String name)      { this.uploaderName = name; }
    public void setUploadDate(String uploadDate)  { this.uploadDate = uploadDate; }
}
