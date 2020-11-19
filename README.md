
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vindecodr

<!-- badges: start -->

<!-- badges: end -->

The goal of vindecodr is to provide an efficient programmatic interface
to the US Department of Transportation (DOT) National Highway
Transportation Safety Adminstration (NHTSA) vehicle identification
number (VIN) decoder API, located at <https://vpic.nhtsa.dot.gov/api/>.

## Installation

You can install the released version of vindecodr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("vindecodr")
```

Or you can install the development version from
[GitHub](https://github.com/burch-cm/vindecodr) with:

``` r
# install.packages("devtools")
devtools::install_github("burch-cm/vindecodr")
```

## Examples

### Find the Make and Model for a Given VIN:

Managed fleet vehicle systems often need to confirm the information they
have on file for a particular vehicle, such as the make, model, fuel
type, etc. This can easily be accomplished by comparing the records on
file with the manufacturer’s values as encoded in the VIN.

``` r
library(vindecodr)
given_vin <- "1C4BJWFGXDL531773"

vehicle_details <- decode_vin(given_vin)

knitr::kable(vehicle_details)
```

| VIN               | make | model    | model\_year | fuel\_type | GVWR                                          |
| :---------------- | :--- | :------- | :---------- | :--------- | :-------------------------------------------- |
| 1C4BJWFGXDL531773 | JEEP | Wrangler | 2013        | Gasoline   | Class 1D: 5,001 - 6,000 lb (2,268 - 2,722 kg) |

Single VINs are passed to the [Decode API
Endpoing](https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValues/).  
The same call can be used for up to 50 VINs. When multiple VINs are
provided, the [Batch API
Endpoint](https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINBatchValues/)
is used instead.

``` r
library(vindecodr)

given_vins <- c("1C4BJWFGXDL531773",
                "JTHFF2C26B2515141",
                "WDBRF40J43F433102")

vehicle_details <- decode_vin(given_vins)
knitr::kable(vehicle_details[1:3])
```

| VIN               | make          | model    |
| :---------------- | :------------ | :------- |
| 1C4BJWFGXDL531773 | JEEP          | Wrangler |
| JTHFF2C26B2515141 | LEXUS         | IS       |
| WDBRF40J43F433102 | MERCEDES-BENZ | C-Class  |

See the [NHTSA API Documentation](https://vpic.nhtsa.dot.gov/api) for
more detail on API endpoints.
