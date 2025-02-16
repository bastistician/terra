

setMethod("princomp", signature(x="SpatRaster"),
	function(x, cor=FALSE, fix_sign=TRUE, use="pairwise.complete.obs") {

		if (!hasValues(x)) {
			error("princomp", "x has no values")
		}
		if (nlyr(x) < 2) {
			error("princomp", "The number of layers of x must be > 1")
		}
		xcov <- layerCor(x, fun="cov", use=use, asSample=FALSE)
		if (any(is.na(xcov[["covariance"]]))) {
			error("princomp", "the covariance matrix has missing values")		
		}

		model <- princomp(covmat=xcov$covariance, cor=cor, fix_sign=fix_sign)
		model$center <- diag(xcov$mean)
		n <- diag(xcov$n)
		if (cor) {
		## scale as population sd
			S <- diag(xcov$covariance)
			model$scale <- sqrt(S)
		}
		model$n.obs <- stats::as.dist(xcov$n)
		model
	}
)

