use core::byte_array::ByteArrayTrait;
use super::beast_definitions;
use super::beast_manager::BeastAttributes;
use super::utils::felt252_to_byte_array;

#[generate_trait]
pub impl BeastSvgImpl of BeastSvgTrait {
    /// Generates a complete data URI for the SVG
    fn generate_svg(
        beast_id: u8,
        prefix_name: felt252,
        suffix_name: felt252,
        beast_name: felt252,
        rank: u16,
        beast_attrs: BeastAttributes,
    ) -> ByteArray {
        let is_shiny = beast_attrs.shiny > 0;

        let mut svg: ByteArray = "";

        svg
            .append(
                @"<svg xmlns='http://www.w3.org/2000/svg' width='250' height='350' viewBox='0 0 250 350'>",
            );
        svg.append(@"<defs>");
        svg.append(@"<linearGradient id='gold' x1='0%' y1='0%' x2='100%' y2='100%'>");
        svg.append(@"<stop offset='0%' stop-color='#e5d8b2'/>");
        svg.append(@"<stop offset='60%' stop-color='#b79a5e'/>");
        svg.append(@"<stop offset='100%' stop-color='#8a6d3b'/>");
        svg.append(@"</linearGradient>");
        svg.append(@"<linearGradient id='panel' x1='0%' y1='0%' x2='0%' y2='100%'>");
        svg.append(@"<stop offset='0%' stop-color='#2d2d32'/>");
        svg.append(@"<stop offset='100%' stop-color='#1e1e22'/>");
        svg.append(@"</linearGradient>");
        svg.append(@"<linearGradient id='shiny' x1='0%' y1='0%' x2='100%' y2='100%'>");
        svg.append(@"<stop offset='0%' stop-color='#ff6b9d' stop-opacity='0.3'>");
        svg
            .append(
                @"<animate attributeName='stop-opacity' values='0.3;0.8;0.3' dur='2s' repeatCount='indefinite'/>",
            );
        svg.append(@"</stop>");
        svg.append(@"<stop offset='25%' stop-color='#c44569' stop-opacity='0.4'>");
        svg
            .append(
                @"<animate attributeName='stop-opacity' values='0.4;0.9;0.4' dur='2s' repeatCount='indefinite'/>",
            );
        svg.append(@"</stop>");
        svg.append(@"<stop offset='50%' stop-color='#f8b500' stop-opacity='0.3'>");
        svg
            .append(
                @"<animate attributeName='stop-opacity' values='0.3;0.8;0.3' dur='2s' repeatCount='indefinite'/>",
            );
        svg.append(@"</stop>");
        svg.append(@"<stop offset='75%' stop-color='#00d4ff' stop-opacity='0.4'>");
        svg
            .append(
                @"<animate attributeName='stop-opacity' values='0.4;0.9;0.4' dur='2s' repeatCount='indefinite'/>",
            );
        svg.append(@"</stop>");
        svg.append(@"<stop offset='100%' stop-color='#ff6b9d' stop-opacity='0.3'>");
        svg
            .append(
                @"<animate attributeName='stop-opacity' values='0.3;0.8;0.3' dur='2s' repeatCount='indefinite'/>",
            );
        svg.append(@"</stop>");
        svg.append(@"</linearGradient>");
        svg.append(@"<radialGradient id='sparkle' cx='50%' cy='50%' r='50%'>");
        svg.append(@"<stop offset='0%' stop-color='#ffffff' stop-opacity='0.8'/>");
        svg.append(@"<stop offset='70%' stop-color='#ffffff' stop-opacity='0.3'/>");
        svg.append(@"<stop offset='100%' stop-color='#ffffff' stop-opacity='0'/>");
        svg.append(@"</radialGradient>");
        svg
            .append(
                @"<path transform='scale(0.7)' d='M13 11c0-6 9-6 9 0s-9 10.5-9 10.5S4 17 4 11s9-6 9 0Z' stroke-width='3' id='heart' stroke='#ff6b6b' fill='none'/>",
            );
        svg
            .append(
                @"<path transform='scale(0.95)' id='bolt' stroke='#ffd166' stroke-width='2' stroke-linejoin='round' d='M6 2 2 9h5l-4 7'/>",
            );
        svg.append(@"<g id='crown' fill='#e6c56e' stroke='#af8a3c' stroke-width='1'>");
        svg.append(@"<path d='M2 14h16l-1.5 4h-13z'/>");
        svg
            .append(
                @"<path d='m3 14 2-9 3 5 4-5 3 5 2-5 2 9Z' stroke-linejoin='round' stroke-linecap='round'/>",
            );
        svg.append(@"<circle cx='5' cy='5' r='1.2' fill='#fff3c4'/>");
        svg.append(@"<circle cx='12' cy='5' r='1.2' fill='#fff3c4'/>");
        svg.append(@"<circle cx='17' cy='5' r='1.2' fill='#fff3c4'/>");
        svg.append(@"</g>");
        svg.append(@"<g id='trophy' fill='#c0c0c0' stroke='#8a8a8a' stroke-width='1'>");
        svg.append(@"<rect x='5' y='4' width='10' height='8' rx='1'/>");
        svg.append(@"<rect x='3' y='6' width='2' height='3'/>");
        svg.append(@"<rect x='15' y='6' width='2' height='3'/>");
        svg.append(@"<rect x='7' y='12' width='6' height='4'/>");
        svg.append(@"</g>");
        svg
            .append(
                @"<pattern id='pin' width='12' height='12' patternUnits='userSpaceOnUse' patternTransform='rotate(12)'>",
            );
        svg.append(@"<path fill='#1b1b1f' d='M0 0h12v12H0z'/>");
        svg.append(@"<path fill='#242428' opacity='.3' d='M0 0h12v6H0z'/>");
        svg.append(@"</pattern>");
        svg.append(@"<style>");
        svg
            .append(
                @".label{fill:#c9c9d1;font-size:10px;letter-spacing:.4px}.valL{fill:#fff;font-size:15px;font-weight:700}",
            );
        svg.append(@"text{font-family: Courier, monospace;}");
        svg.append(@"</style>");
        svg.append(@"</defs>");

        // Background
        svg.append(@"<rect width='250' height='350' rx='12' fill='url(#pin)'/>");
        svg
            .append(
                @"<rect x='4.5' y='4.5' width='241' height='341' rx='9' fill='none' stroke='url(#gold)' stroke-width='3'/>",
            );
        svg
            .append(
                @"<rect x='9' y='9' width='232' height='332' rx='7' fill='none' stroke='#fff' stroke-opacity='.05'/>",
            );

        svg
            .append(
                @"<path transform='translate(13, 12) scale(0.029)' fill-rule='evenodd' clip-rule='evenodd' d='M242.9 629.232H69.4V349.536H0V699.071H242.9V629.232ZM312.3 69.9071V0H34.7V69.9071H0V314.582H104.1V384.489H242.9V314.582H347V69.9071H312.3ZM277.6 244.675H208.2V314.582H138.8V244.675H69.4V139.814H138.8V244.675H208.2V139.814H277.6V244.675ZM104.1 594.279H277.6V734.093H0V804H312.3V734.093H347V524.372H173.5V489.418H347V419.511H104.1V594.279Z'
            fill='",
            );
        svg.append(@get_tier_color(beast_attrs.tier));
        svg.append(@"'/>");

        // Crown for rank 1, trophy for other ranks
        if rank == 1 {
            svg.append(@"<use href='#crown' x='218' y='9' width='20' height='20'/>");
            svg
                .append(
                    @"<text x='228' y='39' text-anchor='middle' style='fill:#e6c56e;font-size:11px;font-weight:700'>1</text>",
                );
        } else if rank > 1 {
            svg.append(@"<use href='#trophy' x='218' y='9' width='20' height='20'/>");
            svg
                .append(
                    @"<text x='228' y='39' text-anchor='middle' style='fill:#b0b0b6;font-size:11px;font-weight:700'>",
                );
            svg.append(@format!("{}", rank));
            svg.append(@"</text>");
        }

        // Specials and name
        svg
            .append(
                @"<text x='125' y='30' text-anchor='middle' style='fill:#b0b0b6;font-size:12px;'>",
            );
        if prefix_name != 0 {
            svg.append(@"\"");
            let prefix_str = felt252_to_byte_array(prefix_name);
            svg.append(@prefix_str);
            svg.append(@" ");
            let suffix_str = felt252_to_byte_array(suffix_name);
            svg.append(@suffix_str);
            svg.append(@"\"");
        }
        svg.append(@"</text>");

        svg
            .append(
                @"<text x='125' y='51' text-anchor='middle' style='fill:#fff;font-size:19px;font-weight:700;letter-spacing:.7px'>",
            );
        let beast_name_str = felt252_to_byte_array(beast_name);
        svg.append(@beast_name_str);
        svg.append(@"</text>");

        // Beast image with clip path
        svg.append(@"<clipPath id='artClip'>");
        svg.append(@"<rect width='130' height='130' rx='8'/>");
        svg.append(@"</clipPath>");
        svg.append(@"<rect x='60' y='65' width='130' height='130' rx='8' fill='#141418'/>");
        svg.append(@"<g transform='translate(60, 65)' clip-path='url(#artClip)'>");
        // If animated, use the sheet image, otherwise use the single image
        if beast_attrs.animated == 1 {
            svg
                .append(
                    @"<image width='780' height='130' background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;' href='",
                );
            let beast_image = get_beast_png(beast_id, true, is_shiny);
            svg.append(@beast_image);
            svg.append(@"'>");
            svg
                .append(
                    @"<animate attributeName='opacity' dur='2.2s' from='1' to='0.999' repeatCount='indefinite'/>",
                );
        } else {
            svg.append(@"<image width='130' height='130' image-rendering='pixelated' href='");
            let beast_image = get_beast_png(beast_id, false, is_shiny);
            svg.append(@beast_image);
            svg.append(@"'>");
        }

        svg.append(@"</image></g>");
        svg
            .append(
                @"<rect x='60' y='65' width='130' height='130' rx='8' fill='none' stroke='#fff' stroke-opacity='.08' stroke-width='2'/>",
            );

        // Stats panels
        svg.append(@"<g transform='translate(13 208)'>");
        svg.append(@"<rect width='70' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='35' y='18' text-anchor='middle' class='label'>TIER</text>");
        svg.append(@"<text x='35' y='38' text-anchor='middle' class='valL'>");
        svg.append(@format!("{}", beast_attrs.tier));
        svg.append(@"</text>");

        svg.append(@"<g transform='translate(75)'>");
        svg.append(@"<rect width='70' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='35' y='18' text-anchor='middle' class='label'>LEVEL</text>");
        svg.append(@"<text x='35' y='38' text-anchor='middle' class='valL'>");
        svg.append(@format!("{}", beast_attrs.level));
        svg.append(@"</text>");
        svg.append(@"</g>");

        svg.append(@"<g transform='translate(150)'>");
        svg.append(@"<rect width='70' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='35' y='18' text-anchor='middle' class='label'>TYPE</text>");
        svg
            .append(
                @"<text x='35' y='37' text-anchor='middle' style='fill:#fff;font-size:13px;font-weight:700'>",
            );
        let beast_type_str = felt252_to_byte_array(beast_attrs.beast_type);
        svg.append(@beast_type_str);
        svg.append(@"</text>");
        svg.append(@"</g>");
        svg.append(@"</g>");

        // Power and Health panels
        svg.append(@"<g transform='translate(13 265)'>");
        svg.append(@"<rect width='107' height='65' rx='5' fill='url(#panel)'/>");
        svg.append(@"<use href='#bolt' x='75' y='30'/>");
        svg.append(@"<text x='18' y='22' class='label'>POWER</text>");
        svg.append(@"<text x='18' y='46' style='fill:#fff;font-size:20px;font-weight:700'>");
        svg.append(@format!("{}", beast_attrs.power));
        svg.append(@"</text>");
        svg.append(@"</g>");

        svg.append(@"<g transform='translate(126 265)'>");
        svg.append(@"<rect width='107' height='65' rx='5' fill='url(#panel)'/>");
        svg.append(@"<use href='#heart' x='68' y='30'/>");
        svg.append(@"<text x='18' y='22' class='label'>HEALTH</text>");
        svg.append(@"<text x='18' y='46' style='fill:#fff;font-size:19px;font-weight:700'>");
        svg.append(@format!("{}", beast_attrs.health));
        svg.append(@"</text>");
        svg.append(@"</g>");

        // Add shiny border glow effect if beast is shiny
        if is_shiny {
            svg
                .append(
                    @"<rect x='4.5' y='4.5' width='241' height='341' rx='9' fill='none' stroke='url(#shiny)' stroke-width='6'/>",
                );
            svg.append(@"<circle cx='80' cy='100' r='8' fill='url(#sparkle)' opacity='0.6'>");
            svg
                .append(
                    @"<animate attributeName='opacity' values='0.6;0.9;0.6' dur='1.5s' repeatCount='indefinite'/>",
                );
            svg
                .append(
                    @"<animateTransform attributeName='transform' type='translate' values='0,0; 50,30; 100,0; 150,50; 200,20; 0,0' dur='8s' repeatCount='indefinite'/>",
                );
            svg.append(@"</circle>");
            svg.append(@"<circle cx='170' cy='200' r='6' fill='url(#sparkle)' opacity='0.7'>");
            svg
                .append(
                    @"<animate attributeName='opacity' values='0.7;1.0;0.7' dur='1.2s' repeatCount='indefinite'/>",
                );
            svg
                .append(
                    @"<animateTransform attributeName='transform' type='translate' values='0,0; -30,40; -60,0; -90,30; -120,60; 0,0' dur='6s' repeatCount='indefinite'/>",
                );
            svg.append(@"</circle>");
            svg.append(@"<circle cx='125' cy='300' r='5' fill='url(#sparkle)' opacity='0.8'>");
            svg
                .append(
                    @"<animate attributeName='opacity' values='0.8;1.0;0.8' dur='1.8s' repeatCount='indefinite'/>",
                );
            svg
                .append(
                    @"<animateTransform attributeName='transform' type='translate' values='0,0; 40,-20; 80,10; 120,-30; 160,0; 0,0' dur='10s' repeatCount='indefinite'/>",
                );
            svg.append(@"</circle>");
        }

        svg.append(@"</svg>");
        svg
    }
}

fn get_tier_color(tier: u8) -> ByteArray {
    match tier {
        0 => "",
        1 => "#ff8800",
        2 => "#B634E2",
        3 => "#6C6CF7",
        4 => "#00ff00",
        5 => "#ffffff",
        _ => "",
    }
}

fn get_beast_png(beast_id: u8, animated: bool, is_shiny: bool) -> ByteArray {
    if beast_id == beast_definitions::WARLOCK {
        if animated {
            if is_shiny {
                get_warlock_shiny_gif_svg()
            } else {
                get_warlock_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_warlock_shiny_svg()
            } else {
                get_warlock_svg()
            }
        }
    } else if beast_id == beast_definitions::TYPHON {
        if animated {
            if is_shiny {
                get_typhon_shiny_gif_svg()
            } else {
                get_typhon_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_typhon_shiny_svg()
            } else {
                get_typhon_svg()
            }
        }
    } else if beast_id == beast_definitions::JIANGSHI {
        if animated {
            if is_shiny {
                get_jiangshi_shiny_gif_svg()
            } else {
                get_jiangshi_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_jiangshi_shiny_svg()
            } else {
                get_jiangshi_svg()
            }
        }
    } else if beast_id == beast_definitions::ANANSI {
        if animated {
            if is_shiny {
                get_anansi_shiny_gif_svg()
            } else {
                get_anansi_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_anansi_shiny_svg()
            } else {
                get_anansi_svg()
            }
        }
    } else if beast_id == beast_definitions::BASILISK {
        if animated {
            if is_shiny {
                get_basilisk_shiny_gif_svg()
            } else {
                get_basilisk_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_basilisk_shiny_svg()
            } else {
                get_basilisk_svg()
            }
        }
    } else if beast_id == beast_definitions::GORGON {
        if animated {
            if is_shiny {
                get_gorgon_shiny_gif_svg()
            } else {
                get_gorgon_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_gorgon_shiny_svg()
            } else {
                get_gorgon_svg()
            }
        }
    } else if beast_id == beast_definitions::KITSUNE {
        if animated {
            if is_shiny {
                get_kitsune_shiny_gif_svg()
            } else {
                get_kitsune_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_kitsune_shiny_svg()
            } else {
                get_kitsune_svg()
            }
        }
    } else if beast_id == beast_definitions::LICH {
        if animated {
            if is_shiny {
                get_lich_shiny_gif_svg()
            } else {
                get_lich_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_lich_shiny_svg()
            } else {
                get_lich_svg()
            }
        }
    } else if beast_id == beast_definitions::CHIMERA {
        if animated {
            if is_shiny {
                get_chimera_shiny_gif_svg()
            } else {
                get_chimera_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_chimera_shiny_svg()
            } else {
                get_chimera_svg()
            }
        }
    } else if beast_id == beast_definitions::WENDIGO {
        if animated {
            if is_shiny {
                get_wendigo_shiny_gif_svg()
            } else {
                get_wendigo_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_wendigo_shiny_svg()
            } else {
                get_wendigo_svg()
            }
        }
    } else if beast_id == beast_definitions::RAKSHASA {
        if animated {
            if is_shiny {
                get_rakshasa_shiny_gif_svg()
            } else {
                get_rakshasa_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_rakshasa_shiny_svg()
            } else {
                get_rakshasa_svg()
            }
        }
    } else if beast_id == beast_definitions::WEREWOLF {
        if animated {
            if is_shiny {
                get_werewolf_shiny_gif_svg()
            } else {
                get_werewolf_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_werewolf_shiny_svg()
            } else {
                get_werewolf_svg()
            }
        }
    } else if beast_id == beast_definitions::BANSHEE {
        if animated {
            if is_shiny {
                get_banshee_shiny_gif_svg()
            } else {
                get_banshee_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_banshee_shiny_svg()
            } else {
                get_banshee_svg()
            }
        }
    } else if beast_id == beast_definitions::DRAUGR {
        if animated {
            if is_shiny {
                get_draugr_shiny_gif_svg()
            } else {
                get_draugr_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_draugr_shiny_svg()
            } else {
                get_draugr_svg()
            }
        }
    } else if beast_id == beast_definitions::VAMPIRE {
        if animated {
            if is_shiny {
                get_vampire_shiny_gif_svg()
            } else {
                get_vampire_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_vampire_shiny_svg()
            } else {
                get_vampire_svg()
            }
        }
    } else if beast_id == beast_definitions::GOBLIN {
        if animated {
            if is_shiny {
                get_goblin_shiny_gif_svg()
            } else {
                get_goblin_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_goblin_shiny_svg()
            } else {
                get_goblin_svg()
            }
        }
    } else if beast_id == beast_definitions::GHOUL {
        if animated {
            if is_shiny {
                get_ghoul_shiny_gif_svg()
            } else {
                get_ghoul_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_ghoul_shiny_svg()
            } else {
                get_ghoul_svg()
            }
        }
    } else if beast_id == beast_definitions::WRAITH {
        if animated {
            if is_shiny {
                get_wraith_shiny_gif_svg()
            } else {
                get_wraith_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_wraith_shiny_svg()
            } else {
                get_wraith_svg()
            }
        }
    } else if beast_id == beast_definitions::SPRITE {
        if animated {
            if is_shiny {
                get_sprite_shiny_gif_svg()
            } else {
                get_sprite_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_sprite_shiny_svg()
            } else {
                get_sprite_svg()
            }
        }
    } else if beast_id == beast_definitions::KAPPA {
        if animated {
            if is_shiny {
                get_kappa_shiny_gif_svg()
            } else {
                get_kappa_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_kappa_shiny_svg()
            } else {
                get_kappa_svg()
            }
        }
    } else if beast_id == beast_definitions::FAIRY {
        if animated {
            if is_shiny {
                get_fairy_shiny_gif_svg()
            } else {
                get_fairy_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_fairy_shiny_svg()
            } else {
                get_fairy_svg()
            }
        }
    } else if beast_id == beast_definitions::LEPRECHAUN {
        if animated {
            if is_shiny {
                get_leprechaun_shiny_gif_svg()
            } else {
                get_leprechaun_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_leprechaun_shiny_svg()
            } else {
                get_leprechaun_svg()
            }
        }
    } else if beast_id == beast_definitions::KELPIE {
        if animated {
            if is_shiny {
                get_kelpie_shiny_gif_svg()
            } else {
                get_kelpie_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_kelpie_shiny_svg()
            } else {
                get_kelpie_svg()
            }
        }
    } else if beast_id == beast_definitions::PIXIE {
        if animated {
            if is_shiny {
                get_pixie_shiny_gif_svg()
            } else {
                get_pixie_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_pixie_shiny_svg()
            } else {
                get_pixie_svg()
            }
        }
    } else if beast_id == beast_definitions::GNOME {
        if animated {
            if is_shiny {
                get_gnome_shiny_gif_svg()
            } else {
                get_gnome_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_gnome_shiny_svg()
            } else {
                get_gnome_svg()
            }
        }
    } else if beast_id == beast_definitions::GRIFFIN {
        if animated {
            if is_shiny {
                get_griffin_shiny_gif_svg()
            } else {
                get_griffin_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_griffin_shiny_svg()
            } else {
                get_griffin_svg()
            }
        }
    } else if beast_id == beast_definitions::MANTICORE {
        if animated {
            if is_shiny {
                get_manticore_shiny_gif_svg()
            } else {
                get_manticore_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_manticore_shiny_svg()
            } else {
                get_manticore_svg()
            }
        }
    } else if beast_id == beast_definitions::PHOENIX {
        if animated {
            if is_shiny {
                get_phoenix_shiny_gif_svg()
            } else {
                get_phoenix_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_phoenix_shiny_svg()
            } else {
                get_phoenix_svg()
            }
        }
    } else if beast_id == beast_definitions::DRAGON {
        if animated {
            if is_shiny {
                get_dragon_shiny_gif_svg()
            } else {
                get_dragon_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_dragon_shiny_svg()
            } else {
                get_dragon_svg()
            }
        }
    } else if beast_id == beast_definitions::MINOTAUR {
        if animated {
            if is_shiny {
                get_minotaur_shiny_gif_svg()
            } else {
                get_minotaur_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_minotaur_shiny_svg()
            } else {
                get_minotaur_svg()
            }
        }
    } else if beast_id == beast_definitions::QILIN {
        if animated {
            if is_shiny {
                get_qilin_shiny_gif_svg()
            } else {
                get_qilin_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_qilin_shiny_svg()
            } else {
                get_qilin_svg()
            }
        }
    } else if beast_id == beast_definitions::AMMIT {
        if animated {
            if is_shiny {
                get_ammit_shiny_gif_svg()
            } else {
                get_ammit_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_ammit_shiny_svg()
            } else {
                get_ammit_svg()
            }
        }
    } else if beast_id == beast_definitions::NUE {
        if animated {
            if is_shiny {
                get_nue_shiny_gif_svg()
            } else {
                get_nue_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_nue_shiny_svg()
            } else {
                get_nue_svg()
            }
        }
    } else if beast_id == beast_definitions::SKINWALKER {
        if animated {
            if is_shiny {
                get_skinwalker_shiny_gif_svg()
            } else {
                get_skinwalker_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_skinwalker_shiny_svg()
            } else {
                get_skinwalker_svg()
            }
        }
    } else if beast_id == beast_definitions::CHUPACABRA {
        if animated {
            if is_shiny {
                get_chupacabra_shiny_gif_svg()
            } else {
                get_chupacabra_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_chupacabra_shiny_svg()
            } else {
                get_chupacabra_svg()
            }
        }
    } else if beast_id == beast_definitions::WERETIGER {
        if animated {
            if is_shiny {
                get_weretiger_shiny_gif_svg()
            } else {
                get_weretiger_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_weretiger_shiny_svg()
            } else {
                get_weretiger_svg()
            }
        }
    } else if beast_id == beast_definitions::WYVERN {
        if animated {
            if is_shiny {
                get_wyvern_shiny_gif_svg()
            } else {
                get_wyvern_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_wyvern_shiny_svg()
            } else {
                get_wyvern_svg()
            }
        }
    } else if beast_id == beast_definitions::ROC {
        if animated {
            if is_shiny {
                get_roc_shiny_gif_svg()
            } else {
                get_roc_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_roc_shiny_svg()
            } else {
                get_roc_svg()
            }
        }
    } else if beast_id == beast_definitions::HARPY {
        if animated {
            if is_shiny {
                get_harpy_shiny_gif_svg()
            } else {
                get_harpy_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_harpy_shiny_svg()
            } else {
                get_harpy_svg()
            }
        }
    } else if beast_id == beast_definitions::PEGASUS {
        if animated {
            if is_shiny {
                get_pegasus_shiny_gif_svg()
            } else {
                get_pegasus_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_pegasus_shiny_svg()
            } else {
                get_pegasus_svg()
            }
        }
    } else if beast_id == beast_definitions::HIPPOGRIFF {
        if animated {
            if is_shiny {
                get_hippogriff_shiny_gif_svg()
            } else {
                get_hippogriff_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_hippogriff_shiny_svg()
            } else {
                get_hippogriff_svg()
            }
        }
    } else if beast_id == beast_definitions::FENRIR {
        if animated {
            if is_shiny {
                get_fenrir_shiny_gif_svg()
            } else {
                get_fenrir_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_fenrir_shiny_svg()
            } else {
                get_fenrir_svg()
            }
        }
    } else if beast_id == beast_definitions::JAGUAR {
        if animated {
            if is_shiny {
                get_jaguar_shiny_gif_svg()
            } else {
                get_jaguar_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_jaguar_shiny_svg()
            } else {
                get_jaguar_svg()
            }
        }
    } else if beast_id == beast_definitions::SATORI {
        if animated {
            if is_shiny {
                get_satori_shiny_gif_svg()
            } else {
                get_satori_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_satori_shiny_svg()
            } else {
                get_satori_svg()
            }
        }
    } else if beast_id == beast_definitions::DIREWOLF {
        if animated {
            if is_shiny {
                get_direwolf_shiny_gif_svg()
            } else {
                get_direwolf_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_direwolf_shiny_svg()
            } else {
                get_direwolf_svg()
            }
        }
    } else if beast_id == beast_definitions::BEAR {
        if animated {
            if is_shiny {
                get_bear_shiny_gif_svg()
            } else {
                get_bear_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_bear_shiny_svg()
            } else {
                get_bear_svg()
            }
        }
    } else if beast_id == beast_definitions::WOLF {
        if animated {
            if is_shiny {
                get_wolf_shiny_gif_svg()
            } else {
                get_wolf_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_wolf_shiny_svg()
            } else {
                get_wolf_svg()
            }
        }
    } else if beast_id == beast_definitions::MANTIS {
        if animated {
            if is_shiny {
                get_mantis_shiny_gif_svg()
            } else {
                get_mantis_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_mantis_shiny_svg()
            } else {
                get_mantis_svg()
            }
        }
    } else if beast_id == beast_definitions::SPIDER {
        if animated {
            if is_shiny {
                get_spider_shiny_gif_svg()
            } else {
                get_spider_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_spider_shiny_svg()
            } else {
                get_spider_svg()
            }
        }
    } else if beast_id == beast_definitions::RAT {
        if animated {
            if is_shiny {
                get_rat_shiny_gif_svg()
            } else {
                get_rat_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_rat_shiny_svg()
            } else {
                get_rat_svg()
            }
        }
    } else if beast_id == beast_definitions::KRAKEN {
        if animated {
            if is_shiny {
                get_kraken_shiny_gif_svg()
            } else {
                get_kraken_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_kraken_shiny_svg()
            } else {
                get_kraken_svg()
            }
        }
    } else if beast_id == beast_definitions::COLOSSUS {
        if animated {
            if is_shiny {
                get_colossus_shiny_gif_svg()
            } else {
                get_colossus_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_colossus_shiny_svg()
            } else {
                get_colossus_svg()
            }
        }
    } else if beast_id == beast_definitions::BALROG {
        if animated {
            if is_shiny {
                get_balrog_shiny_gif_svg()
            } else {
                get_balrog_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_balrog_shiny_svg()
            } else {
                get_balrog_svg()
            }
        }
    } else if beast_id == beast_definitions::LEVIATHAN {
        if animated {
            if is_shiny {
                get_leviathan_shiny_gif_svg()
            } else {
                get_leviathan_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_leviathan_shiny_svg()
            } else {
                get_leviathan_svg()
            }
        }
    } else if beast_id == beast_definitions::TARRASQUE {
        if animated {
            if is_shiny {
                get_tarrasque_shiny_gif_svg()
            } else {
                get_tarrasque_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_tarrasque_shiny_svg()
            } else {
                get_tarrasque_svg()
            }
        }
    } else if beast_id == beast_definitions::TITAN {
        if animated {
            if is_shiny {
                get_titan_shiny_gif_svg()
            } else {
                get_titan_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_titan_shiny_svg()
            } else {
                get_titan_svg()
            }
        }
    } else if beast_id == beast_definitions::NEPHILIM {
        if animated {
            if is_shiny {
                get_nephilim_shiny_gif_svg()
            } else {
                get_nephilim_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_nephilim_shiny_svg()
            } else {
                get_nephilim_svg()
            }
        }
    } else if beast_id == beast_definitions::BEHEMOTH {
        if animated {
            if is_shiny {
                get_behemoth_shiny_gif_svg()
            } else {
                get_behemoth_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_behemoth_shiny_svg()
            } else {
                get_behemoth_svg()
            }
        }
    } else if beast_id == beast_definitions::HYDRA {
        if animated {
            if is_shiny {
                get_hydra_shiny_gif_svg()
            } else {
                get_hydra_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_hydra_shiny_svg()
            } else {
                get_hydra_svg()
            }
        }
    } else if beast_id == beast_definitions::JUGGERNAUT {
        if animated {
            if is_shiny {
                get_juggernaut_shiny_gif_svg()
            } else {
                get_juggernaut_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_juggernaut_shiny_svg()
            } else {
                get_juggernaut_svg()
            }
        }
    } else if beast_id == beast_definitions::ONI {
        if animated {
            if is_shiny {
                get_oni_shiny_gif_svg()
            } else {
                get_oni_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_oni_shiny_svg()
            } else {
                get_oni_svg()
            }
        }
    } else if beast_id == beast_definitions::JOTUNN {
        if animated {
            if is_shiny {
                get_jotunn_shiny_gif_svg()
            } else {
                get_jotunn_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_jotunn_shiny_svg()
            } else {
                get_jotunn_svg()
            }
        }
    } else if beast_id == beast_definitions::ETTIN {
        if animated {
            if is_shiny {
                get_ettin_shiny_gif_svg()
            } else {
                get_ettin_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_ettin_shiny_svg()
            } else {
                get_ettin_svg()
            }
        }
    } else if beast_id == beast_definitions::CYCLOPS {
        if animated {
            if is_shiny {
                get_cyclops_shiny_gif_svg()
            } else {
                get_cyclops_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_cyclops_shiny_svg()
            } else {
                get_cyclops_svg()
            }
        }
    } else if beast_id == beast_definitions::GIANT {
        if animated {
            if is_shiny {
                get_giant_shiny_gif_svg()
            } else {
                get_giant_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_giant_shiny_svg()
            } else {
                get_giant_svg()
            }
        }
    } else if beast_id == beast_definitions::NEMEANLION {
        if animated {
            if is_shiny {
                get_nemeanlion_shiny_gif_svg()
            } else {
                get_nemeanlion_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_nemeanlion_shiny_svg()
            } else {
                get_nemeanlion_svg()
            }
        }
    } else if beast_id == beast_definitions::BERSERKER {
        if animated {
            if is_shiny {
                get_berserker_shiny_gif_svg()
            } else {
                get_berserker_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_berserker_shiny_svg()
            } else {
                get_berserker_svg()
            }
        }
    } else if beast_id == beast_definitions::YETI {
        if animated {
            if is_shiny {
                get_yeti_shiny_gif_svg()
            } else {
                get_yeti_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_yeti_shiny_svg()
            } else {
                get_yeti_svg()
            }
        }
    } else if beast_id == beast_definitions::GOLEM {
        if animated {
            if is_shiny {
                get_golem_shiny_gif_svg()
            } else {
                get_golem_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_golem_shiny_svg()
            } else {
                get_golem_svg()
            }
        }
    } else if beast_id == beast_definitions::ENT {
        if animated {
            if is_shiny {
                get_ent_shiny_gif_svg()
            } else {
                get_ent_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_ent_shiny_svg()
            } else {
                get_ent_svg()
            }
        }
    } else if beast_id == beast_definitions::TROLL {
        if animated {
            if is_shiny {
                get_troll_shiny_gif_svg()
            } else {
                get_troll_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_troll_shiny_svg()
            } else {
                get_troll_svg()
            }
        }
    } else if beast_id == beast_definitions::BIGFOOT {
        if animated {
            if is_shiny {
                get_bigfoot_shiny_gif_svg()
            } else {
                get_bigfoot_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_bigfoot_shiny_svg()
            } else {
                get_bigfoot_svg()
            }
        }
    } else if beast_id == beast_definitions::OGRE {
        if animated {
            if is_shiny {
                get_ogre_shiny_gif_svg()
            } else {
                get_ogre_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_ogre_shiny_svg()
            } else {
                get_ogre_svg()
            }
        }
    } else if beast_id == beast_definitions::ORC {
        if animated {
            if is_shiny {
                get_orc_shiny_gif_svg()
            } else {
                get_orc_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_orc_shiny_svg()
            } else {
                get_orc_svg()
            }
        }
    } else if beast_id == beast_definitions::SKELETON {
        if animated {
            if is_shiny {
                get_skeleton_shiny_gif_svg()
            } else {
                get_skeleton_regular_gif_svg()
            }
        } else {
            if is_shiny {
                get_skeleton_shiny_svg()
            } else {
                get_skeleton_svg()
            }
        }
    } else {
        // Default empty image
        "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
    }
}

// Include all the beast PNG functions// Auto-generated beast SVG functions

fn get_ammit_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAUFJREFUWIXFVlsSgyAMXDu9mHfyGN6Jo9mPFpvGPDao08wwgCZk2UDCBGDDH+U5YrSi7eMF830AVrQfB5bj/u0MkC1qK9re+lz2Uidby2mxcw/QVSAeGT2SduBNtUX3LSGQO/V2qL8NsFCjTNOeAcpaGgLgGwYdjqukdAv0P88mW1c0nm4LzNkwhIlIn+yzWc+S0hm4QygAmWQAVzRXZ6gYaccL5hSE1JGhnPA5iaNOvIWtQiYLWB9TIehOupHs2WoYsUTlAeBYCbMCFKXpPi4xAByzYrRzbeexQOf+UV2LKTG/xnlk470fwIagUyj7ESmH4Mr679mVGWCSjtRnpHyF9JytiNZZoAA4hikYC7SxRj2BZE5YVmGdAZ3DtfRXcRTj6k2hds+EZISZ8nsgY6gqNABdCSOpgqSvlqXLhCha6wW5/qpme8KK6AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_anansi_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqCmYQcchQnVoQFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdXFSdJES/5cUWsR4cNyPd/ced++AYKPKNKtrDNB028ykkmIuvyJGXhFBPwSEEZeZZcxKUhq+4+seAb7eJXiW/7k/R69asBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU+J46bdEHiR64rHr9xLrkc5JmCmc3MEQvEYqmDlQ5mZVMjniSOqZpO+cGcxyrnLc5atcZa9+QvjBb05SWu0xxGCgtYhAQRCmqooAobCVp1UixkaD/p4x9y/RK5FHJVwMgxjw1okF0/+B/87tYqTox7SdEkEH5xnI8RILILNOuO833sOM0TIPQMXOlt/0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcYfDJkU3alEM1gsQi8n9E35YGBW6Bn1euttY/TByBLXaVvgINDYLRE2Ws+7+7u7O3fM63+fgBXknKcyUKElgAAAQ9JREFUWIXFV0EOwyAMC9Me3Sf01+wwsTGrJHaCukiorVqIsZ2gNjPr9sd4Zif283vfjhqIro5++s/KeNSwv6Mdv4wokQYwEmYTlwEM3av6mxX1x3cJP+jJoyQKCFmCftZMhyEDGMl3gkjRH8khyKCbj/ECC6DkgR0ypPoAgqjGNg+wZWqqBEjzTgYoAJiE9QDrj21VkJGAAuAlv8UDH6outL+lCiLKo3feoBnwKsH7Lgq6CiKqZzBKeYYAlB2hL5i5IQDFZLhzZm7pLIi+YSLViplgZZAYyLTgiCkXwFho3o1CPfPv4AKYk0WLrfoEriMBwMVHP0CKkSmlDM2INjz/cMzXVSsW27J0dKbHCsQLNgcL7AwMt80AAAAASUVORK5CYII=",
        );
    svg
}

fn get_balrog_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAAM9JREFUOI2tUkkSA0EIQv7/6GRasHEuuSQ1FRV3bNSPH1qQ3PgAsNUIRzgEE03BLQbG49FXbKXVk/EEcLtfIQV3VlRPOFARZDaJCMXBHk0fSkdAI6v/zCbsWyFGjMJ3zFmzhhqmX0TF/snHIWolVXZvBeWr3EVD472F6pPucm9RHoPmwWpfc0j1rmMcHCY4V5NxgrBe0Zb3ReWR1tEOD1RW7zL/hrHMqGMY17gsju0ZJpMhBCNz4g5T788V3tIBe/UkpYmyGo+9bhoiafMgxwcWBAVgSaxWswAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_banshee_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AAAD/0o8flwAAAAR0Uk5TAP///7MtQIgAAADeSURBVDiNhVMBDsQwCNLw/z/frYpgl9w12boNqwgu8s8KPaIunIcr4PvxgXD2Z3tlOHA2fpcAkzSmCJwAHUAzaDJ1D5JCXqGdMXiwKKazBEiS0KZZW3Suk9NI4qxUCYAkMGhnULxqUzKWqNq2utvuggaQHqFKEcK7w2mmIqLta/0oIuZc2BsbluKQDsRHDmYN82eIDVfjoBJmG+126Wc2aHmQovFfc6mRWyOhuaTdV7djPnVIOyzCq004qJq022h7JzCSS5/REfyzZup6tmaS2QWc4vr54nofGZYOv9YHt/cGjd5fhNsAAAAASUVORK5CYII=",
        );
    svg
}

fn get_basilisk_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAARJJREFUSIm1VkkShDAITKh5dJ7gr51DLIwsDWQcyouEppEl2Jsv5/F47QPY1kV4n5r5vOxdOH2HQ3vZ5ugewW2hUo9PhZAJm8gJ1vGuTsNPIbZbYX1cyKnkV1NS6coY6WprpZYP9rjGbqa7MBxmO/6ambXIXNJ8aBkO2aai2s1vymQohA59vK52isAz5ZnwJNupyZLq+seXR6lhyvfdX70TttZN1YqbhwAGt2yBoBRRdXG6d1EpfH3EWJvATH2Llo/W99EIh4bdhcDzaH1dLLfWSTQbg60pWElcoklhp2YTG/Gt4xNORjKaafmYAzMDHjiUa597MNDvumw7grve/DMrz3meA9Vve60zRzwcr3B4S/QLQlDU0fk/7DIAAAAASUVORK5CYII=",
        );
    svg
}

fn get_bear_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8A/////zPWCAAAAAR0Uk5TAP///7MtQIgAAACqSURBVDiNhVPREoAgCIPb//9zZwlshNWDh2MMZ2L+8xlvgFqFANwgIkJhi7AibDAVbmhFtuOnnpaAmQAuJ0IyonJHTwW7kEOqzTxcKQTNvBhRKZtoUTkoIgrlYlBotXnf5QKo5vQ7iOBxRQ4/ENCMKGE0+WrxpSDPZCBAsrNCuZwJfFXfLWYXf4SWL+BEOCrk8ZoCwRgJNDNt/izzSFA28aohM5vD2KZ7+i6bwwVnShVyQwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_behemoth_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqCmYQcchQnVoQFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdXFSdJES/5cUWsR4cNyPd/ced++AYKPKNKtrDNB028ykkmIuvyJGXhFBPwSEEZeZZcxKUhq+4+seAb7eJXiW/7k/R69asBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU+J46bdEHiR64rHr9xLrkc5JmCmc3MEQvEYqmDlQ5mZVMjniSOqZpO+cGcxyrnLc5atcZa9+QvjBb05SWu0xxGCgtYhAQRCmqooAobCVp1UixkaD/p4x9y/RK5FHJVwMgxjw1okF0/+B/87tYqTox7SdEkEH5xnI8RILILNOuO833sOM0TIPQMXOlt/0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcYfDJkU3alEM1gsQi8n9E35YGBW6Bn1euttY/TByBLXaVvgINDYLRE2Ws+7+7u7O3fM63+fgBXknKcyUKElgAAARpJREFUWIXtV1EShCAIfTV7se7UMbyTR2t/loZ1AUGsfvbNOJMJ8XyC2gLgwINYnwz+JwAAr4hxQT2fd2z3EaDAPOhMMofVCqo5TjYeO6XFCFiBRkiEkpDLLmHH1rWRMF3eiL2pQEE9E6ygDs2uh0v2gchShAl4P+wloRIg+TP1Tv4WkWlLoAXZsZlERAKSYXa340R+CGgB2/e8Kjz2HpwKkPOsUgtVAa916meST1NKSuy1dbCkHJVZ+s4XAY1da2zByg9rfG2NRoJn8JUDdwcnpE+63p2B+pLv8J2QI1s16XPeq4A05j4LIrUdwS33Ad6XyA7Jz69qUpJJz9K7YQXodIv6tLNfPoxc6FVBS0irDL4cIQJX4PGf0zcw000xKtIqzwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_berserker_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAR9JREFUWIXFl8EOwyAMQ8O0//9ldkJClk2csK0+tZSSh2kCHREx40G90h6IN0k7a2P3JYD18vAGou+PHEQD7IEZxGrbA6ng+DwFwMBzu1aOsD6GC9pgJGcBcJbsGRvLAkBqFgCdUi4dloADnNa144AaUwIEac1mxdzC94n8JLt1QCgHYKmoBq/0tQFYkBOAOfOlvBSjsjpQVB1gD8iu/wZwKsU/BcB0w4pX1LscmG0yrOabrngOqABqwynklu8AAp3uC/JORGuGaCt+AwF9DbCaA+qLN7depn4WqLNhsbb6ADizi9zvAaC+dJjvAywZJ987ALWmWeExP8beqV8duRhIotoSsHIc0FZUDeC03s1dsfvjdR146b4QXWbB4w58AF2Ueh/5xGUaAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_bigfoot_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAO5JREFUSInNlUsSxCAIRCH3v7OzcMoiCE37WYSFlTL46E5EpbUmIvzIhM+/xY1pd+nfcBCrmBBHDgCumThykC12AdSwDsICjJrUAfBeOpjdaH9S1TGrqnbG+32HS7P5/VXAyrRs0EXk6Xo36CAss9DuasxqSvdPiXZ0SyzdC3ZgF2escEdQBUp6h2a7bkTxiTK6ewty0n2G6XOXZA5QN9nuwwVAjdcn+veeGbG6ki58H2x0QI/6J6+eTqs5Pm+cuAtHCHOjhTUoTfEdRNDLGw1R+PnafZaBZ5jbmL2TmUrIzcn6nRr3K93Vyzq4OP4AF6fW0LqyuFQAAAAASUVORK5CYII=",
        );
    svg
}

fn get_chimera_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAADNSURBVDiNhZNZEsMwCENhdP87t2OQWJymzk8cNM9CJuZ/lvEFwKsA53kT4CDgvnQliNLFMR6fFp4EcTxOCZcX40fQCLaHLJVXegqUDaQ+p93v3ryQcFS39NwISEW2ktpJiJZpGkEggn0GQZ2bKtUu5AYjqKC34FZQGFlmIMi7EBFyGS8UjOVSLAHB9fCIpWgMDox6gnLQ8CxCyzr7tPKoC2seuoAhMYA2MGVsKCBBjcODwsY8SVHjZ+2fk1Uy4rrbIDcjAtvc3st+VnJ9AOFfBvtWFc+xAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_chupacabra_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAADASURBVDiNhZJZDsAgCEQhc/87N1FnoUtK+mGdh8Jg9U9UrLG+b+DoZAC8AqDcWOuyjMFgUwk0RAXxBLLUBEgkkldQCX3VuQEWpFtWtLuAe4sywgc0E+wUk0omIMv3svI3JzEApOKmAmjNJlw0MNu/TbX69DwqgZ0pOugcmXqMOvlxzDbFTsoEGbjhfDCyOgZlgFOM94QEeN5o935FnzLcEZ+DZzFnuEuV1S+6tsqHhRnW5cN9X1G5+w14Fg+i+icuBf4F3zotd/EAAAAASUVORK5CYII=",
        );
    svg
}

fn get_colossus_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAS1JREFUSImtVlsSxCAIQ6eH9gje2v2w41IeAbbLR6fVEBEDlci3NcFk1vp79o1c03ZpL9mJqA1a834WzIsIRFPYwXFowyAieoyfKTEYL6ApHp7PtU32Ndkhhwlpw2bx3PdI5x9vdGkm7V6Ab9BbYwPMWS0hTtjPR7iGecg6+5pQTmcEqmHlJAuo5gJgboFMsToPBqgrxc67jdhKLG7A7inv9hxfTK2SD5q/mDL19IPM61wnGydRZn6MMxMTPHAvNND1BFUQNYjLLAKAR+x81iTVqeN2nbeqljX+x2rYVirsv1l4eETUcH/mXLgyCvnRB+X9BjJU8l4E+ntYVmab6gKBq1+XmBargF34MqL/XHzQu2zZ414IGTMb1H65gE/SAv1oLeepMx2p/9LTK8gPlrMBMRnvjvkAAAAASUVORK5CYII=",
        );
    svg
}

fn get_cyclops_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AAAD/0o8flwAAAAR0Uk5TAP///7MtQIgAAACySURBVDiNhZMLDoQwCERp5v53XiMMDAWzaCK2j39r54+Y6EjZAaxqAs1M/ghAgjQnVvtp5QpuoIe4APQyNKoCkHcD3p3HHPUfgDuFP/HJZdOEwrpywAWc1ugNaJLABxGrBKQydr0Dnnd1CLeHtFJvBKJiD0XXXJRpVqb7NO8TtQJs1AToFaJPIGvAAnB+HMY4tPPITUCr2IFMDjuQU0MPEXkhrgao+Maxdr7UW4xMb/cqP62ZBbfx0owaAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_direwolf_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAKZJREFUOI2Vk0ESxSAIQ0nuf+i/qAQi/OnUTWt9hgRt4GXEF4DPAP8qJEAuAJOohwG2wkZEiWMlohe/zVzAjCPgFuhELAK2JfosMTaJMIGni1qfAI7QrpAi8mgAsKRwwEJgB1gABkAZmEAeZVmsjx1QzF6oDkvbD3QmBlQPZJi6MMMCTm905SpGNVQmTcXeHOh1sAFVavsvRLiXG2BDJ4AXDy1qU/gB1Z4FJkIxQpEAAAAASUVORK5CYII=",
        );
    svg
}

fn get_dragon_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAAN9JREFUOI2FUwESwzAIUv7/6F0iIOtuW3ttUkVUYqv/XPX4xm8APhGVzvMCvgCg5YEgAGPGWYEMqbHrOX6XAQJuxDUrHK2wA2AQ/YvgtjDREIBkNpa2KsMpia8GkgEuj6lLjaFNIUnvXfCeFMtxYSqSWd2khKMObo0cijop7GcjyqCNAOxkGHQuV0n5VfUe5jCXjodiB8WYar3RyIo9gJQvGJpS64PXgmdgNh39TkEl1UFIZBgHRv6Ogdy6Stk7ETHbBZshZGqugUEciXXcoY2koQKlzqAcnu3iTaKPn7tf1nUFaqrjsNoAAAAASUVORK5CYII=",
        );
    svg
}

fn get_draugr_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAYAAAC4JqlRAAABfWlDQ1BzUkdCAAAokX2RPUjDQBzFX1tLRSoKZhBxyFCdWhAVcdQqFKFCqBVadTC59AuaGJIUF0fBteDgx2LVwcVZVwdXQRD8AHF1cVJ0kRL/lxRaxHhw3I939x5374Bgo8o0q2sM0HTbzKSSYi6/IkZeEUE/BIQRl5llzEpSGr7j6x4Bvt4leJb/uT9Hr1qwGBAQiWeYYdrE68RTm7bBeZ9YYGVZJT4njpt0QeJHrisev3EuuRzkmYKZzcwRC8RiqYOVDmZlUyOeJI6pmk75wZzHKuctzlq1xlr35C+MFvTlJa7THEYKC1iEBBEKaqigChsJWnVSLGRoP+njH3L9ErkUclXAyDGPDWiQXT/4H/zu1ipOjHtJ0SQQfnGcjxEgsgs0647zfew4zRMg9Axc6W3/RgOY/iS93tZiR0DfNnBx3daUPeByBxh8MmRTdqUQzWCxCLyf0TflgYFboGfV6621j9MHIEtdpW+Ag0NgtETZaz7v7u7s7d8zrf5+AFeScpwisFufAAABKElEQVRYhcVXW44DMQgj1d7/yukXErJ42Emq9U/zYIIHJoYuM9v2j/jMJio/zX4gsM1sJWsb5hFLIiFGQB3PIOiefCIYtRpEBPCwFdZWsc9DS1hrqjl2EBF46xDxd+fYx11kfC8nLEYgy1h1VSdiRwRYINE6XSSB+EZ++IY52s3OM6oDATdfsJe98S7sZQKZ885ZXJ9B1IJsPNnyaAiwB1Yh5p5vCGSHVhnLSFynIB7qmj8JTrS/jkDmAHEvxw+E6I7EAwKo9dW1lAgwIhIdnEdBkGKsgr72sxRkOo+34b6jF76BrA9g0vOEQKyAVvw+l2J0jmNHl5r5+xCkuOuEp2ePCCCqyig21hyBqhBl88r5k36gw70ICQQyPTCY961XBfJ/AVsJdRJfR89eOWNH3K0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_ent_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAABVQTFRFAAAAAAAAAP8A/4gAjAC/AAD/////XlWhuwAAAAd0Uk5TAP///////6V/pvsAAADfSURBVDiNbVOBFsQgCBL+/6NvpSj2bmsty5BCg9+DrwFngNOINM8MoxZAtex6R4D5Xi+A5cOaRiBXKa/6qNBRuxonGcjEdShT0B3qjgtB8+i/sBKBvpttCmEOh4Vze5Fc8EOjEIQx3MdNIbTL2XaICbIcOAgO8B7YEfqYfxDAvumUoIFirxeNaouDqYhJohFrNJ4wTtL01mXRb5LvOzcaK8JkzUbwCDTDtVjYujjAE+bxgHNorfzZOameVV5sjxiJrbBMtWiOgtCgPMJTVirYxKnNrlUJOoc8pWfrDt4eP2/BBYMauZByAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_ettin_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAQ1JREFUSImtVlEOxSAIE/Puf2Xez2YQaAWzZjGKQFUQJ+MMHUP24YJ43YAJLDmZmGEVCgz0/aJyj0NDB/V1b+8JlLbpIhLMfRhdiGmXpHH0E08dHTVoBo2BYoUqDYkVig23ygkqHGgfEGK0BVxadF0rs/5OSpZCHArU/BZjgiIJ71vhduwkdCTOhOMh+IUJF5WxD93CK2cIl4CEdooc2jNcN7mxFgPB+c0cVvI9jVNSDdNaJKAQkRODhYufzLKRTB5tE3nMIs5UVD5ElDwvnLJU/nhxJsS95yE1c9l18/QTgkoJSUCezAh0rVhIWwQHXxcg/0Wxn6O4g17hvCCw+Oy/6BsOsnHnIi1HRyfjDxqnkLbYqnInAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_fairy_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8A/////zPWCAAAAAR0Uk5TAP///7MtQIgAAACxSURBVDiNlZNbDsMwCARBe/87N20wDNhVlPxYggmwPMwfPpsGPQEXoQ2QxKcRFlGFpxG2sob1JqQdSO6byosooBEVA0DmuGMcAFSRAVNFERSiCQQBPdGoRqilMd8IlcwEoDsKmICje70OTlOUeQLSquhUqmASVaifwZp3zQnlGEXECORTZg1cFDBbXUM4rRz/P65cJh3+BbSl2dYeXeaqFODNPW6LnST1F5inebjNt8AHUyUFa2pdeGkAAAAASUVORK5CYII=",
        );
    svg
}

fn get_fenrir_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAALRJREFUOI3NUksWhDAIg9z/0GP5hlqdrS7UvnwIBdE/j3yCAPvihbAwvBAWissBZ5IYHuCJYSUW7Iw7xUJ6iXPYVaIdjgTXln6v4l2UENHUVoLQ+GuOh4wqpCyGDC17h4s8oPUWOk19MKQSYBP7EMkhg4IPETJuGjnYFCEcQgjuFjm8XDmT5u6wRxOUytOWSQUE9UZbVBnIddyWjCvAmFM61LQ3PB36buYiQCmDUnuN6yQ8PD90jgS9NRkeyAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_ghoul_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAMZJREFUOI2VU0ESxCAMUv7/6N1JCGLipU6r04oQUNd+NMSTbY1J/CejawCcxdHqczBspMJg6CJWAzogi3gyAMcCMeueZ3WmcgOCnEups9wkFeoNqDNkPPE7aYzBE9AY3QTkWhkZAL6oH81FlSIjL4Bli5FD5SVbPckKgy6REj3g+K4qVq0TQEcGrMEqLm/MC8mgLdZIvdRZafukqwPLwRguL0J8Byil7RKeogWNCbi1yHBtXw+ee6FDaBeCifR7Aa92nIdX+wEw9wT/I1DR0wAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_giant_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AAAD/0o8flwAAAAR0Uk5TAP///7MtQIgAAACwSURBVDiNjZILDsQgCEQhc/87d1UYPi1xNY1gHzgiopchvw/2rWUNWgacTQRGCxuAJ9vYmRa9FkEKQU6xoQOAGeHDoXzE3oXt+xkhMmnnPwIWXgCKEaUsMxDOF1DdDuACIOwIkJrAaoCgGhAq/OITQOcLwAR4gccMGo8VaK1DUtEBf+80C8DGY0/pC7hmyABeGqjS+3sAlM02A72svCZbOcqagBTf2+ZfoNS/eKzDNB6kygX1hPndnwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_gnome_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAARBJREFUWIXVVtsOhTAIA3P+/5d3njQMYS1ostgXlwWhK5dNRWTIRhw7gz8iMMY7wn1TgfP0b6jwPQX8qZ+q8D0FthLI5H6SBpoACtIlobJ5FP+QQftkqpydFBQYY4iqXt9srwKogA3uA4rItO4AKtAJVFEiVMAGqjizaWH/vymAcpmpkP2D/E1zoFtIK6DU3QZRZIwkjaRf+QsJWMNsHZHw64qfiYB1xqRBVXGBEf4Oa+xrwA8cBD8jMr8W6SDKBg/bBWxBTwQ82yinq3bzfhgity5AklnHmSr+ECtQo5i9bOzYZkHdhpUBVSXReg+sCtFf0wjUk8y3pt3LCpZF+VF6njKq8s47of0oXVW57RCEP+Hu8Rtg2L0sAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_goblin_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAALdJREFUOI2FkwESwyAIBM3+/9FNq8CdkiaddHBc8TjIuF6e4UvWewKsfyBjz3Bv5FnmcgMSmdsN8GXydwIzab6pVqtgiw5Ab4jF5oPs94Aa1QA/kyA8mKm8CgLkFFnCsUB6sWoPMw+AsojwtQA/iPRr5AUhVEIEKP3RSSRD1OWjUhlKoJSjGrw/Miypwfqn7br2XqzzPAFrFvte+A0tUMLUXR85ra+dyf8A+TVVZBMV9VFOdCL35wP5IQTbfyQzXAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_golem_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAMFJREFUOI2VkwsShCAMQ2vuf+gdJUmDC8PI+EF4pmmBug6tvgK42w7Ac90PbAD9iw3wSIDXJoQ6JyA0KsZivkWqh8AZmRki1doiQLMjTPV8IM1OgEz4hyuBqLDL5RBD9qXAypeDxwT+gHGDXaCrYYASUJLPmx4WDuAINIm2ppwizfAQW4FRJmBIAQsFOo5Kvwslz+K6Xt4wzIVu4LwSsDq6G1vO6UHbYwIALdk6hA5ML6RiVC5wrrTeUmAz6O/j6f4BJx0FD0j789sAAAAASUVORK5CYII=",
        );
    svg
}

fn get_gorgon_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAATRJREFUWIW1V1sOwkAIROPFvJPH6J16NP2RBCkzwLJOQuw+Wl4Du4qIvL0ccl7mkHT2RnIXgENOtNTak+H2taSk4CXPnzU7nqAcVp2364ecl/3RHBGuBCnzSnQcvcfkJwU+rDqOcq3zO9IAQ+Y99GurXjup5zxLz6IReX2zjzKjKvKIcmJzjp53leSlEakSSzJLxH/0AhjaiHiV504aYCuOvNXfrDzt/lEEsmc77nqeRgDltjtfAbWw4tXkSKYcUFTKchVhH/AKfBlGJTnBOKyTFMAI+DLb5W2EZS+Hp2CdhBF2EFAkOAs6StmlRDtmBloFzIhMuW/JjEMjDlS5QXhSN4BdSJnBCVnrjGVHdPWo9t9sc4BdSLLOidCq26nHgfSbB7qKr9wN6H/DDCi0nbY9MmAHPiTeytgXlEBhAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_griffin_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAAMxJREFUOI2FUlEWwzAIUu5/6C0JKGZ9a37SZwmgGPly4qGGCcADAvgP+NbQgIW3IxF9xyWZp4z6jhwUen5UViGm7VU6gCQ4VB8UaK89B9wUKZMJGI1eogHVE5pCRmtQJLZGdM1JOni3SUCp191Gwpo6T8kgyki4RpoJcA4T4B1tE79hXbN0gHkZDIXAoEFn0dHcM+E+KCdzyMEyC/0vD04XLWBuoQgtzWFSee4ubD2cQoFHi8PbqInfEm6UJm0B2d7hYvJRknOOtg8v5wOFywUbW3VO1AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_harpy_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAAD/rmEGTQAAAAN0Uk5TAP//RFDWIQAAAL9JREFUOI2FkwsOwyAMQ1Pf/9DrCv6ERmo3jQYeODFZXR9PZYD7i2eYAPw/C0Ew1fev5TyjuLaP0ECq/EoROBaQMx4M3O9PJAnNhMSuLwZL7NqgZDNcAJy/a0ECW8ZJKhkCMIE2FUDYhxHIK5oAqzTHTwnaNErQTy1PZbKWo0wx2qlNlZ1gN11XAC+/XwDzzBzVcnGF1jgBWhG2RdMiVqCK1fbZyOFoAvtw/R4Au5RavnsCzYi8/QZcQ9D+3dPzA4tsBSRylHBPAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_hippogriff_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAMZJREFUOI2Fk4kOwyAMQ4P//6PXksMOZBtCKoInxzlq68+y4Q57F4DfxKMAXw3AyhuGECw/CaiAHxBxEApQgXyMMKaaflCLKA8qUAS6yRJIoExShM8YgLL2FXgjoLgJ2C8hISbf2JGDOgjO/P2IkFnCgdbQXgfcQPmIPQCRAW4FcqBLy/40QLSaAjgNZdWYNgpiVx8gMz8MIIthvXflDYmYXLQsafICFku/ZxLaGi2IK00AR9iH9iTA3yo8IAeWZaLe9He39QFNtQUDkNPYpgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_hydra_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAjAC/MJKlOQAAAAN0Uk5TAP//RFDWIQAAAN5JREFUOI2FUwkSg0AIg/z/0a1CjtXO1PFYXUhCwOo/R8Ua+F4/A7jhCDwDsI/r6PgUAVdycGhVN/LmAbtk9EuD2ZRU83Lra1BbkNUI2HgxYPOEcINMHWQ4jCK+BTJ+qxhWLAK373tYnT4+nKRwLDmrklFHKxDO28k2swDmrKwJlieIauYNxGSHa+UKm+BQYxbBKtQYm1byABIBCRIFohACxMC0HHK71PKgAA4FEtkR4n5rpW6uUISvtBrCJIo865cPHAj3vjTFp9Ac+6ia0+mR9H+x8IbKX0/7TI+Z+wAytgWa3LC2QwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_jaguar_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAMxJREFUOI2VUlEWwzAIUu5/6G1RQNe+9S39SRUBNZEPJ8YdDwDcIv4AvPMCALqHk4ydpBBxIrNcSiAAy3+VHsJTFVXvNIvRZCEuHGelZTsfhgIg5SYdaYkmBbm7i2MnRmL1YQ9o5lk9sEEsS91GMQd7g1wAOejCmjBJf+AusMQhKQHcajuCZq5tKkiitW5aAAX0l+5CzOoW9MCZwU446/Ee4GeGC4PW5715J/Ed8MBLdAH8GOXLo54acuNlGaHyPSj5G9uYgBnJG8Cv8wJtjgUiWsDz8QAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_jiangshi_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAAJpJREFUOI3Nk0kSwCAIBIH/PzolYRkWbznEAyXY4kACcVvSfIIjWAkDkJfFLpzNHZCZgeEBf6UDgYFIdCWMZzwZQDcAHiWXe4xG1JoxDaZXq1LEXB5AqW8FXPEdgGoK8GoDNqU4IPUzZog4UoBAjgQGtA4alMBQBmz9YdpmZpDo5QVY5FA9n86HQJsH+SXA2F/ZysTphWCZrG09N3IEyUneHIcAAAAASUVORK5CYII=",
        );
    svg
}

fn get_jotunn_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAQ1JREFUSImtVlEWwjAIA5/3v3L90cogCczK82NSIIEBndmRrPCwoMXjDGBj+IlzaxPzuBd9lb9JU42nGDpWVUbNCEMn/k8MZipOf6xVYq39b2O0Gkhr2XgO7vXfR9xsCQDWSO30xtFzBgDnM0X0K962uXjBEa/RU5R6tME8YdQMIHexamAeVMQA69PpqqgRoT4qmQt2EB0iBm1rpvTbOmiXIwxorOT8RtMCSMyTGN13IgPvMHxe+gyLnuHrbZc2ziBSc4Ix/YzYAHXbsP2zwq+XtEnq+kyhq3ten8lYMKU+iEf1ehuzbcrEZ9X/BoEvmXU9C60aWvcyiwjvDEzuyaPblbXgoao6mcbfJ9bMXmrpm6m8R29bAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_juggernaut_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAjAC/MJKlOQAAAAN0Uk5TAP//RFDWIQAAAMpJREFUOI11kwEWgzAIQyH3P/RWB0mgrk+f2v6mEDDSBl7eIgeB73XudADGn/Varmc869DgVyleCgygIAdMXYeEQoYpPGvPBgGSab4BjL0WzRERgJ5JzaTHMAVuAH585+FpouLWWXRSVrbqroXzbdEFWCq3AiwtWDk3ADCPlxh+c9UrQ8OKxYRzAVZuGiRiAHy1Hpr9ABkBU5A7WIYkm1a7dEoBnKwTuieaCJmkxwKogHKrC79iUJL9H80s6q9qT9mBkfcmfjrwd3wAu4YFMBJ5c6EAAAAASUVORK5CYII=",
        );
    svg
}

fn get_kappa_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAALlJREFUOI2Vk4sOxSAIQ7H//9FblEcLLjfXLM7psRR0tn408ze8A2oswLsCxtAVzgp2y90SIgWahIlAG9xCbJu3EGF8S38DGBH+Uzh7VaABqP4CeCWgiMky/Fmz1OKNP0ym/CyYYCB0gQFkBTgdKAAi4AUZQLUGHEEOUTaNUhAgCKOcpA4xbWSPLJRVo+Cq4FYYGKdZQBQyckTkBfeQ2zIZxNUxiYo+rkryz4LcnpXEajcRmbzcyVt7AOjLBOSqQZabAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_kelpie_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8A/////zPWCAAAAAR0Uk5TAP///7MtQIgAAADBSURBVDiNhZMLDoMwDENTvfvfeWP5OS2wIqBSXxPXBlt/huWEV4ACrhn3AE1yX8EfeyvzdYj7kBMVUgFHjWqRh9lVNkAT2sRknWyDECZ8WbG3yJ2l46lFA2cFpgwpZ1KdeRQ9ZnShPF9sQIXBShIFiN2LNd8dVksgex0iM0uPgwPoXZm9+ICuO/IbDnjN6Xh8FwQgDWao33n5sGdBXPtn365GIFaalhBhJcw0c3V4Z2mN1Kclyr+pg8z1CVC1r8A1Pnr9BbUUk/lCAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_kitsune_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAVdJREFUWIWtVsERwzAII7ku1p06RnbKaOmn9FwsgXDKna+xDbLAYGpmdqnjsPPWPhq7iXLYOc19ZHqKSJ67d/EXrTUj0Q99RoLN2ZiugIVWDS+zY5hTBKJXzEv1O4sSjMAoL3u2ooD2EEaU8u7YfUYPV3AeiLF7UrFXvDOzEk/K/k5pdey2jxL1So2G6jU6q2SserSIgx+R7GHpkizw8ixXALMDhCrJS2rlfc9swDnrtV1dlYK7OYsorDIOO2lFxL2sulwoAUTGQbrzTG5FAB18KwKVQRb+SifDlh6YzruQJXLU3yvWaM+9Gf9kxFbsTY21aF+fuuEI1n3/0UEV3peA0pDGfbQWbXwtEpkIZHUdATpJGO2RLSxDFLJ/r41SZm+nHzT7wG8zygArvY7u1IxUttG7UUdt3RGLlmFVCSjZ0F6VwFIZsjUkTA+VrpnYDUdBRJWmw+QNAAMBDX21h8UAAAAASUVORK5CYII=",
        );
    svg
}

fn get_kraken_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAASxJREFUWIXFVtEOwyAIxGUf3U/wr92TCSUcHNRtJKTWqhwIV4aILPmjvJ9sXvP+Pq7mOR1dk5vL9NVCPLG3NiqZlK9gG/AMjesHALahUwIBaE+swf3NeuwB02uhLatr3hMKjdFee4Y9T+sQkgeikkP5wErqkUWPPEJzUdTCJNTl5kVgf0c5oSMRli7yPBpvz/S79yQ0TyZkHIW5AgIyoVd6es4rwSoJiYi0qDgSnRcsKOrHw3ADU/eOcgCqa44B6LBgBcDRHMg4wRMaQEQkTyQE8C2jNAANhJXqNaQA2Ch4pMQCp7KV4frGf4CrgmouVGm5VdtM50NGgjeO2C66ngxEiYhQc/JEykx4mhsggKgdQ3Nsm5YC8IxnXnsGGRBuW44aUD22zWa0R89Z+QCqlz2k0H53+wAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_leprechaun_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAMNJREFUWIXtVssOwyAMc6r9/y+np2g0BZaYFaQKn/q24zoBAaBYiGMl+RawBWwBAPBhX1S9jg8RmSdAVW+EtWsRvOcXsBAsXgtSDkSrzmQh7UAvbEwQ6S4AvpWO5IES4KscEUKFsEU0ZQ6U5CJyIX3cgTJkrVGcDWLYAftwr8rIM7SAGpEhSzoswAgtA+xCBBAZ8CL8sZ1HkXKg1v+tmfCIgB7J9A3Jv0A74LuAdWD5jogW4NtwioBf/c6IGVqMMvdaOAHZ92xVz90wqgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_leviathan_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAARFJREFUSImlVkEOwyAMg2mP3hP66/bAxJCT2IblULUQbBISl9aU3Ve7LzFC7CXRnRHC17fQf8s+6DNHwN4EPa6JuUrR1/E8goE+/NKtAdPqA6x4BiOhA314pImqEhJj6jBH9sIRxQ78sqtWjdBjRXVCsJZKfIdMAk4ZgbMpcF6fjbQF+HFvyaGZztBXaKEoEt3k6HCAq6X9mbb3PO28e2L2uaJVChgjyBFNBXU4ttEdTwz0LBsOh1AHUmQVfVpF4o/GbUr6+hn1ozQZQeqzlyU5JVudpcgK8/+Fu4W0h8XdHCncpvf7LqeVu0i1WgK65ojSOQ0khPfztB7nqptW9dv4AhWlqW8VwMqjjjeMfngatj27QywUyyWIVgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_lich_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAACnSURBVDiNjZILEoAgCERx9v53rpTPAmYxjTrygAWT8WHyLDgDwPOpAWjAnYD9hSglMKEGhM1yHYC70SQzsNSWHAFgpdd1mJjoQoN9V7Fi6Lyf7Iq2QgaoWxGSIq4+xgXuR/wqHVQWA4NGEFgHXL1BYjEcNehQNKR8BHgLL2+RYm3GCQC7s8nuEg3ICg9/VO1xUyI9SgWQtpPIDtBD74HPDO8S/g7qYBdzqwU9vZyI5AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_manticore_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAAMlJREFUOI2VUwEOhDAIg/7/0acMWnAzFxejUUopBc3/HPsAwLpf5x2QQZwBrlRhpwZMbNymSOgZF7YumoZFcgPualhlqwuIxCIWH9FEgCQWpcDEh6IoEUGqPgBA854urhLZT1PWwiESLoEgTTWcGjw7ZHJmLIZdf4PNLvY20gdvQhWNFyvrR7RthSlXCPgA1LRyfAyphGMYcQB45XJqZb0WRvxdRjrZmKGeB4DzQB+JAJTATap55T7MuGaDtpM0e/AI4PvB8b/Yzw8ulgUFnTfMVQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_mantis_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAXtJREFUWIXFV9mOAzEIM9H+/y+zTxkxLuboPixS1U447CFAUgPg+Ec5SuHucM+5xXX1W8VjG0OSAXeHmT3GZtYS6Wyi/sYHkgxE5f3O3ozXlI2ZSXIA8KPAr9xMsK4KqgiVBDJwBuN0xq1SNp3IItwQ+RYcAM7WicH4ewMOhC6otkDpsi2Y+EVd2obK4WGdgHLrXjv25/p5dYECU/pJK1brgJgDnXTdwvGy9bv2MQfYKBsmKt1qWxQpd+/bkIGmMpkrrxrI3p5JRMfqbStwlsPganbHkVxJB87+q0l4iURCEXSSdpYzMYr6rEW30y9KOgeUZNUfiW1Sf+VMjDIS8TPx//MWxFH6TVsqWWVApXpyEiqbVRGyDd+UurMgi3+mwBlAd9/rwB8C0XgyaKYgk6152rC7WEQ7RWQL/iLQkeBgVfutzwIFkpFjoOx5MxnbK1l25lektgQ+TkMFHoNPqr+TG/vwQvbc3mwX/5g+Yru7V+1TtRjrtzXg7vgFKKGDVGX90zEAAAAASUVORK5CYII=",
        );
    svg
}

fn get_minotaur_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA/4AABnhFZgAAAAN0Uk5TAP//RFDWIQAAANhJREFUOI1lk4ESwyAIQ0P+/6N3KiShc7eeQgoPpKhZZMXSAdd1Vu01FhzxnzcksJ9abeFJdAT3PKp+cBLfCKLgUtwftBUIS0o25OMQKTfkSk9nKJXZ9gcaFS9BvGoUWhDNqU8IeJtVeIco7JNdZTqfg70S2QKmK3BuaVBHMgZ1f9PqdJrpQmYbk4P9InzZ6u46I+3f67qQXBZ7erSGYc9AVg4Ozf5TE8Vow2qFBEw6p2gz4Y/Go15UhhZwB48AT9BzwixhPgQIeIGYCNOQaHYUxGHIaUxk8geWOAU3PiV9ywAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_nemeanlion_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAVFJREFUWIXtVtEOAyEIw+X+/5fdyy6rtRRuW7KHrclFT5EiAjoiYsYXcfsm+d+AHzLAhPlhhUfj/w3yCPTAfHyn0gH/g/5x3hGgvDXgVMLKK6UDxhyMvmMTYGNm7LtXBlfErGMZnkIYoVxZKN6gNhLnESgleL5DjF0hN3jGgAqycw5bNhJbB9QP8nsM8CLVd2suYvUAgwmckZM+BeEF7QHMf1V4OCM6xiceew4nUZqSVJmTGUQchyTvWO/kFRKPrR5QytVOXrkTBHkE3gWcflUaVlWwif065mBULfez9Q2s13FW6xVBlQUKaSl2wkFtRXaxQOXiKjNU5FdZU3ixZ6+6qN6IfJyr34SOHMtup2wL7G9CVpAFZvc9UNQMfQTu9YPz7gHDLDz3WL96oEqxatedakpbXl/FikzNu/N19UFc1XkMoDLsu+h3Mkk6f+hd8zruqcKZOlY8Mk4AAAAASUVORK5CYII=",
        );
    svg
}

fn get_nephilim_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAACpSURBVDiNrZONDsQgCINH+v7vfJmApYK5XHLG+fuNleoe+1KeHADwrkwEeJffitUOEXzTSyU0Ako3AK4AkKX/ArmFWxYrgew6sNKLLAtRgHTCxCpanS67iGY1dgbxYAIADg7AhW0N5TwEsHx3BuKYgmhALIQDzFQjlGbUkEleNfA0Rw0SoWsgxol+wqReIuwsbBBpR1WANtAIBSwuUvtzfry0x0ABVIDEBxciBgM4SLpkAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_nue_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAADXSURBVDiNhVMJDsMwCAP5/3/eFvDRVlOzrlLBss2R6pdT3z/m/AXg/NqIC3wZJhp5IUqBjeEQ/t5YAI4ISHSeDVJiAutiCIYjJJpWbFYS6Z2ZcFmRFk/WUbfKIfE2IIpiIQ+JlO9WjdcqhFsaAuKL8tsQM9DeItTbZBjzO9SdXjBsFtKDnHFYTgcdBgBBWuYgF9U38gFB7+pIeAu8gwa0YSIIBrjFsBBnAZOG02HSVseg3egBxPS5lBwJtlFyFMWwjrIB77sswhcnWn3dct0LFni/xtUv5wPa5watFtZaaAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_ogre_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAWRJREFUWIWtV0ESAyEIw53+/8v20KFNs4miK5fOKEsiYKQtIno8tN5/IVprS/6vp+AI3Hu3ZHAd/Y8RYEAGdZm5ToHzCdESPH0wU0cIqNMhoQTMtKd/a+1cBhA0fxEIwf9KEwduARPg5lPNmGtHM8Dglf3tW6A6vKoB6LeVAe740Q2Y7S8TcMHcOmdluwTcPKoEqglVHNyfEmAgBOFrxXKsiPDasAROSrnp3IlnvREx0AFOlduv+I1IygyMgj5twturGJSB2Ykc2G4WtoSoIjhV+ysBPya7poYPF1f2wKxuJ+1GYCW9O8T4mws33GAxGjhcQ1Yb9XIgPGAq8FFtFQk1kFglVCqnZBZJ8Bim1JNt6TFyQdQEVFHJCBAiNTpVBGnFRwlS+6yvg6+ae9ikEKmPq1dO+WJZbk3oXjW8ZvlhxRSI+tv2JaBOUOneChGOaXVgRuKpOWGKiLh4tDrdfGj4Fy3tDQ0lUDS7MbOrAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_oni_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAUNJREFUWIW9VtEOAjEIY8b//+X5YEwQ2gK70yZGc4elG6xsmdm2hG1mKz++BMz5wIG/QuZ+5IC7V+6xkgiwA/8FEZCVXgPf2SDAJ75LhE+ehRQluCqi7ikgICY9FRGTYzGCHRGY1acExbV7QMHXcZJc46kTIuWqJOid7oMgINaeEakVMuGYG0je+PHYIdH/R8cwrna7j0rqY+odEz2AxPhEnWc95sNxrB2uyzk4hnH7F/ldlekbTSNCIarLY8wtRvQhRKI2eN9DcQqYs6EkLGZkRArVUFImxlEIiOaBhpNKejSOFTrdPRvdgxJEi47HMN6kemVoCGBzoXrWEzG47lQrVDvE0SwBst1q2h3tgCdnTndyJePcTgCz0kioVobsm1X5HffUpIqw2wOae5ntjUmZs3V7oMcBegARst5QV3D0ncW8ANrAhEO3Zl04AAAAAElFTkSuQmCC",
        );
    svg
}

fn get_orc_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAATtJREFUSImtVkkSAyEIBGv+/2VzMCEEuhGteEpYmqWRUeXkzDlFRFXtR9YG+ejjmn9HbsKRFdkBomT5SlxVQQUeNxQe/IW0gsWOLYI+JvTaLLSO+bIeSeXPOWGYbAb/Ll/MQXZj1Wznx5j4iSafEWTNrccUJwSz9p4MNMihr6wWQeo8ilf5Ue5Q9RTVedPVt4zILo1ZDsuuGNAwGAwdIgxmkdPPwuALq6l2USDWx/Bzyapfp8uBwYmbn8Ly67LFrYHs3jAvcJPh1MK59Fo263jstnlB2jM6qEDKy8k2mgkz25gDv5HyqthmvQ8ghNsCna1IfA8YmUzFPs5S34MiRkFyOJhkZu336Bb6jdYxMvSQRIft1ruIBet80boBOg05mKILrJt1bafz1GA2ZxXAN0udwVmA4kXznwAX5wXBryxTNJai3QAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_pegasus_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAVRJREFUWIW9V1EWwyAI073e/8ruZ04EAmG142edJRKCou2ttdEok26dgxB21dxnYJaMl9vuTxIYH+CcsKt3zJhPqLujMLhWoCsf/YwDT3yigM58Af1gmixSYpEKCMjJs0WHhES45QsIRDLKcZ1ltqHsHK8E8QF5hKRFmQ7xbMeBAln9UDC9WLVa2t8QkEHvNpusNF2/jbaZfh8FYogvv2sfmL8REW1ehmj7Ssz3aQx/70rHKDNv73v19vFgF7AKoOBy9bcWqQFKkEmoiXoEGXxrF58dY1kprKkSeEAuk92fxzlrAB0+FRI8rjhztTtKXGkXIJs9AvX4uhUJeERY831/JCCJVMySuElgkoiU0Kfj3qQOEIgCo8W3SBev5ZXgXHkeVMAz2yUPEZDrIMrenjMPKBDdgOwh9+cSSDtaguzLSAbd1TlAQF+3M+vm371mDj/bOHsDJrB6SwMuoZ0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_phoenix_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAABVQTFRFAAAAAAAAAP8A/4gAjAC/AAD/////XlWhuwAAAAd0Uk5TAP///////6V/pvsAAADESURBVDiNjVIBEsMgCJPL//88a0kI1q3zej2FACEw4uWMPwD47sUNgL27fwHmXxBs7vlliQWBI2iZGW4rEbBcl2tlIPryo+BgBo8Hr7QP3TIKCaJVHKKzjRMH0+PIQV3o4RwyUBRMatchz1MH5SdAfuNgXZbqTQdX0nWINszqIu2DgdIj+2cqrdwyq81aom0ni8MRsHFoAITKog2MJNl6vzWSlK5WZi+hIdXCJACWWOCUo5XQ1NBLIDhBccjJchY/zyvgA0eqBfsWjmxzAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_pixie_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAA9QTFRFAAAAAAAAAP8A////AAD/tOJkVwAAAAV0Uk5TAP////8c0CZSAAAAkElEQVQ4ja2SCwrAIAxDK7n/nYdiP7FVGZsgin3EpCrtMuRPAMAR6OWCMGCUT4AyHwB0l/kWSlG5oCvWoEgAC2BVaMj1pVERAXsYAcbUSGxSA1orTEmC/GwFyK44rx5AcVVhvhVSGPNAzjIwZYovEwFynwHQkgHPUAPwMjYAls1bwI93HhyoFOJfQtnq/bgCDz8WBQVaYwgSAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_qilin_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AjAC/THy84wAAAAR0Uk5TAP///7MtQIgAAADTSURBVDiNhZMLDsMgDEMT+f53bktwbIK0MamM6uVjh0b+WdH/8P5qT0BHAesFavsQzAwM3LG4ShRSoUowAEHr2QAYaUjtBawj4FnYBD5gZRw62UUBkn46klUCVM7KTaIyWG0wrskBqD8942yf4lQrcrSQo+WwERQFGiOr+RJtATXS6oS13WLqEDowxa4Pyjy1uQUrKNwid4N1TqCnJVNDBekG2oU9rLZInlqf4dFyW3oj+wZiILLaxiQGBrQEeCWz+hy4X+nUtc97QbPAD+L+ssZ6AJpoBiX1LtEcAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_rakshasa_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAQtJREFUSImtVkkSwzAIM3lJp2/o/79GD+l4AYRR4xwyMQbJFkvbGvFoa8rY/3kQwXl0dctHcCE64ljsgtH9Vn5MmQLD8CrWVqi9XFsPdW/Dt0GgMoacf/aLwaLQ70wEBPv8rDokZUJurLso1Zs05MWTJ1ABfYkgbDrEl2lQHzUGvS/pAn06cHICNGqMkSBGifKCaF0Wj5KMYlol02g9vo/GvO9oiebISsnS0JUArvDN9SuDCEHHgRScB51B2MMdID6DcrLVifS+X5/7QyJXWS0ViQ3TgL1AsL+4rJbwr5F3G52MamO+YmXsWL5rPaDhF1zp3n+2jLFo1t6jGzX6TiwWJKwQ8zuM3gmOfgHWEqIKfpZ+TwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_rat_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAA////g93P0gAAAAN0Uk5TAP//RFDWIQAAALtJREFUOI2FkwEOwzAIA4n//+htSQw2dFtURWq5Gpumsf6s8FvgF4Dc6tYV8LngWhO4Qk8AW7xrmMB9svdNXDqs3CwiFainOSCA1a0bNoDVASY5AJrAqgzHJAXGlNdp0Rtkm7OHDcBD7k5UgJeYgQr6uhgCPdiz9tUjU/M7eEdNkfO31GHxaH7V+CZwamDwB4W08QUomwTslIx+AiCnqEsV6rwABhTBCUirdiYhjAJXF82mAumzE+3vnusF6bME0K/qcSgAAAAASUVORK5CYII=",
        );
    svg
}

fn get_roc_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAMhJREFUSInNVlsOgDAI24z3vzL+Gh6lwBLlwyzbbAsIuNZhk9dC0MUZ+qqii1lMrk3ROwRpQPvhtrpcrCaBDU4UroiAIrZYPDoicI+VBwBC77sysQTK/Su7uuPTzRDcEBpzswbqqF8777dSFKaSk+IAHOQXGR7ZHKisUplkWMkQl/qdqF2G41jP+ZKjTNCYoqSjOgclq7XrSHtpM6eUOFx44FD6ABx4si09ahWkH3ZWO44yvw6uOiBuZGD6l8qWpSHpT1o14L+1B1zYk3wE/fgqAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_satori_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAUJJREFUWIXFl1sOxCAIRdHM/rfsfExN6ZWLiDZD0rSxFg4P0RYRafJHqdMZL+ONAE1dIiJFPb8AMwKU60KDTY0fhHkCaM87DEJYMFsAaJAZ1xDsXQqgK7M8ZXKwFm5frKLDmWjci0QwRT8VM49QGUsbzglAVFNJgTsajqyGYJ3wRoQQmcoPQNRBOfMOayDaE3SRG/M+lNRrPDi3f+9FiDgwRgA9xLZsyUp6eqdtGsBrOgjDQCJpMMbqY4ApswwXWS9KA2y+HVuGmSQ65NgJPePaEAurJ0atPIswosB6jhgnUgcqr+16hpMblF0DFoS3Qa0sQdAzb8Ur7xJR8FeBrgt2RygWrRQAKl8J9cLUduSMF9FBl+HsoxclloITQiI0B4icbDZSmIvAalocQH87ZnLop+QG2JHN9MT7wOzAkTAuIvIFbsdiOX8KB4MAAAAASUVORK5CYII=",
        );
    svg
}

fn get_skeleton_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8A/////zPWCAAAAAR0Uk5TAP///7MtQIgAAACiSURBVDiNjZNRFoAgCAT17f3vXKnACoj54SsZ1zGz9Utro4e84m0V8FbREQEd/OajAk5LwCJSyVUec5E6jDEsxEkoMO2kjwBmwnwAuTbbv+SsGhgQQZixEALIIMgBHpiCugAIoE8pYdgSxBm6WQ+Qme0hdWDFCGi+BXiAj6Qfge23yAFqfwH+ZQqgx7oDbkuUkqiBnwnxVmwJ66jcxWjJpK09hJkFbcnr6SEAAAAASUVORK5CYII=",
        );
    svg
}

fn get_skinwalker_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAWxJREFUWIWtV9mtAyEMHFZpLD2lDHqiNPKR8GS844u8kVZBYOzBF6QBmCiiY9zmXnhW1QAArqWMKbWMS2NrXNkv0QDMpVQuWifyDGX2aJnWMeYynjmNJFrdZ2F2jIlPLmxj78vKRfIP74Rsfp2EnUiHUo8ZbgQ84SxYklpoX9dQYR1fL9ZaTleLhcfa7Lndk5FkpVzWi64HPAOaqJapYHYMN6vluiUbrVvflXGXXme54q17uDxFFnT7/qVqrljE7v+/lutGwFOWNVTJ/j8COquzYdCGT/eHrZglYNQzqrmxlRAOSpDpKJTj3ZBlgBmJfiMSbbHIus56vLB5CUvnrQyjns+uWOsCSucAsMcRSfexh8zax0LGPrMRvfB0vcFcnrktNdKdkBE8dblJwKtxRsQyeHwZRZCKs/8novZcIsDIeI/TDEICLCwdY/NA9h3IvEVfxRlSbHyC4xBEOaDLM90Js/ivR8kxgSosT70BoEuLXJFOBDgAAAAASUVORK5CYII=",
        );
    svg
}

fn get_spider_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAUtJREFUWIXFlksSxCAIRGFq7n9lZqVlSDcCJjUu46cfDWhUREz+OL4nm804u6qmzlBpOhCJV0A+b4pn1pYBKuKqKqoa7jmqgUhY5AprZjAdpRrIRL+L2EO0aqArLnIPIg2wO5iJjzpg4xEHInEzo/m/AFSquyK+nk+LcF2IFnXh2Fg11MzMt032Gu2A+bOnAxEEszg7P9bAFKz+I4hM9XuQiqMzBdnIV+FIIOOKiLsJs5F7cW8vcwKBXIpwFwGCy+aawcE27L71qJjZuvGdPkaRA2w9szyEGACIOMrdTpwVs/9+ScFtElQ6++5BECSCmPcAE/fC/rCxN9t2tyJEXXDS36X8syKsvP27dyPKvwj5H5j2oJuL2D3e/ahwEcy2DZl961w3/yHA2JBpJwYYBbB1wEOc/Cu0bsInRgbi0d9yP6L2HHOvAngINPcDboFfHhnxxOIAAAAASUVORK5CYII=",
        );
    svg
}

fn get_sprite_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAKhJREFUOI2NklEOwzAIQ5N3/0NvWlOwgWrNR2uBYwJm7T9nBWLDQV/YCb8gF9rCSIUdyaEEE4EkkLcaXMo2AlaCjOLUooBB7QKJKQ4FTiqGRFG4wwI6gVuBgaAp1A3tgvLzElnf/Xhp1lsCV/s8EE4Os9RWTiY5rtzOOYyDKm3SCZlRieUC+SmTdIN08QsBE0tCuKMPwAmYUTlQXzl5ia2cbn3d++JmPx+LjwSp65nJ7wAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_tarrasque_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAW5JREFUWIXFV1uOwyAMNKs9dI7QW9OPypGZzNh4o02REI3jMIPxq8PMpn1x/KgX8/VlAk+ROAkwsHE8Q2Ka2Zyvz/Rnl8UVp5J35nIFeOL4jJaIz3esdBJwMGb2caxAvjLdLplhEIaRBAIjKaWD71oEFGAFHsHQQhmR3x1gFQ0MqLLcZW8jV5B+UIQmswoj5+OSiFwBVwaO7xxMgftY9rBGLWDgKmxRhvouv1gAQy2u0Sp4UtRhMv8did7yAZU7lBNSn0ACikR2/1U+UHuN448+oDy6a43zendmLExZkYoy1y2+rYEZ4G6lrEikV5BlRmbynSuJ5k99oHJEFdeMCNtP5oEMHIGzBMP6CBY5W3kgq2ZVAcv6DLOiKa1G5SNRR+kuBDqn3ylKTC4JoAN1zL7T/WAtWQioDKd6vqxkZ8SY1WhTWp0iazAQoNqz/Ge001gyXVUJKUnbSK1MJ9Nl38Y0HGbvn8wdEmy2yvF/jDfxpN91/a0m7AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_titan_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqCmYQcchQnVoQFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdXFSdJES/5cUWsR4cNyPd/ced++AYKPKNKtrDNB028ykkmIuvyJGXhFBPwSEEZeZZcxKUhq+4+seAb7eJXiW/7k/R69asBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU+J46bdEHiR64rHr9xLrkc5JmCmc3MEQvEYqmDlQ5mZVMjniSOqZpO+cGcxyrnLc5atcZa9+QvjBb05SWu0xxGCgtYhAQRCmqooAobCVp1UixkaD/p4x9y/RK5FHJVwMgxjw1okF0/+B/87tYqTox7SdEkEH5xnI8RILILNOuO833sOM0TIPQMXOlt/0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcYfDJkU3alEM1gsQi8n9E35YGBW6Bn1euttY/TByBLXaVvgINDYLRE2Ws+7+7u7O3fM63+fgBXknKcyUKElgAAAUtJREFUWIW9V1sOgzAMC2gX404cgztxNPZVFGV2GrfVLE0aXRu7eZFtZvaYgMtuuH7aoZh5sSkCGnkkY+tLBXiS6AW/por4KJsReRM3GoJdIc/AcmOZAERy2jF88wYpCb2IFo4moJcjSwV4csX1SIiUhJ4sGutVwmU3TNayAJb9VbEsDFISVsBuz7BEQCONCVkV8VQ/l93lvegsOj/lgZZYFWSl+DcPIBtlD7C4+vXs+5QHvOoWS7QWz7Bbh2fN7ZUwRHHZ72kIottR+2V7qoACfGx9bVcMR4G998VPK45EM+NWBaUQREGx440OI10BkRyJY88M0cNwHuhNvz2wYQXZNBvsgr4fZKXWK2NpIIm3ZFByY1hAlcDvRaLlPyYqUF/woB5Y8Zqt9JDXAysImYjszJ6R+1ELDZYzDchjaAhhZabYMGUgmUH2QvoC6Kp2/lujcjkAAAAASUVORK5CYII=",
        );
    svg
}

fn get_troll_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAOBJREFUSImtVVsOgDAIG8b7Xxk/TIzh0bULfk1XWhgd2qIfd38XZsZHyexhPc+uylyDkgMCL6+7820QBMomf5I8T8tbfnT3GfatTIehBBiPCuyBtDwNUBClhKGAIm/dGfGZJHhxbFRIxghI9pRKHHli4fXKe9JFXWuZmWyhbt2dXolEAtiOJXWXWT2LtKrJkH/u/O9lW8EGTbJTAlouPbJtMkDzSkIbMjp7VG1YpCAt/w/UvMfMmaDBCuDa+WsoaIDEz9mzTCbdCrSjAsQcDJL6ObjPJ+wdy4kvy2DQBkbjAdZatI8bL86ZAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_typhon_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAYAAAC4JqlRAAABfWlDQ1BzUkdCAAAokX2RPUjDQBzFX1tLRSoKZhBxyFCdWhAVcdQqFKFCqBVadTC59AuaGJIUF0fBteDgx2LVwcVZVwdXQRD8AHF1cVJ0kRL/lxRaxHhw3I939x5374Bgo8o0q2sM0HTbzKSSYi6/IkZeEUE/BIQRl5llzEpSGr7j6x4Bvt4leJb/uT9Hr1qwGBAQiWeYYdrE68RTm7bBeZ9YYGVZJT4njpt0QeJHrisev3EuuRzkmYKZzcwRC8RiqYOVDmZlUyOeJI6pmk75wZzHKuctzlq1xlr35C+MFvTlJa7THEYKC1iEBBEKaqigChsJWnVSLGRoP+njH3L9ErkUclXAyDGPDWiQXT/4H/zu1ipOjHtJ0SQQfnGcjxEgsgs0647zfew4zRMg9Axc6W3/RgOY/iS93tZiR0DfNnBx3daUPeByBxh8MmRTdqUQzWCxCLyf0TflgYFboGfV6621j9MHIEtdpW+Ag0NgtETZaz7v7u7s7d8zrf5+AFeScpwisFufAAABh0lEQVRYhc1XUa7EIAjEpofuEby1+/HWDYVhQL4eSbONIkxxGF0RkXXyrNmbi55LGrZmbaxiLQA6aTfxtiF/pThODIM9PRD/hwO7pJWyap+qfxR7renRR1/TqQCK/RvTk/vd/kYBdaCKr/VbU9bNyjYeXzJNNEQ65o/sx4E1vbMeG48HZPd0++s1CJAeczqAgCA7JSECAwFYIBYQA2f9dIzIbpSEgarMZ7FsTsjgrC13B5y0cODj2+lEEzq9r9/Hd+BVHltuPZaV91XaQtxb74m27sFSjbHnnBAxojnyGNJVWI+stKdi9pZJOFtrfaAORF9glXEbU74spruQWJJE3DgZR2R85bRP1t9MN5heIH94GmbqeNI1KNZeuybogiggOvXsPAOB4ogoDjAdRwRiAI98JFDCEHGjz9m94LIT7JyvMPrkljSe730AfXUlOapEdl7YuQsJS7Yo89FXs+wyQ4UILWJVqGyRNdeGUcKo5Jn8sqNZJPlvmJ2MUeBql4yHAOgmj9ZH4D7THTIdDRz0OAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_vampire_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAAD/rmEGTQAAAAN0Uk5TAP//RFDWIQAAAMRJREFUOI2NUlEWwzAIUu5/6G0NIibt6/LRFyMiWiJfTngAngdAJxzSgFGHEzDyFsZ9vh/+AeAZgMXwFX3kf8lrmNB1n4JlwagKVvoKM50BTNi3GZIFRTaeBDDe0rQBSinYZAMgZwvNHiMaGpANqISW2kzjX0ik7d4BpbTJcvoBd/fpKFnyxlFaXq/1BMxpNpFuCv29BVh9tV1dl5wAxZX6moBiQculiVcFLcduaiTyVRpuIt9kcYbW44apJ7aAIXoAPn0A2q8FC6y+R30AAAAASUVORK5CYII=",
        );
    svg
}

fn get_warlock_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAASFJREFUSIm1VW2uxCAIVE/dI+yt3/vBBu0wfLVZstlQhAFGxTF+IH+frc+HYVc1aj1Al0+wgKeuVjugcGkfXhGJX1r+KT2K0oqkp6KzW1cjst5BXdrlQ6TV35ZDsYJ9BiEUaXAKUTlL01rn9dVVGfcjD7hwGyBkqVX9VKekx23ZkHVmO3PQYDqOaEO6OsHppMV+gsiq/ivUaVlevaM8MhURsoosMckvQN8tM7vNsR28isAyzOmie+CluWE9uKUSRW9P6T0ABnawuRy26sa4tuxXHtG8A0rxqcRSpYiia9ZXCbwNuKH4OUp78Gb6NyhyIUKK8g7s+QH0OH2VIjoqFD0aiCk0iXGqpo327kEXfaQUwQa4I/Nyh1iDIvumDsYhtPIPgYPBCOPyCoAAAAAASUVORK5CYII=",
        );
    svg
}

fn get_wendigo_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAABVQTFRFAAAAAAAAAP8A/4gAjAC/AAD/////XlWhuwAAAAd0Uk5TAP///////6V/pvsAAADISURBVDiNjVIBDsQgCMOk/3/z7QRKu7lkLjOipZZKrGvg+h6jNqMChaHjAvwX2Js2ITGxHJHhnOcVQNM3aENEQ5/VWCJ6AJ0iixtg0rRoAixNguCW+MHYRRrDFw1ZkALG6jUlG8A04MAwAODM0FaDKm4MXssOYhFrIqHP3Yh6LnlKqNVyuzz6MFRe1ia90xqeDDUJwBj6Y1eTFBKTgT26S8j+7GuCCbU5FUDa3vxz54OcB6sTgLLvlYEFleN4BwDzqwZJ8Ibeqx90awciQiXInQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_weretiger_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAAD/rmEGTQAAAAN0Uk5TAP//RFDWIQAAAL5JREFUOI2Vk4sShSAIRHH//6PvJIJny6a5PUzxCCtYjI8r/gAkXe9szsB89vcZohbSAQDNm51DiNTwFiKnunEg1TdQngrQCutNItGqOrbMVMBBJICa0hbUesJwC5HdSFCDFVCbLkC9CJ9tjHJQ6RF7UnkQZVjKwrPAAHnHQPGEUKMB1hl1LXNs46rX8cgdakFg6eF5MGCe43I+uk8P2LalKgExb71b93BXxsHyIDFf3Cp3AWDjVU37Wzj8/Lt/R3wFDuZL55YAAAAASUVORK5CYII=",
        );
    svg
}

fn get_werewolf_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAAD/rmEGTQAAAAN0Uk5TAP//RFDWIQAAAMJJREFUOI2FkgsOwzAIQ8H3P/SU8DPQaKnULeHVGIjonyX3DfgWZ+XfAmKH+zQ0AD+APgCWeAHa0e7hiCOoRLOKqsE8gBnRddQ2lgJWRSFDoX9YZu6hcJAqdbiq8FU+g+VWU5G2B6hRcxA6gPAOkkBPYRYQHuGfCEez5+7lHEocejyGmMWKZmmmyRLmAf0ONLeVgsIlz1VwXEsFc1gxDOrZBqIfCyCCExJQYwD9fgA1saeCEiEjyjdvK9DVzXu1Usz1A6mbBSUhSCFIAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_wolf_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8A/////zPWCAAAAAR0Uk5TAP///7MtQIgAAACxSURBVDiNhZNBEsQgCAS1+v9/TsXACIi7OSSRaURGHfPPM7ogFQCyxgoKeH83sUYoNoTuOSglyvzMNIwAIgKZ1tDoRxe7RAQ6D/z7EyADVL2dAYKZDfDpVKB4c++CaEQDpPRzDceefa+RA6HVUoKcyOFD3HK1egOibgDRiXxsRsiS3jnpujqIwE5gd1uBlYQRZKstZJrSdXHwy6I65hN27HF/sQs1lYHP4BZ4nX43L88DwwwFYW4O0c4AAAAASUVORK5CYII=",
        );
    svg
}

fn get_wraith_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAlQTFRFAAAAAAAAAP8AEEcUsgAAAAN0Uk5TAP//RFDWIQAAAMtJREFUOI2FUgkOwzAIA///0dNK8BGtWiK1aSHGNlT/WcUT+j7CEvDdOIeJAIGAfQDz2t8q0QMyEMqqiAqJiNVXhioCU2IvLraTxSBgqzPluW8qFvCwW6q3TPgmnfLwgskmOSkroWwvIXbyG5FA9rLFjYJuqV30YXXBNLBvxc6sGpIc18ohvaPrdx15Nk8PCPtR3Vf4wKxtMTDRbuQ8QJ3uAC2/Y8NGZdss0QorwkkfNLGpjm/CZ4lQiRTOgXlbRY0vSS7zZ079+BfrA1ViBPF/yQ1oAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_wyvern_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAAxQTFRFAAAAAAAAAP8AAAD/0o8flwAAAAR0Uk5TAP///7MtQIgAAAC8SURBVDiNnZILDsMgDEMT+f533gSx49DPpLVSK/DDJIbIH088KoADqKHJNRVz2HLWVFD/fn11rhcb4GqYWRELWP/Fb19utokw/VILAdKlGgSwiyrMHnpE69rCCG4BJNpKLXoXULhqsqNWcZ45PWOzUEwj7ulgy+w4Vw0+raXDYepW7c2FUb14AOgHazO9CBztRt4Rdl4CjlPWsIHz2h7AtMAd0NPwQLtNBTp0z4EXZuhnUJjndQVeuvgb+AA3cQYBxBXi6QAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_yeti_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAPFJREFUSIm9VcsOwzAIC9H+/5ezUyZabGq31VDVAwGbEB4xFFlFE5KfZljRHQ6HILiGy5TCOGHJ+XEIxg6cZewFgkh/WT6qoRm4TzDQIztORayQOQw5uZcQBIZ0d9MN8YpiteesxbLX8WhSOyh+pSYCMTNmHziNJsoxUE4QwLpDJDebB6OTW+aABhmdhKKlaJFZze6X9LdmkdMo7RvoQItWcCHoqzD2J8dUCBaHuFxq6MYoRbBsKqLWcVoVNTl5geDyVZ4SPJO/EZgz0if40cQuZ7bilZ2RGkKeRdm/4es6uZ8NcJpW9GJGdrI1iCDBBv4CP4E1QtjzoX8AAAAASUVORK5CYII=",
        );
    svg
}

fn get_anansi_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAMAAACP+FljAAAAY1BMVEUAAABzc/9/c/qJ/3OLc/SXc++f/3Ojc+mvc+S1/3O7c97Gc9LK/3PQc8Lac7Hg/3Pjc6Htc5H2/3P3c4D/dXP/gXP/jXP/mHP/pHP/sHP/vHP/xnP/0HP/2nP/5XP/73P/+XOFEODKAAAAvUlEQVQ4T5WMgQ6CMAxE6wCHigooiIji/3+la9fNSDsS312vl3QZwH9kWbZ63/Ik2cVIUFWASnOOodPyahP3t1NoKvMMMzf9wYvkm8aT5bvChJ5ilzxYviuMMDqHrnBn+ZAMAxkbpeTGCkvQo3sIKejQXVgKV1JoChcnzLAETdO4iNKo0Rh1rVxP7FPskiOaIsHB6WvBnsTm+KFEl2EJrB9LYa0vC4qiABIiv4A8j5NTWWCMASfjGplmnQ3lBy0tClPpWieWAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_balrog_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAABC0lEQVQ4T42Mi1KDUBBDV0AUn9gib8r//2U3yd6L7TiO6d7kJDia/U9lWf411HXNR4qIgWqaBs7k+cuz6y2dP4IQALJP/+ECWFQFJ+cTJKTAmhz33Sxf0rHtdjGcGxyWgR8utm22obgJN2TagCvP3yrCrTExbOH5WxYkQwPDNc82u8PAgbPYJto0BaSBk4Zx1P8ZeXekHIbBjRDHyjmp742//galbwjJ55iL9i7+riN1GlQA6TN1Pt/mL/rKdqhtI1rQ4Wl2+4BY5RHH7HqnPFmOnvSaghCRZ9eLHwRAU1GjnlMQIvLsevKDAGgqatRjxH0qzKoKr0KkgUVDURQw4o/Txo/Sg8udmBp1BbnXFiTsZUE8AAAAAElFTkSuQmCC",
        );
    svg
}

fn get_basilisk_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA6UlEQVQ4T22Ki5bBQBBE2xIr2CQrxCOI//9K/Ziu6RH3SPWtGkTOj4A2Z2W5sjvnVz7EF7ZbTdiMP+bTQGdf14noNXF6z960F+IfXtGlvOyAyc80maYh83xqSFoPb8bj4ZFryd2SSbd4ZcZ0RpFRKJ7pdoNpE8IzXa8wbZb5/XKBlTVxPsPKmhiGwS1k4HRyKSs4loIKDsU9oCpi/zZ8HEDUtjpZptYGqGlk0lBp+GebCtt+zy6fIk2X1ER3O/580paxVtf8+VRLy1jZMJiCFqwha1XLSAWpKm1pWPoOoSUTloXvEFoIaXkDk/QPWXqmWv8AAAAASUVORK5CYII=",
        );
    svg
}

fn get_colossus_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABBUlEQVQ4T3WKDVvCMBCDD0FgA0UdDJju4///Si9Jr0+7R99ec0las+Alu7/Z7aq0ymaHGjtEk3+0bfHdWk7NG8VR0lrzQeiigXQp0HUdo1RrWZb4sOSkimG2eZ7jBzyCl9LZJjfTBAWT7BTD64zjmH7kMFpRgZ8QmqQ13yT5+okMmGEYYCFrnlIA/1TOPB4cGEdV+X7nuNx9nChF3/d+6VLk1oNz4xDtGxZt9Ne04eCvNE7uM19+arPiM4Tmfy6cxHtCwaMLyvxBnM/UFMoHrZMfKJedpHS01sRYA6E2Lg3k6Hh3NCkXN2q92Z6nZg/wBF5xapTxZNuYgi0iK/UbPyXK7Db2Cz1MEo8D7vOCAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_dragon_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABCklEQVQ4T12KjWKCQAyDq4iCzvkHDJyo7/+Ua9O0nAt3yZccIiJrgdaRHqFNAmkTsGgHg1vuAqm9+96OpfvHL6Yj7IggBp9hZ0Shz+WmX+CNGPnW845XR9acX6900P+Qp90nnAsBm8x65tkClwLO8McDrmngbj3ffl0YWAxYFe4qf1Upsft212+a8tl5mix8nfQbl/fRedTkyvhhMK0XKMMwgBnOBfR9bwQHLambUgeGOy7QdUHXa5jXXJ0uFzcLM2QxiZxUFkYIrgtD3zi4ZU99qcyzo2SlDpkHllhMbdsm8oarmqYJtBYntN0ubBWHJlLXdflqi348IlVVvFRoXKqk0Gq1UjNgt+kPBBwSK2B0rm4AAAAASUVORK5CYII=",
        );
    svg
}

fn get_griffin_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABCklEQVQ4T52K22KCQAxEY8ULFosiUKjU//9MMzMJl4e+9CS7c9k1+wcf23jYRlaHdXle+eS8aT83qFIbH76Wv0iM6uTN7guMsXc86MdLAvd6IaFgmS+/M0xGWRky6Z4mOAY1zvMZAug4WPLj69DQGibWGXmN0BHMXcqgsPhhgOIamL99CXwqD8bpfUjfy4ao89N1mUCniKvjmLXt+gMyGpRtvD0270yPLClNvoVpmka+MTjnFh9S5W5YVbXa2upwc5v5Ot9XBw5jsKCqJCZVrrI2u8wSzo3CBeqUvmUpk5RsjfWJuyj9KSKbow/1iA3kFAvfopDhgYSKfV57jqsLyR+7nWHmGPe6+5s3NasSULosNaAAAAAASUVORK5CYII=",
        );
    svg
}

fn get_jiangshi_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABz/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OYI300AAAAxElEQVQ4T32KhxqCMAyEqyKKCweiOPD939Lkkq580L8Zd5c6Z1jYILJK0CT/4Opc1HVMhCYTTRJ4DgqkPTJtK7MVoVyJoMPwJ14/gARTZUzdOLoRg2DnJTvwRVGzgBGLxXxQfllLvFHShJeymBcKHROfMgM9NwwDJJcYxOCpL8FED3pcGHFDgb7HDF6kpAl3aV0TdF1nhOFG5dvewAVDZn4RzrNGOc0a5ThrhH3REruiJbZFS2yKllgXLVNV0zphGbCXEn8jFw78eV1YZwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_kraken_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA00lEQVQ4T5WK6QKCMAyD530j4oGKyvu/pUnbsa3yx69ZmhRC+JMZ8Lec5WDjbNR1jbBXwt5/iBzdzmiaxlye5Px73+OJtPLAW8kH2OL2vN/Rgpp44gUBbBoTT4nO1HUdnaXkiaHRNfk/wgMjFsdzx4hhdHnatoVRmNZ/Bbc8DCVxFfmYcRH95oEzJuWsGCfRWDHqUNd5owqqKlQxSo0t4yBjYYQdtRvSD1vTVsRcsobWsnWogpUpDlWwoMwsFMyhOVyMW06JKcRHl6AtMQGBQowFRr7g9A37Am5hkAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_leviathan_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA+ElEQVQ4T4WKjXaCUAyDO4e6saFMEYfiz/s/pU3T3gJn5+wrTZNcRJLVKvUvqqqa6PJVZBvQL5+l9lPXLhGcRpomLHATz20rLSSSWSo4Hql2vCFMz9IHaJ6KxweB4z7MoOcPd/vkrpSIEWblpoNjimgNj3cy6jemjRmjVK5XvxQfbS+aL8Ce/WiLwYPIoAMFw1Acx8Kv71I5ImffdJHOZntLfV+cLxRTOJ3C2AfRKa1I14XxVemyVQ6TS3+wKfxMjPt0M/b2ZUh2RemS70XwnC750oFynU8XuzS0Uc34mOjckQ12w0sx1uswFozyKPJOYDJZYdXbP7wA1aMTPk/+oA0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_manticore_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAWlBMVEUAAAB/c/mMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Oa6C5yAAAA8klEQVQ4T61K12LCQAwzKwmQposwQvj/36wlj8vR9g3Z1roTeSG2xoqnh0Cr27bu/sThkA4hU8FbcbCkGh9FuZELHg9yWrp5ngWjxpKFWLlj7jh4B0KwTDJhQfFumLiKG0CtP9y4IleATRqHpQvWxtdx8XQ++6GkR2LlpYzjKKOrgY6V3kkhJ3+pgAfiGzCtPojHLx1jc45F+HQ2zSbj+2KiKQwMwyADWT0L7/NHL30Ppg1KAY5xR12S1SbEfg9a5EpEOqeuozWOXtE0eQ0zLByTyC5vB1GmKjFuNiCeWWUoC+U1Zh3GFKJsecX5jf/6Z/wAIgcPy1fsZWoAAAAASUVORK5CYII=",
        );
    svg
}

fn get_minotaur_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABE0lEQVQ4T2VMCWKCQAwcpRQFKrWo0BaE/7/STI5l1Uky16JAYL9PlikPH4q8sTJsharKnwKV1zXq2kyCN6KUL1k/S1ZJQUj65ijoua42gt6m7/UvmPVcBCt3XakGN+sazbKYJLvEJtzvcip0UWYfzJhnUzfWZV8EpgnTFrb+P1Gmmfvzy/Oz+ZVJliRQsW7MxD3dOEYchoEcL0M0VPJNJnCLTYfrVV/I5lLgKC4XP10Wz/lHV42pdcmc1RhvirOCueuYSV0SJ5PTCRy8nNcSWrRtC6qdotVeB00Dzgb1VjY0R0JflI8qrGIOhvj9wddGXvEpABe+QfogvkRZksB9R4mCgEwB2KajFNgpIIqdlSbK8vIARksSFP1F6cMAAAAASUVORK5CYII=",
        );
    svg
}

fn get_phoenix_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAV1BMVEUAAACMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93PYfm3JAAAA7klEQVQ4T62K2RaCMAxEg+KGGygqCv//nWYmSVt49HhJZkkR+QPr5SFjT9tt9BSi83A4YIxwK/FwwlIsG3ERuepH415ZrMbTJNNEg0zMLJqYxxDdcRwj5rt8XOAfEs3krZ8Bf1PSgWmQYTDzu8fBL68k0Bc2isuTneFJyovy0I+m63iNp14/mvQOS3q4u8DvJHeTWxI1xVNx7Tpz6SynGkGkbVsVgaIImpXM5SL6EYb5a+KsLG8FRx3s8g4abAN1Y0zs97o2s1Sy4+5cuDM2mE1ktkwtdQ3FWOfU0Y0VZmWJOVNJpdClMNyq4ref+QJkNQ9tfIdS3AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_tarrasque_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABBUlEQVQ4T5WNiVLCUAxFr7JZWVygSkX4/8/kniRtoY4zevLezUleB6S/8ThdTFksppsbnuKSv7BeEyLpP9m5nLvMGCa8uYj+MN5zcekCJbQ7zoXO4iht4Dug5XVZbj7QqejFG85p/OKL4gytFuMn0HVdRheBk+Y4FifukTUzfBbiMOVKDPnjH0DiMfar+vekbdVGt7WM/aI46OCTZh3HZL/X3kkweebWaN4Dd5HZbeHwCk4sWu2UqhfIXldRsTRbSE3fKmpYbyDfQzd9r/Uz5DuCR/b7phEFDeANGimtVlr5LW84x2LCly7RwvC41mXsNHeRafPSOYKZmWuQ0hhnN0PyEPVPrqlgGew8GT8VAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_typhon_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAMAAACP+FljAAAAZlBMVEUAAABzc/9z/3N/c/qJ/3OLc/SXc++f/3Ojc+mvc+S1/3O7c97Gc9LK/3PQc8Lac7Hg/3Pjc6Htc5H2/3P3c4D/dXP/gXP/jXP/mHP/pHP/sHP/vHP/xnP/0HP/2nP/5XP/73P/+XNcoW5xAAABA0lEQVQ4T3WLiVqDQAyERy3W6gqUqwV7+f4vac7d8En/JDPJLACB15VtsNsV3WS/t37Kp/D8/XtlhbZtbaFSiXHfs+iKYL29/XJzMeRh1bcHqFkIdjl5txh3KhG2u3UOqG5SJgZKdsM1F3EVZCvxhfsilikRffsDExnCM8+XhZtcksUsPMzz7OL/zTEFzmfL3fNiLycHJz5oQiRMk/0xUams83Ec1eHBKiaGYeAZEFU2p+s6VnTI5pFxNDkS5YJcmaZBI64mScNrXctVM1tLSomvxJ4CluCLgRhsVDQHDjgYsAlmfAjiefhC5p0wz/OPqqImiUsV3t8UWfIlu/KiyOK36h8+nx1lGP9+DQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_warlock_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA5ElEQVQ4T32Ni3qCMAyFz8Yuuk1lChQG6N7/KZdbS2vqfpKTc5J+CvzDs1+9EH678a7EhOgSH0q+Ke4HkUOeStoWLUvK2LxwSfKA3yQWNx+5WVe5XstZsK5Ua/Rr3NpclgVSiyU1cYEZ8yzNI01z9hs/BRx5KR8xTRO3yqSOPphiJFjUjRYx8sn+AAEh8AhaQS1yBtVBSpz4Id77Hnf0tHJLdOgE8Z07A+czFYsEf/8moPWA00mLpMoRx0T1wVdG9QE+E/X7HnuDbI3dTkvb86ak6XllVGl6GjRN3u7BE8HDrATgD8U4FYbMv2GjAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_ammit_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA50lEQVQ4T5WJ4UKDQAyDqzg2EN3GxmBT8P3f0kvaXvHYH79rmqQn8i+qqipPTg3VNVb5ZTRNI3gplF+k4+rgHXPJ8Whu2tBL3/caVE/54djasMiyYDM+YZ5nmpY/X+Q7TYLB1oav2BoLHg+1vEru9zBKezBNtqeJEWH9P45pRm40Fcy5+btps1MwDMI3WFVZA1e5klXny1zKeIHF9ZyTlzMszifMKUpxEfn0xZBP0T5WozWLvIdgvmikxbQRmVs9gIPqAFkNS+xXC7Zn1gvZUTtbGlTGG4Vn0c15NeXIYpfEC8cinhv4BU+pDK9vZSaGAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_behemoth_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAMAAACP+FljAAAAVFBMVEUAAACLc/SXc++jc+mvc+S7c97Gc9LK/3PQc8Lac7Hg/3Pjc6Htc5H2/3P3c4D/dXP/gXP/jXP/mHP/pHP/sHP/vHP/xnP/0HP/2nP/5XP/73P/+XMExvBJAAAA1ElEQVQ4T82K2RaCQAxD6wruwyao//+ftmkGCvrkk3faNMkZkf+iKIplFTkeIaZfuYxmdHNe3OkseOo8J//J4xFD8GSQYRhC+qCXvu9jXHKXuxLznE66Tjc2MYi00ra69OyyUZrGRhoPUw2tsXVdw+UmmKry0WVfYdwYKSWsJH5IdLw3ewossMYvuF51VMx6QeNJ5AzcZoXxpJwUuqwwLCOHLL6IkbLkwS3FY2A/KteLkR1155YnsKXa5XqV2dhuxJ6P34l1Pmt4DDuyArKih84+/MYbwf4JdQi4BMEAAAAASUVORK5CYII=",
        );
    svg
}

fn get_chimera_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABDElEQVQ4T52N61LCUBCDY6lUQSpX29LS939MNskekf5wHL90NsnuGQD+SlVVy9UTr9IvvJEwxuVNbLcc/BgWtG3L4Qz7Tw4Wh+dh8WCeMXMwicX9ditDnimMIlOoMLGwTt5PzONYzmNkwsRPK+AaEgzXIFeMugxD+QWGIao0qOvWh2jyvudw8QboOnQx7Z1juNAvf1kk/NHzj4HLBSESnk2dN704n+MTUOLklkUPTs8gxXTSg6PBUYkm6aSJvcE+E4OL7/g0ERhlSDM7g51jTEqdfCQuUTmkZGOwYVZT+ObdgAIni0I+aJoSwBSz0co1WOc90pp5nU6T13WdD2pSggy0FfGLlfTw5EX6N3fMTRl8ZKuIKQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_chupacabra_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA8UlEQVQ4T5WIC3LCQAxD3VJSCAlJw68kpfc/JpZs7xpmOlMkrfVWIi/onflba4aP33VQaBPhZyNw0k5dY2dHcu0RGPFB9s7QF2JGfCyk+kXq4WRF3ZAbgQiyAfrBw1GiKdupZam90IyvqlnmeUYhfHqtXFf4ik7Tg77TzYvrcsk/LkzRGe+Mm4f6PfGdDHhtcR0hx7gcYpWD2iHKJxumaUqlYMhnywiPYo81ArmHBq9hcDbwuVfj1kjfE4AiXdfhltf58RtqpW2typJYZKtmWxEKqz7VbCsbgkWaRpogAww+qT7oR8pa0c+Y9KYOyr//6g6ZWA9IqEduPgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_gorgon_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABz/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OYI300AAAA10lEQVQ4T32KCwKCMAxDq6Io4hfBH+j9b2mTDhll+pqmaTcRMKP7GLFYTJNjpWD4e2ATXOcGmRZRsqQsIW1uEQf2ATA7zmc6pYuuPAy8g/dl5nlRllCerjN1jNL597aVNrgl/0Hk+YR9hW3MA60ICtF/uPfSvmMkuH1HSI7rJDiaRhtq/ItR10FS+ydyScaYqqr6NLrHnMw4khzRR440+722Vp8n7BTZWcTmnkW2NHMsTDFFAUnBDDHFrNcwrUFjcus8z4XCPmapNShFlkmmjvmLOfHXf3wAyUAMWk/7dc8AAAAASUVORK5CYII=",
        );
    svg
}

fn get_hydra_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAABGklEQVQ4T5WM2XKDUAxDFRKalGylgVCytP//l5VkXyAzfalsS8e+DMA/tF5z/nx5c9MKpE96Z0VIy1Pq4MLhICunQtRZmkB4Ns9/+HRnBln5/EPRTPOJlsu3ShJH6oQ8Uc8QnkQu5YSlHppHjoJgfPj5ftfc4ZoY4QvdbpygzBeN44hRPorVs77cNEMUUIIahiGdqR7UuVBXCjNdlbHC2bPU6Ps+R+3dia7roDJmi5Fw0VzCTZdYPShqW7QOQZsnb9RHKAhuLgzMOuFEFcqb4FS+OB7ZnoBii5/s926ZtomkpuE4XFrDm3jfUXZkl2UX71vNNpyLaJsRH9S2uobbQzOmNhsOyyg5sFTFruiyqkT18slqBZZUvLz8ArEgGg3LbPdYAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_juggernaut_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABz/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OYI300AAABBElEQVQ4T3WKiVLDQAxDDQ2khCbQHC30IP//l1iS98hM+xTLsjZmFS8P0pbdzj/Mpn13lQOkpOoDKuSLb/SDK4Oo8+Co+3IpOBHSrYexWjCfcZTpaa3c1jUFROY/F5cmwZrF3SW/Y1WNLrNbMoZc3XJxTXOFq2KK8+KyiwPXmQvyCwFEfIZY8+Ofw0hHU3PmFLczPXOisO3kCWzebaFs4Sxs6IUZE4Y9z7wKUwkeJ/cpV+DoUjjiUxMV+XbloJgrMeQ12KBjSCXo+147Plxy8UlFSI4ddJyOwXenFA9g77I9pqx4EC2npbU8uBjFG1U2okh/NE0jbwwhOli6wKvYnvUPT/kH6sQSj94TDLQAAAAASUVORK5CYII=",
        );
    svg
}

fn get_kitsune_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA+klEQVQ4T3WLi2KCUAxDyxTxxRwComxM//8rd5O298G2w22SpiqSeFv5mu0WQ1mfSNMIPkqzPoIj5+ihoG3bIPZFQ2l8hIfJn5rR6/Q9Fe6V8YoiL7PUkOczTFq5oMv45vtzW5ZFLTZx09MXX/JfzSeGotndO5n5r5k+zzq22vHxoApNsUUvgftdzaOtaso0TVBbYlFwu5VTMo4jFIFmhTEMg3osilquZvCrrsx+6hi7DqEj6KB2vGAocFB28h7Aj6m2eKNOzucwsBjiCZxO/4hyOFCFlkXtRfZRNWWRuqNAd/go3jDVNlLXeG7psAlgB0j5lrJSVZVJ4gdBZRIvhUexBAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_lich_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAV1BMVEUAAAB/c/mK/3OMc/Sg/3Olc+i3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93NHMZYcAAAAxElEQVQ4T52KiwKCMAhFqay0LK2mzsf/f2eAuLGt7HGAey9sAN+wXX/OMmq3uOg5YC2RSH8UQSr8mlKW2GVyrhavKrUpJrGJG2WKPows40gjOl/kfcBCJRsG5zxC3/OQcgGHvncfrAUqag7WLip0XYeCJatc3AGg5VahZWvdh0bNbA34FTFuUI2RkwHPA4taJAjEnVttemVuWLODpNfUYnX8cFX6DZfkcg6i2mJOSUjIqfM3j8fAfmMf+Z/sAltl8+mD5gniRAu7syOJ8gAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_nephilim_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA30lEQVQ4T42KgRaCMAhFSSvLsmamU7P6/78MxlxAek4XeO+xAfAveZ6zicWyp94HXeQIxwjGRc5YX1vkeuVZ5XbjWeX95lnh9dJueRLJfpmmiSbawsGD+oFw+mGEcWQHSqP9H2AYQM5gDnroQ6fQ638P3ntWnxZJB13XsQE5m6CFtg06S1DBPTSFu95nGmgaVCH4JKmhrnEw1GIROHCOzEEKTh1csC9R0Vgl1axVJRbBCUt1lETJWpZR8KFUBwcs0wd1AEVBU3AseNfsdthhgtnvwHar3ZJlmQmaDWIT8gGsdBCG5FFiIQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_nue_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABC0lEQVQ4T42M13bCQAxElQTjAiZ0glP+/zOZot3l5Ikr7Wg0MkS8wLv5H1c6VXRdDcjzF8MwSIa6toVsKt5iw4jG7Ng7qkSdYfuTOEioBxabxvyBnB4lznvhF6SR91L5IWm8eE2+SXWRtp6XZcFLi6ckg8L9XoYdZjt+gWqLlgTc1LY32xu1hBHXa44rLRZ1puDivlyCBeNFxpzP6iw25Qx8P7FLpZzqDo7HI0TF1vMuB/ZZbK14+6bgs6i6bXZgLsZ+jnlmNHuALd+WCsuqWf4qppRpkmaCZdIlxnG0jkEjkQkdopeXUnqqt15jrfsa2Dy3olXKSk7GLmfEBwkXRatz3cVbFhxo+Qs8AL6kFPIBzUyvAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_qilin_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABB0lEQVQ4T41Li3KCMBC8ilDQ1lYQRar+/2d6u3sJ0akzbu72lcTsbaz8SG2FjVig1kKsrqWPaFtfTIvwfEtsHbaFgl9g5yDtlm4P2L6MoSput0QJLJKx6xXjamAorBKbix+7YPVdBQ31zw8EUFaR3awEyM6zzExrdl4eAIjngs2m6eGB5ygmjuNEAnRxQoqaOB59NYQa5IRxHEGGAxqjXV7Y4UAOw+CslhhsGEB+4CBSGKDngjP1PSce2G8yOavJ/U8p4HCUbywIIqiM9gvgdQgcJxWbTYhUDYOKrvPpgtMTxOTtMxsih1Rb04QaTJNjqGO9zpaJMUSoqmoJGUX74SivAv+3z7gDA9MRNMgn7gYAAAAASUVORK5CYII=",
        );
    svg
}

fn get_skinwalker_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABAUlEQVQ4T2WKC3LCQAxDTSlNgDYtEEiaQJr7n7KW/NlleNbKkmdFat7A00XkXafKVOmgkaZp7NAYWbgPOnIwBCrN+aJKeck/eIDJLijR5BIhU7mAdV25TACJN+NPh1tD4CdjWZZMKAtDzeOR22Js567zlO7lQmaZ5yrN3PWHSabJA2SX+sMvlRme3RhlHDPCxuzGgBkGy4BefbjpYN2gOHg0rtfc1fiR9H0Ejb05QnLW8XSmfCcn1anK2rTHRflOU9chuvJDR6Mjd5o7WH6QT3tYTDpUcvQH9znCk72/aHtT+dCGtS2FoYKPNK86VLCrbEcDdiHbNK9bUF02aV43Bso/hzkUeEIRr9QAAAAASUVORK5CYII=",
        );
    svg
}

fn get_titan_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAMAAACP+FljAAAAZlBMVEUAAABzc/9z/3N/c/qJ/3OLc/SXc++f/3Ojc+mvc+S1/3O7c97Gc9LK/3PQc8Lac7Hg/3Pjc6Htc5H2/3P3c4D/dXP/gXP/jXP/mHP/pHP/sHP/vHP/xnP/0HP/2nP/5XP/73P/+XNcoW5xAAAA50lEQVQ4T22KCXbCQAxDTQul0CVACA1tk8D9L4nlZcbjx4+lseQQBV6E2LSs19Wfsd3yiOWLsae9kPvAl5LrwoGB577S99SrM/kI7vgq+Uy3m5q8FiPLsqjJLOnKzPOsps+c7zRNE8xWSYn/FFMm+oNgITf85piK69UsTmDkGcUQRmSR82PyIHspiC4XFolVqYFhGNh81FzgDInproUJnHhO/tpSBI4ysCPQ5KXQdeoOdZLKXfmGGN0ltT98hpVpG/AhViB8DbsGxHB8L3gRjm+FUFING4E2lkrti/Nqrm8pKitzfWvzACUgEugkOBuPAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_wendigo_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA9UlEQVQ4T3WKiWKCQAxEx4py0yKHWBX8/69sLvYA+pKdzGQDEF9UO6JlopKsKXFLJuWX8ogktS+i4FfwKCwWnC0ydV2jVgdneBnxQ21I2NN13cZs+exMyLIs/wRlnkW9zNsLvN/HPuAVmxcTXzyD8TTii18vRvyPxyoPx+ZiksY0abIZcr8fh3EcWS1sF8wwDBhksErkrT9AL42+935V4cZ9MzTBRGipuNGKuEW7HnxrGfBlNFTcJE2QG90BFarKDXoaoIYpqXSiLLEG55Ajz3GIrrMMmVtl3nJiueJK4BBZX6yECxEciD9bkTv7pzhjnE5eV/cH85AQx3kO64IAAAAASUVORK5CYII=",
        );
    svg
}

fn get_banshee_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABC0lEQVQ4T41Ki1KDQBALLSBqS6WFai3w/5/ZTXJXEMcZs7t53QH/x863k9mgQlUFV1LKLzSxTTCp2T6+J46RNS8vbY5oWyZObsVdjMQqdLSdBZjnOMpskcsPxjRhIlNIU24TRozjSBUj+xSB+50nVnSKrAh88zLcyHH9A7cbYtZgVucPX9wY7dMr6/2Tq+ES9sr8cI0x4SryPUtgyBs3DINDEqFHH2tD7u1TBC6a0IvO7Fo9zjESWSUVWT5ipJZVlYqT92SrC5KscEwkpT1mJxwO4ry+KDnE24qtPg7xmkbWl9j2RUc2JahaijoGdZ2dkskoy9iShipTMnCJfSB9lS7RKIriR1azrf7EA64CFomTQfzlAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_cyclops_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAAzUlEQVQ4T5WKWQKCQAxD64Ybioo76P2P6TTplIrw4aNNkwwifzB1+i9kMWid1Wo8KVsqCIWz11VBgMmJHDHj+W3H+CrBK6uPl6Q1aaVteXMJmqZR5WfH68QTQwfvydwDQwtyyP0d80vX3zB9QntNc83OBA2dyEXnQmOZhWU5Y9TgULs2Udc1DpxqKI2Ty28CB9vhmKi4FfAY2VHsZAmUtlKWIUQ2uobFHuvRYCyXw94pigKnsz3mHDvhYQbSgddIwweRCX+buMuJMZQjfABO6A2D7N+eYwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_draugr_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAhCAMAAACP+FljAAAAY1BMVEUAAABzc/9/c/qJ/3OLc/SXc++f/3Ojc+mvc+S1/3O7c97Gc9LK/3PQc8Lac7Hg/3Pjc6Htc5H2/3P3c4D/dXP/gXP/jXP/mHP/pHP/sHP/vHP/xnP/0HP/2nP/5XP/73P/+XOFEODKAAAA6ElEQVQ4T42Ki5aCMAxEg4IgrLA+d1cU+f+v3MykYBvxHO90JpO2Ip+yftMnNozNVNJHsN3Cmlb8s/IV4x9J13UaYS5zMPz1k3Ec6bc8opRHmAlDsMYwsDjuwZp3mzE36MbkfKHvpcfQgoaecL2Kas4X/gAyNM8v4bDuP8iPwrDhn+WikkvAtpQzBJDcHCcIaGX3H44Q0Axrwl4le0Vj3mO+TYh5T2hbPS1ma7vYnNntcFCeFwlNIw2DtouEuqZroI17QhUsVVWxcYko4RIuBeKFp6CLomBbIIfzXKBlVtAKuUyWSTaViH+dIxLmPwcWPQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_ettin_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA70lEQVQ4T22JgUKDQAxDq6LTbU4UHLIN5v9/pU167VXgXdKkPZHKI4eSbqRJqW4aPxR2+pg7JoYdnD3l3uOhV96L/Nkp0UrbqktnscXppOs6BDtW68EvpcZjteHc715CfjHmefaGhfGPaZKpZL1EQ73dVDoSvtj5qq/OasQV5aK6YEWhrGPyY0QdR3g0+5GbyA+7BwoqHTcwpDIMXOMkcj6rvdvAy3zrwzTrtEOi7/uSvqdP8BXEnn4/+bxb+A4+9EFemStO8MnMZclRdfSy/AQH6MC5zVvSFq/mEhu8UOE1z1TNFU8Ui+WCBxCt3v8AiZYQTX4fMY0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_giant_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA3UlEQVQ4T42Li1YCQQxDg4LuKvJQVB7K/3+mTZvOdFfO0VuapJkF+Ad3WhppSe8rYsoYRaY4B32HYRigYVSDZ9SlKhueNvmjbJJo6MDe/2S+5/IyiaC3a1Cypyb45lLcicpU8tUD51eNS0uTs9fnoiW0AqcmYRFVGMfUo0H1Jlrns6gao5wfRSdV8l5UnkdwkB0UeiXe0guTD/AaGlaaxm7nOpkZW4I22/k7XnzrzFj7atZxV55CDZNedMa0cYyoovHYLaKK5IGYec6qvC+r6SgBuK+mowRgIW5df/EDA+MOWqP7gHgAAAAASUVORK5CYII=",
        );
    svg
}

fn get_harpy_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA5UlEQVQ4T5WKAVfCQAyDi4BuMBUFBAX8/z+TJmnvbmPv+fzSa9JsZv/hyQdv2os1tDY8aIYO03XyObZU2hxvENf0S/IxspZfB+bSyia44d3ojbEmV58rBunhdC528aErKdPJjwvDF8YmbvsOIcWqFThL5zjRRBXnKdQwrr4orRKiJEfpmNmQJXFIOTgPpYgf9i5MY4oI4BPDRY+sQuwo2+FB6fnd3iWsmngFr1VOcxYGlw0DphiqwsaFteGRV/NDr+kV+jibH+zFRauLVnjWpmlHVVk5vjXMY5YQVvpy8sOCmjv+4g5SehKLs1UfvQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_jotunn_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA90lEQVQ4T22LgVrCQAyDT0RRNhCcOmEM9v5PaZO0d7f7/GmTNDdS+oeNzaYta7Zb27ZMuzrv1jfY7ylUnbDC4QDRwqBy53SyVSpB7gzD0KYhRSWWJS2mkGiqDB6VKj6qw7jfqauiXPNsM7vnqnC7YYkO00QT0ySdItgmRnG9hnsywy+4XCCrZIGF+HWhw6JwxlFrikEavRA/HC0kisI3h+tnwxeH62f9BD453GJ1PmvPcD+diB9amAlNfY5H7hGmw2vEnrH36UH+ALHrOmZaR5Iavb2D/I/I3uB8I/FBBDlfXoV6N096eAniKSevnzPWNYHHU6HOmT8CuxEygH4gTQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_oni_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA5klEQVQ4T3WKjULCQAyDO2EiboL4B8IQ3v8pbdLe9Vbn1zZNcycCHqiJJlyvwweRbrQWiPhZa4GIX9iZNn1lz5ll7z4NKbr7/B/cMBC7eMar8kOhlu1H4cq5Ej+CaZpkEnRN0Iidi1yUeBe7Izmjz4qfcMwK32wzjTVDTo1pfeVIoYarJ/jSBvRm6Cuf2nlmH+SDnVbLG0YpymDGoWg1if2fTuxQOzra/C4yjqI1+sqvYBhk4IZbYIveKuZanrSwqOE8FnkEquo8QOax0jNU7XvzPVzEKy3VFRU7BfjWdZ1YwUOs6H8BLvwPLS8WjpMAAAAASUVORK5CYII=",
        );
    svg
}

fn get_pegasus_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA8klEQVQ4T22KgWKCQAxDO2RDZSg6dCoD/f+vXNP2ypXzpaRJDyKnqqqlvKPmqetUQHimhpoGy43EnD2L9vhkkIG/d9R1tlXSSJ3ps9D3XvsUfsSSQ8tBePG84BohDJP+eD5hkkR+F59nbbJmFWa2h4ln0g2fLNgT0R+LXZd1loA+QuOIIEjXoDxUj7La6X4n1YJ0xg83uvFkf8TG/LIw4RS4XmHxFJpyuYSWl8Qw0OA5f1g4n8sUOXk4eYwc02JZjhzEDghQybd9bFBJax+1re6CHSttTSu2MhK2GlZ8yUjQveJTRmMKOZsNJpX8xfhg8v4PH7gQS6CFYBgAAAAASUVORK5CYII=",
        );
    svg
}

fn get_rakshasa_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA70lEQVQ4T2WN62KCUAyDi84N3U2nA6eAvv9TrklPey58hyZp+gORis2m9jUvla15w1DaixxcDopFuvOZLECVSnIsw5GSO+VcRjx1s8Qzx3J1F3lE4pbWR/RL3JAXX5dIs1+RsMzwOfrJz9MUWWPu76Xf+cpa5NbYjZJW8BdqacXV5erGJjOOOnDoqBuKgkGGYaDbrPhVoMwmtIrLxUOaip9VLhvlVK9yUpoq803U20PLV1skPkIttbwXGmGvUFX8whKbTi99z1EFljhYRF6BpIdkO1Ur2e2Ez7768ZOtYrqF5mS1/rTjr7uuk/zYUP4Bjc8N01PUGtkAAAAASUVORK5CYII=",
        );
    svg
}

fn get_roc_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAABz/3OK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93PP5IUTAAAA0klEQVQ4T52K2wKCQAhEMSsrtexiN6v//8xggBbXeuk4wMysRD8pWEVeBmY2kQX0LSgrKIWQlLqukw+9s8XItpCxD7IVLnhh6fbKDdHzqUdkHol5YDHWapEYBt0DwUy537HdTLhBasxFbnTlLaPHXKzoYhPWyNAZi0kpGDm9d0IK4npeJ+hD9MYRijHnAIU0pmN1WZE8h13IChqv+bat2uzgWmgaHZILadSGaKOzSR+j73hYk40ZSD5PVFWV/69UJIXPlCXEy82Uebpuf1CWefMHbxpFCkA3babPAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_vampire_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA7klEQVQ4T5WKCXaDMAxEJ20INHRvCkmB9P63rGckGQNdXr9s+Wtk4D/cOuvcORy2VnL342Dc/zoCT38Fr6u5DD5zKynT6xXXcucpc2PCNLEXcJ5yNPKkGmM9atRCDBiGQbLoKfYP+EgVVmgYcEmFCztflr/BOVXqZ5qORoVGj74P45H1YaTr0JnoSDoT511HN0Q+c7J28uZBwVvcLMs98KKz9ZlnXuHDhkdVPN/wYNefNW3bos2DxsyR4Ehjz6oYaBo1djQ2mvuCXte8NU2jImUcUVX+JJC8co3dnrK3HuZZ1hsHLG+ekN0MdgoW0Rfxrw5bLuWckgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_weretiger_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAWlBMVEUAAAB/c/mMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Oa6C5yAAAA3klEQVQ4T62LVxLCQAxDFxJCCYQeQrv/NbFkexszfPG0lmUFQvgjbdtiaPU3suRL+5vNptwVOyoPNQeMYPGb97uwkpcQXgwwvRPPZ4Aqk9Z4mJDMUgXuIi4ZwaLXwjTRJu4s+n1Tw7Lop1oYRxmsUf9gkRWua5q0sjJcLjL4JYLGmBjOGJrGGOwKJxNSell9pMiRWz37sKcYDLusNoYwDDIeKrYUthlDpFf1PbIaPLJe80nAjjljtYrG0y+j6zouJG94JhbZFIXSNI0apA2E1pmrYH5rpcxmMiavyvM3H+e6EFADHpYoAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_werewolf_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA/ElEQVQ4T42KjXKCQBCDVwGLFaml/oAW3/8xu0n2jqPOdPpl2SR7mP2P7TaHbeTkQdM0NCoOOgWttcAdY2otY3A4yCxcFD/0S+qRe7A826c2LWU5eT5lBsdWT8zzLE89J/FNrU+r/igL+kNf5n43KAYLxhhM0DQhuHNjFYwuG0cmDAJr4kZF0OUWYcX1imXYKPLERcDtgs6dORM7I2F4W56/gLkwKoaa3gcbBmxmh5V3caIiK55EHD9ckRx0Hg1ZHF12JCi6sBR0FMZXp+nYgvcQIqEVP+wppj0Grp54oxCc0l/Z7XJIaU1d1y9poap8qshov9jYxsnZIv7JD4B9EStNv2QdAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_wyvern_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAV1BMVEUAAACK/3OYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93O04eAhAAAA4ElEQVQ4T72JSRaCQAxEo4igMog4gHD/c5qqpKHh4caFP92pISI/s9vFKUmSOLKIqyOYIzK7kE+K7kXkeFUUhakHxMIH1DrcNT9k6mFHHW6VEdgZ2GmAHTAA3oR1MG95K1yBcCC99EBcuHu/iHT4HQWho4f6TeSlgycvLG5UlshToZj3UtzIQx76oAjc1s/+rrgTN1a7aflm2pbRBdxu85XJimU90TS+GroNrlcXU6eKXIVQcUeUkStJdASXS+Q5K87KuluS59t+IpMsC1b94makfDCpmzUHfQTuG3vOn/kAenMQ7xDT3O0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_berserker_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAAwklEQVQ4T42JhxaCMAxFozgRFdko6v//pXnpoA3jeN9I2hD9SyJJbElCDtZjwSFnGOWX6JyxMxL5gc+RuwRyQxJQFAWJ3Cii89cU5Ib9dHwYlN3NW/MWuTFhGGC9Kl7RmOPpa4G+N1mko46tf0faduwZmoZj3OgbqKmuyaXWV6aiysOPCSVSlrbkGfMQT3dPzs4Jksr1nW4iTL/GXL3cUFyseHOLIk0pxYBTbHOcpKTnOAZZYM+C19jpj5AtC73KRr1//coNRg1y/a4AAAAASUVORK5CYII=",
        );
    svg
}

fn get_direwolf_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAABzc/9/c/mMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93P1NtDjAAAA30lEQVQ4T62L6WKDMAyDva3H2nEVaEeP7f0fs45k54Dyrx+xLClB5J1siWxXX3yDsF5c/kCUtAqapqH6asr7k5Ltk2fnH6xn+QvMYl48QPbDY9bcA5JzL6oboGFh1c0eXAN0cqUa9mAKuKVMU1bKb0AXgxcswUVRlcTFsHhWpOCMLrajQuMPRpaeB0UGuDQDWqPv+6A+SL5A13XRSaLDAW3bBoUTeA9GXddYtAi1SFSlwuFUFSvrjKN+WDFnwTjglK5gv9eRNAt2lJ3bJRvIJtoFXzjmVvjMZsmHfljc5AkhvxVOmEEEgQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_ent_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABD0lEQVQ4T11LC2KCUAwLiqLipg5FNnVy/1OuSfs+LGmTNA+wMsAGYABnRZWpQtu21DQuWj2gc3YdD2VaFzWPAw6Ee9qoDvrro5Awz6fegbOodHb3KjIGDMOQcziRr3l2lSWf0214Z6mL0vwa3dO9qIWX5AVRh1eBp0bpGaHqiIfRwyNCqRw/YcSycnwbTSnJvCqYJhgdOqbFM+53GE0ZmbwpGDGOWkJuUp5vuHFqsKlwvSKYkk/+4Os/QwIXXDgXqg6PzIHTCUEhH+kdn1oxLKqE45HiDEut0Pfo88cZPXvH3hi6N1QFDdjtdu6a4oge2PpuJTmwpACbSjaGRWFYrylaIy+GqEyaxkLZpj74+gfI8RcitkOAfgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_fenrir_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAUVBMVEUAAAB/c/mMc/SYc+6lc+ixc+O+c93Ic87Sc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93MzdOcoAAAA1ElEQVQ4T9WJ65aCQAyDw2UVFXUVRJb3f1CnSYuzoOf417STfskAX6F95i91PIa91TRNmOiv9UeRll/UONpidF7rnvYOG08rDRgGcw8r3dKYi3ET/VPfow9kjOTqVoCuezKutleCebQZJ10Wl3yJ9Lu4T47m7K7rHYOaU5rkZopesmVo9WOnRavkQT84cLgHElm9tMNOKzY3c6eapuEzgp3MqO1Wz9DJo7TRbpwNTfP/TxqeMG9ddZ1BPae5rypUAemJmXVKlKWgdFj0oaJAkUfOB3oAqpwJMoJwqbkAAAAASUVORK5CYII=",
        );
    svg
}

fn get_ghoul_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABz/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OYI300AAAA90lEQVQ4T32KiWKCQAxEU8CjniDFWgr1///STCa7AdS+ZOcIiLzgw/YNZSklZcE629qYXWd86lDecTgIJjhPMrvO8uhcLvpsmZfcAYNgnvjDKKkwGCN1ZPI3ok8ZBhmgSdBm/Opw6S5BryN93yNCXIMfHWhKyYIb9YZlp2e+Fx7Bubpdc4hvRte5dEw8iHwpdMGw24XathCG1lpLeJWmsX8bG4YGmkzqWh82e43/agVd5HTS1SdY7+be5XjUZ+vgYO63/V6frYODud92O322XlNKp+2Wlpun/GWzoSVliJOsZGXLPMFvRsVXVdg4TopTFIUUkaP8wwMaXRClleZU7QAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_goblin_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA1klEQVQ4T5WJhxLCMAxDA6Wssjdl/P9nIst2iAPHHU+2JSUp/cfQ9pPWbtu2OUemU6xnrZEudZ1cLqKkwErmLZuS7bYu5QN5cvVqEi95ZOVScQ9XVHOzZb55cvq+t7Uev69XrCXJ3pxLvkw5OGfMma7X5s0Jkkknup/MEZKrYy5PxoGDo9cjA9lDdKJFgrMDGopbhA0k47sRzwbWlIe1FXZjCZm5tFcsFhisBPbqP83THAMH2iOzID58Y/I1GuNxacmsYDQKltQzTdPE5NUYiAYSmOLnD163Sw3BkTcN1AAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_golem_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAWlBMVEUAAAB/c/mMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Oa6C5yAAAA7ElEQVQ4T61M2XaCUBCbSmsrKpZFLIr//5tOMgtg1Sdj1rkcRd6NT+D+GPgmYYz/KMsyyvIhsVfunY/wO5WsC1yzXMElxlHGWZfZBC4XisGNieU4m59BBp0ihvBhAFVZ7IM/d8tpR5MT7cTIPb/0PdRLHzvD2lF5pNsDu99ZulDntUPQWaSFWoSaF0u8KBpl0yBihuJU1zU8lp2YdjuE0nhV8CxSpapKE4LFWWSnhECWHZxpfybbrdiPA2S1ndgoNzB0gnXCD03h3esMa9payZbp+FLQY2hjdxRmBdNmUcRSrO5K7LzLh+PZfoEbY10P39byP/0AAAAASUVORK5CYII=",
        );
    svg
}

fn get_hippogriff_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA/0lEQVQ4T51KWVbDQAxzKFCWQNrsIaX3PyaWZCcTvnjIsixpxuwfeCA3PBV+r8r2RSgbzKEB3omwOvn0CWyeqt3aK5bIAF7RxY/7vTBi5DT2TcAk5QvcsDdcSjQl1nV1MQrIPeAL1IDcI5bFFhMXxN/vjtnmGZKJmKYJ62puICBfqOM42hgOBlSmNxsGGyIzJuUdfW998cGLqESzrrPu8IGRpfq2tVYPcdTtzeXiyygtwaZprFFsHLxKaT5Il1C/cFlbLdY1ExvYWod4I7mR2fhE9eojyazdztlHEkh/dvh59tkPIQfFPvrshzZddCef/bhxd5KXVpVV+0nh+Qt+AOo1D4jhBpY7AAAAAElFTkSuQmCC",
        );
    svg
}

fn get_jaguar_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAABBUlEQVQ4T5VK4XqCQAyrg+GUKQKbCO58/8dckvYO5w++b0maJr0z+wfeXg8veAc38QFuobW2Lblds3C2s+SFQZbR99bTolmkfLCHVNqDBcagnJKl8pw8Jsnyy487gQzT+A12B7VoLPdcYpaFbfGwCo1DzDOGmlUjsfjpBt3kRaqC9hRDJ+M2TTS16zVMEzWL+AbdfBXqQnyBUgSnToFxlGdTHf3oGKCBe+DCkE+4ULQIl9IcXfe0O4p0I04a8MQUVU3d7JMCAe9qfhSOR4wHX1Hhvg+SgjYXA/ygw15i8JUPe5FoQA+NQhO7PNS11f6jBkwlDoHKqqqKAOa1Yrczcu1/6zZ+ASpDEzcLQWHBAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_kappa_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA30lEQVQ4T42LiRKCQAxDq8ih4IF4X///mTZtt9RFZ3wlaZodiP5kbjaHvIiUZckmyY4pDTUChylt27JZtjNnw/MZcnrqe4L6/MV4QWL5i/HkGdcXHpBY/pK486j94HYb/QvXK6SevzGXiyqmyNk0PZST6iT4GThCR7gHO5QDBEu3FONNA74h3tKM7PHtA9o4OxHcC62MrQrLm62VYG1S8+A1ddR1Ghw7ScKKR0k7FEhLHsNCuBFrGd51DdkKD1TxUFXJP0gaJGkGi7BiThQ8VBSFXQhSJWYzwgSk+Gh+8gbKHwxGApacqgAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_nemeanlion_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAUVBMVEUAAAB/c/mMc/SYc+6lc+ixc+O+c93Ic87Sc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93MzdOcoAAAA5klEQVQ4T9WKAXqCUAyDIwKbCuIQBbn/QW2avuLmtwOYviZ/2wd8tI4v3Pd99rZLXFew4L4SgkOPx7tZ+JMWLIs7CEvZJs6YZyVtVsZBcGfdCU7lnnyzMr/xWdNDugDTlCsO2zTB+WpFL32l9EMnjCNGOo2Ddtz6Afix8hB7OsfhwjKFWaUCh2HAIHJOJZ5lEZuSu47dKXwR+/IBOJ0ySJq2BA5ZfGEZ1HcpPjetFdJX9Mv4a9Oq2zaIHmuqabIbn4kkn4DaXu3pYa6x5gXY762VDMsAKCtW5ckQeFY8ATuvd/23/6Mnpp0NmhaYiQQAAAAASUVORK5CYII=",
        );
    svg
}

fn get_satori_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA9klEQVQ4T42Li3KCQAxF0xdVi4ja8hAo//+XTe7NbrM4znh2N/ckAZFnedsOIlVVadHzmP3eruZ2Aepa9NSIe058J4Buy+XCS7ZbY131Kmaua9z/Ou4+jF8syyJ2cNU5DB/M88wMzo5MeqyyTBPMmmy3mz4kgFvLjcgo42gxmhj+HxJlGAYryMHwL5Aofd/b0+INSSnSdZ3YTQ3Fe+UHUNHkBeNbrwIzMcsb5YqisF7FjFDOrIk8ybuW3gJ0rY9816Suydo0boijTwPHNGN+/W9IHrgciojmsisiWMrPB5nlI2R6cS7yXsRdiryWUbbGS5HepaH8Ab/CFF+8s16uAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_sprite_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAAwElEQVQ4T42JiQKCIBBE8Sg71eyyLP//M2OHXVjQrMfs7AOM+Zvc5Dmb1fiPWNlDQeEyywaZsleiXajrH2rMyUswEWIcRZD4DbzDVqp5+YpdGAa3SFjdCjylvSQ8KPagcI3pTd9TwZxH3F3FK+WGhD3LFVnggnzlbEOTvjNdZ8elS/+IFtO2LBMaTMOFiThKIlUc3PhgFDtOKIpiaw9Fbu5BUdmTpNL/a6m1X1xMaVOKYIsIRcEb0S8gy0R86ddlPju6CeXJzQQXAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_wraith_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA9UlEQVQ4T5WK22KDMAxD1fUyOgoFRtfS2/9/5izbSQy8bMe2bCkB/szH6gwJ9qy9H2yYLVRJqspWiDM16poC2wwCLdpWl0nagR59HwzUcr/fFDbFpzjyYlG0bcmmOk8Ohfp0Kc/Kgx3qMX++s+9+2agrTBMmCi9RuhW3m4yfPFQC16sMd/JamR8tX3poagu4XKDlyw6PhXHE6D9HOope+gR8S7ENcQw0dB0wDNTCIAG9KdBpRzp0nUaL/HwuZ+pMg6aBjjn2nJO0zYnOVuZLK20tCzJHKarMMbnCp1Q+ZehDJhzCTWMd2c3tii220st0wcbn3/wCMroQq7mLavIAAAAASUVORK5CYII=",
        );
    svg
}

fn get_yeti_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA4UlEQVQ4T3WMjXqCMAxF4xTYVCaw+bupvP9T2pvbtKnAsSS5J/kUcXwossgmsnjQNE2qs2y3vs3QtqK/dumg63yb4cdYOhjHMdUpz5LJ/jGh3N9n8Pt/YFMyef+nxDmrtL8R8RTiSoqDwlxAqG6v2cSZCB6FjlDkRNCRaGh5cCTWfeLBrxJbQmB4MAyD6APMOjAF+kBsfRK9pCgHEGs2kvM30CpGKfYAVTIU0ewAqjugiOYLoLoDCjOfARR3QGGm1q+uawuhIluQSr8qYH+AsYobsMZbA0ZOfGS1Cu8NmLB6ARQaHQuYuoSOAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_bear_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAAxUlEQVQ4T5WJCRaCMAxEwypuICrKIt7/mKZJ0zblCfrTTGamAP+Qpl4VBWKOuMJ3hqqqwIxxIEoVZzjS8PMiNVLTsEBd20ZqQ0sDrVnwjkrFGx9CJmImmcnM7GwpvALVQZjcmXRjGZ0ZJbmKGQZc8TZH9D30bMgvebI8ncY85NmwpAtPt/y/BypHcfsamKuyQXJccPg6q2ka3MDHnFcjclqNAIetYr+RYSfXGf1f+lvqRshzUe9CsgwyI8vAJGaSIFMBP/EBw7gJ5s6TEcgAAAAASUVORK5CYII=",
        );
    svg
}

fn get_bigfoot_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA30lEQVQ4T4WKCVbDMAxEh30LtLSQQFNo7n/KajSWkU0e/P882oxLtGY0XydbtLtL9mj3mGzR7tlFSW8q2m1d4rk1yl2XvVvZO2rLW9xgWfLE66koTqLe2X37Y1otxJ3NVwzsC3X2PNb7MfjZ1E7M88xnucrBwIHFcoVPw8NrfwU+DA8rsK6/Y5omPsIJzMw4jnxEc3N9J1HZsG9+vJmepGzW2GFH+nXllZJml9n427AkXtzoIuMGDOUx1Q9DzOLJ7KvU9OAiJSu72N27RFVzCNyaynWBGzfqb6/+Ebj42zNMpRTMINA18QAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_fairy_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAWlBMVEUAAACK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93O7wn4ZAAAA1UlEQVQ4y61KCQ6CQAysoiAocsh9/P+b0mu7iyHGxGk7M+0U4Fecvn5cttojSRJfINnlGY+TjKwhF85l2Vye+w+lL8hliW1YA0VeEfawBIZpsSvAHLrZVDEFbsKe+CjJaL8jzSh21Giwj8FrL+jto4e+x9ndu86sFHtD27bqaFq1HpqGmBrUh3gxbYVEzkNd18jkZK8traqKBRsqvWpcFCpoCjtI/nRC/XQ3CR5OHlR6cLgrU3P5SIlS8VwBbjKfiyKOY+eI4QDXK8tRHjFHRzmcHf0Xb0GnC8vPsABQAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_gnome_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAWlBMVEUAAABzc/9/c/mMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/13P/4nP/7HP/93N7+zqyAAAAw0lEQVQ4T62LWQKDIAxEg9pFBW1t1a73v2bJRMAVf/oSJpMFoj9z2Ds47+zLsowfVFUV3V+Z2MGXiR18mMj+LWzuX47NizjPCes3Dxsi6/R9T5KrdJ1Nx2Lbtq0ocH3g7iqYzpibN2A+JWoaKBz7JgzBxcIqHuqGQm3Dau1/SE9hYPCMCb0ZpgPapta2aACDqaeQKIaukMmYnDPP+UmhJScbzno34TiyI+/JMgjDZnmQ8ktJAt2MRDJJvJ+hSCkUFgUPfu97DW00DMqzAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_kelpie_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA60lEQVQ4T42Ki1aEQAxDqyAuLiCs+9LV/f/PtEk7nYeeo3fSNA2I/JfHtqh4olLyWLJT7VKgGvaQ2b79BhZZFh87f7BtaW+RK+453W0avnywihx82mCpKx4Tt3rfokh8mNviHdF59ynOiqvq6tsL3pnLxRZVFCVnzBmLxik5QbATL2SmxFGOKgvVdt70wWNZkTkc6GILFy2zrjCB27lygld9ZtE4ds3zrEbxcvdWmSaYwLFTmNBbVl70BYxocjtSCcRxHHVS8wzyD7iFz8tBNcRXiwNajtL3fXyW3sSuqGu6rpNOoD94aIvf+AYiHw02zfsHZAAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_leprechaun_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAASFBMVEUAAABzc/9/c/mMc/SYc+6lc+ixc+O+c93Ic87Sc77cc63nc5zxc4v7c3r/enP/hnP/knP/n3P/q3P/t3P/zXP/13P/4nP/7HPKDQuxAAAAgElEQVQ4T+3KCw6EIAwE0OJvZVFcdD/3v6m1Ii7JFC/gazNDQoluwI+V/r8pFJ8UircoHFxYEu1izgoIIcRQvLJCJqH/e+9jYCMvkwcybMPkgThyaeHBU+YoxFpLshb/E/X9mdAjK6CL1IOWt5VSNLyNlKLm2QOr/hYyhgzn1qcVNu8FZ4Lw4gIAAAAASUVORK5CYII=",
        );
    svg
}

fn get_mantis_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAABDklEQVQ4T42L4WKCQAyDCw6csAkKwsZA3v8tbZqWw/nHwCVfciDyng4HRrzcHFSllKVTAtupEw5M/eSwXai+6AyffDNvYm0aFFhMzGt8IFeih1+tUaB11b6miXRnYdy33Ae1LIssSCN0MDXPs1lSbLz/U5kbmQvcf5dJJZMR2HDCjI75V6UOAoOswKAflWU67OYi4zj6lwpAeroYhsE/QA72eCfcbt4VnyJu+t679MraooOhrut8cfjfLxfvCob7AWrblr0Vg6gbnM8+WGrzYdvlO9KBGU1V1/U+9+6q6FVlhhCzpE8zc6bjs476mB+RryqKIo76Xh901QakuMxzs1yQMBsoYAbIMryAhFT2AOtcE/bcCsziAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_ogre_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA8klEQVQ4T22LCQKCMAwEA6IIKgqCB6D4/1eas7S0E7LZTQrAljzPk95RQIGQoVHED0rRsvRSQF2b1qh1/AAu1ARc2EfcbvyhoZnificxk+AXSsCyLOa0Q76EWezt/SNo2F5hnqlnMaj8rUzTBPSxYKMLGMcRRSyFUYPxdtM5M8zLhpTtXnZ/OkM47/6HByR4rNthGDbHQdYW+57Ve9Cva6JLa9dJgNbXdk2t7q4sVx0ghrYUyDZg2jROG9nxOIOqGC+cdXXSdsHMSUKlHVFVsj5y4Ty6E1vrAxYcWD0o6XKvFbHX3lHt4jtdgPcZV4Iso/UfJwcO5ld/2ocAAAAASUVORK5CYII=",
        );
    svg
}

fn get_orc_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAABDElEQVQ4T22KiWKCMBBEpxZKLzwQBBWo//+VndldjqAvmzk2AVJ2O40n9zUZsiwuZAxOURSTM7my2ZBv4h/pKlI1W5CyLP2dMZoWpcFwJDj6B2XDooTLs+EfFM6u0wp4EDyWpkn4MzxpwmMnxnHEGC6ZTUsxDAMGM4Z5ta7oeUz63ruQTh+AO+7TsAjT5cNN56YgV5CZO1dciUcz1VgYnZhDh27ZGC3atjVXMI1NcLmAR6ioR55o0MQ0VsXqmdQ8qGsfkT4DVeVa6cpgi4VT2Ek3NPlwSPNBrFYr9nte6l7hBb/EVf6CHzHbM1+G+/bN+BTukG/5MCxonsnzHHmE3MKGdzIHTylvZA6e8A8RyRv+eqdfnQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_pixie_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAVFBMVEUAAACMc/SYc+6lc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93NUC+OZAAAAsElEQVQ4T72J2xqCQAiE0bI0K13XNO393zMGTwservr6YQYGiP5JkiT2pEhTlj0G5OjcXjVP6QM+0rv01DM8duk6Qh3wZvRBJaK2pVblMAhNo1IYmNdrsjEvL1DX9agh0jBnvPfkMaWHJaSqYCggGZcFN5lzkMNQlGXJJiXJvJmigBF8nwewx5D7bNvc1FiTQdmgLa7ck+xPuHDpxXDm0ovltFo0cbzeAqKIonlH+iVf+MQHlJ6d6ocAAAAASUVORK5CYII=",
        );
    svg
}

fn get_rat_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA60lEQVQ4T5VKCRKCMBBbFW+kIngr/3+mu9mDFmecMWlztUT/YT6fLjmWIWMtsZGzsWxeYO+HZQ8r0Zg0DZ8GLUPbtmoq1uJ5GAb1cSna+20eArNE9HqZe0UQ1eXJtKBmg/uDCZhxYGTLnan+DdluTMDMijbRK1MM6pByFbBfmKIGlItdtLPw7O/SQ+WJqKe+xwbtR3d0HXWRWNBsAU7MiLjaY6XjcYyoGFQVaZJSSpJS7If4IOkAqhvq+IBUw+ps38WHXZazuHXBRSuxVl2rS/DoWLlrWIEFqsrdUkW2BBYKEv7AjGZ8putvfACIIA1Zw/JgzwAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_skeleton_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA1UlEQVQ4T5WKixKCMAwE4/uNKIgK6P9/pkkuiZTqjG7K3TaF6CemIczwwVl4L0gmY80DWbOaD9nxmDHJEygKKszSB+PEIyV5ssuIJ76ntGXKQ85jkGN6Hep7SC8kP3QddYTTMdglf7StBmdLohLazt3iztgtSrkhb/iwMFOuPIlp+Y5pmmjRRkeOc+HRctOEgRpZi8BJPaisKlGN2IFzlBy92cooo9RKxp/AMcpszCHKLGOvIamWs81kxMYTkrPyhGQsebTQH5h7QjJmPJLfmfCZvPMPXlr6DM4rtlcJAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_spider_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAYFBMVEUAAABzc/9/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93OndKRVAAAA/ElEQVQ4T5WMYVuDMBCDbwgOp0xQNtiY7v//y12SK3T1ky9tcsn1weyfvIiyXnldKTfiLaPcgY8ND+XW+UxoLNf2lUhT+eAerMP9ef8baGB+fvAj5KZDbvHgRmTU2CzLkvwP6K9+rvEPxBxVFz8XOMgcCzDPMwROWOmKyaYJJhQipid2PvshHNWwwvbENycC2zq00HEccQM2KrmLp/ZNYo6o3mUYBsqgPUOqkfrevadJDRfGYMcjxD8eh4Iydh2mjurWcUqeerP3wIdoUFEjHuzgQEySjKPTttKWohRlsMfdQzVwSpk01jRZUsirgrquZeVipaoqWtlv7Ha0B3nlHfG29LsBAAAAAElFTkSuQmCC",
        );
    svg
}

fn get_troll_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAY1BMVEUAAABzc/9z/3N/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93M8HRRZAAAA4ElEQVQ4T3WKi1bDMAxDvTJgjDIKYw/oePz/V2JJjtO025VjST4xa+i6rj3MWMe7xWNjV9hqy67xgoFuMdgwyAy+YJ+2j9jyx8kUecKvC7u0hh8XR5anyrerpHlwLi6FSwQeJ4zjtBnbKAu+XLRSJ8Xs04WJVUIWs3O+M6y28uHkwtTOVi9HzLF+QORNHCh44aCSh48ytecD7xy+POgYpzc9TdAUe3VhfGmzMIrdDiuynp/ikPRaYdb3TMmzC5sPtuDJheGit2wwm0gKCx5c8ggz7jm1zLnL5VvesAplLPwDWcQLobQoBAoAAAAASUVORK5CYII=",
        );
    svg
}

fn get_wolf_shiny_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAXVBMVEUAAAB/c/mK/3OMc/SYc+6g/3Olc+ixc+O3/3O+c93Ic87N/3PSc77cc63k/3Pnc5zxc4v6/3P7c3r/enP/hnP/knP/n3P/q3P/t3P/wnP/zXP/13P/4nP/7HP/93Ow8UUdAAAA30lEQVQ4T52N2RKCMAxFUymURVRwAxX+/zNtkzQN1RlnPDZ340GAf9jlQ1mWEkXTBnXtL5UaRW1dB5ouH+BwkCQCOg1DDDCQiTPr6g8DSyrMsiyqZJ7zyvyDp/KYmYeI8g/mGWYK379PE0wQHp5w/5J0FG43VHx4GVcdVWEul20VYc4oZ4mswqh9hDF24aTCiWTLUYej6kTfpwg9mWbPh7bfdKLFh6nNBqThC4reNHEgHItz4LA4F1ekCldBRSHEOBHWP2vJabDhAYmnKAq08ONMW1gCRv7LGDBcjZp/8Abjgwj10KYCHQAAAABJRU5ErkJggg==",
        );
    svg
}

fn get_anansi_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACcYSPqcsNAZ1c4dSJH7rZxcp1TBiKSfmgIkiZG3u6llaqGAvP7pXrJq7ZyEA9g00C5AV/xGWxkzTSdlLO81YNXidA4dHjlIpXkWmXOk19R+KcEg1bc7Vtany8xJqzK138k8cFSAQhp1CGiGNoMfhmpVAAACH5BAUUAAIALAYAAQAWAB8AAAJfhI+py70BjZi02nkCuLx7DkSa5iCBBWkfJq2e6lIhdlbwesfVrMvh1qOMfD+GLNcbXoCdERNXVPZ+NU7VmnB6mD/ZB4J1Lr7gIItxFfAsDhcpPdHGnquDWWgo3/dqQwEAOw==",
        );
    svg
}

fn get_balrog_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACo4SPqcsW39ILcQLr8IUaaWpx3NFdznlSpmquLIiuWUrS76SyUvZBbV5B5Xw632aGFI5qRyDR04yBgD+YkPnaFJc/idV6pLmYvNa11pkqqFAzacsWhas6r4wIUy9wZHWWN7RmFueWxGD0FqFIVnhYhzOEVyKJ2PjItwYZQ1fSBlVkeQgI5oJRxyiWiorFB6rZuGkoC0t5OppkCtrlJrln2oaZUAAAIfkEBRQAAgAsAAAMACAAFAAAAl+MjqnLF2CanA/AOLMI1VqtAaAjItBYMp2HLd5FXafEzVnV0uNuvv7H+P1qL45ReDkWccYVZOhrOi3SRyN5zLwmW1CTYkR5uGNv88nC5hSp5XDVizI5YCIxSV2tSax5AQAh+QQFFAACACwAAAwAIAAUAAACVoSOqcsHYZqc78GJkQX85Rx84hSOJBdcprStX+SCUGel5WKn9Fbr9Pzb5YC/ISrY8+2OwgYRhcmRbCIapSOSSrSZ4lIJY9yMyyQCaEMRr2r1061a9MoFACH5BAUUAAIALAAAEAAgABAAAAJLhB8Byrq83pkmuVjl3Wl2j2FbWEGUdyHpuZ4Z4say+s1ljVp6++A7TvkBY7+exeZqKZHBW5HEXDaZMOPuRYVqebKP0MsVlkAqp64AADs=",
        );
    svg
}

fn get_basilisk_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoR/oYrtj0JbsM4kDbN2a8xVSxZRIUBmJuaJFwqz7UNCnjQ79bd+J5rK+X63HegXk5WMrkmxJ2ImR8KSjXWkSWtV3dZ6gg7HHOGuq7tGkMk12DlKpF9LKmNmbNn3XBsOSgUkp6WxtXEYFVJEhlVWl8jm5sUlReOnQvZ12SdJN3lzUAAAIfkEBRQAAgAsAAAAACAAIAAAAn2Ej6nLGg9Dm0k6Sxl+iOflGRv0VeR1llYqRti3Aq/cltpmT/OsgTIf0r1YHWLv4Em5YKagi3cxFTvMKRLaYO2wKKcURtyqgkgr2HflOtDXJpm2TqefFHHrGcl+8Xi2nN9XAcKR57YzSCjkhagm8hNzE1KIAhdZ+aMDdghQAAAh+QQFFAACACwAAAEAIAAfAAACe4R/oYvtn5yCtIV0ca0zmpVtFtBZoIhkTAqGqEqyX4ma3uY+eU7xFz2ruVYSYs9GGp5wRWWLWZSloFMMj/phXTlD7RZCc351XW0tWJ0BcWXrOTkyn4G7tbUTJpNby2zTW4e3VfK0Z2RWCIanmHSIJWPUF6VHmDYZBdNQAAA7",
        );
    svg
}

fn get_colossus_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkYR/gcvtoVwCUCKIs1Z8v2hFoGWM2VKR3zkx4IiWqYyKc0zdMEbl8MUr9YRBX4M1FLUSN9eMoxoKp8uoDFm1KovN6O5k83aS2FyIatY4nxUdsEtVumrV32/yIha1Urx1vnT3d4T2pnaRdqVlAiixIyVHE+iWxASkuPEEiWbT6Sd4xMLYkelxCFWpolnX57g5UQAAIfkEBRQAAgAsAQAAAB8AGQAAAm2Ej6nLEA1hePHN6Kbe3OWuXJVBYeWxoSdCrSzokpYYyq2basvd1rS+A9I8pBdOWCRKGj8Mo3SKVUAoZ6IHVFq1n+GQWeR9pVXlhZrcpaPZstF7hbLm3HB5Jrs+65ZMfe9GxjHm1/cXEuXzRVIAADs=",
        );
    svg
}

fn get_dragon_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+AAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACpYSPqctt4SKDgEpna803cR18V5iRUKiID4Vu6Ll8LbhuBzfXMLtbvv0Innga4Q1UQhKLM6LvBXzhbjtXlBpEsGgk49OqDV9/4GINqzuuhjAat+3iTXNIZl2a62K33LLHDLUlxzZn5Jall9VXJWZlEqPmYZKoOBVGCBWJuNnVuQaXItTSWdgY10Z6RCc6xIq3FiNl8yQDhGaoRYkLKyloFjGZqNJQAAAh+QQFFAACACwAAAEAIAAfAAACjISPqcsZKKKctNJXgY2vha9tYod8JHWIXEkarftJbfe6ACbdgXxFdnm75WIqASio8xmGj6aSltPtUKIQ9AKiykIc2mEqTWGFmcQKZ5lWK1k2F2VGqd9F5Q9SrwKn7fym5Fc0N0EXqGVkaFgYOPOVKOfg+CiAhOQ0mXaJmbYYSMa2qbY5SsrYV0rp8lgAACH5BAUUAAIALAkAAQAXAB8AAAJnhB+iy93polwwgonp2SZ4fEWeFwocQJ7kUipox61T8NYdTRtKzuT07ELgWq6KaYPDOX6ZlDHDQDFFJwQqU7U+H9kNNqvE5KpbS5dIRb6gwSx7yuZ6d/HGvP6AwqNQNL5e9ifIcpZVAAAh+QQFFAACACwAAAAAIAAfAAACgpSPGMntt550IMU5K94G+BCBF9V4FaiB3aEpreAZKhDCLMmg8MK/lA7Z0V5Dm2ChGQIDsaPTEWkxd9Om4noLfmjMkyXhu9CEF97vW9sFOVgX9zvGjMY+NpQosz+mekkxxVaX1ScHaOdTIXhIWMiQojgxgmDCWEmYaJmpubcJ1vmlVwAAOw==",
        );
    svg
}

fn get_griffin_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+AAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAEAClYSPqcsQDyMKTlHqcMu6mut137g8JDRFqjR9aHuYmArXcdlosxeaJB8T2TYpoWXFOo0uPldi1QIBe0naD9QxWqLboe6Fdd6Au5K0HKxop2Fizj2FqzfrlFe4RqGz9KfsFzcDVjQXMtTltMN0g/eXyCAox6KTMYYYtFdpyVjHkyUiZbdkJEj5pkgJumjmVdNWCSUnm1AAACH5BAUUAAIALAEAAQAeABAAAAI9hI+pe8EcnJiUglCz1jGmDWqIZ2Dh6ZiCY5znhVSluzUiQLsNa+cbS2r5MhLZECXEHUO80fIJzVyiIWWuAAAh+QQFFAACACwBAAIAHgAaAAACRpSPeQAZwSKMtLKX7mSqeyd9HZQ1i6gAQWep6NdG72ysNOlkGO2pKvQI8Uq20zAVKx6XTIOrCY1Kp9Sq9YrNprKmKo5qKwAAIfkEBRQAAgAsAQACAB4ADgAAAjgMhKkrEQtOMqyiuBxGz3orUR/UTWUzZlKmPGvKno0Me6HwMgCdu3NtQ4VyQCGryKA1iMhmU5QqAAA7",
        );
    svg
}

fn get_jiangshi_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACf4SPCaHtGKKcUbEH3T11Y59xBvhR1UhinEeVpxU20jolrN1CzM6f9U+6bHao0UJ0tBmXt2QyuHTWokKY9IOECl9VVFV7TCmJKaLzGTJbmhqdComOvnHB1zy9ld/ldrHKD7cHqDc3eFZ4Zxjzt3f4oBiIJZjYuABo12gyVcmpUAAAIfkEBRQAAgAsAQAAAB4AIAAAAnSEj6nL3eEcVHDGgLPGx0bgIV4oMRP3iRtKpqjBpssItnBmig+38njtW3UqHdANZkS+kpaTLsl8NoevKTSKfBSvROC2GaMRbbpxokvjKinp3PBjtcpupN+ceXLeuW0ZeesHd/eX5RJoiCiYeHG46DbXs9FQAAAh+QQFFAACACwBAAEAHgAaAAACZISPqcvN4SJMcEYQst7Z1Os9FIiJiHVx2khi6LS1x9vJbGivsdutFDcruUKWnvGDe+FKvmFx1nzWksHGU0iNLnVLplfiVV6p1W9wvJAqplhYeShhe+QgmL1Lop1yKRnKlNe3UAAAOw==",
        );
    svg
}

fn get_kraken_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACeoSPqcvtD4MMsBp6sW1TAr0t4Bcek0l5mhdhbpK+YffRZYZeCFu5p3oiRXSkVLFkPAqTs6VJ2ZTVoJuganoTMkYWKZHbI+7EVe3YHEZ/kViFt4Ve8aJOcFcnsz/yMXKaZ/S2txboN6hUqMaBk+c0hBXjI+j2k0Rjk1AAACH5BAUUAAIALAQAAgAWAB4AAAJjhI+pi+HBIjROplfnqkfTvnVQBjbUeAGcKY5Y2YofXL7ZY6k6OnmqHVuxZjSFr4eSCHe+VC6kYy1/xWgTCY0GQzhGk/gERz7JpJcshfasa6ln3Z65qDsiFouu08vI/k1o81AAACH5BAUUAAIALAMAAwAYAB0AAAJhhI+py+0PozShBlnPpXevrlkg4CVbhoKnknGmV4ZcZ2kOvJJtI9Y7NLJFYrJH0MSrJRmlWJOJYrWIRaSOKrQOPxMnCaOifI3i5w+RKrt0Whr7CxNG4fHVyY6+61PnK61SAAAh+QQFFAACACwDAAMAGAAdAAACaYSPEBvpr86CqEnWLDVac7lNYgY+FlkpXjKpGVaa4xeHr7s6Z0TuOtyZQTyrnI7FQdmKqg1t6PSVWr8azRhpHp8VkckVhTq52TEIpaTsiORUFi11U990JO/GI5/g5+f+8wf2xoDTNTJRAAA7",
        );
    svg
}

fn get_leviathan_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAClYSPEIGbD9NiZh4X49xY9dw8lkddX3hWW5N6iiuOZMyWMWe/oGimeAms6FQ5ClCmYyhVPJtPuHw9YSGpdQWZQq8yjiR3JVqFLPKFezarh9tosDosJtkw+XoJNmXV+BYV7iSVt2YmF7WHCGa0k5gxmAb5KMG4OEkHcviGSGZ3CMd45wgaV0nIxEOEpYFzSvJT8xMr+1MAACH5BAUUAAIALAAAAAAgACAAAAKYhI8WCcsPm1MzWjmDPvsmDYZc5ykMSFXYs5FIWKFv17Ly+p6uDn9lnlJhdsJFjGiCxZINyqk5ejaNSaSENc2KiEKodkqiFVVUh8y8g5K1xuUMyPn6oqZ63Cz1xvXMrmiuV5a2N7fWRmiRcZcF0aWWg/cT6VjTCEglyVfn97Em5ahzAQp4ZUM4NkOmOJJxoxSkpvQqS1srWwAAIfkEBRQAAgAsAAAAACAAIAAAApiEj6nLHJFgm+chS+mTYFeeGduIdWUIfuJppqu5kBfrwe7K1ZWix2R6m+R6OFasMwOKWssdEiIxQme85fTZyx2n3BrtaH0yoxig8uoxR5q7LvISAZ3F7XXTha6+4O/wNT7X50ekweYX0hd1+If4Jofl0KDIZySo9xgkqJTIRQfD89VyUyIzKTfykabySfPzk3oK6zr7KvtTAAA7",
        );
    svg
}

fn get_manticore_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkoSPqathDgKEUbr5cpWR+WN5nMZQ4PeYyDSum2qpS9tdtZjI1Zm1Idz5wEKoYjCnsZ04MZIwyXKyfKYoRXmcZV2jqgtZiu68G55NVzwb12wouQ2eXWW0nV16/TJ5jaq/mbKG0XMziGb3d0SU08X3MncY53hT8tV35mM5WRnYVFfnaLXUEJdHAzhGmIl1kRgJp1AAACH5BAUUAAIALAoAAgAUAAgAAAIdDI6hhn28GnsTKJeezpjKj0HU5XHlNhpiZXWnUgAAIfkEBRQAAgAsAQABAB4AGwAAAnyEj4EQrQsjMy6lJ698PC8MNZZ3gCVFceKljinaMdhcdXE7Z6sMK05Msv1opBPv9zHpbBNfahdStSZGpBElcz4jItOQWoS9njvoEneabsDYdJjdjCt1Uef82rasQPxQMFnBdUfjRZfU1jX2sYioVRLItvcYyZiDyPMI5VMAACH5BAUUAAIALAQAAQAaAA0AAAItlC+AcYq/gmLpSFuhYe7d30GXxlmhdwqgRmZqR7Fis8r25t76zvd9GPNBUrwCADs=",
        );
    svg
}

fn get_minotaur_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODdhIAAgAJEAAAAAAAAAAP+AAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAAAACwAAAAAIAAgAAACnYx/IsjZrOJ6L9agqE7ZdS5J2GQs5NR9JYKOIgaHLezE9mq610r3tJnbsVQlEm/E4hkbqSKSsoQ8ldHbhhkUMpNbqLDK7UrBxtf0WENDmqC0VDf0aGanNLH+tTqfsxobv5T1thWoNSQCFNZX1pWRhdeTmDP5Afk2GYO5wagpM2hlgSlD5Idz4+moFOaSIvlzNReSqXoUNYoiqFamUAAAIfkECRQAAAAsAAAAACAAIAAAApqMj6nLKdIOjK/OKN+CGrOKcJdhlWIYXFPXSWialiRszrBL5zMXj/itep18vwyxZUMCbZ8VidcgopDOzc0Tglo/L0d0e+WCp+LnSHnsOkBhdlitaGnjTPdVqQ7u2vKk16Xlg9fkF+ORZqVxYviWZZHjpsfU6DTYuMOTmQlHt9kDIqXz5CVDhVMZpwgV2OX5qfom+frKxvJXVFEAADs=",
        );
    svg
}

fn get_phoenix_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACh4SPqauB4R6MB77rop7caJAxled9oIiSqZhR5nWWccVZrdzWi35SfTlZCYeMF3FmQeo2o2YDtCw6d1AbyqeCJbGz3bZL2nCP5LL5XB6valimtxNLKkPO7+8py2L07Xy/SZfFJudD1+fCc1dHZXMzplYUZEYoV0VztfjhMsVppPKXEqIJhnZUAAAh+QQFFAACACwBAAIAHgAcAAAChESAqct79lhs7gQ7U24XGh09G6h9U4h0jmKZKKimZFvKEP3Z8qlfPs3DsUi6YSsmNM5yxZwqE6RgfsyVMPTz1Xam4S1bPHqxVFt0C9vwUiORiKN+epY3yjJ7HNlZ2r3f/PbnVQeDJhHoZsbmh/L2wshl1VQiV6XooedUBST1xeXopHVQAAA7",
        );
    svg
}

fn get_tarrasque_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACmoSPqcsQD58z4cja2EU1OjhRXgJK0zWaJ5m1CviJW4xxnomS5UpZfA1TvWouV6eXwxVlkU4TAw0Nn7QPSkm0hY4cK9IG091ON670GKUFjbwly90CSuGvs2oG5za3+Aa1tAGVtYDmVIhl5oNG5tUoKHbl47iT4TQnaDnIhNg1BgkUGdhoMQIW9ISzaKrnlXn5JSfi+MWSOEWHWwAAIfkEBRQAAgAsAQAAAB8AHwAAApGEHafLvZGcbBGkOjM8N/uObArmWaYpnqSmQhd4Tu5suTWCy/PeguuIEkUqm5/kZfMRSzua6slBBUO14Y3UTL6qyhi3IyzaWhrr2Al7XHPaJAXcPbtHvJjc/MjSpTSYnuzWx1FHdxZU9IU1hzPUNBXiCJnlR+XDCIeYw6eJNLUFlFZpKPM4WFVS1oiKOrbqClAAADs=",
        );
    svg
}

fn get_typhon_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPFgnLD5WTsaawcJvW4s91UdiIEpkp5aUd7eoy4aQ56bzBapqX9qfLAH0UGzFXM/KExyVouPTdjqfhjhh1PqFNVcy7eZG8ya8LV/ypwZeTmyKDjF/h7aol3M7md91ZRudn9saSp3YYNiIWBGPF9wXCRhPIwjgHtWdVJxap2akHaogHRFpqt6OXeFr3cGqaKBJ5lgdrgoTJWtvqOgoKUAAAIfkEBRQAAgAsAAAFACAAGwAAAmyEL6nLfG+CBK06Gd6MtoscZd5IluaJpmoirhYQWHE5v0p91tSyu0n/8VVwAoPLyMAQcxih8wn9RXmQ6jIJejggVxmCepAIJ8pymIwJlWfrDQytPLvbLV4ja3Vr0ml19b+30ecH+Nc3qIZnUAAAIfkEBRQAAgAsAAAAACAAIAAAApuEj6nLHPqaRCGaOjPA3OpWhd63jBsJnqfpiNgFHe6rJuH65DRV9zIfk+Vgw43OSFQdI0PmjLkiNqOX529KwzpfnF/1ChPuoJasCGJyXVk+L1pI6SJxnp3xBqZW8bYR2882h3d29yUx2FPEd2hIWIZyU1dIYiVGeKj2pGm3Z1apGWcXOdM5iFg4ujhpeqezJbpVGtsZ1DopZrtQAAAh+QQFFAACACwAAAAAIAAgAAACoISPFgnLD5WTsaawcJvW4s91UdiIXlmSo3Yx5IewW6uFcq2gIJrvKeXI6DLEnm4m/G1ArKQQ94wxY7+iMcj0RY2HiReWewQp4a7NHL41IdivRKXiSd1L3Cyl5fio4xfYfCZ2ITNX99ZGFLfUJZe0WKF3WCbnYddD+MY2Bbi3x1mTFTol+pWIuEMKWKfGuvkIilnoAvP3Z5KnFwvZhOlpUAAAOw==",
        );
    svg
}

fn get_warlock_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgISPqRvrFmJ7lEnJwKzwxro94aeEnNakJpKe4+myogZDx1p3JQ6qK1baqVCjSwJow3gmS5bxuIwSb7SN8iptJW/YTlZLC5JQZOCHJ3OWueexuqbM+ZDkXDlOlV/rdnXbbTfX1EcUBahnSJiUpdg2RQfz5dE3KRX4+MfngmQ1iVAAACH5BAUUAAIALAEAAAAeACAAAAJ9hI+py+0XHgy0RWmorulisGmW5IHl1yEcqpRnSqrOO2a19a5wG+mZb3JVhkLRxNgjIkOeHqjDZJqetssmGJQOISplNoSlVa1JbNa8m26PVB4LOPuexAylk3Uswz/EM/4ZZYQXKIiSFPUHaDdl6LXIBxbI93NoRpe30gR2UAAAIfkEBRQAAgAsAwABAB0AEwAAAkKEj6kWuwGbS1LFO1m+cYsPhl8gClsGkEIDeeULl0BMxyhVm4+a0x3Ui7FaQRsDWHx1kjZmzRCaOUVS6VTEu1Kt2gIAIfkEBRQAAgAsAgABAB0AHwAAAnuEj6GB7Q+WhGZRaSGrd/PneY4SRWKTXQnFrsfZshvckiRKl6+d7nDGsARFmMTEVzQlS0Mh5mnSMSu8JtT2QkWVV6yKGgU6TzewlxqMqcsxK1vatsLV6OGWbgz36O4l/+n3B5gjwzVBqGE3hgdo+CZzCMWnROm0lhLiVwAAOw==",
        );
    svg
}

fn get_ammit_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiISPqcsd3yIK51EAZbS446sp4Odl4TQaYHpSXAWfzDWyLempMlon9qZ69XaxYm5n0hllSdwxKElCLCnXxkV19n46K3YS45K8LJrV8ckuMk0fEKVca7ZPcMc2bBtX6HpYWQXDxQdoFyd351ayZGgWVzZjmAgl2bhISIiYSPN3qFjHNyTi2XVZVwAAIfkEBRQAAgAsBgABABkAHwAAAl6EH3nLG6hAbDS9ayZFogv1SOGWiQ5CVmeZMuEotc67phhdk0GXwyoO81UsnqLxiEwaJ8rmp/NwNqPSpqRq5e2wxavAyz2Cw90tuXw2js+ZdNHshrvn9DoUYP/E0qkCADs=",
        );
    svg
}

fn get_behemoth_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACeoSPqcsYFp6SDdAX8aKJ19iBh1Y5Yoli2deAGedJMDqOJATd9E57Nt+xnCZAlc6y8a1WSGKsmRviHNNqKiirQUsvqVAFDIvHk4s3fCGOz9Til7UzbpNc8NynzQnf+GwbZ5SGFWTyQqg145ZnpvhzFxfS5selNuVCxlMAACH5BAUUAAIALAEABAAeABsAAAJxhI+pyxjfooLmBRnvojhp8B1hB1ZjRYqnl15Wtk4g17z1TGeMC8Xb//LJPDzUkFhCBXdGY4/n+iWbuOrUQf1ELVrWNfSkjTRgBxdczhLF3mYUtmYLrzORndp2usk3bFJLEQP4R6h3dPdWJnhWZzIWUAAAOw==",
        );
    svg
}

fn get_chimera_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACm4SPqcsY32ILgFKJz9vm1rxA3eiBXFV+qWSpLaqarYhuNOvd3anNzseAvICzi05TOxkTy1VR9LLlVqOdD1qN9YhYIWxK/MJi0tvVBiSPFV4pl8wrCcsuX22dLLvtcwfdwnGVlqJXF6hFVVhHEub0Z9WE10P306bF9EgSN/GYk4TkGDL4yfgTRAMoF3eU54cahcZ0aSc6BHKL21AAACH5BAUUAAIALAEAAQAdABYAAAI5hB15y+0hYnSUpmuk3lwrlHWidHzjKUFREKIdm7buaM72jef6zm+sugMogL2i8YhMKpcTpRCQ/BUAACH5BAUUAAIALAEAAAAeAB8AAAKBhB15y+0QIBS02otvCrl7e3DfSEGRQXpbmkZuxH4vEH8SXTcVLCeg4kJMcqfghse6nUKumKR4FMaMp1Kt8oSark/TUZTszhhgknhzoHzX6+7wijXimmqnfFlm3dNwtfvGtNZxFoQgqCLWcIjDdWjVuISABRnppWAXFdJl9/fgeVAAACH5BAUUAAIALAEAAAAeAB8AAAJylA0Wx+0Plny0prOqZilH5GXb0TnRN15C2Zyi1Yhf545g67ybTmL2dkmgfrgcsbjyHR+LC++nEgScUaiOFaMBl9yu1/QNi8fPZdk7PXOFCsiXN2RWnmmYNN5s0RHKpMcWINNW07PjUqVwCLDI2Oj4uFgAADs=",
        );
    svg
}

fn get_chupacabra_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjYSPqcsZDaN5gLaAoaV8bT2FlYdYyvd0FzmOaWuWjPq64pHNIXpXNV4yvVKYYg+XQw5hk5gsp2ohI8Moi+rAaiW7rQ/rlF1v1qAUiCY7w0zpL2z0fVzQsvlMlAPhc/2GByLy43Z2kjYIVZiVhJjIZnPXJWkY89ikmLGWZLbZVQm5h6no+TQaCMqVqgpQAAAh+QQFFAACACwCAAEAHAAZAAACaoSPqbvBD52RkFGJX6Dnzt+AiJdxAOedn1Na3cuqbYLOqqxs94Ti5xX7mTaxIFGEyYCCsmGTpzG9RhWpqLIKdaxUKZd7q+2mZOCVivbtjsIpS7emKVfv5DrV7mVz7jGc6aYEZEM3AqcWUwAAOw==",
        );
    svg
}

fn get_gorgon_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACfIQdp5frj+JKFFrUMmi3bxVwTHhVGXVWnrSF5rg6ohqX341+4uNy+0pisHq3GEkjRNaEE1btB1pCgjSpzFdUQT09oqu0DVp3Wt82GukWjc2X5szLfVtO4A8pBkqw+WXYCnOkNNZXB2i2BthypHhFt3bix+SFIcWYVdkYUwAAIfkEBRQAAgAsAQAAABsAHwAAAl+Ej4Gmu9FOlMk1eITWmHUnbaLggeAofqaDtq3UuIBqXVB7rZO7Aenq4/VoicDPuJmAiMjeTGkSBjVAg5DkuWqn2q73Cw6Lx+Sy+Ty6nW1mJANNbYYV8BnnHMyMaWRQAQA7",
        );
    svg
}

fn get_hydra_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACo4SPqcsbYWCbUsaaLAUavp9xm3dhoeh8nfpEZWO64qoqdXul8UGyfD0raTgs0ow2dPxyqJtr9epVWlMUZRec2KhEHDWJ2HmDHevPAjJ9ZcgtlxhCN89dOK57T5vX96b8xXTjhbWEljZUdAZU94UBxoMXBpcxtsV4OFUF4yElyZnC1lMHiAhyaRfVZ2WKOjiJGMbXKAU2hjSr5Xd0urh5hPmmUAAAIfkEBRQAAgAsAQABAB4AHgAAAliEjynL7e8UnDQYC6hueXtnBaLYfdB4lWY1BuuEWW+1GPMmevJNAS4PDAoQvEPEV0yoeKFDa7lKNYU7H6nYIl2AFwyR2h0Fc43dzKv8jYUPNfsNv0HZbnYBACH5BAUUAAIALAEAAgAeAB0AAAJyhI+py+IPo2AoAImFpcdmCQQOJzrlN4ZMwKLPxm5K6n1hzCr4fWWxIeuoYiAh7Nd7nTDHE8mlaWmAQZ4BqrJWO0uoN+n1SsNfcnhsRt1AaSXY1H68J0TbPBrp+vQjyG15d5aBEKcHE7eHqIhYs5jnGFEAACH5BAUUAAIALAQAAQAZAB4AAAI4lC8RtujvFIPUASkrbbqLG3nWl4AiBKQpeX5YOyYc/Mz0Adx0riN2DwwKh8Si8YhMKpfL340XLAAAOw==",
        );
    svg
}

fn get_juggernaut_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPAAAAAAAIwAvyH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACmYSPFonLD8OS00EF7KMyUZ9l3DiJXGOVV+p9Tdh2aAzW2O2ehwajfKgDvm4rGOtofLF6xN5vB2U6dzJGVarSyUqOILSSI16LJs34af2qqRf1sjNquxXd6zjCpovo9/TGCCanMmO3V/TDBYIWNVShuHKGM4WWuCY0ZJOFEYa5tqWX1CmW5FIGmjZY6eNFlfJBuQQZtzErZytXAAAh+QQFFAACACwAAAAAHwAfAAACk4SPqcsb/ZoE4VUbIZW3potYVEeKZRiJmpGx4KGiHvrNrNJm6dzdH26DjTwx3+SW2uQ2TJyw2YIalc+lMVgLaXe8KPIl5BLDzdVQZ8MydMxieU39nr2OODGorrv23fzPuTM04Xa3RUe29ebmpNWm54D3w3Zo4sP2+ESVNDL1ZqcCOuU1qYTXN6oJMgq2ikGy9mpQAAA7",
        );
    svg
}

fn get_kitsune_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACmoSPqcsb3uIJD9BKZcsP269ZGfh5BjYqXleeralOLLhWZGKXcze7zJgT4U5BSDF2FOVYRSbi4ltOntMqDCgjWm2waIQz1GaJF+n4aVZy0V8sLZrSgIdxCVSnRSWVYaFPFtS0RlJHiLNTVhPGNZh41XgnpnY26WBSBifHeJZSKNlixEY1evMXWCXJ5PR5xQbEQ6qX9PoT2aanUQAAIfkEBRQAAgAsAQAEAB4AGwAAAkqEL6nLen9CaJRJGKtWAZu5aV0FhFQpmk3nqeEjudsFgLL43TOK6kwvsPk4GOHwiEwql6YaM/iJISUsBPLxzGq3GyeTRU1SIclHAQAh+QQFFAACACwCAAAAHAAeAAACeYR/gbntoQCM0FmpstHxoq5JjMdwm9h51Cm26UOFWay2yRta+bU3K8/ivWAk1vBXdH2CugqIdpr4ojXk6Fph2m7ZbXAy/ECz3SZog5ROl4/F8TZ6Xrky8ApMiuG9qme3DPOzp6cDh2bIh+ZUuFf0luSGYgJ5SDZjUQAAOw==",
        );
    svg
}

fn get_lich_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEGQD/ACwAAAAAIAAgAAACc4SPqcvBD01ws9WYqJ0Oo76AlxdVHCmFI0iyEqWdHntypvwqWg4Dpt8ZZYK72AfoOvyCSh/SiftcdpmXqJE6OpvXUDOrpWHBRfEWy/zqSmBvG0Ilo9hDlCs5z59n8LfeD5jHhGe39nfYZ4i4WFjFmPiYVwAAIfkEBRkAAgAsBQAHABgAGQAAAlWEHwG5y+dgUpNVRJGhXMXZNGCWiZa4hWh5qajpbV6ZQm8Uxmwtx5ovSek0tqGLaEsGjzzlz+kEKo1LJrS5nBWv1SSNiwVfpeJyGDl9mstUdHR9JhcAACH5BAUZAAIALAIAAQAbAB8AAAJxhI+pC8EW4oNOqohn28tR7XWVpV1k+KCfNKohmmFsRnlwM252C3Fvr+vRcEEfouLb2VJFovN4WEanwF8JKMRCOVQjN4FkqLrY8feiNZO45ms5O7EG2245mkqvkvPWfEfspvUhGHgHSHYW2OYnVXgYWAAAOw==",
        );
    svg
}

fn get_nephilim_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChoSPqcsY70KUrVEJAa1Wvw9t3II52jhmGcqpIsu4sPV6cwJe4G183u67XX6l0wwj2oRgyJ7OaUzZVNNi63cCYmsK5HC5lVK/UC6uh3sNry7d02zyPbPgShNqK0un+Dv8oNZ3xoZmtFZol+YGGNWx9oj2B7g4OYcSgqnFkxex6VQTJBRaCVcAACH5BAUoAAIALAUAAQAWABwAAAJYBCKpy8APo5w0GEOhdfnt7mHgSHbcc3oJoq0lyKphXB3olN5SbiW21BMcgoIAbWFUDC9G0cLQhG6kOWGU+qFcllPc9gqtHpjcKvB3xFk2RC1tmAFvM1tAAQAh+QQFFAACACwHAAEAEQAHAAACEYSOqaHtDxuYgMUz7RV549oUACH5BAUUAAIALAgAAQARAAcAAAIRhI6poe0PE5iAxTPtFXnj+hQAIfkEBRQAAgAsBQAKABYAEwAAAkyEEYnJGweReYzOeNV500LKaaKXgeUilVYlNaFzhsorpt58pRu35SYMxLWENdepg0S+ULLjsofS+WxT6bMj492oXNoO+xlFZmQWD1AAADs=",
        );
    svg
}

fn get_nue_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPqbvhH5hsIMZ6FczsGahtXCKCh1Nh1pimqPrFsjVxr4vBrPndOcnqeBCozeTE04lqSRWNKFwBZ83GqGhrWX1I4iU4s2p/Yy9Q+o1xw7rWa7jOFXHpk5Okpufbz176mZElhUdTZ+eHdIXnVvYVBHa4Ejh0CGPXpxWXJSeTaYnohxk41Vk6avh5RclWd7PZ19o1ZlSolrRKiBN6xNvLUAAAIfkEBRQAAgAsAQABABsADgAAAkGEgxnG7b7iWa9CNPFNT3nKfCBARaWGmWY1pkf4nloWd6RFclM3Np6fUvCEQBUxt4LUfDzb7Jfp7UISUIklod4oBQAh+QQFFAACACwBAAEAHwAeAAACl4SPqavhH5hsIMZ6p34GNi9BYtaNzGWhTllh6Yas6DGTCcm1L2e7cY75bEQ0HuiUWpVkpgkwqFMqb0fWlEhpUbeWxayY/Om8GZ72+7otx1KVSsgeazsuHL3blZvzrPjcniZG9/d3NTU3iBbTt8h4d5ZXZRf0RVP0U2ZmORjFx4nIh1dVl4W20+ipJ+YmI7f09GSJR3WoUAAAIfkEBRQAAgAsAQADAB4AHAAAAo0EcnlobQGhm/FVGi/OvElUSd6zWMw5JsykmCQaOtnmrTWLz26H1/oC4th8wNVsOFT8SrKlSWNhvlinpOjWwtCgVyQJqPrCrMEwiHm5Ks1rW7ArOqPEn/BUTJGp3N420RXVs5aSpWRlBqdmdDP3JRVYlNVYRtiyeAnm+JQy97EYeGbHJ5mGuATVxBbZUwAAOw==",
        );
    svg
}

fn get_qilin_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACk4SPqcsZ8FAMEzYVrTZ0X1lZWfZh1DOhZXmibdOqy3uczkjOtVS7e17pjH6ckMNTJPZsO6TGqAN5UpzVRiaSrpi8KYjb7DiTzyJNPDYnZT4tA/0c8uBzFdsopl+9YXZ0i5RTddQVKAcBFJPnFnPzNojopjbTNuViQ2OSJmgG1vMmiOUZSckCN7pkdcOZqYrI6fpRAAAh+QQFFAACACwAAAAAHwAfAAAChISPqRC8v1poRkIUhNb1THthHgU6YTJ5Zkqd6CfFKdO64zca247vvtaqNXyVmsjB6lQ2wR+Qg3ICSSiAlFoqzjxOqglCJSqRRrDPK5KqOWuBtQ0/x9vb4lxqvxPPOn2b4TeXETjUVRj4FrgWtpHox2KkyGMheXVYeXaJKdCzmam5iQNQAAAh+QQFFAACACwAAAcAHwAYAAACSpRhFhDpv15CTVCpHMP02lVN2IF827WNDxMx6ZGE6tm8nKwKrZ730IHzCXnDYamokh2RzKZTaHv+ltIq1CqhYrfcrjS4rWi/omoBACH5BAUUAAIALAEABwAdABgAAAJJlGEWEOkPj2gCUYfis/asq0EMU00VCGpjGmXhGS6Kerlveef6zvf+D9RRWMGi8UY6PohFUrI56Sg5zJ9UWQLZeplU1zqThLmKAgA7",
        );
    svg
}

fn get_skinwalker_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACk4SPF7vpDwNoLb6KmHYsT6l1lBFi3gShqaqoIetREpfOib3iLrmh+s0BlUY1k0JYMdJ+stgvo/RBYZGncPeM0aiglS+riwLFuF6NVxV1zsimViy9dedfC/gzf13I1342fkGC12WBNzbotoV20vZRKEgl6BfYoiUl8vhXR6TI4pbn2Kl5eQVUKemEaQrJtsF00qpXAAAh+QQFFAACACwAAAEAHgAfAAACfAwcostiDRWKFIIIcpXbpvp1R6Z1pmiQZKquAZulIYO069i+x8vz18nY7Xq2HEYHQVJ+nkaseNPZdLLDCRY7mphb1I4C236GwBOpvJyhl5x1ZaR2e+LyRamOF1/hCGzWVOPzINcnNEjIJ1Q3U8hV9kGk4AgE6SNJKNGTUgAAOw==",
        );
    svg
}

fn get_titan_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChYSPFsvp/xaSsCbJAqDW6sx1IhiKUKZoZoelW7NO20vCK4epR1nBTa67UX4pnmcYJMVmJuNpF3REPTcmSzdUaK29osuFpW6lY+5F9RmHd5EsM8kuq9dwNfkVt63NbxnIzvdVVPPmdEcDtyd2otc0UdMy1QaJYjNJeHipxMJYmSlT5feUUAAAIfkEBRQAAgAsAAAAAB4AHwAAAnuEj6nLGg+bRI+GKSu8FS++XV4WiqMTAd2JqoaWnpxabuMKJ2uTRrCJ6WlesYnQYvMASUpZs7lEumgv4vRKXHZw1OohOt2ZxhTvUFf2mrlYEVm3C6ffxuxXDXbQStk8urZ3V8eQhEX4VTPkh5i4FccI+PHR+AS5pSeJUAAAOw==",
        );
    svg
}

fn get_wendigo_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoQReMud2QyUir018QlXwf5MWYWAmidGXLdR2ho50kq78Q1b3M3bVh/LBXfA2clHLJZ4SWVLpRMyZRuaFHcsWUfYp3bLDdqaWueSGS77xsl0+ZMLZdwVUYq0Psmt9eyL/WQSdrFXQ+gB9YEx18dC0Xa2c+f4+BOpsxZiRmXkRgb1eLWZchhFR3JoZ3TG2dP0uVoAACH5BAUUAAIALAEAAAAfAB8AAAKNhI+pmwHOonEQ1SrfwTbQx4GaFzbeJl4nQ37W1IArHMstFJZdPme2tqCQfDhJ0QekKYG3SE+xuj1r0IlU96pdhxkMjsPtZoPYapKF3JSX6otZhiK7WrDwWauOe+80oZRZFwRopZfC9+HXhEgYc8QYCIkyI0To5miYFUX1RUdGFOiShrdoMkXl9PXYYVAAADs=",
        );
    svg
}

fn get_banshee_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPqcsa98CLzckY8r20Ijxtmgcl4Wig5teMZ8mmUtyZ1NS5qQZy9sLbnXA/S+amQh2PxaUMtgzGONFaVOQYVq8v1WxGVIJ7OdmQGnSFzOwd7Iv5PuNm6Utel699c/x9gwUI9jT4Fkb4VghRw1JG40ZYxsjgOMlUkdQXmTaFaFiyNxh6s5JI6tgCRwl3CqX6czmmRGcV22lL6YWJS9LbUAAAIfkEBRQAAgAsAQABAB4AHQAAAmCEjxDCbZFibLSyAKHcWGX/WNYhNkuJCsClrMKZVkoKx5SXaZBduiwfa2GAtpmJiEwql8ym8+ncQY1QirSKDWYvRNBGVhNpbgdNGXUVtayxsEnYfJyLaLkb5Sul2/dKoAAAIfkEBRQAAgAsAQAEAB4AGgAAAnYEhKnLahaanOzQ+0AI0FyqcVv3VRv3jGWSog9yelN7uhoUl6M7hvUP3LEUkUQRU7ylOhyKCLWzCDQrwZNk7VCrShsKsV1Bl8dq01GuGru3tHpa5r0Zaekqg0+fL3HtcuZGFDaFIaFk9walFgg2xpeCpKMygVIAACH5BAUUAAIALAEAAQAeAB0AAAJmhH9hwq0IoQqh2cuifhTMr4XIhFlAiVqV4HlZqaBxesL1k3QceYHpmgHSUgzKg4js1TIeyi8JNUWn1GrPmhROXdhuyaAlhmnAmcO69KqzYMwYZnpjW13z+g6V26V4RxvJBZVGY1AAADs=",
        );
    svg
}

fn get_cyclops_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChISPqcsbD2ObJkxL1cs71xR1B0aRInKSDaYybKmF57eC9IteOWBtOB0z8YY+4mj2Gw2NtuXNEXIAly3Pc1flTG8tVTf5FDaZVXCqu62k1B3vbOyEZ8dzYF3JlTjv+I93pzXV1hfIIyNmFeeSeHTBB/XHxng1qAgSJeKTySJRloaFNmlVAAAh+QQFCgACACwLAAcACgAGAAACDYSPEMur7wKU0akmky4AIfkEBQoAAgAsCgAEAAwACAAAAg+EjxYB656inPS8yzCupgAAIfkEBQoAAgAsCgAEAAwACAAAAhSEg2mA6+2inC/ZExjLPO+vLBYEFAAh+QQFFAACACwLAAcACgASAAACHkSOZ7AdIKKMa9L43tImBQuG4kiW5olin+QhFAPDBQAh+QQFFAACACwMABYACAADAAACBwwMiYrh7woAOw==",
        );
    svg
}

fn get_draugr_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACgYSPqcsbD15oNEp4rawGWjQ5Iedl5ciBkbZOG7lq2OjCx1nT6V2he1cC+n6qjupFymFYv5qM5ezFXNFjj0Z9hTzN23JIDNuARl74gs6Ivei1wjfkdsts4tK4qVLaeXWzbyIHk3XSsuMUaHUlxJig97b10QcCVkTHpGPHk+eGB5VSAAAh+QQFFAACACwEAAgAFgAVAAACSJSPmRHqGEB7hs0jGdj82hNZgBMlWShxmxapoaaun3LR1CvGFi7mbnraoWoLivH4SBGRTIqSiZI1o5mmAFadtrJIrMR6dYG3BQAh+QQFFAACACwFAAIAFQAeAAACaoSPqReLraAJUAI7K200rw2G2NNd2RiJTsqVK5OM7gPD21czs9ly/H7xTYI+S6f3k4GIxJ1qGYrdnk5Tkykc9kpHq7bZsn2vM2Ex6BWjb0yaBp0jecJTCfcd/eWM3KEfPmWFYof1wrOGUgAAOw==",
        );
    svg
}

fn get_ettin_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjISPEBi9Cc9L87kI1zRXevxVoaJsmMWRGvmBasOOqfui40rbKruZmc+bwXJDCkdHjJVOwJJF03EBO7jdLOajHhmw6PWILEZEXOSXgZU0W8Yleax779aeKaUqFS/vNLXjn6VnhMe2BYJjQkg3pmao1CfUcwYZNLSYIzRJmca5KdPpGfQZakZICXgniFAAACH5BAUUAAIALAAAAAAgABoAAAJ2hBGny70BVXpwOhmPNbPeh22c9o2kOSaZsyKueqKM6Eq2DM53WmsZDdtYgL/G0NTyHWedzsWDILKS0eaQZsRoPTCUMObL1ojYKpQbgVbF4F2FCi5/SyqnDld6xex5igjex/E2GAjSlVOo18OTeBcl2JjTUqZQAAA7",
        );
    svg
}

fn get_giant_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQECgD/ACwAAAAAIAAgAEACioSPqatx4RKcEVRzn1w3MytNVsdpmJZV1NkgnroxkAs6dv2Z9N6G4szSkXSuiAhjAwZjuSXx6fFFn0iKdVo63bagprML/jauL7KMapUyfbikcnTrkshAVecqfQ97rXiWLxZGJWh0NANzxvOBhfa2thiSw5jXVjPJxJUUCKjleAlXp4gkyTn16dVUAAAh+QQFFAACACwEAAEAFAAUAAACP5SPoIrdEGIEroalQt3ian54GESBoRSZ0jKlJneNGerEMukhNlvC4/XakYK/ng8jvJGQLl+F8QpFhZ9opwkqAAAh+QQFFAACACwAAAEAHwAaAAACc4SPqcvtHk5MoVZqcb6Ayw92zCZG1mSc4XShKZt1bPq+Z4xyrozEvC+yAYWeIO1o7N1CyN6o1Ng1IQup9am4Oim1LXerknmkU7Im+qWqla72g3yLm71dLMRtguYfRH1pnvWRN5i0Rmgyw7ejUgTIRDMkVQAAIfkEBRQAAgAsAAABAB8AGgAAAnSEjxi76XpCkjCyyWQDehr6RQ/XgN9lbZy4Zu65xSEJWyQoK+aNzr6746lWLKLR0/Epi6Pmchl8HplBSrTq4dUqWeYDN9pFMeNp2euoDk3nKQzYa4rPbZqog3eHM63+0GmUJwhYNJgDOFfCRuim8VfX6BVUAAA7",
        );
    svg
}

fn get_harpy_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkoSPqctx4UCUJsK3nJbTvr1lFHV9Y8gkYEWmyDpVcYu+LcdqXq1Afvn6AV05HI7nig1lthTMc4KJQLMezQo9YVg31VV3kVZt0HLRSRqrVsRmSd3m6rTx6XFU/2F2nyV5brEDaBfVY1b1lCTlFdLId8VIM+TzZXXD10gXOSgJSRgWaITkxiQoV2eSikql2IX6elAAACH5BAUUAAIALAIABQAcABYAAAJahBGiy71xYpiuvhnRsfZA81Gcg2naNzrguQBp5SoYlLwNjeCQ3ep6zDvlhLsUcajj/WZAXm/YaHaitYeUg7DggjTGjys8gruqoFbjFIRXaUaWdO1UVYZgBlAAACH5BAUUAAIALAEAAQAeAB4AAAKKhI+pyxkWHpCNvSvj3NUdzIUVdXElaUUoWEKq97mKJlKbukIhvu+ZDqTddKwWrTg8EX8m4015ssmgE6pUSExaO8nnUDaKsYDfY8/7PaOyXdvrg1V2EUzRXB6cZ3P0H4heU+P0xyZmyNOSBpjxp2EmZVHVZ8c1tVS5wFTHhUMo2dkQBemC5+E5U1oAACH5BAUUAAIALAwADwAKAAQAAAIJhH+RusAKHYoFACH5BAUUAAIALAEAAQAeAB4AAAKKhI8QFqsJ41uN0SeloxfneG3ThzjMFJZZY1aJq8DqeYrtYdKsqFtu3olhfsIazsPpCW+2UbHU7KQ8lpcxSvtgR1MNd/gFAsNGlDMkBTvX6/R1djsGv71ul15Ey6nTSnS7d8XSRlW2tJFkeAQm46dk1ZIGM6ellEMC0XhJsjP40rm5J5N5Jxr6uVYAACH5BAUUAAIALAIABQAcABYAAAJihC2py3pvAmjUSQiCbq/pe4BVFT7SNnrnoQRp5SZRNr3cSp/2sl59AsJkgLnZL1XE9WqCGM9SzHGmDGUV6MHymDLnS0LS7VaL5K4ZNQ7HRYo39YbG4TTInE1Z28Aw/bduUAAAOw==",
        );
    svg
}

fn get_jotunn_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACj4SPmWHBCuN6Ty4LXMNHN591TCWBFXWRkKeiyIg56jfDsW2vYXyVoP+yaGafDGtUI4poMgopp/g1nyilMSqbhJSm12lpfW5SwZWznEOWxrtrh71uE606eT3+tvfw7PP+nrcjFjb39tOGBSe4MQWU5SXShBjZGPEYSFkZBWg0Jfm35ynKNTcqmnliqoq0KloAACH5BAUUAAIALAMAAAAdABsAAAJyhI+py+0PTwixAuqw1WpKb2Ach4CXFIbjApIimrJmOWskfZ53vsN+l0t4apfbxChqvYSUke14VJWCUlr0E3P6oMGra6p7fYWoZTNG3WZtqh47DSd3f3Ewj95To8cy+1LXMDPXxMVwBUPItQPlksT3EVAAADs=",
        );
    svg
}

fn get_oni_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkIQRp8uWjR6csSVJLWI3z748mOeUnElu6olm0qi8nky9sEPXMRxgN7vpCUErS0/1M12Op+FMWIyVnCGoCHKVHkZZjfeXLDI5PhcOuqWGlaI2rvVBdbvmc3u81m7heW32nzJVkRYU+LZ0tGRIyJTIFRXn9Df0+Gg0tmenCOkjQ8QmVuHomeZpJagX0UGEV0hVAAAh+QQFFAACACwAAAAAIAAgAAACkYQfp8uWDcKDNE6VbmWZx011y6OB3zk6JqI2Uwm9IbvJ1Qtb9I2VEmaSSYYilOtH4n2GLsuvxswliZxoy2M0apKxbnbXREgvORqRTP1in2wSt3Z9v+EOptMWTGXLYa5/pZKBtgRYt2T1NLMlaJgYc9YiiATiY4fFIiQGpIeUJsY4iTl3skV6h2IpQtWBg3k4UQAAIfkEBRQAAgAsAAAAAB4AIAAAAomEHafL2JGaVHClOOelAOfXceHHRN54fmZ5pBLmwqT8tm5H13bp3e0PCW4cj8pK4whacBWVMrUS8oxE0am3HGVZ2q23yROBmGDyUddMm87on5atIyOU1cy13rUTj3DkpbfhE/ZHVUaC0/V3aCXXxwH4ggUjlcZlRJlFBQQ3xLSp6Vn1FDIJRFpRAAA7",
        );
    svg
}

fn get_pegasus_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACh4SPocjtt0xIYM53YZWP5Q5qnGZh1Vem36ZeK7uJIfZK9UzFZGhl0ZlzoIawxMrl85RMwBSPpbjRZlKcbvez7ihL7SIb7CBrUbAwFnEZy+f2V/hCXtW9U9TYQMG+bI6vi2V35wd1piLj0fRUhTfypIV3w/iYZ+bV6ASpQzTJdASkqVapKThTAAAh+QQFFAACACwAAAAAIAAgAAAChoSPqcsa32IM5tFl5aGwXpB5EieCFfM5YEqSq9UlKXJBMy3TbKvG52ranGocn04odGFuuaQpE/rAbDKlQ1q98V7UIAz1bEqNvSdWxZ2YfzqWmsjEaOKjuUZevzeDe/2GXOKHs0SXl1MkiFSyJXg2xNfIZlP4hmMVyTeZ+LMD6ad5tJk2iFAAADs=",
        );
    svg
}

fn get_rakshasa_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/yIgNAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjoSPGJGwDaNhico7z8tY2rU5k+Up4LkxJLRyzidibaZqddnNs+u1d7MThUy6COVz/FWAShtPAYQ2gytfTBWMaZ6d5fa6zUJdqcfwYv6KSyCytHt6wroV61gmTp7prLaWHxUIeOc2KJfj5/dHFFLThlL3mPby8ihUWWkWJ+RImdYJipU5IolVWib3eVmlUAAAIfkEBRQAAwAsAgAAAB0AGwAAAmqEjxFoyg/bW7HKRkG2+mTlXOHEgCYobQn0fR1bLbI3k9xb2tbo4T7Jo21UqxbGRzwSQ6rk8AddAjvBS896u1opriRt+0JVeyhwFsN8krNjF8erxerO47PGJLdH4O9V/qYGIXCXxhWDZ1AAADs=",
        );
    svg
}

fn get_roc_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACeYSPqRkWvcBjTkJ6bpT7zgo2Iic+GnIqZhdBp7e1bqrGlh3TLr63YB76cWofx4SG+2mWvkWPlTTWMChmpmgbKaPcbhTGE1KR4yHKK8TqnhbsmWd1c8FvZIptejWr4mmX7Rf29zY2kxEkhUFX1DMCRga1BIjmBEmJUAAAIfkEBRQAAgAsAAAAACAAHgAAAnSEj6kYFr2iBJBO9Wg9cF8LYs7HPR5DlmiGJqephm3MsGLl5fXNXXa/gPlwmVMKlDN+GjjaRDdyMIESpdLpykarT2n0uk11uscvmdQBy4LjI7T1C5bS1FjT+g5NmXehtunFs/ESx9WmUcaDGJbIVtgIGQlQAAA7",
        );
    svg
}

fn get_vampire_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkYSPqbsR8CBD8Tl246nJ6ulYGHRNlKl8jZQaqsua3BqnapjB+P1S/fajoTogHQkjmhE1pVlJEoRtWKLp8FRNyphPqpLEBe60UNf4Ch5Hi9f1CV0jSuGx2zFOyy27/E8IX3aUBcXx49GCpzdS90bVZnXHCMeFA0nHNOe2w1g4teljhgn5F+nnB2RJSqimuMoKUAAAIfkEBRQAAgAsDAAXAAgACAAAAg+Ej2EKHN7SeW8hey1VoQAAIfkEBRQAAgAsCwAVAAoABwAAAg8MjmcQ7ckUWjC2dOertQAAIfkEBRQAAgAsCAAHABAABgAAAhFUhKl46xtAe0YiQG/eYb4OFAAh+QQFFAACACwIAAcAEAAGAAACEYSPaaHK8NphNKZAEdbWLVUAACH5BAUUAAIALAgABwAQABUAAAIsRICpGOIPoztnKeqAhHr7FzRf+JXmiabqyqpMCCMbxRilclbi98rjZYLtHgUAOw==",
        );
    svg
}

fn get_weretiger_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACl4SPqcsQ9kJ0Uzq4pD0zdahxlPiM5tdkJbKl1xpyKwVf5NuVOvuKp83IzRoxja7l8hw3SGKv5nsCcTYm72fZVaKeGwoT2fmayi7GPM1IXduhmp1UI7NxxdZbN52OslQRDFhFVtVHw3c2NFPhRqdYWCOmNQYTNnZFqXc3MsfYE0RjN2iHVejpxKL55HaV+QniVLlKkppXWwAAIfkEBRQAAgAsAQABAB4AHgAAAouEj6nLEJ0eRKGaal2eVNMncVF4bOLlpGVKihkmmdD2xqHcsaAH7uoYQwWDmtbO9/sdk0Reh4YSlmiY6U1FOtouy1UP2wQLe00fEbmFPRXIYvrKjPKWptZqqlN/2EZ9TseV5CIYMUi3Zve0hcfI5hH45YQTeEcIN/KXqLRAhsUwJKNFqMiC+Ph5CFAAADs=",
        );
    svg
}

fn get_werewolf_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkYSPqcsWsZ5Ms4HqrkbyWdiB2RF6jUluZPmdaNhyUCrPkZ3ZIs5gI6U6aXguy6U0wZlQveGQJ/oZOatN9OPBzKDMGzTo6E6PKS5RgTxerz3YFvRtJ8npXIQM7uBpVHZVxwJ0pocWdvdGqKR2JmglQ+dTuFOTFNnItWcpGUQYJjZmiPY5pqlZZAkH+iQ2qepqUAAAIfkEBRQAAgAsAQAAABMAHAAAAkOEHaca4g8jBNLRirNIuvsPak1IltFlikAStN7aHp+clmitrfck6Q6LqOw2C9fjAFw8Eotm65l7PoOgVWmkAoKA2EgBACH5BAUUAAIALAIAAAAdAB8AAAKHhI8Zyb3+VIiMmmXB3E1TrCHbWHnc840TpIQS53SmuMa06MpeG4E6fMiEfLycbgdR1VIX4fBZC+acth3KWAReaU7gBTs7BntYL1c1IxObaNQJx7uuSNE1aB32flyW+RiNk0Ii5fYzWKgkczel5BezmDZnduam5ygW9hIlNvl3JLlJSDU0mFUAADs=",
        );
    svg
}

fn get_wyvern_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoSPqcvtFsKL8kFaF86MAqx5X+dJJvdFCbdBo4nAbtmu73ycl9iNPl5LqRTDmPC0CeZstVbS9lOhkLciy5cppoCoHM+qxTFlrK7XDGI6wlgLTxhy67wWEh1ej8fYUM12V2c2o7QmCJR3hJjHd6c4tyLj6LL3o4jlZNkTmcnZ6fmpUAAAIfkEBRQAAgAsAQABAB4AHgAAAoWEHRnHre2ASvBMCtdC2GnZWZuYfdqIVCBDjWckxR8Ypqglt1dV5891Y0V0QM7NRfopdzHhplMs8ibOlcyKa7FcGFOQiiMNUU+huBRslkRHcvq6gvZU2/OcbkPj6bXHnmf186dyIsi3Z6LGd3f1huZ3+Of3NTNYWeeYEWakOLhFlel5WVEAACH5BAUUAAIALAEAAAAdAB8AAAKFhI+pFrEN14vIWSoBxLa23F2Mo3zJF2oqSI5qK55aN2NHer/XJpn3BrTJPLpgrcT4zWooYC5HMhmNE44uGYPSlqPo9UTxcSvjFcos9qRXZBhn3eo1lXQQO7rO1Lv6HjcSZ9fGEyjY9tJHJFOY6ITEWKUH6cd4lpjE5jJJiYd5WUL4aTdZAAA7",
        );
    svg
}

fn get_berserker_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACeYSPqcsY9x6IsCWJp6G6284FWfZhnBKRjeSpLGuJ73TKn6eFuVPatGMS3Xi603CjqvyOFxQzxnuuTNLVD1aFwIRZ5Oa7lKa812pKhjYOX1wf7paMYkve4pte+6rxu9EdSsG28yQ0kzNHCNSl1LJIBObYFFlhOMl4UwAAIfkEBRQAAgAsBAABABgAHwAAAmCEA6LLDGhenLSeihYMS85thR50SUhwjliUgmnpmk8re5+iKuQno7vfs3B0B03I1TCCRLti8umIQKfGBxWaEKBw1673Cw6Lx+SyuZslU8ZD3bgShlnFojqr1rTr96ZqpQAAIfkEBRQAAgAsAgAAABwAIAAAAnyEYwmI6/qOVI3CVivc/Ok4faJ3kSNYYhiarAvjBDDjwtEs2eQmx6/f4wRzJtDwQtPIaB2eD9g8rI5Sz6dzvUZLre02SPWmdOJWrVpm/n5a4WsJJzcz4GHbwgp5VU65G9fl13dDdBdICPWVWCgWlmOI9VjGtTMZCRkl2FEAADs=",
        );
    svg
}

fn get_direwolf_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChYSPqcvt34KcAVT4qLQbo2tQh+hNoxmSGZp2HMto4CI7ml3HN74rPQ87qYIV2azlCllGrx/yyDk1g1PlR5j7oKAJI1SVmX6JsafPNAOpzee19aXlws/hZdelLqal7SvbzuTzlnfUIbe0RxMIcfH15hEF6Ab5WLRIWZmIaee42bV4GJYYWgAAIfkEBRQAAgAsGQAUAAYABgAAAgpEApmoe+wUPKkAACH5BAUUAAIALBIAFAANAAgAAAIUhH9hwair2AMTtvTi3Mj1X3nUdxQAIfkEBRQAAgAsEgAUAA0ACAAAAhSEbxGnuPBgS0xN5hDctMf5aWIkFgAh+QQFFAACACwFAAIAEwAeAAACXIQRgal731hbCRp5JEN5X61E3qc9JglOJ1WuXeu+m0pB5RSuM07b1WWKfGIZoINYPJ5ooiSnqBrhnMvek1P5XbWs6cvifVqDLqbRct2i02evNZp+d8jLNjXpNhQAACH5BAUUAAIALBkAFAAGAAYAAAIIBGKYaqvMWisAOw==",
        );
    svg
}

fn get_ent_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACpIwDBnvMiF5qMyZ3V970wqo5FvhZ0FEqDYpOYelVquiNtN1paSgq/PZq2Vw6X3HU+iF/PBzz83oqgc1gzIhhZoY5XXbKxXqH1WayrI1JrON0scZyibWzzupErd7jQnJPxsLn9wazUiNHd6WIhwd2Yvh4l4eYInTlZ3K56PWUuQOzZjbpdqjXJkPzd1S2RDWXqeYDZdL6FQlUa+QJosbRyHEK61sAACH5BAUUAAIALAAAAAAgACAAAAJ9BIQCkSeMnFkuLphyMxjr4GmPSIpViaYKp7bfFLpoLNd2S9/tKQaLOgn+ZiqfkKJL+IxHHgIELTVhJCbr5nxAc4/pMNNMmo5SSnBJEqaswTTTV2JTxRF68ZzFHrk2vthvFyhDAVhzUVglxzFhAyPnZ3B39paW9XY51+cIUAAAOw==",
        );
    svg
}

fn get_fenrir_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACfYSPqcvtD6OctLKQsFVBg75dINZ5W1kiJjVqJli55JdZpMvFtLHK8ZzjwR6rQ9E4DAJpRyTk2EQWocSa1bhrJF/ZJFb18XCvN3IWC5Qtz2te+C3uvpqplJANXsC8vrvW/fYlhHKBJxiUAaUmkngWaKdXwwdZ6KXXloMZ0lAAACH5BAUUAAIALAEABQAcABYAAAJVhI+pG9gLVXhgxutsmxRn3nWe9oRiVG5VckJbKXkrJaayxhwc6qKWY1AFV75e7LIjsjC1IbCVWdJazZ8TOLReQzPnjqt74qZTpO0ZPZ69JnT4rQMBCgAh+QQFFAACACwBAAUAHgATAAACQIwuhsvdeqCbDICAQaQcQaV1lBFakuiE0YVOLHKp7RLEWj2nG547tSbreYLCovEoICITyeVDKSydjDie8+ek1QoAIfkEBRQAAgAsAQAFAB4AEwAAAk2UDXHL7Q9jDEraBdLdiPKbVd9ILkEolkeSJV55trKbWmc8t1QOPDov2wUdOGCRgiuylDnh76ZDWFwM1qwGCVWhMU7I+q1gI9+ZCpEpAAA7",
        );
    svg
}

fn get_ghoul_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkISPmWGsDxubMyqHXNj8WlgB4Udu4hlh5WmSoNZkqsu1EutmbKfbnhwLongfk6ZFnKWGMdhB+QglVb4l5opq0haURdYChX7Bl6pIXH4esb4aUNqZXbG37rnmPHtHuyDyxuRkJ2Gkdsf01sPll6LE9zcGtCeZJyMmJ5d2SZWpE/m0NyjUuOQnGppzGBaX2mpQAAAh+QQFFAACACwJAAAAFgAfAAACaoSPqathzlJwlCIo39yxAWh1l4WJ3/OVy3SiB9tw4wm/tPxWs9u2NYuRCS89kM92ywWDyQyqZFzpckhnBlbTqIhAakpFempDVOhtgxXb0qnOdCzqruNZdaROu+N5EnnMw7eTtLcG5dcHVAAAIfkEBRQAAgAsCQABABYAHgAAAmiEjxC26bxiTA21gPPbU/ntYF4FWiP5iB+pUhl7Kej0WmIrM0fF26uq2QljI92OdmnhkJRh8+PK+Yw21AkyXepuxteseIR0oOOrt3TtWqO8YAmXBsHBHGs5dIemqNPQmxU2F1elJ8NVAAA7",
        );
    svg
}

fn get_goblin_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqct9EVyDMFVwDY1Tx/xQmoQ948mVpPqV7ZeuIgPG5OsiuOxx8c7TWXKrk8oCcswqyaPSh6zdhsajTeFLtVDVxVYLDSutXCjmanJKQ12TbcPUNXtvKvZuJp+RXuIItmUn9JMD1DYB6FJXBMMyc9iHY4gWRFPkwSd481ZHGeW1JvEC5ndpqlAAACH5BAUUAAIALAMAAgAbAB0AAAJRhIWpy+YWmFQBzIuz3lzZPn2CCJbmmVQqmgbV42hkGGUVBrx4Pjf19Lr5cprgjEcsQl6OFccFabp+m2kTSZVhedkik3tKssbksvkM4pWd5FcBACH5BAUUAAIALAMAAgAbAB0AAAJSBCKpyx0GX5vr0Iuz3nyhTn2CCJbmqRyBhCYHBFsZGQKaXOPTo+/29eolHixMkMYrGlcG3kuZUTlXTFDk2fxxmFjo7fg6eVvksvmM1hDNYbahAAAh+QQFFAACACwDAAUAGwAaAAACSJSPErfpDyGINE1zq968xwCAjZcEJoCmKCmN7BGur+V+GRLXDxjTqL778VKizikmNHlMQ9HP84sWl8PcKzTLarfcLre3nYZRBQA7",
        );
    svg
}

fn get_golem_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoSPqcvtD0GYM7pg8MHaJqpUXphx5oh0n4RuTCVC8KtxjwjXaRmv6SmxBUuk3RAHQvpcKpeR9Qw2nb8pUrh0qmpCK1T77Mwyw42OOjZ1k1+ytI0Gf2LT9tiOFtcp2K/4XXZEBYVDdrXVQ2TTpLMVwXUmxXZT9cdTV6SYCHLByXl5t+CY6PeZFeV2asZHCmraAlEAACH5BAUUAAIALAIAAgAcAB0AAAKChI+pyxn/mgyGHmqli1svG4WZB4wIRl6M2EDlCr5KxspV5aonBqJlfzvhfrhayGETKl+j3GzGiR6fSCIxhjQBg1cVZ2jtMqcQlM9l4tKCzrTWF6bx4Bf0WsYr5rZH7a0pxQRmU6ZDxWZY+JHlVPTxFbeTpDa3IwKZxmW49FPWqOdZAAAh+QQFFAACACwBAAMAHwAcAAACiISPF7vp7wKQylCI5607Rw2G3vdIzAh2SGOqCtWUFxOvCW3ZdT3dr2Xq7Wa+GcxXEb5cvdupKWSVSEpOrogErmDBHO9r7LbEpzFwN71Cocd1UttiJ4cy4jVmFrFw23Zc8zXSNbfGZAOoRiOVscHH9sS4hdjH+AQJWIbRKPLmeEj19tmnCKH4VAAAIfkEBRQAAgAsCwACAAwACwAAAhyEg2gb0HzcW642peSkdtPMHVO2XZJYoWTiRUYBADs=",
        );
    svg
}

fn get_hippogriff_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoSPqcutYWCT7kUXsqYM+lwdG4iQ4jKiHCWZZ5ResgdoDye2sqVur14KsXTAXcVWSypZoV+Spow2QUCotPmk4a62GLT4gllhSzKvNkbNEqt0B12OUrFM8Jw92Q6NV2Gu7xO25vSXcxc3iKRy4kLYd0EEFxSpxif19QjJhjTmJiinydix9SRqWvKB0ybXOYn16lAAACH5BAUUAAIALAAAAQAgAB4AAAKJhI+py80Bo5sGVhQDbbbq72RWB2jXqUiJyaarWmZni2FmfM8luqekvKPdcjVgLNgbbnA6JG/SGvVqS2nStTwmic+XBHSlHr7cIpjGLGOdOWuVOwRTiOij2uOu29tMz1hrM+W3cvXB16amhPcVBLNgKCYFcmdDojO5wVKGSTlGyZkFhdT5lhaaUAAAOw==",
        );
    svg
}

fn get_jaguar_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqasRDKN5gEKH7Z3MNVlxiTaCj+ZV6bGSnAWz3/mpMUKmbsjLEbWj1VgZ0QgDOgaNPmaztCGiVk5TL4RK4qgq3PAHre4WGW4sF2XeslAd+9QaS71GtO/cZD/Rt3rJjdRiQ0fXN4VFeNe3hSgmNeYhJFKmhZhFI4RZ6ZfZqFWkabnZFRo6qlUAACH5BAUUAAIALAEAAQAeABoAAAJxBBKmy+15nEEUyhkb0hdb9TGhiIHdJkHWipKtebSsqJLlneKe9lX1Mzq9QMPe45hZ9F4UW8dkXD1pIdkUCUtmhZUtLvjN/rQllDWSUIGJUg9TeUvHt1VXmJxWN80xo1I+NyHX5kJIhOaV0cWDGLcoUQAAIfkEBRQAAgAsAgABABwAHAAAAnSEY6nLjNhihNCFeyV4La/qbOFEiglokdXqfRtItexHnfYt1Tb6KpgHw2gssIOGZ7qhlq2XrrTziZC5Zo86XCZxxx/HxQUbV8YeGPjlkLtfU7OYfKy3ZO2b2/Y69+HMXD4VNjZ3FXfy48SjphRY01YV5bhRAAAh+QQFFAACACwCAAEAHAAcAAACdkSAqct711CYNJrbJoNb9sg5WBJupTdyVaeRUpuWbQjRFmqfsEHVzn57yYC2j2t0FCpWyOBjeTndmK9mMOnRXXk9azEDVaG8VR7mWZMuNWJqsS0eN2XmI33Wrbh/KRe7zxJX9SSHQ2VGGHPIgoQWlWUFBunzUAAAIfkEBRQAAgAsAQABAB0AHQAAAnuEj6lrEQzhA5O5W9fMxymePCDYSQ1CdinFno33UdwGt3K4he5u8eyYweRQl8in5lrZULGls6iqKGdLkc8IVV2NviGTK/SWxpqvNDl6qVvWcwTqRgZ3bfL8RLXamVLMTSSHYxNXt6VnUTjoh/UzVldz+HYG6BEpUaRXVwAAIfkEBRQAAgAsCQAGABQADQAAAh6UH3lrwQaiewLMJym+WoMOhhQnHlaJoepDrm7VigUAOw==",
        );
    svg
}

fn get_kappa_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqcsW+ECcsMFAZcbRpseFoPdhDjOZ5Nl90qqArdnCp8MdtT26O9wJ6WwujfBFvMR+QKaKqBLlNLyb1AocLoIrrpSmbXA9YxTL0mMiX1/R2ql7bp+/YM9ML7Jx7fON5YUX97YWthWDdHfRh0hxN7UUGEjF54bjh5hZR5YIaeQoNqI2JJNkClAAACH5BAUUAAIALAEAAAAeAB4AAAKBhB0HuejHlAyR0bei3Jd6n23ihU2QJoYoFKZjiySry8ZkQ7+rnL921eP8SLPe7RTkFI9GywcEo1mGU5xLs1QUMbJnp+azXsFa1rYBNDm8XiuqAk19wE60FF3lPdhQIO8tVgb4pSYn9PXGN2iXKLdomNEWeAUYyCRUOLmlF3cypVEAACH5BAUUAAIALAEAAAAeABoAAAJOhB+iyy1xogSurjmT3RCfvVHgSJbmiaaBloZiW0XwTNeXZN85s7ZQC+hIfrDgEIESKpEqhAGyMqCeUKMQ+AxWa9Yu61TtLL7Jm6zo4R4KACH5BAUUAAIALAEAAAAeABoAAAJVhB0gy+0C0pknvMskpbjDPVneJY7m2W2oF7TuioEKjLU0+976zj9u3lvYgg3DLXLTbEo0ZeUAe1Ikx8jUqENII0xTS5oYJsNWTbVcmh0z5O6qXe6RCwA7",
        );
    svg
}

fn get_nemeanlion_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACjoSPqasR8J6JUCK6HJx69+NoYlZFYWlaFcO2DPWNaoJdtjo3mWSNoA/auIbEoo7UwQAvtZ/r9BJ6UNTmsTFLBq9YjhfH6U2mxqC1jE6r19hUifVhOr30bc5kc+bG4B6eGiUmNsYXcifV1Le3grPkEcc1Z8gDRgM3pZSnGUUIdJZV9xfmJwTD82bWeMaWUAAAIfkEBRQAAgAsAQAGAB8AEwAAAl+EEYG553+UYxI1iFlLlF8cLV4YjaCkpB9lgYaaovFrZq121hDc9pV68gFHM07l5espZyUWymIU8TLAy/F23T00RpkLuQ1PvkoS1Awe27o3tDutPmazSF6ns6Wn9fBXAQA7",
        );
    svg
}

fn get_satori_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACjISPqZvh79BTgcmI22zUrvp91TiBHhMBJlR2KmgaLHTEXB26N5qOp4chzX4i2yq1o/SEr03S11xFbZJqiNrUqbRJHHer+VqwxDHJWwaDh+RTcFNi/VowGRLdkXqdF+Or9saHFxOXYYeFKFdFkyPTB0NzZ+WoEQmIglcmScmZOdmFiEYW2tXpaWpKRVYAACH5BAUUAAIALAAAAQAgAB8AAAKIhI+pyxgNWZjmvYirvYBnZ3VT+B3cNY5daW5iSrHaG6uwt9yxhq+Q7UPtTC+FytHq+YqrE5KZwAkrydTyidzZYJJcbaPrGik3mvKapFWHxGiYd8w9y2/xVWclGdtrK3+PZqYnInY2CNKDIjMDePZjlxhh+Ef1CFgZ1TBJiXknlwn6GcppGJlQAAA7",
        );
    svg
}

fn get_sprite_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACeoSPqcsZEJ57silqKszbeql5SHiADFmimQqx3aW67WLCH81d4svnvhVxzELBHfHXu20omJpx2GliRJopp7or/ZxZXLLrlXVBXPAqRzb7mC+x8ApHAtEj+tPudNemfLmurLVEFYUX14Blx+OSFlgFOKGTVHSCggipZlYAACH5BAUUAAIALAIABQAcABoAAAJXhCWBy40qgJu0Lmkrzrz7D4biSJbmiaYk5ATGC8dG4FIALcs4d7v5/WJNfEBdzBIjBmcen7LohDFm1GI1WoVhiU+fzUpV4jaTmbg31pIv5vTvpXn/eK8CACH5BAUUAAIALAEABAAeABsAAAJWhB+iyy1xYlTJ2Qqs3tzVvnzgSJbmiabqyrbuC8OB6EGSNOcGZ+Qz8sNxbBFfg8jrHWkMJmUDIQIzFkCwiGgKG8rQ7XoL96RiarJ8I6HXzsVa3FbFNQUAIfkEBRQAAgAsAQAFAB4AGgAAAlaEESKg7c9EerTa6yLOu/sPhuJIluaJpuo6GtgBx3IwWbSMI4F7GbcM8WF2vEaRooH0YMSmzQcFGhHIAzETa0aZ1iixy+x8t2Pa50em1SqImbrFmuYOBQA7",
        );
    svg
}

fn get_wraith_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODdhIAAgAIAAAAAAAAD/ACH/C05FVFNDQVBFMi4wAwEAAAAh+QQIFAAAACwAAAAAIAAgAAACi4SPqcvtn0JY80hojawaTK6BEPhlJCJ2VemxDfetp5h6aOuQdGfL4X2xmXCrXw/3yggvMR6GVYouc8WTs/qKFlXYWgwWcu0sUnEkohWqjlBwCwpkI2dwhe/nluaIayXGLqf2EEThNLhU0zcyNyPIoMekpre3VeaYlIh1WVgYmfgIunno8vdUeoqKUAAAIfkECBQAAAAsAAAAACAAIAAAAoyEj6nLGQ2eg6/KiLMJt/XLad0GkWG1oSQVgYj0lVjIgHB63PCeZ3Rv8eFEP4XthTppSrqZs+gxvXpDZtLWlCFX0yzlxu0uJ6qkcOswK6/E9mjFyfKcY6AaaAJ7lFLqu9YSIwM1dQZIQ6g3OMTXUkcm8jSjEuXC+Ai5cGQWxQSn9afF0igKSlWKmgpQAAAh+QQIFAAAACwAAAAAIAAgAAACjoSPqcut4RaUaUY0gz4ZQGs1m9F9nIdSVWp67Qm78kym9bqOKheCdQbk3XqoTWfW0oVsRyPycioVpzaJNOajYkimkc+r3WqyYyaOO30tl9RX+k1jPaNvMMvJHoLcHzejL9dUlPcHVwWlQohYqGjl4CdyRwHJeERHeYnWFfYoV2e4sxV4OFnJGUnqubjaUAAAOw==",
        );
    svg
}

fn get_yeti_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoSPqcsNAaGbKVpKI5K48d15gTGWIfMd46lYLttq5Aq7ttzdOu7sPo26bFIPXuVViRFVNoxQ+exFZzdSsjjFaozD0rKKo22n4J/XONb61EdOlSpDX5DtM5CdZdrr54mEPLd0pAWF5bd3RSilCGIlOMTY2Kcy6LbgxkX1QCkCOGcFUAAAIfkEBRQAAgAsAgAAABwAIAAAAnyEf6GL7b5ieBTFpGpldurHTKL3NRxWQtKVdtzarvJJzTap3jPIYjjQM8BMud/wI3HRNr1kRkjMsGBPHvAiu5K20pEWq3uGnOGuedwkm69fI/gsDPpGZ/rP9W1rkXb9UpWnxsfWRje4lbfHBAXUCBXE5fGSoKd0x1iWhFAAADs=",
        );
    svg
}

fn get_bear_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACfYSPqcsQGJ4zMsKm5N346E41zxhO1YSSX2KhrLd25DaD1Ne2txxpVV9yADOmXcqowsRORJurGIqBpC9nUGaV6jgiE3VXc263Sktt7PPioOf0KdwV5qzXZ/3rYejWYviPXsLEJVY1OKVUZzOXgbfQmEcYedi0pKiydAmoeVAAACH5BAUUAAIALAIAAQAcABoAAAJjhI+pyxaBXpsQPGmnvbE6v2Ec5JFOdpIjan5Ha0qweIZpFr8ffYNKBXRRIihiwlc7Jo0L5EYH/TGZGEbVB3Q2S8WWhrUMD5XTBlb6LZrT2lpbecaln+rXO6q518fWubgsBFgAACH5BAUUAAIALAsAAQAKAAkAAAIURAJpiHvJGmwMmjvVw7Tvb12SBhQAIfkEBRQAAgAsAgACABwAGQAAAmMEgmFnqdxSVHShdR6jskJtNSK3jZbmVSr0ieyKYVc2z7EcP7ob5jjI6/luO+JNKEPhjiAgz8ZULqHHU0jprBadWa1xWUWyxOEuODz+mn3A3ToZtKLj5Xm6jn4PvXb6Hv61UAAAOw==",
        );
    svg
}

fn get_bigfoot_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACiQyMpwnt35JU8ISLqzPaIpxFFMSNYvmV4jOdlfqanedd883WcMcs/gT8CXu4zfAGsuVcyKQyhgPpbDtNcnMlFa3G56zlc8FQx6D5WJYh0+DiecwKac88anREnHqXaqyzutJklwEomBKSJ6in5Yanw7iVc1goJtOTaMTUNSckGbZZGVQZylb6xlYAACH5BAUUAAIALAAAAAAgAB0AAAJ8RIx3wJ2tXpzIQYlptFxnzFne8jgkc6KfeZnBe3lh+NZbVc7uzaopbYP1QLNgbajrGE+kX3GZciYNsOB0elRUr8+qVYr1HnFcSNaWK6PETfX6PFa5N1a5Wym8dxJx0dwM5ud0k9eCJBhTBjay4kOGQzHE9OjoyJj2wXhTAAAh+QQFFAACACwAAAAAIAAeAAACfQwMl2rN7xaC1Nkl872JY+xFX/d0kziNoEKWGtuS6TGvYIDHp5rdeK5C1GASDy/4+SmHxx5tCWxKoVHpUfmsWoO55fbaxX55Ye949Msyz+n2Gf2kvFfd2LxCvJeGazKjn9QkAncXoifzYqMoCLOzk7fxYsQSWYkX4Xip2VAAACH5BAUUAAIALAAAAAAgAB4AAAKBRIx3wKwJn4TNxTtztVX7tmwghlhhKG5fl46s1qbBvJwjGhv0LNp4SyuxTELZLujK9Y5I4S/G5A2VKt6RmgsqrFig9fqkanecbuerLZp1W9/agUaFswny9A2X4lV16Rx7oqf00OMkCATlpJaI+DFxo+aGYwNZKElCAel4odm5KVEAADs=",
        );
    svg
}

fn get_fairy_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACgYSPqavBfqAJTrJFEZS2awtU4Xhp0XSOYpk+KOk1YMZNM0tGIM6r/X6zhXYJ4gvmaxWNvpXykTlGbdNjSrT5VXWmnvf7A1M/Hmb3FKtsG5iijsKMd2PtSy2de7rhQ7d9neOUx1LWl2XExxVFBMSGRDcYdJhUUlM3KLZlxgMp5rlQAAAh+QQFFAACACwCAAEAHQAeAAACdISPqcsaDYNc70FkgZ2m3p5wmXdlx6hpXGOeoAqz1KtKbTinHcnc+oaJzIA8GS5l8oVaJCCth7LFkJ8o1fXRaYvKJQiFFb4qvO50lLx6dzGm9PjF+phB4okepjbF2rbeuOXiYbaE15e1dojIxrgYlOfY41gAACH5BAUUAAIALAQAAgAbAB0AAAJohI+By73qIggwTflMvWrLSh1diF2aOY0liKaUx2xdMmMsK9p0XusnJFtZgCdL4xYi8RykWS/3KXIykaTUA3MNU6gsVhRsSbnNx7OL5oJjvyJuvHZOqczpGV7HlzTvvVHvF+Y3SFi4UAAAIfkEBRQAAgAsBAABABoAHAAAAmuEjxDJGd/WamgqA/Gl+2QrcZZHShkzkht0VpGGPa3qwEqIvqub59OYoqlwttQM9yuhQDdTjcIMGTm3YufaS9qwPI2T6TiBgJdfi6X1fMId85O8g3tr0q2LnKyLZPcylQr2FxYoKDRTKCdYAAA7",
        );
    svg
}

fn get_gnome_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACdISPqcvtDwOcStIb8qXZbtdpXxN6YxWeSymqBtu5MgizrmThc6y1Y18zRVq1l48hNKYSSUQTYKuQTJ4l9Wm9OpVNnRF08EpfUCw0TFKebbgcWHcsk5/bNbAsxpxX9Ec/PhRWgrZRBbfXt0KGR5jIJLfIxVAAACH5BAUUAAIALAIAAgAZAB4AAAJmhI+pyxAN04sxWArtxEpfLnlgqI2HV46oaLbnCnPPNKvXvVUz/DE9b8ghhA7UUEgssoYnyeuDDOam05eSlmxea9YFt7a5OZjcsbmEwwXXa3BPWTRrwfEdJivVHd94ufiXwZYCdVAAACH5BAUUAAIALAIAAgAZAB4AAAJihI8Wwu0Po5wtWIqztlz7D2LcmJTliJrqyiboy7VHcMpIbAHLR8N5m5voaKbfLHV0AUCK2YpUrEiGS8gOumsYIilaSAcm6phe6WN0fowFVe2Bq+Rm3SZIKYSnvPLqOb/tUAAAOw==",
        );
    svg
}

fn get_kelpie_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqcsYDdsD05lQ45nY0qt5D0dlIYiNXWZqXZKWp7e871m1d8vkoBPjwWqKEQ4mNIZ8khmHaVK5oj/g7HNRKrEuVNa67cl8W6PwA918zxsWt/Rky7zF1a2IDddTMSDpPbf290WnBshXZcHmZoYHOJQltXdXs4JGFVinaNi2+IP4eAWXJ+pUKloAACH5BAUUAAIALAIAAAAeACAAAAKIhG8RyO23FkzqPVkBtnxHzVlRpXxgyGTIhqZNCaqodFJ1S9OQF+rTbuqkfLFWjfib2ZCJZoepC/ZW1NEsmjwxnRoT9iNrwo6s4q3rEmOsFyo6yU47ieOSb6y92PG2vIgkVbUSRlHmVnZXFNhlqALINbQzqCh05pLzd+fotyUH9tPpCUlo5MZQAAA7",
        );
    svg
}

fn get_leprechaun_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACVYSPqcvtD6OctNqLs66hh418hwiSgKl5Hsgu6otacSx3xrrNLLzbp58RqW7B08/2oUWSzJ/xknxGlUskkyoBOnMKbBbmXd6EpTGRSw4/yNJU1KhdFAAAIfkEBRQAAgAsCgAIAAwAFgAAAjGEjwnBoYtckoae1p5euF9lOZIYgZMXMZVarSwpZjFHqzYEwXZMsWs5SXVCP1yLhisAADs=",
        );
    svg
}

fn get_mantis_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACloSPqcsWkSCQEr0aJ3ZPdecdH3dZmWlt3oapHEi5bTO+C9WI0O6CYmhiAWmdCs+Ii3wuzGYsqVsWmZqd5laaZX9XKwl6nPiuypqR22LVdGJYOSX7eZUp2rDOvlXn8P6K/pdHl4blF4QHKIjysrY2hqjoSPIW2fNY9YWU8+i4tMkwF/aJFdb0qdZIBWqDOUNWSGjWZTlRAAAh+QQFFAACACwBAAkAHAAUAAACRpSPqQiQ7ZYUkcG5QHgxVExtzxGIoKZU5rkajVC2k/zCMkgiNy7tPMX49YTEYgZmTCE3vhMSWSM6Vh7jNFEqam7NRbPLKwAAIfkEBRQAAgAsAgABAB4AHwAAAmKEL6nLeg9BmynagANdIAfbHRiILB+kbRy2GWlzvduJfow8SbN6PzhPsQGHxKLJCAwhl0zF59eMSqc5hw66ZAl0Sy61pf2OvuRtA8vrjAxlQVgKoYZcHi8yQxVO0EerC8ZTAAAh+QQFFAACACwBAAkAHAAUAAACRpSPqRiR7ZYUkcG5AngRVExtzwGIoKZU5rkajVC2k/zCMkgiNy7tPMX49YTEYgZmTCE3vhMSWSM6Vh7jNFEqam7NRbPLKwAAOw==",
        );
    svg
}

fn get_ogre_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPacF6HJxcAMYF65T3NdRtYPhFmah0lqmhqclqn5vMakg/4J6ftd6zvCi01QxYvJyOSlGmAauUXMufEOfAyrJa3o6FbaY4wiEnV+v6UCQt0znK/rxEDO6exlNIo7Z0DoVU51OlowI4IbaFpHb2x4jW99XyyAW5GMjm0QJG2QME1qVJ2Rlpd1AAACH5BAUUAAIALAQABwAZABEAAAJBhI+Zoe3HTHShSmSfrHlpwIXKNEbchjWnxbCZCb2eCINfmaq2Ws82idqVTjziTQgCIpck4yUGnLRyqM6zg832bAUAOw==",
        );
    svg
}

fn get_orc_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkYSPGQGrjpZkx8HGJk0VbzoZ1sWVonSGJbqmYqW1Iwaj6rp5Hpub+D3zsWqjIYhIcmWKJlsq+bxxlkmSpteZDXfYlq8R/QpjO3FzyzVPdc40cUoNgmll7JUHybfhdPMeD4iW9bL0YAM1eMH0drZ1BUbGF/cR1RUxpxXpx1emo4ZDKPUZ5jZKymaqFCGqJqppUAAAIfkEBRQAAgAsAQAAABUAFwAAAj6Ug6bLh9HiSgDICA3Id6rUheIoWE0lckepmKvGmKj3VXZmfw3Ex/oOIpFUw41Q5zoqW0sNJHmEkqQjalVYAAAh+QQFFAACACwKAAcAFAAUAAACPZSPGcktAJw8ccpqszZrho6AEwR8nxWQ5kdiRwqtLKmopRmLAuyeDX8zOW5BoUcBk/h2rIzrsUk8o1OnowAAIfkEBRQAAgAsAQAAABUAFwAAAj6EL6nLctDiMqHKCGqFl+XNdeJIBpElhgmlmUroKgHrTe3Mxur6MDpmIAlfw9esuEIhl4kYcqZ8Mp1DanVYAAA7",
        );
    svg
}

fn get_pixie_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACY4SPqcvtD6MEoc5o6XXB9L49IBgyY7l81YcmFtu6Kya9EInhZk1maa5SuTQ3m+eI0Jl6mlXGyEkenk7eCeZRipjalrNbwoEvyjEti0aN1sgQdkp0x+Hm6E/d9U2gQ33sD2hQAAAh+QQFFAACACwFAAMAGAAbAAACVoQRecttipw84cWJb81y7/aBSFKF1kSSYpY6plu63ChjEG29i6LeNxg7lYKrWErVoVA8OmXuMoN4ZstHi7rLYqHOaPXEmWq8UDGLG2kyflaqjt154yYFACH5BAUUAAIALAMAAgAUABwAAAJThB15y6sQWmywTkfPvCj3ilFRolwcU4JfRp4nOqIe8r60Zj7OWJqiuoHUYrxWbdX7dWIeXXDmbM1kmumqOn2qWMvrz7eVbJlcDplltsF2WZ3lVQAAIfkEBRQAAgAsAwACABQAHAAAAlGEj6kXEL+ia07GRm2iWRt+bRPUfQpZicsDnRe2Sq26ZTNcjxNTombl+8FYRJqNU0oBlS+hp0VMyhBSFy30QVpAOyb1x/CGk7iTdGZeVVkxdAEAOw==",
        );
    svg
}

fn get_rat_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEAChISPqcsQoeCRSFJnb0wX9uY1jrhYRvcw2kmq0zq945mC61PHMPm5LV6hpHKzSikSkmU4N84LiCnKZsIfSFdMOoNNbes4/IqJYpHptrvGorj0c3tkITdMlDxKR5KrTZ7mvJZXM0iFF1gVuLGD+KcW97aUJ6llMnno5sPk5OXXFoJZFopQAAAh+QQFFAACACwDAAIAHAAPAAACJIR/osvtD56ctE4QbD1ZSxOE3ieO5ql0Hoa27luFKoxF8P0ZBQAh+QQFFAACACwBAAUAHgAUAAACMoSPAcLtD6GKtDJjswuc68wtnxaOwmSmUaC2rnC8qyfXo8La+s73Ve47hQzAF+JQ6h0LADs=",
        );
    svg
}

fn get_skeleton_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAEACgISPqcsQ9sJzbs6WIrJ0n8uAHhZ2mSSSIwShbIal3Oeq5pvaN03ljcZr7WySDgcl8n2GPc+sdGI9la8RVZWs6mAVI3DrQ26XsmJxbFZcSRcL6AxuVjQRMbZ9/hrZ0a5VCceTJ0eVBCTDtMTltvKjpjWmBbfmaBXpZHkppajZiVEAACH5BAUUAAIALAMAAAAGAB8AAAIfBGKJeryHYkuT0fXCa3n7ql3VSG4lRZ7iakhWO5pGAQAh+QQFFAACACwDAAAABgAfAAACH4RvgaCnzWJ6EabVsmR0IrtVjtVdH4ae6mo66UWecQEAIfkEBRQAAgAsAwAAABAAHwAAAjmUYqnLiQZMAM9FeRuKG1eZcFcWHlDjCCTKtgvllvFMa/A80bdLrfUPDAoVu6ExOPmwerjiMjfzLQoAIfkEBRQAAgAsAwAAABkAHwAAAlCEhanL7Z9AALDaiyTFS6LALWBIllyAToYxWer6etaqyZcasySsZ+1dU9geI8cPwhMNO7nlDJcMxY4YVmpToplc2K33C35ovpOiaewtg82hAgAh+QQFFAACACwDAAAAGQAfAAACUQQiqcvtD1U4sdqbJsJsJsAxYEiWnIGmVHUE7qReMOphRwrX3IxKq3X7CXSQ0UP40CBvEF6Q5LxtTkGkxYUzDV9a1rQLDos71hCzqwGfu0ZSAQA7",
        );
    svg
}

fn get_spider_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjYSPqcttAWNw9Mg7K8NYKy49HgJm4VgCHLqmFaiekdaGUJxk+RXPNnkDllyqh24xnJGMllMvKBIyYUzcx/r0HbObSa1YdW47yuiu6SWCy1ghO8prGk3vta6ctljzZrRcZDKX9hZ0BCV459SGqNWVeGVTeIj3YShJuJXjtzOZuXRYaTnSwAY6utl3CpRQAAAh+QQFFAACACwFAAsADQASAAACK4SPoalrDZoML07qLsZW9qc5oIccZBlZ1cJW3VZOrydubE2Zmfupa44KIgoAIfkEBRQAAgAsAAAKACAAFgAAAliEhanLjRCAm1TAUDOLuoWPLVK3RMa3kY7BnuoGHi8FcrPYXu6ttB8ke9V8D14idrrcfL9LiMfc3ZCnyFMVZVmNR5OSq/V6c+QyVVxOm8VjtTsMf8t1VUMBACH5BAUUAAIALAUAAQAYABsAAAJFlI+gC+gv2lNwViNvhiHs+3TUd5CGt5mVB30me3SgA59KMNsIDOCzm8jlfEJO8YhMKpfMpvMJjRotyNSpWJMQhazGNlcAADs=",
        );
    svg
}

fn get_troll_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACfYSPGJvtb8KRsDaqrAY49u1Q0ghWI0Z+oCqqm3hFXDmj4TvnTJ65/Q18kBILH09ozEyOsY7LKdQpY7JotcZaPqUQ2JUoS9qYNZ7RS+ael9/qOAj7jNHUNX0XZofe+lY6WMZWpDFk1rbC5UYjBXWIKOdIGPnXNZVHk3KU+VAAACH5BAUUAAIALAIAAAAdAB4AAAJ0hI+pyxnfogqHSmndZdnAvVjUCIbAd6bdtaZn1k6erHIIOdO26PFaXNNpZK0H0LVCRTo4l7Nigt6Q0+gz5xwVoUxqw+flHbNYEuxbroJ1Z9zZlnNL18OrvNJ93/TSGWT8BCai5IDyBviD5cXiV3WFoUi2UAAAOw==",
        );
    svg
}

fn get_wolf_regular_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_anansi_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfALf/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/4r/c6D/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF6+AnjmRpnmj6dazqnt4Yv/QHkHftBsHX9zqVgDQMogamAdJIInycJijzUyhQTdbpx7DtkrjTw0dMLomZCFE6XWIbEx+4vARnKj6K+720Ny4+f4EigkwMDB+GiCOHh1MNH4+RIpKPRg4il5eYH5pGDyKfoaAfn0wQH6enJKlTER+uIrCwr0wStiISH7m7uloTIr+/HxPETBQixx/HycrIUxUi0NAf01ofFtci2NncQRcf39/gIuLkQRgi6OrpH+hBGSPwH/DyGfbz+Doa+x8a/f37+BnZsEEEQYMFExbUwaHhBw4PIT4UIXFiiRAAIfkEBRQAHQAsBgADABYAHQAABc1gJ44iYJJoOgar6ooCGb/pMHT3TZMEwfe7TuE1pBk6hiNK+TocRE7S84UQIaoprCrR4Xa9I3BKMSKPX4vOIr1GpV2MTjw+mtManQZeL9rTHB2AgCOCLg8dh4iIiYeJKhAikJAjkpEpER2YmCSaLxIdnyKhoaAuE6ciEx2qrKs0FCKwsB0UtbQvFSK5uTsWI74dvsDAOxcdxsciyMsoGB3Ozs8i0DsZItbWHRnbNBreHRrg4N7f4eAbIhvoHerp6O/rJBzzHRz19vUi+CQhADs=",
        );
    svg
}

fn get_balrog_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_basilisk_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcDj8GI3EpHJJBCQBUKY0GRgGqsLrdCsQEL3C7lY6KA+U5vMYRBi22YS3Oy6XFpJ30D0vLPj9WwaBgkKCBoRSB0qKB41JimsgCAhDk5RLl5EJCUObTJ6RIApJCqWjQ6ahC0oLrUOtsGsMDEy0QrO4tlINDUy9Qry/ILxSDg5Mx0PGkQ8PTM5DzZEQ1EsQSdeRERFL3ETboRJM4kTkkRNL6EQT6kns7+0USvJJ9EQU+Pn6IBUVSf7/AArpR7AgQQsWiCRcghAEwoYKHya8cGFIxSUUhWTEuBEDBiEfmXgcM1JIhgwmmZxEuYWlEA0wNUiBGUrJBiYbchLRGYkDEx4OQIX4BDF0SAcmR5F2WEok6RAPTKBG9UBVKgirQQAAIfkECRQAHwAsAAABACAAHwAABf/gJ44kYJ4Aqa6sGLDB286jUNs3TQ8D2Ys8no5FKBKIxuNwVBAVnqqntLkUGayfK0lr0FZXh8NI/J0hVOdhgrVOrFXupUJBmtNZ9rtuQVrwP35/gIGCNAwqDImHI4qKQw0NKpAkkyORQw4qDpkjm2UPoCQPKqFLEKenJBAqqUsRrxEqsSSvVRK3LBIkuFUTEyy/I77BSxQsxiQUyCPKzSsVLNAjFdTT1NfXOhYqFtsi3eDh4DMXKhflH+fq6+wsGCsY8R/x9PX27yoZLBn8H/z9+f5pUDFwhYaDAwu2OLhhAwmHLBo2HOKQg0URHGZYvIhxY4sOID90oAFy5MgRIWcKeFjioaWKlR9CAAAh+QQFFAAfACwAAAEAIAAfAAAF/+AnjiNgnmSqrmOgBi4rk8Io1DY+s8NA+qJeb7cifAhGFXJJJBVEhWgqSn02RQbsJzsycL3ca+pwGJWJiF2atCYmVO/EOyW/KkiKPCuv3y1SC38fgSSBhkQMKgyLJIuOjDMNKw2SI5QplTIOKpsjDp9iIg8poyMPp6EfEBAkrCOrq6ERESS0I7OzoRISJLy9u6ETEynDI8LCoRQUJMvMyqEVFSnSJNHUVxYWKdok2dwr3tkiFxck5SrkK+Tr7BgYJO8q7vEi8+4pGBn6Ivsr/R/6ArLQQLDgQIIfCiKUsaGhiA0sHDacGIoDCw4WMVocoXHjig4dWID8MFJEyBEnVwt48MBi5QeWL1WEAAA7",
        );
    svg
}

fn get_colossus_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcDj8EI/IpBIAUBKbTCcxQK1ar6BA9qpNCgRSIRg0DgsHxIEanWabkYS4nEhI1oUFZx5U6BP9f3sGg0oGQoOGQ4mKhAcgB5BOkJFCjo6VjwcIQwidSZ2eQpsgo6OkRwmpUqkJQ62tZgpEskK0Q7ZvQgu7vEgLuUQMQsIMxUPGwEINRw3NzSDL0NFhDg4g1ddC1dtH2E4PQuBDD+Dk5kjm4iAQ7OsQRO9D7O1J8SARQvhI+kMR/Pz3kEhwMnCgEIMFJShMBmJCQyQOHTIUQoFIRYoTw1QQsjGJhY8gPx6xAEIkyZIi31y4QITlEZdOYArBAILmzJtDMNjEWVMnkVAMQoCCEDqUaNGgGYAmTaqhqYYhT58KkSp16tSmV6tuALF1a64NYMEK8SqEAwizHNKqXcv27NqyIDoIkRv3TQe6dYfgBeGB75u+fYUEFgwiCAAh+QQFFAAfACwAAAEAIAAfAAAF/+Anjh9AnmiqBoFKtqxLCnRt35+Q33o6DDIR8DMMiggoghJ5ZCZHBVdhShVFU1ORYasyaLkfMGnrPXwO6JT5nD6jzGjECEFX0esfvEi+PyX+KH+AHwkihYRGHwouCosijokoCyOTlJEnDJmamJckDSKfDaIjn50iDicOqqokrIkPIrCwHw+1tSezMhAiu7y7EMDAJ70qESLGxyQRy8jKKRLQ0CQSJ9Ii1CPYIxMi3Cjc3h/e4OPhIxQq6Ogn6h8U7ZEVJPIi9CkW+Pn4JxYf+/39/EW6cIFEwRMFCR5EeALDB4ciIEKMOPHhCAwYSWQQsfFDR48fQXLMsJEkSQ0oNT+MUKlSRMuWLl2ilAlzwwebNiNt2LlTRE4RHD4E5UC0qNGjQo0C/dBBRFOmiTo8hTpi6gcPVxNhxSqCa9cPIQAAOw==",
        );
    svg
}

fn get_dragon_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_griffin_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmhqduoItCcgqwF81nUq7HzflwLRrzSwDYojZFIpIjifUAJJ6qFKr85SIVXoerbfEVg0HhnO6DTJ4GGX2G7UoXSoe+Z3Er6EQPD7gCR+gyJ+JQkiCYqIHoyJio2Rko4eCiQKlpaVmJiXJpoiCy2iIwuipKcepiMMIgyvsKywra6sHq20Hg26Jg2+vCK/uyfDDg4wxscjyh7HziIPDzYe0dHQI9LWIhA23CPc3iThESjkJRHoIuYe5OkjEifwKPIe8vD0HhMm+hP6Kv75TFAoMVAEhYMFByo0WHBEhQolIEKMONGDxIojLJjQ6IHjRo4gLXj0cEHEhZMjSkmmKKmSpUoMImCOkCnTBAaYNGOOyOCBJ4kMPIGiELqThAYRGpKOOIrUhFIVG0hEFRG16ogNVbFqPcGBgwevXlGEHQH267SzJUIAACH5BAkUAB0ALAEAAgAeAB0AAAX/YAd0ZGme4jiiZMC+pRvM8ynceI7b6F0OsB/w1wEaB8MOYclsmggkaPR5KrAK2I5Vi7JuTYawOAzuGFDn0uFwYqvXHbebNO8gSIh7Kc833f94JQmCCYMkhoeFHYOGjSQKj5ElCpSUJpAnmAsmmyidHQubnaKgmwwkDKmqJaqprK+npw0dsycNtyS1uLUoDQ4OQSW/JsAkwMcPD8Elyckkys8dzhDLHdQl1Ncm1BEv3ScR4STfHd3iHRIs6S/r6CTp6xMo8hPyQfYd+B0UJ/wkFAD98Rv4z1+HChVOJEyokOHBgw47WEAxUeILCxUzYiRxgeOFjhyDdAQ58gIGEidLPKRMiQLDyZUoO2SQeSLDTJsvcJaY2UEDCQ1AS/j8iSLoiw0mkJJAyrTEBqZPo57gwKFD1aovsJa4arVDCAAh+QQJFAAdACwBAAIAHgAdAAAF/2AHdGRpnuZIAmoZoDAZzN381jcp7Hy/nwIUrzSIEYskZBHZYXYI0GjURChVn0ZSAVXodrbfLMpALhtM5/NJTTq4TQf4Ox6Hd+qIEiJP2vtNeYF9JgkdCYWHJYUkh4iGjJAdCiYKk5SVliSZJZYLYiSeHQueoaSingwkDKusJayrrrGpqQ0dtScNuSW1urcoDQ4Onx3BJsIkwskPD8Mdy8skzNHOzBDD1iXW2CbWETHeJxHiJOAd3uMdEjDqMezpJOrsEyjzE/NZ9x35HRQn/SQUAv7rRxDgvw4VKpxQqHBhQ4QIH3awgILixBgWLGq02OECiQsgS3g04nFkyQ4YSD+kLLFyJQoMKVuiJJGhQ00TGWrmjLGT5k0NJDQILQE0KIqhMTaYUEpCqdMSG5xGnXqCA4cOV6/G0FoiK9YOIQAAIfkEBRQAHQAsAQACAB4AHQAABf8g0I1kaY6AKJ5jwL6kG8yzKdx4jtvnTQ6wH/DXARoHww5hyWyWCCNo9FkqvArYjlV7sm5JhrBYXDJ0zCb06HAgtU3s9vu9LiFGiHsnz8/b94CBIwmDCYSDJYaEi4gdhwojkB2SkQqWlJMnkgslnCeeHQucnqOhnAwjDKqrJKuqrbCoqA0dtCYNuCO2ubYnDQ4OQSTAJcEjwcgPD8Ikysojy9AdzxDMHdUk1dgl1REv3iYR4iPgHd7jHRIs6i/s6SPq7BMn8xPzQfcd+R0UJv0jFAL+60cQ4L8OFSqYUKhwYUOECB92sHCC4sQXFixqtNjhwogLIEl4hOFxZMkOGEY/pCSxcuUJDClbohyRoUPNEhlq5nyxk+ZNDSM0CCUBNOiJoS82lFA6QqlTEhucRp1qggOHDlevvtBKIivWDiEAADs=",
        );
    svg
}

fn get_jiangshi_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUdAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/4r/c3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF7mAnjmTZfWaqkl7rvq3prSWg2iRg43QXqL9RMNgTCY7I40hZNA0GpKeURqgSVNdRNmUdFb7gUoE0JoO/JYOhs1az1eu3G96Okw4ifL6jP/T5I38lCCKEhYcjhoYdiiYJIo+QIwmUkR2WkZYjCiKcnTSeHZ6hIwsdpqcLqKciq6qopqsjDB20tkW3tyYNHby9JL6+IsG/KQ4OJMgryiLHTR0PI9HQ0s8mENjX2dYkESIR3h3g39wkEubnI+nlE0Xt5RRF8eUVRfXcFs/51hfP/dYYngW0luFZQWsaniXktmEDjYblRnCYSLFixIsmQgAAIfkECRQAHwAsAQABAB4AHwAABeDgJ45kaY7eqZbA2bbrGMx0PctxKaj72OeigUr4GRCBI4JyqRQRkKZCgSQVTaElA0lr0KoO4MOXJP6CP4i0Oo1Wi9btNVuUSHzs9Dsdb8fr6yQKIoKDhSOEhB+IJAsijY4jC5KPH5SPlB8MIpqbMZyZnSMNH6OkDaWkIqinpaOoHw6wsrE5sbayJA8furu5Iry/wcAjEBAkxivIIsVAESPOH9DRWCMS1ibWEtQiE9zdHxPf39QUJBTlI+hYFUDsWBZA8FgXQPRQGPdQGfpQGv1QGwBi4QCEILUOCBMqRLgiBAAh+QQFFAAeACwBAAIAHgAeAAAF36AnjmRpisCpmgHrtSspzHQ9i4KXx+Og+iQgz0NQFUnHoafAbDJLBeXIYCBVPVSqlHTgHrpbE4I0DnsS6DM6IVqz1yaFfD5SeOx3vB2fz9sXgB4LI4OCJIWFhoCJDAwejiKQj42SlZMkDSKZmjGbHpueHg4iow6mI6OiqKepqSIPHrCyQ7OzIxAeuCK6u723v7wiER7DwjHFxMklEhIkzSLPzx7S09QqE9gm2BNmHhQiFN/e4uJhFSQV5yPqWxZD7lsXQ/JbGEP2Uhn5Uhr8Uhv/tnAYMjBMh4MIEx5cEQIAOw==",
        );
    svg
}

fn get_kraken_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAP/3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/7f/c83/c+T/c/r/c6D/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF+6AnjmRpnmiqrmzndmwsZmNGy6qm656Gq5tS8CfiGEfHJJITAwBET0909HRCiYFswKPNEkcCAVjsIYvCuIFowFazPW01PEYQ1T31PH7/K3j8f4GCfoA/Bh6HiCOHjF8HHo+QIwePlV8ImCKZCB6ZXx4JKqFfCiKlJKenRAsirCWurj8MHrMmtbU4DSK6Jry8OA4eDsEnxMQyDw8eyiTMy8mfEB7S0tPWnx4RItra2dufEiLhHhLh5eJEEyIT6use6u3tMhQi9B70+Pf1PxUi/f0e/gX0h8OCCAsGDXpQmPBgjAsiLkD0AFHiRIsRWWDYiMHDRo8iOHYUeSIEACH5BAkUAB0ALAQAAwAWAB0AAAXiYCeOZGZmZKqK2qi1a7elW13LccdxJN+PvhRgBBgWO0NRchQQBZpNEjRKElQFVqx2ZCUNviNwZ+BVEUSE9DndUZ9jBVF83qHXU4Z8vmMY6fl9Kgckg4Q5HQgpiYiJizEJkCkJHZE5CoeXMQsimySdC50kDAwjpCmmpiQNIg2rKq4dsCIOtB0OK7e0tzEPvIciECnBvyMRHcbGx8o5EiLNzSPQ0CkTItUd1dcT2ikUIhTeI+He4yQVIucV6ecd6egjFiIW8fEd8/D28h0XIhf8+wD3/fM3EINBDB0OIhyhMOHBEAAh+QQJFAAZACwDAAcAGAAZAAAFv2AmjmQGnECpjkHAsq67ZgI9Cjhu7+ogDj5gRhj8qQiEEbK0FCVVhYIoKqVKpzORYWTYZrxdb/ZALh8y5KwKkWGT3GpRYpaYxxUZ/Eq/WvgXan4zDCSEhYcrDYoZDSqKjYxZDg4rlBmTljMPK5txIxAroJ4iESWlpaMSEhmrq6yvcRMisrIjtLUqFBQZuiK7u7zAvSQVI8UVx8UZx8YjFiIWz88Z0tPU19cXIhfaGdrd293c4hjlGBnm5yXp6OYhACH5BAUUAB0ALAQAAwAWAB0AAAXkYCeOZGZmZKqK2qi1q7iRW113cyxyI0/6HWAKAOgQjcWiSEkKiJzOZicQTQkEoitWex1hVYNwRzwmDXQiAqGjZqvXsYJITu/U7SmDXt8xjPZ9fioHJISFaAgpiR0IiYsxCZEpCR2SOgpomDELIpwkngueJAwMI6Upp6ckDSINrCqvHbEiDrUdDiu4tbgxD71oIhApwsAjER3Hx8jLOhIizs4j0dEpEyLWHdbYE9spFCIU3yPi3+QkFSLoFeroHerpIxYiFvLyHfTx9/MdFyIX/fwC8gP4jyCGgxg6IEw4YqFChCEAADs=",
        );
    svg
}

fn get_leviathan_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgEfT7EY3HJLAKewycgOm02A9hsdri1LgVfARgkHg/LzQFooF6y30T4kkAA1elMOl6oXxYKRH+ATYKFg0MGXkyJQgaOjEQHkpMHQ5VCl5WXmJJFCEKfoAijRKGfp6JLCSCrQwmtRK2rs0KzsEMKQgq5Rby5vyC/u7xLCwvFRMfKIMrGDEMM0dFF09Qgz8/X0w0g3ELeQw3e4N/d5uJDDulF6kTt6+rxQg9D9ET2IPj48/n8EEUQ/oEQOIQgQSH/ElqJEIFJQxAPhTScyLCJBAlMMArRuBEExotWJjARKYTkEJEorVBoshJESyItXyoiUkFIzSY3rVgoslNIz1SZF4AKCVqEKNGZIDAkHaJUSFMmGYhEBTF1yNSoVaUiJaKhSNcmX2duGLJhLAizQtAW4cCBSVshbOOy9dKhrt0OQuoOucsX794OHgILHky4sOHBQQAAIfkECRQAIAAsAAAAACAAIAAABv9AkHBIFH6KoCNyyQQBAMRnc0oMWIfWAFZLLQq+YPBQ3B0OkIO0MH0mspcEAigOj9OH9mJhL+QXlnt8fYJDBkgGiFOIi4lEB2WOQweTj0UIl5eWSAggnEOYRQlCogmlpkSiIKSqo6lECiCwQwqyr0KwuLexCgtFvSALv77AxL3Gwb0MDEXKS8tCy9Eg0c1CDQ3W2EXX2yDY2tfaDkIO5UjjIOhD4+zp4w8PRPHy80L19iDx+kgQRBD9QgCCEBhwYMEiEYYkRChkIZGEEJdImCgBSUUhFzGCqEixyYQlH0GEHPKx5EgKZVAKUQkCpcuWTSowkQmCphCZNG12sSCEJwhan0gs8LzQhCgRoyCIIu2CAURTJE+fFpEqJEOGIleRZM3aRYMGKl/LhBWyYQOTskPMkkWCdgiHt0XgCuFA5C3duXaHdNjLVwjfDiAAB/5LuK+Hw4gTK17MGHEQACH5BAUUAB8ALAAAAQAgAB8AAAX/4CeOpAgAJVquLBkELtzOpWCPtoDr9Dr8QOBI2CMRWITjJ6kcMVmFwicKjVJH1pJhK+IaWttvl0s6rA5oGnqdJiGKpbcIQZeTEnh8MfHhj/IlCiKCCoWDJIIfhIqDiSQLH5AjC5KPIpCYl5ELDAwkniKgJZ6kH6WdnSINDSWsK64frLKxsasfDiIOurkluyS4wLm7DyUPxCTHxyPEzB/GHxAl0SQQ0yLW19Da2BEf3STf3iLhI93f5CISIxLqJO3t6R/q8ywT9iUTH/n6+Pz2ExTgjAj4geDAggjhVBix8EPDhRAdShQ4woIIixU/WLSAccWFGR8/hBwR8sJIEhhoWKT8sFJEypYrMpCQOVMEzQ8ZZOrE+UHDCA0+VwAN+lPEUKIkNmwYobTph6VPRUCV2nQqh6tXP3AYkVXrVq8lsF7tQLYs2RFmSZwVYdash7dw48p9S2Ku3BAAOw==",
        );
    svg
}

fn get_manticore_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQdAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF/2AnjmRpnmiqrihQArDLpoEY3GQ9o4LAiz3fTjRIDYpE5I5wYnacTOeoUChRRdcpKdupigzfL7gzJhvO5HB6LTq03e426hB/kxAdBF6vF+FZf38dCYSFI4Q7CSKKHQqNCpAlkJErlCILHZiamZedKAuYnB0MDCKkpiSlo6Sqq6kkDbEdDSOxtCa2IrezIg6+Dh3AQyS/JQ/HxyPIOw8kEBAd0CLQ0tEq1CcRJdraKN0i3yQSHePl5Cnj4igT7B0T7u0i7yPzJPUlFB0U+fok/CL/RgRMUWFEhYIHD3ZQSILhCQsWRkRMMZFERRIXMIq4kDHjxg4eNZbAgEEESZMlS0COUElSZQeXIjKMkBmzQwaaMW/ivGlzhAYNPoP+9DkUKAmgRjd0ULpBqQimS0cwdfq0adQOHLBqHSYiq1euXEMAACH5BAkUAB0ALAEAAgAeAB0AAAX/YCeOI0CKQGqebNsFYiCT8Di7pyC4e9f3uNEANxgKgyRCS9lhEpidQuEkHVWtpOvUIOJ2DF5vF8wNf7uiQ1qtTuMO7Q5chOgg6vc7Hbm3dxKAgSOAfCIJhgodCouJJIyNQYsiCx2UlpWTmS4LlJUMDCKfoSSgHZ+ioaWjHQ2trCOtDS2xIrK1DrgOHbqFLLkjD8HBwMOFDyIQEB3KyMsjzC7K0CIRJ9XVLtjUJxId3d/eON0k4yQT5x0T6egi6iPu5iwUHRTz9CT2Ivkj+y0VIxX+BQzYgSAJgycsWBixEEdDEg9FXCAxscOFiRUtajyRsQMGDCI+hgQJckTJjyU9OI7IsLJlBpYrX8Ls8JJmBw0aRuQUkROnTp87dd7c0IHoBqIijBYdYRRp0qNFOXSQKrUXCapTO4QAACH5BAkUAB4ALAEAAQAeAB4AAAX/oCeOZEd6XWqebOsBIiCT8Di7ZxC4u9f3uJEAJxgKg6RBS+lhDpiE6ClKEElHVWy2WhB1PYUveBQOj8ffr0FkWK/ZuPZI7jnU7Ye8vY4U7e0IgYIjgX0iCIcJHgmMiiSMhouOCh6UlpUiCpqULpqZCwsioKIkoR6goyOmpB4Mrq0jrgwtr7MkDA25DR67kby/vL0eDsTEI8Z9xSIPDx7Ny87Lzy7N0yIQJ9jYhtsjER7f4eC+3ycS5x4S6UHqJO0nEx4T8fIk9CL3I/ktFCcU//9cBGxRYUSFgycKulBIwoIFEQ8hPozosEXEERcwYsyYkcSFjx09hPSAAYMIkydNPaI8eQLlygwjYIqAmUHmzJo2PdD0oEHDCJ8ifPb8ORToT54bPCTdkFTEUqUjljZ1ylQpBw9Xr/oakRWrhxAAIfkEBRQAHgAsAQABAB4AHgAABf+gJ45k2Z1dqa4eAIjuO8owzY5BwOoez98jwU0gDAJJg1XSs2QuCdASlOCJjqhXK7Ug4noK3m8XzPWauyJDWq1OswzttejgOdDt9vlRX/cg/oAjf3siCIUJHgmKiCSKhImMCiOSCpUilZYsmQoLCyKdK54enaAjop8iDKoeDCOqrSqrsK4NtQ0et4+4u7i5Hg7AwCPCe8EiDw8eycfKx8ssyc8iECXU1ITXIxEe293cutslEuMeEuVA5iTpJRMeE+3uJPAi8yP1KxQlFPv7LP0rFUZUGFgiIAuDJCxYELGQ4cKGClc0HHGBIsWKFUlc2JjRQ0cPGDCIEDlSJMmRJUg5nswwgqUIlhlcvowp0wNMDxo0jNApQmfOnT957sS5wUPRDUVFHDU64mhSpUiNcvAwdaquEVWpeggBADs=",
        );
    svg
}

fn get_minotaur_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcDj8fIjIYhIJaDqX0GcyAApQoVih9SoUgAReInhM9oLF3+FAOFiD2kg3e96uuwkgPGHPF+LzRH96gH8gBYaIBYpLh0KNjYhDBkKTBpVQk0iWmUQHB0ifQp6doqVYCAhCqSCorKtLr0sJIAmzQ7a1srRZUAoKIL+9WAtExEnGS8hEDEPMWc5J0EQNINRL1kIN2tjaSA5J30PhSw7lQuMgD+pDD1Dt6etE8SAQ9Fj19vn6+CAREUj/hARMMvCfQSQSJAhJuLAhEYUgGEZ0CGKCEItELGJMshGJRQpIQCYROZKCSZMgQFaoQISlEJcuQcSUmcSlBQsgcOIUsjPnkHyeOnX6xHkBxIWjQ4oKUZpEadGnRkFgwCC1ahaqQ6hqtYohg1evSDIQEStWyFcQZNGi1cC2rQYob0HEfUtXrhC2G/JuAJGXr5C9focA/qsX8AYOIDggXiwEMS8oHDpIlgyiQ2XLlYVgzqw5iWQPoEMLAQ3CQxLTRFCPBh0EACH5BAUUAB8ALAAAAQAgAB8AAAX/4CeOIwCQaJmiQeuu8JsKn0DDuGjf4vANPhJwSPQBhb8RQURYfpooJ3ParDoLH2xhyxVhs6SvFvz9GMxog3p1FrXb6NFBND/UYXOUPU9CIFB/H36AIoGBMAkJIoofiY05jDAKHwqTI5aWKZOZOSgLCx+gMKIrDCSmKailKw0jrTmvKbEkDh+1K7ciDru0uSIPKcAjwsEPxr8kEMojEDDNOMsiER/TMNXV1BHY1CMSEjjf3eIi3+UkE+gjEyLrH+3q5+7yIhQoFPWd9Pj7IhUV+f9QBEzxz4KFDwcNilCIEIfBhwk/XJB4YaIIixJJYMyIwiKGDxg+rhCZ4mNIkCg/V2bI8IElyxEvcbhsSbOlhps3P2iAsXPniJwkem4YuuHDUBJFRSRdajTFUA4fOECFGrWqCKpXR0y1GrWDV68fwHZAMVZEWbNfx3r1wLatCLZvUXiQS6JtCAA7",
        );
    svg
}

fn get_phoenix_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQaAM3/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9KD/c7f/cwAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAaACwAAAAAIAAgAAAF/6AmjmRpnmiqrmzrvjAJxG9Ar4KYx0PvlwNRD+X7iQgkAjKpXI6UyVFBVJhSpVWN9Uq1bg0jA1gzJovPZJE4PDpo3Cb4Wy4nueUIDSIv4vNJfiN7eiMJJIaHIgmIiIWJIgookQqUlRqRJ5gaC5sknCILoaKhI5+gnSIMGqqqq6kMsLGts66tGg0luLgiDb2+I7q5Ig4qxA7HxsUjDyfMD87QGswm0yMQ19gQGtrXIt3c2d0wEeQRNxIm6BoS6uok7igTEyPy8/Ty9y8UIvsaFP0AW1QYMVDEwIIHCSpEYaGhCAsaIJaAKLGhRBMXSmTUsJHExo4iQI7AQJKkCAwaUBWOTHmypEoWGTTEjCmzJs0bOHOyCAEAIfkEBRQAHAAsAQACAB4AHAAABf8gp3FkaZ7oOXLblrJv2nIAQNsoHt98UAY+UjCYAv44AqQpSWIKmMtocsAZUElXrDVbLVm7BFOYNCaYOWN0Ka0umNwceLxAp8dJ8ruBs0f1+X9/Jnt7BxwHhiSGiSiLJYiHHAgmk5QkCJWVJZqSHAkvnwmio56gHAqnJqgkCq2urSWrrKkLHLUltwu6u7okt762HAwmw8IlDMjJxyTFzBwNJtAnDdTS0dckDg4p2xza2dzdJg/kJA8c5SXl5+jpMRAQHPHw9PPy8TsxEfsR+f4cEkhICAjwn4kJJSYoPLiQBMIYFCiQkMiBYsSJGCtSjFGhRMeOHD56/GeBRMmSJ04qmnxxgcOFli5JwDQBs2bLmSgwkNCpswTPnS8ycMhAVOjQo0aFKiVRdGkIADs=",
        );
    svg
}

fn get_tarrasque_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnqgIpGzrBYEre8JY1zM7DCPPk7+chzAcEY5GIlFY8DSdzmZB+nzKDB5s1sDFarvZ2WFMHnsOInQarUYh3nBPfC4XvVuJvD7v2etFCYB9KQoehQqHiIaGiIWLio4tC5MilB6TlAuVmpojDB6foaCgoQyfpKeppyINra6tHrANsa60sLG4JA67ux68Iw4iv76/wS0PDx7JI8nIyMrOyiwQHhDU1CPY1tfXKRERHuDh4yTg3+LmJxLr7CISHusk7+zzJxP39x75+hP8Jfj9+pGgQJDgiIIeEBqkkDChQRIVIkY8IVGihwoXL1YkYaFjRxMePYoISXLEhZMnTVyg9JCSJcsLL1d6wIBhpk0SNHPerKmTZ80MGTwEFTFUqNGhSIMCBUrUgwanJJ5CfSoVqggNVLFe9bCB64iuIrqKDft1A1izJTh4UJt2rdsUHOLm6OCBLl0heGWEAAAh+QQFFAAdACwBAAAAHwAeAAAF/2Anit5onmh6AoDqqsEYx28tCsKY5/Y7dD/RYHgK9kSETlKpXDKfx0JHOi1Yq9MR9WXoeg2dbxgcFpFdh7R63TmI1O33C9GhI+4ien2E1x8THQmCgoGFgYAiiDUKjI2NIgqQHZGTJgsdl5mYl5ubnJmaJgyjpKQdo6cMqaiqqacmDbGxHQ20tba1sre7ty4ODiLAv8Adw8TCKg8dD8rKyyLMzdHNKRAQHdfW2CLa1tfY3tsmEeTlIhEj5h3q6OgmEvDx8O8SHfX38fb6IhP9/hP8+AH012EgQYAiKChciGKhwoQdKERkKLGCxYsnLlbosHHExo4aLYjsYIFkSREiU0ymHKGy5YULHWCKkPkyps2bMGvmfImhQ08RP30K/Rm0J4ajQ3tm6JBhqYmlUFE0ZdrUqVMXGjpk1ZDVBFetX4+42EBWRFmxNjioHRECADs=",
        );
    svg
}

fn get_typhon_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_warlock_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgsGo+fo1IIaAKWUGVgSg0crdboUMDtCqLf6IA4GBvN2iGBAGKvl+50gThPaw1EvBKvtx+Gf3ZKCAhGhIJDCQkgiotFjUeORAqUIJWUCpOYmZqcQgsgC6KhoqWfpaNDqKBFDK6vsLAgr0MMs7dCDboguru9v768Qw3CQg7HDiDIxsjNycfKQ8lGDyAP1ULX1tXX2NrYUBBFEOLkIOJC5ObqRxERiO7v74ISIBL3+ET3iEITEyD+/AEk8g8RhYMUQBxUmJBfkQoVQECUCDGiQyEWQFjYyLHjRRAXQoocGfIjCAwoU6o0mQFEhpcwX7r8qEEDiJo3cda0yW+DzyWfG0AA/emQg1GjII4qddgBRIenTqE+bQpVkIerHoZkFYIVa5EgACH5BAkUAB8ALAIAAQAeAB8AAAX/4CeOZGmawHkGbKB+7lsKdC2Y95i/Q+8PPJmIQCIQhcICqaBEygwk6EsqPJCsL6wTMeKqvK9EwiRWjU8KxSdtSqtLbtJi/qHTR/O8PL8QMT4MgYCBgoOEhYCJfyQNjY6Pjh+NkiMNlB8OmQ6YmZyan5yYI5sjD6Yfpg+oqayqqagvEB8QsrOytLa1tLi7JxEkEb/BH78jwcIqEhJOI8rMIhMfE9PUJdHPFBQf2dnbzyUV4RUf4eTj3yQWFh/q7Orr6B8X8hf19vbxHxj7/P0Y8Rk+ZBhIkGA+DR80KEyoEOHCZxsifoi4YWJFihWZcdjI8QPHjxyYdRDRoeSHkiNRDpJE4qGlyxEeYLpsWSIEACH5BAkUAB8ALAIAAQAdAB8AAAX/4CeOZGmOwHkGbKCa7inMtPCK9jvs/HD7vheBQCIKb59CIZlcvpw3A0mKRB5I16oWIeJqR4nEJ2win8QjhfqjXpfaJvhnMV/Q7/SRfU/a20kMgYKBIoOCIwwfiYkNjR+NkJGQjw2PI5WVDh8OmpydnqCfmyOaJA8fD6eoqaysq6eqKhAjELO1H7WzuLm7uiMRESTAH8PBv8VfSBISyRMfE9DRJc5fFBQf1tbYySQV3hUf3uHg3CMWFh/n6efo5RcfF/Hy8+UfGPf4+RjlGR8Z/wAB1tPwQYPBggYJHvyyoeGHhhseRoQYUQuHixg/YNzIQUsHER1Cfgj5kSRIJB5SCqoc4YGlypQkQgAAIfkEBRQAHwAsAgABAB0AHwAABf/gJ44kYAJkqq5f4L4BK76yYN9CPebsMJC/VfAzVBEIH+RRdkTKPgVS9En9GEjXqvYg4mpHCMQnrCKvxKOE+qNep9oq+EcxV9Dv9JF9T9rbSQuBgoEig4IjCx+JCwyNDB+OkZKQj48ilSINmh+aDZydoJ6bnpkpDh8Op6iprKyrp6osDyMPs7UftbO4ubu6IxAQJMAfw8G/xV9UERHJEh8S0NEpzl8TEx/W1tjJJBTeFB/e4eDcIxUVH+fp5+jlFh8W8fLz5Rf29/j25R8Y/f7/+zJ8yECwIMGB5TRo+KCQYUOFC79smEhxw4eKFJNx2LjxA8ePyTp86EByZEmSIksNVvHA0sMIlyJatiQRAgA7",
        );
    svg
}

fn get_ammit_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRpnmgKrGlLBmMgi7PbCvgn6GJunwPSIBj8DH8mAiE5WiJJhU9hCh1FnyeDSDviYkWHzyEsJpG/iDQJUWJjE6KEHP6hx78jRUmfx38WCyWBI4NfDAwlhyOIiYwpDQ0kkB+Qk5KULQ4OH5qdnJsioKGcLQ8fpqinpiOrpyKtJxAQH7O1syW3srQtER8Rv8AovyLDKRItxyQSycknEzbPI8/TKRQi1tYm2dfX2yYVJOAi4ifi5CYWIukf6+sj7unuJhcj9CL29vck+ScYIv7+SAQcOCLgiQwjEH7IoFDhQhMOS2ggMXHExIofNGAUsZHEhhEfP34ICVKEyJEpOCKMUMlShEqXMGOe6DCCZgmbH2jizInCgwifJnwK/flhaIkQACH5BAUUAB8ALAMAAQAcAB8AAAX/4CeOI2CSaEoGY+CKryqLQv0JN43P6TCMvs9POOSNCB8C8sg0qgokqEjqRBlE11G2OjocRN8u94Mgm8+jMjfxYY/cIrhR8aHXRXb8eMFfkPwjgFUMDCiEI4UihzMNDSSNH42QIo6TKA4OH5ibmpkinpqfKQ8fpKalpCOpIqcoEBAfsLKwriO0tCMRHxG8vTK6wLsoEjzEJBLGH8kfE07NI83PzyIU1B/VKdjW19wjFSTfIuEq4+MfFiLo5+ko6uvsIhcj8vH18yTy9CIY+x/8JP8CjsDwT0SGEQc/ZEiYUGGKhh80kJA4QiLFiBdFZNwwgiPHDx47ivgIEgWHESdTHYo4ufIDy5YkOoyQiYLmB5k4b6LwIIJnCp5AnYQAADs=",
        );
    svg
}

fn get_behemoth_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQbAOT/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+c3/cwAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAbACwAAAAAIAAgAAAF9+AmjmRpnmiqrmzrvvCozbEKAOON12SABj7eRjAiloy1gWigNDVjBMJKCitsCtiUFWbYGL6q7uuwOZjJKTQLsUG426v3KrFJ2OsluumOUig2fiJ/JIMnhRsLI4kLjIgniY8kDAwbk5WWlCaZmSOcIg2gG6ANnyekpCSnIw4brA6vrCKxJK4lsyIPDxu5uSS6vrjAJRDExcPHGxAkyiYRzhHNJdAb0yLVLhIk2SLbGxLdLRMTJeLjI+PmLRQlFOsb7iPwKxUl9PQb9/gi+SoWJRb+RgQc2OLCiAsGDR4UgXCDwhUYTEQcMRFDxIksMmjcaIKjRiEvQgAAIfkEBRQAGgAsAQAFAB4AGgAABeugJo4kYJJoqo5BwLZrTAqrQMvrMOooj6MEESGYIv5GhQJOedQYnIZnLHo8aA7YH9YaQ2gQYO9RnEpoEuhzU51SaBTw99qNWiw0dtE9ta/fGSOADIMagCqGhiKGDQ0ajI6PjSmSkiKVGg6ZmJqYKg4inyOhGg+kpA+oI6Ukq6sirhoQELGysyO2tyK4sSQRvr+9Eb0jwsQoEsgSJMrLzSLKzDETEyjT1iTU1DIUKBTcIt8a4eEpFSjmGujo6eoxFijvGvHx8hbzKxcjF/n5Gvwi/fwBVIEhRUENBQ8eFJFwRYaHEDU8HBGRxMMQADs=",
        );
    svg
}

fn get_chimera_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_chupacabra_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmjZpWwrAm8LzGww2h6Ol/t+CiKgRygsFYepwUjJFCmTJ4JI6pFaq1MU1VQQdT3db9hbKnxPBlE6rfaw2ep16UA60Ef0vMfOv99LCIGAgggehYWGIoIoCR4JjY4ikJEkjy0KHpgKmJksnC0LJaEsoywMLiSnpywNJA2trB6wKA60JbUiuLgmDw8eviXAIsK/I70mECjJHsvLzM8iziQR1CLUESPYHtjX1traJxISIuMj4+Ie4uXp7CYTEyPwIu/w8h7v8fctFCP8Hvz+RAQEyKLCCIMiDCJMiFAhCwseLEAUAXEiRYkUI6a44IEjiQseRXAMORIFBg8nSTakTIHh5MoRGTJ4kFkiJs2aMmOa0OCBJ08SPnuWCPqTxAYPR08cXWoUqVNUIzhE9SAVqtWrIQAAIfkEBRQAHQAsAQACAB0AHQAABf9gJ44iQJ5oigYjq76jEItyV6fCTQ4j3/k+FDBFGBWLneMJKWJ2CiLocyqFSlHXjmG07Wq/3+1JPDocROczeq0mmUUIEiI+itvh9M5cP0r4T34JHYKEIoGGJAoiCoodjY6LkJGMKAsdlguWl5opmS8MJ6AwoikNMCimpikOJA6sMKyvJw8qtLUitiMQEB28J766wSK7IxEqxiTIHcbKyh0S0CLQEiPUz8/R19IoExMi3iPe3R3d4OPgIhQUI+vp6h3t6ezwKhUj9h32+CIV+PopFkRYCNiBIMGCAwUWRHGhw4WGIx5CdEhRRMOJIjB00EiC4wsMGj1myNCB5ImRJk8ikhw5QkMHly5JwHx5YmbMDhtwqsjJk0TPnKdEcBgxdOipEAA7",
        );
    svg
}

fn get_gorgon_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/eAnisBojuWprl8QsC4rn0ItjPesDyfPf4MfUDgjfIzGIzJJaB51n8JIWqhWo9CTwWDifrzfLRc8O5zM6E9azc6OECL4CU53ixKJD16/59/tCgofgoMmgoSEdgsLKowfjot2HwwjDJaUmJWUbg0inR+foKChkiIOKqcfqaUfDyyurCMQECK0H7S2sRERH7u9vL2xHxIzxMITyCsTwiYUzR/OzCIVIxXU1NIfFhYi3NzZHxfiF+HgIhgmGOgn6utuGRkf8CLxI/XzdhoaI/v7Iv3/7GwYMfDDhoMDCx6UxOFDQ4ciGnKQCFFShw4fMGYcofFiLA8gQ4L8ENIclBAAIfkEBRQAHwAsAgAAABoAHwAABfLgJ44jQIrmSQbB2brrKYjCTI+1/eUqOYy/H1DYOxFEhGMyWWwWns9PoXkyGEhXkfWzLR4Oou/3Ay6DyUWESn1if9juXiLxmdPrd3xRwRf1FR+AfU0LCyqGH4gihVQnDI8MH5Ekk40NIpeYJA2ZVA4qn40nD0WkoiMQECKqH6qspxERH7GzsrOnHxJUurgTvj0TuCQUwx/EwiIVIxXKysgfFhYi0tIk0aIX2Rcf2yTd2VQYJBjiI+Ll5T0ZGR/rIuwj8OzwPRoaI/f3H/r8TRsj/z5sGCjw38CARTh8ULhQBEOGpzp0+DCRIsWKyDxo3NgjBAA7",
        );
    svg
}

fn get_hydra_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_juggernaut_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjqToleSJriwAfO7rsmTw2XSg6+VeCh+gYEgsCoNG0nA0+DRpT2dpQI2KCB9sicDVjrhbMKmAIo/MH3NhLVqzR4ZSXG6Yk+L1+ujw4e//NH2Cgx8IhSOGiSKGiIeLjyQJkSOSLJUflZciCiOcmwqeKKAkoSILH6eoC6umqaevrawlDB+0DLe3IrS1I7mBIg3ADcMkxMW/Ig4jysrJH83J0DQPH9TUItcP1trayB8Q3+Hf4OPkIhDmgREjEesi7R/w8e3ugRIs9/cfEvn8vxMfAJaYAJAgiYICWVD4sLDEwocOGf6qgILiB4oVLI7ASMOCxxIWRIT8EHIkyZMrLlx8UKlyBEuXK0u0LIFhRM2aH3DexKCTJooMH4AGFUqUqAihI5CO0LD0A1OnTjU8jSpVRNUVGz5kzSpiq1YUG8KK5VqCg9kRZs9yYHFWxNpAHeLK7cBiblxveGmEAAAh+QQFFAAeACwBAAEAHgAeAAAF/6AnjqQHlOSJrmgQeO7rsqLg2bSg6+U+Dh7gYEgsCoNG0tBDYNKcoiaJQJV6CldUYYslbUvckQE1Fps9hrQorT6g3KWD/O2RyxEePEn/HOH1CAkegiOChIQoiIciCiWNjJAjjY8ej5QLI5giC5ornCSdDB6iowymIqcooqapIg0er7ANs6+xsLe2LA4jDr27Ir68v08PI8XFHsclyDQQHs7OItDTENV9HhHY2tjZEd4k330SIxLjHuXn5uXoTxMr7u4eE/DzTxQe9yQU9/v6+PkrKngQSEKgwRIHaVgosdBDw4YMWVyYSOJCCYsWRWBcgcFDx44eRYAMybFEhhEnU0GKOOkhA0uWKEto8DCT5syaN0XgJFFzxAafHn4K3fDTJ1ERRI+S4OCBqVMOUJuigBpVBFMSHbJ6yMpV64quXj2EAAA7",
        );
    svg
}

fn get_kitsune_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRpnugJqGk7BoEIxx/spoLw6fru97eBUDQYFYsfZJI4PBFEz+hHOq1Sn6fCqKDVfrzgr/eLMpDMBrQIrR6ZUYeDSE6Kl+h2F+Kz1/NRCYEkCR+EhCWGhYOCHwoijiOQjSSSkpOXCyMLmR+cnZybmiKhoyIMJacfqSgMp6umIw0NJLKxsre0tLMlDg4kviK9vSPAwcUnD8kiD8vNH8zPyjciEBAf1iXW1dMiEd7dH9/hEeHd4icS6SUSI+oi7CTp8CMTJhP1Ivj4H/f2IxQlKAAE+EGgQYIDCf4TUWFEhYYMGT6cGFGiQxEWMlogkXGExo0YQYbseOLCBREnP12YNIkSZcoWGDCMiDlTpgiaN22ayJCBRM+eJ376BDpCQwmjIpCSUKo06YgNJDZAFQG1atUPU7FmxSqCwwivX71yADv2Q9mvaD90WNsBxVoRb0+wbXvDg10Rdj3cCAEAIfkECRQAHwAsAgABABwAHwAABf/gJ44jQJZnqgaByLYfq86fINQ4ft/0OYy/30c47BGOH0JyqWQykaeCqCCVfqzYa/ZkGHUNX9E3LE4dRmfSIY1upxCIT7wnl89niU8+f9rrUwqBJAojhIWHhYELIguLH46Pjo0jkpIMJJcfmTMMl5uaDScNoSKjpqSloh8OrCQOI6ytIq+wsiIPuA+3ux+6vbe4dBAQH8QnxMN0EcsiER/Mz87O0dMjEtcnEtbaItzb2hMpE+Ei5OQf4+IUJBTr6x/t8e/u7yIUFfj4IxUi+fn9+/ypsGBhBEGCBgvSuXBBRMMPDBk6dPgwBQYMIy5mxChCY0eOIjJkIDFypIqSJEc4ajixUkRLEi9futwwYgNNETRz5vxwk2fPDRyCciAR9ENRo0OPihA6tEeHDiKe0unhoaqIqh56hAAAIfkEBRQAIAAsBQAAABYAIAAABv9AkHD4GRqLxqQQAFgynUpjIACiUqvYa1Qw5HJBX3AUNCCby2ezkiBkg9zwdrJQENJBdTw+fx8aQH9GBoF+gEYHIIhjQ4iKQgiPiyCQk0kJCZJCl1EKQp1Jn59RC0KkQ6amQwyrIAyqrq2wrbEMDUK2tou4tw5JvUIOvyDCwA/GD0PIScogx8wgEBBC0dPS0NZDEdrZQtsgEdnbEknjUeVDEhNDE+pC7e0g7OsU9BQg9vf19EL2+kkVQioIHBhwkQULQw4eTIjQyIWHQi5EfCgRREWKQjAMwaAxY0cQHDcKyUAyAwiTUUyWRKlEQ8tMQjaAkLmB5sxMHDiAyCmEJ08QmB06CAkKc4iHo0KOeogSBAA7",
        );
    svg
}

fn get_lich_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQcAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3aVz6Ixz9H9z+Yr/c5hz7nNz/7Fz4wAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJGQAcACwAAAAAIAAgAAAF3yAnjmRpnuiGrqwIANyLvnBbBhx+Bjxvl4JVUCQY/lqDASepPHIIJ4J0BHVyCqYCVnu9cn8GkmHMGZvL5xG5dOC0RYe2fO52v+MoBEKk5+z9gH98fn0nCQkciIiJI4qJh4yHiyUKlSIKHJgmmpWamSgLIqEko6OiHKamJQwjrCKuJK6wHLMkDSO3Ire5Dbm6vysOHMLDJMQmxygPIssrzRzPLRAc0yTV1FYsESYR20cSJeDZ4yQTVhQs6Bzq5CQVKO/tIxYi9PTyFyb58vwmGCf/+gm0kcFEwYEoNCDMFgIAIfkECRkAHgAsAgABABsAHwAABdyg521iaZ6oCQDemrbuWwYenQY4LpeC3IuC3042GHiKxh0hRWiWlsMCqiCleqpWU9ZgMng93jBYLPp6DucSOn1At9ftc1yEQNA9dbsez+fnSwkJHoKCg4YihIaFgSIKjo0mCh6Sk5OPJZQeCyKbmyWeJp2fJQwipR6nqKqrqaseDQ0osbEptLQiDiW5uCi7Hru+KQ9DMhAixijIxCIRHs3LzNAeEiXUJ9YmE9Ii2jsUIt8e4SXj0BUy5+fbIhbryxfu8SYYMvTEHCX4+PLEGSX+LzQQEyivQwqDKEIAACH5BAUZABsALAIAAgAbAB4AAAXm4LYBYmmOAHmeQbC169vCcSlsd5zjez3Um8FP+AMCCcgSwSgqrApO6CYqNTlFBpNhu9l6u18sd3MwlQ/nM1mEJrc3CLgoPq/L6XGEvpRIbPx+fyKBg4KBfSIKiolAChuOjomRCwsrlSKXl5glmgwinp9MJqAiDRumpzGoqCWsDiKvG7Err7MrDzW4JrobvCYQRsAbwiLEJhERxyXJokASJc8bz9FAEyXWItbazUAUJd414CIV40zkG+foJhZG7CLu7twbFzX08h4rHvgi+/JAGEY4mBA40J+JDDUQGtEggqHBGh0MhgAAOw==",
        );
    svg
}

fn get_nephilim_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_nue_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_qilin_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_skinwalker_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgcAo7HonLJDIACTijzuRQIlNasFbsdDkCDb3gcBouF5PGSIGQz3VO4sACi1wt4ur2o7y8NU4BKglNCB0WHIIkHjIyGioUISgiSlJaXIJJTCZxLnZydIKFTCiClRQqlqUSqp0wLsEsLILNDsbWFDAxLu7ogu7/BhQ0gxEXGxkPEyUwOIA7OS9FD0IVCDyAP2Evb19rdTBBCEOJL5Ocg5+VMESDtEfDw7u1E7/NTEiD5RRL5/voA/e1TMgFEwSUFJyg0aFChQyYUIkKkAEIiRYsUmVQAsVGjkI0VQoKcYkGIhZNFSqo8yRIEyiUXiFyIKVNIzJkzQeRcgoFIT1oQP4v0HEp0SQYiR5GCSHq0aYamTDQMkTpFqgarVplsILJVyIatX72CAEt2CQciZwudXctWSQcib4e8jStkboe7c5V4ILK30F4PgAGD6EvkQ2Frhj8oXmwYRBAAIfkEBRQAIAAsAAAAAB0AIAAABv9AkHBIHAKOx6IyAGIyl82AUzlkCkCCrDLL1W6vA1BYOCibxeEy2qweEtxU0Psdp4MKxIIej1fy/0QGcUKCSoVKB4lFB0KMiY8gjlQIIJRFCJSYmptxCZ6dCSCeo6GDCgpUpyCoQ6esSgsgsVQLs0S2SgwgDLq5ur2/vUoNIA3ERcTHRMZxDkLOVNBE0lQPIA/WSthE2NlUECDgEONF4+bh50oRIOtDEevvRfDs7UUSEkr3IPj8+/76SiZMoDJQYEEQBg0qoQCC4UKGFCA2hOiQSAUhFS4q0XgxY0YQGolYEFlkpEkLKFGCUEnkQkuXLYW4vEBzJkwiGIbkBLETJ09Xnjkx9BySgWiRokhBIM2QtIiGIU/jPNUwdaqSDUSwCtmAlSuIrl+7ah3CgUjZOGXTqi3SgUjbIW3fxu1AN24RD0TwxsHroW9fEHqHfCAyOM7gD4gTDw4CADs=",
        );
    svg
}

fn get_titan_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgUfo7IonK5BACITqZUGQiAqtWrdcoVgATgMHc8HJjPAzKXwCYI2WpuoQCi1+nzeZxoAPUNgIGCfXEHB0OGIIlEi2MIj0KPCCCQknsgCZlCmQmYm5x7CqJCo0Oipwp7C2oLq2oMQwywUrNkDWq3t2MODkO8Qr0gwcNjD0IPyMfGyiDLzVMQQ9FL09NC1koREULb2yDe30Pg4UoS5kIS6OpD6esg7UQTQxPyQvX19vP6RRRCFP3+/P0bAhBEwYJDKghRmBBEhYcPFzZ0yMSCBSIWM2q8eBFERjUXhlwYGVIkiJInyWCYgqHlSiEvuWQgkqGmzZsgZs4co6GnzyqfP0H4nLKhqNGjSzZM4cC0qdMxHJh0mEoVRAclV5dkJeOhSNeuS8ASCQIAIfkEBRQAHwAsAAABAB4AHwAABf/gJ46kCJxoqa5lEJAuK5OC8NX1bc/y8A3AIG/4IRiPBKKswCyImEqZwfChVqnTaVR0+HQP4LC4S0QgRuZPmrSeJd6id+IDl0cVeBFe8eH390oLgiKDI4KHC0oMiotDDVGPQw5Kk5MsD5gfDyKZmpybm5wlEKSjECKlqB+pqyQRK68fEbEitLYkEiK5HxK5u7jAuiQTIhPGI8QfycXMzSQU0CUUItMj1dUf2DMVIhXeI9wf4eJEFh8W6OnoIupEFx8X8fLv8iPvPBgyGPv5Iv0zGUZkGEiw4IeAAXloWMiw4UIRDFlsmEixosQVHDJq3EiEQ4kOIEOK6KCC5AqTPDwJlFCpckVLESEAADs=",
        );
    svg
}

fn get_wendigo_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQEPQhDo/IZLGYFAKOzycyCm0GhoHrFaQVdrncLfgoGArKZVBamEav18eBHDRA1ul2+ryJJAgJgIGAf3yFQgWISYgFho0GfI+NTQeUhpQHkkMICEecmp2emSAJCYakokkKfKpHCq6umQtJskMLtre2mQxHu0MMv8C/og1HxEINyMnKog5Czc7PQw7TqCAPD43XfBDcQxBJ30Lc4SDkSRHoIBFC6Onq6u7shhJC9PX2IPb49YUTQv4TAgoMCMJfwSMGk1AAsZDhEAoNHTpsuDDikQogMGqswLGjxowgPyaxAIJkySMWTAohaZLlySMXQFyIKSTmzJo2h9DMiQQDCEmfR4BiENqT6JEMIDIgrYZkqRANGkBE5QNV0lQQG7Bu2MoUSVYhHECEHZuEg9mwhtCC6LC2LVshHd7Ghfs2Sd1GHjwcycuHL4ggACH5BAUUAB8ALAEAAQAfAB8AAAX/4PcBo2ieaEqSaGC6aQx/Myrcn5Drtu7jMdNgKPwQB0JikMAkfJwnKNTkbE4/hVQWW+h6t9tTOGgop8qGYOzAPnzc63dbbUKI7Go8ni5KnPwmgH19CYWCKQoKdIkiiY6MagtBkh8LlpeWfB8MKZybDKChoZoNJ6UfDacmqap0DievQQ6xmh8PIrd0ubUfEBCavykRwyYRwsXEIsYxEs0fEiLNzs/P09FqEyLZ2tsf293e4SkUIuQU5+jnH+Tr5e0pFR/x8iYV8/T09vkpFh/9/xYCCvznr6C/figufFC48MQFhiIUQpSIAsMHDBZFWMSocaMJjxdPZMjwgaRIESNRN6IwWVKEhpcwg7zUpEHEhg83c/KKcfMDB59Af6LgQFSoGqNqOnQQoZTp0hRNNXnwcGJqEKsfQgAAOw==",
        );
    svg
}

fn get_banshee_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_cyclops_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnugJrGybvmLwyrApCPVdj0M5/EDfjjAiEE1G0vFVEDVhz2fKYDJYr9bq61Dierzg7gtBInvICLTIvEYl3qOER06nz++it5ykEPVLfX+BJoIkCyKHJguLjCeJiSIMkTsnkh6WIw0impSZmyYOIg6hJKSiJaOnJQ8irKytJq8errAlECK3JBC5uLy4vyYRwiQRIsLDHsUjxy8SJM4n0CLSKRMj1tXXNRQj3B4U4OEi3t87FSTn5yPqIuwwFiPw8fLyHvU1FyMX+/z7+p0iMNQQCNBDhgwvDhb0oKEhCQ0jGkIsuEFERQ8bLmp8waGjRw8dR4T8KCIkSI8cPA90MLFS5YuWHVqOkLkQRggAIfkECQoAHgAsAAABACAAHgAABf+gJ46kB5xoWq7sGLTiC7eCMIv1TQ7l4P89nYcwIhBXRtJxVhA1b88nzCBkUWGH1WHL3WpnCBIiTCZ7xuJWYj1KiNhweJtNUojsK4V+z8LjRQuAVSuBHoUiDIiDJYkejSMNIpGLHpOTJA4iDpmYnZicnCQPIqOjpCumHqWnJRAiriQQsK+zr7YrEbkkESK5uh68I74zEiTFLMciyTATI83MzjoUI9MeFNfYItXWQhUk3t4j4SLjNxYj5+jp6R7sOhcjF/Lz8vGUGDr4lBkZM/yUHjQIJKFhhMCClDaIUOhhA8OHMzhInOhB4giLFEVYrDiRg4cOK0B+nCGyg8gRHUIBAAAh+QQJCgAeACwAAAEAIAAeAAAF7qAnjqQHnGharuwYtOILt4Iwi/VNDvreEyMCUEgkkoC3gkiZXN4MPRYUdoiuqjBECcHterethHgkLpvP5DFJIWJb123SQjR/j+p1EUNvH+09fyMNIoN2hYUkDiIOiomOiY2NJA8ilJSVK5celpglECKfJBChoKSgpysRqiQRIqqrHq0jrzMSJLYsuCK6MBMjvr2/OhQjxB4UyMkixsc9FSTPzyPSItQ3FiPY2draHt06FyMX4+Tj4nYYOul2GRkz7X0a8iQaI/L1dhsi+h4b/P8zOAgc6EHgCIMERRgsOJCDhw4rID6cIbGDxBEdQgAAIfkECQoAHgAsAAABACAAHgAABf+gJ46kB5xoWq7sGLTiC7eCMIv1TQ7l4P89nYcwIhBXRtJxVhA1b88nzCBkUWGH1WHL3WpnCBIiTCZ7xuJWYj1KiNhweJtNUojsK4V+z8LjRQuAVSuBHoUiDIiDJYkejSMNIpGLHpOTJA4iDpmYnZicnCQPIqOjpCumHqWnJRAiriQQsK+zr7YrEbkkESK5uh68I74zEiTFLMciyTATI83MzjoUI9MeFNfYItXWQhUk3t4j4SLjNxYj5+jp6R7sOhcjF/Lz8vGUGDr4lBkZM/yUHjQIJKFhhMCClDaIUOhhA8OHMzhInOhB4giLFEVYrDiRg4cOK0B+nCGyg8gRHUIBAAAh+QQJFAAeACwAAAEAIAAeAAAF/6AnjqQHnGharuwYtOILt4Iwi/VNDuXg/z2dhzAiEFdG0nFWEDVvzyfMsDJYr9bq7FDierzg7gxBInvICLTIvG4l3qOER06nz++it5ykEPVLfX+BK4IkCyKHKwuLjCyJiSIMkUIskh6WIw0impSZmysOIg6hJKSiJaOnJQ8irKytK68errAlECK3JBC5uLy4vysRwiQRIsLDHsUjxzMSJM4s0CLSMBMj1tXXOhQj3B4U4OEi3t9CFSTn6enolBYjFvDx8u+dF5T2nR4YOvv5HhkZZgD050GDQRIaRhhM6G+DCIceNkCcOIODxYseLI7QiFGExowXOXjosILkyBkmOwWYHNEhBAAh+QQFFAAeACwAAAEAIAAeAAAF/6AnjqQHnGharuwYtOILt4Iwi/VNDuXg/z2dhzAiEFdG0nFWEDVvzyfMsDJYr9bq7FDierzg7gxBInvICLTIvG4l3qOER06nz++it5ykEPVLfX+BK4IkCyKHKwuLjCyJiSIMkUIskh6WIw0impSZmysOIg6hJKSiJaOnJQ8irKytK68errAlECK3JBC5uLy4vysRwiQRIsLDHsUjxzMSJM4s0CLSMBMj1tXXOhQj3B4U4OEi3t9CFSTn5yPqIuw3FiPw8fLyHvU6FyMX+/z7+p0iMOgQCNBDhgwzDhb0oKEhCQ0jGkIsuEFERQ8bLmqcwaGjRw8dR4T8KCIkSI8cPA10WLFS5YyWHVqO6BACADs=",
        );
    svg
}

fn get_draugr_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeALf/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/6D/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmiqrma3umwJkMDs2SIee0Eg9j2eT7gjCY7IJLJYGjhFA+iTaSJYrwQqqsD1cAvak6E0JpeZh1Fa7Tm4tYhRnISoMxMefGKf7+/xTAoKHoMig4KHhEULCx6NjI+OjFQMlZUelpiWDEwNnp8enw2hokwOpw4eqKiqp0wPHrCxD7SzsLdFEB66EL29Ir+8OxEexMURyMTII8oxEh7P0BLT0iTP0SoTHtrb29rcJd8rFBQi5OUe5ybl6CkVFSLvJPAn8ioWFiL5+B74+/kj+Km4cGEEQQ8EE4ooiJChCgwkII7AQFGERA8XU2QgkWGjh44bQ47wWETDCJMaUhd6MBnGw4YRG2K6nNnSAwebNjncvMkiBAAh+QQJFAAeACwFAAIAFQAeAAAF/6AndmJpjqcImMDquWoaBOI8ezdOp0Lv/75UaUAUDYxFoYnAbBKUqYLUIy1ErSdDtqQ1eIWHcPgkPiFEiHQa7VGnEgkRPO6Z1+8lhcKzN+31fSYLg4MehIaECycMjI0ejQyPkCcNlQ0elpaYlScOHp6fDqKjnqUmDx6oD6urqa2qJhAeshC1tSK3tCYRHrwRv7+9vCK+IhIex8gSy8omx8kTHtHT0ynVHhQU2Nki2dom2t8VFR7jJuQp5h4WFuvr7ezw7SLsIhcX9vj3+/Ye9yUYAJrAQFBEQA8HPWQokWGhwoYKI0o8oaFERQ0YPVSEsqHEho8eOnaE4oFDyZIcTASaTBECACH5BAUUAB0ALAUAAwAVAB0AAAX3YCcCYmmOpxiYwdq5aioI4jx3N06nQ+//vlSJQBQRjEWhqcBsFpQpg7QjNUBPB2zqkE0hSl9wB0EWJkpnU2J9UnTcivh7HnefFotOXpTH9/UmDAwdg4KFhIIpDYuLHYyOjA0nDpSVHZUOl5gnD50PHZ6eoJ0nEB2mpxCqqaatJhEdsBGzsyK1siYSHboSvb27uiK8IhMdxcYTycgmxccUHc/R0SnTHRUV1tci19gm2N0WFh3hJuIp5B0XF+np6+ru6yLqIhgY9Pb1+fQd9SUZ/iYyCBTxr0PBDhpKaEiIcCHChxBPbCgxcYPFDhOvcOiwkUPHjSlCAAA7",
        );
    svg
}

fn get_ettin_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgEAYiA5LHIHAaaT2E0QG0yBSAsUcDdDrVW4UA8HJNB47Q5DCII3e24e06Eswuggj5fxPOFfmwGIAaFQoNDiIOLbEIHjkOPkpCRjQgITZggmpyabAmgTQlCoSCjjUIKCiCrQ6pWr02qrQsLILW1qLZMuEIMIL++wEPBw8JFDMlCDcvMQw3QINDOz0XTQg5EDtlh3CDe2NtCD0zkTeTmIOkP6VYQ7kIQ7+/xYRERQvj5Q/r7+P1hJIAQyITgEAkCDbKZwLBIQ4cTUAmhQLGiRSYV2VQAsXEjE49EKoBsYgFESZNFSp4cslIiiAtDLsB8OfOlSyIYhGDIOYQnzz2bQjIEBZFBKFGgTDQIUQqCKVOkQjYMkQqCalWoQjhkHaJ1K9YOQsAOESsWqgchZ4mcTYv0g1u3Rd5+YBMEACH5BAUUACAALAAAAAAfACAAAAb/QJAQBBgaj8ikMcBcIplNpVFAnR4FQipWOhwYB2CkVziWEoxnYVoNOhPWyELBOK+D5kJ8XmlA9o1/QoGBRwdJhkOIQoaMhQeGCEiRk0aRQpaVCJEJSZxCnqCeRwmkQgpJCqcgqaZSqacLC0ixSrGyR7YgDLtDvFxCDEa+IA0NxMXEyULGy0bMykMODknTINXVRtLYRg/d3kLf4d1D30cQ5krnQhDs7EoRRvBJ8kL0ShIgEvj5Sfv8v0YmgBAohODAggCRUFh4hGHCJBUiSpz40IgFEBcvItFY8QIIjx+PeARZ8QiGIRhOgkhZ8kgGIRleDpHZUogGmzhB3KwJYsMQJZ89f/LkIIRo0SFGW3YQsnRI06YtPQiRakQq1ZIfsmY9ovWDlCAAOw==",
        );
    svg
}

fn get_giant_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeALf/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/c6D/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJCgAeACwAAAAAIAAgAAAF/6AnjmRpnic3qiXnuu1rdjTt2WJX6jnJiwAUYOgJGovD4CjpCYycImhzSpIGrlCnQLT1dLlegXgsBnO/g9Mg7Vmz22k36e0h2O+EEt5Oyo/8IgUjBYIlhIeFHomBKAaNHo6OjycHKCaVlygIJZsnnZwoCSSiJaQepiKoJAolrB4KsK6wryOuJwsluJYeC726KAwlwbsew7sNJcgmyiLMlg4mDtLPxB4PJw/Z2tvZ1R4QJRDgluPEEREk6Ooe6+veHhLx8fD0EvX27x4TI/v9+v/+3lEYMbCgh4IDD76rUKKCQ4YOSTD0ZsFERQsYS1T0dsFERxEfR4TchaFkSREYSCGkLHHSUgYTL0nEhGlJgwmbJHDetLShp8+eJn7+zEfURAgAIfkECRQAHgAsAAABAB8AHgAABf+gJ3KiR5ZoWnLsWXYw7Mlv3KH3WwKqCPw8FPAn/AVKR1HSc2wyn8qAVCkQVT1XazVrLWUF10FvIPaQz+gzquwhuN8E1LvkbtfppUJenyr4/3l9KgY9HgaHiIWGKgeKjY8ejYwpCCqVhZeUKQmbPZwinyWhJQoppSIKqaepHqetPQspsYoiC7azKgwpurQivIUNKQ3DKsElxoUOPcq0zIoPKdAP09TV070QKRDbtNm9EeDgHhHj5eTn5b0iEuzsHhLv8fDu6iITJff5Hvr69RQl/wJ6CPhvYL0KKSooRKgQBUJ1FlREtEAxRUR1F1RkFLGxREdFGEKGFIEBRckUIwsbZVCxEkVLloU0qJCJgubMQhty6sypYudOFCEAACH5BAkUABwALAAAAwAfABwAAAX/ICcCIkeWI6Ce5cqKQRxzMx2gdHnrpYD3Ap+QIwz6gIJBSSliDpTMpfPpJIisHCxBu+12r6WtqIArkEvmM8e8ZqNLhrj8J5/DUYbSQf/jHP6AfCh7Pwh9HIaJh4h9CYs4jj+RKAo/lX2XOJklCzidniILn5x9DDimHAyqqKuoqYcNOLGPHA22iw44ubS7iw8/D8EovyXEixB9EMrLzMq0HBE4EdGL1I8SEijZ2xzc3M8cE+Li4eUT5ufgHBQl7O7r8O/gFSX09hz29PjgFjgW//3+oej37MIPgxcS4jBIC4NDhyIwoJCIA+KhDD8wotCY8ZCGHx9RhAR5aIPJkyZ/BaBEiSIEACH5BAUUAB4ALAAAAQAfAB4AAAX/oCeOJMmdZ6mS3diy5St2tCwCOO7pe08Ct98osPIEjsbSETk8CkZPUfQpqFqtUqxHMBB1Pd9BWDwii7/gL6FEWJPacLdI7pEX7ngVPj8qkPwiBiOCK4KGgyWEJQdFjYsrCCWRkJQqCSSXJZmZmioKJZ8eCqOhpKArCyWpjqserSUMsI4iDLWNDSW4s7qNDioOwCS+I8ONDysPycrLybMeECUQ0I3TjhERJNjaHtvbzh4S4eHg5BLl5t8eEyPr7erv7t8UI/P1HvXz998VJRX+/P5I8HNmQUVBCwhLFHR2QUVDEQ9HRGyEoWJFERhIZCxxsUgGFR9JhARZRIMKkyRQDZ4ssqGly5YqXr4kEQIAOw==",
        );
    svg
}

fn get_harpy_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_jotunn_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/c4r/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgsFj1CD9LIbBY/H2HUaQRQQQAr9joMBLreLhj0vQoEQ7RQrU6D2s3BQDgn1uvDOb5J6DP7BEaBgVcFBSCHiIpNh4lUBkWQTgaUXAcHRJhOlyCaRggIIKChoqGgn6RNCQlCq66rraxDrLJMCgpEt7q5uCC4vUwLC0bCwkXGw8NMDAxDzc7PINHM0k4NRNcg2dja3EwODkLgROEg4eXm5uhGD0Lt7kMP7/Ag804QQvj5TPpcQhH/hgA0MtBJQSESEA5JWIShE4dCJgyRCGICRSIXmWQUQmFIRxAfOYJ0QiEkkQpDUFZAedLJSiEWisQEMTOmhZs3neS8wLNIT00hPINeADHUSFAMSJE6SVoEg5GkGaJKbZKBSVUiUjNo2MpVgxGvTcCC6Kphg9mzZ5uYZYLWLIe3cOMOift2Lt24HfLq3dsBBN+/gPMGAQAh+QQFFAAeACwAAAIAIAAeAAAF/6AnjmRplgBwruwZtKQAmzI8DOONi/vOwwTCSCgiGonFVqEgYpKcTk80ujJYT1YDSSvitg4HT1hMNo3HMERJvVKzV4mEJ06S00tx+UqhEPH7Hnx+JoKAJQsLI4iLiCKNih6JJwwMJZSXJJQilR6cJQ0NI6EioKAeo6empysOJK0erQ6vsSWvJw8juLgeu7oiu7wtECPDHsUQxcYiyMkrESPPHtEk084lEiPYItrZMNwjEyLh4iXjLOYjFOnrJOorFO4lFSPzHvX2+CsV9RYl/SL9AloY+O/EQA8XEpa4IIJhwocOTzzEQJFiCYseKl40UTGDx48rMpwQSeJjBg0oUytqMLFyRUsPKjVsmEmT5oqZJ2rO5MCzp88RPnkCDeqzg9GjSDt4SMq0qdEQADs=",
        );
    svg
}

fn get_oni_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQEAQYGo9IYTEJCgSY0KEzKQBVo9Dq1TgAdbHM7tdIEJbBx/P5WBC20e540jCko+0gPPIw5GP9IIBMCEMIhEmGhWAJRgmMR46NaApDlAqXmCCUQptMC58gC0KiUKSin6RHDCAMratYrquvSA1CtQ24tUe5t7ZMDkLARsLBR8LESA9MyiDMyVEQRhDRSdPSWBFCEdvbRtzdINlYEkIS5CDm5efp6GgTQu/w8vPxYBRDFPn3IPr7/HAgKhwRGHAgQBAWhCREqLAhQ4AXQES8EHEIRYkYD2LAAILjxo0dO3I8KCRDBhAmS55MaWQlHA0gNMiECTOmkJkzj2wAsdNIT0UkG4L+HPKTg1GjIJAmRcLBiNKlTTsckQqig1SqQq5qrWp1iAcQX4V4GOsV7NivYdEeCSvkg1sQH+DKbRu3rdy4bt+CCAIAIfkECRQAIAAsAAAAACAAIAAABv9AkHAIGBqPSGExCQoEmNChMykAVaPQ6tU4AHWxzO7XSBCWwcfz+VgQttHueNIwpKPtIDzyMORj/SCATAhDCIRJhoVgCUYJjEeOjWgKQ5QKl5gglEKbTAufIAtColCkop+kRwwgDK2rWK6rr0gNQrUNuLVHube2TA5CwEbCwUfCxEgPTMogzMlREEYQ0UnT0lgRQhHb20bc3SDZWBJCEuQg5uXn6ehoE0Lv8PLz8WAUQxT59yD6+/xwICocERhwIEAQFoQkRKiwIUOAF0BEvBBxCEWJGA9iwACC48aNHTtyjJIBREkjGUqmFLJyZRQNMGMK0TATREyaNLFsQLKh585DJD+H7AzKAURRIRyOIkVyNKnRpE6NdJgKgqpVqVU7CNGKFYSHI1+/evXqoexYIWXFjhX7oe0HEG/jDmk7F65dt0OCAAAh+QQFFAAgACwAAAAAIAAgAAAG/0CQUAgYGo9IYlIYCCyfw2ZSAKJCn1SrcQDiXpdcr5EgJH+PZvOxIGSf2/CkYTg/10F35GG4v/ZBf0sIQwiDSYWEXwlGCYtHjYxnCkOTCpaXIJNCmksLniALQqFPo6Geo0cMIAysqletqq5IDUK0Dbe0R7i2tUsOQr9GwcBHwcNID0vJIMvIUBBGENBJ0tFXEUIR2tpG29wg2FcSQhLjIOXk5ujnZxNC7u/x8vBfFEMU+PYg+fr7byAVjgQEKPAfCAtCEB5MyHDhvwsgIF6AOGRixIsGMWAAsVGjRo4cNxoUkiEDCJNDTJYcKURDSxAaYrp0CfPLBhA3h2zIiWSnkUCbPIVwGDoURFGjSDgIVUr0KIgOR6A+hSpVCFWpVa2C8LB1iIevXrd+5cpVyNiwZUF8WKu27YchbIW8nas2LoggADs=",
        );
    svg
}

fn get_pegasus_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEj8GInIpFIJEAKezCd0SQyAAlYhdrjlUocCUFg8LhMF6PRyABqwh+x4u/2GKwlLPIiA1yP5SQVEBYJDhCCChYaKSAZCBo6OQ5KRIJCWkJdJBwdDnZ4gnZ9KoyAICEmoQ6ispqynp0QJQgmztEi1ILZKuwogvkIKvsBEw7+/wslDCyDMC89CzEjOzUTSRAwg2dvZSdva2t3gRA0NIOboX+fr5eVLDiAO8PBf8+pCDyD5+vf89xAQhgT81w9JhAj3EBYkIkECCIdKIC4kMmHCkooTkVBYQqFjRiIVkoQcGfKjBSIWToI4yfLjhSEvYYJ4GXMihiE3cd7M+TEDCC2fRHwK/QhCgxCjRIxqQJpxgxCnRJxCzchBSNUkHK5O7NABBNclXTN6GOvhXhAAIfkEBRQAHwAsAQABAB8AHwAABf/gJ44jYJJoqqaBGLzr266k8Am2iI94fvuqwUc4JBpXxBThQ1iOllCmqEltpgor7KeA1aq8HwPJIB6Rw2iU+Dw6iA5ud/v9kcPr9xQCMeL3P3x+Kns0Hwkkh4mGCYmMIocfCpKTkSiSlSuXHwsoC54pnKEinqSbHwwiDKqoKqiuKKysDbOFHw22uLQitygOIg7AvjS+xMLCIw/JJA+FzMwfyc+1ELUf1NUoEdXa2CQS1d/dIxPjKuTiIxTqK+voIxUrFfLuIhYq9vj27hckF/wf/AK6wzCCYMEPBA2iyyCCYUOGGRy60/CB4giKGOl92CCCY0eOGzyi4yCC5AgOJE0SouvQ4QNLFC/peZjpAUVNFCEAADs=",
        );
    svg
}

fn get_rakshasa_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgkAgBF0DHJbAoDSahzOhRUrUIstTkYDr5dYfi7JRAJ6LRaaDZPC0y4sCAHwetOQ1PPHxr6TgdbIIJJhUwIWwiJRYmMSQlOkQmRkJRMCk2ZIJucmwqZnUULSQukpKWoqEkMrEStsEWtTQ1FtbYgt7UNt00ORb8gwYNMD0TGIMjIycyDEEPPQhDR08/TxBERINpC3NzERBIgEuRC4ubh44MT7BNC7kTwIPLgIBQUSfhE+lQVFf1C/PmrN8WCQQtCEBJMcoFJw4VDMBSRKITiwgxFMFLRwFGDkI5DPDLpyDEkiA0nN6BUybIIS5UpVwqByaFmTRAccOq0idNmTjGfOXV26ACCqNGjRZMaVaoUqYenHoRAfQoCatWpV61eFfKhyIevILqKDUuWSNchH4IAACH5BAUUACAALAAAAAAgACAAAAb/QJBwSBQCAEXQMclsCgNJqHM6FFStQiyVOBh2hYPwF/QNUwlFgnrNFqLR0wJTLizQQfJ70+Dk+4cGf04HWyCESYdMCFsIi0WLjkUJU5MJk0mWl0UKTpycQgqfoSCfRQtNC6enpqurSQxMsEOwskS1SQ24urm8uU4ORcBCwoVJD0THQsnJIMfMUxAQQtLTINTR0tFbESAR3kPcQuHFQxLmEkLmROjlIOzFExNM8kL0hRRU+ET6VBXkQhX8/WtioWBBIRYGFrugsAgGIg+FRGyYgUjFJheFaNioQeNGjU44fgS5AcSGkyZPoiSiEqVKk0JQcpg5EwQHmzhp2qR5k+dNLpwdOoAQSrTo0KNEkSI16qGpByFOm4JwOjVqVapVhXwo8qEriK1gv4olsnXIhyAAOw==",
        );
    svg
}

fn get_roc_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9AAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/KAnjmRploAIpGfresEYv6Mg2i2O094g+i1gjyciGF0EYqkwYjKXypFBNPVUq9QTtnUgHbojcOnbQiBKZ8/ZfEqLEqSEHH6i0xQKEj6fj5YWCySBHoB+JAwiiIcjilEMDSOQJZKSJpWRIg4jmpsknCafJQ8kD6WjpC2nqB4QPK0tr6ytESK0L7ZREiK6L7xREyLALsJEFCIUxjTJLsgeFYbPI9ElzxYWJtcl2STW3CUXFyLgI+Ee5eXm6OQjGOwi7fAe8Rj07SftGSP5Ihn7HvsA/wnkR9CDhoNKNBgcoVBEQ0MeNoiQOGIDRYoQPXA4sVFjxhcdOnwcSVJECAAh+QQFFAAcACwBAAAAHwAcAAAF6CAnjmRpjoAIpGfrBiPsloLA1aZ9z+Ug+icgkMchGAkuJFFUKJCczZJTWjJYR1eO4bQlZUeHcOvAIYvMYBJCvS6t2xz4KZEw1ed0nkIx2vP5SyYLIoMkC4WBIwsMI4wiDI48kY8iDSMNlpaVPJolDjwOny2iI6IPPKcuqQ+nECKuM7CBESK0LraJEiK6LrxEEyITwDPDLsIcFInIJcnMHBUVPNEi0NPQI9MjFhYi3N0c3ibbJeEXI+boHBfmIujr7CXmGCPzIhj1JfP6JPgiGf+BMnAQOHAEQGUkNHBQuJDhQoQzNkjcEAIAOw==",
        );
    svg
}

fn get_vampire_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_weretiger_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmjZpePKnkAsxrJHv2jgBfrI77iUQGAaBk8DTzI5WiqPJQJBJJVSp9BCYaQVdT1f8JZlEJUNZw9arU6zUYe46DD30O34fPxeQnj8gCN+goSBgyQJIomKiwmOjYsejSUKHpUiCpkkmiOZl5agIwsko6WjJQulHqcirAweDK+vsLOzIrW1tLAiDQ28I76+HsLEw8C8wh4Oyw4kzc0lz87MJA8PHtYj19jVItvY19kiEB7k5iPkJ+nl7OceEe/xIhHw9CT2JfXyHhL8/hL9+vkbKFBEwIEoJniYwNAEQ4VHKHiQSEHiRBIWK+Ko4KECx44gRXgcwfEjCgseLFGgFIFypUqWLlOyuFDiAs2bJHDaTIEBQwmfIoCSECr0RIYRGY6KUGqCadITGkRoiOohKlUUVqVeJbHBQ9cNX1l8Ddu1BAcPZ9PiUKsWitsRIQAAIfkEBRQAHQAsAQACAB4AHQAABf9gJ44dQJ6nia5d4Iru28rsKnTCPeZ47Q8DFNDHInSMxhHySEQVCqLnMwptdgyGEVa0vWa539VBND6UO2Y0+qxGId4iRLwjp9vv7/oo0eH79yR8In9/Iwoih4iHiYgdCoyJjAsdkyILlyOXmJablJ4dDCSho6GgpQyjoKIdDaytra4isLKysK+vDg4iursdvL+9vL67ug/GDyTIyCfKycciEBAd0SPS0yTW1tPS1BEd3hHeI+Io5N/g3xLq6ifs7RLv6ygTI/QT9B33+VYkFB3+NQASqdCBoMGCJA4SrGGhg4WGDiGKeEiC4ooLHS5gFKExY8aNHTF2XIEBAwmTIlA4nhyhkkSGDC5HwFwxs0NNEho6aNipU0TOFT9z7vw5YkMHoxuQ+kCq1OgIDh2gSoVag4PUqFg7hAAAOw==",
        );
    svg
}

fn get_werewolf_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnqgIAOfqlm/qBTQZzLhN16ngCUDgT+QbBY+ywaC0XJKUUKWMkCJYR9asrFAqcEdfsDdlMJTMZhHak5Yd3qXDSS6XeRD3vF2EwMsSgIGCHgkkgCKHMgoei42MiySOIpB7JAsjC5eXHpp7DJ8enwwjo6ElonYNqiUNHq2sq5UkDg4jtbWztHsPvL0PHr3AI7+/MhDHyB4QIsfKyyTPJxHT0x4R1tfU2iPZJxIeEt/gJeHh4OIj6CMTHuzsJhPu6/H07yQUHvgmFPz6Jfr8TlTwMJBghYMHRRRUaDChHQseIEKMSMKCxIsWZVzwsLEjiQsgQ3IUmQKDB5MmSTxgQJny5Mo9GTzEjDkig02aIm7ilEVCg4YTPn/yJLGh6ImiG4Zy4OBhKdMSTJfy7OChg1WqJahqHcrVQwgAIfkECRQAHwAsAgAAABwAHwAABf/gJ37eaJrlqY4AsLatCq9BcNr4Xdeq8AlA4G9oChpVg8FJqTQln0kVYSUiWEfWrKpwKnBHX7D3ZDCQyyOzmnponw4rOHyF+NTr1BMCf0r4/38iCSZ+goMqCh+Ji4qJJowijicLH5QLl5Qil5WanFQMoCoMIqMmoKV5Jg0fqycNr6kmDg4jtLSys3kPu7wfvQ8jwMAqEMXGHxAixcjJJs0mER8R0dTR0tPYI9QmEh/d3yLfEuPe3dwmEx/p6icT7iPu8e8mFB/1JxT19yP3+bEVAAOaqPAhIEEqFhIqFGGBYcOEHxQ2PHHhQ8WKFkdc2MjRYscTGD6EHDkCw8iQIkw4ojyR4UPLliYyyIQpYiZNExo+5MyJk+cJDUBjndhAdAXRDUI5cPigdOmJpUpjdfjQoerUE1OzhgAAIfkEBRQAHwAsAgAAAB0AHwAABf/gJ45k6ZVoCqQfsKLumwYoTZdBnrOCQPrAX2/oKw0+g2QSKTqOlNAUgVCiUqvTKavA+hS+pC83ZSgZyqMyuvs5HErvtyjO/iDuJURKz08lPn9/dSIJgigKiImJIgokiIyNKQsfk5WUkySWIpiDHwwjDJ+fnqQsDR+nDaojp6glqq0oDrMlDh+2tbSdHw8PI76+JL3BKBDGx8Yfx8ojEMzOJBHS0xEf1dbT1tEoEh8S3d7e3d/f4iPjJBMf6uwlE+8i7+oj8yIUH/f4JRT3+fj8AP2JqPCB4IgKCBOSIGgQIRsLECGKsDCRYsSIXS580MhxxIWPIEFuZIHhQ8mTIjA3qDS5UuVKFhlixhQhc+YImR8y7PqgoWeKnkB3bhjaZeiGOhw4fEiaNIXSpl06fOhAlWoKqVhDAAA7",
        );
    svg
}

fn get_wyvern_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQcAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAcACwAAAAAIAAgAAAF/yAnjmRpnmiqigCwBvA6wnQq3PeKc7hwDsCBSPgLcoRI4ojALBFIzKjoSeU8RwVOVpQteLXesKmrFRk4ZzM6bWi3Vef0gTSvH+5zET5fupsQHAiCgIOFhn8lCRwJjIwijY6QjiSKHAojCpeXJJqZlp+eIpsiCxylpiMLp6Snpa6rJQyyDCOytbaxHLQlDRwNvb2+JL8pv8ElDskOJsvLKckmDyLSKw/WJNbUJRAQMtwc3yPhMiYRESPmIubn5CcSEiXv8CoTKfUT9SL4+SsUKf4UAgpsV6GCCoMI23GwwNCCwnYXLqiI+FAEBg4YLprIiLEihwwiQJLIAFKkRw0iNBSoXMkBpUcTGzjEjPmyps2bOEeEAAAh+QQJFAAeACwBAAEAHAAeAAAF/6AnikAJjGhqpmPgBTDMtrGMCh4uCvzc4zydaDBIEVnHorIoIsw8BOcoCp1CpZ6CSMvNbgtgVhdl8JQNaDN6PUuPDp6DXB6f059wEcKD2Pf/f3p9KXsJIwmGiImKHoqOIoYiCh6TlJWWCpmTmposC5+fKAseo6Gkp6YeDKqrqyMMrqyurawoDbcNtra5Kbm3Ig7AKMEjDsQsxsciD08PzMvOKdEeEBBP1tbU2Nna3E8pEREj4ePi3ywSHukpEu3nMxMTKfHy7ykUHhT4+fr59iwVPFQYOFDgEwvvECr0gPDbhYcOPVyQaA+DxYvvMLzLwFFEBhYdP9rT4IEkCw0kTRm+2zCCZcsNLF3+Q8Ghpk0PHGY+6eCB55MQACH5BAUUAB8ALAEAAAAdAB8AAAX/4CeOZGmKnncCLHuubRl8c2DPr3jfo/D5PQHw5Cv+gIPBKWliKp8fJSH3IUxH1qpWNCUUTN9CWCQugz9fA0nNbhve6tO7dKjb7/bcoYRAfPx9gYF/fSZ+HwkjCYmLiIuNj4+KJAoflZaXCpqbmJuXJguhoSMLH6WjpqmoIwwfDK2tIq+ss662tSQNug0iurm8Jby+Iw4iDsXIxscvx8slDybQ0CIP1dMf1iYQVB8Q3t3bIt8jERHc5uYi6eXp3CUSEu/w7iYTHxP29/j39BQl/hQCBvzgj14FEwcTfjhI74MFCyYgQmw44oJFiycufNBID4NHKhgofsgw8kQGkiQbIWoQsZKEhpUtKW74sGEmTZs2RY7gwJPnBw46TXT4MPRFCAA7",
        );
    svg
}

fn get_berserker_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Ixz9HNz/5hz7n9z+XP/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF9+AnjmRpnigJjOv6tWxaBiL90TZe77Io+J9fUPgj9j4D0SCZPDGbzRRhNBVVqx8sVlbojgofL1jUHcsMJLRatEaP3KmD/CCSk+yfOf04Qnz8fn+CgXwjCQkiiCWKh4UmCo+OMgsklJIpDAwimZcpDR8Nn5+dJg4OJKakIw8PIq0fr6ykEB8QtLW3trWdER8Rv8DBvpcSIxLHIsfFyZITIs4n0NCFFCIU1djWH9mOFR/e3iLh4N+SFh/n6egi6ueOFx/w8iMX8/CSGBgf+iL8+vmqRGQgkWFgwA8aRiQUsfDghw4PRUB0WGIDxREePmQUsfGiCA6OQgAAIfkECRQAHQAsBAABABgAHwAABd9gJwLi2JFnWqJiUL5w3MaCWNfdbcOD2MvA309EIHaKBOTRCCuUnFBR1CkVGaydqza77WJhh044LC6TYYhOeo1Il9prtTyW6NTr9jw+phD1FX0wgB2BgUALMYhAQAwvjYtADQ0ikpBADh0OmJiWJQ8PIqAdop+WEB0Qp6iqqaiQER0RsrO0sYsSJRK6Irq4vEATIsEyw8MxFCIUyMvJHcwyFR3R0SLU09JAFh3a3C/d2jIXHeLiMOTjixgYHeoi6+3tnTIZ8i8aIvca9/X8ixsd//4B7EdwEYcOHA4iBBICACH5BAUUACAALAIAAAAcACAAAAb/QJDwIyyCiMSj0rgUApzMZ3QKkoICzKzWiAUJmF9jOFwkC78DYdqYXreZ7i2IMBcS6HV8tiDkgwp8gX+CgX6GIAZCiYqIjY2Ji46RRgcHIJaYmJeXlloICEagokKjoEWfWwkJIKqrRa2srnJFCiC1tba5uHILC0K+vVnBviDBs0IMWcnHcg1GzsxyDg5C09FyDyAP2dnXRhAQQuEg4+DeESAR6Onr6unXEiAS8/T18tETRRP7Qvv5/cwoCBGohSDBWRWEVEjIJKFDZhZARJxohGLEYxdAZMwohONGjcwwgBApUkhJkiOZZQCxsqURlyuZadCwheZMb0U6CNHZQSdOFSEbigQFMfRnFg8gkBoVwgFE02tBAAA7",
        );
    svg
}

fn get_direwolf_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_ent_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CAEAASgo5DJJJIXBaToID0GD0GrNQq1jo9CkDfsOCbDZfH4DQZNGAP3u342y2Hw91ZAkjP3+8JgH1+fYBZRwUgiIhZBY2GiZCOhgYgBpaPlZiWm5mGBwdZn6Chn6SljwhZqZhUq62YCSCxWbOGtVSxt4YKWQq8vyC+u6xHC8WPC8mYxiDMmAwg0IYM1M/RxEcNjw3c3Jja2A4g4kcO5FTmWeLnxA8PIO/u8u7w8e/YRxAQIPv6+/n6+PXrhy0CiAgIDyJcaJChQmISQEiIOLGixYsSI2KbMAFEx48eOXocKbIkKwogUKpMyXIlBZcoH1UAUWFmzZs0c97EWTPnI4sLFkAEHSoUqFGhSIcGxXSBStOnIC5AneqUFQYMVLBqBXGVq1esR7o+ypABRFl8Y82ezaIBRNsjbd9qmCvXLZW4b49s2Gtog94sfkEEpsLXEAcqh0EcTsyBseIjiRVHBtEhS2UqlTtozmy58xEPHqiE/gwiNOjRpkWLDv3hAxXXR2CDcA1btu3XH4IAACH5BAUUACAALAAAAAAgACAAAAb/QBAIABgajUWi8ChMDouggFS6DAity6jWio1OrQJQeCwoZ8dnMzo7AA3eb7c7Dp/D620hAbTv8/8EgYF/gICDQgUgiYtZigWJjYyPilkGIAaYjUKWmpiel5oHB1mio6Sip6imSwhZrZquja+wCY21ILW3t1m7mgogv0sKv8PEwcLAsAtLy40Lz8ogy82wIAyNDNnZmtfVQg0g4FniS+Tl3lkOSw7s7e3pIOzeDyAP9PTV9vX46CAQEP4CagL4zx9AIQeXRAARYWFDh40cPmQIsZoECSAuYsQoZKPGjBurTRgJYkLJkyNNqiyp0qQ3CiBgyoxJcyYFmzOXVBBSYWfPkJ8gfAb92XNoNQtIQVhQyhSp06VQm0ZtdGFJ1asgLmDdarWqJgwYloQdCwJs2bNhhZjVlCEDCLf92L6F20gDCLt3897VwFeIXbx5+2bZQHiwkA2GQSBeUhgWh0aPH4PgIDkyZMlZOizRvBkEZ82chYQOLcSDhyWnQZxenYW1atSpQXz4sIS27Nq3c+e2LZt2EAA7",
        );
    svg
}

fn get_fenrir_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQaAPr/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+eT/cwAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAaACwAAAAAIAAgAAAF/6AmjmRpnmiqrmzrvnCMZiUtmwAw5jca/JpAENjTCI5IkqA3GGiaIucIGiOICNZsyRoraAreryn8MmjMIvQIbVC7DgdN3DSXw1sIVF6P2J8SIoCAgRqDKAmGKQoniyoKjyYLJ5IqlCOWIwwlmpoqDJ0ioBoNoyMNpCaopqOqqhoOJrAisA6yI7a0Jg8au7u8Ig/BvyO+wMMkEBoQycvKI8zPydEoEdUa1REj1tnaJNwmEhIi4SXiGuTj5igTIuwaE+7tJPD08SUUGvgj+iL8Jv4jKlQ4IVCEwIEEEY6wYEFDQxIMRTB8eIKiiAsaLmAkoVHjCoweV2DAoIGkCpIoiwO4CAEAIfkECRQAGQAsAQAGAB4AGQAABecgkI2ZSJ5oigYByapwnAn0PNdyPOz8OeQqAiEjHA1JRSCpMCownyimcmTIGKrWFFZ5yHRHX9L3EAYiEBl0Sp0+5xIweDwhRylG9zs+o4cp+ioLgTkLhScMKogyiiQMjA0okJAyDZMkkA4ZmSMOmyienJqbng8ppSOlD6ckq6erEBmwsLEjELa0JLO1tyQRGRHAv8IjwL7Exr0pEhIjyyjMzCTOMBMj1RkT19bW2tjdIxQZ4STj4CgU6OgoFRUq7CPs7e7yGRYW9Sj2I/b3MP0ZFwAGPHGh4MAYAQvKwIAhQ8OFDiNmCAEAIfkECRQAGgAsAQAFAB4AGgAABepgpo2aSJ5oigIAyapwrAX0bMu4oO+jjsODgSY4EhZ/KcKIoGySmMhTQVOYUlNWpEGzHXVR3+jhoCGjzOMoArceId6yREwOS9hVilE+r9fwYQp/KguDOAuEJwwqijKMIwyOGg0ok5MyDZYjlg4anCMOniihn50nng8pqCOoD6okqrAnEBqzs7QjELm3JLa7vRoRwBHBxCTDwSPDxsgoEhIjzs0azyTRMBMj2BoT2tnZ3dvgIxQa5CTm4ygU6+soFRUq7yPv8PH1GhYW+Cj5I/n6MABquDCQ4IkLCA3GIIhQBgYMGiA6jEhRQwgAIfkEBRQAGgAsAQAFAB4AGgAABe5gpo2jSJ5oegIAyapwrAX0PNdyLOz8KeSqwUAjHA1JRSCJMCIwnyimclTQFKrWFFZp0HRHX9LXEAYeDhp0Sp0+5xAweBwhRyVg93ssoVcpNH8ogTEKgyMLhyeIMouHC40MKJGRMgyUJJENGpojDZw5mp6dJA4ppSinpKoaqQ8arq4nsLEktK+3JBAaELq8I7y9J7rCKhHGGhHIJMbJI8c5EhIj0SjS0iTUMBMj2xoT3dzc4N7jIxQa5yTp5igU7u4oFRUq8iPy8/T4GhYW+yj8I/j1gzFQwwWDB09cWJgwxsGFMjBg0DAxIsWLGkIAADs=",
        );
    svg
}

fn get_ghoul_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRZeiJqrqwIAB/8xq0Z2GKg73i9Ch9gcOgrfgaDo7JFMIqa0KbTVCiIrB/sVes0eL0ksOEznn4O5/NhXUKzWYgSIv6h10f0ub2WSHz8f30ifYB/TgofiIkiiIqKjEYLH5KTC5SVJJZGDB+cIp6doSOcoDUNJQ2nqagfp0UOK7CxTg8mD7e2tUYQECO8Iry9wB+/IxHHESTHH8nJzMjMJc4fEhIj1iLV1NTY1d7a2yITEyXk5iTm5B/q4+IiFBTv8vEf9PHwJPD49B8VFf3++on4RyIgwYECSViwIILhB4crFppgCPHDhQsiMFpscdEERo0iMGAISdKEyJErUDyOyJChREuXLV+aYElCg4YSN2uKyLmCp4gNHzYAFVoCqA+iLDiMUPqBg1KnLZ4yNdKh6ocOK6paxWrGTAgAIfkECRQAHgAsAQABAB4AHgAABf+gJ45kWQIiaprB6gVtHJOtawqioO92Tw4eYHBYIviKxuTRVxA1C81lyWDwVEVXbPZ46B5KXc83bEKUzGiE+pw+JhIjuEjukb99CoVHL8rz/X1HCx6DIoWDhyOFLgweDI0ij5COk42TJg0NmCOampw9Di4OoaMkpT0PK6kmqQ+rLhAQJbGysCIRuBEjuB66t765Jb4SEiPFxyLIHsTEyyUSExMl0R7SI9LY0drW0hQUIt8e3+Mk4+Hn4R4VFerr6ivs7iPr8h4WFiL49i73+yP4+jxcuCCCoEAXAw2SIGgQAwYRDz1EXOHQxMOIGTKU0GgiI8eOIzRoKDGShMiRJU0kiBSxwcOGli9LtGTpIqYJDiNwctCJ0wbPIx2CeujgIqjQDiEAACH5BAUUAB4ALAEAAQAeAB4AAAX/oCeOZEkCImquAdu+b9mupiAKeE7v5uD5v6CJwCsRiMii0lNgMpvLksEgonqsVazywOWSvJ5DWGxClMxohJqkTisTCVFcPpp77DuFwrPn60V6fYBFCx6FhiKFh4eJjCYMHgyQkZIjlZaROw0NJZwinJ4joSsOpKUOpSSoRQ8mD6+uHrA7EBAktSK4I7YevBG/ESO/HsHEIsDDJMUSEiPNzyTMIszQ0yITEyXZ2yTb3tjZIxQUIuQe5iXk4+Ll6BUVHu/w8Cvv8SPy9B4WFiL9+zv4legn0MOFCyIQGtxx0ARChRgwiJDogaKJiBcrjsiQoURHExw9fCQx0oMGDSVQKKYUoTJlyw0eNsCUaQLmDporOIzQKYKDTp85PQCN0qGohw4lihpFGgIAOw==",
        );
    svg
}

fn get_goblin_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmg6AoCaBnBQwiI9xnIqiMLem72fZ+cajIweZFKkVLoIIqjUM5VCXaSCNrUdFbAkg0dMHofNYvBBdGizSes4WIQo1Un1/FyUGPVNCYFzCoQihYUlCmALCyKNJIyMkFgMJZUil5gjmSgNIg2enx6ho6KlKg4eqaojDqupr6wpDx60Ira4tbe3ticQIr8jEMHAJMPFJxEeyiQRzs/Lzc4oEtUSJdck2SbbIxMe3+De4+Dh3uYkFB7q6iPs6xTvJu0lFR72I/b69/z4+XsWLHgIKLCgQBIHwVzwcGHhQoYNH4qQ6AKDB4sYL2q0OILjnhEZVITco0FDiZImTCLu2bChBEuXHlpi4UDzBE0OJHBi6eCBZweeIn72HPqxqIkQACH5BAkUAB4ALAQAAQAaAB4AAAX/oCeOpAgAZToGbNl6r8gGqeAJNl7juTqMP09QKBoOSwRRculhLpMqUWEa9VCrJYNHy92mtNWD6EAek8ToKqK0Jq3f2MRIXpLbVYq8SK8n5RUqCyKCJAuGJYQlDCSLIo0ej5ApDSKUlR6WI5mZIg6dHp6doQ6jnyQPHqipIqqorqyrIxAis7S1tLK2JBEevCMRwMG9v76+EscSJMnKJcgiEx7Q0c8j0hPSJdAUHtvbIt3cFOAk4iMVHuci5+vo7ekk7yUWFh7z9Pf0JPkqFx4X/f38/QsogmAJDB4QKkzIEOEIh1hEZMAysYoGDSUupsBYZcOGEh5TfFTBoSRJkyI4EnhQWaKDB5cdXIqI+bLmTBEhAAAh+QQJFAAeACwDAAEAGwAeAAAF/6AnjuQIAGU6BmxQsiK8tqUgCjae4rpnp4NR0DMkiorFFEG0bHqczaVqVKhOPVbqVWTwdL9eErg7PYgO6DPJzN4iSm/Se771JEb3VGJ/VfhFf38lClMLCyKHJIaGiioMJY8ikZIjkyMNIg2YmR6bnZyfJQ4eo6QjDqWjqaYkDx6uIrCyr7GxsCIQuCQQuSO9uL2/ER7DJBHHyMTGxyMSzhIl0CTSKdATHtfYI9na2NwiE9kUHuPjI+XkFOgp5hUe7iPu8u/08PFbFhYe+fr9+iT/plzwcGHgQIIFD4pQmAKDB4cQH0p0OIJiHREZtmTcokFDiY4pPG7ZsKEESZMeShaq4MByZcsRHKZ08DCzw0wRNmnqLBECACH5BAUUAB4ALAQAAQAaAB4AAAX/oCeOpAgAZSoGbFCyqzu2sijYt3CXum6ng1HQMySKisUSQbQkOD3OJnSpEhWuVQ82WzJ4vOBvyps9iA7oM8nMziJKb9J7zk2M7CW7XqXoi/x+JH0KKgsihiQLioiHKgwkjyKRkiOTIw0imJkempybniQOIqKio6WkHqclDx6srSKurLKwryMQIre4ubi2uiQRHsAjEcTFwcPCwhLLEiTNziXMIhMe1NXTI9YT1iXUFB7f3yLh4BTkJOYjFR7rIuvv7PHtJPMlFhYe9/j7+CT9Khc8XAgYUODAgiIQlsDggaHDhhAZjpDIRUQGLhezaNBQYmMKjlk2bCghMsVIFRxSFqJUKYKDB5clOniQ2UGmiJozc94UEQIAOw==",
        );
    svg
}

fn get_golem_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQdALf/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+aD/cwAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF/2AnjmRpnmiqrmzHvW+rAiI90rZcBrzZ6yaBSCAkdozA0QC1XCZFBBQhOpUVCh3s6SrCalMGgyjcIZdJ4nI4bTqUDm64SO7uyO11EqK07yD2fyJ/gYF+fSMJJYmJJoyIjyQKkQqSJ5WTlyMLCyKbnJwmoCSgoh0MIgynp6YmqiWrqyINI7Oys7Udt7i5tbsOIw6/vx3CwcQiwcbCJQ8iD88dzSbS0SPS1CMQ2tknECTb3iLhIhEj5eTnHRHpJOvr6iQSI/Ii8hL39fQd+Pr6HRMiJgD8F/DfQIECSSA0QYFCB4cQSzh8SHHExBUVRFTYqHHExo8ZM66wQMKCSZIiUDl2OKlSxQUSF17GfAkz5goMODGIyEkiJ0+dKTKQEJpBaAmjHYoWRaGBqYmmT1FsmEp1qtSqVJ8ACQEAIfkECRQAHAAsAgADABwAHAAABf8gJ47kCJxnqa5cILqjC7OrYKs3zQ7iwPscoK5EYBWLQ1KBVVg2aYYox8CSTq+qw+ig5Yq02y8XLEKUEGZ0Ob1ucxIl+BuekNfrcxFeUeLzVX8jgXwLJAuHLIUlh4oMDCKOj48qkySTDA0iDZmZHJ0knCWdDQ4jpSIOpaccqquspw4PIw+yshy1tLcitLm1HBAiEMK/K8DBI8bGEcsjESrOJMzQHBESI9YiEtba2yrc2xMj4Rzj4RPl5+ki5RQiFO3wJe0c8SPv8xUVHPr6+/37I/LlC8jCAgmDHBAmHGGhocISFyByuEAxIomKKzBoJLFRBAaOHz+WyDAiA0mTJEsXouSAMqUIDSxglpA5k8SGmzhxqsjJMwQAIfkECRQAHAAsAQADAB8AHAAABf8gJ47kCJxnqa5qwLkjDLM0Jwgqjtf0wA0+oEjIWxFYR4KyyCkUmjQnVMoyGETW6hVrzZYO34NYBB6Bx+SyCFFir90ItpwTH9VFiVI+j+fzR38cfAochCIKiCyGJIiJHAsjkAuTjyuQJZeVDCSbmxyenJ8loJ8NJA2mHKiqI6arrakiDQ4jDrYctLi4t7m2vLu5D8IPI8QqxhzIyMkjECLOHNAl0tHO1tYjEdkiEdrc3iXd4OASIhLlHOXn6Ocj7evtJBPzIhP1HPT48/Yj/DUUHACSEAhQoAiDNCqIqMBw4QiGEBUqrGGBhIWLFUVk5IBxI40LJC6AFAkypMgaGFIoYhChkoTKlitZZCAxM8PMEjc52LS5QgMLnyWABl2xoajRoiyOHhURAgAh+QQFFAAdACwBAAIAHwAdAAAF/2AnjuTInWeprirQuSMMs3QXBCqO17TQCT6gSMhbDVjHY1FFYBGaz2Wh0KGupiIqlmUwiLodcJjkDXfFpEPpoGaL3OqO+x0XIUr3DuK+t+/5eXqBCSWEhCqHI4kdhwodjiIKkiyQJJKTHQsjmgudmSuaJaGfDCSlpR2opqklqqkNJA2wHbK0I7C1t7MiDQ4jDsAdvsLCwcPAxsXDD8wPI84q0B3S0tMjECLYHdol3NvY4OAjEeMiEeTm6CXn6uoSIhLvHe/x8vEj9/X3JBP9IhP/OvgT2A/gCIM1KHRQSIKhQoYiINKoIKKCxYojLGqkSLGGBRIWQn4UMbKDyJI0LjOQuKCSpcqVLGtgmIlBBE0SNG/WZJGBRM8MPUsE7QAU6AoNLJCWULp0xYanUJ+yiBpVRAgAOw==",
        );
    svg
}

fn get_hippogriff_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmhqdiKbAioKezMa3HgQ6/wdj4KgsBQkngZI5HFAYoqcyhJhRKhaqVjPdFs1FQqnrwjsIXtRhrR6ZBC1PW/27zA60D30+120jyH+IggegoOBI4Q/Hgkii42KjCOLiSIKCh6Wl5SZmpMjCx4Ln6ImnyQMpx6nqiIMqayvJa0jDbQeDSW1t7YitSa6Hg4OwDHCw8YjxSIPDx7MP8zLzcrTIhAQHteJ2djc3SIRER7hJeMn4CblEhIi6yTtne8TEx7zJfLyJPUj9foeFCL/RlAICHDgP4IBCXqoIILhwgoOT0AcwXCiCQsiMGZEgVFjRw8WNI644IFkyZMnTEqiJKHSAwaXIl6+RCGzBIabMzN40DlCJ88TP0X85KnBQ9ERRY+a0KCURNIRGzxEhSrVxIaoV6dSHcGBgwevIrp+JQE27NhOaE+EAAAh+QQFFAAdACwAAAIAIAAdAAAF/2AnjmRpAmhqrqwYBC75vm0tCsKId3neDsBgBzgaFI8rgtJEEDU7T1JUVKgWRtYqddu5krwig2EkHpPMY/R5dWiP2u7OQS6a0+ssRAfB14v4e4F+foE2IgmIh4odCYwjjYYiCpIdCpOXJpORHQsLnCKenyWhmwwMIqcdpiupLA2vrx0NsiKztCS2Iw67HbwtDr3AwL0iwx0PyMeRDyPMzMojEBAd05vU1STYEREd3JHeI97gHRIS5DXl5eci5usjExMd8CTx8PEi8/jy9yQUFB3/+gXsB1DEv4MDO1RQSKLCwhUPGYpwSHGhhQ4XLWi82CIjRxEfLVzoMLIkyUgXUi+OJLESQweXMCO5fDmzRIYON3NGynCzhYYOP4Nas7GhQ9GjQ1tw4NBhKVOmSUeEAAA7",
        );
    svg
}

fn get_jaguar_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_kappa_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnqgIkKvXvmxKBrQY2LeX07lcCh6BcCgM+kqDpGiAYnqSzqOHMEVRqdJSwVPYjrrcrMkwMpjJIrR4dPC0S+33WoQYIe51+nyUECX+gH57IwoKJoWDIgsLKIt7DAwikJOTkpFZDSKZHg2dnpqgUg4joyelHqcyDyOrD66vrh6rIrMpECO3PrkeuycRIr+/KcHAKRIjxxLKy8zKHsci0CYTIxPWMtbUItolFCMU3t4p4eIe5SIVI+npHhXu7/Do7eokFh4W9iL2+Sb7I/j3RlzwMLBEQRQHBRIUgcFDQxMYIkqceKLhwwweMGIUkaEjio4bM4oMqcFDSZMnUS5qWMlyxEoRJVOW2HCCpgebM31w8LCTJ4efJH4C5UkURYcOHpAi9aE06dJEWUIAACH5BAkUAB8ALAEAAAAeAB8AAAX/4CeK3viVJ6mOqOkCwBh/sDjTt6sHwcf/P19PpxMIRkdi8mMkugaDT5QYhTqdhA8hO9pqr9fCqEAWi8xgneGzdq3baddhdKjPRfe4CSFC+P99ejoJCYOFgiYKCk6KiB8LCyKQk5OSkXEMIpkfDJ2emqBgDSajRKUip0QOI6sOrq+uH6sis0QPI7dpuR+7JhAjv79XwcA6ESPHEcrLzMofxyLQIxLTEtZg1tci1CIT3d7gYOET3h/lFB/oIuoU7e7v6yPo6BUf9Sb19zr5LvkWH/9cBHQycMQ/Cxc+JExo4oLDhxBdLFT4AUNFFxgsEsmI8aKTDCIyiBwpMqQgDRpcKqT8sHIEyjQbdMQcMdNETR0cPuTUyWGniZ47c/o00aHDB6NG0yA9mvRDCAAh+QQJFAAfACwBAAAAHgAfAAAF/+Anjh4plh+KpmPrfsAYw/MMv28gBjrv+x/eDtcSjIw45EdJFA0GHygO+mziCB8CdqTNWomFUWEcFpW/LsNHvWar2ejWYTT/1O1xF0K0H/X7eSMJCS+DgS0KCkSJhwsLIo8ukY5xDCKWHwyYmpedVg0toCINoh+lpk0OLaoOra6tH6ojsi4PLbZfuCK6IhAjEL6+TcHCH8URI8jKEczNzsofyCLSEh8S1dbXVtfY2tUTH+Aj4OJE5C3kFB/qI+wU7/DxIuzz6x8V9/n5+Dj4/P76PlgQ2GJgE4MiBiJscqGhw4eHRmDAQGRixAwiMmjcqDFjHg0aXIT8MHIEyC8bXiGkHLGyRcsXHD7ElMlhZouaM2PabNGhwwefPr8A/Rn0QwgAIfkEBRQAHwAsAQAAAB4AHwAABf/gJ4re+JUnqY6o6QLAGH+wONO3qwfBx/8/X0+nEwhGR2LyYyS6BoNPlBiFOp2ET9aV3V6JBVFhTBZ/nYZv+qw7jA5wt0jONiFEiLweX9clEn6AfSYKCk6Fgx8LCyKLjo6NjGwMIpQfDJiZlZtfDSaeRKAiokQOI6YOqaqpH6YirkQPI7JntB+2JhAjurpXvLs6ESPCEcXGx8UfwiLLIxImEtFf0c/OIxPXE9jYV9va1yIUHxTi4+Hk6Onh5+YVH+4m7vA68i7yFh/4LvpO/CP4Fi58ECjQxIWDCBO6IDjwAwaHLjA8JCIxIkQnGURk2Mhxo8Y+GjS4EPmB5IiQZzYi6FA5gqUJlzo4fJA5kwNNEzZpyrxpokOHDz9/ngkKVOiHEAA7",
        );
    svg
}

fn get_nemeanlion_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQZAPr/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAZACwAAAAAIAAgAAAF/2AmjmRpnmiqrmzrvnAsz/QJqEGe5cGuoz+TQJAhEkXG4pGUNA0Go2cUKpKSqNQSIUPYcr/crVcrLhUyhfNILUqjUWe2yJChG+hzez2lHx0yfyIHf4OCg4EnhCQICCuMjSiNkBkJlCOVIpiWCZycJpWaCgoZo6SiIqOnJKKnrSMLGbCvJLALsia2sSMMGbwMv77AvcMpvCQNyBkNJcvIyynPJQ4k09Mj1inYJA8PItzf3t0j4tspEBAl5yLo6yfsJhEZ8fPyIvEj9yT5JhIZEv/+/vUTOBDgCIMnJoxQmGGCQoYNI5aAOIICBREWMV68WFEjxwwfRVQQOVJkhgolSS6iHLEypQULImDGhClzJs0SNzNc0KlzJ88LQEnsDDoC6FARGDIkTSpjqdIaLEIAACH5BAUUABkALAEABgAfABkAAAX/YCZmAECW56iuo6kGQRaLMcze8iwI2b73PiBOxRMMjgNVcoRc4pZJQkZKkIqq0+wwKy1kCt6vFywCk4djkcGwXa/bGfYhMxfV6aP5naUfIRAZgIF/IoCEf4QqhiMJGY2MKo0JjyKTk46YGQqamgqenZ+bmzehIwsLIqgqqqdbGaojDAwisrW0s1u4Kg0rvLuuvisOI8PDIsbELMgrDxkPz8/OIs3TN9QrEDfZGdsi3SPfKhEZ4+Xk5RHp5yvqOBIj70PxKvMqEyP3GRP3+fr+K/1EUKAgkGCGgQdVGBxoMOGICiIqQIyYQaIKiRYjQpxowYIIjx89ggwpckXJCxlQGF5AmTLlShUqWYpYqTIDBps4Xd24yTNDCAA7",
        );
    svg
}

fn get_satori_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/4r/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRpnijppSwKvCLwyW0tBsGHj7ltCoJPEAgU+kiDUfIzaDqZxxGB8JlWp1hrVFQofLpgbvcLHrMM6DSalDYZWof45zAX0efy0h2F6JcQI32AJoMmCR+HIomKigmLJI6PIgoKkyOUmJQflSWcmiILHwuhoKOio6gnpKAjDK4ir64MH7KvJrOtIw27H7u8Dbq8JsAnDsYfxw4lxsfLJw/Q0SUPH9HUzyUQIhDc2tsf3dwp3iIRJBHo5h/p6OvqJu8fEiUS9fb2I/Mo+h8TJhMAA/YbARCFPxEUUCRMaIKCw4YjKmz5UEGiCYsiLETReILjiAsmQKIQGbIEBhMnUTCkNGkiwwmXImB+kFmCpggNJ3Ca0FmCZ4kNJoAGPSHUBAejRo+WUHqiQ9MSTqGiCAEAIfkEBRQAHgAsAAACACAAHgAABf+gJ44iQJ5oegasGHivKquC4NWjPcvD4Pm93m+XIoyMHoJymSSiCgUPVAqtTp0ng8Gj7Yq8Xe/sQC6TSWXUYYdoexBvEfztPsHbc1Jif0qM9n4ogR6AIgoeh4YkiQqNKYkjiQsLIpSVk5iUliebIwweDJ8ioZ+kpCqiJw2rIqyrr7AqDSkOtR61uA63uSq6KA/AHsDBIsPDKQ8oEMvMyyPNzioQJBEiEdfYHtjbM9UiEiQS4uPk4OYq4CITJxPt7u4k6yryFCgU9/ge9SP3KvsVKgACTFGhIIqBFrCcsJAQRcMLCkdATDHRAwYUF2dkxDgiAwqPM0CeEOlBQwqTKlAkolDpYUMKlyNgipBJgqYIDihwqtB5gueIDiiApugglETRESEAADs=",
        );
    svg
}

fn get_sprite_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF+6AnjmRpnmgJeMCqrm5qBh5dkzZty7Ig+rzTADX0FE1HE4GQWjaZqQKqID1VUwbDSevhlrK8w0nsIZfMMgRJXWKL3LJEojSXe+Yke9CjKPX5fnsjCyKEhoYehImCHgyNjpAikQyRQQ0kl5cjmZiMHg4ioCOiop4mDyKopjIQIq2rJxEiEbIetbAeEhIiu7m8vaYTI8ITxMOmFCPJyR7LyowVItEe09LW1IIWI9oe3N7bexci4h7i5Obj6TwYHuztKO7s7jIZHvX2Ivf6+fgyGiT/RAQM6IFgQRkbRGxIOIIhQ4UOeXDgYIKiB4skJsro0OFExxEfS3DE5SkEACH5BAkUAB4ALAIAAQAcAB4AAAXuoCeOHlCa5FmmrBh4L0zGb9zeniDqeDrcP0+QNRwRPEcWIZk6MkmFWyHaorIMLaxHm+KmDi2wR/zFIUjnVFq0ZiUSKfjbAyfNcYpU3rMf9XELIoGDgx6Bhj0eDIqLjSKODI43DSSUlCOWlYkeDiKdI5+fmywPIqWjPRAiqqgsEREir7GwrRISI7ceubq7OBMTJMC/HsAjwzcUI8nLIszJzS0V0STSLNUkFiLZHtvd2t/cKRci4x7lJOfl6iQYIu0e7/As7/QjGSn39iL5+/geGiQ0AAwoYuAIgQQ3KNzAgqEIhykWQhzFodWoDolCAAAh+QQJFAAeACwBAAEAHgAeAAAF7qAnjiLgASZ5mqnqioEXy+Qcz28+CiKv6wNX0DMkFXUEgiu5VP4KuQL0Nc0ZDC6sR0u6/g4vsEesIucQJLRKLWLnEglVHO6Jk+g/j0K11/PzIwsigoSEHoKHgB4Mi4yOIo8Mjz8NJJWVI5eWih4OIp4joKCcLg8ipqQ/ECKrqSQRsBEisLOxeRK4uCoSIrwkuboiE8MuE8IexMbIxcMUJBTOI87R08/RIhQVI9ok2twi3irf2hYuFuUi6Oge5+YjFxci8CrxHvXv9fMqGBiuHvyuMogQ6O+FBhEHC7rYIIKhQhUcRER8OKIDCYt5QgAAIfkEBRQAHgAsAgABABwAHgAABeugJ44eUJrkWaasGHgvTMZv3N6eIOp4O7A/T5A0TBE8RxYhaUS2CrcC9HkztKwebEqbOrS8HnAXhyCVU2dRmpVIpNxtj5sUxylSd09+tMctRH+BgR5/hD0eDIiJiyKMDIw3DSSSkiOUk4ceDiKbI52dmSwPIqOhPRAiqKYsEREira+uqxISI7Uet7i5OBMTJL69Hr4jwTcUI8fJIsrHyy0VzyTQLNMkFiLXHtnb2N3aKRci4R7j5Czj6CQYIuse7eoj7fIjGSn19CL3+fYeGiQa/v6JCDgCoMANCDe0UCiCIYmEDntwWHWoA8UQADs=",
        );
    svg
}

fn get_wraith_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQdAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF/2AnjmRpnmiqriUAnO/osmMgBjhp72VOiwJSMAjsEIujwUmp7DBFg6eKMKISqJ0ryVrClgokcAGcIovGJYNI3VGzDW/2uv0mHTr3Q150x/f3eioII4MdhQiDiYc/HQmNIo6Rj5KPKQoKIpiYI5sdnZuaKQsLHaSjIqSopammpScMHQyyI7Cxs7WxJbgdDQ28v76+IsIjxMPBHQ4OySTLzszPycsi08oPHdfYJNfc2tzZ2SLcEB3k5SfmEObl5OvpHRHwK/ER9CL2I/GMJRId/f8i+tGYMCFFwQ4HWVDosJBhwxMLH66o0KECxYoXRVDcyMJCB48eP4L8OGJkSBUXOi+kVCkipUuWK1lg6DDzRM2ZN2lkQLEzQ88OOxlpQDG0Q9F9GzokTbqPBoemUJuGAAAh+QQJFAAeACwBAAEAHgAeAAAF/6AnjmJHnp55qijguYArwjMZo2SQj4Gui78dTiTwCIpIYpI49AycT1FUSh1NcQQPITvkarmEQmE09ozLYlFabVaXPQY4PB6Xz0X1eZ50GB36fn2Cgh6ATR4IIomLiI2LiYcJIpKSI5UelwmXQwoKHp6dI52en6WHJAsLIqonqqyuhwwMIrO0OLO4OA0eu7u8v70iviMNwx4ODsfKyMvLyckizMkPDx7VKNfU2dYi2Q8QHuDhQ+AQ5ePi6BEeEevsp+3r7u/uEiL2p/ceEvwk+E0TJgAUIdBDQRQUPFBIqJAhCYYOD1UQUWGih4oXR2C0iMOCB48eRYD8SBLkyCEXPDCkFLFS5cqULXFg8DBT5ggMM3PSHJIhX08PP3820ZCv6IgNHjYgRWq0KIcRT5uKCAEAIfkEBRQAHgAsAAABACAAHgAABf+gJ45kSXZmSgIqu6pwIAb0KHtybsOjIPSinxA4TA1Mx6MnKRowSUoRYUSYVqVTqicrNRW8nsJXNR6JSYZR2pNeG9xrtlsU9xzs9vsdnxfp/Xt8IwiDIoQeCISKh4c8IwkekJGTkJWTlyoKCiKbmyOeHqCenSYLIgumqaYeq6ysq6muJgweDLYjtLW3ubUlvB4NDcDDwsIixiPIycMeDs0kztHP0s3OI9bODw8i2yPb3x7g2tzk4Q8QHujoKesQ6+nqJOoRHvSO9BH4Ivr1+x4S/wA6GgGw4D+CAwdOELEwoUMRFDxEfFihAg+LFhNa8LCRY8cSG0M6vODhAsmSJUg4qkQJA4MHly5fwnxJc2bCDB5w5hSBs+dOnzpVaEgx1EPRoUgHbvCwNMXSDU+ZOuQggqoJq1ZVhAAAOw==",
        );
    svg
}

fn get_yeti_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUfAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRpnmj6ASyrvmUgzwEMCziZ2+kwmD8eikAQFY9CVKFgYiZNhqhU+jQdrofRtSpCeL9gcDJBLpvPZZtizW673a+FXF6a1+0ohn5vYvT5Jw2Cgw02hCgOiYoONouMJQ+RkpIiD5CVk5YlEJydH54onqAkEaWmER+mI6giqqesIxKysxIftLe0trkkE70fvr3BwsO/wiUUyBQiycwjzMjL0CQV1NQf1dYm2NfVJRbf3x/gFing4uYkF+rqH+sv7OsXJRj09B/1L/b1GCYZ/hkf/r3wF1BgCQ0jNChEqELhh4UMSWwYMXHDRBUWP1jMaIKDCI8cQpLwOBIkSZIlOhh0EKFSJYqWH1ayVOGhps0SNm96ELHzQwgAIfkEBRQAIAAsAgAAABwAIAAABv9AkHA4/BiPxKRSCWg6m8soMUANDKtSqWCb5GaXgzBoMB6Tv0qCOrlGJwvwuNydNNjtwvudfuj7/4AHXwiEhYaHhVIJi4yNjo5LCpKSSZOVlkQLmptKC52cRAyio26jokQNqapuqqlDDrCwILJCDkm2srG2IA+9vrwPUr3AvxDGxxAgx0PJQsvGyskR09QRINXY2ELUIBLe393f4uPe4eUT6Okg6epC7Ojr6hTzIPTz90n39vgV/RVC/votCQiCoIWDB0EgtCAFoUKHFyJGBCHxy0SJF0Bg2LhRY8csHTliAJGhZEmSJ7OcTJlBg0uXIF5+galhSM0NODcIyZkF584lnxyGBOVANKhQoUSFFBXSYUjTDlChJokqdYkHIR6yat3KVWuSIAA7",
        );
    svg
}

fn get_bear_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+Yr/cwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF9qAnjmRpnijadeSankAMjLMn17Utm0HvBb+RTwgUAY9DkcCzXDKVz6dzKiUNPNcrdisaaLfaLHdE8JTLZrRaRFifX6SCqECXe+zwkYFk2Hv8gH4igigHJYaHiXkIJowejiWQKQkoCZQil5h5HgoKIp4moJyimwsLHqckqaabJQwkr68isa0kDSK3Hrm2tSQOJr++vR4PJcXGwx4Qecu9ES/PHtG9Eh7VJNfV170TEyLeJt3DFK3ktRWt6K0WveybF7XwrRgnGPQm93AZJ/se/ST/4GjQQGKgCIMjEMLZsMFDQ4YmID5s+IKDB4scLKbIeLFjsmQhAAAh+QQJFAAdACwCAAIAHAAdAAAF6mAnjiQAlCeprmMgBrDbyawo3AJ56/mI94NgZzAcEYlFZHIYJHSczqdURIhKo9BnobPdcgvesAgs7nYM57QIfTa41yO0vCY61O+dg53eQZD8fiqBfywJhSKGK4ksCoyNIo+QNQsklCuWHQuYLAwMI54koJ18JA0NI6enIqmkIw4irx2xJLOtDyu3JLmkECq9vq0iEa3DrRJ8xx3JrRMdzSTPzc+tFBQi1ivVwRXBHdykFt0d4XQX4h3mdBgsGOsq7jUZLPId9CT2LBoaJPoi/SP/WGzY0IHgwBUHDRJcwaFDQw4N6UB0SFFECAAh+QQJFAAeACwCAAEAHAAeAAAF76AnjmTXlSepriMgArDryWwtBgGJ26PgCyQg0CMM/kSDpGewRI6UziYzOSB4rNardpvFiryEgkcsHhfK57MovR67DR44XDSv00fyOM9zWPX7PAgkgoIqhYMsCYkiiiuNLAqQkSKTlDULJJgrmh4LnCwMDCOiJKSheyMNDakeqyKrrqgOIrMetSS3qA8ruyS9exAqwcKoIhGox6gSPMsezagTHtEk09HTqBQUItor2cUVxR7gexbhHuU2F+Ye6jYYLBjvKvI1GSz2Hvgk+iwaGiT+RAQcMZDFhg0eEB5csVAhwhUcPETkENEGRYkYRYQAACH5BAUUAB4ALAIAAQAcAB4AAAXtoCeOZNeVJ6mKQAuMr+fGseyKQe4F+6j7PFwvFxB4jMajKElKOpWCgUcqnVpFg6q1SrUSPN+vSEwej8Lg1ahQELHZ7rZ6ZFDVPfe8fXUg9fsqgH5qCIQihSuIagmLjCKOj3MKJJMrlR4Kl2oLCyOdJJ+ccysMDCOmpiKooyoNIq4esCSyrCIOK7ckubUPKr2+tSMQwcPBEazHHsnBEh7NJM/Nz8ETEyLWK9XBHhTb3MEV3uGsFt4i5aMX5uqsGGoY7ivxahn0IvUq+HMaGiT8Iv9GBFSzYYMHgwVXJERocAUHDw85PBwlEaJFESEAADs=",
        );
    svg
}

fn get_bigfoot_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_fairy_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQdAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7or/c4xz9H9z+QAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF/2AnjmRpnmg6bmrbAh3sjkFN1sHd5bMw+h1gUOQrugYlJHK0VA6WKYJJSqJ2CFKsqnDikrydglicMqDMI7TIYFabDin4SC4X1U2IVF60z/tJeyMJKoMig4WGiYgiCiqNHY+RJI8lCyqWC5kdmiSWJwwMKaGjHaEkpigNqicNI62trjMODiS0Hba3tTMiDyS9v7+8Hb0qEMYjEMjJyscoEc8k0NAdESfVJhISJdkd2iLe3CTeJBMm5R3n5eci6+glFCbwHfD0IvIuFSX5Hfv5/vwuLJCwIHBgB4EIZ1wYsfBEww4PXWCYeILiCAy7UmTIUIJjxhMaSmgI+fEEBxInSwaqXMmyRAgAIfkECRQAGwAsBAACABsAHQAABfHgJo7kBpQoGqxpsLlpKYzzJtR2HotDOfQbYHC4I6CMIqOSgEwVnKLnpvCkxgwp7Ea7NXi5pUNKvCGXxeYSIrXetNsieCmRotM3dvxuo0D1+YAjfzELCyWGhhuJiYo7DAwjkI+SkCKSew0jmZsbmZp7Ig4joqEbpKV7Dw8iq6usJK4xECOzG7MQt7QxEREjvSK8JL3DJRISI8YbycrFxscjEyTR0SLU1CXXFCTa2hvcIxTd4CIVJOXnG+Xpe+UWJBbuG+7z8jvuFyP4Ivj8G/qgGAKWwDCCIKgYGTKMUHgQhQYNIx42RMGBRMWJoDpg3BACACH5BAkUABsALAcAAgAXABsAAAXQ4CaOG0CeaLoFaioIKAy32yDao63TxEj0ot4PmCqMjEZRAZlEGUbPJ9RAlZ4OJCx2dNCqECMwWDQmpxKkBFqEbrcUIzh8MxfVTwtSPr/h80d/GwwjgwyGgoMkhSQNDSKOkBuOJ5MnDiKXmBuZI5wjDw8boaKfJ6MbEKkkEKiorKwisBsRJ7QiEba3uhsSJBK9vyK9vsAbEyPHxyLKE8rLyhQi0dEb1NTVJNcVFRvc3t3gJ9wnFhvl5+Yp5SoXI+00JxgYI/PwJBn39icaJPz6IQAh+QQFFAAcACwEAAEAGgAcAAAF7SAnjiS3lWgJrCnAuSkZjDMX1HYec0Ip9LxRD5gaoIwio3KARBFST06U8KSmClcRVlvobkuGVJgzJofLpENKzWGzRW8SIjWfc+wifCmB4nP4fiKBgSIKCiWHhxyKiouOJQsLI5KRlJIklykMI5udHJskoDENDSKlphynqDsOIq0cr7AksSgPJLa4uCO2JRC+IxDAwcAcwcMRyCTJyRwRJcjOHBIlEtPTItfV1CITJN0c393f3N4cFCXn6eYi5ynnFSTw8Bzy9PY7FvkWJPv9HPs7Al4YMTBgCgwIR2AwmCIDiQwOGZbQQIKiRA4hAAA7",
        );
    svg
}

fn get_gnome_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQdALf/c83/c+T/c/r/c//3c//sc//ic//Xc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/6D/c//Cc//NcwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAdACwAAAAAIAAgAAAF3mAnjmRpnmiqruzGviYAz11g06+g4+vg+7wUYTgMogpIpNFkaDoNy9FhSqVGryiOdsvlLhEdcHgcTZg757NRoeiw3/D2bEEf0e93UX7FODH+gCZ9KQ0oDYeIJ4UoDg4kjiKNjZGPkCYPmA8imCScI5odmaAlEB2lIhCnKKqlqiURI7ARsCeysSkSIhK7Hbm7v769ub0qEx3GyMYlE8rILBQi0BTTHdTT0jwVHdonFdw8FioW4TgXFyPm6eci6zMYIxjv8h3v9DgZIvgdGfwj+vowNHTQIFBEQYMED5YIAQAh+QQJFAAbACwCAAMAGQAdAAAFyOAmjqQIlGiKBmqLCrArb0M9t0Se32nh+zyUYTgMkg7I5MG46TifT6aUhKhar1deYrPleoOK8EYsvi0Wm7N6jW4xGKO3XC6Cpxqohn5P0pccKQ6CgyiAIg8liIcPjIeJIhAQJJIjkZOVkhGaESKaLpwbmxESG6QjEqYopKarGxMjE6+yJLOvIrYUIhS7G7y7vrm9uiMVG8XHFcXEycbHJRYi0NIbFtPVNxcuF9kuGBgk3t7gLhkjGeXo5SLqKhoi7hsa8u/w8BshACH5BAUUAB0ALAIAAgAZAB4AAAXKYCeOpLiVaIoCaosGsCt3Qj23Q57fKeH7PFRhOAySDMikwdg5OJ9PppTEqVqvVx4CtQ0mvh0wmKfoKM5o9GyxELHf7w5bxWCU6nj7qF5qpBqAgSh+Ig4tDoiGKYoPDySOI42Rj44QlhAili6YHZcQER2gIhGiKqWgoBIjqhKqKayrIhOyE7O2tbgdt7IjFB2+wL4lFMLAJRUiyBXLHczLyjIWHdIpFtQyFy4X2S4YGCPe4d8i4yoZIxnn6h3n7C4aIvAdGvQj8vIdIQA7",
        );
    svg
}

fn get_kelpie_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XP/c3Nz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnigJpGwaiG8ZB3FLCqKAj3tvkwNRMOgZEn8kgofAXDaVIyjSUyiYqtbqdGRIGbqe7/YwIpcOZk+6hRi1PW83Yg63JU730j1vU5QUfid+gTYLI4YpiD8MIgyMjZAkjI42DQ0llx6ZJJZbDiMOn58eoqBIDyKoqB4Pq6mqrC0QHhCzsyK2tCO5tycRHr8iwcHAwr/EKRISJMvLI8rO0C0TEyPV1SbU19QpFB7e3+HdFOTl4CMV6SIV6yXq6Ozv7CMWFvQe9iT5+fT1+ycXPARMMVBEwIMCTWAQsTBFQw8YIkJ8SCKDRYstLnrIsHEjRxIaRGgIiWIkSA8kUR2W2MCSxQYRLz2wbClzywkOOD1wELHTJpIOPm2GAAAh+QQFFAAgACwCAAAAHgAgAAAG/0CQcCj0eIjIpHIIADWZQoB0uQwIA1ZQNktdCoTfMOjbXQ5AgzRafUaXkwQCXCh/IwvJgh6E39tBBkOBgoGDfwdDiEgHioiKVAhKkUMIlSCTXQlICZqbIJ1vCkOiS6RvC0ILqKhLrKxUDAxLskOytG8NRLlDub27XQ4ORMJCxMXHVA9DD8rKIM5Czc/P0EMQIBDZQtfb3NzY4OFDERFI5ULl5Ojp50oSRO8gEvFC9O/zShNE+iD8+xP8AAJEQqHgEApCECopyJAhkgoVhEQEMXEJxIgQKS6xAILjEAsglYD06BHJBSEnQaRUaZLlyZdJMMgUgoHITJo1b9ZUkiHDkDaeRID6HNpFgxCjVIwiBbE0yYanSJ5uGDJ1KgirVt9wGLK1K1chW/90GDIWRFkhHc7+UfJBSRAAOw==",
        );
    svg
}

fn get_leprechaun_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQXAP/ic//Xc//Nc/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz///sc/+3c//CcwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAXACwAAAAAIAAgAAAFkeAljmRpnmiqrmzrvnAsz3Rtx1Ve3STQ86IASQgUGI/AZMnCbDpvA1P0RqiKqgRewbTlGb5g4GEsGh9uCBFinb60Z4lLPEGfy2mKiyK/1/NpCxeBgYKFhDMMiReKiQw3DQ0kkDwOJpU3D5mamTwQIhCeF6E2ESIRpReoNhIXrK2vNhMishe0tDQUFBe6u7u8KSEAIfkEBRQAFQAsCgAJAAwAFwAABXBgJVZACYxokKKigLrsJc9szQ54ro9E3Y+FSlBIHBlqR9RhyWQhnqInYpQQJa7VSlVR4Sq+3u6ishiXyWZGRa1eu9WNeEUeb4wcDhQe9aj1RxCBgoEoESIRhhWJIhKMjRWPFRMik5KUIhQUFZqbm5ohADs=",
        );
    svg
}

fn get_mantis_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_ogre_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAHP/c4r/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgsCgFI4xAJUDqFAVBgGoVSpU+noCjocrPKwYAoFo7FY7CRMCS43SA2W20sFEB2vPCepxsNBkOBQoB+SgdEiEOKfgiOSghDkYYJlZVGlyAJhgqdngpGoIYLC0KkpSCkRKioTwyvILAMsbOvs7F0DbpCDUW9uru9YA5KxMRGDsdPD0bMziDMRdHRRRBOENjYStpOEYZFEd5KEuSGEkTlRhMTROxZ7kLrShRF9ET2Q/ggFPxFFf7+KvwjMhDEv4IgLBCxwHChwoYLhTRUKORCEYsVL2AEoRHjRo4ghWAoMhJESSUlT448CSLDEJdKYBqBmUEmCA1DcH7LqUGnkDUNIIAC/TlUyYaiSIVwALGU6dKmYKByeCqkAwirWHdeHWIVhAevXr9qBUsWxAezaMd+WDskCAAh+QQFFAAgACwAAAAAIAAgAAAG/0CQcEgsCgFI4xAJUDqFAVBgGoVSpU+noCjocrPKwYAoFo7FY7CRMCS43SA2W20sFEB2vPCepxsNBkOBQoB+agdEiIZZCEONiwmRQglEkotCCpmZSgqXIAugoQtGo4YMDEKnqCCnRKtqDbEgsg2ztbG1s0K5Tg6+Qg5Fwb6/wSDGSg+XD8pZEE7Pz0oQ0koR1iDX2kYR10oSEk7g4+LgRhPohhNE6UYURe9E8UPzIBT3RRVG+kMV/vn9QPATYsFIwSEWCiYscnDhQRAXiFyIKGQiRYgTK0qEOARDEY8gQCoBKdKjSBAZhqRUstLIygwtQWgYMtOTTA01hWwAsXOnTjCfSjYAHSqEAwijR40iBbOUg1IhHUBEneopKlQhHkBk9ZDVZteuID6EHWvzg9khQQAAOw==",
        );
    svg
}

fn get_orc_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_pixie_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQbALf/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9KD/cwAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAbACwAAAAAIAAgAAAFuuAmjmRpnmiqrmzrbkD8tkEg2nMqiPuerwNR8JciiIxEU2FTaC6XSZLBsKFSo6WD9tDithCITXg1diUSLHRLoRixU23WYr6ZL+p30j2/Yvg3DCOBgCWDKw0NI4mLiIgijokrDiSTIg6Vl5kuD5wiDxufnyOdMxAQI6enWCURra2rJBKxsBsTJrZYFCMUuhu8URUiFcEbw8JJFhvJJcnLPxcb0CXQ0kQYKNdJGRko2z8aGhvhJ+HgtOewIQAh+QQJFAAbACwFAAMAEgAbAAAFouAmbkA5nqgYBGqaCiIMu+4g2jRKiLvbbwVgYQhMBUeGpDJlSB2eB1cUhUBsrCksKpFwdU8KxSg83ohHi8UmrU6j1SIGYzOP2+V0UUO/2Tf+gHsiDiOEg4YOhiIPI4yOORAQIpIblDQRESKYmzknEp6dGxMpozQUIxSnIqopFSKuG7CwKBYitba4KRcbuye7vSgYGCnCNBkuGccpGhouzcwoIQAh+QQJFAAcACwDAAIAEQAcAAAFriAnils5nigHACKLumPAyTJao4KYnzs6iL9TcETgEI7Fokh5KhQ4z+dIijJYDdUU53DYorpaBCI1PiUSo3NaLVIoOO63e/QeLTh3Uf6+yHMYDH+CgISAIw0iiImIDYoiDiOQkloPDyOWHJgpEBAjnJ9aKBEno6EcEimooRMirK2hFCKxsRy0KRUcuCK6uigWHL8jv8EoFxzGI8bIKRgYJ82mGRkn0qEa1ycaHNgiIQAh+QQFFAAbACwFAAMAEgAbAAAFqeC2ASNAimiaBoHYqjAqbHMcDyJuq4TYx79NQVgoCmFDlMGwYTJVz9RheohVVQjERgvjqhKJWDilUKDK540ZtVhs2u422y1iMDb3ut6OFzX8G38Ng4R/Ig4oiIeKDooiDyiQkjsQECKWG5g2EREinJ87KRKioRsTMKc2FCgUqxutNhUishsVtLQpFiK6uRu8KRcbwSrBwykYGDHIMRkZzM4qGtIxGhvTKCEAOw==",
        );
    svg
}

fn get_rat_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQeAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+QAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAeACwAAAAAIAAgAAAF/6AnjmRpnmjqAYDqmgEZo/M7CiKOl8JujwNR0DMUDoo/AknpISidzl9hSqKKqNYrysAtGVJfUdh0OJBJ5lI6XUIgTO+2mzT3xEeJU76UyO9FfR5/CgonhYaEhyOKHgsnjj8kkAwelCWWKgyYIpYNDSWeJp8kox6epyIOHqqpKKyrrA6xqyIPD7W3Kbkjux63uRAeEMEkxMIjxscoEREezSXMIs/PzioSHtcn2dgi290oExMp4iLhHuTn5icUKewkFPAe7vEmFSn2Ivb6I/smFin/RvwL6CEgQRIXUiRMqBAFBhIPRUT0gGHijwwlMmg0gbGjDQ0nNIAkAbKkjQ0bTBygRFkiZUobHGLK5OCBJs1ILjp46KBTJ86fLkIAACH5BAkUAB4ALAEAAQAeAB4AAAX/oCeO5AgAZaquZMC67Cp4cynUMTmIu9fzg19ORBgVPYRiMjkcFZxPUeE5JUVThuzIwOKKvKXDIUwakz3mEQKRYpfWbtFaLkokVPfS3U7i3xUKKoGCgIMjgwsqiU0lCwwejyWRMQyRlZUNDSWZKZoknh6aog4epCKmKagOpqunpQ8PIrAxsSS1JRAeELkkvLojvr8pEREexSXEIsfHxisSHs8q0dAi09UpExMs2iLZHtzf3iUULOQkFOge5ukkFSzuIu7yI/MkFiz3I/f5Hvn8IhdYBAwoMAUGEgdFJPSAYeGQDCUySEwBsWIODSo0YCSBsWOODRtSgARZImTIHBxSEKrk4IElS0YxOnjoIFNmjhAAIfkEBRQAHgAsAQABAB4AHgAABf+gJ47kCABlqq5kwLrsKnhzKdQxOYi71/ODX85DIBWJRYLyOCyQCk4R1DMdRVeGURarTR2+39GBNC6VyyIEQrUuqdvp9jqRWNVLdM9dlK8rFCqAgX+CI4ALCyqJQykLDB6PJZExDJMiDA0NJZkpmiSeHpmiDh6kIqYpqA6mq6elDw8isDGxJLWyHg8QHhC7JL68I8DBKRERHsclxiLJycgrEh7RKtPSItXXKRMTLNwi2x7e4eAlFCzmHugU6+ki7CQVLPEiFfXzHvX4JRYs/DEW/khcYDFwIKMRGEgkFLHQA4aGQzKUyEAxhcSLOTSo0KCRhMaPOTZsSCFSZImRI3MTcFjJkoMHly4PxujgoQNNmjlCAAA7",
        );
    svg
}

fn get_skeleton_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

fn get_spider_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPQfAKD/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/4r/cwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAfACwAAAAAIAAgAAAF/+AnjmRpnmgqemzrqfAIzHQdp0Gu7/ltCsCgUCAi+kaDpFIpWh4/hKhUCp1Gj4WsNvvZem+GsDj8GRtE4tthzT582u71201CnBD4/CeP3+vtIwmCJYKFhoeIIwoiCospjZCRkSULIguVlpeXI5qbnCUMoSKioaWlI6IfqSUNHw2tIq+yr66wI7O2JQ4OH7u+u728vCLAwcUfDyUPy8zIyyTJJs8iENUf1djZECTb19Yj3yUR4+QmESLk4yTqHxLuIu7vJRLw9PX27R8TEyP8+yL++AE0sU/gBwoURiRMeFAEQoQHHzJUyLACiQoWL2LEOGIjx44ZSVgYSXLkB5MnSEaOQEniwocLMF3GFDFzRM2XJjBgIKFz54eeOksETZFhRIajJo4iNVo0hYYPGp46jUqC6pMTG7KS0HrVBIevJDh0PdGhQ4kQACH5BAkUAB8ALAAAAQAgAB8AAAX/4CeOZOmdqFeu7Aq8cNzOZGDfuE3PQu//AlFwtxoYj0cRkkgiOJ/PDzTK/BSu2Ks1m2UavuDvJ2wQgZmHtPrwWbPTbTYJwULY75+7PY+njxKAO4CDhIUjCiIKiIeKioyNkI4kCyILlh+WmZmVmyOUJAyhIgwfoaaioqWkqiwNHw2ur7CzrrCvJLSxKw4OH7y/vb8lvCLAIw8kD8rLzCXIK8ojENMi09YQLNgf1iTULBHgEd8i4eAk5h8S6unpEiLu6+7tI+ry7BMTIvn5H/z4+PpW/BtBgQJBgyQKKvygsGAJhx8qkKhAsSLFiBJHWMwo4uIKCx8siAQ5skVJESJXQVy4QGIlyw8uX4pwOUImCQwjMOgUobMnzps/Z2T4kGEoi6JFSSStMkODUxJPmbbYQJVEVaksOGglwQFriw4dSoQAACH5BAkUAB8ALAAAAQAgAB8AAAX/4CeOZOmdqFeu7Aq8cNzOZGDfuE3PQu//AlFwtxoYj0cRkkgiOJ/PDzTK/BSu2Ks1m2UavuDvJ2wQgZmHtPrwWbPTbTYRQa9/6vS7HVFKEBOAgYKCJAqGCoWHiCKKjYYkCyMLkx+TlpYil5orDAwinp2hnR+jpKWmJQ2qDSKrrh+qsCSrLA4iDra4urm4Jbu9JA/BD8TFxSXCI8YkEM0izdAQLNLT1BErEdnX2CLa293XEiIS4uXiH+bo4+TsJOQiE/Af8fPwE/fyJPf09RQUIv5K+Bv4YeC/EQQLVqgwYqFDhx8Wkng4keEHCyUwWtioceMKjiQ8XihxYeSIkiZRPZIoufIDhhUvRWCYKXOmzRE0a7bI8CEDTxY+f/YUKrQKCQ1IR2hQapTFhg0jnjalwYHDiKpTW3ToMGKriBAAIfkEBRQAHgAsAAACACAAHgAABf+gJ45kCZwoUK7sGrxw3M6kYN+4Tc9D7/8DUXC3IhiPRxGSSCo4n08PNMr0GK7YqzWbZR6+4K8nfBCBmYi0GuFZs9NtNilBpCfudw/eTlL4FX1/gCKChX8jC4gLiYuNjSKOkYkkDAwilpWZlR6bnJ2eJQ2iDSKjph6iqCSjLA4iDq6wsrGwJbO1JA+5D7y9vSW6I74kEMUixcgQLMrLzBErEdHP0CLS09XPEiIS2t3aHt7g29zkJNwiE+ge6evoE+/qJO/s7RQUIvYl9vse+/cj/PpVqDBioEGDHgaSOLiQoAcLJCxAlChRRMUSFCNCvFCCY8cLHEF6FAGSBEcMJVA3ksDA0gPLlypdxmy5IsOIDDZr4ryZ00PPKiQ0CB2hgShQFhs2jEh6lAYHDiOeNm3RocOIqiJCAAA7",
        );
    svg
}

fn get_troll_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPUgAIr/c6D/c7f/c83/c+T/c/r/c//3c//sc//ic//Xc//Nc//Cc/+3c/+rc/+fc/+Sc/+Gc/96c/tzevFzi+dznNxzrdJzvshzzr5z3bFz46Vz6Jhz7oxz9H9z+XNz/3P/cwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQJFAAgACwAAAAAIAAgAAAG/0CQcEgkfo7FpHIpBAydzGgyMJVaQYKiIHuNDoTfcDdKABHKwrJ6TCwk3aACnA0yCO1FvB3fPYD8QoBFglEIIIaHQgiIiESGjUsJIJJJlJVRCiCZRQqdTJtMCwtXo0OjpUsMIKpDrEWuq0sNILO0RLVJuLhJDkO9Qr0Ov0TDwUoPIMjJUcrKy0oQQtHRTNQg1NZDESDb20LeSt7g4EQSQuYg6Erq7EkTQu/wTPEg8e/0QhRD+iD8/Er+mFQAMZAgkQoFhQxMmDCJBQtDIBaRCELiw4pdLhDRqHFIxwsgrWAAMVJISZIm6QjJAIJlSyIuXY7RIIQmzSE3QeSkswFETx4iP3/S4SCE6BKjYzoQUboUBNMxHkBEnUqEatQlQQAAIfkEBRQAHwAsAgABAB0AHwAABf/gJ46kCJxlqqrB2K5wKahzDA/lgNswIfpAHqzwKRBFxKRwZEg1P4YnlHcQVUvX6jWFIHW7InBJrEp8zGdRAo0mmdslxUeeotdVi0++tOjD9nsjDAxChIIfhh8NI4sljY4kjyIOH5SVJJYpmZkjD52fD54loh+epB8QqCKpMKysqh8RIrKxtTC0trgSH7u7Ir4qvsDAHxMixsUwyMnHyRQiz9Aw0R/Rz9EVI9kf29sq3t4iFh/j5CQW5eLm6iUXFyPv7STv7h/xMBgk+R/7/CIYAGFkGDgiQ0ERBpd80LBQBMMRDx/y2CCCIsURFz9kFMJBREcSHz+EtNGBREmTH04M8vDwgaVLEi9ZqggBADs=",
        );
    svg
}

fn get_wolf_shiny_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,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",
        );
    svg
}

