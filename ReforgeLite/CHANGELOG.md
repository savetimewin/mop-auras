# ReforgeLite Classic

## [v3.0.0](https://github.com/brues-code/ReforgeLite/tree/v3.0.0) (2026-08-03)
[Full Changelog](https://github.com/brues-code/ReforgeLite/compare/v2.3.13...v3.0.0) [Previous Releases](https://github.com/brues-code/ReforgeLite/releases)

- Fix reforge cap overshoot with Amplification trinkets  
    Cap baselines were summed in raw (unamplified) space while reforge  
    option deltas and cap targets were amplified, so the solver overshot  
    Haste/Mastery/Spirit caps by an amount proportional to the existing  
    rating pool. Affected both the DP and Branch & Bound paths.  
    - Add GetBaselineStats to sum character base plus item stats in  
      amplified space; use it for cap init (DP), CalculatePriorityCap, and  
      the B&B starting stats  
    - Divide the conversion correction by mult[dst] so data.initial stays  
      uniformly raw  
    - Compute the Amplification factor from the unrounded server-side float  
      budget curve instead of the floored integer RandPropPoints table, so  
      it matches the game's applied value at every item level  
    Closes #58  
- clean json so we can print for debug  
- revert human spirit change  
- stop aliasing the shared classPresets table for the player's class  
    InitClassPresets set self.presets = classPresets[playerClass] (a shared  
    reference), so InitCustomPresets/Pawn polluted it and a later wipe()  
    cleared classPresets[playerClass] itself. Toggling debug then rebuilt  
    the player's class entry as a self-reference, making its submenu list  
    every other class. Populate the addon's own self.presets table by spec  
    instead of aliasing.  
- resolve function-valued spec presets in the preset menu  
    The class-level preset value is resolved with GetValueOrCallFunction, but  
    the per-spec loop used each preset raw -- so a function-valued spec preset  
    hit 'attempt to index a function value' when building the menu (and would  
    have errored on selection too, since the handler reads value.weights/caps).  
    Resolve each spec preset the same way.  
- fix B&B ignoring the 17th item slot on Cata  
    B&B hardcoded 16 item slots (MoP), but the Cata ranged slot makes 17.  
    It silently skipped slot 17, so it couldn't reforge that item and  
    returned a suboptimal result whenever the optimum used it (e.g. Shadow  
    Priest losing the Spirit->Mastery reforge there, scoring 404380 vs the  
    DP's 407630). Drive all slot counts from #data.method.items / #sortedSlots  
    so B&B covers every equipped slot. Validated B&B == DP on Cata.  
- print build info for algo compare  
- refactor amplification + Human Spirit into stat multipliers  
    Encapsulate AmplificationItems/RandPropPoints as locals behind  
    GetAmplificationFactor(itemInfo).  
    Move The Human Spirit (+3% Spirit) from a SPIRIT->SPIRIT conversion to a  
    proper stat multiplier.  
- cleanup  
- fix tooltip stat parsing on non-comma locales  
    getTooltipPatterns hardcoded [%d,] for the stat value, so it only  
    handled the enUS thousands separator. On deDE (separator '.') a value  
    like '+1.038 Willenskraft' captured just '1' and failed the match,  
    leaving the stat undetected -- corrupting GetItemStatsFromTooltip for  
    upgraded items (wrong reforge, and a stuck reforge from the bad index  
    count in DoReforgeUpdate). Build the digit class from the client's  
    LARGE\_NUMBER\_SEPERATOR so it works on every locale.  
- make GetStatScore iterate caps instead of hardcoding two  
- avoid per-branch stat-table copy in B&B search  
    Apply each reforge to currentStats in place and undo it after recursing,  
    instead of CopyTable-ing the whole stat table for every branch. Search  
    is unchanged (same node count, same result == DP); per-node cost drops  
    ~8% from eliminating the per-option allocation.  
- remove dead GetSmartReforgeOptions  
    B&B now uses GetFullReforgeOptions exclusively; the old smart-options  
    generator and its references are gone.  
- add best-effort B&B pass for infeasible cap configs  
    When the caps are unreachable (e.g. Hit AtMost below the reforge floor),  
    the constrained search prunes every branch and finds no solution, which  
    previously dropped to the full DP (~6min). Add a second pass with  
    constraint pruning relaxed: every complete path becomes a candidate and  
    the score bound keeps the highest-scoring (closest) one. Validated to  
    return the exact same best-effort solution as the DP (matching score) in  
    623 nodes vs the DP's 367s.  
- make Branch & Bound exact with a tighter joint bound  
    B&B previously searched only GetSmartReforgeOptions (one source stat per  
    item plus a few destinations), which excludes reforges the optimum needs  
    -- so it returned suboptimal results. Switch to full reforge enumeration  
    (GetFullReforgeOptions, deduped by cap effect) so B&B searches the same  
    space as the DP and reaches the true optimum.  
    To keep that tractable, add a joint per-item upper bound: each remaining  
    item is credited only its single best reforge (score + linear cap gains),  
    which is far tighter than the old frankenitem bound that summed  
    independently-maxed score/cap1/cap2 a single reforge can't all achieve.  
    Both bounds are kept and pruned on the min. Validated equal to DP on a  
    dual-AtLeast case in ~1/4 the time. Also guard a debug-only nil deref  
    when no feasible solution exists.  
- delete whitespace  
- fix amplification factor and trim rpp table  
    Derive the Amplify equip bonus from the actual in-game spell (146051,  
    coefficient 0.00177 on the Epic\_0 budget) and floor to match the  
    truncated tooltip percent, replacing the Round(rpp/420) approximation  
    that overshot at ilvl 528 (1.06 vs 1.05). Move the logic into  
    GetAmplificationFactor, and trim RandPropPoints to the single Epic\_0  
    value per ilvl since that column was the only one ever read.  
- method window height is now dynamic  
- cata: include ranged slot in calc  
- grant contents:write so packager can create GitHub releases  
    The default GITHUB\_TOKEN is read-only on newer repos, which would block  
    release creation; explicit permission ensures the tag release and zip  
    asset are published.  
- add GitHub Actions workflow to package and release on tag push  
    Runs the BigWigs packager on tag push (same release.sh path proven  
    working locally), uploading to CurseForge via CF\_API\_KEY and creating  
    a GitHub release via the built-in GITHUB\_TOKEN.  
- add release to git ignore  
- fix cap optimizer targeting 1 below displayed cap  
    The engine re-derived preset cap values with floor() while the UI  
    display/storage used ceil(), so the optimizer solved for AtLeast 960  
    when the cap shown was 961. Align the engine to max(0, ceil(getter())).  
- use currentlocale  
- ignore release folder  
- cleanup  
- refresh conversion before running calc  
- moved locales folder  
- unused in cata  
- revert  
- test  
- rename root file  
- rename cata toc  
- Ace3, LibStub shouldnt be optional libs  
- useless comment  
- removed 50503 from toc  
- Support 4.4.2 and 5.5.4 (#57)  
    * initial work  
    * reforge detection fixed  
    * dont need PLAYER\_SPECIALIZATION\_CHANGED anymore  
    * main toc will support cata if it ever gets updated  
    * no need to hide playerTalents if they never get shown  
    * temp fix to allow caps to update when switching specs. seems like a latency issue  
    * move compat functions to addonTable to stop polluting global  
    This was breaking LibFroznFunctions  
    * check if player has human spirit racial instead of checking their race  
    * move mists data to mists folder  
    * prevent cata client from loading unused locales  
    ---------  
    Co-authored-by: brues-code <5278969+brues-code@users.noreply.github.com>  
- staticpopup cleanup  
