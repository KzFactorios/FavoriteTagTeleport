Allow for icons to be added within a text box

To implement a button in the text box to add an icon to the text, you can create a GUI that includes:

A text-box for entering or displaying the text. A button next to the text-box to open a dropdown or picker for selecting an icon. A list or grid of available icons in a pop-up window (e.g., frame or flow). Logic to insert the chosen icon into the text. Steps to Implement the Icon Picker

Create the Main GUI Add a text-box and a button to open the icon picker.

Handle Button Click When the button is clicked, display a list of icons (e.g., in a frame or scroll-pane).

Insert the Icon into the Text When the user selects an icon, append the corresponding rich text tag (e.g., [img=item/iron-plate]) to the text-box.

 How It Works Main Frame:

A text-box for entering text. A button to open the icon picker. Icon Picker:

A dynamically populated list of icons displayed as sprite-buttons. Icons are displayed using their corresponding rich text format (e.g., item/). Rich Text Insertion:

When an icon is selected, its rich text tag (e.g., [img=item/iron-plate]) is appended to the text-box text. Cleanup:

The icon picker frame is closed after an icon is selected. Customization Options Dynamic Icon Lists: Populate the list of icons from game.item_prototypes, game.virtual_signal_prototypes, or game.fluid_prototypes to include all available icons dynamically. Searchable Picker: Add a text-box above the icon grid to filter icons by name. Custom Categories: Separate icons into tabs or groups for better organization. Example of Dynamic Icon List To dynamically populate all item icons:

lua Copy code for name, prototype in pairs(game.item_prototypes) do scroll_pane.add{ type = "sprite-button", name = "icon_picker_" .. name, sprite = "item/" .. name, tooltip = name } end This approach provides a complete replication of the chart tag editor's icon functionality.