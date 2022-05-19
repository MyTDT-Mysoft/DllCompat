extern "windows-ms"
  UndefAllParams()
  #define P1 s      as LPCSTR
  #define P2 maxlen as DWORD
  function strnlen(P1, P2) as DWORD export
    for i as int = 0 to maxlen-1
      if s[i] = 0 then return i
    next
    
    return maxlen
  end function
end extern