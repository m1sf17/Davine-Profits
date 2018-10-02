<#
Roll 1d100 per (in-game) day to see how well the business does. Collect your earnings when you can. Maintainence cost is 5 gp/day.

d100 - Result

<20    - Pay 1 ½ x maintenance cost
21-30 - Pay 1x maintenance cost
31-40 - Pay ½x maintenance cost
41-60 - Business covers its own maintenance cost
61-80 - Business earns a profit of 1d6x5 gp
81-90 - Business earns a profit of 2d8x5 gp
>91    - Business earns a profit of 3d10x5 gp
#>


function Get-Profit{
    param(
        [int]$days,
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

    $totalDays = $days
    $total = 0 
    
    $maint = 5
    Clear-Host
    Write-Host $banner
    Write-Host "Calculating Profits for 1 Business for $totalDays days: `n
--------------------------------------------------------------------- `n"
    While($days -gt 0){
        $roll = get-random -min 1 -max 101
        

        if ($roll -lt 21){
            $cost = $maint * 1.5
            $total -= $maint
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as maintanence cost `n"
            }

        }elseif($roll -gt 20 -and $roll -lt 31){
            $cost = $maint
            $total -= $maint
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as Maintanence Cost `n"
            }

        }elseif($roll -gt 30 -and $roll -lt 41){
            $cost = $maint * 0.5
            $total -= $maint
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Pay $cost gold as Maintanence Cost `n"
            }

        }elseif($roll -gt 40 -and $roll -lt 61){
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business covers it's own maintanence cost `n"
            }

        }elseif($roll -gt 60 -and $roll -lt 81){
            $gold = (get-random -min 1 -max 7) * 5
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }

        }elseif($roll -gt 80 -and $roll -lt 91){
            $gold = (get-random -min 1 -max 9) + 
                    (get-random -min 1 -max 9) * 5
            $total += $gold
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        
        }elseif($roll -gt 90 -and $roll -lt 101){
            $gold = (get-random -min 1 -max 11) + 
                    (get-random -min 1 -max 11) +
                    (get-random -min 1 -max 11) * 5
            $total += $gold
            $days = $days - 1
            if ($full){
                Write-Host "rolling 1d100 : $roll"
                Write-Host "Business earns a profit of $gold gold `n"
            }
        }
    }

    Write-Host "Profit for $totalDays days is: $total gold `n " -ForegroundColor Yellow
}
