#comments for model_two_advanced.
Using this clk to reference other clk and combining with FSM is my idea. However, bugs here are not synchronize with variable 'sel' and both clk1 and clk2 die (at high level too long).
I will try to refer from model_three (with 8 flipflops) and try to fix the problem "synchronize with variable 'sel'" first. 
