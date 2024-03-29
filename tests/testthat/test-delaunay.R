test_that("2d Delaunay", {
  pts <- rbind(
    c(-1, 1), 
    c(1, 1), 
    c(1, -1), 
    c(-1, -1), 
    c(-0.802336097229272, -0.26233067503199), 
    c(-0.457044367212802, -0.768556851893663), 
    c(0.533056422136724, -0.515254276338965), 
    c(-0.550715145654976, -0.572112019173801), 
    c(-0.595112917944789, 0.0101109039969742), 
    c(-0.393483111169189, -0.217547377571464), 
    c(-0.518365745898336, 0.444131538271904), 
    c(-0.257755127735436, 0.0397646767087281), 
    c(0.101255970075727, -0.922953370027244), 
    c(0.494106223806739, -0.325543498620391)
  )
  edges <- matrix(
    c(1L, 2L, 1L, 1L, 4L, 1L, 1L, 5L, 0L, 1L, 9L, 0L, 1L, 
      11L, 0L, 2L, 3L, 1L, 2L, 11L, 0L, 2L, 12L, 0L, 2L, 14L, 0L, 3L, 
      4L, 1L, 3L, 7L, 0L, 3L, 13L, 0L, 3L, 14L, 0L, 4L, 5L, 0L, 4L, 
      6L, 0L, 4L, 8L, 0L, 4L, 13L, 0L, 5L, 8L, 0L, 5L, 9L, 0L, 5L, 
      10L, 0L, 6L, 8L, 0L, 6L, 10L, 0L, 6L, 13L, 0L, 7L, 13L, 0L, 7L, 
      14L, 0L, 8L, 10L, 0L, 9L, 10L, 0L, 9L, 11L, 0L, 9L, 12L, 0L, 
      10L, 12L, 0L, 10L, 13L, 0L, 10L, 14L, 0L, 11L, 12L, 0L, 12L, 
      14L, 0L, 13L, 14L, 0L),
    nrow = 35L,
    ncol = 3L,
    byrow = TRUE
  )
  colnames(edges) <- c("v1", "v2", "border")
  #
  del <- delaunay(pts)
  expect_equal(del[["edges"]], edges)
})
