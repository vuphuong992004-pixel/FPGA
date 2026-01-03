//upgrade for the proposed way:
- be able to apply fsm and synchronize with sel. This way seems like in the paper that contain model_three. You guys can totally check the image of model in model_three folder
- Here's my idea to solve the problem both of two clock get stuck at high level when counter have not reached to threshold yet (I set threshold here is 3):
  + I think I can apply some combinational logic for clk_out to checkout when count goes from 0 to 2.
  + Or maybe, this thinking path is not good. I will all of this thinking into trash and find a new way from flipflop couple cross.
