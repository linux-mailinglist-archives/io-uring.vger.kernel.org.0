Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD87632A1E
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKUQ4A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 11:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUQz7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 11:55:59 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB91460EB4
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 08:55:58 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id h206so9027088iof.10
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 08:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u2MGEDR2oV7h7pFcRQjpy7U4Qu9Ey3K1zKZyAfQttag=;
        b=MWgDttL/7g+v43Ihdc2MQD7/xUOUmKu4feM6G1+hhxKituw8pRrhRUHLi9P8mStXIM
         CjCXPbY6NEYbvukm4jqIslA4QJUCLED/iykcsSj97qxoQS69Lbpi+3ZdVivPrRYSeKPw
         I3u33JoYDxXe8WygjKTtyb3Dxoo/isrSrhj/Untu/rD3FONq3Xgf9UVfpslKDymuD6Pq
         ueVxXir/5t7xAybtD2rI0IR7u9OxRc5r5cGZvj2mVBW3EQDpYiuO5WWnVQBAlvKUHo8b
         kOlPVdQRamS41qGiRAvkFtmT9L82SMMyBKFm20FOc4J+Z3LAFSrTNQoxaHLIokRiEndr
         6ZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2MGEDR2oV7h7pFcRQjpy7U4Qu9Ey3K1zKZyAfQttag=;
        b=tpEjteyPY1AeTC7O6i3YoYgIjuCXq4OcE2oLylm+4dXEIFTq8PDx0Ixz6rRUhWXNCX
         ZYukzPGzRzksnDrAv8BEDVBiwrOjwtXpn+ndUe2SxNDV4wQD4NtErebn/DTu145zPoeI
         x53ZUBGDj/X7MeqdvwxVxvAey8c3sme1ZpKcGWwGifPyPr5ksbErUWkTynvyVmFDiOYy
         BKM3tn/uxDuaN4Zsqcy1JsjZizO61WThJbbNC7U8+a7EJQum1Zuc+Jsoh0UDAY6iFN9p
         gqx+DrfInEouRwfm/CuCkUOSsbdRVYSjOA9JrQQaaGNwmhsus1IZ6B+yBpoI2cFcYgCV
         eqfw==
X-Gm-Message-State: ANoB5pkBX1O8W4Oo+m3C+UjGfaOeihlFi6ibqpLTD8ouYGw+DjcOzKny
        mKWz/dUgz9A2gkemPlSp1SslXSkCvizCYQ==
X-Google-Smtp-Source: AA0mqf4kXJTtd5w73k28smU1OUDJJTjgq4eXPtq7slE5dyQ3p0ikGjwGTE49R2OPgmr7T1vJTXQevQ==
X-Received: by 2002:a6b:310e:0:b0:6bd:36d3:a858 with SMTP id j14-20020a6b310e000000b006bd36d3a858mr8715516ioa.20.1669049757940;
        Mon, 21 Nov 2022 08:55:57 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g21-20020a056602151500b006c05ff4cd91sm4472975iow.35.2022.11.21.08.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 08:55:57 -0800 (PST)
Message-ID: <5c39ed45-4c0b-3ec7-decd-eb0fc1885591@kernel.dk>
Date:   Mon, 21 Nov 2022 09:55:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH for-next 09/10] io_uring: allow io_post_aux_cqe to defer
 completion
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221121100353.371865-1-dylany@meta.com>
 <20221121100353.371865-10-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121100353.371865-10-dylany@meta.com>
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

On 11/21/22 3:03 AM, Dylan Yudaken wrote:
> Use the just introduced deferred post cqe completion state when possible
> in io_post_aux_cqe.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>  io_uring/io_uring.c | 21 ++++++++++++++++++++-
>  io_uring/io_uring.h |  2 +-
>  io_uring/msg_ring.c | 10 ++++++----
>  io_uring/net.c      | 15 ++++++++-------
>  io_uring/poll.c     |  2 +-
>  io_uring/rsrc.c     |  4 ++--
>  6 files changed, 38 insertions(+), 16 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c797f9a75dfe..5c240d01278a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -845,11 +845,30 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
>  	state->cqes_count = 0;
>  }
>  
> -bool io_post_aux_cqe(struct io_ring_ctx *ctx,
> +bool io_post_aux_cqe(struct io_ring_ctx *ctx, bool defer,
>  		     u64 user_data, s32 res, u32 cflags)
>  {
>  	bool filled;
>  
> +	if (defer) {
> +		unsigned int length = ARRAY_SIZE(ctx->submit_state.cqes);
> +		struct io_uring_cqe *cqe;
> +
> +		lockdep_assert_held(&ctx->uring_lock);
> +
> +		if (ctx->submit_state.cqes_count == length) {
> +			io_cq_lock(ctx);
> +			__io_flush_post_cqes(ctx);
> +			/* no need to flush - flush is deferred */
> +			spin_unlock(&ctx->completion_lock);
> +		}
> +
> +		cqe  = ctx->submit_state.cqes + ctx->submit_state.cqes_count++;
> +		cqe->user_data = user_data;
> +		cqe->res = res;
> +		cqe->flags = cflags;
> +		return true;
> +	}
>  	io_cq_lock(ctx);
>  	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
>  	io_cq_unlock_post(ctx);

Seems like this would be cleaner with a separate helper and make that
decision in the caller. For the ones that just pass false that is
trivial of course, then just gate it on the locked nature of the ring in
the other spots?

-- 
Jens Axboe
