#[starknet::contract]
mod beast_gif_regular_data {
    use core::byte_array::ByteArrayTrait;
    use super::super::interfaces::IBeastImageDataProvider;
    use super::super::beast_definitions;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl BeastImageDataProviderImpl of IBeastImageDataProvider<ContractState> {
        fn get_data_uri(self: @ContractState, beast_id: u8) -> ByteArray {
            if beast_id == beast_definitions::WARLOCK {
                get_warlock_regular_gif_svg()
            } else if beast_id == beast_definitions::TYPHON {
                get_typhon_regular_gif_svg()
            } else if beast_id == beast_definitions::JIANGSHI {
                get_jiangshi_regular_gif_svg()
            } else if beast_id == beast_definitions::ANANSI {
                get_anansi_regular_gif_svg()
            } else if beast_id == beast_definitions::BASILISK {
                get_basilisk_regular_gif_svg()
            } else if beast_id == beast_definitions::GORGON {
                get_gorgon_regular_gif_svg()
            } else if beast_id == beast_definitions::KITSUNE {
                get_kitsune_regular_gif_svg()
            } else if beast_id == beast_definitions::LICH {
                get_lich_regular_gif_svg()
            } else if beast_id == beast_definitions::CHIMERA {
                get_chimera_regular_gif_svg()
            } else if beast_id == beast_definitions::WENDIGO {
                get_wendigo_regular_gif_svg()
            } else if beast_id == beast_definitions::RAKSHASA {
                get_rakshasa_regular_gif_svg()
            } else if beast_id == beast_definitions::WEREWOLF {
                get_werewolf_regular_gif_svg()
            } else if beast_id == beast_definitions::BANSHEE {
                get_banshee_regular_gif_svg()
            } else if beast_id == beast_definitions::DRAUGR {
                get_draugr_regular_gif_svg()
            } else if beast_id == beast_definitions::VAMPIRE {
                get_vampire_regular_gif_svg()
            } else if beast_id == beast_definitions::GOBLIN {
                get_goblin_regular_gif_svg()
            } else if beast_id == beast_definitions::GHOUL {
                get_ghoul_regular_gif_svg()
            } else if beast_id == beast_definitions::WRAITH {
                get_wraith_regular_gif_svg()
            } else if beast_id == beast_definitions::SPRITE {
                get_sprite_regular_gif_svg()
            } else if beast_id == beast_definitions::KAPPA {
                get_kappa_regular_gif_svg()
            } else if beast_id == beast_definitions::FAIRY {
                get_fairy_regular_gif_svg()
            } else if beast_id == beast_definitions::LEPRECHAUN {
                get_leprechaun_regular_gif_svg()
            } else if beast_id == beast_definitions::KELPIE {
                get_kelpie_regular_gif_svg()
            } else if beast_id == beast_definitions::PIXIE {
                get_pixie_regular_gif_svg()
            } else if beast_id == beast_definitions::GNOME {
                get_gnome_regular_gif_svg()
            } else if beast_id == beast_definitions::GRIFFIN {
                get_griffin_regular_gif_svg()
            } else if beast_id == beast_definitions::MANTICORE {
                get_manticore_regular_gif_svg()
            } else if beast_id == beast_definitions::PHOENIX {
                get_phoenix_regular_gif_svg()
            } else if beast_id == beast_definitions::DRAGON {
                get_dragon_regular_gif_svg()
            } else if beast_id == beast_definitions::MINOTAUR {
                get_minotaur_regular_gif_svg()
            } else if beast_id == beast_definitions::QILIN {
                get_qilin_regular_gif_svg()
            } else if beast_id == beast_definitions::AMMIT {
                get_ammit_regular_gif_svg()
            } else if beast_id == beast_definitions::NUE {
                get_nue_regular_gif_svg()
            } else if beast_id == beast_definitions::SKINWALKER {
                get_skinwalker_regular_gif_svg()
            } else if beast_id == beast_definitions::CHUPACABRA {
                get_chupacabra_regular_gif_svg()
            } else if beast_id == beast_definitions::WERETIGER {
                get_weretiger_regular_gif_svg()
            } else if beast_id == beast_definitions::WYVERN {
                get_wyvern_regular_gif_svg()
            } else if beast_id == beast_definitions::ROC {
                get_roc_regular_gif_svg()
            } else if beast_id == beast_definitions::HARPY {
                get_harpy_regular_gif_svg()
            } else if beast_id == beast_definitions::PEGASUS {
                get_pegasus_regular_gif_svg()
            } else if beast_id == beast_definitions::HIPPOGRIFF {
                get_hippogriff_regular_gif_svg()
            } else if beast_id == beast_definitions::FENRIR {
                get_fenrir_regular_gif_svg()
            } else if beast_id == beast_definitions::JAGUAR {
                get_jaguar_regular_gif_svg()
            } else if beast_id == beast_definitions::SATORI {
                get_satori_regular_gif_svg()
            } else if beast_id == beast_definitions::DIREWOLF {
                get_direwolf_regular_gif_svg()
            } else if beast_id == beast_definitions::BEAR {
                get_bear_regular_gif_svg()
            } else if beast_id == beast_definitions::WOLF {
                get_wolf_regular_gif_svg()
            } else if beast_id == beast_definitions::MANTIS {
                get_mantis_regular_gif_svg()
            } else if beast_id == beast_definitions::SPIDER {
                get_spider_regular_gif_svg()
            } else if beast_id == beast_definitions::RAT {
                get_rat_regular_gif_svg()
            } else if beast_id == beast_definitions::KRAKEN {
                get_kraken_regular_gif_svg()
            } else if beast_id == beast_definitions::COLOSSUS {
                get_colossus_regular_gif_svg()
            } else if beast_id == beast_definitions::BALROG {
                get_balrog_regular_gif_svg()
            } else if beast_id == beast_definitions::LEVIATHAN {
                get_leviathan_regular_gif_svg()
            } else if beast_id == beast_definitions::TARRASQUE {
                get_tarrasque_regular_gif_svg()
            } else if beast_id == beast_definitions::TITAN {
                get_titan_regular_gif_svg()
            } else if beast_id == beast_definitions::NEPHILIM {
                get_nephilim_regular_gif_svg()
            } else if beast_id == beast_definitions::BEHEMOTH {
                get_behemoth_regular_gif_svg()
            } else if beast_id == beast_definitions::HYDRA {
                get_hydra_regular_gif_svg()
            } else if beast_id == beast_definitions::JUGGERNAUT {
                get_juggernaut_regular_gif_svg()
            } else if beast_id == beast_definitions::ONI {
                get_oni_regular_gif_svg()
            } else if beast_id == beast_definitions::JOTUNN {
                get_jotunn_regular_gif_svg()
            } else if beast_id == beast_definitions::ETTIN {
                get_ettin_regular_gif_svg()
            } else if beast_id == beast_definitions::CYCLOPS {
                get_cyclops_regular_gif_svg()
            } else if beast_id == beast_definitions::GIANT {
                get_giant_regular_gif_svg()
            } else if beast_id == beast_definitions::NEMEANLION {
                get_nemeanlion_regular_gif_svg()
            } else if beast_id == beast_definitions::BERSERKER {
                get_berserker_regular_gif_svg()
            } else if beast_id == beast_definitions::YETI {
                get_yeti_regular_gif_svg()
            } else if beast_id == beast_definitions::GOLEM {
                get_golem_regular_gif_svg()
            } else if beast_id == beast_definitions::ENT {
                get_ent_regular_gif_svg()
            } else if beast_id == beast_definitions::TROLL {
                get_troll_regular_gif_svg()
            } else if beast_id == beast_definitions::BIGFOOT {
                get_bigfoot_regular_gif_svg()
            } else if beast_id == beast_definitions::OGRE {
                get_ogre_regular_gif_svg()
            } else if beast_id == beast_definitions::ORC {
                get_orc_regular_gif_svg()
            } else if beast_id == beast_definitions::SKELETON {
                get_skeleton_regular_gif_svg()
            } else {
                // Default empty image
                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
            }
        }
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
                @"data:image/gif;base64,R0lGODlhIAAgAPEAAAAAAIwAvwAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACmYSPFonLD8OS00EF7KMyUZ9l3DiJXGOVV+p9Tdh2aAzW2O2ehwajfKgDvm4rGOtofLF6xN5vB2U6dzJGVarSyUqOILSSI16LJs34af2qqRf1sjNquxXd6zjCpovo9/TGCCanMmO3V/TDBYIWNVShuHKGM4WWuCY0ZJOFEYa5tqWX1CmW5FIGmjZY6eNFlfJBuQQZtzErZytXAAAh+QQFFAACACwAAAAAHwAfAAAClISPqcsb/ZoE4VUbIZW3potYVEeKZRiJmpGx4KGiHvrNrNJm6dzdH26DjTwx3+SW2uQ2TJyw2YIalc+lMVgLaXe8KPIl5BLDzdVQZ8MydMxieU39nr2OODGorrv23by2vjPE8TZSGEaH5OTm9tOY5LSG98OGaOLDpvdH9cjTuMWX2Kb5tCkI0+dl2ZMKxopBEtljUAAAOw==",
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
                @"data:image/gif;base64,R0lGODdhIAAgAJEAAAAAAAD/AIwAvwAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQIFAAAACwAAAAAIAAgAAACoISPqbviL5hsIMZ6FczsGahtXCKCh1Nh1pimqPrFsjVxr4vBrPndOcnqeBCozeTE04lqSRWNKFwBZ83GqGhrWX1I4iU4s2p/Yy9Q+o1xw7rWa7jOFXHpk5Okpufbz176mZElhUdTZ+eHdIXnVvYVBHa4Ejh0CGPXpxWXJSeTaYnohxk41Vk6avh5RclWd7PZ19o1ZlSolrRKiBN6xNvLUAAAIfkECBQAAAAsAAAAACAAIAAAAp2Ej6nL4i+YXLEaN/N5lycYTSD4jVJYoRiApakWduy10TEC4av1zRrrASpWGdKmlRMZj67kEDm09ZRR4rJE1Gl5UV/JK+R+dS+U7VbzcXi7NqU8Y+OAWXX8jl/jO2Y5rfbSY2E2x8c0ldY3Vfd3chbj1Bh0dwOJ1qjm5+VCxiQGOQYGBkpoiEmHRqgKmrj5Z4lJMviYNSm4F/mj+1MAACH5BAgUAAAALAAAAAAgACAAAAKehI+py+1vhJwCwopjtW5qqVBbI4pJOYYRALItiMEpk8LrnZGIx/Zyfmp9RsJDkWYaunikmJCyhD6YrhXvaJRmq8OZ8bab2by4sDPsQ2Yzm7aV3B5zX/TFK52rRU9WfH/phxZItOMDR9jzB/jBV5jo9sXVKNkX90iViJM3ecQEpQd2lgk2CsTmIYb5qDnnCPRXY/qZtkalWjm6x7ELUQAAIfkECBQAAAAsAAAAACAAIAAAAp2Ej6nL7W+EnALCimNddLepSUonMmR3iJjqpRFQgvBLZx8iZ6yNy2kJa2ksIQ8IdUEGV8rRznhMCF3LFrA4xQpZuBlnKN1usr8ws0eV1lTe8euKZuuCIXB3Nndbq+Z3mxrF41ej5rLiVKj3AyXm4JaWNTaVB0QxAmmzZ4dW5EX4BqfpyaPj49n5KUl3t5r5VzaZg1d1ZYo4x0ekC1EAADs=",
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
                @"data:image/gif;base64,R0lGODdhIAAgAIAAAAAAAAAA/yH/C05FVFNDQVBFMi4wAwEAAAAh+QQIFAAAACwAAAAAIAAgAAACmoSPqcsZfR5coZpqAZ7s5etxzRdJoqOlUWqeIJiR3BdLdEtdWmh5oUqJ6Wwqm2zIWimTPwTxtaspcc1NyUkDanm4XXLpKz51XtZPiCymxSVSc9XCxMPkONmb5S1RyPMXP6eg14dXd8cE4dNlJcJ1aDRTVmXyJlj2JfWXg6Xp2EG1d9fldHVICsUnNAqHShq2OjToqtmB6HJ7UAAAIfkECBQAAAAsAAAAACAAIAAAApSEj6nL7a8CNHKegCmu2yaZXaAXVUhIUsB4rW66cl1MouFtogxHg2PG291UvODs42K9VMRkhNk70ZimpiZ3zC63P5nG2SKyhuEh8LscU9PomE7Zqm7kvrI0XW++d6ff9a3T9ldVkncGc7RA6OAH5/dgSNfHOBWFk7Q4GbYFlSmYwwf11BH0hJnZxYl0ttjo+fUI41EAADs=",
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
                @"data:image/gif;base64,R0lGODdhIAAgAHcAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAAAACwAAAAAIAAgAIAAAAAA/wAClISPqbsBrmCYDyZ7nERUx3cZW+hx2aVRXIdlbSOmk1pZLyrLIMOrZcoLxTw2kfHm6uyMTFqwiLEhYccqM2jyHUfYU9Q6bbRGwG6MRA4nV7NTpetst7fYWREUf4vTeP37BqR1d+UEZnW2VdjHxvghFDUWp4TmEqG41KOoqTZkyclQNjQHh/i1o8YihXiKxNVKZRa7UAAAIfkEBRQAAAAsAQABAB4AHACBAAAAAAAAAP8AAAAAApgEcqaGF/iWapIp8QTAQs9kXYi3VUtAngyqotQFLt2GrV5DPU1tYiN1O3SGpopHcxQaRR8GR/Z5iSKpWwp0NcyQLuYmMyuKY7DxiVWRmqHfb3atNKvhKic9ZJmvszu85T3x0oFGt8OD85RTBgMhw8IRNOhIwuKSkuMzotVV4td0haSkBhjItjIWtBhK2iPRt3hXxhoLS9taAAAh+QQFFAAAACwBAAEAHgAcAIEAAAAAAAAA/wAAAAACmAR0pofihpaKEqoQwwl6JnshnYGVkjAukZNS1PUtHMCtKOg+9Cs/GJxAcWaVSkdz3BhDHogJGCxifDLniSRF7n6kDItYDIOq4tOtwitLjqKzGp0Kp99XK30cvZNV2JglbibzdJfBtWLiAoXV0IMk9MfVNXKD4hZTSbWV0VQXp0W5VKbTBzEH9DKiBVgWt6mo17cKGzorplEAACH5BAUUAAAALAEAAQAeABwAgQAAAAAAAAD/AAAAAAKZBHKmh+GGlooSGiGCAFnLNi0ZV13fVkUOOo2U+V4bpnrU/XCx0um8pcFgShXUDMb6XW4tjzKx0z2SKGeIVDxmRstlMEks7cBhBjlRDhsR2zTRGo66F7dznI6ei1KmvMUO8UIDKCajAtHG1PcDwuOxVcXBtcRi03Z10MFGGVFZiPWzYVOUlrPIUBb5pKV3ikbVSgoam0qbtlEAADs=",
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
                @"data:image/gif;base64,R0lGODlhIAAgAPAAAAAAAP///yH/C05FVFNDQVBFMi4wAwEAAAAh+QQEFAD/ACwAAAAAIAAgAAACfISPqcu94VKYDCIL6LNY6vkpWgSNjnmlldgdpdq1LqcatHui0hORfH/6ZYAxIdBYO3qGGNluNRQpL7LmNNOyOhs649ZGTUZ71VQXKmWCiegb6fvC+dZm+nddzdKF+pjba/PSZMUniBMSmAaCtzSCsniI9RhSVGFYd5V5UAAAIfkEBRQAAgAsAAADABwAHAAAAiWUj6kK6w+jnLRCEKzeBvMPhuJIluaJpurKLkHTbi85j3W8wWMBACH5BAUUAAIALBgABwADAAMAAAIERGAJBQAh+QQFFAACACwAAAMAHAAcAAACI5SPqRrrD6OctNqLs75g+w+G4kiW5ommCdCoGBvCoOxiLVgAACH5BAUUAAIALAAABQAcABoAAAImlI+pCutvQIAUyYpzvrq76YXiSJbmiabqyrZp0LgkjNKnLZPxWQAAIfkEBRQAAgAsAAABAB0AHgAAAl6Ej6nC7Q8ZCgrE2w4F+2DMGUHwlc6Iml8nIuoTTtR7jXKFa61C0pflk7ASo2CE0jNmTMDaSZfjDT3G5qOTVDayWsiUaDVxu+Sy2Tg7q4PjFU+Uftk0mbDKtuwi6ecCADs=",
            );
        svg
    }
}
