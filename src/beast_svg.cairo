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
                @"<path d='M13 11c0-6 9-6 9 0s-9 10.5-9 10.5S4 17 4 11s9-6 9 0Z' stroke-width='3' id='heart' stroke='#ff6b6b' fill='none'/>",
            );
        svg
            .append(
                @"<path transform='scale(1.5)' id='bolt' stroke='#ffd166' stroke-width='2' stroke-linejoin='round' d='M6 2 2 9h5l-4 7'/>",
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
                @".label{fill:#c9c9d1;font-size:9px;letter-spacing:.4px}.valL{fill:#fff;font-size:16px;font-weight:700}",
            );
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

        // Crown for rank 1, trophy for other ranks
        if rank == 1 {
            svg.append(@"<use href='#crown' x='13' y='12' width='20' height='20'/>");
            svg
                .append(
                    @"<text x='23' y='42' text-anchor='middle' style='fill:#e6c56e;font-size:11px;font-weight:700'>1</text>",
                );
        } else if rank > 1 {
            svg.append(@"<use href='#trophy' x='13' y='12' width='20' height='20'/>");
            svg
                .append(
                    @"<text x='23' y='42' text-anchor='middle' style='fill:#fff;font-size:11px;font-weight:700'>",
                );
            svg.append(@format!("{}", rank));
            svg.append(@"</text>");
        }

        // Specials and name
        svg
            .append(
                @"<text x='125' y='30' text-anchor='middle' style='fill:#b0b0b6;font-size:13px;font-style:italic'>",
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
                @"<text x='125' y='52' text-anchor='middle' style='fill:#fff;font-size:18px;font-weight:700;letter-spacing:.7px'>",
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
            svg.append(@"<image width='780' height='130' image-rendering='pixelated' href='");
            let beast_image = get_beast_png(beast_id, true);
            svg.append(@beast_image);
            svg.append(@"'>");
            svg
                .append(
                    @"<animate attributeName='x' values='0;-130;-260;-390;0' dur='1s' calcMode='discrete' repeatCount='indefinite'/>",
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
        svg.append(@"<g transform='translate(18 208)'>");
        svg.append(@"<rect width='65' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='32.5' y='18' text-anchor='middle' class='label'>TIER</text>");
        svg.append(@"<text x='32.5' y='38' text-anchor='middle' class='valL'>");
        svg.append(@format!("{}", beast_attrs.tier));
        svg.append(@"</text>");

        svg.append(@"<g transform='translate(75)'>");
        svg.append(@"<rect width='65' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='32.5' y='18' text-anchor='middle' class='label'>LEVEL</text>");
        svg.append(@"<text x='32.5' y='38' text-anchor='middle' class='valL'>");
        svg.append(@format!("{}", beast_attrs.level));
        svg.append(@"</text>");
        svg.append(@"</g>");

        svg.append(@"<g transform='translate(150)'>");
        svg.append(@"<rect width='65' height='50' rx='5' fill='url(#panel)'/>");
        svg.append(@"<text x='32.5' y='18' text-anchor='middle' class='label'>TYPE</text>");
        svg
            .append(
                @"<text x='32.5' y='38' text-anchor='middle' style='fill:#fff;font-size:14px;font-weight:700'>",
            );
        let beast_type_str = felt252_to_byte_array(beast_attrs.beast_type);
        svg.append(@beast_type_str);
        svg.append(@"</text>");
        svg.append(@"</g>");
        svg.append(@"</g>");

        // Power and Health panels
        svg.append(@"<g transform='translate(20 265)'>");
        svg.append(@"<rect width='100' height='60' rx='5' fill='url(#panel)'/>");
        svg.append(@"<use href='#bolt' x='75' y='20'/>");
        svg.append(@"<text x='18' y='22' class='label'>POWER</text>");
        svg.append(@"<text x='18' y='46' class='valL'>");
        svg.append(@format!("{}", beast_attrs.power));
        svg.append(@"</text>");
        svg.append(@"</g>");

        svg.append(@"<g transform='translate(131 265)'>");
        svg.append(@"<rect width='100' height='60' rx='5' fill='url(#panel)'/>");
        svg.append(@"<use href='#heart' x='68' y='20'/>");
        svg.append(@"<text x='18' y='22' class='label'>HEALTH</text>");
        svg.append(@"<text x='18' y='46' class='valL'>");
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

fn get_beast_png(beast_id: u8, animated: bool) -> ByteArray {
    if beast_id == beast_definitions::WARLOCK {
        if animated {
            get_warlock_sheet_svg()
        } else {
            get_warlock_svg()
        }
    } else if beast_id == beast_definitions::TYPHON {
        if animated {
            get_typhon_sheet_svg()
        } else {
            get_typhon_svg()
        }
    } else if beast_id == beast_definitions::JIANGSHI {
        if animated {
            get_jiangshi_sheet_svg()
        } else {
            get_jiangshi_svg()
        }
    } else if beast_id == beast_definitions::ANANSI {
        if animated {
            get_anansi_sheet_svg()
        } else {
            get_anansi_svg()
        }
    } else if beast_id == beast_definitions::BASILISK {
        if animated {
            get_basilisk_sheet_svg()
        } else {
            get_basilisk_svg()
        }
    } else if beast_id == beast_definitions::GORGON {
        if animated {
            get_gorgon_sheet_svg()
        } else {
            get_gorgon_svg()
        }
    } else if beast_id == beast_definitions::KITSUNE {
        if animated {
            get_kitsune_sheet_svg()
        } else {
            get_kitsune_svg()
        }
    } else if beast_id == beast_definitions::LICH {
        if animated {
            get_lich_sheet_svg()
        } else {
            get_lich_svg()
        }
    } else if beast_id == beast_definitions::CHIMERA {
        if animated {
            get_chimera_sheet_svg()
        } else {
            get_chimera_svg()
        }
    } else if beast_id == beast_definitions::WENDIGO {
        if animated {
            get_wendigo_sheet_svg()
        } else {
            get_wendigo_svg()
        }
    } else if beast_id == beast_definitions::RAKSHASA {
        if animated {
            get_rakshasa_sheet_svg()
        } else {
            get_rakshasa_svg()
        }
    } else if beast_id == beast_definitions::WEREWOLF {
        if animated {
            get_werewolf_sheet_svg()
        } else {
            get_werewolf_svg()
        }
    } else if beast_id == beast_definitions::BANSHEE {
        if animated {
            get_banshee_sheet_svg()
        } else {
            get_banshee_svg()
        }
    } else if beast_id == beast_definitions::DRAUGR {
        if animated {
            get_draugr_sheet_svg()
        } else {
            get_draugr_svg()
        }
    } else if beast_id == beast_definitions::VAMPIRE {
        if animated {
            get_vampire_sheet_svg()
        } else {
            get_vampire_svg()
        }
    } else if beast_id == beast_definitions::GOBLIN {
        if animated {
            get_goblin_sheet_svg()
        } else {
            get_goblin_svg()
        }
    } else if beast_id == beast_definitions::GHOUL {
        if animated {
            get_ghoul_sheet_svg()
        } else {
            get_ghoul_svg()
        }
    } else if beast_id == beast_definitions::WRAITH {
        if animated {
            get_wraith_sheet_svg()
        } else {
            get_wraith_svg()
        }
    } else if beast_id == beast_definitions::SPRITE {
        if animated {
            get_sprite_sheet_svg()
        } else {
            get_sprite_svg()
        }
    } else if beast_id == beast_definitions::KAPPA {
        if animated {
            get_kappa_sheet_svg()
        } else {
            get_kappa_svg()
        }
    } else if beast_id == beast_definitions::FAIRY {
        if animated {
            get_fairy_sheet_svg()
        } else {
            get_fairy_svg()
        }
    } else if beast_id == beast_definitions::LEPRECHAUN {
        if animated {
            get_leprechaun_sheet_svg()
        } else {
            get_leprechaun_svg()
        }
    } else if beast_id == beast_definitions::KELPIE {
        if animated {
            get_kelpie_sheet_svg()
        } else {
            get_kelpie_svg()
        }
    } else if beast_id == beast_definitions::PIXIE {
        if animated {
            get_pixie_sheet_svg()
        } else {
            get_pixie_svg()
        }
    } else if beast_id == beast_definitions::GNOME {
        if animated {
            get_gnome_sheet_svg()
        } else {
            get_gnome_svg()
        }
    } else if beast_id == beast_definitions::GRIFFIN {
        if animated {
            get_griffin_sheet_svg()
        } else {
            get_griffin_svg()
        }
    } else if beast_id == beast_definitions::MANTICORE {
        if animated {
            get_manticore_sheet_svg()
        } else {
            get_manticore_svg()
        }
    } else if beast_id == beast_definitions::PHOENIX {
        if animated {
            get_phoenix_sheet_svg()
        } else {
            get_phoenix_svg()
        }
    } else if beast_id == beast_definitions::DRAGON {
        if animated {
            get_dragon_sheet_svg()
        } else {
            get_dragon_svg()
        }
    } else if beast_id == beast_definitions::MINOTAUR {
        if animated {
            get_minotaur_sheet_svg()
        } else {
            get_minotaur_svg()
        }
    } else if beast_id == beast_definitions::QILIN {
        if animated {
            get_qilin_sheet_svg()
        } else {
            get_qilin_svg()
        }
    } else if beast_id == beast_definitions::AMMIT {
        if animated {
            get_ammit_sheet_svg()
        } else {
            get_ammit_svg()
        }
    } else if beast_id == beast_definitions::NUE {
        if animated {
            get_nue_sheet_svg()
        } else {
            get_nue_svg()
        }
    } else if beast_id == beast_definitions::SKINWALKER {
        if animated {
            get_skinwalker_sheet_svg()
        } else {
            get_skinwalker_svg()
        }
    } else if beast_id == beast_definitions::CHUPACABRA {
        if animated {
            get_chupacabra_sheet_svg()
        } else {
            get_chupacabra_svg()
        }
    } else if beast_id == beast_definitions::WERETIGER {
        if animated {
            get_weretiger_sheet_svg()
        } else {
            get_weretiger_svg()
        }
    } else if beast_id == beast_definitions::WYVERN {
        if animated {
            get_wyvern_sheet_svg()
        } else {
            get_wyvern_svg()
        }
    } else if beast_id == beast_definitions::ROC {
        if animated {
            get_roc_sheet_svg()
        } else {
            get_roc_svg()
        }
    } else if beast_id == beast_definitions::HARPY {
        if animated {
            get_harpy_sheet_svg()
        } else {
            get_harpy_svg()
        }
    } else if beast_id == beast_definitions::PEGASUS {
        if animated {
            get_pegasus_sheet_svg()
        } else {
            get_pegasus_svg()
        }
    } else if beast_id == beast_definitions::HIPPOGRIFF {
        if animated {
            get_hippogriff_sheet_svg()
        } else {
            get_hippogriff_svg()
        }
    } else if beast_id == beast_definitions::FENRIR {
        if animated {
            get_fenrir_sheet_svg()
        } else {
            get_fenrir_svg()
        }
    } else if beast_id == beast_definitions::JAGUAR {
        if animated {
            get_jaguar_sheet_svg()
        } else {
            get_jaguar_svg()
        }
    } else if beast_id == beast_definitions::SATORI {
        if animated {
            get_satori_sheet_svg()
        } else {
            get_satori_svg()
        }
    } else if beast_id == beast_definitions::DIREWOLF {
        if animated {
            get_direwolf_sheet_svg()
        } else {
            get_direwolf_svg()
        }
    } else if beast_id == beast_definitions::BEAR {
        if animated {
            get_bear_sheet_svg()
        } else {
            get_bear_svg()
        }
    } else if beast_id == beast_definitions::WOLF {
        if animated {
            get_wolf_sheet_svg()
        } else {
            get_wolf_svg()
        }
    } else if beast_id == beast_definitions::MANTIS {
        if animated {
            get_mantis_sheet_svg()
        } else {
            get_mantis_svg()
        }
    } else if beast_id == beast_definitions::SPIDER {
        if animated {
            get_spider_sheet_svg()
        } else {
            get_spider_svg()
        }
    } else if beast_id == beast_definitions::RAT {
        if animated {
            get_rat_sheet_svg()
        } else {
            get_rat_svg()
        }
    } else if beast_id == beast_definitions::KRAKEN {
        if animated {
            get_kraken_sheet_svg()
        } else {
            get_kraken_svg()
        }
    } else if beast_id == beast_definitions::COLOSSUS {
        if animated {
            get_colossus_sheet_svg()
        } else {
            get_colossus_svg()
        }
    } else if beast_id == beast_definitions::BALROG {
        if animated {
            get_balrog_sheet_svg()
        } else {
            get_balrog_svg()
        }
    } else if beast_id == beast_definitions::LEVIATHAN {
        if animated {
            get_leviathan_sheet_svg()
        } else {
            get_leviathan_svg()
        }
    } else if beast_id == beast_definitions::TARRASQUE {
        if animated {
            get_tarrasque_sheet_svg()
        } else {
            get_tarrasque_svg()
        }
    } else if beast_id == beast_definitions::TITAN {
        if animated {
            get_titan_sheet_svg()
        } else {
            get_titan_svg()
        }
    } else if beast_id == beast_definitions::NEPHILIM {
        if animated {
            get_nephilim_sheet_svg()
        } else {
            get_nephilim_svg()
        }
    } else if beast_id == beast_definitions::BEHEMOTH {
        if animated {
            get_behemoth_sheet_svg()
        } else {
            get_behemoth_svg()
        }
    } else if beast_id == beast_definitions::HYDRA {
        if animated {
            get_hydra_sheet_svg()
        } else {
            get_hydra_svg()
        }
    } else if beast_id == beast_definitions::JUGGERNAUT {
        if animated {
            get_juggernaut_sheet_svg()
        } else {
            get_juggernaut_svg()
        }
    } else if beast_id == beast_definitions::ONI {
        if animated {
            get_oni_sheet_svg()
        } else {
            get_oni_svg()
        }
    } else if beast_id == beast_definitions::JOTUNN {
        if animated {
            get_jotunn_sheet_svg()
        } else {
            get_jotunn_svg()
        }
    } else if beast_id == beast_definitions::ETTIN {
        if animated {
            get_ettin_sheet_svg()
        } else {
            get_ettin_svg()
        }
    } else if beast_id == beast_definitions::CYCLOPS {
        if animated {
            get_cyclops_sheet_svg()
        } else {
            get_cyclops_svg()
        }
    } else if beast_id == beast_definitions::GIANT {
        if animated {
            get_giant_sheet_svg()
        } else {
            get_giant_svg()
        }
    } else if beast_id == beast_definitions::NEMEANLION {
        if animated {
            get_nemeanlion_sheet_svg()
        } else {
            get_nemeanlion_svg()
        }
    } else if beast_id == beast_definitions::BERSERKER {
        if animated {
            get_berserker_sheet_svg()
        } else {
            get_berserker_svg()
        }
    } else if beast_id == beast_definitions::YETI {
        if animated {
            get_yeti_sheet_svg()
        } else {
            get_yeti_svg()
        }
    } else if beast_id == beast_definitions::GOLEM {
        if animated {
            get_golem_sheet_svg()
        } else {
            get_golem_svg()
        }
    } else if beast_id == beast_definitions::ENT {
        if animated {
            get_ent_sheet_svg()
        } else {
            get_ent_svg()
        }
    } else if beast_id == beast_definitions::TROLL {
        if animated {
            get_troll_sheet_svg()
        } else {
            get_troll_svg()
        }
    } else if beast_id == beast_definitions::BIGFOOT {
        if animated {
            get_bigfoot_sheet_svg()
        } else {
            get_bigfoot_svg()
        }
    } else if beast_id == beast_definitions::OGRE {
        if animated {
            get_ogre_sheet_svg()
        } else {
            get_ogre_svg()
        }
    } else if beast_id == beast_definitions::ORC {
        if animated {
            get_orc_sheet_svg()
        } else {
            get_orc_svg()
        }
    } else if beast_id == beast_definitions::SKELETON {
        if animated {
            get_skeleton_sheet_svg()
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

fn get_warlock_sheet_svg() -> ByteArray {
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

fn get_typhon_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_typhon_svg()
}

fn get_jiangshi_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_jiangshi_svg()
}

fn get_anansi_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_anansi_svg()
}

fn get_basilisk_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_basilisk_svg()
}

fn get_gorgon_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_gorgon_svg()
}

fn get_kitsune_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_kitsune_svg()
}

