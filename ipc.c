/* Inter-process Communication */
#include <windows.h>
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include "ipc.h"

static STARTUPINFO StartupInfo;
static PROCESS_INFORMATION ProcessInfo;
static char *program = "ezshare.exe child";
//static char *program = "a.exe child";

int spawn(char* parentName)
{
  memset(&StartupInfo, 0, sizeof(StartupInfo));
  memset(&ProcessInfo, 0, sizeof(ProcessInfo));
  StartupInfo.cb = sizeof(STARTUPINFO);
  StartupInfo.dwFlags = STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow = SW_HIDE;

  char str[80];
  strcpy(str, program);
  strcat(str, parentName);

  if (!CreateProcess(NULL, str, NULL, NULL, FALSE,
                     0, NULL, NULL, &StartupInfo, &ProcessInfo)) {
    return 0;
  }

  return 1;
}

int lock(void* whom)
{
  return WaitForSingleObject(whom, INFINITE);
}

int unlock(void* whom)
{
  return ReleaseSemaphore(whom, 1, NULL);
}

static HANDLE hMemory;

char* mapMemory(uint32_t memsize, char* memoryName, int child)
{
  if (child) {
    hMemory = OpenFileMapping(
                              FILE_MAP_ALL_ACCESS,
                              FALSE,
                              memoryName);
  }
  else {
    hMemory=CreateFileMapping(INVALID_HANDLE_VALUE,
                              NULL,PAGE_READWRITE,0,
                              memsize,memoryName);
  }
  assert(hMemory!=NULL);

  return (char*) MapViewOfFile(hMemory,
                               FILE_MAP_WRITE,
                               0, 0, 0);
}

void* init(char *parentName)
{
  HANDLE semaphore;

  if (parentName == "") {
    return OpenSemaphore(SYNCHRONIZE|SEMAPHORE_MODIFY_STATE,
                         FALSE, "Global\\EZShare");
  }
  else {
    semaphore = CreateSemaphore(NULL, 1, 1, "Global\\EZShare");
    if (!spawn(parentName)) {
      return NULL;
    }
    return semaphore;
  }
}
