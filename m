Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DD920BB55
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 23:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFZVV6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 17:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgFZVVy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 17:21:54 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D256C03E97A
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 14:21:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so10630902wml.3
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 14:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s4BWm6yYZtQvb0hDmwCCseEV4rVQ2tQ18Xv90iVE83U=;
        b=F62MI8/me9E4B+Ma4At6v3+4+YHent8Dz3uSK5nmUWI5TG9H/5U6/O+n/EzIyVApun
         ZOaI5opEFIRGjPC/8kzoNeVuuGJ7UNtNFCJ2gdnH9h8SP2NxY5+gDTiUo8nsYTx5GNLb
         CEoBnDoBzqL0FbDDkBlx3kyBC2vFCK2FsSHieXpcEDWg6gl43V2/VCmw5Nnon99e9wgK
         n6dceB2TQUgwq/x1CWsueDX0jtwIbXlJGYlrwASzphBFtNqMzDbwGe+X4V4oZe3+fqfw
         1kMs0FlEMToTyt4FNxLfWNh0WSMvd3eM62ji2xtylHq14Rcx4QolZZzP9FLj1LSBXL2Z
         h1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s4BWm6yYZtQvb0hDmwCCseEV4rVQ2tQ18Xv90iVE83U=;
        b=bYRPAPTXxZcc3Z3cU8/geo6un5KHBO7W+NZrDdoRWMlJDs+BXHsBStPyl7r/6Jf6lH
         4W7KVqAvwkzzbNsvsbOg9LJpPyAvkB0keM3uOTd2r7c8oQu5TjyDZPUta9f2PW7RkDBj
         fTBrsMA5j3YIsuPrMvAK5kkbfmmfJ2hkqhhwcNvXVg2kDUPh61ZQN9vSmNGkaqf2/irK
         +3AYUkwzb4/yqXbQgQ+tjiQnW4NuOwuy63SFPzdfHf/M1rNLidjbUz3Sz5HyevT4/sM/
         rxTJHHsUqiM+JMQTBkaThS+zGHev72Z4WEixqa2P1ehMnKbOT9CFBTsqlY7Gx8+hwEOD
         5OIw==
X-Gm-Message-State: AOAM5314AWOzVUWlddsPx621C4fGZvBlLhFVyApMkooSkgg8NViOEj7q
        tLaIFZaeG+e5mQr2HCUxu4LAjVvy
X-Google-Smtp-Source: ABdhPJwekxTEeY2kT669fEc22y1uDBdM6if9I6puShX1rURYkQ1XBMsraipB96YUt2WgGB3p9dZCOg==
X-Received: by 2002:a1c:7517:: with SMTP id o23mr5178418wmc.7.1593206512317;
        Fri, 26 Jun 2020 14:21:52 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id f12sm8618567wrj.48.2020.06.26.14.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 14:21:51 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
 <22c72f8a-e80d-67ea-4f89-264238e5810d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: use task_work for links if possible
