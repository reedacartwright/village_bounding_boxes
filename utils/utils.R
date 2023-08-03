library(glue)
library(readr)

chop_line <- function(length) {
    length <- as.integer(length)
    parts <- 2^(11:0)
    b <- (bitwAnd(length, parts) == parts)
    parts[b]
}

make_line <- function(pos, length, axis, color) {
    # split length into particle pieces and find mids
    parts <- chop_line(length)
    x <- cumsum(c(0,parts))
    mids <- (x[-1] + x[-length(x)]) / 2
    
    # calculate the position of each particle
    axis_tab <- c("X" = 1, "Y" = 2, "Z" = 3)
    m <- matrix(0, nrow = 3, ncol = length(mids))
    m[axis_tab[axis], ] <- mids
    m <- m + pos

    # build particle commands
    p1 <- glue("particle ll:linep{axis}{color}{parts} ~{m[1,]} ~{m[2,]} ~{m[3,]}")
    p2 <- glue("particle ll:linem{axis}{color}{parts} ~{m[1,]} ~{m[2,]} ~{m[3,]}")
    p3 <- glue("particle ll:line_backp{axis}{color}{parts} ~{m[1,]} ~{m[2,]} ~{m[3,]}")
    p4 <- glue("particle ll:line_backm{axis}{color}{parts} ~{m[1,]} ~{m[2,]} ~{m[3,]}")

    c(p1, p2, p3, p4)
}

make_box <- function(pos, size, color) {
    x1 <- make_line(pos, size[1], "X", color)
    x2 <- make_line(pos + c(0, size[2], 0), size[1], "X", color)
    x3 <- make_line(pos + c(0, 0, size[3]), size[1], "X", color)
    x4 <- make_line(pos + c(0, size[2], size[3]), size[1], "X", color)

    y1 <- make_line(pos, size[2], "Y", color)
    y2 <- make_line(pos + c(size[1], 0, 0), size[2], "Y", color)
    y3 <- make_line(pos + c(0, 0, size[3]), size[2], "Y", color)
    y4 <- make_line(pos + c(size[1], 0, size[3]), size[2], "Y", color)

    z1 <- make_line(pos, size[3], "Z", color)
    z2 <- make_line(pos + c(size[1], 0, 0), size[3], "Z", color)
    z3 <- make_line(pos + c(0, size[2], 0), size[3], "Z", color)
    z4 <- make_line(pos + c(size[1], size[2], 0), size[3], "Z", color)

    c(x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)
}

make_box_grid <- function(pos, size, color, length_out) {
    ret <- c()

    myseq <- function(sz, out) {
        x <- seq(0L, sz, length.out = out + 2L )
        x[-c(1L, length(x))]
    }

    # X lines
    x <- myseq(size[1], length_out)
    for(xx in x) {
        ret <- c(ret, make_line(pos + c(xx, 0, 0), size[2], "Y", color))
        ret <- c(ret, make_line(pos + c(xx, 0, size[3]), size[2], "Y", color))

        ret <- c(ret, make_line(pos + c(xx, 0, 0), size[3], "Z", color))
        ret <- c(ret, make_line(pos + c(xx, size[2], 0), size[3], "Z", color))
    }
    
    # Y lines
    y <- myseq(size[2], length_out)
    for(yy in y) {
        ret <- c(ret, make_line(pos + c(0, yy, 0), size[1], "X", color))
        ret <- c(ret, make_line(pos + c(0, yy, size[3]), size[1], "X", color))

        ret <- c(ret, make_line(pos + c(0, yy, 0), size[3], "Z", color))
        ret <- c(ret, make_line(pos + c(size[1], yy, 0), size[3], "Z", color))
    }

    # Z lines
    z <- myseq(size[3], length_out)
    for(zz in z) {
        ret <- c(ret, make_line(pos + c(0, 0, zz), size[1], "X", color))
        ret <- c(ret, make_line(pos + c(0, size[2], zz), size[1], "X", color))

        ret <- c(ret, make_line(pos + c(0, 0, zz), size[2], "Y", color))
        ret <- c(ret, make_line(pos + c(size[1], 0, zz), size[2], "Y", color))
    }


    unique(ret)
}

if(FALSE) {
    orig <- c(0,0,0)
    aabb <- c(64, 24, 64)
    center <- aabb / 2
    box <- make_box(orig, aabb, "L")
    write_lines(box, "functions/vbb/show_aabb.mcfunction")

    box <- make_box(orig + -64, aabb + 128, "T")
    write_lines(box, "functions/vbb/show_zone.mcfunction")
 
    box <- make_box(orig + center - c(8, 6, 8), c(17, 13, 17), "W")
    write_lines(box, "functions/vbb/show_spawn.mcfunction")

    box <- make_box(orig - 4*8, aabb + 4*8*2, "A")
    write_lines(box, "functions/vbb/show_act4.mcfunction")
 
    box <- make_box(orig - 6*8, aabb + 6*8*2, "A")
    write_lines(box, "functions/vbb/show_act6.mcfunction")

    box <- make_box(orig + center - 1, c(2, 2, 2), "V")
    box <- c(box, make_line(orig + center - c(1, 0, 0), 2, "X", "R"))
    box <- c(box, make_line(orig + center - c(0, 1, 0), 2, "Y", "R"))
    box <- c(box, make_line(orig + center - c(0, 0, 1), 2, "Z", "R"))
    #box <- c(box, make_line(orig + center + c(0.0, 0.5, 0.5), 1, "X", "G"))
    box <- c(box, make_line(orig + center + c(0.5, 0.0, 0.5), 1, "Y", "G"))
    #box <- c(box, make_line(orig + center + c(0.5, 0.5, 0.0), 1, "Z", "G"))
    write_lines(box, "functions/vbb/show_center.mcfunction")

    box <- make_box_grid(orig + -64, aabb + 128, "T", 5)
    g <- sort(rep(1:5, length.out=length(box)))
    split(box, g) |> purrr::iwalk(function(x, i) {
        write_lines(x, glue::glue("functions/vbb/zzz/show_zone_grid_{i}.mcfunction"))
    })

    box <- make_box_grid(orig - 4*8, aabb + 4*8*2, "A", 4)
    g <- sort(rep(1:5, length.out=length(box)))
    split(box, g) |> purrr::iwalk(function(x, i) {
        write_lines(x, glue::glue("functions/vbb/zzz/show_sim4_grid_{i}.mcfunction"))
    })

    box <- make_box_grid(orig - 6*8, aabb + 6*8*2, "A", 4)
    g <- sort(rep(1:5, length.out=length(box)))
    split(box, g) |> purrr::iwalk(function(x, i) {
        write_lines(x, glue::glue("functions/vbb/zzz/show_sim6_grid_{i}.mcfunction"))
    })

# execute at @e[name=svb] positioned ~0.0, ~0.5, ~0.0 run function svb/show_sim6
}