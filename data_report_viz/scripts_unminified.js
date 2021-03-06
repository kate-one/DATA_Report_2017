function main(t, e, r, a) {
    console.log(t, r);
    (window_width = d3.select(t)[0][0].offsetWidth) <= break_point_mobile ? (buttonWidth = 60, togglebuttonWidth = 250, window_height = 2200, grid_margin_left = 10) : window_width <= break_point_tablet ? (buttonWidth = 120, togglebuttonWidth = 250, grid_margin_left = 20, window_height = 2200) : window_width <= break_point_desktop ? (togglebuttonWidth = 250, grid_margin_left = 40, buttonWidth = 120, window_height = 1200) : window_width > break_point_desktop && (togglebuttonWidth = 250, grid_margin_left = 40, buttonWidth = 120, window_height = 1200);
    var o = window_height;
    target_bar_height = 70, columnWidth = (sidebar_width = window_width / 2 - side_bar_margins) / 3, tablerowHeight = 50, context_chart_width = window_width / 2, context_chart_height = 10 * barHeight + 2 * row_chart_margin_top, context_chart_group_height = context_chart_height + page_margin_top, row_chart_width = context_chart_width - context_chart_margins, xScale = d3.scale.linear().range([0, row_chart_width]), xScaleODAGNI = d3.scale.linear().range([0, row_chart_width]), yScale = d3.scale.ordinal().rangeRoundBands([bar_chart_height, 0], .1), targetChartXScale = d3.scale.linear().range([0, sidebar_width]), xAxis = d3.svg.axis().scale(xScale).orient("bottom").ticks(5), yAxis = d3.svg.axis().scale(yScale).orient("left"), countryProfileSVG = d3.select(t).append("svg").attr("width", window_width).attr("height", window_height).attr("id", "countryProfile"), tooltip = d3.select("body").append("div").attr("class", "tooltip").style("opacity", 0), gridTitle = countryProfileSVG.append("text").attr("class", "grid_title").attr("x", grid_margin_left).attr("y", 70), gridiNTRO = countryProfileSVG.append("text").attr("class", "paragraph").attr("x", grid_margin_left).attr("y", 130), gridGroup = countryProfileSVG.append("svg:g").attr("transform", "translate(" + grid_margin_left + "," + title_section + ")"), countryProfileGroup = countryProfileSVG.append("svg:g").attr("id", "countryProfileGroup").style("visibility", "hidden"), profileOverlay = countryProfileGroup.append("rect").attr("width", window_width).attr("height", window_height).attr("fill", "white").style("opacity", 1), country_profile_title = countryProfileGroup.append("text").attr("x", page_margin_left).attr("y", title_height).attr("class", "profile_title"), country_profile_close_button = countryProfileGroup.append("text").attr("x", window_width - 20).attr("y", title_margin_left + 40).attr("class", "close_button").attr("text-anchor", "end").on("click", function() {
        closeCountryProfile()
    }).on("mouseover", function() {
        d3.select(this).classed("close_button_hover", !0)
    }), context_chart_group = countryProfileGroup.append("g").attr("width", context_chart_width).attr("class", "canvas").attr("transform", "translate(" + page_margin_left + "," + page_margin_top + ")"), row_chart_group = context_chart_group.append("g").attr("class", "rowchart").attr("transform", "translate(0," + row_chart_margin_top + ")"), row_chart_yaxis = row_chart_group.append("g").attr("class", "y axis"), row_chart_xaxis = row_chart_group.append("g").attr("class", "x axis").attr("transform", "translate(0," + bar_chart_height + ")"), sidebar = countryProfileGroup.append("g").attr("width", sidebar_width).attr("height", o).attr("transform", "translate(" + context_chart_width + "," + page_margin_top + ")").attr("class", "sidebar"), sideBarText = sidebar.append("svg:foreignObject").attr("width", sidebar_width).attr("height", o), d3.json(a, function(t, e) {
        console.log("Data is loaded"), console.log(e), console.log(r), countryProfileData = e.data_one, annotationData = e.annotations[r], "english" == r && (formatThousands = d3.format(",.2f"), formatRounded = d3.format(",.0f")), "french" == r && (formatThousands = d3.format(",.2f"), formatRounded = d3.format(",.0f")), "german" == r && (formatThousands = d3.format(",.2f"), formatRounded = d3.format(",.0f")), console.log(annotationData), drawGrid(countryProfileData, annotationData, r), drawHeaders(annotationData, countryProfileData), drawTargetChart(), drawRowChart(countryProfileData.Australia, annotationData), updateSidebar(countryProfileData.Australia, annotationData), checkWindowize(), window.onresize = checkWindowize
    }), checkWindowize = function() {
        (window_width = d3.select(t)[0][0].offsetWidth) <= break_point_mobile ? (console.log("mobile"), new_coxcomb_width = window_width - 80, new_sidebar_width = window_width, window_height = 3e3, sidebarTranslate = "translate(10," + (context_chart_group_height + page_margin_top + 150) + ")", d3.select(t).style("height", window_height + "px"), resize_country_profile_smallScreen(window_width, new_coxcomb_width, new_sidebar_width, sidebarTranslate, window_height)) : window_width <= break_point_tablet ? (console.log("tablet"), new_coxcomb_width = window_width - 110, new_sidebar_width = window_width - 20, window_height = 2200, d3.select(t).style("height", window_height + "px"), sidebarTranslate = "translate(20," + (context_chart_group_height + page_margin_top) + ")", resize_country_profile_smallScreen(window_width, new_coxcomb_width, new_sidebar_width, sidebarTranslate, window_height)) : window_width <= break_point_desktop ? (console.log("desktop"), new_coxcomb_width = window_width / 2 - context_chart_margins, new_sidebar_width = window_width / 2 - side_bar_margins, window_height = 1200, d3.select(t).style("height", window_height + "px"), sidebarTranslate = "translate(" + (new_coxcomb_width + context_chart_margins + 30) + "," + page_margin_top + ")", resize_country_profile_smallScreen(window_width, new_coxcomb_width, new_sidebar_width, sidebarTranslate, window_height)) : window_width > break_point_desktop ? (console.log("large screen"), new_coxcomb_width = window_width / 2 - context_chart_margins, new_sidebar_width = window_width / 2 - side_bar_margins, sidebarTranslate = "translate(" + (new_coxcomb_width + context_chart_margins + 30) + "," + page_margin_top + ")", window_height = 1200, d3.select(t).style("height", window_height + "px"), resize_country_profile_smallScreen(window_width, new_coxcomb_width, new_sidebar_width, sidebarTranslate, window_height)) : console.log("something else going on here")
    }
}

function resize_country_profile_smallScreen(t, e, r, a, o) {
    countryProfileSVG.attr("width", t).attr("height", o), profileOverlay.attr("width", t).attr("height", window_height), country_profile_close_button.attr("x", t - 20), resizeSidebar(r), updateGrid(), resizeRowChart(e)
}

