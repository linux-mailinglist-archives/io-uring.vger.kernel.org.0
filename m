Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432453FF2F9
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346689AbhIBSFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhIBSFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:05:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792A1C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 11:04:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u9so4334195wrg.8
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NSeGX4nOpoqHcrEbj5hZwevbtiKFxcU8alNA4NVnABM=;
        b=d6/yiVp2xJ8KuNnAF27e2nZ1tciSPeQjBNY3l43MnWeBOUulGboSwIUICK5jmVJP95
         Fg+YreaFzOOZl73q+QmT0HzKzAFcP6MdEI8qKAttLW9w1OdhE12TdQCwFtRsfG9FxKX0
         P4pvGEe4F4WTGWFIyPS9Xp3F5+B50CWWlNyO1UqgYk03AbB9iE5YcjnMld5nSwWpf5zk
         AaLy4jFyM6ygOoYfLnciGazcTg86sNMS4Y9QPQ+QxUMu1/j71Seb4noyW6bs37EEgvhy
         jhTqtGzFE1MdtmRm1rBA8f7scmd68wL9Gyx+pbOzzkggRIYdNXk+HQnnKUnxHabVvhZa
         5DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NSeGX4nOpoqHcrEbj5hZwevbtiKFxcU8alNA4NVnABM=;
        b=gfVTrjr/6WbD861OTnGP6fleGsWBuMkx4an4fmBRmyHjrcs/S9sw/OxcYGnYYGBpnY
         ws9gxUNXGNQgOYIs7X/1ZzRnHCQm2Lk/Kjv9XLSShraFvheSzj270JiRuCgm7us9rykV
         VI1KrB7OZvVVbgNbfObzKX6JIXMuIso6K+cD6nhkndN3VaiKeYTGO4+e/LEHklvaTgmr
         3zFpHB2ZNjZ1TMV6iQ8Y1Z24D/BkASX1ahORQ17w+bXoJrZstk9qxm3N7pm8QT28MJR3
         jkSrWt7/CPeP9gkT4Tz2qBJQgReZKeZPW9nTOP4v7weQUgYbpUQ05ZTw3tZbeHBl2VyW
         6a3Q==
X-Gm-Message-State: AOAM533PSJ1Npv1XfN89hTnamvw2MhQ8i63osX8oyYpI4TsEcSycUKJN
        4+OeMUgPX24dauHQsNf25IGpqBg4hnM=
X-Google-Smtp-Source: ABdhPJwclS0G3m1p5qouFMLy+kSAWeuLDcysN2nGR3yyLQoPr2bDTGS6ob+z8tsO+ohILSkr+bQ4Bw==
X-Received: by 2002:adf:f943:: with SMTP id q3mr5529392wrr.118.1630605875906;
        Thu, 02 Sep 2021 11:04:35 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.203])
        by smtp.gmail.com with ESMTPSA id a5sm2221126wmm.44.2021.09.02.11.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:04:35 -0700 (PDT)
Subject: Re: [PATCH] io_uring: trigger worker exit when ring is exiting
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <045c35f3-fb30-8016-5a7e-fc0c26f2c400@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0a7dbae3-e48e-bf8c-1959-59195cad4bcf@gmail.com>
Date:   Thu, 2 Sep 2021 19:04:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <045c35f3-fb30-8016-5a7e-fc0c26f2c400@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 6:56 PM, Jens Axboe wrote:
> If a task exits normally, then the teardown of async workers happens
> quickly. But if it simply closes the ring fd, then the async teardown
> ends up waiting for workers to timeout if they are sleeping, which can
> then take up to 5 seconds (by default). This isn't a big issue as this
> happens off the workqueue path, but let's be nicer and ensure that we
> exit as quick as possible.

ring = io_uring_init();
...
io_uring_close(&ring); // triggers io_ring_ctx_wait_and_kill()
rint2 = io_uring_init();
...

It looks IO_WQ_BIT_EXIT there will be troublesome.

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index d80e4a735677..60cd841c6c57 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1130,7 +1130,17 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
>  
>  void io_wq_exit_start(struct io_wq *wq)
>  {
> +	int node;
> +
>  	set_bit(IO_WQ_BIT_EXIT, &wq->state);
> +
> +	rcu_read_lock();
> +	for_each_node(node) {
> +		struct io_wqe *wqe = wq->wqes[node];
> +
> +		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
> +	}
> +	rcu_read_unlock();
>  }
>  
>  static void io_wq_exit_workers(struct io_wq *wq)
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2bde732a1183..9936ebaa8180 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9158,6 +9158,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
>  
>  static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  {
> +	struct io_uring_task *tctx = current->io_uring;
>  	unsigned long index;
>  	struct creds *creds;
>  
> @@ -9175,6 +9176,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  	/* if we failed setting up the ctx, we might not have any rings */
>  	io_iopoll_try_reap_events(ctx);
>  
> +	/* trigger exit, if it hasn't been done already */
> +	if (tctx->io_wq)
> +		io_wq_exit_start(tctx->io_wq);
> +
>  	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
>  	/*
>  	 * Use system_unbound_wq to avoid spawning tons of event kworkers
> 

-- 
Pavel Begunkov
