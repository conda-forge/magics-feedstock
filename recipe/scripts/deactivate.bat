:: Restore previous env vars if any
@set "MAGPLUS_HOME="

@if defined _CONDA_SET_MAGPLUS_HOME (
    set "MAGPLUS_HOME=%_CONDA_SET_MAGPLUS_HOME%"
    set "_CONDA_SET_MAGPLUS_HOME="
)
