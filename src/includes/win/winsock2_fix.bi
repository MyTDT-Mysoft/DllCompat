#pragma once

type pollfd
  fd as SOCKET
  events as short
  revents as short
end type

type WSAPOLLFD as pollfd
type PWSAPOLLFD as pollfd ptr
type LPWSAPOLLFD as pollfd ptr