use core::byte_array::ByteArrayTrait;
use super::beast_manager::BeastAttributes;
use super::utils::felt252_to_byte_array;
use super::interfaces::{IBeastImageDataProviderDispatcher, IBeastImageDataProviderDispatcherTrait};

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
        image_data_provider: IBeastImageDataProviderDispatcher,
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

            let beast_image = image_data_provider.get_data_uri(beast_id);
            svg.append(@beast_image);
            svg.append(@"'>");
            svg
                .append(
                    @"<animate attributeName='opacity' dur='2.2s' from='1' to='0.999' repeatCount='indefinite'/>",
                );
        } else {
            svg.append(@"<image width='130' height='130' image-rendering='pixelated' href='");
            let beast_image = image_data_provider.get_data_uri(beast_id);
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
