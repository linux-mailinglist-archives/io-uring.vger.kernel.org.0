Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17403B0228
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhFVLCy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhFVLCy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:02:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA09C061574;
        Tue, 22 Jun 2021 04:00:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r7so22999033edv.12;
        Tue, 22 Jun 2021 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U6aYLg3rpzlIK65H4pgISZM5ejhhHKIKpr2biUGLgXE=;
        b=r8ue6W4Q+MltWbHnMxttMvROuFfMJJP3VT5LiYHph70cpYNZyNii6/nAnYQVOJ5AFV
         1wyzmhMxb4k+3GZPGzsvXoVPYggBQ72RqKugZUEEHy7RzGX0m88fn4ju/pcq88+ke93G
         v2L48NfY88scPvNR1iiuTaHAzeZdyMFeNmqjWTi1yT005PpW5Ck57FsefL1tH7RfUh7Z
         R2pzT+VDKQV+8aeLTjgnFOMVC6udXOXP5hrJvyOuUkWWqDYOGKQ2DG4KYba7N8LvGZLV
         5JsxiR8H8P+569Qy7BOxBeMYp3h3HpMG/2dRXluSx7BQJFEgJSgYMshcR+nSMyUGt7Sf
         ahwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U6aYLg3rpzlIK65H4pgISZM5ejhhHKIKpr2biUGLgXE=;
        b=rsGm4cXCO7D5jHie1Qr8OdSRQcI+/6ZKARx3NIrRHhOFxT+f6ggMDXBR9c7oypsvaa
         1mbFSnNLvhmrijgxIml+p9Y6ipnatARbYRkPaazYRlyqDCYWeusd5KrXyNGIxVCn/wxu
         29iHcUk7geRySOiXWcTOj5kBxCCNAaGVRsQXe3Zit9nqiEch24Q+07XwP6T60arAHV+l
         /FqPYm/PfT6/LfnTV2JTPmcYS5dk1lpWfo0QbKQqVk7QdlcqmFO4GKTQrUZTsVrflyEk
         IAKEFTXyH/BWSB8y9yV0A2jz6vy5tDUS50axzKjiWttZLxuPLs4i2Hjkn2kC58rHBlzT
         TPog==
X-Gm-Message-State: AOAM533h6LWnHGocC+/JJWfl1B9IfwKSOvDrHwETIO+6YCYI3dSujpJL
        S8NRTS4DYgPL9UgbpqBykI3/Gd9AcpJDUxib
X-Google-Smtp-Source: ABdhPJwOJkCWObOraOC1JFRU674J/LiYs8mfKRF77RXcLogBsxu7TYyGfqhX0AzpvRDmhJxMvK/YwA==
X-Received: by 2002:a05:6402:290b:: with SMTP id ee11mr3982768edb.325.1624359637040;
        Tue, 22 Jun 2021 04:00:37 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:c503])
        by smtp.gmail.com with ESMTPSA id s5sm12141285edi.93.2021.06.22.04.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:00:36 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4deda7761d61c189f4e2581828f852c8a1acb723.1624303174.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ab4e6bc7-e5f5-0c0d-9e03-1e490f1ad22a@gmail.com>
Date:   Tue, 22 Jun 2021 12:00:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4deda7761d61c189f4e2581828f852c8a1acb723.1624303174.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/21 8:22 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.

Looks good to me, will stamp later after testing it out.

 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc8637f591a6..5efa67c2f974 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5152,7 +5152,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>  	return mask;
>  }
>  
> -static bool io_arm_poll_handler(struct io_kiocb *req)
> +enum {
> +	IO_APOLL_OK,
> +	IO_APOLL_ABORTED,
> +	IO_APOLL_READY
> +};
> +
> +static int io_arm_poll_handler(struct io_kiocb *req)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -5162,22 +5168,22 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	int rw;
>  
>  	if (!req->file || !file_can_poll(req->file))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	if (req->flags & REQ_F_POLLED)
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	if (def->pollin)
>  		rw = READ;
>  	else if (def->pollout)
>  		rw = WRITE;
>  	else
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	/* if we can't nonblock try, then no point in arming a poll handler */
>  	if (!io_file_supports_async(req, rw))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  
>  	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
>  	if (unlikely(!apoll))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	apoll->double_poll = NULL;
>  
>  	req->flags |= REQ_F_POLLED;
> @@ -5203,12 +5209,14 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	if (ret || ipt.error) {
>  		io_poll_remove_double(req);
>  		spin_unlock_irq(&ctx->completion_lock);
> -		return false;
> +		if (ret)
> +			return IO_APOLL_READY;
> +		return IO_APOLL_ABORTED;
>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
>  	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
>  				mask, apoll->poll.events);
> -	return true;
> +	return IO_APOLL_OK;
>  }
>  
>  static bool __io_poll_remove_one(struct io_kiocb *req,
> @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>  	int ret;
>  
> +issue_sqe:
>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>  
>  	/*
> @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		switch (io_arm_poll_handler(req)) {
> +		case IO_APOLL_READY:
> +			goto issue_sqe;
> +		case IO_APOLL_ABORTED:
>  			/*
>  			 * Queued up for async execution, worker will release
>  			 * submit reference when the iocb is actually submitted.
>  			 */
>  			io_queue_async_work(req);
> +			break;
>  		}
>  	} else {
>  		io_req_complete_failed(req, ret);
> 

-- 
Pavel Begunkov