Message-ID: <7bfac3fc-22be-0ec7-fb7e-4fa714091ba9@gmail.com>
Date:   Sat, 27 Jun 2020 00:20:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <22c72f8a-e80d-67ea-4f89-264238e5810d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/06/2020 23:43, Jens Axboe wrote:
> On 6/26/20 2:27 PM, Pavel Begunkov wrote:
>> On 25/06/2020 21:27, Jens Axboe wrote:
>>> Currently links are always done in an async fashion, unless we
>>> catch them inline after we successfully complete a request without
>>> having to resort to blocking. This isn't necessarily the most efficient
>>> approach, it'd be more ideal if we could just use the task_work handling
>>> for this.
>>>
>>> Outside of saving an async jump, we can also do less prep work for
>>> these kinds of requests.
>>>
>>> Running dependent links from the task_work handler yields some nice
>>> performance benefits. As an example, examples/link-cp from the liburing
>>> repository uses read+write links to implement a copy operation. Without
>>> this patch, the a cache fold 4G file read from a VM runs in about
>>> 3 seconds:
>>
>> A few comments below
>>
>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 0bba12e4e559..389274a078c8 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -898,6 +898,7 @@ enum io_mem_account {
>> ...
>>> +static void __io_req_task_submit(struct io_kiocb *req)
>>> +{
>>> +	struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +	__set_current_state(TASK_RUNNING);
>>> +	if (!io_sq_thread_acquire_mm(ctx, req)) {
>>> +		mutex_lock(&ctx->uring_lock);
>>> +		__io_queue_sqe(req, NULL, NULL);
>>> +		mutex_unlock(&ctx->uring_lock);
>>> +	} else {
>>> +		__io_req_task_cancel(req, -EFAULT);
>>> +	}
>>> +}
>>> +
>>> +static void io_req_task_submit(struct callback_head *cb)
>>> +{
>>> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
>>> +
>>> +	__io_req_task_submit(req);
>>> +}
>>> +
>>> +static void io_req_task_queue(struct io_kiocb *req)
>>> +{
>>> +	struct task_struct *tsk = req->task;
>>> +	int ret;
>>> +
>>> +	init_task_work(&req->task_work, io_req_task_submit);
>>> +
>>> +	ret = task_work_add(tsk, &req->task_work, true);
>>> +	if (unlikely(ret)) {
>>> +		init_task_work(&req->task_work, io_req_task_cancel);
>>
>> Why not to kill it off here? It just was nxt, so shouldn't anything like
>> NOCANCEL
> 
> We don't necessarily know the context, and we'd at least need to check
> REQ_F_COMP_LOCKED and propagate. I think it gets ugly really quick,
> better to just punt it to clean context.

Makes sense

> 
>>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>>> +		task_work_add(tsk, &req->task_work, true);
>>> +	}
>>> +	wake_up_process(tsk);
>>> +}
>>> +
>>>  static void io_free_req(struct io_kiocb *req)
>>>  {
>>>  	struct io_kiocb *nxt = NULL;
>>> @@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
>>>  	io_req_find_next(req, &nxt);
>>>  	__io_free_req(req);
>>>  
>>> -	if (nxt)
>>> -		io_queue_async_work(nxt);
>>> +	if (nxt) {
>>> +		if (nxt->flags & REQ_F_WORK_INITIALIZED)
>>> +			io_queue_async_work(nxt);
>>
>> Don't think it will work. E.g. io_close_prep() may have set
>> REQ_F_WORK_INITIALIZED but without io_req_work_grab_env().
> 
> This really doesn't change the existing path, it just makes sure we
> don't do io_req_task_queue() on something that has already modified
> ->work (and hence, ->task_work). This might miss cases where we have
> only cleared it and done nothing else, but that just means we'll have
> cases that we could potentially improve the effiency of down the line.

Before the patch it was always initialising linked reqs, and that would
work ok, if not this lazy grab_env().

E.g. req1 -> close_req

It calls, io_req_defer_prep(__close_req__, sqe, __false__)
which doesn't do grab_env() because of for_async=false,
but calls io_close_prep() which sets REQ_F_WORK_INITIALIZED.

Then, after completion of req1 it will follow added lines

if (nxt)
	if (nxt->flags & REQ_F_WORK_INITIALIZED)
		io_queue_async_work(nxt);

Ending up in

io_queue_async_work()
	-> grab_env()

And that's who knows from which context.
E.g. req1 was an rw completed in an irq.


Not sure it's related, but fallocate shows the log below, and some other tests
hang the kernel as well.

[   42.445719] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   42.445723] #PF: supervisor write access in kernel mode
[   42.445725] #PF: error_code(0x0002) - not-present page
[   42.445726] PGD 0 P4D 0 
[   42.445729] Oops: 0002 [#1] PREEMPT SMP PTI
[   42.445733] CPU: 1 PID: 1511 Comm: io_wqe_worker-0 Tainted: G          I       5.8.0-rc2-00358-g9d2391dd5359 #489
[   42.445740] RIP: 0010:override_creds+0x19/0x30
...
[   42.445754] Call Trace:
[   42.445758]  io_worker_handle_work+0x25c/0x430
[   42.445760]  io_wqe_worker+0x2a0/0x350
[   42.445764]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[   42.445766]  ? io_worker_handle_work+0x430/0x430
[   42.445769]  kthread+0x136/0x180
[   42.445771]  ? kthread_park+0x90/0x90
[   42.445774]  ret_from_fork+0x22/0x30


> 
>>> -static inline void req_set_fail_links(struct io_kiocb *req)
>>> -{
>>> -	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
>>> -		req->flags |= REQ_F_FAIL_LINK;
>>> -}
>>> -
>>
>> I think it'd be nicer in 2 patches, first moving io_sq_thread_drop_mm, etc. up.
>> And the second one doing actual work. 
> 
> Yeah I agree...
> 
>>>  static void io_complete_rw_common(struct kiocb *kiocb, long res,
>>>  				  struct io_comp_state *cs)
>>>  {
>>> @@ -2035,35 +2120,6 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
>>>  	__io_req_complete(req, res, cflags, cs);
>>>  }
>>>  
>> ...
>>>  	switch (req->opcode) {
>>>  	case IORING_OP_NOP:
>>> @@ -5347,7 +5382,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	if (!req->io) {
>>>  		if (io_alloc_async_ctx(req))
>>>  			return -EAGAIN;
>>> -		ret = io_req_defer_prep(req, sqe);
>>> +		ret = io_req_defer_prep(req, sqe, true);
>>
>> Why head of a link is for_async?
> 
> True, that could be false instead.
> 
> Since these are just minor things, we can do a fix on top. I don't want
> to reshuffle this unless I have to.

Agree, I have a pile on top myself.

-- 
Pavel Begunkov