function resizeSidebar(t) {
    sidebar.attr("width", t).attr("transform", sidebarTranslate), sideBarText.attr("width", t), selectorGroup.attr("transform", "translate(0," + (context_chart_height + page_section_padding) + ")"), targetChartXScale = d3.scale.linear().domain([0, .01]).range([0, t]), targetBar.attr("width", targetChartXScale(.007)), targetBarValue.attr("width", function(t) {
        return targetChartXScale(t)
    }), targetBarMarker.attr("x", targetChartXScale(.007)), targetBarText.attr("x", targetChartXScale(.007) + 10), targetValueMet.attr("x", 10), targetBarValueText.attr("x", targetChartXScale(.007) + 10), value_switch_group.attr("transform", "translate(0," + (keyStatisticsSectionTop - 20) + ")"), new_columnWidth = (t - 20) / 3, d3.selectAll(".column01").text(""), d3.selectAll(".column01").text(function(t) {
        return t
    }).attr("x", new_columnWidth / 2).call(wrapTableCol01, new_columnWidth), console.log("new column width = " + new_columnWidth), new_columnWidth < 130 ? d3.selectAll(".column01").attr("transform", "translate(0,-10)") : d3.selectAll(".column01").attr("transform", "translate(0,0)"), d3.selectAll(".column02").attr("x", new_columnWidth + new_columnWidth / 2), d3.selectAll(".column03").attr("x", 2 * new_columnWidth + new_columnWidth / 2), d3.selectAll(".table_header").text(""), d3.selectAll(".table_header").attr("x", function(t) {
        return new_columnWidth * (t - 1) + new_columnWidth / 2
    }).text(function(t, e) {
        return annotationData.country_profile_page["key_stats_table_header_" + t + "_title"]
    }).call(wrapTable, new_columnWidth), d3.selectAll(".tableBackgroundRect").attr("width", t - mobile_page_padding), d3.selectAll(".tableBorderRect").attr("width", t - mobile_page_padding), d3.selectAll(".table_arrows").attr("x", 2 * new_columnWidth + new_columnWidth / 3 - 30), d3.selectAll(".tablesource").text(""), d3.selectAll(".tablesource").text(function(t) {
        return " " + t
    }).call(wrapEffectsSource01, t), void 0 != recommendations.datum() && (recommendations.text(""), recommendations.text(function(t) {
        return t
    }).call(wrapEffects02, t + 40), recommendations02.text(""), recommendations02.text(function(t) {
        return t
    }).call(wrapEffects02, t + 40), recommendations03.text(""), recommendations03.text(function(t) {
        return t
    }).call(wrapEffects02, t + 40)), recommendations_section_02_pos = 21 * d3.select("#recommendations_section_01").selectAll("tspan")[0].length + 10, recommendations_section_03_pos_01 = 21 * d3.select("#recommendations_section_02").selectAll("tspan")[0].length + 10, recommendations_section_03_pos = recommendations_section_03_pos_01 + recommendations_section_02_pos, d3.select("#recommendations_section_02").attr("transform", "translate(0," + recommendations_section_02_pos + ")"), d3.select("#recommendations_section_03").attr("transform", "translate(0," + recommendations_section_03_pos + ")")
}

function resizeRowChart(t) {
    xScale.range([0, t]), xScaleODAGNI.range([0, t]), yScale.rangeRoundBands([0, bar_chart_height], .1), row_chart_xaxis.call(xAxis), row_chart_oda_bars.attr("width", function(t) {
        return xScale(t[contextChartValue_All_ODA])
    }), oda_bars_text.attr("x", function(t) {
        return xScale(t[contextChartValue_All_ODA]) < 135 ? xScale(t[contextChartValue_All_ODA]) + 10 : xScale(t[contextChartValue_All_ODA]) - 10
    }).attr("text-anchor", function(t) {
        return xScale(t[contextChartValue_All_ODA]) < 135 ? "start" : "end"
    }).attr("class", function(t) {
        return xScale(t[contextChartValue_All_ODA]) < 135 ? "oda_bar_text_highlight row_bar_oda_text" : "oda_bar_text row_bar_oda_text"
    });
    for (var e = 0; e < aid_types.length; e++) resizeAidTypeRects(e);
    d3.selectAll(".source").text(""), d3.selectAll(".source").text(function(t) {
        return " " + t
    }).call(wrapEffectsSource01, t + 60), oda_legend_position = t - (110 + context_chart_legend_rect_width) - 20, odalegendText.attr("x", t - 120), odalegendBox.attr("x", oda_legend_position), legendBox.attr("x", oda_legend_position - 100 - context_chart_legend_rect_width - 10), legendText.attr("x", oda_legend_position - 100), context_chart_target_toggle_title.attr("x", togglebuttonWidth / 2), context_chart_target_toggle_button.attr("x", 0), window_width < break_point_tablet ? (d3.selectAll(".toggleChartGroup").attr("transform", "translate(-80," + (context_chart_height + 30) + ")"), d3.selectAll(".rowchart").attr("transform", "translate(-40, " + row_chart_margin_top + ")"), d3.selectAll(".target_switch").attr("transform", "translate(-40, 0)"), d3.selectAll(".main_subtitle").attr("transform", "translate(-40, 0)"), d3.selectAll(".profile_title").attr("transform", "translate(-40, 0)"), context_chart_target_toggle_title.attr("transform", "translate(-40, 0)")) : (d3.selectAll(".toggleChartGroup").attr("transform", "translate(0," + (context_chart_height + 30) + ")"), d3.selectAll(".rowchart").attr("transform", "translate(0, " + row_chart_margin_top + ")"), d3.selectAll(".target_switch").attr("transform", "translate(0, 0)"), d3.selectAll(".main_subtitle").attr("transform", "translate(0, 0)"), d3.selectAll(".profile_title").attr("transform", "translate(0, 0)"), context_chart_target_toggle_title.attr("transform", "translate(0, 0)"))
}

function toggleAidLayers(t, e) {
    thisbutton = d3.select(t), d3.selectAll(".row_bar_text").text(function(t) {
        return ""
    }), d3.selectAll(".row_chart_rect").attr("width", 0).classed("active_row_bar", !1), d3.selectAll(".row_chart_rect").transition().attr("width", 0).each("end", function() {
        drawAidTypeRects(e)
    }), d3.selectAll(".aidSelectorRect").classed("active_aid_type_button", !1), thisbutton.classed("active_aid_type_button", !0), legendBox.classed("hidden", !1).attr("id", e), legendText.classed("hidden", !1).text(function() {
        return "In_Donor_Refugee_Costs" === e ? annotationData.country_profile_page.context_chart_button_3 : "LDC_ODA" === e ? annotationData.country_profile_page.context_chart_button_1 : annotationData.country_profile_page.context_chart_button_2
    })
}

