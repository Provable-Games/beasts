#[starknet::contract]
mod beast_png_shiny_data {
    use core::byte_array::ByteArrayTrait;
    use super::super::beast_definitions;
    use super::super::interfaces::IBeastImageDataProvider;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl BeastImageDataProviderImpl of IBeastImageDataProvider<ContractState> {
        fn get_data_uri(self: @ContractState, beast_id: u8) -> ByteArray {
            if beast_id == beast_definitions::WARLOCK {
                get_warlock_shiny_svg()
            } else if beast_id == beast_definitions::TYPHON {
                get_typhon_shiny_svg()
            } else if beast_id == beast_definitions::JIANGSHI {
                get_jiangshi_shiny_svg()
            } else if beast_id == beast_definitions::ANANSI {
                get_anansi_shiny_svg()
            } else if beast_id == beast_definitions::BASILISK {
                get_basilisk_shiny_svg()
            } else if beast_id == beast_definitions::GORGON {
                get_gorgon_shiny_svg()
            } else if beast_id == beast_definitions::KITSUNE {
                get_kitsune_shiny_svg()
            } else if beast_id == beast_definitions::LICH {
                get_lich_shiny_svg()
            } else if beast_id == beast_definitions::CHIMERA {
                get_chimera_shiny_svg()
            } else if beast_id == beast_definitions::WENDIGO {
                get_wendigo_shiny_svg()
            } else if beast_id == beast_definitions::RAKSHASA {
                get_rakshasa_shiny_svg()
            } else if beast_id == beast_definitions::WEREWOLF {
                get_werewolf_shiny_svg()
            } else if beast_id == beast_definitions::BANSHEE {
                get_banshee_shiny_svg()
            } else if beast_id == beast_definitions::DRAUGR {
                get_draugr_shiny_svg()
            } else if beast_id == beast_definitions::VAMPIRE {
                get_vampire_shiny_svg()
            } else if beast_id == beast_definitions::GOBLIN {
                get_goblin_shiny_svg()
            } else if beast_id == beast_definitions::GHOUL {
                get_ghoul_shiny_svg()
            } else if beast_id == beast_definitions::WRAITH {
                get_wraith_shiny_svg()
            } else if beast_id == beast_definitions::SPRITE {
                get_sprite_shiny_svg()
            } else if beast_id == beast_definitions::KAPPA {
                get_kappa_shiny_svg()
            } else if beast_id == beast_definitions::FAIRY {
                get_fairy_shiny_svg()
            } else if beast_id == beast_definitions::LEPRECHAUN {
                get_leprechaun_shiny_svg()
            } else if beast_id == beast_definitions::KELPIE {
                get_kelpie_shiny_svg()
            } else if beast_id == beast_definitions::PIXIE {
                get_pixie_shiny_svg()
            } else if beast_id == beast_definitions::GNOME {
                get_gnome_shiny_svg()
            } else if beast_id == beast_definitions::GRIFFIN {
                get_griffin_shiny_svg()
            } else if beast_id == beast_definitions::MANTICORE {
                get_manticore_shiny_svg()
            } else if beast_id == beast_definitions::PHOENIX {
                get_phoenix_shiny_svg()
            } else if beast_id == beast_definitions::DRAGON {
                get_dragon_shiny_svg()
            } else if beast_id == beast_definitions::MINOTAUR {
                get_minotaur_shiny_svg()
            } else if beast_id == beast_definitions::QILIN {
                get_qilin_shiny_svg()
            } else if beast_id == beast_definitions::AMMIT {
                get_ammit_shiny_svg()
            } else if beast_id == beast_definitions::NUE {
                get_nue_shiny_svg()
            } else if beast_id == beast_definitions::SKINWALKER {
                get_skinwalker_shiny_svg()
            } else if beast_id == beast_definitions::CHUPACABRA {
                get_chupacabra_shiny_svg()
            } else if beast_id == beast_definitions::WERETIGER {
                get_weretiger_shiny_svg()
            } else if beast_id == beast_definitions::WYVERN {
                get_wyvern_shiny_svg()
            } else if beast_id == beast_definitions::ROC {
                get_roc_shiny_svg()
            } else if beast_id == beast_definitions::HARPY {
                get_harpy_shiny_svg()
            } else if beast_id == beast_definitions::PEGASUS {
                get_pegasus_shiny_svg()
            } else if beast_id == beast_definitions::HIPPOGRIFF {
                get_hippogriff_shiny_svg()
            } else if beast_id == beast_definitions::FENRIR {
                get_fenrir_shiny_svg()
            } else if beast_id == beast_definitions::JAGUAR {
                get_jaguar_shiny_svg()
            } else if beast_id == beast_definitions::SATORI {
                get_satori_shiny_svg()
            } else if beast_id == beast_definitions::DIREWOLF {
                get_direwolf_shiny_svg()
            } else if beast_id == beast_definitions::BEAR {
                get_bear_shiny_svg()
            } else if beast_id == beast_definitions::WOLF {
                get_wolf_shiny_svg()
            } else if beast_id == beast_definitions::MANTIS {
                get_mantis_shiny_svg()
            } else if beast_id == beast_definitions::SPIDER {
                get_spider_shiny_svg()
            } else if beast_id == beast_definitions::RAT {
                get_rat_shiny_svg()
            } else if beast_id == beast_definitions::KRAKEN {
                get_kraken_shiny_svg()
            } else if beast_id == beast_definitions::COLOSSUS {
                get_colossus_shiny_svg()
            } else if beast_id == beast_definitions::BALROG {
                get_balrog_shiny_svg()
            } else if beast_id == beast_definitions::LEVIATHAN {
                get_leviathan_shiny_svg()
            } else if beast_id == beast_definitions::TARRASQUE {
                get_tarrasque_shiny_svg()
            } else if beast_id == beast_definitions::TITAN {
                get_titan_shiny_svg()
            } else if beast_id == beast_definitions::NEPHILIM {
                get_nephilim_shiny_svg()
            } else if beast_id == beast_definitions::BEHEMOTH {
                get_behemoth_shiny_svg()
            } else if beast_id == beast_definitions::HYDRA {
                get_hydra_shiny_svg()
            } else if beast_id == beast_definitions::JUGGERNAUT {
                get_juggernaut_shiny_svg()
            } else if beast_id == beast_definitions::ONI {
                get_oni_shiny_svg()
            } else if beast_id == beast_definitions::JOTUNN {
                get_jotunn_shiny_svg()
            } else if beast_id == beast_definitions::ETTIN {
                get_ettin_shiny_svg()
            } else if beast_id == beast_definitions::CYCLOPS {
                get_cyclops_shiny_svg()
            } else if beast_id == beast_definitions::GIANT {
                get_giant_shiny_svg()
            } else if beast_id == beast_definitions::NEMEANLION {
                get_nemeanlion_shiny_svg()
            } else if beast_id == beast_definitions::BERSERKER {
                get_berserker_shiny_svg()
            } else if beast_id == beast_definitions::YETI {
                get_yeti_shiny_svg()
            } else if beast_id == beast_definitions::GOLEM {
                get_golem_shiny_svg()
            } else if beast_id == beast_definitions::ENT {
                get_ent_shiny_svg()
            } else if beast_id == beast_definitions::TROLL {
                get_troll_shiny_svg()
            } else if beast_id == beast_definitions::BIGFOOT {
                get_bigfoot_shiny_svg()
            } else if beast_id == beast_definitions::OGRE {
                get_ogre_shiny_svg()
            } else if beast_id == beast_definitions::ORC {
                get_orc_shiny_svg()
            } else if beast_id == beast_definitions::SKELETON {
                get_skeleton_shiny_svg()
            } else {
                // Default empty image
                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
            }
        }
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
                @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAC0klEQVR42sVXLU9cQRQ9s+kGDbqgMNiqKv4Cgux/QGGuW1P3RMsYVAUJNSiCQK1bUYUBgakBU5qAIE2aPCALm9yK9+5w3uzMbEtJOsnN/Tjn3LnvzQTeOgCK/7h6/yL+qPIqQ+jf2heVZPxCm08aJTax2kglib/aAKeF5oadqhR5JXO5S/iDzvet81nMcKvFXNbksM5Ejyr6SE+Ty7ke+5xl8CbQB1F96BIs5zrzSprYUtwwgN6K6m3bNONLPObEmnlc6HfaoI3Zx3jMyWn/tGfPrTQXQ78J3IrveNyhMVuUBw5hpg2Xi3PG76K/hHoqwH3j3ZoPHvdozBblprHl1nyjMaytMZd7Gwf6VdQMQCe2vPNK5+CpOveOfc9eq1t/flVu3UNH8vzakT4GHTXHFLi0uIf1thrvBT2kSduYa3GuhxIsx4m5pXrPDdpz2hegbsevo8eh3A18k9ethrSdnLlUs35u4KH7AgdAdbcVbHvorsBt003e7b5ew7jOfNZZvxKnF54w8fRatcPUCF4rAWvctodW0jHekHVBy4PrUFSH7dkP6awTccqzvmSpPQDom+lkIUxk8ZMM4aqqE3NtOlnAkwwxnTS6vm9wXn1fdZ+28p1eAf8lnxSAmueYazFmsVmJl+oZ8GvZUwAa+9ji+rXsBYvzXI9ULwdAL+QIq34z+9F4IUfFj8qUNu6Z26N3LuMkcC7j4Ff9Ju6xmLRVvxm46PzbWEwOydxzGSN8kp3IGd77d+D4RM4COZezhleMFz/Lx3IZzsTisVwGY4xrMc7GnBLe+Sg9lquZ6Tb8Mo7lCht+eYZjmMXcJ4fN3IEDuQEAHMgNavRRo48Nvxxia2A8q9foB43hZrYh83LLAdDP8jMUtvwSLE/FW34pcGNdapmG+8zcgR2pdUfqmXOyWgpjDluJl+nVBB9kEizXJMWxOPYv+mUkUv6l7r0Dczl/6foNp356kvBrxUQAAAAASUVORK5CYII=",
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
}
