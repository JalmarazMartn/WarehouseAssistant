page 69006 "Assembly Assitant"
{
    Caption = 'Assembly Assistant';
    DataCaptionFields = "Document Type", "No.";
    Editable = true;
    LinksAllowed = true;
    PageType = ListPlus;
    SourceTable = "Assembly Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Tasks;
    ApplicationArea = assembly;

    layout
    {
        area(content)
        {
            group(Input)
            {
                Editable = true;
                field(InputText; InputText)
                {
                    ShowCaption = false;
                    Editable = true;
                    ApplicationArea = Assembly;
                    ToolTip = 'Tell me what you want to do';
                    trigger Onvalidate()
                    var
                    begin
                        ProcessInput();
                        InputText := '';
                    end;
                }
            }
            group(Response)
            {

                field(ResponseText; ResponseText)
                {
                    ShowCaption = false;
                    Editable = false;
                    MultiLine = true;
                    ApplicationArea = Assembly;
                }
            }

            repeater(Control1)
            {
                ShowCaption = false;
                Editable = false;
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the type of assembly document the record represents in assemble-to-order scenarios.';
                }
                field("No."; "No.")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the description of the assembly item.';
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the date when the assembly order is expected to start.';
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the date when the assembly order is expected to finish.';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item that is being assembled with the assembly order.';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how many units of the assembly item that you expect to assemble with the assembly order.';
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location to which you want to post output of the assembly item.';
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.';
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how many units of the assembly item remain to be posted as assembled output.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control103; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control104; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Assembly;
                Caption = '&Show Document';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Open the document that the information on the line comes from.';

                trigger OnAction()
                begin
                    case "Document Type" of
                        "Document Type"::Quote:
                            PAGE.Run(PAGE::"Assembly Quote", Rec);
                        "Document Type"::Order:
                            PAGE.Run(PAGE::"Assembly Order", Rec);
                        "Document Type"::"Blanket Order":
                            PAGE.Run(PAGE::"Blanket Assembly Order", Rec);
                    end;
                end;
            }
            action("Reservation Entries")
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Reservation;
                Caption = '&Reservation Entries';
                Image = ReservationLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View all reservations that are made for the item, either manually or automatically.';

                trigger OnAction()
                begin
                    ShowReservationEntries(true);
                end;
            }
            action("Item Tracking Lines")
            {
                ApplicationArea = ItemTracking;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+I';
                ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                trigger OnAction()
                begin
                    OpenItemTrackingLines;
                end;
            }
        }
    }
    var
        InputText: Text;
        ResponseText: Text;
        ReadingLots: Boolean;
        JSONBuffer: Record "JSON Buffer" temporary;
        CurrAssemblyOrder: Record "Assembly Header";
        YouCaption: TextConst ENU = 'You: ';

    local procedure ProcessInput()
    var
        WhseAsistantMngt: Codeunit "Whse. Asistant Mngt";

    begin
        //JSONBuffer.ReadFromText(WhseAsistantMngt.GetLUISPredicition(InputText));
        //page.RunModal(Page::"JSON Buffer", JSONBuffer);
        ResponseText := WhseAsistantMngt.GetIntentResponse(InputText, CurrAssemblyOrder) +
        '\' + YouCaption + InputText +
        '\' + ResponseText;
    end;

    trigger OnOpenPage()

    var
    begin
        CurrPage.Editable(true);
    end;
}