fn get_lich_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_lich_svg()
}

fn get_chimera_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_chimera_svg()
}

fn get_wendigo_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_wendigo_svg()
}

fn get_rakshasa_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_rakshasa_svg()
}

fn get_werewolf_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_werewolf_svg()
}

fn get_banshee_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_banshee_svg()
}

fn get_draugr_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_draugr_svg()
}

fn get_vampire_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_vampire_svg()
}

fn get_goblin_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_goblin_svg()
}

fn get_ghoul_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_ghoul_svg()
}

fn get_wraith_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_wraith_svg()
}

fn get_sprite_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_sprite_svg()
}

fn get_kappa_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_kappa_svg()
}

fn get_fairy_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_fairy_svg()
}

fn get_leprechaun_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_leprechaun_svg()
}

fn get_kelpie_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_kelpie_svg()
}

fn get_pixie_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_pixie_svg()
}

fn get_gnome_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_gnome_svg()
}

fn get_griffin_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_griffin_svg()
}

fn get_manticore_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_manticore_svg()
}

fn get_phoenix_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_phoenix_svg()
}

fn get_dragon_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_dragon_svg()
}

fn get_minotaur_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_minotaur_svg()
}

fn get_qilin_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_qilin_svg()
}

fn get_ammit_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_ammit_svg()
}