function drawHeaders(t, e) {
    country_profile_close_button.text(t.country_profile_page.close_profile), gridTitle.text(t.selector_page.title), gridiNTRO.text(t.selector_page.intro_line), selectorGroup = context_chart_group.append("g").attr("class", "toggleChartGroup").attr("transform", "translate(" + page_margin_left + "," + context_chart_height + ")"), selectorGroup.append("text").attr("x", 0).attr("y", 0).attr("class", "subtitle_small").text(t.country_profile_page.context_chart_selector), selectorGroup.append("text").datum(t.country_profile_page.context_chart_source).attr("y", selector_group_height + 20).attr("x", 0).attr("class", "source").text(t.country_profile_page.context_chart_source).call(wrapEffectsSource01, row_chart_width), aid_types.forEach(function(e, r) {
        selectorGroup.append("rect").attr("y", 10).attr("x", (buttonWidth + 10) * r).attr("width", buttonWidth).attr("height", buttonHeight).attr("id", e.name).attr("class", "aidSelectorRect").on("click", function() {
            toggleAidLayers(this, e.name)
        }).on("mouseover", function() {
            tooltip.transition().duration(200).style("opacity", .9), tooltip.html(function() {
                return "LDC_ODA" === e.name ? t.country_profile_page.explanation_LDC : "Africa_ODA" === e.name ? t.country_profile_page.explanation_Africa : t.country_profile_page.explanation_IDRC
            }).style("left", d3.event.pageX + "px").style("top", d3.event.pageY - 28 + "px")
        }).on("mouseout", function() {
            tooltip.transition().duration(200).style("opacity", 0), tooltip.html("")
        }), selectorGroup.append("text").attr("y", buttonHeight / 2 + 15).attr("x", (buttonWidth + 10) * r + buttonWidth / 2).attr("class", "bar_chart_label").attr("text-anchor", "middle").text(t.country_profile_page["context_chart_button_" + (r + 1)]).on("click", function() {})
    }), aid_over_time_title = context_chart_group.append("text").attr("x", 0).attr("y", 0).attr("class", "subtitle main_subtitle").attr("text-anchor", "start").text(t.country_profile_page.context_chart_title), context_chart_target_toggle_button = context_chart_group.append("rect").attr("y", row_chart_toggle_position_y - buttonHeight / 1.5).attr("x", row_chart_width - togglebuttonWidth).attr("width", togglebuttonWidth + 5).attr("height", buttonHeight).attr("class", "button target_switch").attr("id", "").on("click", function() {
        if (d3.select(this).classed("active")) {
            odalegendText.text(t.country_profile_page.context_chart_legend_1), d3.select(this).classed("active", !1), context_chart_target_toggle_title.text(t.country_profile_page.context_chart_toggle_1), d3.selectAll(".oda_bar_text").transition().duration(duration).attr("x", function(t) {
                return xScale(t[contextChartValue_All_ODA]) < 135 ? xScale(t[contextChartValue_All_ODA]) + 10 : xScale(t[contextChartValue_All_ODA]) - 10
            }).attr("text-anchor", function(t) {
                return xScale(t[contextChartValue_All_ODA]) < 135 ? "start" : "end"
            }).attr("class", function(t) {
                return xScale(t[contextChartValue_All_ODA]) < 135 ? "oda_bar_text_highlight row_bar_oda_text" : "oda_bar_text row_bar_oda_text"
            }).text(function(e) {
                MoneyFormat(e[contextChartValue_All_ODA]);
                return "$" + formatThousands(e[contextChartValue_All_ODA] / 1e3) + " " + t.country_profile_page.billions
            }), d3.selectAll(".row_chart_oda_rect").transition().duration(duration).attr("width", function(t) {
                return xScale(t[contextChartValue_All_ODA])
            });
            r = d3.select(".active_aid_type_button").attr("id");
            e = "In_Donor_Refugee_Costs" === r ? "In_Donor_Refugee_Over_All_ODA" : r + "_Over_All_ODA", d3.selectAll("." + r).transition().duration(duration).attr("width", function(t) {
                return xScale(t[r])
            }), d3.selectAll(".row_bar_text").text(function(t) {
                return percentFormat(t[e])
            })
        } else {
            odalegendText.text(t.country_profile_page.context_chart_legend_2), d3.select(this).classed("active", !0), context_chart_target_toggle_title.text(t.country_profile_page.context_chart_toggle_2), d3.selectAll(".oda_bar_text").transition().duration(duration).attr("x", function(t) {
                return xScaleODAGNI(t[contextChartValue_ODA_over_GNI]) < 135 ? xScaleODAGNI(t[contextChartValue_ODA_over_GNI]) + 10 : xScaleODAGNI(t[contextChartValue_ODA_over_GNI]) - 10
            }).attr("text-anchor", function(t) {
                return xScaleODAGNI(t[contextChartValue_ODA_over_GNI]) < 135 ? "start" : "end"
            }).attr("class", function(t) {
                return xScaleODAGNI(t[contextChartValue_ODA_over_GNI]) < 135 ? "oda_bar_text_highlight row_bar_oda_text" : "oda_bar_text row_bar_oda_text"
            }).text(function(t) {
                return percentFormat(t[contextChartValue_ODA_over_GNI])
            }), d3.selectAll(".row_chart_oda_rect").transition().duration(duration).attr("width", function(t) {
                return xScaleODAGNI(t[contextChartValue_ODA_over_GNI])
            });
            var e, r = d3.select(".active_aid_type_button").attr("id");
            e = "In_Donor_Refugee_Costs" === r ? "In_Donor_Refugee_Over_All_ODA" : r + "_Over_All_ODA", d3.selectAll("." + r).transition().duration(duration).attr("width", function(t) {
                return t.percentage_over_oda_gni = t[e] * t[contextChartValue_ODA_over_GNI], xScaleODAGNI(t.percentage_over_oda_gni)
            }), d3.selectAll(".row_bar_text").text(function(t) {
                return t.percentage_over_oda_gni = t[e] * t[contextChartValue_ODA_over_GNI], percentFormat(t.percentage_over_oda_gni)
            })
        }
    }), context_chart_target_toggle_title = context_chart_group.append("text").attr("y", row_chart_toggle_position_y).attr("dy", "-0.2em").attr("class", "buttonText").attr("text-anchor", "middle").text(t.country_profile_page.context_chart_toggle_1), legendGroup = context_chart_group.append("g").attr("transform", "translate(0," + row_chart_legend_position_y + ")"), context_chart_legend_rect_width = 20, legendBox = legendGroup.append("rect").attr("x", 0).attr("y", -18).attr("width", context_chart_legend_rect_width).attr("height", 20).classed("hidden", !0), legendText = legendGroup.append("text").attr("x", 75).attr("y", 0).attr("fill", "black").text("key value").attr("class", "legendText").classed("hidden", !0), odalegendBox = legendGroup.append("rect").attr("x", row_chart_width - (110 + context_chart_legend_rect_width)).attr("y", -18).attr("class", "row_chart_oda_rect_legend").attr("width", context_chart_legend_rect_width).attr("height", 20).attr("text-anchor", "start"), odalegendText = legendGroup.append("text").attr("x", row_chart_width - 110).attr("y", 0).text(t.country_profile_page.context_chart_legend_1).attr("class", "legendText").attr("text-anchor", "start").attr("fill", "black"), sidebar.append("text").attr("x", sidebar_padding_left).attr("y", 0).attr("class", "subtitle").text(t.country_profile_page.target_chart_title), sidebar.append("text").attr("x", sidebar_padding_left).attr("y", keyStatisticsSectionTop).attr("class", "subtitle").text(t.country_profile_page.key_stats_table_title), value_switch_group = sidebar.append("g").attr("transform", "translate(0," + keyStatisticsSectionTop + ")"), usd_toggles = value_switch_group.append("rect").attr("y", 30).attr("x", 0).attr("width", buttonWidth).attr("height", buttonHeight).attr("class", "button value_switch").attr("id", "USD"), d3.selectAll("#USD").classed("active", !0).on("click", function() {
        d3.selectAll(".national_currency").classed("active", !1), d3.select(this).classed("active", !0), switchTableCurrencyUSD(activeCountryData, t)
    }), national_currency_toggle = value_switch_group.append("rect").attr("y", 30).attr("x", buttonWidth + 0).attr("width", buttonWidth).attr("height", buttonHeight).attr("class", "button value_switch national_currency"), national_currency_toggle.on("click", function() {
        d3.selectAll("#USD").classed("active", !1), d3.select(this).classed("active", !0), switchTableCurrency(activeCountryData, t)
    }), value_switch_text = value_switch_group.append("text").attr("y", 57.5).attr("x", buttonWidth + buttonWidth / 2).attr("dy", "-0.1em").attr("width", buttonWidth).attr("height", buttonHeight).attr("text-anchor", "middle").attr("class", "buttonText currency_switch"), usd_currency_button = value_switch_group.append("text").datum("USD").attr("y", 57.5).attr("x", buttonWidth / 2).attr("dy", "-0.1em").attr("width", buttonWidth).attr("height", buttonHeight).attr("text-anchor", "middle").attr("class", "buttonText currency_switch").attr("id", "USD").text("USD"), sidebar.append("rect").attr("y", keyStatisticsSectionTop + tablerowHeight + buttonHeight - 10).attr("x", 0).attr("width", sidebar_width).attr("height", 4 * tablerowHeight).attr("stroke", lightGrey).attr("fill", "white").attr("class", "tableBorderRect");
    for (var r = 0; r < 2; r++) sidebar.append("rect").attr("y", keyStatisticsSectionTop + tablerowHeight + buttonHeight - 10 + tablerowHeight + tablerowHeight * (2 * r)).attr("x", 0).attr("class", "tableBackgroundRect").attr("width", sidebar_width).attr("height", tablerowHeight).attr("fill", lightGrey);
    for (var a = 1; a < 4; a++) {
        t.country_profile_page["key_stats_table_header_" + a + "_title"];
        sidebar.append("text").datum(a).attr("y", keyStatisticsSectionTop + target_bar_height + buttonHeight).attr("x", a * columnWidth + columnWidth / 2).attr("id", "table_header" + a).attr("text-anchor", "middle").attr("class", "paragraph table_header")
    }
    for (o = 1; o < 4; o++) column01 = sidebar.append("text").datum(t.country_profile_page["key_stats_table_row_" + o + "_title"]).attr("y", keyStatisticsSectionTop + target_bar_height + buttonHeight + (tablerowHeight * o + 10)).attr("x", columnWidth / 2).attr("text-anchor", "middle").attr("class", "paragraph column01").attr("id", "text" + t.country_profile_page["key_stats_table_row_" + o + "_title"]).text(" " + t.country_profile_page["key_stats_table_row_" + o + "_title"]).call(wrapTableCol01, columnWidth), console.log(columnWidth);
    for (o = 0; o < key_statistics.length - 1; o++) column02 = sidebar.append("text").datum(key_statistics[o]).attr("y", keyStatisticsSectionTop + target_bar_height + buttonHeight + tablerowHeight * (o + 1)).attr("x", columnWidth + 2 * columnWidth).attr("text-anchor", "middle").attr("class", "paragraph column02").attr("id", "text" + key_statistics[o]).text("value here");
    for (var o = 0; o < key_change_statstics.length; o++) column03 = sidebar.append("text").datum(key_change_statstics[o]).attr("y", keyStatisticsSectionTop + target_bar_height + buttonHeight + tablerowHeight * (o + 1)).attr("x", 2 * columnWidth + columnWidth / 2).attr("text-anchor", "middle").attr("class", "paragraph column03").attr("id", "text" + key_statistics[o]).text("value here"), tableArrows = sidebar.append("svg:image").datum(key_change_statstics[o]).attr("y", keyStatisticsSectionTop + target_bar_height + buttonHeight + (tablerowHeight * o + tablerowHeight / 2 + 5)).attr("x", 2 * columnWidth + columnWidth / 3 - 30).attr("width", 30).attr("height", 30).attr("class", "paragraph table_arrows").attr("xlink:href", "https://s3.amazonaws.com//one.org/data-report-2017/countryProfiles_datavis/images/arrow_up.png");
    sectionPadding = 50, tableHeight = 4 * tablerowHeight + sectionPadding, sidebar.append("text").datum(t.country_profile_page.key_stats_table_source).attr("y", keyStatisticsSectionTop + target_bar_height + tableHeight + buttonHeight - 70).attr("x", 0).attr("class", "tablesource").text(" " + t.country_profile_page.key_stats_table_source).call(wrapEffectsSource01, row_chart_width), recommendationHeight = 100, sidebar.append("text").attr("x", sidebar_padding_left).attr("y", keyStatisticsSectionTop + target_bar_height + tableHeight + tablesourceheight).attr("class", "subtitle").text(t.country_profile_page.recommendations_title), recommendations = sidebar.append("text").attr("x", sidebar_padding_left).attr("y", keyStatisticsSectionTop + target_bar_height + tableHeight + sectionPadding + tablesourceheight).attr("class", "paragraph").attr("id", "recommendations_section_01"), recommendations02 = sidebar.append("text").attr("x", sidebar_padding_left).attr("y", keyStatisticsSectionTop + target_bar_height + tableHeight + sectionPadding + tablesourceheight).attr("class", "paragraph").attr("id", "recommendations_section_02"), recommendations03 = sidebar.append("text").attr("x", sidebar_padding_left).attr("y", keyStatisticsSectionTop + target_bar_height + tableHeight + sectionPadding + tablesourceheight).attr("class", "paragraph").attr("id", "recommendations_section_03")
}

