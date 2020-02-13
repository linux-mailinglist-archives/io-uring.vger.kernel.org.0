Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36BC15C4C0
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 16:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgBMPuQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 10:50:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35484 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388045AbgBMPuQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 10:50:16 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so7173392ljb.2
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 07:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wti+REJmtucduHKxeCiFF1wsh4NesKa8iqJvXPcnFPE=;
        b=PNZmEWlJYo+M5wn85T00AWoeYk2MNKLRpS1Je/NyZ1VOo6+oB0a0Kp65MnsV6Vuhtn
         Q6XPVN+vya2NjJ0/DefxgAxq98LgaeyWCybxM7kzCbQrJTBmXui85sgEGBQnaiVn46Mc
         6E5WrN7GVQ1OW5D65OBHmwnGSbKjkIr/73oqkoU1I+XB46wpGpyAtbyy7WeHgCJYcbCX
         3tYoq7giL4ndbJITGx96Wn/yIWM5cVULwdjY1wlgm4vEjhpmrAaxFRmKWv0qXALqY/LY
         W5QNgFE1MIfjc+ibkVM+qiLzQb9ybhDNmKZkyoon380NAoikqM1LxI6i8rCEcv1ZycnN
         Jd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wti+REJmtucduHKxeCiFF1wsh4NesKa8iqJvXPcnFPE=;
        b=R+uEW/xM286WjRUi0zkr5CGBsmUSfD6u4hBxLFn5TaT9UxiY8pKmJLNMCi1hL4608f
         B8HtqdC7IURLDItEytO4g1iY+mPDmvmPKaoG99I+5FH2wTRcwbAqtkRCr2nXnkI++oZz
         XLFtzhrblI4D3ZRt/XhHn2CDv5Z6mhm6lyc9mH2zanLpKF5nJeJcOFqI7SoLJPL+V+i2
         Ily3emlYkSvD4AV1iKnmLMbG5CQDrAWdD/k10F3YxGdkUsZ6vfu2TimpcYCNTTe4It79
         ahw1tQr6nijzN6QAoRVwof5WyTAL4tSjdNHb9XStvOREAmVphT2FMRcxyR4JFMReYGnR
         UaoQ==
X-Gm-Message-State: APjAAAVw0O1sE9rtgemoZFFYLPu7zAnvg+6yhYLopROc2q+7Dl6eHN99
        Aca7K+3Lh12qBbdR+gdcoWY5QrJo
X-Google-Smtp-Source: APXvYqwqtzrQauYYFnExAew4VHIh1sz5HwHCLmIetBW4gh1qy/+1BAU5k/MdgXHXO7aNmwwJWZ/7pA==
X-Received: by 2002:a05:651c:1bb:: with SMTP id c27mr11934495ljn.277.1581609012907;
        Thu, 13 Feb 2020 07:50:12 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id v7sm1515698lfa.10.2020.02.13.07.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:50:12 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait()
 users
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200212202515.15299-1-axboe@kernel.dk>
 <20200212202515.15299-4-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5a5942a7-027f-e943-a708-eb6dc804d2d4@gmail.com>
Date:   Thu, 13 Feb 2020 18:50:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200212202515.15299-4-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

There is a couple of comments below

