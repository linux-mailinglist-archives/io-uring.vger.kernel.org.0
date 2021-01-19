Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0B72FC4E6
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbhASXhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 18:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395062AbhASOFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 09:05:38 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2B2C061575
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 06:04:45 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id 19so21870997qkm.8
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 06:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wU6+fi+zBzcHviaxycW/FvztAConmFKtN2XCThl/pvM=;
        b=H2o+UaUKucaRhAQyni04CoZ5HmLmPzymBBGdNdFKWNXGQzUKY08MVdYS7iIQ2y1mpd
         ZTP2z3+HGV2GSgEhdfzifsftTlXnFWyDe8gcQfd+hnBsmEGBhfx01QhKDpeFQQ063FLl
         5D83RmDmDa0K7qSK2GIi48EXIBVQUQHExqYUQvuOziCTxjhzr7BbVMXmFTkTQiMilZfa
         2tCovf2nF+wCPLZf3EqRHLUSzkEaUGWnLzxEtGOebQrK6Af4WSXaJBY1jp8sNIqsEIU9
         5HwzZESTaMOKciPCGs6OEqTBB1ZemaJdVXQTIzr3CdClYeMp7KU818/Thl8/JsQFDVeN
         iEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wU6+fi+zBzcHviaxycW/FvztAConmFKtN2XCThl/pvM=;
        b=HPOpw3aZO9GWTzaUNu5Cc1274vn5Uu6c9+QY0bmIlPri+E2INDGf3SCT/jvbn5KovO
         Fq8amiis1nbSPttbH388i3xKOuxueFOADctkg2e3K0N4n4tKJCfo7jLai6wFW6ML/9ES
         F6adVQ/RdfNcEYrXwUE4mceXVo/X9cEXAcv9/Pl5OG3pmXIE+sZSZJuxhPAFXnF62GVY
         zLratqRrVUnYOLFc42/jIDYTCMVM3AO2OBiqRvIMuwKzbAEGtQy9bSbVCnNoIOfmoq7v
         uKDkYs21efS80PRmkeefY1L5GCZ5Jz2LPYpkJBTk4tB7a7ZFb+iOf+vrWfhXk3Lw+Oo3
         it3A==
X-Gm-Message-State: AOAM530+JotIqZUqw0v76g8wXH1T3CH/XJGNMgOBMDt5Xm5dbQzPPEO+
        tlu9ujrEc5j/Hh8QQjw/H9bSEarmEOLQzQ==
X-Google-Smtp-Source: ABdhPJwMhJUXTAYAvEfmER8It2UZdDBbOhqSYTeQYbyPweyiHopVRX66Kbbr8jUQ5L8T4nFz9YtVlA==
X-Received: by 2002:a37:a342:: with SMTP id m63mr4522748qke.120.1611065084658;
        Tue, 19 Jan 2021 06:04:44 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id y25sm373556qky.14.2021.01.19.06.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 06:04:43 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:04:41 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] tests: add another timeout sequence test case
Message-ID: <20210119140441.GA5533@marcelo-debian.domain>
References: <20210118170029.107274-1-marcelo827@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118170029.107274-1-marcelo827@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 18, 2021 at 12:00:29PM -0500, Marcelo Diop-Gonzalez wrote:
> This test case catches an issue where timeouts may not be flushed
> if the number of new events is greater (not equal) to the number
> of events requested in the timeout.
> 
> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> ---
>  test/timeout.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/test/timeout.c b/test/timeout.c
> index 9c8211c..d46d93d 100644
> --- a/test/timeout.c
> +++ b/test/timeout.c
> @@ -112,7 +112,7 @@ err:
>  /*
>   * Test numbered trigger of timeout
>   */
> -static int test_single_timeout_nr(struct io_uring *ring)
> +static int test_single_timeout_nr(struct io_uring *ring, int nr)
>  {
>  	struct io_uring_cqe *cqe;
>  	struct io_uring_sqe *sqe;
> @@ -126,7 +126,7 @@ static int test_single_timeout_nr(struct io_uring *ring)
>  	}
>  
>  	msec_to_ts(&ts, TIMEOUT_MSEC);
> -	io_uring_prep_timeout(sqe, &ts, 2, 0);
> +	io_uring_prep_timeout(sqe, &ts, nr, 0);
>  
>  	sqe = io_uring_get_sqe(ring);
>  	io_uring_prep_nop(sqe);
> @@ -149,6 +149,8 @@ static int test_single_timeout_nr(struct io_uring *ring)
>  			goto err;
>  		}
>  
> +		ret = cqe->res;
> +
>  		/*
>  		 * NOP commands have user_data as 1. Check that we get the
>  		 * two NOPs first, then the successfully removed timout as
> @@ -167,15 +169,16 @@ static int test_single_timeout_nr(struct io_uring *ring)
>  				fprintf(stderr, "%s: timeout not last\n", __FUNCTION__);
>  				goto err;
>  			}

Ahh wait actually I don't like it so much because this assumes the
timeout has to be the last one in the ring even when nr = 1. Happens
to be true but doesn't seem like something the test should require in
that case. I'll send a v2 later.

-Marcelo

> +			if (ret) {
> +				fprintf(stderr, "%s: timeout triggered by passage of"
> +					" time, not by events completed\n", __FUNCTION__);
> +				goto err;
> +			}
>  			break;
>  		}
>  
> -		ret = cqe->res;
>  		io_uring_cqe_seen(ring, cqe);
> -		if (ret < 0) {
> -			fprintf(stderr, "Timeout: %s\n", strerror(-ret));
> -			goto err;
> -		} else if (ret) {
> +		if (ret) {
>  			fprintf(stderr, "res: %d\n", ret);
>  			goto err;
>  		}
> @@ -1224,9 +1227,14 @@ int main(int argc, char *argv[])
>  		return ret;
>  	}
>  
> -	ret = test_single_timeout_nr(&ring);
> +	ret = test_single_timeout_nr(&ring, 1);
> +	if (ret) {
> +		fprintf(stderr, "test_single_timeout_nr(1) failed\n");
> +		return ret;
> +	}
> +	ret = test_single_timeout_nr(&ring, 2);
>  	if (ret) {
> -		fprintf(stderr, "test_single_timeout_nr failed\n");
> +		fprintf(stderr, "test_single_timeout_nr(2) failed\n");
>  		return ret;
>  	}
>  
> -- 
> 2.20.1
> 
