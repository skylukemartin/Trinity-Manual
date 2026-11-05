## Downloads and Uploads
Files can be transferred between the TeamServer and agents in chunks. The TeamServer also provides file storage for files uploaded to the server and files received from agents.

### File Storage
The TeamServer provides two file storage locations:
- `Uploads` - files uploaded to the TeamServer.
- `Loot` - files received from agents.
Files stored by the TeamServer can be listed and retrieved through the file management functionality.

The available file folders are:

| Folder | Description |
| --- | --- |
| Uploads | Files uploaded to the TeamServer. |
| Loot | Files received from agents. |

### Uploading a File to the TeamServer
Files can be uploaded to the TeamServer and stored in the `Uploads` directory.
When a file is uploaded:
1. The file is submitted to the TeamServer.
2. The TeamServer checks that the file is not empty.
3. Any directory information supplied with the filename is removed.
4. The file is saved to the `Uploads` directory.
5. If a file with the same name already exists, a numbered filename is created instead of overwriting the existing file.

For example:
```text
example.txt
example(1).txt
example(2).txt
```

### Viewing Stored Files
Files stored by the TeamServer can be listed by selecting the required storage folder.
The available folders are:
- `Uploads`
- `Loot`
A file can also be retrieved by specifying its filename and storage folder.
The TeamServer verifies that the requested file exists before returning it.

### Downloading a File to an Agent
A file can be transferred from the TeamServer to an agent using a download task.
The TeamServer first creates the first chunk of the requested file at offset `0`. The file is then transferred in chunks until the complete file has been sent.

The download process is:
1. The download source path and destination path are provided.
2. The TeamServer validates the source path.
3. The first file chunk is read.
4. The chunk is encoded and queued as a download task.
5. The agent receives the chunk and writes it to the destination file.
6. The TeamServer creates the next chunk using the previous chunk's offset and size.
7. The process continues until the final chunk is received.
8. The agent reports the final download status to the TeamServer.

The agent creates the required destination directory when necessary and writes each received chunk at its specified offset.

### Uploading a File from an Agent
An agent can transfer a file back to the TeamServer.
The file is read by the agent in chunks and sent to the TeamServer. The TeamServer stores the received file in the `Loot` directory associated with the agent's campaign.

The upload process is:
1. An upload task is issued to the agent.
2. The agent reads the file starting at the requested offset.
3. A maximum of 512 KiB is read for each chunk.
4. The chunk is returned to the TeamServer.
5. The TeamServer decodes and stores the chunk at its specified offset.
6. If more data remains, another upload task is queued.
7. The process continues until the final chunk is received.
8. The completed file is stored in the campaign's `Loot` directory.

The resulting storage structure is:
```text
storage/
└── Loot/
    └── {campaign ID}/
        └── {filename}
```

### File Chunking
Files are transferred in chunks rather than as a single file.
The current chunk size is **512 KiB**.
For downloads, the TeamServer reads the source file from the current offset and sends the resulting chunk to the agent.
For uploads, the agent reads the source file from the current offset and sends the chunk to the TeamServer.
The next chunk starts at the previous offset plus the number of bytes contained in the previous chunk.
A transfer is complete when the final chunk has been processed.

### Download and Upload Status
The TeamServer and agent use transfer status information to determine whether another chunk is required.

For uploads:
- `More to follow` indicates that another chunk remains.
- `No more to follow` indicates that the final chunk has been received.
For downloads:
- `Download chunk` indicates that another chunk remains.
- `Download final `indicates that the final chunk has been sent.

Once a download has completed, the TeamServer reports that the download was completed successfully.
Once an agent upload has completed, the TeamServer reports that the file was successfully received as loot.

### File Transfer Errors
File transfers can fail if:
- The requested source path is empty.
- The destination path is empty.
- A file offset is invalid.
- The requested file does not exist.
- The source directory does not exist.
- The file cannot be read.
- A file chunk contains invalid Base64 data.
- A file chunk cannot be written to storage.
- An upload or download task cannot be queued.

When an error occurs, the transfer is not completed and the TeamServer reports the corresponding failure.