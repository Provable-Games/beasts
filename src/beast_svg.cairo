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
            let beast_image = get_beast_png(beast_id, true);
            svg.append(@beast_image);
            svg.append(@"'>");
            svg
                .append(
                    @"<animate attributeName='opacity' dur='2.2s' from='1' to='0.999' repeatCount='indefinite'/>",
                );
        } else {
            svg.append(@"<image width='130' height='130' image-rendering='pixelated' href='");
            let beast_image = get_beast_png(beast_id, false);
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
        if beast_attrs.shiny > 0 {
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

fn get_beast_png(beast_id: u8, animated: bool) -> ByteArray {
    if beast_id == beast_definitions::WARLOCK {
        if animated {
            get_warlock_gif_svg()
        } else {
            get_warlock_svg()
        }
    } else if beast_id == beast_definitions::TYPHON {
        if animated {
            get_typhon_gif_svg()
        } else {
            get_typhon_svg()
        }
    } else if beast_id == beast_definitions::JIANGSHI {
        if animated {
            get_jiangshi_gif_svg()
        } else {
            get_jiangshi_svg()
        }
    } else if beast_id == beast_definitions::ANANSI {
        if animated {
            get_anansi_gif_svg()
        } else {
            get_anansi_svg()
        }
    } else if beast_id == beast_definitions::BASILISK {
        if animated {
            get_basilisk_gif_svg()
        } else {
            get_basilisk_svg()
        }
    } else if beast_id == beast_definitions::GORGON {
        if animated {
            get_gorgon_gif_svg()
        } else {
            get_gorgon_svg()
        }
    } else if beast_id == beast_definitions::KITSUNE {
        if animated {
            get_kitsune_gif_svg()
        } else {
            get_kitsune_svg()
        }
    } else if beast_id == beast_definitions::LICH {
        if animated {
            get_lich_gif_svg()
        } else {
            get_lich_svg()
        }
    } else if beast_id == beast_definitions::CHIMERA {
        if animated {
            get_chimera_gif_svg()
        } else {
            get_chimera_svg()
        }
    } else if beast_id == beast_definitions::WENDIGO {
        if animated {
            get_wendigo_gif_svg()
        } else {
            get_wendigo_svg()
        }
    } else if beast_id == beast_definitions::RAKSHASA {
        if animated {
            get_rakshasa_gif_svg()
        } else {
            get_rakshasa_svg()
        }
    } else if beast_id == beast_definitions::WEREWOLF {
        if animated {
            get_werewolf_gif_svg()
        } else {
            get_werewolf_svg()
        }
    } else if beast_id == beast_definitions::BANSHEE {
        if animated {
            get_banshee_gif_svg()
        } else {
            get_banshee_svg()
        }
    } else if beast_id == beast_definitions::DRAUGR {
        if animated {
            get_draugr_gif_svg()
        } else {
            get_draugr_svg()
        }
    } else if beast_id == beast_definitions::VAMPIRE {
        if animated {
            get_vampire_gif_svg()
        } else {
            get_vampire_svg()
        }
    } else if beast_id == beast_definitions::GOBLIN {
        if animated {
            get_goblin_gif_svg()
        } else {
            get_goblin_svg()
        }
    } else if beast_id == beast_definitions::GHOUL {
        if animated {
            get_ghoul_gif_svg()
        } else {
            get_ghoul_svg()
        }
    } else if beast_id == beast_definitions::WRAITH {
        if animated {
            get_wraith_gif_svg()
        } else {
            get_wraith_svg()
        }
    } else if beast_id == beast_definitions::SPRITE {
        if animated {
            get_sprite_gif_svg()
        } else {
            get_sprite_svg()
        }
    } else if beast_id == beast_definitions::KAPPA {
        if animated {
            get_kappa_gif_svg()
        } else {
            get_kappa_svg()
        }
    } else if beast_id == beast_definitions::FAIRY {
        if animated {
            get_fairy_gif_svg()
        } else {
            get_fairy_svg()
        }
    } else if beast_id == beast_definitions::LEPRECHAUN {
        if animated {
            get_leprechaun_gif_svg()
        } else {
            get_leprechaun_svg()
        }
    } else if beast_id == beast_definitions::KELPIE {
        if animated {
            get_kelpie_gif_svg()
        } else {
            get_kelpie_svg()
        }
    } else if beast_id == beast_definitions::PIXIE {
        if animated {
            get_pixie_gif_svg()
        } else {
            get_pixie_svg()
        }
    } else if beast_id == beast_definitions::GNOME {
        if animated {
            get_gnome_gif_svg()
        } else {
            get_gnome_svg()
        }
    } else if beast_id == beast_definitions::GRIFFIN {
        if animated {
            get_griffin_gif_svg()
        } else {
            get_griffin_svg()
        }
    } else if beast_id == beast_definitions::MANTICORE {
        if animated {
            get_manticore_gif_svg()
        } else {
            get_manticore_svg()
        }
    } else if beast_id == beast_definitions::PHOENIX {
        if animated {
            get_phoenix_gif_svg()
        } else {
            get_phoenix_svg()
        }
    } else if beast_id == beast_definitions::DRAGON {
        if animated {
            get_dragon_gif_svg()
        } else {
            get_dragon_svg()
        }
    } else if beast_id == beast_definitions::MINOTAUR {
        if animated {
            get_minotaur_gif_svg()
        } else {
            get_minotaur_svg()
        }
    } else if beast_id == beast_definitions::QILIN {
        if animated {
            get_qilin_gif_svg()
        } else {
            get_qilin_svg()
        }
    } else if beast_id == beast_definitions::AMMIT {
        if animated {
            get_ammit_gif_svg()
        } else {
            get_ammit_svg()
        }
    } else if beast_id == beast_definitions::NUE {
        if animated {
            get_nue_gif_svg()
        } else {
            get_nue_svg()
        }
    } else if beast_id == beast_definitions::SKINWALKER {
        if animated {
            get_skinwalker_gif_svg()
        } else {
            get_skinwalker_svg()
        }
    } else if beast_id == beast_definitions::CHUPACABRA {
        if animated {
            get_chupacabra_gif_svg()
        } else {
            get_chupacabra_svg()
        }
    } else if beast_id == beast_definitions::WERETIGER {
        if animated {
            get_weretiger_gif_svg()
        } else {
            get_weretiger_svg()
        }
    } else if beast_id == beast_definitions::WYVERN {
        if animated {
            get_wyvern_gif_svg()
        } else {
            get_wyvern_svg()
        }
    } else if beast_id == beast_definitions::ROC {
        if animated {
            get_roc_gif_svg()
        } else {
            get_roc_svg()
        }
    } else if beast_id == beast_definitions::HARPY {
        if animated {
            get_harpy_gif_svg()
        } else {
            get_harpy_svg()
        }
    } else if beast_id == beast_definitions::PEGASUS {
        if animated {
            get_pegasus_gif_svg()
        } else {
            get_pegasus_svg()
        }
    } else if beast_id == beast_definitions::HIPPOGRIFF {
        if animated {
            get_hippogriff_gif_svg()
        } else {
            get_hippogriff_svg()
        }
    } else if beast_id == beast_definitions::FENRIR {
        if animated {
            get_fenrir_gif_svg()
        } else {
            get_fenrir_svg()
        }
    } else if beast_id == beast_definitions::JAGUAR {
        if animated {
            get_jaguar_gif_svg()
        } else {
            get_jaguar_svg()
        }
    } else if beast_id == beast_definitions::SATORI {
        if animated {
            get_satori_gif_svg()
        } else {
            get_satori_svg()
        }
    } else if beast_id == beast_definitions::DIREWOLF {
        if animated {
            get_direwolf_gif_svg()
        } else {
            get_direwolf_svg()
        }
    } else if beast_id == beast_definitions::BEAR {
        if animated {
            get_bear_gif_svg()
        } else {
            get_bear_svg()
        }
    } else if beast_id == beast_definitions::WOLF {
        if animated {
            get_wolf_gif_svg()
        } else {
            get_wolf_svg()
        }
    } else if beast_id == beast_definitions::MANTIS {
        if animated {
            get_mantis_gif_svg()
        } else {
            get_mantis_svg()
        }
    } else if beast_id == beast_definitions::SPIDER {
        if animated {
            get_spider_gif_svg()
        } else {
            get_spider_svg()
        }
    } else if beast_id == beast_definitions::RAT {
        if animated {
            get_rat_gif_svg()
        } else {
            get_rat_svg()
        }
    } else if beast_id == beast_definitions::KRAKEN {
        if animated {
            get_kraken_gif_svg()
        } else {
            get_kraken_svg()
        }
    } else if beast_id == beast_definitions::COLOSSUS {
        if animated {
            get_colossus_gif_svg()
        } else {
            get_colossus_svg()
        }
    } else if beast_id == beast_definitions::BALROG {
        if animated {
            get_balrog_gif_svg()
        } else {
            get_balrog_svg()
        }
    } else if beast_id == beast_definitions::LEVIATHAN {
        if animated {
            get_leviathan_gif_svg()
        } else {
            get_leviathan_svg()
        }
    } else if beast_id == beast_definitions::TARRASQUE {
        if animated {
            get_tarrasque_gif_svg()
        } else {
            get_tarrasque_svg()
        }
    } else if beast_id == beast_definitions::TITAN {
        if animated {
            get_titan_gif_svg()
        } else {
            get_titan_svg()
        }
    } else if beast_id == beast_definitions::NEPHILIM {
        if animated {
            get_nephilim_gif_svg()
        } else {
            get_nephilim_svg()
        }
    } else if beast_id == beast_definitions::BEHEMOTH {
        if animated {
            get_behemoth_gif_svg()
        } else {
            get_behemoth_svg()
        }
    } else if beast_id == beast_definitions::HYDRA {
        if animated {
            get_hydra_gif_svg()
        } else {
            get_hydra_svg()
        }
    } else if beast_id == beast_definitions::JUGGERNAUT {
        if animated {
            get_juggernaut_gif_svg()
        } else {
            get_juggernaut_svg()
        }
    } else if beast_id == beast_definitions::ONI {
        if animated {
            get_oni_gif_svg()
        } else {
            get_oni_svg()
        }
    } else if beast_id == beast_definitions::JOTUNN {
        if animated {
            get_jotunn_gif_svg()
        } else {
            get_jotunn_svg()
        }
    } else if beast_id == beast_definitions::ETTIN {
        if animated {
            get_ettin_gif_svg()
        } else {
            get_ettin_svg()
        }
    } else if beast_id == beast_definitions::CYCLOPS {
        if animated {
            get_cyclops_gif_svg()
        } else {
            get_cyclops_svg()
        }
    } else if beast_id == beast_definitions::GIANT {
        if animated {
            get_giant_gif_svg()
        } else {
            get_giant_svg()
        }
    } else if beast_id == beast_definitions::NEMEANLION {
        if animated {
            get_nemeanlion_gif_svg()
        } else {
            get_nemeanlion_svg()
        }
    } else if beast_id == beast_definitions::BERSERKER {
        if animated {
            get_berserker_gif_svg()
        } else {
            get_berserker_svg()
        }
    } else if beast_id == beast_definitions::YETI {
        if animated {
            get_yeti_gif_svg()
        } else {
            get_yeti_svg()
        }
    } else if beast_id == beast_definitions::GOLEM {
        if animated {
            get_golem_gif_svg()
        } else {
            get_golem_svg()
        }
    } else if beast_id == beast_definitions::ENT {
        if animated {
            get_ent_gif_svg()
        } else {
            get_ent_svg()
        }
    } else if beast_id == beast_definitions::TROLL {
        if animated {
            get_troll_gif_svg()
        } else {
            get_troll_svg()
        }
    } else if beast_id == beast_definitions::BIGFOOT {
        if animated {
            get_bigfoot_gif_svg()
        } else {
            get_bigfoot_svg()
        }
    } else if beast_id == beast_definitions::OGRE {
        if animated {
            get_ogre_gif_svg()
        } else {
            get_ogre_svg()
        }
    } else if beast_id == beast_definitions::ORC {
        if animated {
            get_orc_gif_svg()
        } else {
            get_orc_svg()
        }
    } else if beast_id == beast_definitions::SKELETON {
        if animated {
            get_skeleton_gif_svg()
        } else {
            get_skeleton_svg()
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

fn get_anansi_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACcYSPqcsNAZ1c4dSJH7rZxcp1TBiKSfmgIkiZG3u6llaqGAvP7pXrJq7ZyEA9g00C5AV/xGWxkzTSdlLO81YNXidA4dHjlIpXkWmXOk19R+KcEg1bc7Vtany8xJqzK138k8cFSAQhp1CGiGNoMfhmpVAAACH5BAUUAAIALAYAAQAWAB8AAAJfhI+py70BjZi02nkCuLx7DkSa5iCBBWkfJq2e6lIhdlbwesfVrMvh1qOMfD+GLNcbXoCdERNXVPZ+NU7VmnB6mD/ZB4J1Lr7gIItxFfAsDhcpPdHGnquDWWgo3/dqQwEAOw==",
        );
    svg
}

fn get_balrog_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACo4SPqcsW39ILcQLr8IUaaWpx3NFdznlSpmquLIiuWUrS76SyUvZBbV5B5Xw632aGFI5qRyDR04yBgD+YkPnaFJc/idV6pLmYvNa11pkqqFAzacsWhas6r4wIUy9wZHWWN7RmFueWxGD0FqFIVnhYhzOEVyKJ2PjItwYZQ1fSBlVkeQgI5oJRxyiWiorFB6rZuGkoC0t5OppkCtrlJrln2oaZUAAAIfkEBRQAAgAsAAAMACAAFAAAAl+MjqnLF2CanA/AOLMI1VqtAaAjItBYMp2HLd5FXafEzVnV0uNuvv7H+P1qL45ReDkWccYVZOhrOi3SRyN5zLwmW1CTYkR5uGNv88nC5hSp5XDVizI5YCIxSV2tSax5AQAh+QQFFAACACwAAAwAIAAUAAACVoSOqcsHYZqc78GJkQX85Rx84hSOJBdcprStX+SCUGel5WKn9Fbr9Pzb5YC/ISrY8+2OwgYRhcmRbCIapSOSSrSZ4lIJY9yMyyQCaEMRr2r1061a9MoFACH5BAUUAAIALAAAEAAgABAAAAJLhB8Byrq83pkmuVjl3Wl2j2FbWEGUdyHpuZ4Z4say+s1ljVp6++A7TvkBY7+exeZqKZHBW5HEXDaZMOPuRYVqebKP0MsVlkAqp64AADs=",
        );
    svg
}

fn get_basilisk_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoR/oYrtj0JbsM4kDbN2a8xVSxZRIUBmJuaJFwqz7UNCnjQ79bd+J5rK+X63HegXk5WMrkmxJ2ImR8KSjXWkSWtV3dZ6gg7HHOGuq7tGkMk12DlKpF9LKmNmbNn3XBsOSgUkp6WxtXEYFVJEhlVWl8jm5sUlReOnQvZ12SdJN3lzUAAAIfkEBRQAAgAsAAAAACAAIAAAAn2Ej6nLGg9Dm0k6Sxl+iOflGRv0VeR1llYqRti3Aq/cltpmT/OsgTIf0r1YHWLv4Em5YKagi3cxFTvMKRLaYO2wKKcURtyqgkgr2HflOtDXJpm2TqefFHHrGcl+8Xi2nN9XAcKR57YzSCjkhagm8hNzE1KIAhdZ+aMDdghQAAAh+QQFFAACACwAAAEAIAAfAAACe4R/oYvtn5yCtIV0ca0zmpVtFtBZoIhkTAqGqEqyX4ma3uY+eU7xFz2ruVYSYs9GGp5wRWWLWZSloFMMj/phXTlD7RZCc351XW0tWJ0BcWXrOTkyn4G7tbUTJpNby2zTW4e3VfK0Z2RWCIanmHSIJWPUF6VHmDYZBdNQAAA7",
        );
    svg
}

