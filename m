Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55E12E8865
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 21:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbhABUHw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 15:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbhABUHv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 15:07:51 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B60C061573
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 12:07:10 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q18so27067891wrn.1
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 12:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DUQZWQXr0LfkICtPEpx0uobnNwUm/byDpKUQ41TOlIU=;
        b=f8nTfzcrsf44tsHXlUVKwjTK3heDqzAuCK3e6LFKoI9anUcUE7Q1U3qGKV+zSzPQ3B
         /9JPIk6njp8zOEikGMIErhOp1yfoiE0anmEv9Yh0m1XBKPUUHObqp66mCIHIX6KTlC2Q
         iwnEz7eZm6+LPEk+ttZDRAqN7vq0C4SGb55zgJEARbTRqDVfkokjrsZ8RO+8BnCqr9QO
         iwa0Z6TFR7uRhdHku9JMHxOzIC/yc0LMwI8f7pDcyyYFTMm7gN9MZ3xueuPLg1Z6YSb/
         b4b4OdQJSz6ARMenwIiwBpGuAfZWUTZ3QWbcn9dEqEvPgFNKTlsKQ1CUMkrXCLI7+Ju9
         NWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DUQZWQXr0LfkICtPEpx0uobnNwUm/byDpKUQ41TOlIU=;
        b=XYO98phUW+Ej+sRB0Sfjtrksaw6BS4BgeWU06wWzbmt3Avkexv8NVawgSADlbzW1Z7
         JclGCbkTNjMTcDIuhnWf+kqd8Kk/AgiIk+PQhC84KV2lqX6WV73HjkLd9BI7c/bxBltd
         x3C0ElLz9b6jLgkkWCI8+2VPJTSTsZA6xW801PbD+IPLnOkPIzJ6RB7DkE+4RSTyjm1A
         c6u9uNu7mf911nYqvvLq023s4vdwX8jgwajJjryw+yvuh8Mn4/0lQ+6vEHWZj+QE9LBx
         FgCagEqN0k+ggihxhQvpUPqpundmErEDD0y3o9U3ikA/indbpqmqSMaXHpGU5EWsZAct
         p80g==
X-Gm-Message-State: AOAM531QnJEvrNZO9EqkHaUaevhcwv1bVTpiCZitPEeN58sQ0S1j4yDK
        JW6MwMsT0FDcN1q5XnORwB/8/3YSM8E=
X-Google-Smtp-Source: ABdhPJwsm4sBjiPimiulSrwN7PYFFF0bptn83Bz9RmbnfrHTm0oHuGm/NVbbGlM1brGYp2wSExIIlA==
X-Received: by 2002:a5d:504b:: with SMTP id h11mr73121697wrt.337.1609618029153;
        Sat, 02 Jan 2021 12:07:09 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id f77sm23144152wmf.42.2021.01.02.12.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 12:07:08 -0800 (PST)
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-2-marcelo827@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 1/2] io_uring: only increment ->cq_timeouts along with
 ->cached_cq_tail
Message-ID: <f06c14be-da77-6946-38ba-2ded59743f98@gmail.com>
Date:   Sat, 2 Jan 2021 20:03:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201219191521.82029-2-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
> The quantity ->cached_cq_tail - ->cq_timeouts is used to tell how many
> non-timeout events have happened, but this subtraction could overflow
> if ->cq_timeouts is incremented more times than ->cached_cq_tail.
> It's maybe unlikely, but currently this can happen if a timeout event
> overflows the cqring, since in that case io_get_cqring() doesn't
> increment ->cached_cq_tail, but ->cq_timeouts is incremented by the
> caller. Fix it by incrementing ->cq_timeouts inside io_get_cqring().
> 
> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> ---
>  fs/io_uring.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f3690dfdd564..f394bf358022 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1582,8 +1582,6 @@ static void io_kill_timeout(struct io_kiocb *req)
>  
>  	ret = hrtimer_try_to_cancel(&io->timer);
>  	if (ret != -1) {
> -		atomic_set(&req->ctx->cq_timeouts,
> -			atomic_read(&req->ctx->cq_timeouts) + 1);
>  		list_del_init(&req->timeout.list);
>  		io_cqring_fill_event(req, 0);
>  		io_put_req_deferred(req, 1);
> @@ -1664,7 +1662,7 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
>  	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
>  }
>  
> -static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
> +static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx, u8 opcode)
>  {
>  	struct io_rings *rings = ctx->rings;
>  	unsigned tail;
> @@ -1679,6 +1677,10 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
>  		return NULL;
>  
>  	ctx->cached_cq_tail++;
> +	if (opcode == IORING_OP_TIMEOUT)
> +		atomic_set(&ctx->cq_timeouts,
> +			   atomic_read(&ctx->cq_timeouts) + 1);
> +

Don't think I like it. The function is pretty hot, so wouldn't want that extra
burden just for timeouts, which should be cold enough especially with the new
timeout CQ waits. Also passing opcode here is awkward and not very great
abstraction wise.

>  	return &rings->cqes[tail & ctx->cq_mask];
>  }
>  
> @@ -1728,7 +1730,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
>  		if (!io_match_task(req, tsk, files))
>  			continue;
>  
> -		cqe = io_get_cqring(ctx);
> +		cqe = io_get_cqring(ctx, req->opcode);
>  		if (!cqe && !force)
>  			break;
>  
> @@ -1776,7 +1778,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>  	 * submission (by quite a lot). Increment the overflow count in
>  	 * the ring.
>  	 */
> -	cqe = io_get_cqring(ctx);
> +	cqe = io_get_cqring(ctx, req->opcode);
>  	if (likely(cqe)) {
>  		WRITE_ONCE(cqe->user_data, req->user_data);
>  		WRITE_ONCE(cqe->res, res);
> @@ -5618,8 +5620,6 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>  
>  	spin_lock_irqsave(&ctx->completion_lock, flags);
>  	list_del_init(&req->timeout.list);
> -	atomic_set(&req->ctx->cq_timeouts,
> -		atomic_read(&req->ctx->cq_timeouts) + 1);
>  
>  	io_cqring_fill_event(req, -ETIME);
>  	io_commit_cqring(ctx);
> 

-- 
Pavel Begunkov
