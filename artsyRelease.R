#####################################################################
############## PACKAGE ROOT #########################################
#####################################################################

setwd("C:/Users/derksk/OneDrive - NBU/Desktop/aRtsy")

#####################################################################
############## BUILDING WORKFLOW ####################################
#####################################################################

# Documentation
roxygen2::roxygenize()      # Build the .rmd files   
devtools::build_manual()    # Build the pdf manual

# Local .tar.gz
devtools::build(args = "--no-multiarch") # Build the package from the root

# Github package
devtools::install_github("koenderks/aRtsy", INSTALL_opts = "--no-multiarch")

# Local R package install
install.packages("C:\\Users\\derksk\\OneDrive - NBU\\Desktop\\aRtsy",
                 INSTALL_opts = "--no-multiarch", 
                 type = "source", 
                 repos = NULL,
                 lib = "C:/Users/derksk/R/R-4.0.5/library")

#####################################################################
############## RELEASE WORKFLOW #####################################
#####################################################################

devtools::test()                                        # 2. Perform unit tests
devtools::spell_check()                                 # 3. Perform spelling checks
devtools::revdep()                                      # 4. Check reverse dependencies
devtools::check(args = "--no-multiarch", cran = TRUE)   # 5. Perform CRAN checks and unit tests
devtools::check_win_devel()                             # 6. Perform winHub checks (takes about 30 min)
devtools::check_rhub()                                  # 7. Perform RHub checks (takes about 30 min)

devtools::release()                                     # 8. Release the package to CRAN