fn get_colossus_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkYR/gcvtoVwCUCKIs1Z8v2hFoGWM2VKR3zkx4IiWqYyKc0zdMEbl8MUr9YRBX4M1FLUSN9eMoxoKp8uoDFm1KovN6O5k83aS2FyIatY4nxUdsEtVumrV32/yIha1Urx1vnT3d4T2pnaRdqVlAiixIyVHE+iWxASkuPEEiWbT6Sd4xMLYkelxCFWpolnX57g5UQAAIfkEBRQAAgAsAQAAAB8AGQAAAm2Ej6nLEA1hePHN6Kbe3OWuXJVBYeWxoSdCrSzokpYYyq2basvd1rS+A9I8pBdOWCRKGj8Mo3SKVUAoZ6IHVFq1n+GQWeR9pVXlhZrcpaPZstF7hbLm3HB5Jrs+65ZMfe9GxjHm1/cXEuXzRVIAADs=",
        );
    svg
}

fn get_dragon_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+AAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACpYSPqctt4SKDgEpna803cR18V5iRUKiID4Vu6Ll8LbhuBzfXMLtbvv0Innga4Q1UQhKLM6LvBXzhbjtXlBpEsGgk49OqDV9/4GINqzuuhjAat+3iTXNIZl2a62K33LLHDLUlxzZn5Jall9VXJWZlEqPmYZKoOBVGCBWJuNnVuQaXItTSWdgY10Z6RCc6xIq3FiNl8yQDhGaoRYkLKyloFjGZqNJQAAAh+QQFFAACACwAAAEAIAAfAAACjISPqcsZKKKctNJXgY2vha9tYod8JHWIXEkarftJbfe6ACbdgXxFdnm75WIqASio8xmGj6aSltPtUKIQ9AKiykIc2mEqTWGFmcQKZ5lWK1k2F2VGqd9F5Q9SrwKn7fym5Fc0N0EXqGVkaFgYOPOVKOfg+CiAhOQ0mXaJmbYYSMa2qbY5SsrYV0rp8lgAACH5BAUUAAIALAkAAQAXAB8AAAJnhB+iy93polwwgonp2SZ4fEWeFwocQJ7kUipox61T8NYdTRtKzuT07ELgWq6KaYPDOX6ZlDHDQDFFJwQqU7U+H9kNNqvE5KpbS5dIRb6gwSx7yuZ6d/HGvP6AwqNQNL5e9ifIcpZVAAAh+QQFFAACACwAAAAAIAAfAAACgpSPGMntt550IMU5K94G+BCBF9V4FaiB3aEpreAZKhDCLMmg8MK/lA7Z0V5Dm2ChGQIDsaPTEWkxd9Om4noLfmjMkyXhu9CEF97vW9sFOVgX9zvGjMY+NpQosz+mekkxxVaX1ScHaOdTIXhIWMiQojgxgmDCWEmYaJmpubcJ1vmlVwAAOw==",
        );
    svg
}

fn get_griffin_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+AAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAEAClYSPqcsQDyMKTlHqcMu6mut137g8JDRFqjR9aHuYmArXcdlosxeaJB8T2TYpoWXFOo0uPldi1QIBe0naD9QxWqLboe6Fdd6Au5K0HKxop2Fizj2FqzfrlFe4RqGz9KfsFzcDVjQXMtTltMN0g/eXyCAox6KTMYYYtFdpyVjHkyUiZbdkJEj5pkgJumjmVdNWCSUnm1AAACH5BAUUAAIALAEAAQAeABAAAAI9hI+pe8EcnJiUglCz1jGmDWqIZ2Dh6ZiCY5znhVSluzUiQLsNa+cbS2r5MhLZECXEHUO80fIJzVyiIWWuAAAh+QQFFAACACwBAAIAHgAaAAACRpSPeQAZwSKMtLKX7mSqeyd9HZQ1i6gAQWep6NdG72ysNOlkGO2pKvQI8Uq20zAVKx6XTIOrCY1Kp9Sq9YrNprKmKo5qKwAAIfkEBRQAAgAsAQACAB4ADgAAAjgMhKkrEQtOMqyiuBxGz3orUR/UTWUzZlKmPGvKno0Me6HwMgCdu3NtQ4VyQCGryKA1iMhmU5QqAAA7",
        );
    svg
}

fn get_jiangshi_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACf4SPCaHtGKKcUbEH3T11Y59xBvhR1UhinEeVpxU20jolrN1CzM6f9U+6bHao0UJ0tBmXt2QyuHTWokKY9IOECl9VVFV7TCmJKaLzGTJbmhqdComOvnHB1zy9ld/ldrHKD7cHqDc3eFZ4Zxjzt3f4oBiIJZjYuABo12gyVcmpUAAAIfkEBRQAAgAsAQAAAB4AIAAAAnSEj6nL3eEcVHDGgLPGx0bgIV4oMRP3iRtKpqjBpssItnBmig+38njtW3UqHdANZkS+kpaTLsl8NoevKTSKfBSvROC2GaMRbbpxokvjKinp3PBjtcpupN+ceXLeuW0ZeesHd/eX5RJoiCiYeHG46DbXs9FQAAAh+QQFFAACACwBAAEAHgAaAAACZISPqcvN4SJMcEYQst7Z1Os9FIiJiHVx2khi6LS1x9vJbGivsdutFDcruUKWnvGDe+FKvmFx1nzWksHGU0iNLnVLplfiVV6p1W9wvJAqplhYeShhe+QgmL1Lop1yKRnKlNe3UAAAOw==",
        );
    svg
}

fn get_kraken_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACeoSPqcvtD4MMsBp6sW1TAr0t4Bcek0l5mhdhbpK+YffRZYZeCFu5p3oiRXSkVLFkPAqTs6VJ2ZTVoJuganoTMkYWKZHbI+7EVe3YHEZ/kViFt4Ve8aJOcFcnsz/yMXKaZ/S2txboN6hUqMaBk+c0hBXjI+j2k0Rjk1AAACH5BAUUAAIALAQAAgAWAB4AAAJjhI+pi+HBIjROplfnqkfTvnVQBjbUeAGcKY5Y2YofXL7ZY6k6OnmqHVuxZjSFr4eSCHe+VC6kYy1/xWgTCY0GQzhGk/gERz7JpJcshfasa6ln3Z65qDsiFouu08vI/k1o81AAACH5BAUUAAIALAMAAwAYAB0AAAJhhI+py+0PozShBlnPpXevrlkg4CVbhoKnknGmV4ZcZ2kOvJJtI9Y7NLJFYrJH0MSrJRmlWJOJYrWIRaSOKrQOPxMnCaOifI3i5w+RKrt0Whr7CxNG4fHVyY6+61PnK61SAAAh+QQFFAACACwDAAMAGAAdAAACaYSPEBvpr86CqEnWLDVac7lNYgY+FlkpXjKpGVaa4xeHr7s6Z0TuOtyZQTyrnI7FQdmKqg1t6PSVWr8azRhpHp8VkckVhTq52TEIpaTsiORUFi11U990JO/GI5/g5+f+8wf2xoDTNTJRAAA7",
        );
    svg
}

fn get_leviathan_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAClYSPEIGbD9NiZh4X49xY9dw8lkddX3hWW5N6iiuOZMyWMWe/oGimeAms6FQ5ClCmYyhVPJtPuHw9YSGpdQWZQq8yjiR3JVqFLPKFezarh9tosDosJtkw+XoJNmXV+BYV7iSVt2YmF7WHCGa0k5gxmAb5KMG4OEkHcviGSGZ3CMd45wgaV0nIxEOEpYFzSvJT8xMr+1MAACH5BAUUAAIALAAAAAAgACAAAAKYhI8WCcsPm1MzWjmDPvsmDYZc5ykMSFXYs5FIWKFv17Ly+p6uDn9lnlJhdsJFjGiCxZINyqk5ejaNSaSENc2KiEKodkqiFVVUh8y8g5K1xuUMyPn6oqZ63Cz1xvXMrmiuV5a2N7fWRmiRcZcF0aWWg/cT6VjTCEglyVfn97Em5ahzAQp4ZUM4NkOmOJJxoxSkpvQqS1srWwAAIfkEBRQAAgAsAAAAACAAIAAAApiEj6nLHJFgm+chS+mTYFeeGduIdWUIfuJppqu5kBfrwe7K1ZWix2R6m+R6OFasMwOKWssdEiIxQme85fTZyx2n3BrtaH0yoxig8uoxR5q7LvISAZ3F7XXTha6+4O/wNT7X50ekweYX0hd1+If4Jofl0KDIZySo9xgkqJTIRQfD89VyUyIzKTfykabySfPzk3oK6zr7KvtTAAA7",
        );
    svg
}

fn get_manticore_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkoSPqathDgKEUbr5cpWR+WN5nMZQ4PeYyDSum2qpS9tdtZjI1Zm1Idz5wEKoYjCnsZ04MZIwyXKyfKYoRXmcZV2jqgtZiu68G55NVzwb12wouQ2eXWW0nV16/TJ5jaq/mbKG0XMziGb3d0SU08X3MncY53hT8tV35mM5WRnYVFfnaLXUEJdHAzhGmIl1kRgJp1AAACH5BAUUAAIALAoAAgAUAAgAAAIdDI6hhn28GnsTKJeezpjKj0HU5XHlNhpiZXWnUgAAIfkEBRQAAgAsAQABAB4AGwAAAnyEj4EQrQsjMy6lJ698PC8MNZZ3gCVFceKljinaMdhcdXE7Z6sMK05Msv1opBPv9zHpbBNfahdStSZGpBElcz4jItOQWoS9njvoEneabsDYdJjdjCt1Uef82rasQPxQMFnBdUfjRZfU1jX2sYioVRLItvcYyZiDyPMI5VMAACH5BAUUAAIALAQAAQAaAA0AAAItlC+AcYq/gmLpSFuhYe7d30GXxlmhdwqgRmZqR7Fis8r25t76zvd9GPNBUrwCADs=",
        );
    svg
}

fn get_minotaur_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODdhIAAgAJEAAAAAAAAAAP+AAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAAAACwAAAAAIAAgAAACnYx/IsjZrOJ6L9agqE7ZdS5J2GQs5NR9JYKOIgaHLezE9mq610r3tJnbsVQlEm/E4hkbqSKSsoQ8ldHbhhkUMpNbqLDK7UrBxtf0WENDmqC0VDf0aGanNLH+tTqfsxobv5T1thWoNSQCFNZX1pWRhdeTmDP5Afk2GYO5wagpM2hlgSlD5Idz4+moFOaSIvlzNReSqXoUNYoiqFamUAAAIfkECRQAAAAsAAAAACAAIAAAApqMj6nLKdIOjK/OKN+CGrOKcJdhlWIYXFPXSWialiRszrBL5zMXj/itep18vwyxZUMCbZ8VidcgopDOzc0Tglo/L0d0e+WCp+LnSHnsOkBhdlitaGnjTPdVqQ7u2vKk16Xlg9fkF+ORZqVxYviWZZHjpsfU6DTYuMOTmQlHt9kDIqXz5CVDhVMZpwgV2OX5qfom+frKxvJXVFEAADs=",
        );
    svg
}

fn get_phoenix_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACh4SPqauB4R6MB77rop7caJAxled9oIiSqZhR5nWWccVZrdzWi35SfTlZCYeMF3FmQeo2o2YDtCw6d1AbyqeCJbGz3bZL2nCP5LL5XB6valimtxNLKkPO7+8py2L07Xy/SZfFJudD1+fCc1dHZXMzplYUZEYoV0VztfjhMsVppPKXEqIJhnZUAAAh+QQFFAACACwBAAIAHgAcAAAChESAqct79lhs7gQ7U24XGh09G6h9U4h0jmKZKKimZFvKEP3Z8qlfPs3DsUi6YSsmNM5yxZwqE6RgfsyVMPTz1Xam4S1bPHqxVFt0C9vwUiORiKN+epY3yjJ7HNlZ2r3f/PbnVQeDJhHoZsbmh/L2wshl1VQiV6XooedUBST1xeXopHVQAAA7",
        );
    svg
}

