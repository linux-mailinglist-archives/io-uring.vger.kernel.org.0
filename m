Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAB20BA74
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFZUnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 16:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUnz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 16:43:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616FC03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:43:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 207so4926014pfu.3
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xOAoJLygQqIqjKkvwDYkfHAQCmid0pmE5Xtj9X1NVgI=;
        b=iirsfZNh1qJE2CSXRVJ/bLZ1as+3jlUkEaCRHqE1xboYXj/ct+t6lPtWtqslqZcjwe
         L4qfwbjRLNeuFUxQZ1Ge59qp/Fmd3hepy4TqBmWMNqBQSOT88x9OpYVdHF7zf85TCoQZ
         F3MTrDceqlXC9CqMoI2B31PG3j+tPd0F1QeWo1SgUz02V2eUy3LY3GWT68r/EhsKQwe3
         MTHJLQaRKo1Ol2LcsuHb7gjV3tmBPxwkSGyvnU0/i/tPIhhhySpZ6fd7FXP/Kk0SlV6P
         mpV7Ar+3xgZlRUOQzDvn4FxDJQoAR4poU1WGoWkHMTSNwBYabTe3h9zEgrYlTxUpjmud
         4dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xOAoJLygQqIqjKkvwDYkfHAQCmid0pmE5Xtj9X1NVgI=;
        b=p9rElPOxIjEmxdX9X3eXE6GCf+ppDWuFcF9q4yLgxQ8GlATWanJcH/7u6IVrjx6w4L
         lzW7jaDMTk/BeJLhXC1UdAg200D6rOwNz316YXMrQyMvQxwvydUfo7L+FtH4U2lp1h5L
         JbPqzomKBcYKp/JVMiL9sLNZz1I1RyRq+9Lb1Y7xt7eRcT2pzs579PrD+/HIol2+1oFz
         I2+i06nUKQWSwYXG7KD2aS88wpopsHeu9kVo41K6nlCg5JsusW7VadZtTcHcNOFQfmcF
         MsHl8AzWPEQ+d8GRq+ixpFYdtB+j8bRw1VspDkaGCXrly/auP6Y6a4cm+1huWnE/8n4D
         3vUg==
X-Gm-Message-State: AOAM533s2dyu6jyOL2enq9FvkfgwJVGUVC/ZiAv4HIG3BMncG2Uw11+C
        5bS7tN+AtF7/76mZ9+D9bCY+YHnyDTYBGA==
X-Google-Smtp-Source: ABdhPJyceS0opw/zXmhzHybXoLewEklnDUOhMvPVdKyGgpsAVJN3tgmzM3thwJMy9B4ah2l+PGaCsQ==
X-Received: by 2002:aa7:8648:: with SMTP id a8mr4433714pfo.222.1593204234389;
        Fri, 26 Jun 2020 13:43:54 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y10sm23750016pgi.54.2020.06.26.13.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 13:43:53 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use task_work for links if possible
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <22c72f8a-e80d-67ea-4f89-264238e5810d@kernel.dk>
Date:   Fri, 26 Jun 2020 14:43:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/20 2:27 PM, Pavel Begunkov wrote:
> On 25/06/2020 21:27, Jens Axboe wrote:
>> Currently links are always done in an async fashion, unless we
>> catch them inline after we successfully complete a request without
>> having to resort to blocking. This isn't necessarily the most efficient
>> approach, it'd be more ideal if we could just use the task_work handling
>> for this.
>>
>> Outside of saving an async jump, we can also do less prep work for
>> these kinds of requests.
>>
>> Running dependent links from the task_work handler yields some nice
>> performance benefits. As an example, examples/link-cp from the liburing
>> repository uses read+write links to implement a copy operation. Without
>> this patch, the a cache fold 4G file read from a VM runs in about
>> 3 seconds:
> 
> A few comments below
> 
> 
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0bba12e4e559..389274a078c8 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -898,6 +898,7 @@ enum io_mem_account {
> ...
>> +static void __io_req_task_submit(struct io_kiocb *req)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +	if (!io_sq_thread_acquire_mm(ctx, req)) {
>> +		mutex_lock(&ctx->uring_lock);
>> +		__io_queue_sqe(req, NULL, NULL);
>> +		mutex_unlock(&ctx->uring_lock);
>> +	} else {
>> +		__io_req_task_cancel(req, -EFAULT);
>> +	}
>> +}
>> +
>> +static void io_req_task_submit(struct callback_head *cb)
>> +{
>> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
>> +
>> +	__io_req_task_submit(req);
>> +}
>> +
>> +static void io_req_task_queue(struct io_kiocb *req)
>> +{
>> +	struct task_struct *tsk = req->task;
>> +	int ret;
>> +
>> +	init_task_work(&req->task_work, io_req_task_submit);
>> +
>> +	ret = task_work_add(tsk, &req->task_work, true);
>> +	if (unlikely(ret)) {
>> +		init_task_work(&req->task_work, io_req_task_cancel);
> 
> Why not to kill it off here? It just was nxt, so shouldn't anything like
> NOCANCEL

We don't necessarily know the context, and we'd at least need to check
REQ_F_COMP_LOCKED and propagate. I think it gets ugly really quick,
better to just punt it to clean context.

>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>> +		task_work_add(tsk, &req->task_work, true);
>> +	}
>> +	wake_up_process(tsk);
>> +}
>> +
>>  static void io_free_req(struct io_kiocb *req)
>>  {
>>  	struct io_kiocb *nxt = NULL;
>> @@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
>>  	io_req_find_next(req, &nxt);
>>  	__io_free_req(req);
>>  
>> -	if (nxt)
>> -		io_queue_async_work(nxt);
>> +	if (nxt) {
>> +		if (nxt->flags & REQ_F_WORK_INITIALIZED)
>> +			io_queue_async_work(nxt);
> 
> Don't think it will work. E.g. io_close_prep() may have set
> REQ_F_WORK_INITIALIZED but without io_req_work_grab_env().

This really doesn't change the existing path, it just makes sure we
don't do io_req_task_queue() on something that has already modified
->work (and hence, ->task_work). This might miss cases where we have
only cleared it and done nothing else, but that just means we'll have
cases that we could potentially improve the effiency of down the line.

>> -static inline void req_set_fail_links(struct io_kiocb *req)
>> -{
>> -	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
>> -		req->flags |= REQ_F_FAIL_LINK;
>> -}
>> -
> 
> I think it'd be nicer in 2 patches, first moving io_sq_thread_drop_mm, etc. up.
> And the second one doing actual work. 

Yeah I agree...

>>  static void io_complete_rw_common(struct kiocb *kiocb, long res,
>>  				  struct io_comp_state *cs)
>>  {
>> @@ -2035,35 +2120,6 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
>>  	__io_req_complete(req, res, cflags, cs);
>>  }
>>  
> ...
>>  	switch (req->opcode) {
>>  	case IORING_OP_NOP:
>> @@ -5347,7 +5382,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	if (!req->io) {
>>  		if (io_alloc_async_ctx(req))
>>  			return -EAGAIN;
>> -		ret = io_req_defer_prep(req, sqe);
>> +		ret = io_req_defer_prep(req, sqe, true);
> 
> Why head of a link is for_async?

True, that could be false instead.

Since these are just minor things, we can do a fix on top. I don't want
to reshuffle this unless I have to.

-- 
Jens Axboe