function drawTargetChart() {
    targetChartXScale = d3.scale.linear().domain([0, .01]).range([0, sidebar_width]), targetBar = sidebar.append("rect").attr("y", sidebar_padding_top).attr("x", sidebar_padding_left).attr("width", targetChartXScale(.007)).attr("height", barHeight).attr("fill", lightGrey), targetBarValue = sidebar.append("rect").attr("y", sidebar_padding_top).attr("x", sidebar_padding_left).attr("width", 0).attr("height", barHeight).attr("class", "row_chart_target_oda_rect"), targetBarMarker = sidebar.append("rect").attr("y", sidebar_padding_top - 10).attr("x", targetChartXScale(.007)).attr("width", 5).attr("fill", darkGrey).attr("height", barHeight + 20), targetBarText = sidebar.append("text").attr("y", sidebar_padding_top + 25).attr("x", targetChartXScale(.007) + 10).attr("fill", darkGrey).attr("text-anchor", "start").attr("class", "highlightText").text("0.70%"), targetBarValueText = sidebar.append("text").attr("y", sidebar_padding_top + 45).attr("x", targetChartXScale(.007) + 10).attr("fill", darkGrey).attr("class", "target_met_chart_label").attr("text-anchor", "start"), targetValueMet = sidebar.append("text").attr("y", sidebar_padding_top + bar_chart_label_y).attr("x", 10).attr("fill", "white").attr("class", "target_chart_label").attr("text-anchor", "start")
}

function MoneyFormat(t) {
    return Math.abs(Number(t)) >= 1e9 ? Math.abs(Number(t)) / 1e9 + "B" : Math.abs(Number(t)) >= 1e6 ? Math.abs(Number(t)) / 1e6 + "M" : Math.abs(Number(t)) >= 1e3 ? Math.abs(Number(t)) / 1e3 + "K" : Math.abs(Number(t))
}

