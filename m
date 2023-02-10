Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82A69153A
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBJAOb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 19:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBJAOa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 19:14:30 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F8E5C49F
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 16:14:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a5so2443523pfv.10
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 16:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P3AveB+mmBa5VWUNFXeyfg54SsOtbbTbogCLGT8ozDI=;
        b=7GvIw5VwPdp/wU08Ia6ArLYs5Ipf08Kebfj4oux494bL0WjP2A3uZclCxrhRsN1+RE
         jq1rJiIN/iP4janAfF/DNuzBCNZvKDnAEVIW2CuuH4cg7b33WtXkNf+YNnNZtXcqPfAD
         Pi+CyPI//cyXYjOrzC9A4/sq0A6JN2t95Vlts6QlS2/qWi3fNDh+M/uOGgv4ZO2xIgEb
         kljvhPpx3/4BaTndgzlX1oKDqGzW0mgPisoQVpMIRXp7PDnl4JmNBjutIyKCaUKl/9UM
         HqUL5d6FkizfVz1HmHoTgiB4uOWymsiV8jW4TFBxZKz2kN7C+6TuMUzEZlkVsTIQHx3e
         MAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P3AveB+mmBa5VWUNFXeyfg54SsOtbbTbogCLGT8ozDI=;
        b=gsdSgHvLUT5zvV4Co8EAEByFIccspFu0yGHzPGY0dH4KQz++0ZnU6dpwuki1cpAaNR
         soOjSY581X8NVMOL0zFT6X/4cV0tFctadOdonxFlDo0poVSh7Jk1qlicnexyWkiQNTH5
         Kbn/gJhnSW8k0SPtxAczrfKFBXznVm+rDSjNn//f34yXgKO3f2LbQCggWtNt8OG5aAb9
         xw62xvRw1qU+cX6YfiUtxNgAwmNoQOnD2UX7ECL+e1IB8d3Tbdy5Eat0MQ56j4axKblM
         1ZPvPJ5wR+CGmBBnvbgBMJrymMWmXjnUDFXq+mgajlSI97wMKt45N/SZ/eke21OHYNUv
         KGvQ==
X-Gm-Message-State: AO0yUKWXHNuKTis5VRtWWmQG1TcvrJHJR5v61p+l7/J/d1GLHJ3N3zi2
        d80U2T8IjVL0lvoBBmCPZ2awLg==
X-Google-Smtp-Source: AK7set9NN4wcnwcbKNJGoBkmVg+AwmSHv5nldFMjTsAywzbDHfsIfGACztcjTO0SThoFvKdK6WLBXg==
X-Received: by 2002:a62:d10f:0:b0:5a8:4675:c9a9 with SMTP id z15-20020a62d10f000000b005a84675c9a9mr6336148pfg.2.1675988068374;
        Thu, 09 Feb 2023 16:14:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n3-20020aa78a43000000b00593b72f6680sm2018611pfa.86.2023.02.09.16.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 16:14:27 -0800 (PST)
Message-ID: <7d684001-e24d-726f-885d-597f8c3d3101@kernel.dk>
Date:   Thu, 9 Feb 2023 17:14:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 5/7] io-uring: add sqpoll support for napi busy poll
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>
References: <20230209230144.465620-1-shr@devkernel.io>
 <20230209230144.465620-6-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230209230144.465620-6-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/23 4:01?PM, Stefan Roesch wrote:
> This adds the sqpoll support to the io-uring napi.

This should also have a bit more of an explanation of _why_ this
is needed and being done.

> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index c9e2afae382d..038957b46a0e 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -278,4 +278,29 @@ void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>  		io_napi_merge_lists(ctx, napi_list);
>  }
>  
> +/*
> + * io_napi_sqpoll_busy_poll() - busy poll loop for sqpoll
> + * @ctx: pointer to io-uring context structure
> + * @napi_list: pointer to head of napi list
> + *
> + * Splice of the napi list and execute the napi busy poll loop.
> + */
> +int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx, struct list_head *napi_list)
> +{
> +	int ret = 0;
> +
> +	spin_lock(&ctx->napi_lock);
> +	list_splice_init(&ctx->napi_list, napi_list);
> +	spin_unlock(&ctx->napi_lock);
> +
> +	if (!list_empty(napi_list) &&
> +	    READ_ONCE(ctx->napi_busy_poll_to) > 0 &&
> +	    io_napi_busy_loop(napi_list, ctx->napi_prefer_busy_poll)) {
> +		io_napi_merge_lists(ctx, napi_list);
> +		ret = 1;
> +	}
> +
> +	return ret;

Should 'ret' be a bool and the return value of the function too?

> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 0672592cfb79..23a6df32805f 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -23,6 +23,7 @@ void io_napi_adjust_busy_loop_timeout(struct io_ring_ctx *ctx,
>  			struct timespec64 *ts);
>  void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>  			struct list_head *napi_list);
> +int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx, struct list_head *napi_list);
>  
>  #else
>  
> @@ -43,6 +44,7 @@ static inline void io_napi_add(struct io_kiocb *req)
>  #define io_napi_setup_busy_loop(ctx, iowq, napi_list) do {} while (0)
>  #define io_napi_adjust_busy_loop_timeout(ctx, iowq, napi_list, ts) do {} while (0)
>  #define io_napi_end_busy_loop(ctx, iowq, napi_list) do {} while (0)
> +#define io_napi_sqpoll_busy_poll(ctx, napi_list) (0)

This should be:

#define io_napi_sqpoll_busy_poll(ctx, napi_list)
{(
)}
do { } while (0)

>  
>  #endif
>  
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 0119d3f1a556..90fdbd87434a 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -15,6 +15,7 @@
>  #include <uapi/linux/io_uring.h>
>  
>  #include "io_uring.h"
> +#include "napi.h"
>  #include "sqpoll.h"
>  
>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
> @@ -168,6 +169,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>  {
>  	unsigned int to_submit;
>  	int ret = 0;
> +	NAPI_LIST_HEAD(local_napi_list);

In general, keep these roughly in inverse xmas tree.

>  	to_submit = io_sqring_entries(ctx);
>  	/* if we're handling multiple rings, cap submit size for fairness */
> @@ -193,6 +195,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>  			ret = io_submit_sqes(ctx, to_submit);
>  		mutex_unlock(&ctx->uring_lock);
>  
> +		ret += io_napi_sqpoll_busy_poll(ctx, &local_napi_list);
> +
>  		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>  			wake_up(&ctx->sqo_sq_wait);
>  		if (creds)

Not clear to me what this ret += ... does here? We're currently
returning number of sqes submitted. Maybe this is fine and just means
'we did some work', but if so, should add a comment for that.

-- 
Jens Axboe

