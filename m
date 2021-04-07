Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222FA356B7C
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbhDGLqF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhDGLqE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:46:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63309C061756
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 04:45:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x15so8428110wrq.3
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 04:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z7tUE3Of+DTxza1gF2XQ4dgAH4PAsi/Dw9bCthgW9u4=;
        b=UBjbZvC8ZCKE3n9zWUspEF8gsSEBhS4fLaLzbM707U0PPtxdWK74gIYcC+Y9wjBhca
         NKtMI30RkZFtgc2cY6s/q605FaOsITFs2cThdfI7GVIeKzkFWnBty6F7xafnLlKDVbLw
         SWd8M4rxT9NwiM2sj4O04aUfGt8SQ14cVp80co9Sjhg9h2nXCV0DT84HwqFmGsBdj/YN
         9yTz99ehk8GvLU8LnwYa6f8RaB+pZB+1xNHGga6JepChjgk91I4egZd1zW4dYgN0N+vy
         kXB0oXlwwzzA7lMQ3gviNItIcVkjbSGIQpmu3RtkowBhNtDono6eQ/qDzxw/LVE0BUUK
         EaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=z7tUE3Of+DTxza1gF2XQ4dgAH4PAsi/Dw9bCthgW9u4=;
        b=ngsD1mRIV3j5KTHUsi45kMSJvDC3m5olgc4kSHanKtODl29Cnj0gkMV/nAmLrcFtEQ
         8lx+1yxuaiqWPqrN8opsmWCh1VgC+tGgWdpx+GFrezBm1SN2pwjgOjJklcuWHTARUhir
         +pW5eOXsZjwbBAp70Tk3d2tsqsaeIiNzYa45TlMI9R5T0ICGCqnIGYjzgwqZcFyPWk5O
         jRD1Ap7YpgDd2H2t70ZIRHkdUIBgqed/8RZdmYzgLRAsqYpzVgA20x7BsoLQRJPGJLCj
         nCBk24frOLX/QYJg6+6ABkppFlNS81nYqFiwJLk7y0c2vpWK44SSOkF4DOnrql6rKOcS
         dZ5Q==
X-Gm-Message-State: AOAM532/idThs9yCUhjTtsgrJvlwMk2/reNsAmJVDExv7EW/yUsEkBOL
        CQQ7pkhyXcPE8CjbjcWDp5Q=
X-Google-Smtp-Source: ABdhPJwyC8MATpkvMYIST2ihhI0XtU1SqBr9x5vPK5RZjX1f+OGFTTIIfCRLfUyGp+zE+7m4Ao0W/g==
X-Received: by 2002:a5d:6c62:: with SMTP id r2mr4115411wrz.62.1617795954173;
        Wed, 07 Apr 2021 04:45:54 -0700 (PDT)
Received: from [192.168.8.145] ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id p17sm8081510wmg.5.2021.04.07.04.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 04:45:53 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: maintain drain logic for multishot requests
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <1617794605-35748-3-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4d6f9688-4a8b-5fc6-f965-4903b5b82074@gmail.com>
Date:   Wed, 7 Apr 2021 12:41:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1617794605-35748-3-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/04/2021 12:23, Hao Xu wrote:
> Now that we have multishot poll requests, one sqe can emit multiple
> cqes. given below example:
>     sqe0(multishot poll)-->sqe1-->sqe2(drain req)
> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
> is a multishot poll request, sqe2 may be issued after sqe0's event
> triggered twice before sqe1 completed. This isn't what users leverage
> drain requests for.
> Here a simple solution is to ignore all multishot poll cqes, which means
> drain requests won't wait those request to be done.
> To achieve this, we should reconsider the req_need_defer equation, the
> original one is:
> 
>     all_sqes(excluding dropped ones) == all_cqes(including dropped ones)
> 
> this means we issue a drain request when all the previous submitted
> sqes have generated their cqes.
> Now we should ignore multishot requests, so:
>     all_sqes - multishot_sqes == all_cqes - multishot_cqes ==>
>     all_sqes + multishot_cqes - multishot_cqes == all_cqes
> 
> Thus we have to track the submittion of a multishot request and the cqes
> generation of it, including the ECANCELLED cqes. Here we introduce
> cq_extra = multishot_cqes - multishot_cqes for it.
> 
> There are other solutions like:
>   - just track multishot (non-ECNCELLED)cqes, don't track multishot sqes.
>       this way we include multishot sqes in the left end of the equation
>       this means we have to see multishot sqes as normal ones, then we
>       have to keep right one cqe for each multishot sqe. It's hard to do
>       this since there may be some multishot sqes which triggered
>       several events and then was cancelled, meanwhile other multishot
>       sqes just triggered events but wasn't cancelled. We still need to
>       track number of multishot sqes that haven't been cancelled, which
>       make things complicated
> 
> For implementations, just do the submittion tracking in
> io_submit_sqe() --> io_init_req() to make things simple. Otherwise if
> we do it in per opcode issue place, then we need to carefully consider
> each caller of io_req_complete_failed() because trick cases like cancel
> multishot reqs in link.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 192463bb977a..a7bd223ce2cc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -423,6 +423,7 @@ struct io_ring_ctx {
>  		unsigned		cq_mask;
>  		atomic_t		cq_timeouts;
>  		unsigned		cq_last_tm_flush;
> +		unsigned		cq_extra;
>  		unsigned long		cq_check_overflow;
>  		struct wait_queue_head	cq_wait;
>  		struct fasync_struct	*cq_fasync;
> @@ -879,6 +880,8 @@ struct io_op_def {
>  	unsigned		needs_async_setup : 1;
>  	/* should block plug */
>  	unsigned		plug : 1;
> +	/* set if opcode may generate multiple cqes */
> +	unsigned		multi_cqes : 1;
>  	/* size of async data needed, if any */
>  	unsigned short		async_size;
>  };
> @@ -924,6 +927,7 @@ struct io_op_def {
>  	[IORING_OP_POLL_ADD] = {
>  		.needs_file		= 1,
>  		.unbound_nonreg_file	= 1,
> +		.multi_cqes		= 1,
>  	},
>  	[IORING_OP_POLL_REMOVE] = {},
>  	[IORING_OP_SYNC_FILE_RANGE] = {
> @@ -1186,7 +1190,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>  	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>  		struct io_ring_ctx *ctx = req->ctx;
>  
> -		return seq != ctx->cached_cq_tail
> +		return seq + ctx->cq_extra != ctx->cached_cq_tail
>  				+ READ_ONCE(ctx->cached_cq_overflow);
>  	}
>  
> @@ -1516,6 +1520,9 @@ static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
>  
>  	trace_io_uring_complete(ctx, req->user_data, res, cflags);
>  
> +	if (req->flags & REQ_F_MULTI_CQES)
> +		req->ctx->cq_extra++;
> +


Here we go, additional overhead burdening everyone but used for
a little new feature. All that can be done in poll or in *_prep()
on opcode by opcode basis.

>  	/*
>  	 * If we can't get a cq entry, userspace overflowed the
>  	 * submission (by quite a lot). Increment the overflow count in
> @@ -6504,6 +6511,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	req->result = 0;
>  	req->work.creds = NULL;
>  
> +	if (sqe_flags & IOSQE_MULTI_CQES) {
> +		ctx->cq_extra--;
> +		if (!io_op_defs[req->opcode].multi_cqes) {
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +

see above

>  	/* enforce forwards compatibility on users */
>  	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>  		req->flags = 0;
> 

-- 
Pavel Begunkov
