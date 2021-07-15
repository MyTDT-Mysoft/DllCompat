function set_ntstatus(status as NTSTATUS) as BOOL
    if 0=NT_SUCCESS(status) then SetLastError(RtlNtStatusToDosError(status))
    return NT_SUCCESS(status)
end function

extern "windows-ms"
  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 flags                    as ULONG
  #define P3 context                  as any ptr ptr
  declare function RtlRunOnceBeginInitialize(P1, P2, P3) as DWORD
  
  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 flags                    as ULONG
  #define P3 context                  as any ptr
  declare function RtlRunOnceComplete(P1, P2, P3) as DWORD
  
  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 func                     as PRTL_RUN_ONCE_INIT_FN
  #define P3 param                    as any ptr
  #define P4 context                  as any ptr ptr
  declare function RtlRunOnceExecuteOnce(P1, P2, P3, P4) as DWORD
end extern








extern "windows-ms"
  UndefAllParams()
  #define P1 ponce      as INIT_ONCE ptr
  #define P2 flags      as DWORD
  #define P3 pending    as BOOL ptr
  #define P4 context    as any ptr ptr
  function InitOnceBeginInitialize(P1, P2, P3, P4) as BOOL export
    dim as NTSTATUS status = RtlRunOnceBeginInitialize( ponce, flags, context )
    
    if status >= 0 then
      *pending = (status = STATUS_PENDING)
    else
      SetLastError( RtlNtStatusToDosError(status) )
    end if
    return status >= 0
  end function


  UndefAllParams()
  #define P1 ponce      as INIT_ONCE ptr
  #define P2 flags      as DWORD
  #define P3 context    as any ptr ptr
  function InitOnceComplete(P1, P2, P3) as BOOL export
    return set_ntstatus( RtlRunOnceComplete( ponce, flags, context ))
  end function


  UndefAllParams()
  #define P1 ponce      as INIT_ONCE ptr
  #define P2 func       as PINIT_ONCE_FN
  #define P3 param      as any ptr
  #define P4 context    as any ptr ptr
  function InitOnceExecuteOnce(P1, P2, P3, P4) as BOOL export
    return 0=RtlRunOnceExecuteOnce( ponce, cast(PRTL_RUN_ONCE_INIT_FN, func), param, context )
  end function
end extern