fn get_tarrasque_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACmoSPqcsQD58z4cja2EU1OjhRXgJK0zWaJ5m1CviJW4xxnomS5UpZfA1TvWouV6eXwxVlkU4TAw0Nn7QPSkm0hY4cK9IG091ON670GKUFjbwly90CSuGvs2oG5za3+Aa1tAGVtYDmVIhl5oNG5tUoKHbl47iT4TQnaDnIhNg1BgkUGdhoMQIW9ISzaKrnlXn5JSfi+MWSOEWHWwAAIfkEBRQAAgAsAQAAAB8AHwAAApGEHafLvZGcbBGkOjM8N/uObArmWaYpnqSmQhd4Tu5suTWCy/PeguuIEkUqm5/kZfMRSzua6slBBUO14Y3UTL6qyhi3IyzaWhrr2Al7XHPaJAXcPbtHvJjc/MjSpTSYnuzWx1FHdxZU9IU1hzPUNBXiCJnlR+XDCIeYw6eJNLUFlFZpKPM4WFVS1oiKOrbqClAAADs=",
        );
    svg
}

fn get_typhon_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPFgnLD5WTsaawcJvW4s91UdiIEpkp5aUd7eoy4aQ56bzBapqX9qfLAH0UGzFXM/KExyVouPTdjqfhjhh1PqFNVcy7eZG8ya8LV/ypwZeTmyKDjF/h7aol3M7md91ZRudn9saSp3YYNiIWBGPF9wXCRhPIwjgHtWdVJxap2akHaogHRFpqt6OXeFr3cGqaKBJ5lgdrgoTJWtvqOgoKUAAAIfkEBRQAAgAsAAAFACAAGwAAAmyEL6nLfG+CBK06Gd6MtoscZd5IluaJpmoirhYQWHE5v0p91tSyu0n/8VVwAoPLyMAQcxih8wn9RXmQ6jIJejggVxmCepAIJ8pymIwJlWfrDQytPLvbLV4ja3Vr0ml19b+30ecH+Nc3qIZnUAAAIfkEBRQAAgAsAAAAACAAIAAAApuEj6nLHPqaRCGaOjPA3OpWhd63jBsJnqfpiNgFHe6rJuH65DRV9zIfk+Vgw43OSFQdI0PmjLkiNqOX529KwzpfnF/1ChPuoJasCGJyXVk+L1pI6SJxnp3xBqZW8bYR2882h3d29yUx2FPEd2hIWIZyU1dIYiVGeKj2pGm3Z1apGWcXOdM5iFg4ujhpeqezJbpVGtsZ1DopZrtQAAAh+QQFFAACACwAAAAAIAAgAAACoISPFgnLD5WTsaawcJvW4s91UdiIXlmSo3Yx5IewW6uFcq2gIJrvKeXI6DLEnm4m/G1ArKQQ94wxY7+iMcj0RY2HiReWewQp4a7NHL41IdivRKXiSd1L3Cyl5fio4xfYfCZ2ITNX99ZGFLfUJZe0WKF3WCbnYddD+MY2Bbi3x1mTFTol+pWIuEMKWKfGuvkIilnoAvP3Z5KnFwvZhOlpUAAAOw==",
        );
    svg
}

fn get_warlock_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP+IAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgISPqRvrFmJ7lEnJwKzwxro94aeEnNakJpKe4+myogZDx1p3JQ6qK1baqVCjSwJow3gmS5bxuIwSb7SN8iptJW/YTlZLC5JQZOCHJ3OWueexuqbM+ZDkXDlOlV/rdnXbbTfX1EcUBahnSJiUpdg2RQfz5dE3KRX4+MfngmQ1iVAAACH5BAUUAAIALAEAAAAeACAAAAJ9hI+py+0XHgy0RWmorulisGmW5IHl1yEcqpRnSqrOO2a19a5wG+mZb3JVhkLRxNgjIkOeHqjDZJqetssmGJQOISplNoSlVa1JbNa8m26PVB4LOPuexAylk3Uswz/EM/4ZZYQXKIiSFPUHaDdl6LXIBxbI93NoRpe30gR2UAAAIfkEBRQAAgAsAwABAB0AEwAAAkKEj6kWuwGbS1LFO1m+cYsPhl8gClsGkEIDeeULl0BMxyhVm4+a0x3Ui7FaQRsDWHx1kjZmzRCaOUVS6VTEu1Kt2gIAIfkEBRQAAgAsAgABAB0AHwAAAnuEj6GB7Q+WhGZRaSGrd/PneY4SRWKTXQnFrsfZshvckiRKl6+d7nDGsARFmMTEVzQlS0Mh5mnSMSu8JtT2QkWVV6yKGgU6TzewlxqMqcsxK1vatsLV6OGWbgz36O4l/+n3B5gjwzVBqGE3hgdo+CZzCMWnROm0lhLiVwAAOw==",
        );
    svg
}

fn get_ammit_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiISPqcsd3yIK51EAZbS446sp4Odl4TQaYHpSXAWfzDWyLempMlon9qZ69XaxYm5n0hllSdwxKElCLCnXxkV19n46K3YS45K8LJrV8ckuMk0fEKVca7ZPcMc2bBtX6HpYWQXDxQdoFyd351ayZGgWVzZjmAgl2bhISIiYSPN3qFjHNyTi2XVZVwAAIfkEBRQAAgAsBgABABkAHwAAAl6EH3nLG6hAbDS9ayZFogv1SOGWiQ5CVmeZMuEotc67phhdk0GXwyoO81UsnqLxiEwaJ8rmp/NwNqPSpqRq5e2wxavAyz2Cw90tuXw2js+ZdNHshrvn9DoUYP/E0qkCADs=",
        );
    svg
}

fn get_behemoth_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACeoSPqcsYFp6SDdAX8aKJ19iBh1Y5Yoli2deAGedJMDqOJATd9E57Nt+xnCZAlc6y8a1WSGKsmRviHNNqKiirQUsvqVAFDIvHk4s3fCGOz9Til7UzbpNc8NynzQnf+GwbZ5SGFWTyQqg145ZnpvhzFxfS5selNuVCxlMAACH5BAUUAAIALAEABAAeABsAAAJxhI+pyxjfooLmBRnvojhp8B1hB1ZjRYqnl15Wtk4g17z1TGeMC8Xb//LJPDzUkFhCBXdGY4/n+iWbuOrUQf1ELVrWNfSkjTRgBxdczhLF3mYUtmYLrzORndp2usk3bFJLEQP4R6h3dPdWJnhWZzIWUAAAOw==",
        );
    svg
}

fn get_chimera_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACm4SPqcsY32ILgFKJz9vm1rxA3eiBXFV+qWSpLaqarYhuNOvd3anNzseAvICzi05TOxkTy1VR9LLlVqOdD1qN9YhYIWxK/MJi0tvVBiSPFV4pl8wrCcsuX22dLLvtcwfdwnGVlqJXF6hFVVhHEub0Z9WE10P306bF9EgSN/GYk4TkGDL4yfgTRAMoF3eU54cahcZ0aSc6BHKL21AAACH5BAUUAAIALAEAAQAdABYAAAI5hB15y+0hYnSUpmuk3lwrlHWidHzjKUFREKIdm7buaM72jef6zm+sugMogL2i8YhMKpcTpRCQ/BUAACH5BAUUAAIALAEAAAAeAB8AAAKBhB15y+0QIBS02otvCrl7e3DfSEGRQXpbmkZuxH4vEH8SXTcVLCeg4kJMcqfghse6nUKumKR4FMaMp1Kt8oSark/TUZTszhhgknhzoHzX6+7wijXimmqnfFlm3dNwtfvGtNZxFoQgqCLWcIjDdWjVuISABRnppWAXFdJl9/fgeVAAACH5BAUUAAIALAEAAAAeAB8AAAJylA0Wx+0Plny0prOqZilH5GXb0TnRN15C2Zyi1Yhf545g67ybTmL2dkmgfrgcsbjyHR+LC++nEgScUaiOFaMBl9yu1/QNi8fPZdk7PXOFCsiXN2RWnmmYNN5s0RHKpMcWINNW07PjUqVwCLDI2Oj4uFgAADs=",
        );
    svg
}

fn get_chupacabra_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjYSPqcsZDaN5gLaAoaV8bT2FlYdYyvd0FzmOaWuWjPq64pHNIXpXNV4yvVKYYg+XQw5hk5gsp2ohI8Moi+rAaiW7rQ/rlF1v1qAUiCY7w0zpL2z0fVzQsvlMlAPhc/2GByLy43Z2kjYIVZiVhJjIZnPXJWkY89ikmLGWZLbZVQm5h6no+TQaCMqVqgpQAAAh+QQFFAACACwCAAEAHAAZAAACaoSPqbvBD52RkFGJX6Dnzt+AiJdxAOedn1Na3cuqbYLOqqxs94Ti5xX7mTaxIFGEyYCCsmGTpzG9RhWpqLIKdaxUKZd7q+2mZOCVivbtjsIpS7emKVfv5DrV7mVz7jGc6aYEZEM3AqcWUwAAOw==",
        );
    svg
}

fn get_gorgon_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACfIQdp5frj+JKFFrUMmi3bxVwTHhVGXVWnrSF5rg6ohqX341+4uNy+0pisHq3GEkjRNaEE1btB1pCgjSpzFdUQT09oqu0DVp3Wt82GukWjc2X5szLfVtO4A8pBkqw+WXYCnOkNNZXB2i2BthypHhFt3bix+SFIcWYVdkYUwAAIfkEBRQAAgAsAQAAABsAHwAAAl+Ej4Gmu9FOlMk1eITWmHUnbaLggeAofqaDtq3UuIBqXVB7rZO7Aenq4/VoicDPuJmAiMjeTGkSBjVAg5DkuWqn2q73Cw6Lx+Sy+Ty6nW1mJANNbYYV8BnnHMyMaWRQAQA7",
        );
    svg
}

fn get_hydra_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACo4SPqcsbYWCbUsaaLAUavp9xm3dhoeh8nfpEZWO64qoqdXul8UGyfD0raTgs0ow2dPxyqJtr9epVWlMUZRec2KhEHDWJ2HmDHevPAjJ9ZcgtlxhCN89dOK57T5vX96b8xXTjhbWEljZUdAZU94UBxoMXBpcxtsV4OFUF4yElyZnC1lMHiAhyaRfVZ2WKOjiJGMbXKAU2hjSr5Xd0urh5hPmmUAAAIfkEBRQAAgAsAQABAB4AHgAAAliEjynL7e8UnDQYC6hueXtnBaLYfdB4lWY1BuuEWW+1GPMmevJNAS4PDAoQvEPEV0yoeKFDa7lKNYU7H6nYIl2AFwyR2h0Fc43dzKv8jYUPNfsNv0HZbnYBACH5BAUUAAIALAEAAgAeAB0AAAJyhI+py+IPo2AoAImFpcdmCQQOJzrlN4ZMwKLPxm5K6n1hzCr4fWWxIeuoYiAh7Nd7nTDHE8mlaWmAQZ4BqrJWO0uoN+n1SsNfcnhsRt1AaSXY1H68J0TbPBrp+vQjyG15d5aBEKcHE7eHqIhYs5jnGFEAACH5BAUUAAIALAQAAQAZAB4AAAI4lC8RtujvFIPUASkrbbqLG3nWl4AiBKQpeX5YOyYc/Mz0Adx0riN2DwwKh8Si8YhMKpfL340XLAAAOw==",
        );
    svg
}

fn get_juggernaut_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPAAAAAAAIwAvyH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACmYSPFonLD8OS00EF7KMyUZ9l3DiJXGOVV+p9Tdh2aAzW2O2ehwajfKgDvm4rGOtofLF6xN5vB2U6dzJGVarSyUqOILSSI16LJs34af2qqRf1sjNquxXd6zjCpovo9/TGCCanMmO3V/TDBYIWNVShuHKGM4WWuCY0ZJOFEYa5tqWX1CmW5FIGmjZY6eNFlfJBuQQZtzErZytXAAAh+QQFFAACACwAAAAAHwAfAAACk4SPqcsb/ZoE4VUbIZW3potYVEeKZRiJmpGx4KGiHvrNrNJm6dzdH26DjTwx3+SW2uQ2TJyw2YIalc+lMVgLaXe8KPIl5BLDzdVQZ8MydMxieU39nr2OODGorrv23fzPuTM04Xa3RUe29ebmpNWm54D3w3Zo4sP2+ESVNDL1ZqcCOuU1qYTXN6oJMgq2ikGy9mpQAAA7",
        );
    svg
}

fn get_kitsune_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACmoSPqcsb3uIJD9BKZcsP269ZGfh5BjYqXleeralOLLhWZGKXcze7zJgT4U5BSDF2FOVYRSbi4ltOntMqDCgjWm2waIQz1GaJF+n4aVZy0V8sLZrSgIdxCVSnRSWVYaFPFtS0RlJHiLNTVhPGNZh41XgnpnY26WBSBifHeJZSKNlixEY1evMXWCXJ5PR5xQbEQ6qX9PoT2aanUQAAIfkEBRQAAgAsAQAEAB4AGwAAAkqEL6nLen9CaJRJGKtWAZu5aV0FhFQpmk3nqeEjudsFgLL43TOK6kwvsPk4GOHwiEwql6YaM/iJISUsBPLxzGq3GyeTRU1SIclHAQAh+QQFFAACACwCAAAAHAAeAAACeYR/gbntoQCM0FmpstHxoq5JjMdwm9h51Cm26UOFWay2yRta+bU3K8/ivWAk1vBXdH2CugqIdpr4ojXk6Fph2m7ZbXAy/ECz3SZog5ROl4/F8TZ6Xrky8ApMiuG9qme3DPOzp6cDh2bIh+ZUuFf0luSGYgJ5SDZjUQAAOw==",
        );
    svg
}

fn get_lich_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEGQD/ACwAAAAAIAAgAAACc4SPqcvBD01ws9WYqJ0Oo76AlxdVHCmFI0iyEqWdHntypvwqWg4Dpt8ZZYK72AfoOvyCSh/SiftcdpmXqJE6OpvXUDOrpWHBRfEWy/zqSmBvG0Ilo9hDlCs5z59n8LfeD5jHhGe39nfYZ4i4WFjFmPiYVwAAIfkEBRkAAgAsBQAHABgAGQAAAlWEHwG5y+dgUpNVRJGhXMXZNGCWiZa4hWh5qajpbV6ZQm8Uxmwtx5ovSek0tqGLaEsGjzzlz+kEKo1LJrS5nBWv1SSNiwVfpeJyGDl9mstUdHR9JhcAACH5BAUZAAIALAIAAQAbAB8AAAJxhI+pC8EW4oNOqohn28tR7XWVpV1k+KCfNKohmmFsRnlwM252C3Fvr+vRcEEfouLb2VJFovN4WEanwF8JKMRCOVQjN4FkqLrY8feiNZO45ms5O7EG2245mkqvkvPWfEfspvUhGHgHSHYW2OYnVXgYWAAAOw==",
        );
    svg
}

