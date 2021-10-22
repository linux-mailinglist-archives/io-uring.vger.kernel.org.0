Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139BB437ED5
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhJVTwC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 15:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhJVTwC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 15:52:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27623C061764
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 12:49:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so5531816edj.1
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 12:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x4CzGUDuinN5p6emW3D+YfuBipy1PT3OvfkWqqm5v84=;
        b=CUDVgn9rajRibY/9v3iEzRoKIZ6TPPsd2swsClZ1wdAF7pLZkm7gOW4ZrnDoZSscDv
         ajODcLoiBK+pdsADHWzdHglatRUIPqmg1s8unG7g+Mf0VX64KUVavTr9FkxMV9QpIBVn
         Iuh9UaPC7CXeggMBO7HB3vnsKB5k9Atj/yrJmaopy72YvqpI/9HI9MOJ2Q/m2i0Bet5Y
         KmqPmHpCIeJ2yuQ5Z0doGhS6BY1Sv5uKhtSZKp31Ou9J4zDOOFhIV40/1DdwhrrE4GK2
         s4Z1sl9xZUNjP8/AW3hMJPGmrYqXhN9stBpaUMX77X5wDgE0dc7gXd+NdjgOO7xc8YUl
         7+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x4CzGUDuinN5p6emW3D+YfuBipy1PT3OvfkWqqm5v84=;
        b=8Ph4LXXpJawUgO7ImIEEGeFpbHp6GsKDQT31NJsnpqPy6Uk+gyWmQkDgxZVJdz5GQD
         GZRV6FU30avSENJ/bMPIZOOHu6SyVhadwFgj7Ig1ceuZFi/RbqnIJiEieK68q6VutILq
         uIOCFR4BbcYHscoJGRSi5PJNLhjhKePYKD4nMJPZePn8V1oPo7kxvWYl06rZalrI0iyD
         UJDvm9pvh/sO7Hsg5O2gUB704mwK2c3/z9B9yPJO0o9P4BmrZW6WyUWiossI45Va6EUl
         7ojFQpCDoCIl2CQ9AYhK7o+opidXFq8nvONPh9LDw7zwaJ33oJeDsmt2AyksalgaemkP
         SclA==
X-Gm-Message-State: AOAM531XLGdDffpPTzYdY3INnlv4HqcecSVqFglFgVmZR05f86+mngAs
        fT3Bm0Pc17CGju2KZYRpOxqibikSW9g=
X-Google-Smtp-Source: ABdhPJxRGi9EMHgbrCHnwmakY2JqqctxacFfDz1RHkM1UMxfPIOczuXu28sUuHtW8SYOy/pThAqVVg==
X-Received: by 2002:a17:906:4a09:: with SMTP id w9mr1917963eju.419.1634932182716;
        Fri, 22 Oct 2021 12:49:42 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id go41sm1000732ejc.32.2021.10.22.12.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:49:42 -0700 (PDT)
Message-ID: <47b4a1bb-7918-8803-90a7-3cf95b99d84f@gmail.com>
Date:   Fri, 22 Oct 2021 20:49:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] io_uring: implement async hybrid mode for pollable
 requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018133445.103438-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018133445.103438-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 14:34, Hao Xu wrote:
> The current logic of requests with IOSQE_ASYNC is first queueing it to
> io-worker, then execute it in a synchronous way. For unbound works like
> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
> there waiting for events for a long time. And thus other works wait in
> the list for a long time too.
> Let's introduce a new way for unbound works (currently pollable
> requests), with this a request will first be queued to io-worker, then
> executed in a nonblock try rather than a synchronous way. Failure of
> that leads it to arm poll stuff and then the worker can begin to handle
> other works.
> The detail process of this kind of requests is:

Looks good, but there are a couple of moments that might be better.
Would be good to have it for 5.16, if it's rolling out soon we can
queue this and do post clean up.

nits below

> step1: original context:
>             queue it to io-worker
> step2: io-worker context:
>             nonblock try(the old logic is a synchronous try here)
>                 |
>                 |--fail--> arm poll
>                              |
>                              |--(fail/ready)-->synchronous issue
>                              |
>                              |--(succeed)-->worker finish it's job, tw
>                                             take over the req
> 
> This works much better than the old IOSQE_ASYNC logic in cases where
> unbound max_worker is relatively small. In this case, number of
> io-worker eazily increments to max_worker, new worker cannot be created
> and running workers stuck there handling old works in IOSQE_ASYNC mode.
> 
> In my 64-core machine, set unbound max_worker to 20, run echo-server,
> turns out:
> (arguments: register_file, connetion number is 1000, message size is 12
> Byte)
> original IOSQE_ASYNC: 76664.151 tps
> after this patch: 166934.985 tps
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v1-->v2:
>   - tweak added code in io_wq_submit_work to reduce overhead
> v2-->v3:
>   - remove redundant IOSQE_ASYNC_HYBRID stuff
> 
> 
>   fs/io_uring.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b3546eef0289..86819c7917df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6747,8 +6747,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		ret = -ECANCELED;

