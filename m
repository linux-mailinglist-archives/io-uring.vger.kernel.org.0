Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4362B48EB0C
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 14:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbiANNrz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 08:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiANNry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 08:47:54 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9902C061574
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 05:47:54 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i14so8350089ila.11
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 05:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hgSlzUnRVwpcdzlI16TsKPz/8jQ5SDcSFwI6ofxmgwU=;
        b=iIF5TvgLnzlypOtcNIyWYFHx9UVxEnV+uXdLhNInArqy32SVjNYR6t0F/Gw1KqbDvp
         PivNIl7VWJlQcgqFQXbVgOMMYov6L8MfzjREv4bf87I+/9enGc+PmM8/jSlUrQgnLsop
         Mc2wZmXHIESp7VnOzO1WjXY9L87UhwzjG7zqWYpQGCF2vWQnL8iRtba5sGvEuJ1dAEyU
         fhXoCTwuoosUCkHQXWecZzLYHzs/HZ/wow595MEQ3xfL0A4CyRKniQP71fVmCQgAuSdP
         8CTLTaWrdhEXacuWklEr8iNa5NS9MTNrtGi4Kwgo9GWTmIb2gwRHWh+99GgvSzH3ohDG
         xMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgSlzUnRVwpcdzlI16TsKPz/8jQ5SDcSFwI6ofxmgwU=;
        b=0v26vfa59dfH00/poWse/PN0RIL+yKoTsdOl5Ge57E7n/zGl/qS2FWPPBHMl75Z4fi
         1lIc8L23Oq6CxlC63y3tBoG6QbqLsR9NWEYJ+o1d1dGoYXaFy/IlSqQqTYZ1/hx/tF0l
         VXCqjP3FLShgrdPOcWsN7yUoGFa9/OVqAdgroTjrTTrJhrnFiMxhKW3am89iQJqO2SXe
         DXBQ4TaoU+aORaEraUWVkWyg5UOUW9S/bTMrvYKl/0T3Cpkb/GAeAwUgswbk/rYN8whg
         KRy19UoIG735vvgivSL8volQ0FtGHN6fH4gq6irpE39YXDWpIu9xHztYpWe4nr0wgvRm
         7sUw==
X-Gm-Message-State: AOAM530JPEz7s7hlh5ur/mwQBk1j0AOO/EYO6ttNpzvcOAuodrfAwchL
        X3PRU2f9nlkaWrCOHpNZ3skfBQ==
X-Google-Smtp-Source: ABdhPJzobpR4FRfrkDOz0PTblrTG64CUbwlys1vv6L70j0bw6cz/OyoE2sbtM/9qnrK1sxPS3ROh/Q==
X-Received: by 2002:a92:3649:: with SMTP id d9mr4984611ilf.76.1642168073906;
        Fri, 14 Jan 2022 05:47:53 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h13sm4219527ilj.59.2022.01.14.05.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 05:47:53 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix UAF due to missing POLLFREE handling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
References: <4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d812d4a0-5afb-5f55-cefc-72c9dbaaeb30@kernel.dk>
Date:   Fri, 14 Jan 2022 06:47:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/22 4:59 AM, Pavel Begunkov wrote:
> Fixes a problem described in 50252e4b5e989
> ("aio: fix use-after-free due to missing POLLFREE handling")
> and copies the approach used there.
> 
> In short, we have to forcibly eject a poll entry when we meet POLLFREE.
> We can't rely on io_poll_get_ownership() as can't wait for potentially
> running tw handlers, so we use the fact that wqs are RCU freed. See
> Eric's patch and comments for more details.
> 
> Reported-by: Eric Biggers <ebiggers@google.com>
> Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
> Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
> Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fa3277844d2e..bc424af1833b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5462,12 +5462,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
>  
>  static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
>  {
> -	struct wait_queue_head *head = poll->head;
> +	struct wait_queue_head *head = smp_load_acquire(&poll->head);
>  
> -	spin_lock_irq(&head->lock);
> -	list_del_init(&poll->wait.entry);
> -	poll->head = NULL;
> -	spin_unlock_irq(&head->lock);
> +	if (head) {
> +		spin_lock_irq(&head->lock);
> +		list_del_init(&poll->wait.entry);
> +		poll->head = NULL;
> +		spin_unlock_irq(&head->lock);
> +	}
>  }
>  
>  static void io_poll_remove_entries(struct io_kiocb *req)
> @@ -5475,10 +5477,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>  	struct io_poll_iocb *poll = io_poll_get_single(req);
>  	struct io_poll_iocb *poll_double = io_poll_get_double(req);
>  
> -	if (poll->head)
> -		io_poll_remove_entry(poll);
> -	if (poll_double && poll_double->head)
> +	/*
> +	 * While we hold the waitqueue lock and the waitqueue is nonempty,
> +	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
> +	 * lock in the first place can race with the waitqueue being freed.
> +	 *
> +	 * We solve this as eventpoll does: by taking advantage of the fact that
> +	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
> +	 * we enter rcu_read_lock() and see that the pointer to the queue is
> +	 * non-NULL, we can then lock it without the memory being freed out from
> +	 * under us.
> +	 *
> +	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
> +	 * case the caller deletes the entry from the queue, leaving it empty.
> +	 * In that case, only RCU prevents the queue memory from being freed.
> +	 */
> +	rcu_read_lock();
> +	io_poll_remove_entry(poll);
> +	if (poll_double)
>  		io_poll_remove_entry(poll_double);
> +	rcu_read_unlock();
>  }
>  
>  /*
> @@ -5618,13 +5636,37 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  						 wait);
>  	__poll_t mask = key_to_poll(key);
>  
> +	if (unlikely(mask & POLLFREE)) {
> +		io_poll_mark_cancelled(req);
> +		/* we have to kick tw in case it's not already */
> +		io_poll_execute(req, 0);
> +
> +		/*
> +		 * If the waitqueue is being freed early but someone is already
> +		 * holds ownership over it, we have to tear down the request as
> +		 * best we can. That means immediately removing the request from
> +		 * its waitqueue and preventing all further accesses to the
> +		 * waitqueue via the request.
> +		 */
> +		list_del_init(&poll->wait.entry);
> +
> +		/*
> +		 * Careful: this *must* be the last step, since as soon
> +		 * as req->head is NULL'ed out, the request can be
> +		 * completed and freed, since aio_poll_complete_work()
> +		 * will no longer need to take the waitqueue lock.
> +		 */
> +		smp_store_release(&poll->head, NULL);
> +		return 1;
> +	}
> +
>  	/* for instances that support it check for an event match first */
>  	if (mask && !(mask & poll->events))
>  		return 0;
>  
>  	if (io_poll_get_ownership(req)) {
>  		/* optional, saves extra locking for removal in tw handler */
> -		if (mask && poll->events & EPOLLONESHOT) {
> +		if (mask && (poll->events & EPOLLONESHOT)) {
>  			list_del_init(&poll->wait.entry);
>  			poll->head = NULL;
>  		}

Nice work, and good job documenting it too. Just one minor comment -
this last change here seems like it was a leftover thing, mind if I drop
this non-functional change from the patch?

-- 
Jens Axboe