fn get_nephilim_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChoSPqcsY70KUrVEJAa1Wvw9t3II52jhmGcqpIsu4sPV6cwJe4G183u67XX6l0wwj2oRgyJ7OaUzZVNNi63cCYmsK5HC5lVK/UC6uh3sNry7d02zyPbPgShNqK0un+Dv8oNZ3xoZmtFZol+YGGNWx9oj2B7g4OYcSgqnFkxex6VQTJBRaCVcAACH5BAUoAAIALAUAAQAWABwAAAJYBCKpy8APo5w0GEOhdfnt7mHgSHbcc3oJoq0lyKphXB3olN5SbiW21BMcgoIAbWFUDC9G0cLQhG6kOWGU+qFcllPc9gqtHpjcKvB3xFk2RC1tmAFvM1tAAQAh+QQFFAACACwHAAEAEQAHAAACEYSOqaHtDxuYgMUz7RV549oUACH5BAUUAAIALAgAAQARAAcAAAIRhI6poe0PE5iAxTPtFXnj+hQAIfkEBRQAAgAsBQAKABYAEwAAAkyEEYnJGweReYzOeNV500LKaaKXgeUilVYlNaFzhsorpt58pRu35SYMxLWENdepg0S+ULLjsofS+WxT6bMj492oXNoO+xlFZmQWD1AAADs=",
        );
    svg
}

fn get_nue_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPqbvhH5hsIMZ6FczsGahtXCKCh1Nh1pimqPrFsjVxr4vBrPndOcnqeBCozeTE04lqSRWNKFwBZ83GqGhrWX1I4iU4s2p/Yy9Q+o1xw7rWa7jOFXHpk5Okpufbz176mZElhUdTZ+eHdIXnVvYVBHa4Ejh0CGPXpxWXJSeTaYnohxk41Vk6avh5RclWd7PZ19o1ZlSolrRKiBN6xNvLUAAAIfkEBRQAAgAsAQABABsADgAAAkGEgxnG7b7iWa9CNPFNT3nKfCBARaWGmWY1pkf4nloWd6RFclM3Np6fUvCEQBUxt4LUfDzb7Jfp7UISUIklod4oBQAh+QQFFAACACwBAAEAHwAeAAACl4SPqavhH5hsIMZ6p34GNi9BYtaNzGWhTllh6Yas6DGTCcm1L2e7cY75bEQ0HuiUWpVkpgkwqFMqb0fWlEhpUbeWxayY/Om8GZ72+7otx1KVSsgeazsuHL3blZvzrPjcniZG9/d3NTU3iBbTt8h4d5ZXZRf0RVP0U2ZmORjFx4nIh1dVl4W20+ipJ+YmI7f09GSJR3WoUAAAIfkEBRQAAgAsAQADAB4AHAAAAo0EcnlobQGhm/FVGi/OvElUSd6zWMw5JsykmCQaOtnmrTWLz26H1/oC4th8wNVsOFT8SrKlSWNhvlinpOjWwtCgVyQJqPrCrMEwiHm5Ks1rW7ArOqPEn/BUTJGp3N420RXVs5aSpWRlBqdmdDP3JRVYlNVYRtiyeAnm+JQy97EYeGbHJ5mGuATVxBbZUwAAOw==",
        );
    svg
}

fn get_qilin_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACk4SPqcsZ8FAMEzYVrTZ0X1lZWfZh1DOhZXmibdOqy3uczkjOtVS7e17pjH6ckMNTJPZsO6TGqAN5UpzVRiaSrpi8KYjb7DiTzyJNPDYnZT4tA/0c8uBzFdsopl+9YXZ0i5RTddQVKAcBFJPnFnPzNojopjbTNuViQ2OSJmgG1vMmiOUZSckCN7pkdcOZqYrI6fpRAAAh+QQFFAACACwAAAAAHwAfAAAChISPqRC8v1poRkIUhNb1THthHgU6YTJ5Zkqd6CfFKdO64zca247vvtaqNXyVmsjB6lQ2wR+Qg3ICSSiAlFoqzjxOqglCJSqRRrDPK5KqOWuBtQ0/x9vb4lxqvxPPOn2b4TeXETjUVRj4FrgWtpHox2KkyGMheXVYeXaJKdCzmam5iQNQAAAh+QQFFAACACwAAAcAHwAYAAACSpRhFhDpv15CTVCpHMP02lVN2IF827WNDxMx6ZGE6tm8nKwKrZ730IHzCXnDYamokh2RzKZTaHv+ltIq1CqhYrfcrjS4rWi/omoBACH5BAUUAAIALAEABwAdABgAAAJJlGEWEOkPj2gCUYfis/asq0EMU00VCGpjGmXhGS6Kerlveef6zvf+D9RRWMGi8UY6PohFUrI56Sg5zJ9UWQLZeplU1zqThLmKAgA7",
        );
    svg
}

fn get_skinwalker_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACk4SPF7vpDwNoLb6KmHYsT6l1lBFi3gShqaqoIetREpfOib3iLrmh+s0BlUY1k0JYMdJ+stgvo/RBYZGncPeM0aiglS+riwLFuF6NVxV1zsimViy9dedfC/gzf13I1342fkGC12WBNzbotoV20vZRKEgl6BfYoiUl8vhXR6TI4pbn2Kl5eQVUKemEaQrJtsF00qpXAAAh+QQFFAACACwAAAEAHgAfAAACfAwcostiDRWKFIIIcpXbpvp1R6Z1pmiQZKquAZulIYO069i+x8vz18nY7Xq2HEYHQVJ+nkaseNPZdLLDCRY7mphb1I4C236GwBOpvJyhl5x1ZaR2e+LyRamOF1/hCGzWVOPzINcnNEjIJ1Q3U8hV9kGk4AgE6SNJKNGTUgAAOw==",
        );
    svg
}

fn get_titan_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChYSPFsvp/xaSsCbJAqDW6sx1IhiKUKZoZoelW7NO20vCK4epR1nBTa67UX4pnmcYJMVmJuNpF3REPTcmSzdUaK29osuFpW6lY+5F9RmHd5EsM8kuq9dwNfkVt63NbxnIzvdVVPPmdEcDtyd2otc0UdMy1QaJYjNJeHipxMJYmSlT5feUUAAAIfkEBRQAAgAsAAAAAB4AHwAAAnuEj6nLGg+bRI+GKSu8FS++XV4WiqMTAd2JqoaWnpxabuMKJ2uTRrCJ6WlesYnQYvMASUpZs7lEumgv4vRKXHZw1OohOt2ZxhTvUFf2mrlYEVm3C6ffxuxXDXbQStk8urZ3V8eQhEX4VTPkh5i4FccI+PHR+AS5pSeJUAAAOw==",
        );
    svg
}

fn get_wendigo_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoQReMud2QyUir018QlXwf5MWYWAmidGXLdR2ho50kq78Q1b3M3bVh/LBXfA2clHLJZ4SWVLpRMyZRuaFHcsWUfYp3bLDdqaWueSGS77xsl0+ZMLZdwVUYq0Psmt9eyL/WQSdrFXQ+gB9YEx18dC0Xa2c+f4+BOpsxZiRmXkRgb1eLWZchhFR3JoZ3TG2dP0uVoAACH5BAUUAAIALAEAAAAfAB8AAAKNhI+pmwHOonEQ1SrfwTbQx4GaFzbeJl4nQ37W1IArHMstFJZdPme2tqCQfDhJ0QekKYG3SE+xuj1r0IlU96pdhxkMjsPtZoPYapKF3JSX6otZhiK7WrDwWauOe+80oZRZFwRopZfC9+HXhEgYc8QYCIkyI0To5miYFUX1RUdGFOiShrdoMkXl9PXYYVAAADs=",
        );
    svg
}

fn get_banshee_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACoISPqcsa98CLzckY8r20Ijxtmgcl4Wig5teMZ8mmUtyZ1NS5qQZy9sLbnXA/S+amQh2PxaUMtgzGONFaVOQYVq8v1WxGVIJ7OdmQGnSFzOwd7Iv5PuNm6Utel699c/x9gwUI9jT4Fkb4VghRw1JG40ZYxsjgOMlUkdQXmTaFaFiyNxh6s5JI6tgCRwl3CqX6czmmRGcV22lL6YWJS9LbUAAAIfkEBRQAAgAsAQABAB4AHQAAAmCEjxDCbZFibLSyAKHcWGX/WNYhNkuJCsClrMKZVkoKx5SXaZBduiwfa2GAtpmJiEwql8ym8+ncQY1QirSKDWYvRNBGVhNpbgdNGXUVtayxsEnYfJyLaLkb5Sul2/dKoAAAIfkEBRQAAgAsAQAEAB4AGgAAAnYEhKnLahaanOzQ+0AI0FyqcVv3VRv3jGWSog9yelN7uhoUl6M7hvUP3LEUkUQRU7ylOhyKCLWzCDQrwZNk7VCrShsKsV1Bl8dq01GuGru3tHpa5r0Zaekqg0+fL3HtcuZGFDaFIaFk9walFgg2xpeCpKMygVIAACH5BAUUAAIALAEAAQAeAB0AAAJmhH9hwq0IoQqh2cuifhTMr4XIhFlAiVqV4HlZqaBxesL1k3QceYHpmgHSUgzKg4js1TIeyi8JNUWn1GrPmhROXdhuyaAlhmnAmcO69KqzYMwYZnpjW13z+g6V26V4RxvJBZVGY1AAADs=",
        );
    svg
}

fn get_cyclops_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChISPqcsbD2ObJkxL1cs71xR1B0aRInKSDaYybKmF57eC9IteOWBtOB0z8YY+4mj2Gw2NtuXNEXIAly3Pc1flTG8tVTf5FDaZVXCqu62k1B3vbOyEZ8dzYF3JlTjv+I93pzXV1hfIIyNmFeeSeHTBB/XHxng1qAgSJeKTySJRloaFNmlVAAAh+QQFCgACACwLAAcACgAGAAACDYSPEMur7wKU0akmky4AIfkEBQoAAgAsCgAEAAwACAAAAg+EjxYB656inPS8yzCupgAAIfkEBQoAAgAsCgAEAAwACAAAAhSEg2mA6+2inC/ZExjLPO+vLBYEFAAh+QQFFAACACwLAAcACgASAAACHkSOZ7AdIKKMa9L43tImBQuG4kiW5olin+QhFAPDBQAh+QQFFAACACwMABYACAADAAACBwwMiYrh7woAOw==",
        );
    svg
}

fn get_draugr_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACgYSPqcsbD15oNEp4rawGWjQ5Iedl5ciBkbZOG7lq2OjCx1nT6V2he1cC+n6qjupFymFYv5qM5ezFXNFjj0Z9hTzN23JIDNuARl74gs6Ivei1wjfkdsts4tK4qVLaeXWzbyIHk3XSsuMUaHUlxJig97b10QcCVkTHpGPHk+eGB5VSAAAh+QQFFAACACwEAAgAFgAVAAACSJSPmRHqGEB7hs0jGdj82hNZgBMlWShxmxapoaaun3LR1CvGFi7mbnraoWoLivH4SBGRTIqSiZI1o5mmAFadtrJIrMR6dYG3BQAh+QQFFAACACwFAAIAFQAeAAACaoSPqReLraAJUAI7K200rw2G2NNd2RiJTsqVK5OM7gPD21czs9ly/H7xTYI+S6f3k4GIxJ1qGYrdnk5Tkykc9kpHq7bZsn2vM2Ex6BWjb0yaBp0jecJTCfcd/eWM3KEfPmWFYof1wrOGUgAAOw==",
        );
    svg
}

fn get_ettin_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjISPEBi9Cc9L87kI1zRXevxVoaJsmMWRGvmBasOOqfui40rbKruZmc+bwXJDCkdHjJVOwJJF03EBO7jdLOajHhmw6PWILEZEXOSXgZU0W8Yleax779aeKaUqFS/vNLXjn6VnhMe2BYJjQkg3pmao1CfUcwYZNLSYIzRJmca5KdPpGfQZakZICXgniFAAACH5BAUUAAIALAAAAAAgABoAAAJ2hBGny70BVXpwOhmPNbPeh22c9o2kOSaZsyKueqKM6Eq2DM53WmsZDdtYgL/G0NTyHWedzsWDILKS0eaQZsRoPTCUMObL1ojYKpQbgVbF4F2FCi5/SyqnDld6xex5igjex/E2GAjSlVOo18OTeBcl2JjTUqZQAAA7",
        );
    svg
}

fn get_giant_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQECgD/ACwAAAAAIAAgAEACioSPqatx4RKcEVRzn1w3MytNVsdpmJZV1NkgnroxkAs6dv2Z9N6G4szSkXSuiAhjAwZjuSXx6fFFn0iKdVo63bagprML/jauL7KMapUyfbikcnTrkshAVecqfQ97rXiWLxZGJWh0NANzxvOBhfa2thiSw5jXVjPJxJUUCKjleAlXp4gkyTn16dVUAAAh+QQFFAACACwEAAEAFAAUAAACP5SPoIrdEGIEroalQt3ian54GESBoRSZ0jKlJneNGerEMukhNlvC4/XakYK/ng8jvJGQLl+F8QpFhZ9opwkqAAAh+QQFFAACACwAAAEAHwAaAAACc4SPqcvtHk5MoVZqcb6Ayw92zCZG1mSc4XShKZt1bPq+Z4xyrozEvC+yAYWeIO1o7N1CyN6o1Ng1IQup9am4Oim1LXerknmkU7Im+qWqla72g3yLm71dLMRtguYfRH1pnvWRN5i0Rmgyw7ejUgTIRDMkVQAAIfkEBRQAAgAsAAABAB8AGgAAAnSEjxi76XpCkjCyyWQDehr6RQ/XgN9lbZy4Zu65xSEJWyQoK+aNzr6746lWLKLR0/Epi6Pmchl8HplBSrTq4dUqWeYDN9pFMeNp2euoDk3nKQzYa4rPbZqog3eHM63+0GmUJwhYNJgDOFfCRuim8VfX6BVUAAA7",
        );
    svg
}

