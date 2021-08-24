Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568053F5E7B
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhHXM7H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 08:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237320AbhHXM7F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 08:59:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FB8C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 05:58:21 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k8so31201317wrn.3
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 05:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s4vyx6bkn7c9UFXeT5ozdVKUozE6RZ6AkyXPRJlKrVw=;
        b=LyfIPS/MnTACAjAigEpbkSylMUNBoh1/0zK9ym4/CfVg7Kp9+Ra+0UBoDHbXl+VrPr
         RwC1c/knwB5NYWmO4fRrlmXPiDyMVM5UxUH0trjEITnUzxbTgh2fUdcMcNdolERVQjjn
         VLJRVP01F74Pa2iXQbqC90IXsujpRsWxC7y/Gvi7qouNwEAMwdOG5/UhFEabIx4iZtmZ
         4zKvnmtQYvNL0FiEe3OqUqeZUP5DCXGY6PY8WH5daAXXMI2MLHfhA/Ydp3BUPDgJfmw0
         bL4C+q+Xu512NrZJr3MoF2fItT2p4vnS5kSzZ9jimjPYl5pfegDE+B1KypYybriscwTN
         ++8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s4vyx6bkn7c9UFXeT5ozdVKUozE6RZ6AkyXPRJlKrVw=;
        b=TMnuM3yk35czWUgIPLRQI3QfgG24o7IteBbHRWaziolQM00E60Un6FCLTr3ejOUgi+
         kqYG5FyhHH2cHkTJY78Z49Kh0Ga3dDVCgK1PzILhITinOidSEsSyBQx81G9Ipm/fRMog
         CMva0my0U8AD25CVaTl62j1ID8D+ut+DpUj9xotPc5s4i1fHm4oiyAX5uoFBLq9yLpTa
         MOxFeztT82VJqwnrfGr+P0gu2yliUUNtzyR1OJZRCqPA8C5qGVSyX9MOR1zFzbH2BBX7
         FvjARhPBFoHW9oRdk9PWOEYCXrcPNLLjLU8f9O8SAL2zJL68r3LGWz/jiSz1vxtlDV/F
         YNTw==
X-Gm-Message-State: AOAM533ss+XdRSoCSeQH3Lr+WaWXAUjAZRrNBeUFHl3hU8CgMgSibZZS
        0a2cB5Iw/oh7b4glHvxkhpiBTaoVPj8=
X-Google-Smtp-Source: ABdhPJygUTiGyEplTULPjnq4e/Psb1IWxjqhW/k1MuQHXps5UkuuqGbd7MfQretlcRCjyMHttiwThw==
X-Received: by 2002:a5d:6d8f:: with SMTP id l15mr19541078wrs.42.1629809899898;
        Tue, 24 Aug 2021 05:58:19 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id r1sm1228490wmn.46.2021.08.24.05.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 05:58:19 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <20210823183648.163361-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: add irq completion work to the head of
 task_list
Message-ID: <50876fd1-9e8a-baf4-e76e-7232eaae45d9@gmail.com>
Date:   Tue, 24 Aug 2021 13:57:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210823183648.163361-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 7:36 PM, Hao Xu wrote:
> Now we have a lot of task_work users, some are just to complete a req
> and generate a cqe. Let's put the work at the head position of the
> task_list, so that it can be handled quickly and thus to reduce
> avg req latency. an explanatory case:
> 
> origin timeline:
>     submit_sqe-->irq-->add completion task_work
>     -->run heavy work0~n-->run completion task_work
> now timeline:
>     submit_sqe-->irq-->add completion task_work
>     -->run completion task_work-->run heavy work0~n

Might be good. There are not so many hot tw users:
poll, queuing linked requests, and the new IRQ. Could be
BPF in the future.

So, for the test case I'd think about some heavy-ish
submissions linked to your IRQ req. For instance,
keeping a large QD of 

read(IRQ-based) -> linked read_pipe(PAGE_SIZE);

and running it for a while, so they get completely
out of sync and tw works really mix up. It reads
from pipes size<=PAGE_SIZE, so it completes inline,
but the copy takes enough of time.

One thing is that Jens specifically wanted tw's to
be in FIFO order, where IRQ based will be in LIFO.
I don't think it's a real problem though, the
completion handler should be brief enough.

> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.h    |  9 +++++++++
>  fs/io_uring.c | 21 ++++++++++++---------
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 308af3928424..51b4408fd177 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -41,6 +41,15 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>  		list->last = node;
>  }
>  
> +static inline void wq_list_add_head(struct io_wq_work_node *node,
> +				    struct io_wq_work_list *list)
> +{
> +	node->next = list->first;
> +	list->first = node;
> +	if (!node->next)
> +		list->last = node;
> +}
> +
>  static inline void wq_list_add_tail(struct io_wq_work_node *node,
>  				    struct io_wq_work_list *list)
>  {
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8172f5f893ad..954cd8583945 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2050,7 +2050,7 @@ static void tctx_task_work(struct callback_head *cb)
>  	ctx_flush_and_put(ctx);
>  }
>  
> -static void io_req_task_work_add(struct io_kiocb *req)
> +static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
>  {
>  	struct task_struct *tsk = req->task;
>  	struct io_uring_task *tctx = tsk->io_uring;
> @@ -2062,7 +2062,10 @@ static void io_req_task_work_add(struct io_kiocb *req)
>  	WARN_ON_ONCE(!tctx);
>  
>  	spin_lock_irqsave(&tctx->task_lock, flags);
> -	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
> +	if (emergency)
> +		wq_list_add_head(&req->io_task_work.node, &tctx->task_list);
> +	else
> +		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>  	running = tctx->task_running;
>  	if (!running)
>  		tctx->task_running = true;
> @@ -2122,19 +2125,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>  {
>  	req->result = ret;
>  	req->io_task_work.func = io_req_task_cancel;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, true);
>  }
>  
>  static void io_req_task_queue(struct io_kiocb *req)
>  {
>  	req->io_task_work.func = io_req_task_submit;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>  }
>  
>  static void io_req_task_queue_reissue(struct io_kiocb *req)
>  {
>  	req->io_task_work.func = io_queue_async_work;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>  }
>  
>  static inline void io_queue_next(struct io_kiocb *req)
> @@ -2249,7 +2252,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
>  {
>  	if (req_ref_put_and_test(req)) {
>  		req->io_task_work.func = io_free_req;
> -		io_req_task_work_add(req);
> +		io_req_task_work_add(req, false);
>  	}
>  }
>  
> @@ -2564,7 +2567,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>  		return;
>  	req->result = res;
>  	req->io_task_work.func = io_req_task_complete;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, true);
>  }
>  
>  static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
> @@ -4881,7 +4884,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>  	 * of executing it. We can't safely execute it anyway, as we may not
>  	 * have the needed state needed for it anyway.
>  	 */
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>  	return 1;
>  }
>  
> @@ -6430,7 +6433,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>  	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>  
>  	req->io_task_work.func = io_req_task_link_timeout;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>  	return HRTIMER_NORESTART;
>  }
>  
> 

-- 
Pavel Begunkov