function resizeAidTypeRects(t) {
    if (d3.selectAll("#row_bar" + t).classed("active_row_bar") && d3.select(".target_switch").classed("active")) {
        var e, r = d3.select(".active_aid_type_button").attr("id");
        e = "In_Donor_Refugee_Costs" === r ? "In_Donor_Refugee_Over_All_ODA" : r + "_Over_All_ODA", d3.selectAll("." + r).attr("width", function(t) {
            return t.percentage_over_oda_gni = t[e] * t[contextChartValue_ODA_over_GNI], xScaleODAGNI(t.percentage_over_oda_gni)
        })
    } else d3.selectAll("#row_bar" + t).classed("active_row_bar") && (d3.selectAll("#row_bar" + t).attr("width", function(e) {
        return xScale(e[aid_types[t].name])
    }), d3.selectAll("#row_bar_text" + t).attr("x", function(t) {
        return xScale(0) + 10
    }))
}

function drawAidTypeRects(t) {
    if (d3.select(".target_switch").classed("active")) {
        var e, r = d3.select(".active_aid_type_button").attr("id");
        e = "In_Donor_Refugee_Costs" === r ? "In_Donor_Refugee_Over_All_ODA" : r + "_Over_All_ODA", d3.selectAll("." + t).classed("active_row_bar", !0).transition().duration(duration).attr("width", function(t) {
            return t.percentage_over_oda_gni = t[e] * t[contextChartValue_ODA_over_GNI], xScaleODAGNI(t.percentage_over_oda_gni)
        }).each("end", function() {
            d3.selectAll("." + t + "row_bar_text").text(function(t) {
                return percentFormat(t.percentage_over_oda_gni)
            })
        })
    } else d3.selectAll("." + t).classed("active_row_bar", !0).transition().duration(duration).attr("width", function(e) {
        return xScale(e[t])
    }).each("end", function() {
        d3.selectAll("." + t + "row_bar_text").text(function(e) {
            return percentFormat("In_Donor_Refugee_Costs" === t ? e.In_Donor_Refugee_Over_All_ODA : e[t + "_Over_All_ODA"])
        })
    })
}

function gridHover(t, e) {
    d3.selectAll("#gridSquares").style("fill", "white"), d3.select(t).style("fill", "#f04e30")
}

function gridClick(t, e, r, a) {
    var o = t;
    o = o.replace(/_/g, " "), thisCountry = t, activeCountryData = e[thisCountry], d3.selectAll("#gridSquares").attr("fill", function(t) {
        return oda_percent = countryProfileData[t]["Constant Prices"][9].All_ODA_Over_GNI, oda_percent >= target_percent_oda ? "#f04e30" : "#00babe"
    }), openCountryProfile(thisCountry, r, o, a, activeCountryData)
}

function openCountryProfile(t, e, r, a, o) {
    currentCurrencyCode = e.country_profile_page.currencies[t], drawRowChart(o, e), updateSidebar(o, e, r, a), checkWindowize(), countryProfileGroup.style("visibility", "visible"), country_profile_title.text(e.country_profile_page.country_names[t]), value_switch_text.text(e.country_profile_page.currencies[t]), recommendationData = o.recommendations.filter(function(t) {
        if (t.language === a) return t
    }), sidebar_width_for_wrapping = d3.select(".sidebar").attr("width") - 20, recommendations.text(""), recommendations.datum(recommendationData[0].recommendations_1).text(function(t) {
        return t
    }).call(wrapEffects, sidebar_width_for_wrapping), recommendations02.text(""), recommendations02.datum(recommendationData[0].recommendations_2).text(function(t) {
        return t
    }).call(wrapEffects, sidebar_width_for_wrapping), recommendations03.text(""), recommendations03.datum(recommendationData[0].recommendations_3).text(function(t) {
        return t
    }).call(wrapEffects, sidebar_width_for_wrapping), recommendations_section_02_pos = 21 * d3.select("#recommendations_section_01").selectAll("tspan")[0].length + 10, recommendations_section_03_pos_01 = 21 * d3.select("#recommendations_section_02").selectAll("tspan")[0].length + 10, recommendations_section_03_pos = recommendations_section_03_pos_01 + recommendations_section_02_pos, d3.select("#recommendations_section_02").attr("transform", "translate(0," + recommendations_section_02_pos + ")"), d3.select("#recommendations_section_03").attr("transform", "translate(0," + recommendations_section_03_pos + ")")
}

function updateTableValues(t, e, r) {
    d3.selectAll(".column02").text(function(e) {
        return "USD " + formatRounded(t[e]) + " " + r.country_profile_page.millions
    }), d3.selectAll(".column03").text(function(t) {
        return percentFormat(e[t])
    }), d3.selectAll(".table_arrows").attr("xlink:href", function(t, r) {
        return e[t] > 0 ? "https://s3.amazonaws.com//one.org/data-report-2017/countryProfiles_datavis/images/arrow_up.png" : "https://s3.amazonaws.com//one.org/data-report-2017/countryProfiles_datavis/images/arrow_down.png"
    })
}

function switchTableCurrency(t, e) {
    var r = t["National currency"].filter(function(t) {
        if (t.Time_Period === currentYear) return t
    });
    d3.selectAll(".column02").text(function(t) {
        return currentCurrencyCode + " " + formatRounded(r[0][t]) + " " + e.country_profile_page.millions
    })
}

function switchTableCurrencyUSD(t, e) {
    var r = t["Current Prices"].filter(function(t) {
        if (t.Time_Period === currentYear) return t
    });
    d3.selectAll(".column02").text(function(t) {
        return "USD " + formatRounded(r[0][t]) + " " + e.country_profile_page.millions
    })
}

