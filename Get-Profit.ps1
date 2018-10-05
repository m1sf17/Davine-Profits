function Roll-Dice{
<#
.SYNOPSIS
    Outputs the total from one or multiple dice rolls.
.DESCRIPTION
    Parses string inputs into dice typoe and number of die. Gets random number within the bounds of the die selected. The sum of all rolls is output to the screen.
.PARAMTER Die
    String consistng of a number of die (the '1' in '1d20') and the type of die (the 'd20', signifying a 20 sided die)
#>
    param(
        [string]$die = '1d20'
    )

    [int]$multiplier, [int]$sides = $die.Split("d")
    $output = 0
    while($multiplier -gt 0){
        $result = (Get-Random -min 1 -max ($sides + 1))
        $output += $result
        $multiplier -= 1
    }

    $output
}


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
.PARAMETER Businesses
    Determines the number of businesses to roll for (because one isn't enough)
.PARAMETER Full
    Switch that shows roll output and subsequent currency calculation
.PARAMETER Maint
    Standard Maintanence Cost. Defaults to 5.

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
    3Oct18 -- Add businesses parameter
    
    TODO
    ----
    - Add Silver/Copper conversion at final output
#>
    param(
        [int]$days = 1,
        [int]$Businesses = 1,
        [int]$maint = 5,
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
    $silver = 50
    
    Clear-Host
    Write-Host $banner
    Write-Host "Calculating Profits for $Businesses Business(es) for $totalDays days: `n
--------------------------------------------------------------------- `n"
    While($daysRemaining -gt 0){
        $roll = Roll-Dice 1d100
        
        if ($roll -lt 21){
            $cost = $maint * 1.5
            $total -= $cost
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as maintanence cost `n"
            }

        }elseif($roll -gt 20 -and $roll -lt 31){
            $cost = $maint
            $total -= $cost
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as Maintanence Cost `n"
            }

        }elseif($roll -gt 30 -and $roll -lt 41){
            $cost = $maint * 0.5
            $total -= $cost
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
            $gold = (Roll-Dice '1d6') * 5
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }

        }elseif($roll -gt 80 -and $roll -lt 91){
            $gold = (Roll-Dice '2d8') * 5
            $total += $gold
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        
        }elseif($roll -gt 90 -and $roll -lt 101){
            $gold = (Roll-Dice '3d10') * 5
            $total += $gold
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        }
        $daysRemaining -= 1
    }

    [string]$totalString = $total

    if($total -ge 0 -and $totalString.Contains(".")) {
        $total -= 0.5
        Write-Host -ForegroundColor Yellow "Profit for $days days for $Businesses business(es) is: $total GP $silver SP `n "
    } elseif($totalString.Contains(".")){
        $total -= 0.5
        Write-Host -ForegroundColor Red "Loss for $days days for $Businesses business(es) is: $total GP -$silver SP `n "
    } elseif($total -ge 0){
        Write-Host -ForegroundColor Yellow "Profit for $days days for $Businesses business(es) is: $total GP `n "
    } else {
        Write-Host -ForegroundColor Red "Loss for $days days for $Businesses business(es) is: $total GP `n "
    }
}
