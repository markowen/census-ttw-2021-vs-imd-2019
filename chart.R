
library(dplyr)

modes <- read.csv('modes.csv')
data <- read.csv('ttw_imd.csv')

doplot <- function(m) {
	filtered <- filter(data, mode_code == m)

	mode_name <- filter(modes, code == m)$name

	percent = filtered$percent
	rank = filtered$rank
	
	axis_col <- "#dddddd"

	par(
		bg="#161B28",
		col=axis_col,
		col.axis=axis_col,
		col.lab="white",
		col.main="white"
	)

	plot(
		y = percent,
		x = rank,
		xlab = "IMD Rank (lower = more deprived)",
		ylab = "Percent",
		main = paste("Census TTW 2021 \"", mode_name, "\" vs IMD 2019 Rank", sep = ""),
		type = "p",
		pch = 19,
		col = "#3EDAFF",
		cex = 0.3,
	)

	axis(1, col=axis_col, col.ticks=axis_col)
	axis(2, col=axis_col,col.ticks=axis_col)

	abline(lm(percent ~ rank), lw = 3, col="white")
}

doplots <- function() {
	for(i in 1:nrow(modes)) {
		row <- modes[i,]
		c <- row[,"code"]
		n <- row[,"name"]
		f <- paste("images/", c, "-", n, ".png", sep="")

		png(file=f, width=1200, height=800)

		doplot(c)

		dev.off()
	}
}


