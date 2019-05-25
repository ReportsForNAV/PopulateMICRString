Codeunit 50101 "Create Purch. Inv. Check"
{

    trigger OnRun()
    var
        Value: Code[20];
        i: Integer;
    begin
        for i := 1 to 30 do begin
            Value := CreatePurchHeaderWithNumber10000;
            CreatePurchLinesWithRandomAmount(Value);
            PostIt(Value);
        end;
    end;

    local procedure CreatePurchHeaderWithNumber10000(): Code[20]
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        with PurchaseHeader do begin
            Init;
            "Document Type" := "document type"::Invoice;
            Insert(true);
            SetHideValidationDialog(true);
            Validate("Pay-to Vendor No.", '10000');
            Validate("Buy-from Vendor No.", '10000');
            validate("Vendor Invoice No.", "No.");
            Modify(true);
            exit("No.");
        end;
    end;

    local procedure CreatePurchLinesWithRandomAmount(Value: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
        i: Integer;
    begin
        for i := 1 to 1 do
            with PurchaseLine do begin
                Init;
                "Document Type" := "Document Type"::Invoice;
                "Document No." := Value;
                "Line No." := i * 10000;
                Insert(true);
                //SetHideValidationDialog(TRUE);
                Validate(Type, Type::"G/L Account");
                Validate("No.", '60200');
                Validate("Quantity", 1);
                Validate("Direct Unit Cost", 60);
                Modify(true);
            end;
    end;

    local procedure PostIt(Value: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice, Value);
        PurchPost.Run(PurchaseHeader);
    end;

    local procedure FindDirectPostngAccount(): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        //EXIT('2720');
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetFilter("VAT Prod. Posting Group", '<>%1', '');
        GLAccount.FindFirst;
        exit(GLAccount."No.");
    end;

    local procedure FindVatPordPostingGroup(): Code[20]
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        VATProductPostingGroup.FindFirst;
        exit(VATProductPostingGroup.Code);
    end;
}

