Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0F5613AED
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiJaQCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiJaQCD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:02:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3E2EAA
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:02:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b29so11019531pfp.13
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=88NZ1ZlQuvYg173XUs6YmRoMOZIyR2+eA0HY3gAx2n0=;
        b=60XvKgSyQ3SE3Dw2ywtCPJCUMkftkf42TdeUsGFYBokm5tZjFT9TPzuEPHqyFemOhP
         G1jpPcnjkwNd0O5X+vjL/NQ/lCL30+HN1ibsyAWXZWWEiVCePSBmXA7ag2KGXJL38reX
         +KK3YAPP9cSi6GbC2CV6LXVdih+BHTGOkPKotWOeitZYHhNOzS1vnnkFmv+VQHSWnBOg
         dLGFSq0o+IH+DjIr7lgV77DVs4Dy+bi4bCqxstNWQ43Cu/IjoghivjirO8AjSJLAAwyF
         uzRegueNSq6WWQ99Rghr41EeyDlAiq0BEyrLiU/w5SmouVYog301IEUE18R4QnjfFAGD
         s91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88NZ1ZlQuvYg173XUs6YmRoMOZIyR2+eA0HY3gAx2n0=;
        b=zpqOYWOrKHNdAM3VurukLjF6Sf+mnGz3xtPehx3femuV7UiXsnN9dSd/thZd/A+W1k
         daD7aQHyhYCztyan/1B7RNHKLVi9dSjzt/wt/BDYKlIHbfsbWoEnP9uHx6pi23EAMoEF
         l8HCjpSSOk4UCJ8PMMKgOZn6dDlbA1b6EoC/xwcaowvi6e3GGRPHONimOwr+rnmBIkZj
         8uhyloMUAO5PqlQR38HKMiJTGD8rdbiVyR0wuGYazBurnC+ndME+vgYIM69iYQGl9ai9
         2uwXRvRNHQV5cwGwCcOZHrY4FKviF6VolUBqbt+jHmIDy1Wd15mbZ9v8S3UX+rl4oW57
         uAhw==
X-Gm-Message-State: ACrzQf2gCSa6YN3kxyXBdec1sR179ZE1kvPMj/mw/yJkcKdiEWiiqNUU
        WYyV6TXtaHdqm/A0cM2FeUwK2g==
X-Google-Smtp-Source: AMsMyM6l4mvSeHhFKt7dkCyF968C4haVN+KReIshDsqt2KFn4oguoTAgKxPSuqgtVhAoMRAl9jd3Xg==
X-Received: by 2002:a63:2cd2:0:b0:41c:5901:67d8 with SMTP id s201-20020a632cd2000000b0041c590167d8mr13198010pgs.365.1667232122328;
        Mon, 31 Oct 2022 09:02:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d85-20020a621d58000000b0056bc30e618dsm4768850pfd.38.2022.10.31.09.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 09:02:01 -0700 (PDT)
Message-ID: <83a1653e-a593-ec0e-eb0d-7850d1a0c694@kernel.dk>
Date:   Mon, 31 Oct 2022 10:02:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-5-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221031134126.82928-5-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 7:41 AM, Dylan Yudaken wrote:
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 8d0d40713a63..40b37899e943 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -248,12 +248,20 @@ static unsigned int io_rsrc_retarget_table(struct io_ring_ctx *ctx,
>  	return refs;
>  }
>  
> -static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
> +static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx, bool delay)
>  	__must_hold(&ctx->uring_lock)
>  {
> -	percpu_ref_get(&ctx->refs);
> -	mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 * HZ);
> -	ctx->rsrc_retarget_scheduled = true;
> +	unsigned long del;
> +
> +	if (delay)
> +		del = 60 * HZ;
> +	else
> +		del = 0;
> +
> +	if (likely(!mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, del))) {
> +		percpu_ref_get(&ctx->refs);
> +		ctx->rsrc_retarget_scheduled = true;
> +	}
>  }

What happens for del == 0 and the work running ala:

CPU 0				CPU 1
mod_delayed_work(.., 0);
				delayed_work runs
					put ctx
percpu_ref_get(ctx)

Also I think that likely() needs to get dropped.

-- 
Jens Axboe
