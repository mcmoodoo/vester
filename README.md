## A time-unlocked vesting contract
Two actors: payer and receiver. A payer deposits X amounts of ERC20 tokens. A receiver can withdraw up to `X * days_elapsed/total_days`

## Progress
I think I got the receiver and payer confused in the test contract. Fix this first thing next time! And then test that the proper amount is withdrawn every time under different conditions and edge cases!

So, who is going to be the payer? The test smart contract? No! Just create specific addresses for each and use those with pranks! For clarity! This will avoid any confusion!

Fixed and cleared up in the test suite! General test cases pass, haven't gotten to the edge cases! Also, need to enforce formatting, naming and other linting rules! Need to use slither, static analysis, fuzzing with echidna or similar. Quite a few security precautions could be implemented to improve the resilience!


