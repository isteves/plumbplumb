#* Download random praise
#* @serializer unboxedJSON
#* @param seed:numeric
#* @get /random_praise
function(seed){
    set.seed(seed)
    praise::praise()
}

#* Download random data
#* @param res
#* @param seed:numeric
#* @get /random_data
function(res, seed){
    set.seed(seed)
    rdata <- data.frame(foo = letters[1:10],
                        bar = runif(10, 0, 5))

    file_path <- fs::path(tempdir(), "random_data.csv")
    readr::write_csv(rdata, file_path)
    on.exit(unlink(file_path))

    res$serializer <- plumber::serializer_content_type("text/csv")
    readBin(file_path, "raw", n = file.info(file_path)$size)
}
