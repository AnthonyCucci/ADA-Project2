-- File: OpenFile.ads
-- OpenFile package interface
--	Procedure declarations for opening files for reading and writing
--	Caller need not know actual file names

with Ada.Text_IO; use Ada.Text_IO;

package OpenFile is

	------------------------------------------------------------------------
	--OpenReadFile prompts the user for the filename and opens it for input
	------------------------------------------------------------------------
	procedure OpenReadFile (datafile : in out file_type);

	------------------------------------------------------------------------
	--OpenWriteFile prompts the user for the filename and opens it for input
	------------------------------------------------------------------------
	procedure OpenWriteFile (outputfile : in out file_type);

end OpenFile;