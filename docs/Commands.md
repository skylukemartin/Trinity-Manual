**The following section outlines the operator command-line interface for interacting with the agent.** Use these commands within the operator console to control execution behaviour, manage file systems, manipulate processes, and configure callback infrastructure. Brackets `[...]` indicate customisable arguments and data placeholders required by the client command interpreter. 
## PowerShell 

Executes a specified command or cmdlet within a fresh PowerShell (`powershell.exe`) process context.
### Usage example:

```
powershell [commandlet] [arguments]
```

## Shell 

Spawns a traditional Windows command shell (`cmd.exe`) to run a system command.
### Usage example:

```
shell [command]
```

## Download 

Spawns a traditional Windows command shell (`cmd.exe`) to run a system command.
### Usage example:

```
download [C:\path\to\target\file]
```

## Upload

Stages a file transaction from the team server down to the host via sequential chunking.
### Usage example:

```
upload [/path/on/server] [C:\path\on\target]
```

## Kill Process

Stages a file transaction from the team server down to the host via sequential chunking.
### Usage example:

```
kill-process [PID]
```

## RunAs

Spawns a program under the security context of explicit, alternate user credentials.
### Usage example:

```
runas [DOMAIN\user] [password] [command] [arguments]
```

## Run

Executes a binary directly without a shell wrapper and returns its standard output streams.|
### Usage example:

```
run [program.exe] [arguments]
```

## RunU

Executes a command using spoofed parent process attributes matching the provided target PID|
### Usage example:

```
run [program.exe] [arguments]
```

## Escalate

Performs user account elevation via a Registry Hive manipulation UAC bypass technique.
### Usage example:

```
escalate [registry_key] [C:\path\to\binary.exe]
```

## Persist 

Establishes persistence by building a Windows Scheduled Task as SYSTEM.
### Usage example:

```
persist [C:\path\to\payload.exe] [username] [task_name]
```

## Inline-execute

Runs a .NET assembly purely inside memory.

```
execute-assembly [/path/to/file.exe] [arguments]
```

## SpawnTo

Instructs the agent which default system binary to launch for post-exploitation jobs.

```
spawnto [C:\path\to\sacrificial.exe]
```

## UpdateHosts

Modifies the agent's active callback routing infrastructure for redundant domain rotation.

```
updatehosts [host1,host2,host3]
```

## Sleep 

Controls the agent's interactive check-in frequency and randomised timing randomisation.

```
sleep [seconds] [jitter_percent]
```

## Kill 

Sends an immediate self-termination signal to exit the agent process.

```
kill
```

## GetUID

Queries the host access token to return the exact identity profile running the agent.

```
getuid
```