fn get_harpy_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkoSPqctx4UCUJsK3nJbTvr1lFHV9Y8gkYEWmyDpVcYu+LcdqXq1Afvn6AV05HI7nig1lthTMc4KJQLMezQo9YVg31VV3kVZt0HLRSRqrVsRmSd3m6rTx6XFU/2F2nyV5brEDaBfVY1b1lCTlFdLId8VIM+TzZXXD10gXOSgJSRgWaITkxiQoV2eSikql2IX6elAAACH5BAUUAAIALAIABQAcABYAAAJahBGiy71xYpiuvhnRsfZA81Gcg2naNzrguQBp5SoYlLwNjeCQ3ep6zDvlhLsUcajj/WZAXm/YaHaitYeUg7DggjTGjys8gruqoFbjFIRXaUaWdO1UVYZgBlAAACH5BAUUAAIALAEAAQAeAB4AAAKKhI+pyxkWHpCNvSvj3NUdzIUVdXElaUUoWEKq97mKJlKbukIhvu+ZDqTddKwWrTg8EX8m4015ssmgE6pUSExaO8nnUDaKsYDfY8/7PaOyXdvrg1V2EUzRXB6cZ3P0H4heU+P0xyZmyNOSBpjxp2EmZVHVZ8c1tVS5wFTHhUMo2dkQBemC5+E5U1oAACH5BAUUAAIALAwADwAKAAQAAAIJhH+RusAKHYoFACH5BAUUAAIALAEAAQAeAB4AAAKKhI8QFqsJ41uN0SeloxfneG3ThzjMFJZZY1aJq8DqeYrtYdKsqFtu3olhfsIazsPpCW+2UbHU7KQ8lpcxSvtgR1MNd/gFAsNGlDMkBTvX6/R1djsGv71ul15Ey6nTSnS7d8XSRlW2tJFkeAQm46dk1ZIGM6ellEMC0XhJsjP40rm5J5N5Jxr6uVYAACH5BAUUAAIALAIABQAcABYAAAJihC2py3pvAmjUSQiCbq/pe4BVFT7SNnrnoQRp5SZRNr3cSp/2sl59AsJkgLnZL1XE9WqCGM9SzHGmDGUV6MHymDLnS0LS7VaL5K4ZNQ7HRYo39YbG4TTInE1Z28Aw/bduUAAAOw==",
        );
    svg
}

fn get_jotunn_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACj4SPmWHBCuN6Ty4LXMNHN591TCWBFXWRkKeiyIg56jfDsW2vYXyVoP+yaGafDGtUI4poMgopp/g1nyilMSqbhJSm12lpfW5SwZWznEOWxrtrh71uE606eT3+tvfw7PP+nrcjFjb39tOGBSe4MQWU5SXShBjZGPEYSFkZBWg0Jfm35ynKNTcqmnliqoq0KloAACH5BAUUAAIALAMAAAAdABsAAAJyhI+py+0PTwixAuqw1WpKb2Ach4CXFIbjApIimrJmOWskfZ53vsN+l0t4apfbxChqvYSUke14VJWCUlr0E3P6oMGra6p7fYWoZTNG3WZtqh47DSd3f3Ewj95To8cy+1LXMDPXxMVwBUPItQPlksT3EVAAADs=",
        );
    svg
}

fn get_oni_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkIQRp8uWjR6csSVJLWI3z748mOeUnElu6olm0qi8nky9sEPXMRxgN7vpCUErS0/1M12Op+FMWIyVnCGoCHKVHkZZjfeXLDI5PhcOuqWGlaI2rvVBdbvmc3u81m7heW32nzJVkRYU+LZ0tGRIyJTIFRXn9Df0+Gg0tmenCOkjQ8QmVuHomeZpJagX0UGEV0hVAAAh+QQFFAACACwAAAAAIAAgAAACkYQfp8uWDcKDNE6VbmWZx011y6OB3zk6JqI2Uwm9IbvJ1Qtb9I2VEmaSSYYilOtH4n2GLsuvxswliZxoy2M0apKxbnbXREgvORqRTP1in2wSt3Z9v+EOptMWTGXLYa5/pZKBtgRYt2T1NLMlaJgYc9YiiATiY4fFIiQGpIeUJsY4iTl3skV6h2IpQtWBg3k4UQAAIfkEBRQAAgAsAAAAAB4AIAAAAomEHafL2JGaVHClOOelAOfXceHHRN54fmZ5pBLmwqT8tm5H13bp3e0PCW4cj8pK4whacBWVMrUS8oxE0am3HGVZ2q23yROBmGDyUddMm87on5atIyOU1cy13rUTj3DkpbfhE/ZHVUaC0/V3aCXXxwH4ggUjlcZlRJlFBQQ3xLSp6Vn1FDIJRFpRAAA7",
        );
    svg
}

fn get_pegasus_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACh4SPocjtt0xIYM53YZWP5Q5qnGZh1Vem36ZeK7uJIfZK9UzFZGhl0ZlzoIawxMrl85RMwBSPpbjRZlKcbvez7ihL7SIb7CBrUbAwFnEZy+f2V/hCXtW9U9TYQMG+bI6vi2V35wd1piLj0fRUhTfypIV3w/iYZ+bV6ASpQzTJdASkqVapKThTAAAh+QQFFAACACwAAAAAIAAgAAAChoSPqcsa32IM5tFl5aGwXpB5EieCFfM5YEqSq9UlKXJBMy3TbKvG52ranGocn04odGFuuaQpE/rAbDKlQ1q98V7UIAz1bEqNvSdWxZ2YfzqWmsjEaOKjuUZevzeDe/2GXOKHs0SXl1MkiFSyJXg2xNfIZlP4hmMVyTeZ+LMD6ad5tJk2iFAAADs=",
        );
    svg
}

fn get_rakshasa_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/yIgNAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjoSPGJGwDaNhico7z8tY2rU5k+Up4LkxJLRyzidibaZqddnNs+u1d7MThUy6COVz/FWAShtPAYQ2gytfTBWMaZ6d5fa6zUJdqcfwYv6KSyCytHt6wroV61gmTp7prLaWHxUIeOc2KJfj5/dHFFLThlL3mPby8ihUWWkWJ+RImdYJipU5IolVWib3eVmlUAAAIfkEBRQAAwAsAgAAAB0AGwAAAmqEjxFoyg/bW7HKRkG2+mTlXOHEgCYobQn0fR1bLbI3k9xb2tbo4T7Jo21UqxbGRzwSQ6rk8AddAjvBS896u1opriRt+0JVeyhwFsN8krNjF8erxerO47PGJLdH4O9V/qYGIXCXxhWDZ1AAADs=",
        );
    svg
}

fn get_roc_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACeYSPqRkWvcBjTkJ6bpT7zgo2Iic+GnIqZhdBp7e1bqrGlh3TLr63YB76cWofx4SG+2mWvkWPlTTWMChmpmgbKaPcbhTGE1KR4yHKK8TqnhbsmWd1c8FvZIptejWr4mmX7Rf29zY2kxEkhUFX1DMCRga1BIjmBEmJUAAAIfkEBRQAAgAsAAAAACAAHgAAAnSEj6kYFr2iBJBO9Wg9cF8LYs7HPR5DlmiGJqephm3MsGLl5fXNXXa/gPlwmVMKlDN+GjjaRDdyMIESpdLpykarT2n0uk11uscvmdQBy4LjI7T1C5bS1FjT+g5NmXehtunFs/ESx9WmUcaDGJbIVtgIGQlQAAA7",
        );
    svg
}

fn get_vampire_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkYSPqbsR8CBD8Tl246nJ6ulYGHRNlKl8jZQaqsua3BqnapjB+P1S/fajoTogHQkjmhE1pVlJEoRtWKLp8FRNyphPqpLEBe60UNf4Ch5Hi9f1CV0jSuGx2zFOyy27/E8IX3aUBcXx49GCpzdS90bVZnXHCMeFA0nHNOe2w1g4teljhgn5F+nnB2RJSqimuMoKUAAAIfkEBRQAAgAsDAAXAAgACAAAAg+Ej2EKHN7SeW8hey1VoQAAIfkEBRQAAgAsCwAVAAoABwAAAg8MjmcQ7ckUWjC2dOertQAAIfkEBRQAAgAsCAAHABAABgAAAhFUhKl46xtAe0YiQG/eYb4OFAAh+QQFFAACACwIAAcAEAAGAAACEYSPaaHK8NphNKZAEdbWLVUAACH5BAUUAAIALAgABwAQABUAAAIsRICpGOIPoztnKeqAhHr7FzRf+JXmiabqyqpMCCMbxRilclbi98rjZYLtHgUAOw==",
        );
    svg
}

fn get_weretiger_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACl4SPqcsQ9kJ0Uzq4pD0zdahxlPiM5tdkJbKl1xpyKwVf5NuVOvuKp83IzRoxja7l8hw3SGKv5nsCcTYm72fZVaKeGwoT2fmayi7GPM1IXduhmp1UI7NxxdZbN52OslQRDFhFVtVHw3c2NFPhRqdYWCOmNQYTNnZFqXc3MsfYE0RjN2iHVejpxKL55HaV+QniVLlKkppXWwAAIfkEBRQAAgAsAQABAB4AHgAAAouEj6nLEJ0eRKGaal2eVNMncVF4bOLlpGVKihkmmdD2xqHcsaAH7uoYQwWDmtbO9/sdk0Reh4YSlmiY6U1FOtouy1UP2wQLe00fEbmFPRXIYvrKjPKWptZqqlN/2EZ9TseV5CIYMUi3Zve0hcfI5hH45YQTeEcIN/KXqLRAhsUwJKNFqMiC+Ph5CFAAADs=",
        );
    svg
}

fn get_werewolf_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkYSPqcsWsZ5Ms4HqrkbyWdiB2RF6jUluZPmdaNhyUCrPkZ3ZIs5gI6U6aXguy6U0wZlQveGQJ/oZOatN9OPBzKDMGzTo6E6PKS5RgTxerz3YFvRtJ8npXIQM7uBpVHZVxwJ0pocWdvdGqKR2JmglQ+dTuFOTFNnItWcpGUQYJjZmiPY5pqlZZAkH+iQ2qepqUAAAIfkEBRQAAgAsAQAAABMAHAAAAkOEHaca4g8jBNLRirNIuvsPak1IltFlikAStN7aHp+clmitrfck6Q6LqOw2C9fjAFw8Eotm65l7PoOgVWmkAoKA2EgBACH5BAUUAAIALAIAAAAdAB8AAAKHhI8Zyb3+VIiMmmXB3E1TrCHbWHnc840TpIQS53SmuMa06MpeG4E6fMiEfLycbgdR1VIX4fBZC+acth3KWAReaU7gBTs7BntYL1c1IxObaNQJx7uuSNE1aB32flyW+RiNk0Ii5fYzWKgkczel5BezmDZnduam5ygW9hIlNvl3JLlJSDU0mFUAADs=",
        );
    svg
}

fn get_wyvern_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAAA/wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoSPqcvtFsKL8kFaF86MAqx5X+dJJvdFCbdBo4nAbtmu73ycl9iNPl5LqRTDmPC0CeZstVbS9lOhkLciy5cppoCoHM+qxTFlrK7XDGI6wlgLTxhy67wWEh1ej8fYUM12V2c2o7QmCJR3hJjHd6c4tyLj6LL3o4jlZNkTmcnZ6fmpUAAAIfkEBRQAAgAsAQABAB4AHgAAAoWEHRnHre2ASvBMCtdC2GnZWZuYfdqIVCBDjWckxR8Ypqglt1dV5891Y0V0QM7NRfopdzHhplMs8ibOlcyKa7FcGFOQiiMNUU+huBRslkRHcvq6gvZU2/OcbkPj6bXHnmf186dyIsi3Z6LGd3f1huZ3+Of3NTNYWeeYEWakOLhFlel5WVEAACH5BAUUAAIALAEAAAAdAB8AAAKFhI+pFrEN14vIWSoBxLa23F2Mo3zJF2oqSI5qK55aN2NHer/XJpn3BrTJPLpgrcT4zWooYC5HMhmNE44uGYPSlqPo9UTxcSvjFcos9qRXZBhn3eo1lXQQO7rO1Lv6HjcSZ9fGEyjY9tJHJFOY6ITEWKUH6cd4lpjE5jJJiYd5WUL4aTdZAAA7",
        );
    svg
}

fn get_berserker_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACeYSPqcsY9x6IsCWJp6G6284FWfZhnBKRjeSpLGuJ73TKn6eFuVPatGMS3Xi603CjqvyOFxQzxnuuTNLVD1aFwIRZ5Oa7lKa812pKhjYOX1wf7paMYkve4pte+6rxu9EdSsG28yQ0kzNHCNSl1LJIBObYFFlhOMl4UwAAIfkEBRQAAgAsBAABABgAHwAAAmCEA6LLDGhenLSeihYMS85thR50SUhwjliUgmnpmk8re5+iKuQno7vfs3B0B03I1TCCRLti8umIQKfGBxWaEKBw1673Cw6Lx+SyuZslU8ZD3bgShlnFojqr1rTr96ZqpQAAIfkEBRQAAgAsAgAAABwAIAAAAnyEYwmI6/qOVI3CVivc/Ok4faJ3kSNYYhiarAvjBDDjwtEs2eQmx6/f4wRzJtDwQtPIaB2eD9g8rI5Sz6dzvUZLre02SPWmdOJWrVpm/n5a4WsJJzcz4GHbwgp5VU65G9fl13dDdBdICPWVWCgWlmOI9VjGtTMZCRkl2FEAADs=",
        );
    svg
}

