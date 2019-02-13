:: Store existing env vars so we can restore them later
@if defined MAGPLUS_HOME (
    set "_CONDA_SET_MAGPLUS_HOME=%MAGPLUS_HOME%
)

@set "MAGPLUS_HOME=%CONDA_PREFIX%\Library\"
