#!/usr/bin/env bash

function get_tmux_option() {
	local option=$1
	local default_value=$2
	local -r option_value=$(tmux show-option -gqv "$option")

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

function generate_left_side_string() {

	session_icon=$(get_tmux_option "@theme_session_icon" "⋅")
	left_separator=$(get_tmux_option "@theme_left_separator" "")
	transparent=$(get_tmux_option "@theme_transparent_status_bar" "false")

	if [ "$transparent" = "true" ]; then
		local separator_end="#[bg=default]#{?client_prefix,#[fg=${PALLETE[yellow]}],#[fg=${PALLETE[none]}]}${left_separator:?}#[none]"
	else
		local separator_end="#[bg=${PALLETE[bg_highlight]}]#{?client_prefix,#[fg=${PALLETE[yellow]}],#[fg=${PALLETE[green]}]}${left_separator:?}#[none]"
	fi

	echo "#[fg=${PALLETE[fg_gutter]},bold]#{?client_prefix,#[bg=${PALLETE[yellow]}],#[bg=${PALLETE[none]}]} ${session_icon} #S ${separator_end}"
}

function generate_inactive_window_string() {

	inactive_window_icon=$(get_tmux_option "@theme_plugin_inactive_window_icon" " ")
	zoomed_window_icon=$(get_tmux_option "@theme_plugin_zoomed_window_icon" " ")
	left_separator=$(get_tmux_option "@theme_left_separator" "")
	transparent=$(get_tmux_option "@theme_transparent_status_bar" "false")
	inactive_window_title=$(get_tmux_option "@theme_inactive_window_title" "#W ")

	if [ "$transparent" = "true" ]; then
		left_separator_inverse=$(get_tmux_option "@theme_transparent_left_separator_inverse" "")

		local separator_start="#[bg=default,fg=${PALLETE['none']}]${left_separator_inverse}#[bg=${PALLETE['none']},fg=${PALLETE['none']}]"
		local separator_internal="#[bg=${PALLETE['none']},fg=${PALLETE['none']}]${left_separator:?}#[none]"
		local separator_end="#[bg=default,fg=${PALLETE['none']}]${left_separator:?}#[none]"
	else
		local separator_start="#[bg=${PALLETE['dark5']},fg=${PALLETE['bg_highlight']}]${left_separator:?}#[none]"
		local separator_internal="#[bg=${PALLETE['dark3']},fg=${PALLETE['dark5']}]${left_separator:?}#[none]"
		local separator_end="#[bg=${PALLETE[bg_highlight]},fg=${PALLETE['dark3']}]${left_separator:?}#[none]"
	fi

	echo "${separator_start}#[fg=${PALLETE[none]}]#I #{?window_zoomed_flag,$zoomed_window_icon,$inactive_window_icon}${inactive_window_title}"
}

function generate_active_window_string() {

	active_window_icon=$(get_tmux_option "@theme_plugin_active_window_icon" " ")
	zoomed_window_icon=$(get_tmux_option "@theme_plugin_zoomed_window_icon" " ")
	pane_synchronized_icon=$(get_tmux_option "@theme_plugin_pane_synchronized_icon" "✵")
	left_separator=$(get_tmux_option "@theme_left_separator" "")
	transparent=$(get_tmux_option "@theme_transparent_status_bar" "false")
	active_window_title=$(get_tmux_option "@theme_active_window_title" "#W ")

	if [ "$transparent" = "true" ]; then
		left_separator_inverse=$(get_tmux_option "@theme_transparent_left_separator_inverse" "")
		
		separator_start="#[bg=default,fg=${PALLETE['none']}]${left_separator_inverse}#[bg=${PALLETE['none']},fg=${PALLETE['none']}]"
		separator_internal="#[bg=${PALLETE['magenta']},fg=${PALLETE['none']}]${left_separator:?}#[none]"
		separator_end="#[bg=default,fg=${PALLETE['none']}]${left_separator:?}#[none]"
	else
		separator_start="#[bg=${PALLETE['none']},fg=${PALLETE['bg_highlight']}]${left_separator:?}#[none]"
		separator_internal="#[bg=${PALLETE['purple']},fg=${PALLETE['magenta']}]${left_separator:?}#[none]"
		separator_end="#[bg=${PALLETE[bg_highlight]},fg=${PALLETE['purple']}]${left_separator:?}#[none]"
	fi

	echo "${separator_start}#[fg=${PALLETE[magenta]}]#I #{?window_zoomed_flag,$zoomed_window_icon,$active_window_icon}${active_window_title}#{?pane_synchronized,$pane_synchronized_icon,}#[none]"
}