fn get_direwolf_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAAChYSPqcvt34KcAVT4qLQbo2tQh+hNoxmSGZp2HMto4CI7ml3HN74rPQ87qYIV2azlCllGrx/yyDk1g1PlR5j7oKAJI1SVmX6JsafPNAOpzee19aXlws/hZdelLqal7SvbzuTzlnfUIbe0RxMIcfH15hEF6Ab5WLRIWZmIaee42bV4GJYYWgAAIfkEBRQAAgAsGQAUAAYABgAAAgpEApmoe+wUPKkAACH5BAUUAAIALBIAFAANAAgAAAIUhH9hwair2AMTtvTi3Mj1X3nUdxQAIfkEBRQAAgAsEgAUAA0ACAAAAhSEbxGnuPBgS0xN5hDctMf5aWIkFgAh+QQFFAACACwFAAIAEwAeAAACXIQRgal731hbCRp5JEN5X61E3qc9JglOJ1WuXeu+m0pB5RSuM07b1WWKfGIZoINYPJ5ooiSnqBrhnMvek1P5XbWs6cvifVqDLqbRct2i02evNZp+d8jLNjXpNhQAACH5BAUUAAIALBkAFAAGAAYAAAIIBGKYaqvMWisAOw==",
        );
    svg
}

fn get_ent_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACpIwDBnvMiF5qMyZ3V970wqo5FvhZ0FEqDYpOYelVquiNtN1paSgq/PZq2Vw6X3HU+iF/PBzz83oqgc1gzIhhZoY5XXbKxXqH1WayrI1JrON0scZyibWzzupErd7jQnJPxsLn9wazUiNHd6WIhwd2Yvh4l4eYInTlZ3K56PWUuQOzZjbpdqjXJkPzd1S2RDWXqeYDZdL6FQlUa+QJosbRyHEK61sAACH5BAUUAAIALAAAAAAgACAAAAJ9BIQCkSeMnFkuLphyMxjr4GmPSIpViaYKp7bfFLpoLNd2S9/tKQaLOgn+ZiqfkKJL+IxHHgIELTVhJCbr5nxAc4/pMNNMmo5SSnBJEqaswTTTV2JTxRF68ZzFHrk2vthvFyhDAVhzUVglxzFhAyPnZ3B39paW9XY51+cIUAAAOw==",
        );
    svg
}

fn get_fenrir_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACfYSPqcvtD6OctLKQsFVBg75dINZ5W1kiJjVqJli55JdZpMvFtLHK8ZzjwR6rQ9E4DAJpRyTk2EQWocSa1bhrJF/ZJFb18XCvN3IWC5Qtz2te+C3uvpqplJANXsC8vrvW/fYlhHKBJxiUAaUmkngWaKdXwwdZ6KXXloMZ0lAAACH5BAUUAAIALAEABQAcABYAAAJVhI+pG9gLVXhgxutsmxRn3nWe9oRiVG5VckJbKXkrJaayxhwc6qKWY1AFV75e7LIjsjC1IbCVWdJazZ8TOLReQzPnjqt74qZTpO0ZPZ69JnT4rQMBCgAh+QQFFAACACwBAAUAHgATAAACQIwuhsvdeqCbDICAQaQcQaV1lBFakuiE0YVOLHKp7RLEWj2nG547tSbreYLCovEoICITyeVDKSydjDie8+ek1QoAIfkEBRQAAgAsAQAFAB4AEwAAAk2UDXHL7Q9jDEraBdLdiPKbVd9ILkEolkeSJV55trKbWmc8t1QOPDov2wUdOGCRgiuylDnh76ZDWFwM1qwGCVWhMU7I+q1gI9+ZCpEpAAA7",
        );
    svg
}

fn get_ghoul_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkISPmWGsDxubMyqHXNj8WlgB4Udu4hlh5WmSoNZkqsu1EutmbKfbnhwLongfk6ZFnKWGMdhB+QglVb4l5opq0haURdYChX7Bl6pIXH4esb4aUNqZXbG37rnmPHtHuyDyxuRkJ2Gkdsf01sPll6LE9zcGtCeZJyMmJ5d2SZWpE/m0NyjUuOQnGppzGBaX2mpQAAAh+QQFFAACACwJAAAAFgAfAAACaoSPqathzlJwlCIo39yxAWh1l4WJ3/OVy3SiB9tw4wm/tPxWs9u2NYuRCS89kM92ywWDyQyqZFzpckhnBlbTqIhAakpFempDVOhtgxXb0qnOdCzqruNZdaROu+N5EnnMw7eTtLcG5dcHVAAAIfkEBRQAAgAsCQABABYAHgAAAmiEjxC26bxiTA21gPPbU/ntYF4FWiP5iB+pUhl7Kej0WmIrM0fF26uq2QljI92OdmnhkJRh8+PK+Yw21AkyXepuxteseIR0oOOrt3TtWqO8YAmXBsHBHGs5dIemqNPQmxU2F1elJ8NVAAA7",
        );
    svg
}

fn get_goblin_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqct9EVyDMFVwDY1Tx/xQmoQ948mVpPqV7ZeuIgPG5OsiuOxx8c7TWXKrk8oCcswqyaPSh6zdhsajTeFLtVDVxVYLDSutXCjmanJKQ12TbcPUNXtvKvZuJp+RXuIItmUn9JMD1DYB6FJXBMMyc9iHY4gWRFPkwSd481ZHGeW1JvEC5ndpqlAAACH5BAUUAAIALAMAAgAbAB0AAAJRhIWpy+YWmFQBzIuz3lzZPn2CCJbmmVQqmgbV42hkGGUVBrx4Pjf19Lr5cprgjEcsQl6OFccFabp+m2kTSZVhedkik3tKssbksvkM4pWd5FcBACH5BAUUAAIALAMAAgAbAB0AAAJSBCKpyx0GX5vr0Iuz3nyhTn2CCJbmqRyBhCYHBFsZGQKaXOPTo+/29eolHixMkMYrGlcG3kuZUTlXTFDk2fxxmFjo7fg6eVvksvmM1hDNYbahAAAh+QQFFAACACwDAAUAGwAaAAACSJSPErfpDyGINE1zq968xwCAjZcEJoCmKCmN7BGur+V+GRLXDxjTqL778VKizikmNHlMQ9HP84sWl8PcKzTLarfcLre3nYZRBQA7",
        );
    svg
}

fn get_golem_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoSPqcvtD0GYM7pg8MHaJqpUXphx5oh0n4RuTCVC8KtxjwjXaRmv6SmxBUuk3RAHQvpcKpeR9Qw2nb8pUrh0qmpCK1T77Mwyw42OOjZ1k1+ytI0Gf2LT9tiOFtcp2K/4XXZEBYVDdrXVQ2TTpLMVwXUmxXZT9cdTV6SYCHLByXl5t+CY6PeZFeV2asZHCmraAlEAACH5BAUUAAIALAIAAgAcAB0AAAKChI+pyxn/mgyGHmqli1svG4WZB4wIRl6M2EDlCr5KxspV5aonBqJlfzvhfrhayGETKl+j3GzGiR6fSCIxhjQBg1cVZ2jtMqcQlM9l4tKCzrTWF6bx4Bf0WsYr5rZH7a0pxQRmU6ZDxWZY+JHlVPTxFbeTpDa3IwKZxmW49FPWqOdZAAAh+QQFFAACACwBAAMAHwAcAAACiISPF7vp7wKQylCI5607Rw2G3vdIzAh2SGOqCtWUFxOvCW3ZdT3dr2Xq7Wa+GcxXEb5cvdupKWSVSEpOrogErmDBHO9r7LbEpzFwN71Cocd1UttiJ4cy4jVmFrFw23Zc8zXSNbfGZAOoRiOVscHH9sS4hdjH+AQJWIbRKPLmeEj19tmnCKH4VAAAIfkEBRQAAgAsCwACAAwACwAAAhyEg2gb0HzcW642peSkdtPMHVO2XZJYoWTiRUYBADs=",
        );
    svg
}

fn get_hippogriff_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACkoSPqcutYWCT7kUXsqYM+lwdG4iQ4jKiHCWZZ5ResgdoDye2sqVur14KsXTAXcVWSypZoV+Spow2QUCotPmk4a62GLT4gllhSzKvNkbNEqt0B12OUrFM8Jw92Q6NV2Gu7xO25vSXcxc3iKRy4kLYd0EEFxSpxif19QjJhjTmJiinydix9SRqWvKB0ybXOYn16lAAACH5BAUUAAIALAAAAQAgAB4AAAKJhI+py80Bo5sGVhQDbbbq72RWB2jXqUiJyaarWmZni2FmfM8luqekvKPdcjVgLNgbbnA6JG/SGvVqS2nStTwmic+XBHSlHr7cIpjGLGOdOWuVOwRTiOij2uOu29tMz1hrM+W3cvXB16amhPcVBLNgKCYFcmdDojO5wVKGSTlGyZkFhdT5lhaaUAAAOw==",
        );
    svg
}

fn get_jaguar_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqasRDKN5gEKH7Z3MNVlxiTaCj+ZV6bGSnAWz3/mpMUKmbsjLEbWj1VgZ0QgDOgaNPmaztCGiVk5TL4RK4qgq3PAHre4WGW4sF2XeslAd+9QaS71GtO/cZD/Rt3rJjdRiQ0fXN4VFeNe3hSgmNeYhJFKmhZhFI4RZ6ZfZqFWkabnZFRo6qlUAACH5BAUUAAIALAEAAQAeABoAAAJxBBKmy+15nEEUyhkb0hdb9TGhiIHdJkHWipKtebSsqJLlneKe9lX1Mzq9QMPe45hZ9F4UW8dkXD1pIdkUCUtmhZUtLvjN/rQllDWSUIGJUg9TeUvHt1VXmJxWN80xo1I+NyHX5kJIhOaV0cWDGLcoUQAAIfkEBRQAAgAsAgABABwAHAAAAnSEY6nLjNhihNCFeyV4La/qbOFEiglokdXqfRtItexHnfYt1Tb6KpgHw2gssIOGZ7qhlq2XrrTziZC5Zo86XCZxxx/HxQUbV8YeGPjlkLtfU7OYfKy3ZO2b2/Y69+HMXD4VNjZ3FXfy48SjphRY01YV5bhRAAAh+QQFFAACACwCAAEAHAAcAAACdkSAqct711CYNJrbJoNb9sg5WBJupTdyVaeRUpuWbQjRFmqfsEHVzn57yYC2j2t0FCpWyOBjeTndmK9mMOnRXXk9azEDVaG8VR7mWZMuNWJqsS0eN2XmI33Wrbh/KRe7zxJX9SSHQ2VGGHPIgoQWlWUFBunzUAAAIfkEBRQAAgAsAQABAB0AHQAAAnuEj6lrEQzhA5O5W9fMxymePCDYSQ1CdinFno33UdwGt3K4he5u8eyYweRQl8in5lrZULGls6iqKGdLkc8IVV2NviGTK/SWxpqvNDl6qVvWcwTqRgZ3bfL8RLXamVLMTSSHYxNXt6VnUTjoh/UzVldz+HYG6BEpUaRXVwAAIfkEBRQAAgAsCQAGABQADQAAAh6UH3lrwQaiewLMJym+WoMOhhQnHlaJoepDrm7VigUAOw==",
        );
    svg
}

fn get_kappa_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqcsW+ECcsMFAZcbRpseFoPdhDjOZ5Nl90qqArdnCp8MdtT26O9wJ6WwujfBFvMR+QKaKqBLlNLyb1AocLoIrrpSmbXA9YxTL0mMiX1/R2ql7bp+/YM9ML7Jx7fON5YUX97YWthWDdHfRh0hxN7UUGEjF54bjh5hZR5YIaeQoNqI2JJNkClAAACH5BAUUAAIALAEAAAAeAB4AAAKBhB0HuejHlAyR0bei3Jd6n23ihU2QJoYoFKZjiySry8ZkQ7+rnL921eP8SLPe7RTkFI9GywcEo1mGU5xLs1QUMbJnp+azXsFa1rYBNDm8XiuqAk19wE60FF3lPdhQIO8tVgb4pSYn9PXGN2iXKLdomNEWeAUYyCRUOLmlF3cypVEAACH5BAUUAAIALAEAAAAeABoAAAJOhB+iyy1xogSurjmT3RCfvVHgSJbmiaaBloZiW0XwTNeXZN85s7ZQC+hIfrDgEIESKpEqhAGyMqCeUKMQ+AxWa9Yu61TtLL7Jm6zo4R4KACH5BAUUAAIALAEAAAAeABoAAAJVhB0gy+0C0pknvMskpbjDPVneJY7m2W2oF7TuioEKjLU0+976zj9u3lvYgg3DLXLTbEo0ZeUAe1Ikx8jUqENII0xTS5oYJsNWTbVcmh0z5O6qXe6RCwA7",
        );
    svg
}

fn get_nemeanlion_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACjoSPqasR8J6JUCK6HJx69+NoYlZFYWlaFcO2DPWNaoJdtjo3mWSNoA/auIbEoo7UwQAvtZ/r9BJ6UNTmsTFLBq9YjhfH6U2mxqC1jE6r19hUifVhOr30bc5kc+bG4B6eGiUmNsYXcifV1Le3grPkEcc1Z8gDRgM3pZSnGUUIdJZV9xfmJwTD82bWeMaWUAAAIfkEBRQAAgAsAQAGAB8AEwAAAl+EEYG553+UYxI1iFlLlF8cLV4YjaCkpB9lgYaaovFrZq121hDc9pV68gFHM07l5espZyUWymIU8TLAy/F23T00RpkLuQ1PvkoS1Awe27o3tDutPmazSF6ns6Wn9fBXAQA7",
        );
    svg
}

fn get_satori_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACjISPqZvh79BTgcmI22zUrvp91TiBHhMBJlR2KmgaLHTEXB26N5qOp4chzX4i2yq1o/SEr03S11xFbZJqiNrUqbRJHHer+VqwxDHJWwaDh+RTcFNi/VowGRLdkXqdF+Or9saHFxOXYYeFKFdFkyPTB0NzZ+WoEQmIglcmScmZOdmFiEYW2tXpaWpKRVYAACH5BAUUAAIALAAAAQAgAB8AAAKIhI+pyxgNWZjmvYirvYBnZ3VT+B3cNY5daW5iSrHaG6uwt9yxhq+Q7UPtTC+FytHq+YqrE5KZwAkrydTyidzZYJJcbaPrGik3mvKapFWHxGiYd8w9y2/xVWclGdtrK3+PZqYnInY2CNKDIjMDePZjlxhh+Ef1CFgZ1TBJiXknlwn6GcppGJlQAAA7",
        );
    svg
}

