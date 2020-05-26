Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456551E1C64
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgEZHj6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 03:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgEZHj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 03:39:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F323C061A0E;
        Tue, 26 May 2020 00:39:56 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id nr22so6370690ejb.6;
        Tue, 26 May 2020 00:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=skSMG6X/+WKS/bVjBD77N/pFg3Dhya72NQQT1usQTkk=;
        b=Mi+k/GZUtchNwfVbDjUj5E6CPwy77us5bbXMOw/Pkj6VWDfYfTspLOncUddCoSIYaH
         pmmZ/9gfhbnmzM1leOIddqbtvWeToj1tPpROZ/ENqcE44yayPWuIfKtsfFvYKOoMVKFt
         mK/ahUpkcgY3+DrPqdpYVfUOqwyvuPRSxBh8IpFelFruARbsAcCGIobFNe3iKXvQg+6G
         BJv8Q439LSstmfG9FIR8F9X+ubttsxFMuPX4SGge7w6uUZdy/PffZyL/VY1clQuiVg67
         WZdVu8NnINm7TU+56VqIDTNvCfcQ5V+1slAm4CCWyTcHWME1fuSr8p7bJw3B/gOUlv/G
         o4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=skSMG6X/+WKS/bVjBD77N/pFg3Dhya72NQQT1usQTkk=;
        b=nL7+hVwz7aDR2N8VkCt4+V6sY30UQcJL3othzFi6adfnxhfiJfZRYke6LfNJwkiYy2
         kXRJLti2ruvg9JBp9T9XjVfsjJM42sYMdyRDRaBx7YRiXFVmGSYC5xABO7tvBRym0iSI
         FuSqNs/dgGeVp6xpa8AGYy2cypylOeatzbqqicFWNWAjYipxY14hC7f2jMyf5xH4Db/6
         UURoFBEtGQFborXgUpq3c0ckI9Cr6zG5fbfqCC/D0CCuAldyJ6b5WyHcVXx48xDjtN71
         2qsCzx3LD8lTxIo3+xxsg4/i/YUSdEDydYDBl0vK4E17RSirzSEQWiifS/4a8DK4cTE/
         AXfg==
X-Gm-Message-State: AOAM533OjZvUQxPYtnobZHDhPC6LReo8u5lge+fs6NslXfiKnWv2rI+g
        tnWV5zl4liQ652pU0XqcflQ=
X-Google-Smtp-Source: ABdhPJyUJQLtuoRKDJxESdd3vHZdvtsDMFogWIKBb4hMwDgxOG2+203wQ3t2VB/jPhNDJPuV2D0NAA==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr1675ejp.113.1590478795067;
        Tue, 26 May 2020 00:39:55 -0700 (PDT)
Received: from [192.168.43.172] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id y17sm17471500edo.23.2020.05.26.00.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 00:39:54 -0700 (PDT)
Subject: Re: [PATCH 12/12] io_uring: support true async buffered reads, if
 file provides it
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
 <20200523185755.8494-13-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9c2cc031-e4ce-4c5f-5e14-21ea48c327f6@gmail.com>
Date:   Tue, 26 May 2020 10:38:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200523185755.8494-13-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/05/2020 21:57, Jens Axboe wrote:
> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
> the buffered read to an io-wq worker. Instead we can rely on page
> unlocking callbacks to support retry based async IO. This is a lot more
> efficient than doing async thread offload.
> 
> The retry is done similarly to how we handle poll based retry. From
> the unlock callback, we simply queue the retry to a task_work based
> handler.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e95481c552ff..dd532d2634c2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -498,6 +498,8 @@ struct io_async_rw {
>  	struct iovec			*iov;
>  	ssize_t				nr_segs;
>  	ssize_t				size;
> +	struct wait_page_queue		wpq;
> +	struct callback_head		task_work;
>  };
>  
>  struct io_async_ctx {
> @@ -2568,6 +2570,99 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	return 0;
>  }
>  
> +static void io_async_buf_cancel(struct callback_head *cb)
> +{
> +	struct io_async_rw *rw;
> +	struct io_ring_ctx *ctx;
> +	struct io_kiocb *req;
> +
> +	rw = container_of(cb, struct io_async_rw, task_work);
> +	req = rw->wpq.wait.private;
> +	ctx = req->ctx;
> +
> +	spin_lock_irq(&ctx->completion_lock);
> +	io_cqring_fill_event(req, -ECANCELED);

It seems like it should go through kiocb_done()/io_complete_rw_common().
My concern is missing io_put_kbuf().

> +	io_commit_cqring(ctx);
> +	spin_unlock_irq(&ctx->completion_lock);
> +
> +	io_cqring_ev_posted(ctx);
> +	req_set_fail_links(req);
> +	io_double_put_req(req);
> +}


-- 
Pavel Begunkov
