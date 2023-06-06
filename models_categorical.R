load("example_data/earnings.RData")
model1 <- lm(wages~education+I(age-mean(age)), data=earnings)
contrasts(earnings$education)

ordered_factor <- function(fact_var) {
  ord_fact <- factor(fact_var, ordered=TRUE)
  categories <- levels(fact_var)
  n_cat <- length(categories)
  cont <- matrix(0, n_cat, n_cat-1)
  cont[col(cont)<row(cont)] <- 1
  rownames(cont) <- categories
  colnames(cont) <- paste(categories[2:n_cat], categories[1:(n_cat-1)],
                          sep=" vs. ")
  contrasts(ord_fact) <- cont
  return(ord_fact)
}

earnings$education <- ordered_factor(earnings$education)
contrasts(earnings$education) 
model2 <- lm(wages~education+I(age-mean(age)), data=earnings)
