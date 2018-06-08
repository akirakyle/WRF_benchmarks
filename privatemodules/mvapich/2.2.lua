require("posix")

-- The message printed by the module help command
help([[
custom mvapich v2.2 module

mvapich installed at

/glade/u/apps/ch/opt/mvapich2/2.2/gnu/7.1.0/bin/
]])

-- Set paths for software binaries, libraries, headers, and manuals
local basepath = "/glade/u/apps/ch/opt/mvapich2/2.2/gnu/7.1.0"
local binpath  = pathJoin(basepath, "/bin")             -- binaries
local libpath  = pathJoin(basepath, "/lib")             -- libraries
local incpath  = pathJoin(basepath, "/include")         -- include files
local manpath  = pathJoin(basepath, "/share/man")       -- man pages

-- Update the binary and manual paths in user environment
prepend_path("PATH", binpath)
prepend_path("MANPATH", manpath)

-- Set flags to help compilers and linkers
prepend_path("CPATH", incpath)
prepend_path("FPATH", incpath)
prepend_path("LD_LIBRARY_PATH", libpath)
prepend_path("LIBRARY_PATH", libpath)
