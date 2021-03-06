/*
 * Copyright © 2013 Tom Beckmann <tomjonabc@gmail.com>
 *
 * Nemo vir est qui mundum non reddat meliorem.
 *
 *
 * This file is part of Final Term.
 *
 * Final Term is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Final Term is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Final Term.  If not, see <http://www.gnu.org/licenses/>.
 */

public class SettingsWindow : Gtk.Dialog {

	public SettingsWindow(FinalTerm application) {
		title = "Preferences";

		transient_for = application.main_window;

		add_buttons(Gtk.Stock.CLOSE, Gtk.ResponseType.CANCEL);

		var dimensions_columns = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
		var dimensions_rows = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
		var rows = new Gtk.SpinButton.with_range(10, 200, 1);
		var columns = new Gtk.SpinButton.with_range(10, 300, 1);

		rows.value = Settings.get_default().terminal_lines;
		rows.value_changed.connect(() => {
			Settings.get_default().terminal_lines = (int)rows.value;
		});

		columns.value = Settings.get_default().terminal_columns;
		columns.value_changed.connect(() => {
			Settings.get_default().terminal_columns = (int)columns.value;
		});

		dimensions_columns.pack_start(columns, false);
		dimensions_columns.pack_start(new Gtk.Label("columns"), false);
		dimensions_rows.pack_start(rows, false);
		dimensions_rows.pack_start(new Gtk.Label("rows"), false);

		var dark_look = new Gtk.Switch();
		dark_look.active = Settings.get_default().dark;
		dark_look.halign = Gtk.Align.START;
		dark_look.notify["active"].connect(() => {
			Settings.get_default().dark = dark_look.active;
		});

		var color_scheme = new Gtk.ComboBoxText();
		foreach (var color_scheme_name in FinalTerm.color_schemes.keys) {
			color_scheme.append(color_scheme_name, color_scheme_name);
		}
		color_scheme.active_id = Settings.get_default().color_scheme_name;
		color_scheme.changed.connect(() => {
			Settings.get_default().color_scheme_name = color_scheme.active_id;
		});

		var theme = new Gtk.ComboBoxText();
		foreach (var theme_name in FinalTerm.themes.keys) {
			theme.append(theme_name, theme_name);
		}
		theme.active_id = Settings.get_default().theme_name;
		theme.changed.connect(() => {
			Settings.get_default().theme_name = theme.active_id;
		});

		var opacity = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1);
		opacity.set_value(Settings.get_default().opacity * 100.0);
		opacity.value_changed.connect(() => {
			Settings.get_default().opacity = opacity.get_value() / 100.0;
		});

		var grid = new Gtk.Grid();
		grid.column_homogeneous = true;
		grid.column_spacing = 12;
		grid.row_spacing = 6;
		grid.margin = 12;

		grid.attach(create_header("General"), 0, 0, 1, 1);

		grid.attach(create_label("Default dimensions:"), 0, 1, 1, 1);
		grid.attach(dimensions_columns, 1, 1, 1, 1);
		grid.attach(dimensions_rows, 1, 2, 1, 1);

		grid.attach(create_header("Appearance"), 0, 3, 1, 1);

		grid.attach(create_label("Dark look:"), 0, 4, 1, 1);
		grid.attach(dark_look, 1, 4, 1, 1);

		grid.attach(create_label("Color scheme:"), 0, 5, 1, 1);
		grid.attach(color_scheme, 1, 5, 1, 1);

		grid.attach(create_label("Theme:"), 0, 6, 1, 1);
		grid.attach(theme, 1, 6, 1, 1);

		// This aligns quite badly at the center so we move it down
		// TODO: Even with bottom alignment this looks ugly
		var label = create_label("Opacity:");
		label.valign = Gtk.Align.END;
		grid.attach(label, 0, 7, 1, 1);
		grid.attach(opacity, 1, 7, 1, 1);

		get_content_area().add(grid);
	}

	private Gtk.Label create_header(string title) {
		var label = new Gtk.Label("<span weight='bold'>" + title + "</span>");
		label.use_markup = true;
		label.halign = Gtk.Align.START;
		return label;
	}

	private Gtk.Label create_label(string text) {
		var label = new Gtk.Label(text);
		label.halign = Gtk.Align.END;
		return label;
	}

}
