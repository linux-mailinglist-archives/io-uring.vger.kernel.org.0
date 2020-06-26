Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2A20BA4F
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 22:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFZU2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 16:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZU2o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 16:28:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD14AC03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:28:43 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so10521224wmh.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzNzysL2EFC7dAfHGPo4H7eYL0vOnd0QBCXdqhqZg14=;
        b=tNoaCBNm0jknaszha9cIFM4F7uALHP2ZxGZHwYyNyU2PN2cV4ikp1BgjIWizE8Q4JC
         qsHysNdKmN0HEAHUmOzQTayhWh5/jjNLgIWHVbfYjUptTElrHPpKvmOqQLOWhGFiAHNM
         EgYlAwyhvrz41slagBKqyIq+XxK+UgbGUUDwVnd2+K3K9SoiGUWucGCzA9hDKGmxGzWD
         qWVfOQDhugJPCcZGrvHt6IuoRvsZKJFD7G4YmCvgcQveRgR6OyHHGIaekMJlfQUCqZzC
         Fp0ZfsiC+YvToeEMAxHPPTl85mu+i7mLNmNmduAGUBeDjNkvRoQlO+akkwsuLCfRXdTG
         1HXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzNzysL2EFC7dAfHGPo4H7eYL0vOnd0QBCXdqhqZg14=;
        b=WRYPoVXOH4zEmrn1JZSsynUu5D0qYkgVI8vdd3nIYogeLb5MjBKEwxgQsTqJY1qphc
         AgPUTtuwoWMmTN7SSbgA6inlfqcUXRrs9/IhBx3VO714luR6I8x5T0wiLR5N0PvwKKqb
         4hJ+bXd/H6H2gyvOWMPPlEI+3d2ogd1Yy9cgMDVsa/JV6EII58pzev8L5Mrl3Hp/UCPD
         UIPEdxlglvTWUnDBZV7yxYQAOo3RN5erM/Q14mKLLh9X5bOcz95jpNaWdJZIu0o9UW00
         NI1yEJzodO4YQiDAAfCzlGfX3U8aPgj2nzG9j1hsT6YVK8FFdW6z21KQPp+XkLMaF9/r
         Inrw==
X-Gm-Message-State: AOAM531iTCqhPuUZiYy+1S/2qUn0VuVoHExKiwWyYLexHQFJ67No/P6r
        e3FSWGohOb/B1WVwYwhOAN+QhPIM
X-Google-Smtp-Source: ABdhPJwkCweN99LRSb6x8xV2EiHdZM7Tje1wlCuc+9PUkaTuT/vogrtphpuZdEuW+Mp2SgsXGkjNfw==
X-Received: by 2002:a05:600c:21ca:: with SMTP id x10mr5167715wmj.63.1593203322224;
        Fri, 26 Jun 2020 13:28:42 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id d13sm22984573wrn.61.2020.06.26.13.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 13:28:41 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: use task_work for links if possible
Message-ID: <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
Date:   Fri, 26 Jun 2020 23:27:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/06/2020 21:27, Jens Axboe wrote:
> Currently links are always done in an async fashion, unless we
> catch them inline after we successfully complete a request without
> having to resort to blocking. This isn't necessarily the most efficient
> approach, it'd be more ideal if we could just use the task_work handling
> for this.
> 
> Outside of saving an async jump, we can also do less prep work for
> these kinds of requests.
> 
> Running dependent links from the task_work handler yields some nice
> performance benefits. As an example, examples/link-cp from the liburing
> repository uses read+write links to implement a copy operation. Without
> this patch, the a cache fold 4G file read from a VM runs in about
> 3 seconds:

A few comments below


> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0bba12e4e559..389274a078c8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -898,6 +898,7 @@ enum io_mem_account {
...
> +static void __io_req_task_submit(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	__set_current_state(TASK_RUNNING);
> +	if (!io_sq_thread_acquire_mm(ctx, req)) {
> +		mutex_lock(&ctx->uring_lock);
> +		__io_queue_sqe(req, NULL, NULL);
> +		mutex_unlock(&ctx->uring_lock);
> +	} else {
> +		__io_req_task_cancel(req, -EFAULT);
> +	}
> +}
> +
> +static void io_req_task_submit(struct callback_head *cb)
> +{
> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +
> +	__io_req_task_submit(req);
> +}
> +
> +static void io_req_task_queue(struct io_kiocb *req)
> +{
> +	struct task_struct *tsk = req->task;
> +	int ret;
> +
> +	init_task_work(&req->task_work, io_req_task_submit);
> +
> +	ret = task_work_add(tsk, &req->task_work, true);
> +	if (unlikely(ret)) {
> +		init_task_work(&req->task_work, io_req_task_cancel);

Why not to kill it off here? It just was nxt, so shouldn't anything like
NOCANCEL

> +		tsk = io_wq_get_task(req->ctx->io_wq);
> +		task_work_add(tsk, &req->task_work, true);
> +	}
> +	wake_up_process(tsk);
> +}
> +
>  static void io_free_req(struct io_kiocb *req)
>  {
>  	struct io_kiocb *nxt = NULL;
> @@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
>  	io_req_find_next(req, &nxt);
>  	__io_free_req(req);
>  
> -	if (nxt)
> -		io_queue_async_work(nxt);
> +	if (nxt) {
> +		if (nxt->flags & REQ_F_WORK_INITIALIZED)
> +			io_queue_async_work(nxt);

Don't think it will work. E.g. io_close_prep() may have set
REQ_F_WORK_INITIALIZED but without io_req_work_grab_env().

> +		else
> +			io_req_task_queue(nxt);
> +	}
>  }
>  
>  static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
> @@ -2013,12 +2104,6 @@ static void kiocb_end_write(struct io_kiocb *req)
>  	file_end_write(req->file);
>  }
>  
> -static inline void req_set_fail_links(struct io_kiocb *req)
> -{
> -	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
> -		req->flags |= REQ_F_FAIL_LINK;
> -}
> -

I think it'd be nicer in 2 patches, first moving io_sq_thread_drop_mm, etc. up.
And the second one doing actual work. 

>  static void io_complete_rw_common(struct kiocb *kiocb, long res,
>  				  struct io_comp_state *cs)
>  {
> @@ -2035,35 +2120,6 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
>  	__io_req_complete(req, res, cflags, cs);
>  }
>  
...
>  	switch (req->opcode) {
>  	case IORING_OP_NOP:
> @@ -5347,7 +5382,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (!req->io) {
>  		if (io_alloc_async_ctx(req))
>  			return -EAGAIN;
> -		ret = io_req_defer_prep(req, sqe);
> +		ret = io_req_defer_prep(req, sqe, true);

Why head of a link is for_async?

>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -5966,7 +6001,7 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			ret = -EAGAIN;
>  			if (io_alloc_async_ctx(req))
>  				goto fail_req;
> -			ret = io_req_defer_prep(req, sqe);
> +			ret = io_req_defer_prep(req, sqe, true);
>  			if (unlikely(ret < 0))
>  				goto fail_req;
>  		}
> @@ -6022,13 +6057,14 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		if (io_alloc_async_ctx(req))
>  			return -EAGAIN;
>  
> -		ret = io_req_defer_prep(req, sqe);
> +		ret = io_req_defer_prep(req, sqe, false);
>  		if (ret) {
>  			/* fail even hard links since we don't submit */
>  			head->flags |= REQ_F_FAIL_LINK;
>  			return ret;
>  		}
>  		trace_io_uring_link(ctx, req, head);
> +		io_get_req_task(req);
>  		list_add_tail(&req->link_list, &head->link_list);
>  
>  		/* last request of a link, enqueue the link */
> @@ -6048,7 +6084,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			if (io_alloc_async_ctx(req))
>  				return -EAGAIN;
>  
> -			ret = io_req_defer_prep(req, sqe);
> +			ret = io_req_defer_prep(req, sqe, true);
>  			if (ret)
>  				req->flags |= REQ_F_FAIL_LINK;
>  			*link = req;
> 

-- 
Pavel Begunkov
