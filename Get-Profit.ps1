function Get-Profit{
<#
.SYNOPSIS
    Calculates total profit for a set number of days and businesses
.DESCRIPTION
    Rolls 1d100 per day per business as specified. The result determines an amount to either subtract from or add to the total. The total is then output to the screen

    Roll Table Rules
    ----------------
    Roll 1d100 per (in-game) day to see how well the business does. 
    Collect your earnings when you can. 
    Maintainence cost is 5 gp/day. (Can be changed by altering $maint on LINE 92)

    1d100:
    <20    - Pay 1 ½ x maintenance cost
    21-30 - Pay 1x maintenance cost
    31-40 - Pay ½x maintenance cost
    41-60 - Business covers its own maintenance cost
    61-80 - Business earns a profit of 1d6x5 gp
    81-90 - Business earns a profit of 2d8x5 gp
    >91    - Business earns a profit of 3d10x5 gp
.PARAMETER Days
    Determines the number of days to calculate into the total
.PARAMETER Full
    Switch that shows roll output and subsequent currency calculation
.PARAMETER Businesses
    Determines the number of businesses to roll for (because one isn't enough)
.EXAMPLE
    PS C:\WINDOWS\system32> Get-Profit -days 2
    
    ---------------------------------------------------------------------
    Calculating Profits for 1 Business(es) for 2 days:
    ---------------------------------------------------------------------

    Profit for 2 days for 1 business(es) is: 5 gold
    
.EXAMPLE
    PS C:\WINDOWS\system32> Get-Profit -days 2 -Businesses 2
    
    ---------------------------------------------------------------------
    Calculating Profits for 2 Business(es) for 2 days:
    ---------------------------------------------------------------------

    Profit for 2 days for 2 business(es) is: 5 gold
    
.EXAMPLE
    PS C:\WINDOWS\system32> Get-Profit -days 2 -full
    
    ---------------------------------------------------------------------
    Calculating Profits for 1 Business(es) for 2 days:
    ---------------------------------------------------------------------

    rolling 1d100 : 82
    Business earns a profit of 32 gold

    rolling 1d100 : 83
    Business earns a profit of 18 gold

    Profit for 2 days for 1 business(es) is: 50 gold

.NOTES
    Author: Wabbadabba
    ChangeLog
    ---------
    1Oct18 -- Script completed and uploaded to Github
    2Oct18 -- Help comment added
    
    TODO
    ----
    - Add Silver/Copper conversion at final output
#>
    param(
        [int]$days = 1,
        [int]$Businesses = 1,
        [switch]$full
    )
    
    $banner= @'
    _______    ______   __     __  ______  __    __  ________          
|       \  /      \ |  \   |  \|      \|  \  |  \|        \         
| $$$$$$$\|  $$$$$$\| $$   | $$ \$$$$$$| $$\ | $$| $$$$$$$$         
| $$  | $$| $$__| $$| $$   | $$  | $$  | $$$\| $$| $$__             
| $$  | $$| $$    $$ \$$\ /  $$  | $$  | $$$$\ $$| $$  \            
| $$  | $$| $$$$$$$$  \$$\  $$   | $$  | $$\$$ $$| $$$$$            
| $$__/ $$| $$  | $$   \$$ $$   _| $$_ | $$ \$$$$| $$_____          
| $$    $$| $$  | $$    \$$$   |   $$ \| $$  \$$$| $$     \         
    \$$$$$$$  \$$   \$$     \$     \$$$$$$ \$$   \$$ \$$$$$$$$                                                                                                                                         
    _______   _______    ______   ________  ______  ________   ______  
|       \ |       \  /      \ |        \|      \|        \ /      \ 
| $$$$$$$\| $$$$$$$\|  $$$$$$\| $$$$$$$$ \$$$$$$ \$$$$$$$$|  $$$$$$\
| $$__/ $$| $$__| $$| $$  | $$| $$__      | $$     | $$   | $$___\$$
| $$    $$| $$    $$| $$  | $$| $$  \     | $$     | $$    \$$    \ 
| $$$$$$$ | $$$$$$$\| $$  | $$| $$$$$     | $$     | $$    _\$$$$$$\
| $$      | $$  | $$| $$__/ $$| $$       _| $$_    | $$   |  \__| $$
| $$      | $$  | $$ \$$    $$| $$      |   $$ \   | $$    \$$    $$
    \$$       \$$   \$$  \$$$$$$  \$$       \$$$$$$    \$$     \$$$$$$ 
                                                                    
---------------------------------------------------------------------

'@
    
    $totalDays = $days * $Businesses
    $daysRemaining = $totalDays
    $total = 0 
    
    # Change this to change maintanence cost
    $maint = 5
    
    Clear-Host
    Write-Host $banner
    Write-Host "Calculating Profits for $Businesses Business(es) for $totalDays days: `n
--------------------------------------------------------------------- `n"
    While($daysRemaining -gt 0){
        $roll = get-random -min 1 -max 101
        
        if ($roll -lt 21){
            $cost = $maint * 1.5
            $total -= $maint
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as maintanence cost `n"
            }

        }elseif($roll -gt 20 -and $roll -lt 31){
            $cost = $maint
            $total -= $maint
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as Maintanence Cost `n"
            }

        }elseif($roll -gt 30 -and $roll -lt 41){
            $cost = $maint * 0.5
            $total -= $maint
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as Maintanence Cost `n"
            }

        }elseif($roll -gt 40 -and $roll -lt 61){
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business covers it's own maintanence cost `n"
            }

        }elseif($roll -gt 60 -and $roll -lt 81){
            $gold = (get-random -min 1 -max 7) * 5
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }

        }elseif($roll -gt 80 -and $roll -lt 91){
            $gold = (get-random -min 1 -max 9) + 
                    (get-random -min 1 -max 9) * 5
            $total += $gold
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        
        }elseif($roll -gt 90 -and $roll -lt 101){
            $gold = (get-random -min 1 -max 11) + 
                    (get-random -min 1 -max 11) +
                    (get-random -min 1 -max 11) * 5
            $total += $gold
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        }
        $daysRemaining -= 1
    }

    Write-Host "Profit for $days days for $Businesses business(es) is: $total gold `n " -ForegroundColor Yellow
}