function closeCountryProfile() {
    d3.selectAll(".target_switch").classed("active", !1), context_chart_target_toggle_title.text(annotationData.country_profile_page.context_chart_toggle_1), countryProfileGroup.style("visibility", "hidden"), d3.selectAll("#USD").classed("active", !0), d3.selectAll(".national_currency").classed("active", !1), d3.selectAll("#target_met_grid_text").remove(), d3.selectAll("#gridText").text(function(t, e) {
        return annotationData.country_profile_page.country_names[t]
    }), d3.selectAll(".aidSelectorRect").classed("active_aid_type_button", !1), legendBox.classed("hidden", !0), legendText.classed("hidden", !0), d3.selectAll("#gridText").classed("big_text", !1)
}
console.log("script.js loaded");
var currentYear = 2017,
    updateGrid, drawRowChart, formatData, drawTargetChart, updateSidebar, legendGroup, page_section_padding = 20,
    selector_group_height = 50,
    tablesourceheight = 50,
    row_chart_title_position_y = 0,
    row_chart_toggle_position_y = 40,
    row_chart_legend_position_y = 80,
    row_chart_margin_top = row_chart_legend_position_y + page_section_padding,
    checkWindowize, wrapEffects, context_chart_group, countryProfileSVG, break_point_mobile = 600,
    break_point_tablet = 1400,
    break_point_desktop = 1400,
    window_width, title_height = 100,
    page_margin_top = title_height + 80,
    mobile_page_padding = 20,
    page_margin_bottom = 50,
    title_margin_left = 20,
    page_margin_left = 100,
    page_margin_right = 50,
    grid_margin_left, side_bar_margins = 40,
    context_chart_margins = 200,
    sidebar_padding_top = 10,
    sidebar_padding_left = 0,
    title_section = 150,
    tooltip, bar_chart_label_y = 32.5,
    keyStatisticsSectionTop = 150,
    currency_value_toggles, value_switch_group, context_chart_width, context_chart_height, text_y_position = 3,
    sidebar, sidebar_width, sideBarText, profileOverlay, recommendations, recommendations02, recommendations03, recommendations_section_02_pos, recommendations_section_03_pos, targetBar, targetBarMarker, targetBarText, targetBarValue, targetValueMet, togglebuttonWidth, column01, column02, column03, legendBox, legendText, aid_over_time_title, usd_currency_button, value_switch_text, currentCurrencyCode, margin = {
        top: 20,
        right: 20,
        bottom: 20,
        left: 20
    },
    years_array = [2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008],
    price_type = "Constant Prices",
    contextChartValue_All_ODA = "All_ODA",
    contextChartValue_ODA_over_GNI = "All_ODA_Over_GNI",
    twoDPFormat = d3.format(".2f"),
    percentFormat = function(t) {
        return twoDPFormat(100 * t) + "%"
    },
    formatThousands, formatRounded, localefunction, context_chart_width, aid_types = [{
        name: "LDC_ODA",
        tooltip_content: "Least Developed Countries"
    }, {
        name: "Africa_ODA",
        tooltip_content: "Africa countries"
    }, {
        name: "In_Donor_Refugee_Costs",
        tooltip_content: "In Donor refugee costs"
    }],
    key_statistics = ["All_ODA", "LDC_ODA", "Africa_ODA", "In_Donor_Refugee_Costs"],
    key_change_statstics = ["All_ODA_YoY_Percent", "LDC_ODA_YoY_Percent", "Africa_ODA_YoY_Percent"],
    contextChartValue_All_ODA_over_GNI = ["All_ODA_Over_GNI"],
    legend = aid_types,
    centerX, centerY, duration = 1e3,
    bar_chart_height = 550,
    barHeight = 50,
    percent = d3.format("%"),
    oda_bars, ssa_bars, xScale, yScale, xAxis, yAxis, row_chart_xaxis, lightGrey = "#cccccc",
    darkGrey = "#424242",
    target_bar_height, columnWidth, tablerowHeight, buttonWidth, buttonHeight = 40,
    row_chart_oda_bars;
drawRowChart = function(t, e) {
    oda_to_ldc_row_chart = t[price_type], oda_to_ldc_row_chart.forEach(function(t) {
        t.target_multiplier = .7 / (100 * t[contextChartValue_ODA_over_GNI])
    });
    var r = d3.max(oda_to_ldc_row_chart, function(t) {
            return t[contextChartValue_All_ODA]
        }),
        a = d3.max(oda_to_ldc_row_chart, function(t) {
            return t[contextChartValue_All_ODA_over_GNI]
        });
    xScale.domain([0, d3.max([r])]), xScaleODAGNI.domain([0, d3.max([a])]), yScale.domain(years_array), xScale.range([0, row_chart_width]), yScale.rangeRoundBands([0, bar_chart_height], .1), row_chart_xaxis.call(xAxis), row_chart_yaxis.call(yAxis), (row_chart_oda_bars = row_chart_group.selectAll("#row_bar" + o).data(oda_to_ldc_row_chart)).enter().append("rect"), row_chart_oda_bars.attr("class", n).attr("id", "row_bar" + o).classed("row_chart_oda_rect", !0).attr("y", function(t) {
        return yScale(t.Time_Period)
    }).attr("height", barHeight).attr("width", 0);
    for (var o = 0; o < aid_types.length; o++) {
        var n = aid_types[o].name;
        row_chart_bars = row_chart_group.selectAll("#row_bar" + o).data(oda_to_ldc_row_chart), row_chart_bars.enter().append("rect"), row_chart_bars.attr("class", n).attr("id", "row_bar" + o).classed("row_chart_rect", !0).attr("y", function(t) {
            return yScale(t.Time_Period)
        }).attr("width", function(t) {
            return 0
        }).attr("height", barHeight), row_chart_bars_text = row_chart_group.selectAll("#row_bar_text" + n).data(oda_to_ldc_row_chart), row_chart_bars_text.enter().append("text"), row_chart_bars_text.attr("y", function(t) {
            return yScale(t.Time_Period) + bar_chart_label_y
        }).attr("x", function(t) {
            return xScale(0) + text_y_position
        }).attr("text-anchor", "start").attr("id", "row_bar_text" + n).attr("class", n + "row_bar_text").classed("row_bar_text", !0).text("")
    }
    oda_bars_text = row_chart_group.selectAll(".row_bar_oda_text").data(oda_to_ldc_row_chart), oda_bars_text.enter().append("text"), oda_bars_text.attr("y", function(t) {
        return yScale(t.Time_Period) + bar_chart_label_y
    }).text(function(t) {
        MoneyFormat(t[contextChartValue_All_ODA]);
        return "$" + formatThousands(t[contextChartValue_All_ODA] / 1e3) + " " + e.country_profile_page.billions
    })
}, wrapTable = function(t, e) {
    console.log(t), t.each(function() {
        var t, r = d3.select(this),
            a = r.text().split(/\s+/).reverse(),
            o = [],
            n = 0,
            i = r.attr("y"),
            _ = r.attr("x"),
            l = r.text(null).append("tspan").attr("x", _).attr("y", i).attr("dy", "-0.5em");
        for (console.log("updating"), console.log(a); t = a.pop();) console.log(t), o.push(t), l.text(o.join(" ")), console.log(l.node()), l.node().getComputedTextLength() > e && (console.log(l.node().getComputedTextLength()), o.pop(), l.text(o.join(" ")), o = [t], l = r.append("tspan").attr("x", _).attr("y", i).attr("dy", 1 * ++n - .5 + "em").text(t))
    })
}, wrapTableCol01 = function(t, e) {
    t.each(function() {
        var t, r = d3.select(this),
            a = r.text().split(" ").reverse(),
            o = [],
            n = 0,
            i = r.attr("y"),
            _ = r.attr("x"),
            l = r.text(null).append("tspan").attr("x", _).attr("y", i).attr("dy", "-0.5em");
        for (console.log(a); t = a.pop();) o.push(t), l.text(o.join(" ")), l.node().getComputedTextLength() > e && (o.pop(), l.text(o.join(" ")), o = [t], l = r.append("tspan").attr("x", _).attr("y", i).attr("dy", 1 * ++n - .5 + "em").text(t))
    })
}, wrapEffects = function(t, e) {
    t.each(function() {
        for (var t, r = d3.select(this), a = r.text().split(" ").reverse(), o = [], n = 0, i = r.attr("y"), _ = r.attr("x"), l = r.text(null).append("tspan").attr("x", _).attr("y", i).attr("dy", "0.5em"); t = a.pop();) o.push(t), l.text(o.join(" ")), l.node().getComputedTextLength() > e && (o.pop(), l.text(o.join(" ")), o = [t], l = r.append("tspan").attr("x", _).attr("y", i).attr("dy", 1 * ++n + .5 + "em").text(t))
    })
}, wrapEffectsSource01 = function(t, e) {
    console.log("wrapping"), t.each(function() {
        var t, r = d3.select(this),
            a = r.text().split(" ").reverse(),
            o = [],
            n = 0,
            i = r.attr("y"),
            _ = r.attr("x"),
            l = r.text(null).append("tspan").attr("x", _).attr("y", i).attr("dy", "0.5em");
        for (console.log(a.pop()); t = a.pop();) o.push(t), l.text(o.join(" ")), l.node().getComputedTextLength() > e && (o.pop(), l.text(o.join(" ")), o = [t], l = r.append("tspan").attr("x", _).attr("y", i).attr("dy", 1 * ++n + .5 + "em").text(t))
    })
}, wrapEffects02 = function(t, e) {
    t.each(function() {
        for (var t, r = d3.select(this), a = r.text().split(" ").reverse(), o = [], n = 0, i = r.attr("y"), _ = r.attr("x"), l = r.text(null).append("tspan").attr("x", _).attr("y", i).attr("dy", "0.5em"); t = a.pop();) o.push(t), l.text(o.join(" ")), l.node().getComputedTextLength() > e - page_margin_left && (o.pop(), l.text(o.join(" ")), o = [t], l = r.append("tspan").attr("x", _).attr("y", i).attr("dy", 1 * ++n + .5 + "em").text(t))
    })
}, console.log("coxcombChart.js loaded"), drawCoxcomb = function(t) {
    console.log("drawing coxcomb"), console.log(t), oda_to_ldc = t[price_type];
    var e;
    t[price_type].forEach(function(t) {
        t.Full_Time_Period = yearformat.parse(t.Time_Period.toString()), t.label = t.Full_Time_Period.getFullYear(), t.oda = 45 * Math.random() + 5, t.ssa = 145 * Math.random() + 5, e = 1e4 / t.Value
    });
    var r = d3.max(oda_to_ldc, function(t) {
        return d3.max([t[contextChartValue_All]])
    });
    console.log("max row chart value = " + r), maxRadius = Math.sqrt(10 * r / Math.PI), console.log("max radius chart value = " + maxRadius), domain = [0, maxRadius], country_data = oda_to_ldc, console.log(country_data), radiusScale.domain(domain), figure.datum(country_data).attr("class", "chart figure1"), createWedges(country_data)
}, createWedges = function(t) {
    console.log(t), console.log("creating wedges"), t = formatData(t), console.log(t), numWedges = t.length + 1, wedgeGroups = context_graph.selectAll(".wedgeGroup").data(t), wedgeGroups.enter().append("svg:g").attr("class", "wedgeGroup").attr("transform", "scale(0,0)"), wedges = wedgeGroups.selectAll(".wedge").data(function(t) {
        console.log("wedges data" + t), console.log(t);
        var e = d3.range(0, legend.length);
        return console.log("ids=" + e), e.map(function(e) {
            return {
                legend: legend[e],
                radius: t.radius[e],
                angle: t.angle,
                data: t.data
            }
        })
    }), wedges.enter().append("svg:path").attr("class", function(t) {
        return "wedge " + t.legend
    }).on("click", function(t) {
        console.log(t)
    }), wedges.transition().attr("d", arc), wedges.append("svg:title").text(function(t) {
        return t.legend + ": " + Math.floor(Math.pow(t.radius, 2) * Math.PI / numWedges)
    })
}, formatData = function(t) {
    return (t = t.map(function(e, r) {
        return {
            angle: r,
            area: [e[contextChartValue_All], e[contextChartValue_Africa], e[contextChartValue_LDC]],
            label: label.call(t, e, r),
            data: e
        }
    })).map(function(t, e) {
        return {
            angle: t.angle,
            label: t.label,
            radius: t.area.map(function(t) {
                return Math.sqrt(t * numWedges / Math.PI)
            }),
            data: t.data
        }
    })
}, console.log("rowChart.js loaded");
var gridRects, rowNumber = 0,
    gridpadding = 2,
    target_percent_oda = .00695;
