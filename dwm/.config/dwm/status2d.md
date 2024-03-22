# Status2d
## Usage

-   **^rx,y,w,h^** Draw a rectangle of width w and height h, with its top left corner at (x,y) relative the X drawing cursor.

-   **^c#FF0000^** Set foreground color.

-   **^b#55cdfc^** Set background color, only applies to text, simply use the ^r^ command to change the background while drawing.

-   **^f<px>^** Forward the X drawing cursor by <px> pixel. Please bear in mind that you have to move the cursor enough to display your drawing (by the with of your drawing).

-   **^d^** Reset colors to SchemeNorm.

-   **^C<num>^** Set foreground color to terminal color 0-15. Requires the xrdb sub-patch above.

-   **^B<num>^** Set background color to terminal color 0-15. Requires the xrdb sub-patch above.

-   **^w^** Swaps the current foreground/background colors. Useful when drawing multiple rectangles on top of one another. Requires the swap-save-restore sub-patch above.

-   **^v^** Saves the current color scheme so it can be restored later with the **^t^** tag. This way a script can modify color in the middle of the bar agnostic to what color was set previously. Requires the swap-save-restore sub-patch above.

-   **^t^** Restores the last color scheme saved by the **^v^** tag. Requires the swap-save-restore sub-patch above.

## Example

`xsetroot -name "[status2d] ^c#FF0000^red text with blue rectangle^c#55cdfc^^r3,3,14,14^^f20^^c#FFFFFF^^b#f7a8b8^ and white text on pink background "`

### Steps to draw a battery icon (ajust the values to fit your setup)

Draw the nose: `"^r00,07,02,04^"` Draw the battery: `"^r02,04,22,10^"` Fill it so that the border stays: `"^c#000000^^r03,05,20,08^"` Fill it with the remaining capacaty: `"^c#ffffff^^r10,05,13,08^"` Reset the colorscheme and forward the cursor: `"^d^^f24^"`

Put it all together: `xsetroot -name "^r0,7,2,4^^r2,4,22,10^^c#000000^^r3,5,20,8^^c#ffffff^^r10,5,13,8^^d^^f24^"`