fn get_sprite_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACeoSPqcsZEJ57silqKszbeql5SHiADFmimQqx3aW67WLCH81d4svnvhVxzELBHfHXu20omJpx2GliRJopp7or/ZxZXLLrlXVBXPAqRzb7mC+x8ApHAtEj+tPudNemfLmurLVEFYUX14Blx+OSFlgFOKGTVHSCggipZlYAACH5BAUUAAIALAIABQAcABoAAAJXhCWBy40qgJu0Lmkrzrz7D4biSJbmiaYk5ATGC8dG4FIALcs4d7v5/WJNfEBdzBIjBmcen7LohDFm1GI1WoVhiU+fzUpV4jaTmbg31pIv5vTvpXn/eK8CACH5BAUUAAIALAEABAAeABsAAAJWhB+iyy1xYlTJ2Qqs3tzVvnzgSJbmiabqyrbuC8OB6EGSNOcGZ+Qz8sNxbBFfg8jrHWkMJmUDIQIzFkCwiGgKG8rQ7XoL96RiarJ8I6HXzsVa3FbFNQUAIfkEBRQAAgAsAQAFAB4AGgAAAlaEESKg7c9EerTa6yLOu/sPhuJIluaJpuo6GtgBx3IwWbSMI4F7GbcM8WF2vEaRooH0YMSmzQcFGhHIAzETa0aZ1iixy+x8t2Pa50em1SqImbrFmuYOBQA7",
        );
    svg
}

fn get_wraith_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODdhIAAgAIAAAAAAAAD/ACH/C05FVFNDQVBFMi4wAwEAAAAh+QQIFAAAACwAAAAAIAAgAAACi4SPqcvtn0JY80hojawaTK6BEPhlJCJ2VemxDfetp5h6aOuQdGfL4X2xmXCrXw/3yggvMR6GVYouc8WTs/qKFlXYWgwWcu0sUnEkohWqjlBwCwpkI2dwhe/nluaIayXGLqf2EEThNLhU0zcyNyPIoMekpre3VeaYlIh1WVgYmfgIunno8vdUeoqKUAAAIfkECBQAAAAsAAAAACAAIAAAAoyEj6nLGQ2eg6/KiLMJt/XLad0GkWG1oSQVgYj0lVjIgHB63PCeZ3Rv8eFEP4XthTppSrqZs+gxvXpDZtLWlCFX0yzlxu0uJ6qkcOswK6/E9mjFyfKcY6AaaAJ7lFLqu9YSIwM1dQZIQ6g3OMTXUkcm8jSjEuXC+Ai5cGQWxQSn9afF0igKSlWKmgpQAAAh+QQIFAAAACwAAAAAIAAgAAACjoSPqcut4RaUaUY0gz4ZQGs1m9F9nIdSVWp67Qm78kym9bqOKheCdQbk3XqoTWfW0oVsRyPycioVpzaJNOajYkimkc+r3WqyYyaOO30tl9RX+k1jPaNvMMvJHoLcHzejL9dUlPcHVwWlQohYqGjl4CdyRwHJeERHeYnWFfYoV2e4sxV4OFnJGUnqubjaUAAAOw==",
        );
    svg
}

fn get_yeti_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAAD/AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACgoSPqcsNAaGbKVpKI5K48d15gTGWIfMd46lYLttq5Aq7ttzdOu7sPo26bFIPXuVViRFVNoxQ+exFZzdSsjjFaozD0rKKo22n4J/XONb61EdOlSpDX5DtM5CdZdrr54mEPLd0pAWF5bd3RSilCGIlOMTY2Kcy6LbgxkX1QCkCOGcFUAAAIfkEBRQAAgAsAgAAABwAIAAAAnyEf6GL7b5ieBTFpGpldurHTKL3NRxWQtKVdtzarvJJzTap3jPIYjjQM8BMud/wI3HRNr1kRkjMsGBPHvAiu5K20pEWq3uGnOGuedwkm69fI/gsDPpGZ/rP9W1rkXb9UpWnxsfWRje4lbfHBAXUCBXE5fGSoKd0x1iWhFAAADs=",
        );
    svg
}

fn get_bear_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACfYSPqcsQGJ4zMsKm5N346E41zxhO1YSSX2KhrLd25DaD1Ne2txxpVV9yADOmXcqowsRORJurGIqBpC9nUGaV6jgiE3VXc263Sktt7PPioOf0KdwV5qzXZ/3rYejWYviPXsLEJVY1OKVUZzOXgbfQmEcYedi0pKiydAmoeVAAACH5BAUUAAIALAIAAQAcABoAAAJjhI+pyxaBXpsQPGmnvbE6v2Ec5JFOdpIjan5Ha0qweIZpFr8ffYNKBXRRIihiwlc7Jo0L5EYH/TGZGEbVB3Q2S8WWhrUMD5XTBlb6LZrT2lpbecaln+rXO6q518fWubgsBFgAACH5BAUUAAIALAsAAQAKAAkAAAIURAJpiHvJGmwMmjvVw7Tvb12SBhQAIfkEBRQAAgAsAgACABwAGQAAAmMEgmFnqdxSVHShdR6jskJtNSK3jZbmVSr0ieyKYVc2z7EcP7ob5jjI6/luO+JNKEPhjiAgz8ZULqHHU0jprBadWa1xWUWyxOEuODz+mn3A3ToZtKLj5Xm6jn4PvXb6Hv61UAAAOw==",
        );
    svg
}

fn get_bigfoot_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACiQyMpwnt35JU8ISLqzPaIpxFFMSNYvmV4jOdlfqanedd883WcMcs/gT8CXu4zfAGsuVcyKQyhgPpbDtNcnMlFa3G56zlc8FQx6D5WJYh0+DiecwKac88anREnHqXaqyzutJklwEomBKSJ6in5Yanw7iVc1goJtOTaMTUNSckGbZZGVQZylb6xlYAACH5BAUUAAIALAAAAAAgAB0AAAJ8RIx3wJ2tXpzIQYlptFxnzFne8jgkc6KfeZnBe3lh+NZbVc7uzaopbYP1QLNgbajrGE+kX3GZciYNsOB0elRUr8+qVYr1HnFcSNaWK6PETfX6PFa5N1a5Wym8dxJx0dwM5ud0k9eCJBhTBjay4kOGQzHE9OjoyJj2wXhTAAAh+QQFFAACACwAAAAAIAAeAAACfQwMl2rN7xaC1Nkl872JY+xFX/d0kziNoEKWGtuS6TGvYIDHp5rdeK5C1GASDy/4+SmHxx5tCWxKoVHpUfmsWoO55fbaxX55Ye949Msyz+n2Gf2kvFfd2LxCvJeGazKjn9QkAncXoifzYqMoCLOzk7fxYsQSWYkX4Xip2VAAACH5BAUUAAIALAAAAAAgAB4AAAKBRIx3wKwJn4TNxTtztVX7tmwghlhhKG5fl46s1qbBvJwjGhv0LNp4SyuxTELZLujK9Y5I4S/G5A2VKt6RmgsqrFig9fqkanecbuerLZp1W9/agUaFswny9A2X4lV16Rx7oqf00OMkCATlpJaI+DFxo+aGYwNZKElCAel4odm5KVEAADs=",
        );
    svg
}

fn get_fairy_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACgYSPqavBfqAJTrJFEZS2awtU4Xhp0XSOYpk+KOk1YMZNM0tGIM6r/X6zhXYJ4gvmaxWNvpXykTlGbdNjSrT5VXWmnvf7A1M/Hmb3FKtsG5iijsKMd2PtSy2de7rhQ7d9neOUx1LWl2XExxVFBMSGRDcYdJhUUlM3KLZlxgMp5rlQAAAh+QQFFAACACwCAAEAHQAeAAACdISPqcsaDYNc70FkgZ2m3p5wmXdlx6hpXGOeoAqz1KtKbTinHcnc+oaJzIA8GS5l8oVaJCCth7LFkJ8o1fXRaYvKJQiFFb4qvO50lLx6dzGm9PjF+phB4okepjbF2rbeuOXiYbaE15e1dojIxrgYlOfY41gAACH5BAUUAAIALAQAAgAbAB0AAAJohI+By73qIggwTflMvWrLSh1diF2aOY0liKaUx2xdMmMsK9p0XusnJFtZgCdL4xYi8RykWS/3KXIykaTUA3MNU6gsVhRsSbnNx7OL5oJjvyJuvHZOqczpGV7HlzTvvVHvF+Y3SFi4UAAAIfkEBRQAAgAsBAABABoAHAAAAmuEjxDJGd/WamgqA/Gl+2QrcZZHShkzkht0VpGGPa3qwEqIvqub59OYoqlwttQM9yuhQDdTjcIMGTm3YufaS9qwPI2T6TiBgJdfi6X1fMId85O8g3tr0q2LnKyLZPcylQr2FxYoKDRTKCdYAAA7",
        );
    svg
}

fn get_gnome_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACdISPqcvtDwOcStIb8qXZbtdpXxN6YxWeSymqBtu5MgizrmThc6y1Y18zRVq1l48hNKYSSUQTYKuQTJ4l9Wm9OpVNnRF08EpfUCw0TFKebbgcWHcsk5/bNbAsxpxX9Ec/PhRWgrZRBbfXt0KGR5jIJLfIxVAAACH5BAUUAAIALAIAAgAZAB4AAAJmhI+pyxAN04sxWArtxEpfLnlgqI2HV46oaLbnCnPPNKvXvVUz/DE9b8ghhA7UUEgssoYnyeuDDOam05eSlmxea9YFt7a5OZjcsbmEwwXXa3BPWTRrwfEdJivVHd94ufiXwZYCdVAAACH5BAUUAAIALAIAAgAZAB4AAAJihI8Wwu0Po5wtWIqztlz7D2LcmJTliJrqyiboy7VHcMpIbAHLR8N5m5voaKbfLHV0AUCK2YpUrEiGS8gOumsYIilaSAcm6phe6WN0fowFVe2Bq+Rm3SZIKYSnvPLqOb/tUAAAOw==",
        );
    svg
}

fn get_kelpie_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPqcsYDdsD05lQ45nY0qt5D0dlIYiNXWZqXZKWp7e871m1d8vkoBPjwWqKEQ4mNIZ8khmHaVK5oj/g7HNRKrEuVNa67cl8W6PwA918zxsWt/Rky7zF1a2IDddTMSDpPbf290WnBshXZcHmZoYHOJQltXdXs4JGFVinaNi2+IP4eAWXJ+pUKloAACH5BAUUAAIALAIAAAAeACAAAAKIhG8RyO23FkzqPVkBtnxHzVlRpXxgyGTIhqZNCaqodFJ1S9OQF+rTbuqkfLFWjfib2ZCJZoepC/ZW1NEsmjwxnRoT9iNrwo6s4q3rEmOsFyo6yU47ieOSb6y92PG2vIgkVbUSRlHmVnZXFNhlqALINbQzqCh05pLzd+fotyUH9tPpCUlo5MZQAAA7",
        );
    svg
}

fn get_leprechaun_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACVYSPqcvtD6OctNqLs66hh418hwiSgKl5Hsgu6otacSx3xrrNLLzbp58RqW7B08/2oUWSzJ/xknxGlUskkyoBOnMKbBbmXd6EpTGRSw4/yNJU1KhdFAAAIfkEBRQAAgAsCgAIAAwAFgAAAjGEjwnBoYtckoae1p5euF9lOZIYgZMXMZVarSwpZjFHqzYEwXZMsWs5SXVCP1yLhisAADs=",
        );
    svg
}

fn get_mantis_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACloSPqcsWkSCQEr0aJ3ZPdecdH3dZmWlt3oapHEi5bTO+C9WI0O6CYmhiAWmdCs+Ii3wuzGYsqVsWmZqd5laaZX9XKwl6nPiuypqR22LVdGJYOSX7eZUp2rDOvlXn8P6K/pdHl4blF4QHKIjysrY2hqjoSPIW2fNY9YWU8+i4tMkwF/aJFdb0qdZIBWqDOUNWSGjWZTlRAAAh+QQFFAACACwBAAkAHAAUAAACRpSPqQiQ7ZYUkcG5QHgxVExtzxGIoKZU5rkajVC2k/zCMkgiNy7tPMX49YTEYgZmTCE3vhMSWSM6Vh7jNFEqam7NRbPLKwAAIfkEBRQAAgAsAgABAB4AHwAAAmKEL6nLeg9BmynagANdIAfbHRiILB+kbRy2GWlzvduJfow8SbN6PzhPsQGHxKLJCAwhl0zF59eMSqc5hw66ZAl0Sy61pf2OvuRtA8vrjAxlQVgKoYZcHi8yQxVO0EerC8ZTAAAh+QQFFAACACwBAAkAHAAUAAACRpSPqRiR7ZYUkcG5AngRVExtzwGIoKZU5rkajVC2k/zCMkgiNy7tPMX49YTEYgZmTCE3vhMSWSM6Vh7jNFEqam7NRbPLKwAAOw==",
        );
    svg
}

fn get_ogre_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACiYSPacF6HJxcAMYF65T3NdRtYPhFmah0lqmhqclqn5vMakg/4J6ftd6zvCi01QxYvJyOSlGmAauUXMufEOfAyrJa3o6FbaY4wiEnV+v6UCQt0znK/rxEDO6exlNIo7Z0DoVU51OlowI4IbaFpHb2x4jW99XyyAW5GMjm0QJG2QME1qVJ2Rlpd1AAACH5BAUUAAIALAQABwAZABEAAAJBhI+Zoe3HTHShSmSfrHlpwIXKNEbchjWnxbCZCb2eCINfmaq2Ws82idqVTjziTQgCIpck4yUGnLRyqM6zg832bAUAOw==",
        );
    svg
}

