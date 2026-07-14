

## Reviewer #1

**1. Hardware overhead per layer**  
- **Place:** Near end of Section II (Proposed Architecture), after the three layers.  
- **How:** Short bridge + FPGA cost (14 ALMs): mainly Layer 1 sensing and Layer 3 enables; versus BBM (3 ALMs) for autonomous failover.  
- **Search:** `Having described the three layers`

**2. Scalability (higher frequency / multi-clock)**  
- **Place:** Section III (Results), FPGA discussion after Table I.  
- **How:** High \(F_{\max}\) from lightweight three-layer structure; that structure can later support more clock sources.  
- **Search:** `more clock sources` / `lightweight three-layer structure`

**3. Failure detection threshold**  
- **Place:** Section II, Layer 1 (Activity Sensor).  
- **How:** Three cycles reduce false fails from short gaps while still detecting a true stall; simultaneous dual fail → no `fail`.  
- **Search:** `Three cycles reduce false fails`

**4. Readability of Figures 4 and 5**  
- **Place:** Section II — short RTL line near figures; shorter captions on block diagram and schematic.  
- **How:** Nets match RTL; captions name Layer 1/2/3 roles.  
- **Search:** `match the register-transfer level (RTL)` and schematic caption `Layer~1 \texttt{fail*}`

**5. Synthesis / implementation complexity**  
- **Place:** Section III (Results), after FPGA comparison (same paragraph block as scalability).  
- **How:** Structural Verilog; no dedicated PLL or third free-running reference clock; effort similar to BBM; CDC + `rst_n` for integration.  
- **Search:** `structural Verilog` / `phase-locked loop (PLL)`

---

## Reviewer #2

**1. Limitations / assumptions**  
- **Place:** Section II architecture open + Layer 1 + Table I footnote.  
- **How:** Partial dual-stop under reciprocal sensing; simultaneous dual-stop limit.  
- **Search:** `Partial dual-stop`

**2. Proofreading**  
- **Place:** Throughout (especially abstract).  
- **How:** Abstract aligned with Table I (14 ALMs, 515.46 MHz); first-use expansions (SoC, FPGA, ALMs, BBM, CDC, GFCM, RTL, PLL); grammar/ref cleanups.  
- **Search:** `14 adaptive logic modules (ALMs)` / `break-before-make (BBM)`

**3. Recent clock switching / CDC references**  
- **Place:** Section I (Related Work), after timer-based discussion.  
- **How:** One short sentence + cites `\cite{9470292,6142332,11424085}`.  
- **Search:** `Recent multi-clock and clock-domain crossing (CDC)`

**4. Industrial / SoC applications**  
- **Place:** Section IV (Conclusion), before future work.  
- **How:** One short flexible sentence (multi-clock SoCs, power gating / domain failure, glitch-free `clk_out`).  
- **Search:** `It can also be applied in multi-clock SoCs`

---


