#                                                     Insights — Vendor / Supply Chain On-Time Delivery Scorecard:

## First Class is late 100% of the time  and that's actually the interesting part:

| Shipping Mode | Shipments | On-Time % | Avg Delay (days) | Std Dev |
|---|---|---|---|---|
| Standard Class | 107,752 | 60.23% | 0.00 | 1.42 |
| Same Day | 9,737 | 52.17% | 0.48 | 0.50 |
| Second Class | 35,216 | 20.27% | 1.99 | 1.42 |
| First Class | 27,814 | 0.00% | 1.00 | 0.00 |


Every single First Class shipment in the dataset missed its promised delivery date. Not most of them  all 27,814. Normally when I see a number that clean I assume it's a bug in the join or the delay calculation, so I checked the regional breakdown before trusting it.

It held up. Oceania, Western Europe, Eastern Asia, North Africa, South Asia  15 regions checked, every one showing exactly 100% late with a standard deviation of 0. That's the detail that convinced me this isn't a fluke: if it were a carrier problem or a regional logistics issue, you'd expect at least some spread  a few lucky regions, a few unlucky ones. Zero variance across that many shipments and that many geographies basically only happens one way: the SLA itself is wrong. Someone promised a 1-day delivery window that the fulfillment process can't physically hit, and every shipment misses it by the same fixed amount because the target was never achievable in the first place.

So this isn't a "which carrier do we drop" conversation. It's a "the promise on the label doesn't match reality" conversation,  which is a completely different fix (re-baseline the SLA, probably to 2 days based on how consistently it misses by exactly one) versus chasing carrier performance that was never going to solve it.

## Standard Class : the "slow" option  is quietly the best-run one:

Ironically, the tier with the longest promised window is the most dependable one in the portfolio. 60.23% on-time, and an average delay that nets out close to zero because early and late shipments roughly cancel out (though the ±1.42 day spread means individual shipments still swing a fair amount either direction  the average just hides that).

If I were setting realistic SLA targets for the other tiers, Standard Class is the number I'd anchor to. It's the one built on a promise the operation can actually keep.

## Second Class: is the one nobody's watching:
20.27% on time puts it second-worst overall, behind even Same Day, and it's carrying almost a 2-day average delay on top of that. It doesn't have Same Day's speed and it doesn't have Standard Class's reliability  right now it's the weakest tier in the lineup by a clear margin, and probably the easiest one to fix since it doesn't need the SLA rewritten, just the process tightened.

## Where the money is:

| Category | Late Shipments | Late Rate | Revenue at Risk |
|---|---|---|---|
| Fishing | 9,930 | 57.32% | $3,971,801.51 |
| Cleats | 14,076 | 57.33% | $2,533,078.74 |
| Camping & Hiking | 7,812 | 56.90% | $2,343,443.85 |
| Cardio Equipment | 7,110 | 56.94% | $2,099,461.62 |
| Women's Apparel | 12,017 | 57.13% | $1,798,600.00 |
| Water Sports | 8,891 | 57.21% | $1,781,861.14 |
| Indoor/Outdoor Games | 11,043 | 57.22% | $1,656,137.27 |
| Men's Footwear | 12,664 | 56.93% | $1,646,193.43 |
| Shop By Sport | 6,328 | 57.61% | $754,426.43 |
| Computers | 233 | 52.71% | $349,500.00 |

Just these ten categories account for roughly **$18.9M** tied up in late shipments. What stood out to me here wasn't any single category  it's that the late rate barely moves between them. Fishing gear, women's apparel, computers  they're all sitting in the same 53–58% band. If lateness were about how a category is packed or handled, you'd expect some categories to do noticeably better than others. They don't. That's the same signal as the regional data above: this is a shipping mode/infrastructure problem sitting underneath everything, not a product specific one.

## Bottom line:

The real bottleneck here isn't inconsistent vendor performance across the board  it's one broken promise (First Class) dragging down the numbers, plus one under-managed tier (Second Class) that's neither fast nor reliable. Standard Class proves the operation is capable of ~60% on-time performance when the target is realistic. The fix isn't "work harder across all tiers"  it's re-scope First Class to a deliverable window and figure out why Second Class is underperforming both its neighbors.