drawGrid = function(t, e, r) {
    var a = d3.keys(t);
    gridRects = gridGroup.selectAll("#gridSquares").data(a).enter().append("rect").attr("fill", function(e) {
        return oda_percent = t[e]["Constant Prices"][9].All_ODA_Over_GNI, oda_percent >= target_percent_oda ? "#f04e30" : "#00babe"
    }).attr("id", "gridSquares").attr("class", function(t) {
        return t.replace(/\s/g, "_")
    }).on("click", function(a) {
        gridClick(a, t, e, r)
    }).on("mouseover", function(a) {
        if (d3.selectAll("#target_met_grid_text").remove(), d3.selectAll("#gridText").text(function(t, r) {
                return e.country_profile_page.country_names[t]
            }).classed("big_text", !1), d3.selectAll("#gridSquares").attr("fill", lightGrey), d3.select(this).attr("fill", function(e) {
                return oda_percent = t[e]["Constant Prices"][9].All_ODA_Over_GNI, oda_percent >= target_percent_oda ? "#f04e30" : "#00babe"
            }), "EU Institutions" === a) return "";
        d3.selectAll("." + a.replace(/\s/g, "_")).text(percentFormat(t[a]["Current Prices"][9].All_ODA_Over_GNI)).classed("big_text", !0), gridGroup.append("text").text(function() {
            return window_width < break_point_tablet ? e.selector_page.instructions : t[a]["Current Prices"][9].All_ODA_Over_GNI > target_percent_oda ? e.selector_page.legend_target_met : e.selector_page.legend_target_not_met
        }).attr("fill", "white").attr("id", "target_met_grid_text").attr("x", d3.select(this).attr("x")).attr("y", d3.select(this).attr("y")).attr("dy", "2em").attr("transform", "translate(" + d3.select(this).attr("width") / 2 + "," + d3.select(this).attr("height") / 2 + ")").attr("text-anchor", "middle").on("click", function() {
            gridClick(a, t, e, r)
        })
    }), gridText = gridGroup.selectAll("#gridText").data(a).enter().append("text").text(function(t, r) {
        return e.country_profile_page.country_names[t]
    }).attr("fill", "#ffffff").attr("id", "gridText").attr("text-anchor", "middle").attr("class", function(t) {
        return t.replace(/\s/g, "_")
    }).style("font-size", "30px").on("click", function(a) {
        gridClick(a, t, e, r)
    }), updateGrid()
}, updateGrid = function() {
    var t, e = window_width - grid_margin_left - grid_margin_left;
    xPos = -1, xPosrow2 = -1, xPosrow3 = -1, xPosrow4 = -1, xPosrow5 = -1, xPosrow6 = -1, xPosrow7 = -1, xPosrow8 = -1, xPosrow9 = -1, xPosrow10 = -1, xPosrow11 = -1, xPosrow12 = -1, xtextPos = -1, xtextPosrow2 = -1, xtextPosrow3 = -1, xtextPosrow4 = -1, xtextPosrow5 = -1, xtextPosrow6 = -1, xtextPosrow7 = -1, xtextPosrow8 = -1, xtextPosrow9 = -1, xtextPosrow10 = -1, xtextPosrow11 = -1, xtextPosrow12 = -1, window_width <= break_point_mobile ? (grid_row_break_point = 1, grid_row_break_point_02 = 2, grid_row_break_point_03 = 3, grid_row_break_point_04 = 4, grid_row_break_point_05 = 5, grid_row_break_point_06 = 6, grid_row_break_point_07 = 7, grid_row_break_point_08 = 8, grid_row_break_point_09 = 9, grid_row_break_point_10 = 10, grid_row_break_point_11 = 11, grid_row_break_point_12 = 12, t = e) : window_width <= break_point_desktop ? (grid_row_break_point = 2, grid_row_break_point_02 = 4, grid_row_break_point_03 = 6, grid_row_break_point_04 = 8, grid_row_break_point_05 = 10, grid_row_break_point_06 = 12, grid_row_break_point_07 = 14, grid_row_break_point_08 = 16, grid_row_break_point_09 = 32, t = e / 2) : (grid_row_break_point = 4, grid_row_break_point_02 = 8, grid_row_break_point_03 = 12, grid_row_break_point_04 = 16, grid_row_break_point_05 = 20, grid_row_break_point_06 = 24, grid_row_break_point_07 = 28, grid_row_break_point_08 = 32, grid_row_break_point_09 = 32, t = e / 4), grid_height = t / 2, gridRects.attr("width", t - gridpadding).attr("height", t / 2 - gridpadding).attr("x", function(e, r) {
        return r < grid_row_break_point ? r * t : r < grid_row_break_point_02 ? ++xPos * t : r < grid_row_break_point_03 ? ++xPosrow2 * t : r < grid_row_break_point_04 ? ++xPosrow3 * t : r < grid_row_break_point_05 ? ++xPosrow4 * t : r < grid_row_break_point_06 ? ++xPosrow5 * t : r < grid_row_break_point_07 ? ++xPosrow6 * t : r < grid_row_break_point_08 ? ++xPosrow7 * t : r < grid_row_break_point_09 ? ++xPosrow8 * t : r < grid_row_break_point_10 ? ++xPosrow9 * t : r < grid_row_break_point_11 ? ++xPosrow10 * t : r < grid_row_break_point_12 ? ++xPosrow11 * t : ++xPosrow12 * t
    }).attr("y", function(t, e) {
        return e < grid_row_break_point ? rowNumber * grid_height : e < grid_row_break_point_02 ? (rowNumber + 1) * grid_height : e < grid_row_break_point_03 ? (rowNumber + 2) * grid_height : e < grid_row_break_point_04 ? (rowNumber + 3) * grid_height : e < grid_row_break_point_05 ? (rowNumber + 4) * grid_height : e < grid_row_break_point_06 ? (rowNumber + 5) * grid_height : e < grid_row_break_point_07 ? (rowNumber + 6) * grid_height : e < grid_row_break_point_08 ? (rowNumber + 7) * grid_height : e < grid_row_break_point_09 ? (rowNumber + 8) * grid_height : e < grid_row_break_point_10 ? (rowNumber + 9) * grid_height : e < grid_row_break_point_11 ? (rowNumber + 10) * grid_height : e < grid_row_break_point_12 ? (rowNumber + 11) * grid_height : (rowNumber + 12) * grid_height
    }), gridText.attr("x", function(e, r) {
        return r < grid_row_break_point ? t / 2 + r * t : r < grid_row_break_point_02 ? (xtextPos++, t / 2 + xtextPos * t) : r < grid_row_break_point_03 ? (xtextPosrow2++, t / 2 + xtextPosrow2 * t) : r < grid_row_break_point_04 ? (xtextPosrow3++, t / 2 + xtextPosrow3 * t) : r < grid_row_break_point_05 ? (xtextPosrow4++, t / 2 + xtextPosrow4 * t) : r < grid_row_break_point_06 ? (xtextPosrow5++, t / 2 + xtextPosrow5 * t) : r < grid_row_break_point_07 ? (xtextPosrow6++, t / 2 + xtextPosrow6 * t) : r < grid_row_break_point_08 ? (xtextPosrow7++, t / 2 + xtextPosrow7 * t) : r < grid_row_break_point_09 ? (xtextPosrow8++, t / 2 + xtextPosrow8 * t) : r < grid_row_break_point_10 ? (xtextPosrow9++, t / 2 + xtextPosrow9 * t) : r < grid_row_break_point_11 ? (xtextPosrow10++, t / 2 + xtextPosrow10 * t) : (xtextPosrow11++, t / 2 + xtextPosrow11 * t)
    }).attr("y", function(t, e) {
        return e < grid_row_break_point ? (rowNumber + 1) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_02 ? (rowNumber + 2) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_03 ? (rowNumber + 3) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_04 ? (rowNumber + 4) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_05 ? (rowNumber + 5) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_06 ? (rowNumber + 6) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_07 ? (rowNumber + 7) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_08 ? (rowNumber + 8) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_09 ? (rowNumber + 9) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_10 ? (rowNumber + 10) * grid_height - grid_height / 2 + 10 : e < grid_row_break_point_11 ? (rowNumber + 11) * grid_height - grid_height / 2 + 10 : (rowNumber + 12) * grid_height - grid_height / 2 + 10
    })
};
var recommendationData;
updateSidebar = function(t, e, r, a) {
    var o = t["Current Prices"].filter(function(t) {
            if (t.Time_Period === currentYear) return t
        }),
        n = t["Constant Prices"].filter(function(t) {
            if (t.Time_Period === currentYear) return t
        }),
        i = t[price_type].filter(function(t) {
            if (t.Time_Period === currentYear) return t
        });
    "EU Institutions" === r ? (targetBarValueText.text(e.country_profile_page.target_chart_not_applicable), targetValueMet.text(e.country_profile_page.target_chart_not_applicable), targetBarValue.classed("hidden", !0), d3.selectAll(".target_switch").classed("hidden", !0), d3.selectAll(".national_currency").classed("hidden", !1)) : "EU Countries" === r ? (targetBarValueText.text(e.country_profile_page.target_chart_not_met), targetValueMet.text(percentFormat(i[0][contextChartValue_All_ODA_over_GNI])), targetBarValue.datum(i[0][contextChartValue_All_ODA_over_GNI]).attr("width", function(t) {
        return targetChartXScale(t)
    }), targetBarValue.classed("hidden", !1), d3.selectAll(".target_switch").classed("hidden", !1), d3.selectAll(".national_currency").classed("hidden", !0)) : i[0][contextChartValue_All_ODA_over_GNI] >= target_percent_oda ? (targetBarValueText.text(e.country_profile_page.target_chart_met), targetValueMet.text(percentFormat(i[0][contextChartValue_All_ODA_over_GNI])), targetBarValue.datum(i[0][contextChartValue_All_ODA_over_GNI]).attr("width", function(t) {
        return targetChartXScale(t)
    }), targetBarValue.classed("hidden", !1), d3.selectAll(".target_switch").classed("hidden", !1), d3.selectAll(".national_currency").classed("hidden", !1)) : (targetBarValueText.text(e.country_profile_page.target_chart_not_met), targetValueMet.text(percentFormat(i[0][contextChartValue_All_ODA_over_GNI])), targetBarValue.datum(i[0][contextChartValue_All_ODA_over_GNI]).attr("width", function(t) {
        return targetChartXScale(t)
    }), targetBarValue.classed("hidden", !1), d3.selectAll(".target_switch").classed("hidden", !1), d3.selectAll(".national_currency").classed("hidden", !1)), updateTableValues(o[0], n[0], e)
};