fn get_orc_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEACkYSPGQGrjpZkx8HGJk0VbzoZ1sWVonSGJbqmYqW1Iwaj6rp5Hpub+D3zsWqjIYhIcmWKJlsq+bxxlkmSpteZDXfYlq8R/QpjO3FzyzVPdc40cUoNgmll7JUHybfhdPMeD4iW9bL0YAM1eMH0drZ1BUbGF/cR1RUxpxXpx1emo4ZDKPUZ5jZKymaqFCGqJqppUAAAIfkEBRQAAgAsAQAAABUAFwAAAj6Ug6bLh9HiSgDICA3Id6rUheIoWE0lckepmKvGmKj3VXZmfw3Ex/oOIpFUw41Q5zoqW0sNJHmEkqQjalVYAAAh+QQFFAACACwKAAcAFAAUAAACPZSPGcktAJw8ccpqszZrho6AEwR8nxWQ5kdiRwqtLKmopRmLAuyeDX8zOW5BoUcBk/h2rIzrsUk8o1OnowAAIfkEBRQAAgAsAQAAABUAFwAAAj6EL6nLctDiMqHKCGqFl+XNdeJIBpElhgmlmUroKgHrTe3Mxur6MDpmIAlfw9esuEIhl4kYcqZ8Mp1DanVYAAA7",
        );
    svg
}

fn get_pixie_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAAACY4SPqcvtD6MEoc5o6XXB9L49IBgyY7l81YcmFtu6Kya9EInhZk1maa5SuTQ3m+eI0Jl6mlXGyEkenk7eCeZRipjalrNbwoEvyjEti0aN1sgQdkp0x+Hm6E/d9U2gQ33sD2hQAAAh+QQFFAACACwFAAMAGAAbAAACVoQRecttipw84cWJb81y7/aBSFKF1kSSYpY6plu63ChjEG29i6LeNxg7lYKrWErVoVA8OmXuMoN4ZstHi7rLYqHOaPXEmWq8UDGLG2kyflaqjt154yYFACH5BAUUAAIALAMAAgAUABwAAAJThB15y6sQWmywTkfPvCj3ilFRolwcU4JfRp4nOqIe8r60Zj7OWJqiuoHUYrxWbdX7dWIeXXDmbM1kmumqOn2qWMvrz7eVbJlcDplltsF2WZ3lVQAAIfkEBRQAAgAsAwACABQAHAAAAlGEj6kXEL+ia07GRm2iWRt+bRPUfQpZicsDnRe2Sq26ZTNcjxNTombl+8FYRJqNU0oBlS+hp0VMyhBSFy30QVpAOyb1x/CGk7iTdGZeVVkxdAEAOw==",
        );
    svg
}

fn get_rat_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAEAChISPqcsQoeCRSFJnb0wX9uY1jrhYRvcw2kmq0zq945mC61PHMPm5LV6hpHKzSikSkmU4N84LiCnKZsIfSFdMOoNNbes4/IqJYpHptrvGorj0c3tkITdMlDxKR5KrTZ7mvJZXM0iFF1gVuLGD+KcW97aUJ6llMnno5sPk5OXXFoJZFopQAAAh+QQFFAACACwDAAIAHAAPAAACJIR/osvtD56ctE4QbD1ZSxOE3ieO5ql0Hoa27luFKoxF8P0ZBQAh+QQFFAACACwBAAUAHgAUAAACMoSPAcLtD6GKtDJjswuc68wtnxaOwmSmUaC2rnC8qyfXo8La+s73Ve47hQzAF+JQ6h0LADs=",
        );
    svg
}

fn get_skeleton_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPECAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQFFAACACwAAAAAIAAgAEACgISPqcsQ9sJzbs6WIrJ0n8uAHhZ2mSSSIwShbIal3Oeq5pvaN03ljcZr7WySDgcl8n2GPc+sdGI9la8RVZWs6mAVI3DrQ26XsmJxbFZcSRcL6AxuVjQRMbZ9/hrZ0a5VCceTJ0eVBCTDtMTltvKjpjWmBbfmaBXpZHkppajZiVEAACH5BAUUAAIALAMAAAAGAB8AAAIfBGKJeryHYkuT0fXCa3n7ql3VSG4lRZ7iakhWO5pGAQAh+QQFFAACACwDAAAABgAfAAACH4RvgaCnzWJ6EabVsmR0IrtVjtVdH4ae6mo66UWecQEAIfkEBRQAAgAsAwAAABAAHwAAAjmUYqnLiQZMAM9FeRuKG1eZcFcWHlDjCCTKtgvllvFMa/A80bdLrfUPDAoVu6ExOPmwerjiMjfzLQoAIfkEBRQAAgAsAwAAABkAHwAAAlCEhanL7Z9AALDaiyTFS6LALWBIllyAToYxWer6etaqyZcasySsZ+1dU9geI8cPwhMNO7nlDJcMxY4YVmpToplc2K33C35ovpOiaewtg82hAgAh+QQFFAACACwDAAAAGQAfAAACUQQiqcvtD1U4sdqbJsJsJsAxYEiWnIGmVHUE7qReMOphRwrX3IxKq3X7CXSQ0UP40CBvEF6Q5LxtTkGkxYUzDV9a1rQLDos71hCzqwGfu0ZSAQA7",
        );
    svg
}

fn get_spider_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACjYSPqcttAWNw9Mg7K8NYKy49HgJm4VgCHLqmFaiekdaGUJxk+RXPNnkDllyqh24xnJGMllMvKBIyYUzcx/r0HbObSa1YdW47yuiu6SWCy1ghO8prGk3vta6ctljzZrRcZDKX9hZ0BCV459SGqNWVeGVTeIj3YShJuJXjtzOZuXRYaTnSwAY6utl3CpRQAAAh+QQFFAACACwFAAsADQASAAACK4SPoalrDZoML07qLsZW9qc5oIccZBlZ1cJW3VZOrydubE2Zmfupa44KIgoAIfkEBRQAAgAsAAAKACAAFgAAAliEhanLjRCAm1TAUDOLuoWPLVK3RMa3kY7BnuoGHi8FcrPYXu6ttB8ke9V8D14idrrcfL9LiMfc3ZCnyFMVZVmNR5OSq/V6c+QyVVxOm8VjtTsMf8t1VUMBACH5BAUUAAIALAUAAQAYABsAAAJFlI+gC+gv2lNwViNvhiHs+3TUd5CGt5mVB30me3SgA59KMNsIDOCzm8jlfEJO8YhMKpfMpvMJjRotyNSpWJMQhazGNlcAADs=",
        );
    svg
}

fn get_troll_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACfYSPGJvtb8KRsDaqrAY49u1Q0ghWI0Z+oCqqm3hFXDmj4TvnTJ65/Q18kBILH09ozEyOsY7LKdQpY7JotcZaPqUQ2JUoS9qYNZ7RS+ael9/qOAj7jNHUNX0XZofe+lY6WMZWpDFk1rbC5UYjBXWIKOdIGPnXNZVHk3KU+VAAACH5BAUUAAIALAIAAAAdAB4AAAJ0hI+pyxnfogqHSmndZdnAvVjUCIbAd6bdtaZn1k6erHIIOdO26PFaXNNpZK0H0LVCRTo4l7Nigt6Q0+gz5xwVoUxqw+flHbNYEuxbroJ1Z9zZlnNL18OrvNJ93/TSGWT8BCai5IDyBviD5cXiV3WFoUi2UAAAOw==",
        );
    svg
}

fn get_wolf_gif_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/gif;base64,R0lGODlhgACAAPEAAAAAAP///wAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAgACAAEAC/4SPqcvtD6OclIWL860zc+M9GvY141amTgie6rucAYywgA3hh76SdC9D/XK+H2+INBZpx9oyCTU9h82oU2i9TVtYWDXLdH2+WiwZLDnvxOltRI1ed6lu2xGelcXtbks/LjcT89c2UnJHmISHaBh4JQikQTSnwhjkR1kGWaEXSNbJgXfIpvk4apYIqJoiugqa0Fp4ORgkSbt5agu1mPoSK9WowJuJievY0buK9lusjDRsXJnsvEfKR3xMXR3MmsjsSqoNO/0dOt2MjMotPhkdhs3lXv7ubuq7ZNmu/HmeXZquaxw8eu2ubeKnLqC9SPNqDVz4L57DeiIcoovHLqPGjf8cO3rU9/HWq2f9MFZcRwelyV0WRbYUVlKgQo0G55FUSRDgNoqybPqDdvFNzIJ1yBnNBBRcrX1Db4Vc1hTmw6c5lQz0aZWnzJtaqVZVFNUrsIAGQVLDOjaol7AfR47xxlabW1lmI4p9hHbt1JWAoCU1t9dZw6MHw1HN6w9ivsNxpWpd3HEu2IQUEAN+HLas05Ndo0DuhrMuxJ2idSbm/Jm0acea+RZD2PkyUcqnHeMtetWwbJc4UwOsCTc0at1pf06MOTHo3zzW8CF3Hviu9OnUq1u/ztEydq7Tk3t+nlt4Vsl6Y28dHv03bvOVX8r0bjvlTNfyJR9fX157rtvpwZD/lwvdfOz8J01g+tXGCXHltddfgg3yxx5no0m4GV31NWbXchNGYoV9hDEoz4dQ9SaihfGZ2Jd7qmXF1FJKRcjhdqDBWJyM9zxYoY0zckehjuex2GN2JX5lo4Y30ugjfUAmudpkSMr4Sms1MikUN1Kq9eKKPxI54pMobrgjlRJlFpyXIRFYJWY4ZoQmlifaVaSCQSqH4U4H7vbli3c6aN6eYL42JIhe+RVok22RaWCAfsq3YJNt0lQnglciuJF2n/kWWaRKbvmnR5aW6eaAci4J55yQiveVkWeBeiSYsInzaquSsroqUogKWNqmWnbaE3ghrslnrmny+h5+WZqKIqG2XQIrqKGeBEgsmnuqqomUsMXKUnhkQRukh9qidS23uhpH4re3AlrurzRGOWq1vqIrIKZpAmdug/ANS+5xuXhbWKIuJquoiuqlS2zBR1r7LqWy+tccbXiWKmbEEodUAAAh+QQFFAACACwAAAwAcABwAAACyZSPqcvtD6M8oIKJs96c2g6GomZd44mmQqm27gvH8kzX9o3n+s73/g8MCofEovGITCqXnFLgGWDqnFBpjvq04rBRrfcLDovH5AW3/DqjW+p1qu2Oy+f0uv2Oz+v3/L7/DxgoOEhYaHiImKi4yNjo+AgZKTlJWWl5iZmpucnZ6fkJGio6Slpqeoqaqrq6ARXAwugKuyj7EQs1y6q7u1tb0ehrQotrO/yUWxgMTPx7e1ysqIwobfwKnUgdzSzM2+2ti8wYvjiuWF5YAAAh+QQFFAACACxgABwADAAMAAACF4QRGceofdSCLtE6obybdvM1ITNGD1UAACH5BAUUAAIALAAADABwAHAAAAK/lI+py+0Pozyhhomz3pzaDoaiZl3jiaZCqbbuC8fyTNf2jef6zvf+DwwKh8Si8YhMKpfMpvMJjUqn1Kr1is1qt9yu9wsOi8cQgBlADp3R6c667T7D5/S6/Y7P6/f8vv8PGCg4SFhoeIiYqLjI2Oj4CBkpOUlZaXmJmam5ydnp+QkaKrjGEkj6YXpWCnhaIfoK+9pqwqqKWmu2+jfrx5uae7tr6/oLoKvni2sc3DtMKwxMHDtNDXoceA2Y/betVwAAIfkEBRQAAgAsAAAUAHAAaAAAAtKUj6nL7Q+jPKCCibPenNoOhqJmXeOJpkKptq5UBnLw1nYSz/de5zIPVPlowSJnaEx2kMomhumMPqDSqvWKzWq33G6L6lWCw8YxOWg+q9fstvtdnRHhQTm9aL8D8/q+/w8YKDhIWGh4iJiouMjY6PgIGSk5SVlpeYmZqbnJ2en5CRoqOkpaanqKmqq6ytrq+gobK9sqx9JZ+3E7Y8uJWzELHCyc5GvSu5t7LMO7WazprLuc3Iz8Gx3AbAmtjD39XG1MLW09XG5+/pLdqc7JvuluWQAAIfkEBRQAAgAsAAAEAHQAeAAAAv+Ej6nL7Q+jnLTai7PevPsPesJIluaJpurKtq5ABXIAvvaNn/Fc5/6/2sl6wKJRSPsYl0zILKl4YphUnJO3kF6qXNd1mMVaumTVF5rQjsvsFEKdfs7a9OYB/pbL6nxgHhylF9BHaHUnFqdXuAgk6CjHGOnySDkoeZlS+YjJaaLp2MmINzHqELpUGpHKcGq0+vCq0FoU21CLMOt3CFjhiJt7tIuGBAccbHAbpvdr/PM3TCrI3EzmG61IXWUtAZpNta0q6P0tfS0Xgh7O+wySnL6R6q4O/Y4ej8ghX39xvw4/N47PtIChBhLkZPDgpYQKdQjbh0ycQnYQux2kuM8iQYz/9TQ25ALnycdCIQGO5FNyz0mUiESuPAbgpSSGMunQrMnmJiGdXVy+qKVvC0mTk/Apoxdikc+i/gI1TTpU5U+jTpFCzACOCE4BWZVsHdFVxFeu5dCNhXGADVCi1Hj+WCs1m1sfcC15m5uj7llUbPdW6+sXJODA5OISZsnrsDZEigujacwkqIdiCiVjZVyZakfMBy1joNx5MOTRpEubPo06terVrFu7fg07Nt/EslGArl3iNm6wnHf7/g08uPDhxIufWBpQdx3k45TTYe7NeRvo2Tw/PCqdWth5DMA13H6me9mYmZfx0+y9/DlzLVjVBC+s/QKc8CMaRuFeZn0A1EvkJn+ZXhBplZbSY/gNSFqBDOG1lYIImsAgfS1p9oxx/e12IW4ZrlYAADs=",
        );
    svg
}

