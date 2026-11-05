### Why did payload generation fail?
Payload generation can fail if the selected listener cannot be found, the required compiler is unavailable, the CMake configuration fails, the payload cannot be compiled, or the generated executable cannot be located or copied into the `Payloads` directory.

Check that the listener exists and that the TeamServer has access to the required payload build tools.

### Why can't I find a payload?
The TeamServer checks both the payload record in the database and the generated file in the `Payloads` directory.

If either the payload record or its file is missing, the payload cannot be retrieved.

### Why did a file upload fail?
A TeamServer file upload can fail if the submitted file is empty or cannot be written to the `Uploads` directory.

Check that the file contains data and that the TeamServer has permission to write to its storage location.

### Why can't I find a stored file?
Files are stored in either the `Uploads` or `Loot` storage folder.

When retrieving a file, the correct filename and storage folder must be provided. If the file does not exist in the selected folder, the TeamServer reports that the file was not found.

### Why did a file download fail?
A file download can fail if the source path or destination path is empty, the requested file does not exist, the source directory cannot be found, the requested offset is invalid, or the file cannot be read.

Check the source and destination paths and ensure that the requested file is available.

### Why did an agent file upload fail?
Agent file uploads are transferred in chunks. An upload can fail if the file offset is invalid, the filename is empty, the chunk contains invalid Base64 data, or the TeamServer cannot write the chunk to storage.

The received file is stored in the campaign's `Loot` directory after the transfer completes.

### Why can't a command or task be executed?
Commands and tasks can fail if the specified agent cannot be found or if the requested task does not exist.

Check that the target agent is available and that the task being referenced is valid.

### Why can't I create a listener?
Listener creation can fail if the required configuration is invalid or if the selected port is already occupied.

Check the listener configuration and ensure that the required port is available.

### Why can't the TeamServer resolve its network address?
The TeamServer uses its configured network settings when resolving its address. Network configuration or address-resolution failures can prevent the required address from being determined.

Check the configured network address and DNS settings.

### What happens when an unexpected error occurs?
The TeamServer uses a global exception handler to process unhandled errors. The error is returned through the application's standard error response rather than exposing the underlying exception directly.