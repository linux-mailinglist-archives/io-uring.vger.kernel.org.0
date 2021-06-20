Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0766C3AE01C
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 21:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhFTT6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 15:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhFTT6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 15:58:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376BCC061574;
        Sun, 20 Jun 2021 12:56:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m3so9043277wms.4;
        Sun, 20 Jun 2021 12:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZryyT0HWRM0dOmzL4ADJOpit6XxJrpxMO5spYCSH/pc=;
        b=ZEldtTJkgOZhfUXxFpr+1e+Rb/Fs37YtM7KDEAnelicz9v49PLa1Ca/O7ieidu/eF4
         DIWTXjGijm5JtM7Z3e4kh9Q6qUy+3Fkh+oSZvka4xS8f441grSpb57BGWa0v4XsIcGK3
         tlS1V/4oEaaXdlpIBuUB3RSM56mgMA4+SNd9WqpwoRNbbNT7/fL2VvYYUBF1DjfNo/2j
         1mG0Po9Vkgu4OG6MI+kGyUEasRsVjWGIyDjm6Wh26zJrKbszUKCsrjwlayc1NBwkJ+Z6
         M/b3qma6ITonSqZM7e3BXDgArpntU3rTpeGPz1iGYgod0tYO0DIJHbV8ZV15pNCJ29uz
         Qg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZryyT0HWRM0dOmzL4ADJOpit6XxJrpxMO5spYCSH/pc=;
        b=AH5MUcYDBqraXH2iWfmryY6b+ck+i7bnp6fIl1E3ZaQh70t9w/rcgdr4Kv8BdRJU3x
         IgIYeXuoRu9+zr750KK8pKJvg+x7xHbl/72lCiQbvmHg+/M8DE/TClieYucxLgEvpK0g
         h+6YBeDr+4PVrIBKkhyo5UU4ek9nbTaecgZMMk22LNJWe7wLHJee+jlRF4czbIyTneYL
         4V+QQcWglf31f/4bXmKcYHNhftg5Bie/S/QmujXLg9IgJkLIEkiL9b7Fn2S1J7LEXoXP
         21FVW/lbyQbzAZKu3VYDNu8F9WnBPDdtICN/g7bV0PT2UPkMRV3qbNNl9IuRYg3c4Rs3
         bv4Q==
X-Gm-Message-State: AOAM531KLWNzOOT+3WVU3nmmWco+lGNoRTaglC3xVxtHiU3PdOIbmLuI
        PCJKk7NqxUfdsZ2jmbRU8FkFsSdEimPcLw==
X-Google-Smtp-Source: ABdhPJzHDsNL+HrdWptOaWSkokuFrZcR1p/dUhCV+ZN1nkxKkKXrL74XLfpmDlYMrBrUZwcEQkhXvQ==
X-Received: by 2002:a1c:43c3:: with SMTP id q186mr5697931wma.44.1624218978603;
        Sun, 20 Jun 2021 12:56:18 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id g17sm19679172wrh.72.2021.06.20.12.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 12:56:18 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
Message-ID: <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
Date:   Sun, 20 Jun 2021 20:56:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 8:05 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fa8794c61af7..6e037304429a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5143,7 +5143,10 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>  	return mask;
>  }
>  
> -static bool io_arm_poll_handler(struct io_kiocb *req)
> +#define IO_ARM_POLL_OK    0
> +#define IO_ARM_POLL_ERR   1
> +#define IO_ARM_POLL_READY 2

Please add a new line here. Can even be moved somewhere
to the top, but it's a matter of taste.

Also, how about to rename it to apoll? io_uring internal
rw/send/recv polling is often abbreviated as such around
io_uring.c
IO_APOLL_OK and so on.

> +static int io_arm_poll_handler(struct io_kiocb *req)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -5153,22 +5156,22 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	int rw;
>  
>  	if (!req->file || !file_can_poll(req->file))
> -		return false;
> +		return IO_ARM_POLL_ERR;

It's not really an error. Maybe IO_APOLL_ABORTED or so?

>  	if (req->flags & REQ_F_POLLED)
> -		return false;
> +		return IO_ARM_POLL_ERR;
>  	if (def->pollin)
>  		rw = READ;
>  	else if (def->pollout)
>  		rw = WRITE;
>  	else
> -		return false;
> +		return IO_ARM_POLL_ERR;
>  	/* if we can't nonblock try, then no point in arming a poll handler */
>  	if (!io_file_supports_async(req, rw))
> -		return false;
> +		return IO_ARM_POLL_ERR;
>  
>  	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
>  	if (unlikely(!apoll))
> -		return false;
> +		return IO_ARM_POLL_ERR;
>  	apoll->double_poll = NULL;
>  
>  	req->flags |= REQ_F_POLLED;
> @@ -5194,12 +5197,12 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	if (ret || ipt.error) {
>  		io_poll_remove_double(req);
>  		spin_unlock_irq(&ctx->completion_lock);
> -		return false;
> +		return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;

spaces would be great.

>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
>  	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
>  					apoll->poll.events);
> -	return true;
> +	return IO_ARM_POLL_OK;
>  }
>  
>  static bool __io_poll_remove_one(struct io_kiocb *req,
> @@ -6416,6 +6419,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>  	int ret;
>  
> +issue_sqe:
>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>  
>  	/*
> @@ -6435,12 +6439,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		switch (io_arm_poll_handler(req)) {
> +		case IO_ARM_POLL_READY:
> +			goto issue_sqe;

Checked assembly, the fast path looks ok (i.e. not affected).
Also, a note, linked_timeout is handled correctly.

> +		case IO_ARM_POLL_ERR:
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