Too much of indention, it's hard to read. I'd suggest to do

if (unlikely(work->flags & IO_WQ_WORK_CANCEL)) {
	io_req_task_queue_fail(req, -ECANCELED);
	return;
}

and kill following "if (!ret)" with extra indention


>   
>   	if (!ret) {
> +		bool needs_poll = false;
> +		unsigned int issue_flags = IO_URING_F_UNLOCKED;
> +
> +		if (req->flags & REQ_F_FORCE_ASYNC) {
> +			needs_poll = req->file && file_can_poll(req->file);

It goes through a weird flow if opcode doesn't use polling,

needs_poll = needs_poll && (def->pollin || def->pollout);


We can even split out checks from io_arm_poll_handler() into
an inline handler.


if (!req->file || !file_can_poll(req->file))
	return IO_APOLL_ABORTED;
if (req->flags & REQ_F_POLLED)
	return IO_APOLL_ABORTED;
if (!def->pollin && !def->pollout)
	return IO_APOLL_ABORTED;



> +			if (needs_poll)
> +				issue_flags |= IO_URING_F_NONBLOCK;
> +		}
> +
>   		do {
> -			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
> +issue_sqe:
> +			ret = io_issue_sqe(req, issue_flags);
>   			/*
>   			 * We can get EAGAIN for polled IO even though we're
>   			 * forcing a sync submission from here, since we can't
> @@ -6756,6 +6766,30 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   			 */
>   			if (ret != -EAGAIN)
>   				break;
> +			if (needs_poll) {

How about inverting it and killing yet another indention level
for the polling stuff?

if (!needs_poll) {
	cond_resched();
	continue;
}

/* arm polling / etc. */


And that's the only place we need cond_resched(), so the one
at the end can be deleted.

> +				bool armed = false;
> +
> +				ret = 0;
> +				needs_poll = false;
> +				issue_flags &= ~IO_URING_F_NONBLOCK;
> +
> +				switch (io_arm_poll_handler(req)) {

1) Not a big fun of back hopping jumps
2) don't like armed logic

What we can do is replace switch with if's, and then you can freely
use break instead of @armed and continue instead of goto. Also,
considering a cond_reshed() comment it can be:

if (io_arm_poll_handler(req) == IO_APOLL_OK)
	break;
continue;
  

> +				case IO_APOLL_READY:
> +					goto issue_sqe;
> +				case IO_APOLL_ABORTED:
> +					/*
> +					 * somehow we failed to arm the poll infra,
> +					 * fallback it to a normal async worker try.
> +					 */
> +					break;
> +				case IO_APOLL_OK:
> +					armed = true;
> +					break;
> +				}
> +
> +				if (armed)
> +					break;
> +			}
>   			cond_resched();
>   		} while (1);
>   	}
> 

With all but (pollin || pollout) changes looks for me like
below (not tested), I guess can be brushed further.


static void io_wq_submit_work(struct io_wq_work *work)
{
	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
	unsigned int issue_flags = IO_URING_F_UNLOCKED;
	bool needs_poll = false;
	struct io_kiocb *timeout;
	int ret;

	/* one will be dropped by ->io_free_work() after returning to io-wq */
	if (!(req->flags & REQ_F_REFCOUNT))
		__io_req_set_refcount(req, 2);
	else
		req_ref_get(req);

	timeout = io_prep_linked_timeout(req);
	if (timeout)
		io_queue_linked_timeout(timeout);

	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
	if (unlikely(work->flags & IO_WQ_WORK_CANCEL)) {
		io_req_task_queue_fail(req, -ECANCELED);
		return;
	}

	if (req->flags & REQ_F_FORCE_ASYNC) {
		needs_poll = req->file && file_can_poll(req->file);
		if (needs_poll)
			issue_flags |= IO_URING_F_NONBLOCK;
	}

	do {
		ret = io_issue_sqe(req, issue_flags);
		/*
		 * We can get EAGAIN for polled IO even though we're
		 * forcing a sync submission from here, since we can't
		 * wait for request slots on the block side.
		 */
		if (ret != -EAGAIN)
			break;
		if (!needs_poll) {
			cond_resched();
			continue;
		}

		if (io_arm_poll_handler(req) == IO_APOLL_OK)
			return;
		/* ready or aborted, in either case fall back to blocking */
		needs_poll = false;
		issue_flags &= ~IO_URING_F_NONBLOCK;
	} while (1);

	/* avoid locking problems by failing it from a clean context */
	if (ret)
		io_req_task_queue_fail(req, ret);
}

-- 
Pavel Begunkov
