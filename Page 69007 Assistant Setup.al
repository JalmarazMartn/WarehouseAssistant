page 69007 "Assistant Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Assistant Setup";
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; "LUIS subscription key")
                {
                    ApplicationArea = All;
                }
                field("LUIS Application ID"; "LUIS Application ID")
                {
                    ApplicationArea = All;
                }

                field("Read lots Intent"; "Read lots Intent")
                {
                    ApplicationArea = All;
                }
                field("Ask for needs Intent"; "Ask for needs Intent")
                {
                    ApplicationArea = All;
                }
                field("Order Number Entity"; "Order Number Entity")
                {
                    ApplicationArea = All;
                }
                field("Product name Entity"; "Product name Entity")
                {
                    ApplicationArea = All;
                }
                field("Open Order Intent"; "Open Order Intent")
                {
                    ApplicationArea = All;
                }
                field("End Scan Lots Intent"; "End Scan Lots Intent")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Get() then
            Insert();
    end;
}