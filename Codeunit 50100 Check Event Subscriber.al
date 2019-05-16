Codeunit 50100 "Check Event Subscriber"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(Objecttype::Table, 6188774, 'OnAfterInsertEvent', '', false, false)]
    local procedure PopulateMICRString(var Rec: Record "ForNAV Check Model"; RunTrigger: Boolean)
    begin
        //* Use This Event Subscriber if you want to populate the MICR String
        //* with data from the ForNAV Check Model
        //* If you want to add data outside the ForNAV Check Model you can do this
        //* by adding local variables in this event subscriber and read from those tables

        with Rec do begin
            "Micr Line" := AmountSymbol;
            "Micr Line" += GetCentsFromAmount(Rec.Amount);
            "Micr Line" += GetAmountPrefixedWithZeroes(Rec.Amount);
            "Micr Line" += AmountSymbol;
            "Micr Line" += GetBankRoutingNumber;
            "Micr Line" += GetBankAccountNumber;
        end;

        Rec."Micr Line" += ''
    end;

    [EventSubscriber(Objecttype::Table, 6188774, 'SetMICRLineEvent', '', false, false)]
    local procedure ManipulateMICRString(var Value: Text[100]; var Handled: Boolean)
    begin
        //* In this event you can manipulate the MICR String. If you do not want that but
        //* just use the value you have generated in the OnAfterInsert then leave the code here as-is.

        Value := Value;
        Handled := true;
    end;

    local procedure GetCentsFromAmount(Value: Decimal) Cents: Code[2]
    begin
        // Only Cents
        Value := Value - ROUND(Value, 1, '<');

        Cents := CopyStr(Format(Value), 1, 2);
        while StrLen(Cents) < 2 do
            Cents := '0' + Cents;
    end;

    local procedure GetAmountPrefixedWithZeroes(Value: Decimal) Amount: Code[13]
    begin
        Value := ROUND(Value, 1, '<');
        Amount := DelChr(Format(Value), '<>', '.,');
        while StrLen(Amount) < 13 do
            Amount := '0' + Amount;
    end;

    local procedure GetBankRoutingNumber(): Code[10]
    begin
    end;

    local procedure GetBankAccountNumber(): Code[20]
    begin
    end;

    local procedure AmountSymbol(): Code[1]
    begin
        exit('B');
    end;

    local procedure TransitSymbol(): Code[1]
    begin
        exit('A');
    end;

    local procedure NonUSSymbol(): Code[1]
    begin
        exit('C');
    end;

    local procedure DashSymbol(): Code[1]
    begin
        exit('D');
    end;
}

