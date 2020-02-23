codeunit 69005 "Whse. Asistant Mngt"
{
    procedure GetLUISPredicition(InputText: Text) TextoResponse: Text
    var
        HttpClient: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        url: Text;
    begin
        url := StrSubstNo(AppUrl, GetLUISAppID(), GetLUISSubsKey(), InputText);
        Request.Method('GET');
        Request.SetRequestUri(url);
        HttpClient.Send(Request, Response);
        Response.Content.ReadAs(TextoResponse);
    end;

    local procedure GetLUISSubsKey(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("LUIS subscription key");
            exit("LUIS subscription key");
        end;
    end;

    local procedure GetLUISAppID(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("LUIS Application ID");
            exit("LUIS Application ID");
        end;
    end;

    local procedure GetOpenOrderIntent(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("Open Order Intent");
            exit("Open Order Intent");
        end;
    end;

    local procedure GetAskForNeedsIntent(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("Ask for needs Intent");
            exit("Ask for needs Intent");
        end;
    end;

    local procedure GetReadLotsIntent(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("Read lots Intent");
            exit("Read lots Intent");
        end;
    end;

    local procedure GetEndScanLotsIntent(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("End Scan Lots Intent");
            exit("End Scan Lots Intent");

        end;
    end;


    local procedure GetOrderNumberEntity(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("Order Number Entity");
            exit("Order Number Entity");
        end;
    end;

    local procedure GetProductNameEntity(): Text[50]
    var
        AssistantSetup: Record "Assistant Setup";
    begin
        with AssistantSetup do begin
            Get();
            TestField("Product name Entity");
            exit("Product name Entity");
        end;
    end;


    procedure GetIntentResponse(InputText: Text; var AssemblyHeader: record "Assembly Header") Response: Text
    var
        ResponseLUISText: Text;
        IntentName: Text[50];
    begin
        ResponseLUISText := GetLUISPredicition(InputText);
        IntentName := GetMainIntent(ResponseLUISText);
        case IntentName of
            GetOpenorderIntent:
                begin
                    OpenOrder(ResponseLUISText, AssemblyHeader);
                    exit(StrSubstNo('%1 %2', AssemblyHeader."No.", AssemblyHeader.Description));
                end;
            GetAskForNeedsIntent():
                exit(GetNeedsResponse(AssemblyHeader));
            GetReadLotsIntent():
                exit(ReadLotsCaption);
            GetEndScanLotsIntent():
                exit(EndScanCaption);
        end;
    end;

    procedure GetMainIntent(ResponseText: Text) IntentName: Text
    var
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        with JSONBuffer do begin
            ReadFromText(ResponseText);
            SetRange(Path, IntentPathFilter);
            SetRange("Token type", "Token type"::String);
            if not FindFirst() then
                error(ErrNoIntent);
            IntentName := Value;
        end;
    end;

    local procedure OpenOrder(ResponseLUISText: text; var AssemblyHeader: Record "Assembly Header")
    var
        JSONBuffer: Record "JSON Buffer" temporary;
        EntityName: text[250];
        EntityValue: Text[250];
    begin
        EntityName := GetEntityName(ResponseLUISText, 0);
        EntityValue := GetEntityValue(ResponseLUISText, 0);
        AssemblyHeader.Reset();
        case EntityName of
            GetOrderNumberEntity():
                AssemblyHeader.SetFilter("No.", '*' + EntityValue);
            GetProductNameEntity():
                AssemblyHeader.SetFilter(Description, '@*' + EntityValue + '*');
            else
                Error(ErrNoEntity);
        end;
        AssemblyHeader.FindFirst();
    end;

    local procedure GetNeedsResponse(AssemblyHeader: Record "Assembly Header") Needs: Text
    var
        AssemblyLine: Record "Assembly Line";
    begin
        with AssemblyLine do begin
            SetRange("Document No.", AssemblyHeader."No.");
            SetRange(Type, type::Item);
            SetFilter(Description, '<>%1', '');
            FindSet();
            repeat
                Needs := needs + '\' + Description;
            until next = 0;
        end;
    end;

    local procedure GetEntityValue(ResponseLuisText: Text; Index: Integer): text[250]
    var
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        with JSONBuffer do begin
            ReadFromText(ResponseLuisText);
            Reset();
            SetRange(Path, StrSubstNo(EntityPathValueFilter, Index));
            SetRange("Token type", "Token type"::String);
            if FindFirst() then
                exit(Value);
        end;
    end;

    local procedure GetEntityName(ResponseLuisText: Text; Index: Integer): text[250]
    var
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        with JSONBuffer do begin
            ReadFromText(ResponseLuisText);
            Reset();
            SetRange(Path, StrSubstNo(EntityPathNameFilter, Index));
            SetRange("Token type", "Token type"::String);
            if FindFirst() then
                exit(Value);
        end;
    end;

    var
        AppUrl: TextConst ENU = 'https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/%1?verbose=true&timezoneOffset=0&subscription-key=%2&q=%3';
        ReadLotsCaption: TextConst ENU = 'Scanning Lots';
        IntentPathFilter: TextConst ENU = 'topScoringIntent.intent';
        ErrNoIntent: TextConst ENU = 'No Intent Detected. Try Again';
        EntityPathValueFilter: TextConst ENU = 'entities[%1].entity';
        EntityPathNameFilter: TextConst ENU = 'entities[%1].type';
        ErrNoEntity: TextConst ENU = 'No search criteria for orders';
        TryAgainCaption: TextConst ENU = 'No intent detected: try again.';
        EndScanCaption: TextConst ENU = 'End of Scan';
}