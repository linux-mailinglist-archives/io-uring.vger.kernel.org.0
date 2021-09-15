Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641A640C2E7
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 11:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhIOJqV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 05:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhIOJqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 05:46:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA1C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:45:01 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b6so2828261wrh.10
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1GKjrebQ6GDqSCyBbuTbQ1fuwG2T3c7dzDkDzDfGqb8=;
        b=ib8aK1QnQl7M5tzxRJoImUyWG1JqQoU/H1k92+I+Cx04HW+B38H4kvJsGWHp0V/HdK
         sGCIP7UowaRvcEW5AM7vCK7fGxhuaZ+fUn0Mh9dDqKVUaU9JJMNklex4nk73I5AtX14F
         Y66fUrlrBCRKUtWmg47nKJV51p9XtjSE/ZRYuk5Fv5HXzHEJ6QKylLubeF2djQRL6xW5
         gSXQ0RxBnZeyq4QFdfK+6GuoNNmp0UKAX7BiDUzkFjaUU8L+VgYuxv2OYNc0fzPhBf/R
         49JdHvHJCxYJKhqnSiubdBIYyjnJT44joHdbTQURvd/yGebtIhm+mB6LAqIZYKW5Ro0Z
         UrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1GKjrebQ6GDqSCyBbuTbQ1fuwG2T3c7dzDkDzDfGqb8=;
        b=48JmqYk5jDrMp+GCk54195PYA/ab+ZdYTEUHiXVWZkpueNBDZJ0GfTFxg8JoXGPfXs
         ZkOA+872WnixjjkXBuzcS0RLaKI2K3ZZCYZETAKOf3w258oj9KA7t3JQBcZVCWw3i0In
         Z3AQl20ij9Y7gIgnF/qwTXyQxh3k85AdDT2eK58Nbuzh8XxZPFH5TRI2kHZvGmAOISk5
         qIo/0xBcGfYq8xd6Kg8rPRw55WutkoL+5dBCPA2dmAVDuDbUkMSJyLY29SuitW/IfHWq
         4kFe3y6ua7XH3Wfsje4fLRlmf5UuYIeAXrqAys71EDRycQmKzpA6uSvUiuaJEb+Nv13Q
         e8CA==
X-Gm-Message-State: AOAM5328bIRXwBfVltiiebarvDnD+Nf8fn1/gDwYRKVmgtcDaZsTDHob
        Zd+hjE2WdgdVQhwhlpoe9+Qc7qoeKh4=
X-Google-Smtp-Source: ABdhPJxoZirVDcy53BYTGuVq/54r7tSpzXENokA0NIdbnW1QtsrX6R2pN1M88BO/304qqYJ070TBzQ==
X-Received: by 2002:adf:e30d:: with SMTP id b13mr3941428wrj.438.1631699099651;
        Wed, 15 Sep 2021 02:44:59 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id m3sm16936572wrg.45.2021.09.15.02.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 02:44:59 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: fix tw list mess-up by adding tw while it's
 already in tw list
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6b9d818b-468e-e409-8dc1-9d4bd586635e@gmail.com>
Date:   Wed, 15 Sep 2021 10:44:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912162345.51651-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 5:23 PM, Hao Xu wrote:
> For multishot mode, there may be cases like:
> io_poll_task_func()
> -> add_wait_queue()
>                             async_wake()
>                             ->io_req_task_work_add()
>                             this one mess up the running task_work list
>                             since req->io_task_work.node is in use.
> 
> similar situation for req->io_task_work.fallback_node.
> Fix it by set node->next = NULL before we run the tw, so that when we
> add req back to the wait queue in middle of tw running, we can safely
> re-add it to the tw list.

It may get screwed before we get to "node->next = NULL;",

-> async_wake()
  -> io_req_task_work_add()
-> async_wake()
  -> io_req_task_work_add()
tctx_task_work()


> Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
>  fs/io_uring.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 30d959416eba..c16f6be3d46b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1216,13 +1216,17 @@ static void io_fallback_req_func(struct work_struct *work)
>  	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
>  						fallback_work.work);
>  	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
> -	struct io_kiocb *req, *tmp;
> +	struct io_kiocb *req;
>  	bool locked = false;
>  
>  	percpu_ref_get(&ctx->refs);
> -	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
> +	req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
> +	while (member_address_is_nonnull(req, io_task_work.fallback_node)) {
> +		node = req->io_task_work.fallback_node.next;
> +		req->io_task_work.fallback_node.next = NULL;
>  		req->io_task_work.func(req, &locked);
> -
> +		req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
> +	}
>  	if (locked) {
>  		if (ctx->submit_state.compl_nr)
>  			io_submit_flush_completions(ctx);
> @@ -2126,6 +2130,7 @@ static void tctx_task_work(struct callback_head *cb)
>  				locked = mutex_trylock(&ctx->uring_lock);
>  				percpu_ref_get(&ctx->refs);
>  			}
> +			node->next = NULL;
>  			req->io_task_work.func(req, &locked);
>  			node = next;
>  		} while (node);
> 

-- 
Pavel Begunkov
