--
--Name: Anthony Cucci
--Major: CS
--Due Date: 3/10/19
--Course: CSC 310
--Professor: Dr. Spiegel
--Assignment: #2
--Filename: lex.adb
--Purpose: Lexicographical Analysis of a program
--

WITH Text_IO;                  USE Text_IO;
WITH OpenFile;		       USE OpenFile;
WITH Ada.Command_Line;         USE Ada.Command_Line;
WITH Ada.Strings.Unbounded;    USE Ada.Strings.Unbounded;
WITH Ada.Text_IO.Unbounded_Io; USE Ada.Text_IO.Unbounded_IO;

procedure Lex is

  type Char_Type is (Beginsym, Progsym, Endsym, Decsym, Colon, Semicolon,
                     Comma, Typesym, Readsym, Writesym, Operator,
                     Lparen, Rparen, Id, Nullsym);

  package Class_IO is new Ada.Text_IO.Enumeration_IO(Char_Type);
  use Class_IO;

  --Name: WriteFile
  --Description: Takes Enumerated token and Outputs it to the file
  --Parameters: File_Type  OutFile: Output File - Input Output
  --            Char_Type  Class: Enumerated Token - Input
  --Return Value: None
  PROCEDURE WriteFile(outFile: in out File_Type; class: in Char_Type) is
  BEGIN
    if not (class = Nullsym) then
       Class_IO.Put(outFile,Class);
       Text_Io.Put_Line (outFile, " ");
    end if;
  END WriteFile;


  --Name: ReadFile
  --Description: Reads input file and sets up output file
  --Parameters: File_Type  InFile: Input file - Input Output
  --            File_Type  OutFile: Output File - Input Output
  --Return Value: None
  PROCEDURE ReadFile(InFile: in out File_Type; OutFile: in out File_Type) is
  BEGIN
      if Argument_Count = 0 Then
         OpenReadFile(InFile);
         OpenWriteFile(OutFile);

      elsIf Argument_Count = 2 Then
         Text_IO.open(File=>InFile, Mode=>Text_IO.in_file, Name=>Argument(1));
         Text_IO.Create(File=>OutFile, Mode=>Text_IO.out_file, Name=>Argument(2));
      end If;
  END ReadFile;


  --Name: ConvertToken
  --Description: Takes a token and converts it into an Enumeration type and
  --             passes into WriteFile
  --Parameters: Unbounded_String token: generated token - Input
  --            File_Type        OutFile: Output File - Input Output
  --            Integer          tokenLen: length of token - input
  --Return Value: None
  PROCEDURE ConvertToken(token: in Unbounded_String; OutFile: in out File_Type;
                         tokenLen: in Integer) is
     Class:    Char_Type := Nullsym;
     tokenStr: String(1..tokenLen);
  BEGIN
     tokenStr := TO_String(token);

     if (tokenLen > 0)  then
        if (tokenStr = "program") then
           Class := Progsym;
        elsif (tokenStr = "begin" ) then
           Class := Beginsym;
        elsif (tokenStr = "end." ) then
           Class := Endsym;
        elsif (tokenStr = "dec" ) then
           Class := Decsym;
        elsif (tokenStr = "':'" ) then
           Class := Colon;
        elsif (tokenStr = "';'" ) then
           Class := SemiColon;
        elsif (tokenStr = "','" ) then
           Class := Comma;
        elsif (tokenStr = "int" ) or (tokenStr = "real" ) then
           Class := Typesym;
        elsif (tokenStr = "Read" ) then
           Class := Readsym;
        elsif (tokenStr = "Write" ) then
           Class := Writesym;
        elsif ((tokenStr = "'='") or (tokenStr = "'+'") or (tokenStr = "'-'")
               or (tokenStr = "'*'") or (tokenStr = "'/'")) then
           Class := Operator;
        elsif (tokenStr = "'('" ) then
           Class := Lparen;
        elsif (tokenStr =  "')'" ) then
           Class := Rparen;
        elsif ((tokenStr =  " " ) or (tokenStr = "")) then
           Class := Nullsym;
        else
           Class := id;
        end if;
     end if;
     WriteFile(outFile,Class);
  END ConvertToken;


  --Name: MakeTokenHelper
  --Description: sends token to Convert token and resets String for next Token
  --Parameters: File_Type         OutFile: Output File - Input Output
  --            Unbounded_String  Str: token string - Input Output
  --            Integer           StrCount: String length - Input Output
  --Return Value: None
  PROCEDURE MakeTokenHelper(OutFile: IN OUT File_Type;
                            Str: IN OUT Unbounded_String;
                            StrCount : IN OUT Integer) is

  BEGIN
     ConvertToken(Str,OutFile,StrCount);
     Delete(Str,1,StrCount);
     StrCount := 0;
  END MakeTokenHelper;


  --Name: MakeToken
  --Description: Takes raw file input and converts it into tokens and
  --             passes token into convertToken procedure
  --Parameters: File_Type        InFile: Input file - Input Output
  --            File_Type        OutFile: Output File - Input Output
  --Return Value: None
  PROCEDURE MakeToken(Infile: in out File_Type; OutFile: in out File_Type) is
     Str:                  Unbounded_String := To_Unbounded_String("");
     Char, tempChar:       Character;
     EOL:                  Boolean;
     StrCount:             Integer := 0;
  BEGIN
     while not Text_Io.End_Of_File (Infile) loop
        while not Text_IO.End_Of_Line (InFile) loop
           look_Ahead(File => InFile, Item => tempChar,End_Of_Line => EOL);
           if not EOL then
              Text_IO.Get(File=>InFile, Item=>Char);
              case Char is
                 when 'A' .. 'Z' | 'a' .. 'z' =>
                    Append(Str, Char);
                    StrCount := StrCount + 1;

                 when '0' .. '9' =>
                    Append(Str, Char);
                    StrCount := StrCount + 1;

                 when '=' | '*' | '+' | '-' | '/'  =>
                    MakeTokenHelper(OutFile,Str,StrCount);
                    ConvertToken(To_Unbounded_String(Character'Image(Char)),
                                 OutFile,3);

                 when ' ' =>
                    MakeTokenHelper(OutFile,Str,StrCount);

                 when '.' =>
                    Append(Str, Char);
                    StrCount := StrCount + 1;
                    MakeTokenHelper(OutFile,Str,StrCount);

                 when '(' | ')' | ',' | ':' | ';' =>
                    MakeTokenHelper(OutFile,Str,StrCount);
                    ConvertToken(To_Unbounded_String(Character'Image(Char)),
                                 OutFile,3);
                 when others =>
                    MakeTokenHelper(OutFile,Str,StrCount);
              end case;

           else
               MakeTokenHelper(OutFile,Str,StrCount);
           end if;
        end loop;

        Text_IO.New_Line;
        Text_IO.Skip_Line (InFile);
         if not Text_Io.End_Of_File (Infile) then
           MakeTokenHelper(OutFile,Str,StrCount);
        end if;
     end loop;
  END MakeToken;

  InFile,OutFile: 	Text_IO.File_Type;

begin
  ReadFile(InFile,OutFile);
  MakeToken(InFile,OutFile);
  Close(Infile);
  Close(Outfile);
END Lex;
