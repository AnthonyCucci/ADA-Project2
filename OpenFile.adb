-- File: OpenFile.adb
-- OpenFile package implementation
--	Procedures for opening files for reading and writing
--	Caller need not know actual file names


package body OpenFile is

	------------------------------------------------------------------------
	--OpenReadFile prompts the user for the filename and opens it for input
	------------------------------------------------------------------------
	procedure OpenReadFile (datafile : in out file_type) is
	   fname : string (1..80);
	   len   : natural;           -- length of the filename
	begin
	   put ("Please enter the name of your data file: ");
	   get_line (fname, len);     -- len is the number of characters read
	   open (File=>datafile, Mode=>in_file, Name=>fname(1..len));
	end OpenReadFile;

	------------------------------------------------------------------------
	--OpenWriteFile prompts the user for the filename and opens it for input
	------------------------------------------------------------------------
	procedure OpenWriteFile (outputfile : in out file_type) is
	   fname : string (1..80);
	   len   : natural;           -- length of the filename
	begin
	   put ("Please enter the name of your output file: ");
	   get_line (fname, len);     -- len is the number of characters read
	   Create (File=>outputfile, Mode=>out_file, Name=>fname(1..len));
	end OpenWriteFile;
	
end OpenFile;