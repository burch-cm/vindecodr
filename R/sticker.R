library(showtext)
## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Fjalla One", "fjalla")
font_add_google("Bebas Neue", "bebas")
## Automatically use showtext to render text for future devices
showtext_auto()

library(hexSticker)
imgurl <- system.file("./man/figures/vin-number.jpg")
sticker("./man/figures/vin-number.jpg",
        package = "vindecodr",
        p_size=22, p_x = 1, p_y = .6,
        s_x=1, s_y=1.15, s_width=1, s_height=1,
        h_fill="#194b6c", h_color="#d1d2d4",
        filename = "./man/figures/sticker.png",
        p_family = "bebas")