fn get_nue_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_nue_svg()
}

fn get_skinwalker_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_skinwalker_svg()
}

fn get_chupacabra_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_chupacabra_svg()
}

fn get_weretiger_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_weretiger_svg()
}

fn get_wyvern_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_wyvern_svg()
}

fn get_roc_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_roc_svg()
}

fn get_harpy_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_harpy_svg()
}

fn get_pegasus_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_pegasus_svg()
}

fn get_hippogriff_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_hippogriff_svg()
}

fn get_fenrir_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_fenrir_svg()
}

fn get_jaguar_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_jaguar_svg()
}

fn get_satori_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_satori_svg()
}

fn get_direwolf_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_direwolf_svg()
}

fn get_bear_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_bear_svg()
}

fn get_wolf_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_wolf_svg()
}

fn get_mantis_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_mantis_svg()
}

fn get_spider_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_spider_svg()
}

fn get_rat_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_rat_svg()
}

fn get_kraken_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_kraken_svg()
}

fn get_colossus_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_colossus_svg()
}

fn get_balrog_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_balrog_svg()
}

fn get_leviathan_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_leviathan_svg()
}

fn get_tarrasque_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_tarrasque_svg()
}

fn get_titan_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_titan_svg()
}

fn get_nephilim_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_nephilim_svg()
}

