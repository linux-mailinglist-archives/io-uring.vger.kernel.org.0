Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC499401DE2
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 17:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243542AbhIFP6K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 11:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhIFP6J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 11:58:09 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A74EC061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 08:57:04 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i6so10513026wrv.2
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 08:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pgyrLlMnQZ+O22RVx7ecH7laHegZPTWxrJzxqIDUuTY=;
        b=mCvGfcdnAHTrjIKLoD5mrunMFQpkuBjb8f06hy1fS+djv+0QCED6eJFujH/2es9qxU
         rxc9CsU62mQ08/cexl/DPUCSe9QEh9gSfC5vXfqI0HJ5pxtQ7AXKhldoSplLTCIxdKWf
         6hala8iG2faskcvPKBxxC3LzKC1E5XkZXWECoMJDiQflKK0IeCc2NRhMzcqQzLCh0I6T
         dGdx/QG6yRrAKysv8HVOHzQ0kPpeIjmdsS0o2VxTnoHnGgYySNm7WRUUigDcBKI4u2vs
         vNwBYq2dtvy809urU5e1qyw1bNCuUF9sNLmT8Bc5l4cZqMq9rTHQz70ql05riF870PKi
         HicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgyrLlMnQZ+O22RVx7ecH7laHegZPTWxrJzxqIDUuTY=;
        b=bflNJiocKeQg3pYNuThH92griiawBGqMlV0oNyPA0PMtnRYoPcdIFC8+de2B56EfxA
         3RU1iTKX0wiIuKG0yU3S6dmFb3V8KQNWpAoFpef2YT+ZPiZ7HuojWF5lO9ZPytE5Ycbs
         6FHUAib/aVQ8xwwtOF9M/FRa8R5WXRRhvN3Op7ODt/JSV4oGyDTVu8kDY5mQs5Q+HVEf
         6XzuEM4eCTqIr5NSL7jahfC1XvqLupGINC4rkB07jk5BXddXC0ljDCDJieRI5ekRoAVY
         dBNVoRj5Cd0fLWDF4abfcMVOwf1WF4IUaj/YIyq3ES2VDvF4KnQWMzYEOl2eIuMbEHPX
         K1Nw==
X-Gm-Message-State: AOAM532iSyxcjXM1s9Bc/5X834KZeTLPYs3iY3rq0qjawrEGr+/zt7HK
        ppGJdFz1OqbGHidYj/J56uI=
X-Google-Smtp-Source: ABdhPJwRJ8M+iyDHy1m+BkKqEs9peEEMT/hFQLxHNpsI7Kzc+b36nSvcmgzNvnvAZGqoUUJNSB8xEQ==
X-Received: by 2002:adf:f0c7:: with SMTP id x7mr13202207wro.42.1630943823142;
        Mon, 06 Sep 2021 08:57:03 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id z5sm1836739wmf.33.2021.09.06.08.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 08:57:02 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
Message-ID: <b3ea4817-98d9-def8-d75e-9758ca7d1c33@gmail.com>
Date:   Mon, 6 Sep 2021 16:56:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-5-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 12:00 PM, Hao Xu wrote:
> For operations like accept, multishot is a useful feature, since we can
> reduce a number of accept sqe. Let's integrate it to fast poll, it may
> be good for other operations in the future.

__io_arm_poll_handler()         |
  -> vfs_poll()                 |
                                | io_async_task_func() // post CQE
                                | ...
                                | do_apoll_rewait();
  -> continues after vfs_poll(),|
     removing poll->head of     |
     the second poll attempt.   |


One of the reasons for forbidding multiple apoll's is that it
might be racy. I haven't looked into this implementation, but
we should check if there will be problems from that.

FWIW, putting aside this patchset, the poll/apoll is not in
the best shape and can use some refactoring.


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d6df60c4cdb9..dae7044e0c24 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>  		return;
>  	}
>  
> -	hash_del(&req->hash_node);
> -	io_poll_remove_double(req);
> +	if (READ_ONCE(apoll->poll.canceled))
> +		apoll->poll.events |= EPOLLONESHOT;
> +	if (apoll->poll.events & EPOLLONESHOT) {
> +		hash_del(&req->hash_node);
> +		io_poll_remove_double(req);
> +	} else {
> +		add_wait_queue(apoll->poll.head, &apoll->poll.wait);
> +	}
> +
>  	spin_unlock(&ctx->completion_lock);
>  
>  	if (!READ_ONCE(apoll->poll.canceled))
> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct async_poll *apoll;
>  	struct io_poll_table ipt;
> -	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
> +	__poll_t ret, mask = POLLERR | POLLPRI;
>  	int rw;
>  
>  	if (!req->file || !file_can_poll(req->file))
> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  		rw = WRITE;
>  		mask |= POLLOUT | POLLWRNORM;
>  	}
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
> +		mask |= EPOLLONESHOT;
>  
>  	/* if we can't nonblock try, then no point in arming a poll handler */
>  	if (!io_file_supports_nowait(req, rw))
> 

-- 
Pavel Begunkov