On 2/12/2020 11:25 PM, Jens Axboe wrote:
> Some file descriptors use separate waitqueues for their f_ops->poll()
> handler, most commonly one for read and one for write. The io_uring
> poll implementation doesn't work with that, as the 2nd poll_wait()
> call will cause the io_uring poll request to -EINVAL.
> 
> This is particularly a problem now that pipes were switched to using
> multiple wait queues (commit 0ddad21d3e99), but it also affects tty
> devices and /dev/random as well. This is a big problem for event loops
> where some file descriptors work, and others don't.
> 
> With this fix, io_uring handles multiple waitqueues.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 74 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9cd2ce3b8ad9..9f00f30e1790 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3440,10 +3440,27 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
>  #endif
>  }
>  
> +static void io_poll_remove_double(struct io_kiocb *req)
> +{
> +	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
> +
> +	if (poll && poll->head) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&poll->head->lock, flags);
> +		list_del_init(&poll->wait.entry);
> +		if (poll->wait.private)
> +			refcount_dec(&req->refs);
> +		spin_unlock_irqrestore(&poll->head->lock, flags);
> +	}
> +}
> +
>  static void io_poll_remove_one(struct io_kiocb *req)
>  {
>  	struct io_poll_iocb *poll = &req->poll;
>  
> +	io_poll_remove_double(req);
> +
>  	spin_lock(&poll->head->lock);
>  	WRITE_ONCE(poll->canceled, true);
>  	if (!list_empty(&poll->wait.entry)) {
> @@ -3679,10 +3696,38 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  	if (mask && !(mask & poll->events))
>  		return 0;
>  
> +	io_poll_remove_double(req);
>  	__io_poll_wake(req, &req->poll, mask);
>  	return 1;
>  }
>  
> +static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
> +			       int sync, void *key)
> +{
> +	struct io_kiocb *req = wait->private;
> +	struct io_poll_iocb *poll = (void *) req->io;
> +	__poll_t mask = key_to_poll(key);
> +	bool done = true;
> +
> +	/* for instances that support it check for an event match first: */
> +	if (mask && !(mask & poll->events))
> +		return 0;
> +
> +	if (req->poll.head) {

Can there be concurrent problems?

1. io_poll_wake() -> io_poll_remove_double() is working
   awhile the second io_poll_queue_proc() is called.
   Then there will be a race for req->io

2. concurrent io_poll_wake() and io_poll_double_wake()


> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&req->poll.head->lock, flags);
> +		done = list_empty(&req->poll.wait.entry);
> +		if (!done)
> +			list_del_init(&req->poll.wait.entry);
> +		spin_unlock_irqrestore(&req->poll.head->lock, flags);
> +	}
> +	if (!done)
> +		__io_poll_wake(req, poll, mask);

It's always false if we didn't hit the block under `req->poll.head`, so
it may be placed there along with @done declaration.

> +	refcount_dec(&req->refs);
> +	return 1;
> +}
> +
>  struct io_poll_table {
>  	struct poll_table_struct pt;
>  	struct io_kiocb *req;
> @@ -3693,15 +3738,38 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>  			       struct poll_table_struct *p)
>  {

May this be called concurrently? (at least in theory)

>  	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
> +	struct io_kiocb *req = pt->req;
> +	struct io_poll_iocb *poll = &req->poll;
>  
> -	if (unlikely(pt->req->poll.head)) {
> -		pt->error = -EINVAL;
> -		return;
> +	/*
> +	 * If poll->head is already set, it's because the file being polled
> +	 * use multiple waitqueues for poll handling (eg one for read, one
> +	 * for write). Setup a separate io_poll_iocb if this happens.
> +	 */
> +	if (unlikely(poll->head)) {
> +		/* already have a 2nd entry, fail a third attempt */
> +		if (req->io) {
> +			pt->error = -EINVAL;
> +			return;
> +		}
> +		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);

Don't see where this is freed

> +		if (!poll) {
> +			pt->error = -ENOMEM;
> +			return;
> +		}
> +		poll->done = false;
> +		poll->canceled = false;
> +		poll->events = req->poll.events;
> +		INIT_LIST_HEAD(&poll->wait.entry);
> +		init_waitqueue_func_entry(&poll->wait, io_poll_double_wake);
> +		refcount_inc(&req->refs);
> +		poll->wait.private = req;
> +		req->io = (void *) poll;
>  	}
>  
>  	pt->error = 0;
> -	pt->req->poll.head = head;
> -	add_wait_queue(head, &pt->req->poll.wait);
> +	poll->head = head;
> +	add_wait_queue(head, &poll->wait);
>  }
>  
>  static void io_poll_req_insert(struct io_kiocb *req)
> @@ -3778,6 +3846,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
>  	}
>  	if (mask) { /* no async, we'd stolen it */
>  		ipt.error = 0;
> +		io_poll_remove_double(req);
>  		io_poll_complete(req, mask, 0);
>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
> 

-- 
Pavel Begunkov