fn get_behemoth_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_behemoth_svg()
}

fn get_hydra_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_hydra_svg()
}

fn get_juggernaut_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_juggernaut_svg()
}

fn get_oni_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_oni_svg()
}

fn get_jotunn_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_jotunn_svg()
}

fn get_ettin_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_ettin_svg()
}

fn get_cyclops_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_cyclops_svg()
}

fn get_giant_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_giant_svg()
}

fn get_nemeanlion_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_nemeanlion_svg()
}

fn get_berserker_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_berserker_svg()
}

fn get_yeti_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_yeti_svg()
}

fn get_golem_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_golem_svg()
}

fn get_ent_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_ent_svg()
}

fn get_troll_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_troll_svg()
}

fn get_bigfoot_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_bigfoot_svg()
}

fn get_ogre_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_ogre_svg()
}

fn get_orc_sheet_svg() -> ByteArray {
    // For now, return the same image as the regular function
    get_orc_svg()
}

fn get_skeleton_sheet_svg() -> ByteArray {
    let mut svg: ByteArray = "";
    svg
        .append(
            @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAwwAAACCCAMAAADc8798AAAAIGNIUk0AAHomAACAhAAA+gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAALZUExURQAAAAACAACpAAD/AABjAAAFAAAVAAAWAAAUAAADAAAPAAAXAAAJAAAEAAAzAADPAADYAADZAADFAAAhAAABAACPAADbAABUAAAqAADLAAA9AAD4AADrAAAoAACrAABkAAAyAADyAACqAAA8AAD2AADpAAAnAAAxAADvAADwAAALAAAQAAARAACkAADzAABnAAAHAAAMAABFAADnAAD+AAD9AADxAADqAAA0AAANAAA+AADiAAA7AACTAADRAADOAADMAABmAAAvAACRAADQAADNAABbAADJAACoAAA4AABZAADfAABEAAAwAABKAAD7AADVAADBAADGAADXAAD8AADtAABRAACvAAC4AABVAACcAABzAADEAAATAAAbAADgAADoAAAlAAC2AABWAABxAABJAAD6AADCAAAeAADhAAD1AAAIAAAKAACmAAD5AABlAAAGAAAfAAAmAAD3AAAuAAAZAAC3AADDAACLAABqAAA6AACOAADIAACyAABNAABIAACuAADsAAC5AACdAADkAADaAACbAAByAABHAAAsAAAjAAC1AACGAABGAAB0AAC7AAAOAABsAAD0AAC/AAC9AABiAACCAAAkAACAAACNAAB/AABXAADuAACBAACsAABuAAArAABSAAB2AACEAADlAAAaAAASAABMAABhAAAcAACeAABvAACSAACVAAB9AACWAAB3AAA3AABdAACXAAAYAADjAAA/AACDAAB5AACIAACMAAAgAACQAABAAABwAABTAABeAAB8AACfAABtAAChAAA5AABgAACaAABfAAB7AACgAACzAACZAABCAAC+AABLAACJAADeAAC6AACjAAAdAAApAABPAAA1AAB4AABBAAAiAAB+AACHAADHAABcAAAtAADSAABQAACFAABDAADWAADcAABOAACKAADKAAB1AAA2AABoAADTAACYAADmAADUAACxAACwAP///7d073UAAAABYktHRPLbto54AAAAB3RJTUUH6QcVCR4KEz12GQAAFrtJREFUeNrtnftjE2W+xiedpqFpS1MMRdNb6JWQWlpIii1d6tZWq0tbgaq9ovTe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",
        );
    svg
}
