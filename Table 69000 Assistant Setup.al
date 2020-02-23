table 69000 "Assistant Setup"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Primary Key"; code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "LUIS subscription key"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Open Order Intent"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Ask for needs Intent"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Read lots Intent"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Order Number Entity"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Product name Entity"; text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(8; "LUIS Application ID"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "End Scan Lots Intent"; text[50])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}