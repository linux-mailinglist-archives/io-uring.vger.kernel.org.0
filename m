Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C0148ED52
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 16:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbiANPoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 10:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiANPoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 10:44:30 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297DBC061574
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 07:44:30 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id v6so12836185iom.6
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 07:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yj+MhtwryY6AfRjFJSVGtPEMmXEB7lREN74krG1enh8=;
        b=r56CxBWjxh+rR/8L2ZAAoNBItFEHicDRKeGo4mqMxhoVdfDmWuu2dshtPjLXMoj18Q
         RplrzHZA7oGwIjyoXpqXTnPJ53JcUWUYiaKboJFnaADu1SR1am6/x01s12uqrVSuJu+r
         fq14rJTKYBQN3tLs/1JzTaqZcSbOahqj4jYVMGnjbmf0f1jhfd87W6or3Q7ohWkxd156
         LZjch5ab6q4Pn6mM5c6YKffxkOkWg0zabswVzL00KhBU/uHGF2X71PjPw4DCTCGVZwu4
         lAvPA8iNps6PwJsrHEobAAuCWHtiVm8cyj05fMPEZTazoeXp4RLrqiXviUoQugscOF+3
         8iYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yj+MhtwryY6AfRjFJSVGtPEMmXEB7lREN74krG1enh8=;
        b=WYox35fnUlPYO+HV/f1LYVsHOr1Q8ykcUfz9a+VZ0D10xtqz+qlp7u/UqaKYQn5zJ3
         uBlZiacfua1zx5u7Qoutlv5BR2fWnshGJ2lzAlhMDO2hNLUcnLf7r3GUMvcgZPmA1wIe
         vwIgq/vjHxFLsPeU8ejEQBvyxOcl7drlngdu2se+tMuPRe6Vy+QCU7JG+AbZFyISb4hJ
         VkV95PWVRglzFq69TEriLcvj73OkFaXrvE9sQA6bSVpRhJED2IvcTZi0FM6b2nkCpkTu
         6PJ5JwRrbLyBWFuWeGbZqyVV3vi6qSZ/t8rPlEP9zxQrmghe5RHlN67t4tO2hnB+BQEv
         or0g==
X-Gm-Message-State: AOAM5339tmOtecTKMZ9z3x1zu8KA8A6YOJt/r5R59KPu/VFOxoTFsxeo
        JOugsUd16mFn9kKq8pMnxTEs8Q==
X-Google-Smtp-Source: ABdhPJzAIktSdOQbz1qIUXTIpu31xCtn6D36dKj5fpdeUvQDd2DB2aEUIvaEje9zBTON5PGoMimr6g==
X-Received: by 2002:a6b:e803:: with SMTP id f3mr1113189ioh.114.1642175069370;
        Fri, 14 Jan 2022 07:44:29 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 11sm4326902ilq.23.2022.01.14.07.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 07:44:29 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix UAF due to missing POLLFREE handling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
References: <4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com>
 <d812d4a0-5afb-5f55-cefc-72c9dbaaeb30@kernel.dk>
 <768b1e93-23c1-8ab6-5891-771d5792aaac@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ec9e9dc-c285-40f1-0513-32505039e9e4@kernel.dk>
Date:   Fri, 14 Jan 2022 08:44:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <768b1e93-23c1-8ab6-5891-771d5792aaac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/22 7:33 AM, Pavel Begunkov wrote:
> On 1/14/22 13:47, Jens Axboe wrote:
>> On 1/14/22 4:59 AM, Pavel Begunkov wrote:
>>> Fixes a problem described in 50252e4b5e989
>>> ("aio: fix use-after-free due to missing POLLFREE handling")
>>> and copies the approach used there.
>>>
>>> In short, we have to forcibly eject a poll entry when we meet POLLFREE.
>>> We can't rely on io_poll_get_ownership() as can't wait for potentially
>>> running tw handlers, so we use the fact that wqs are RCU freed. See
>>> Eric's patch and comments for more details.
>>>
>>> Reported-by: Eric Biggers <ebiggers@google.com>
>>> Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
>>> Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
>>> Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++++++++++--------
>>>   1 file changed, 51 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index fa3277844d2e..bc424af1833b 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5462,12 +5462,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
>>>   
>>>   static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
>>>   {
>>> -	struct wait_queue_head *head = poll->head;
>>> +	struct wait_queue_head *head = smp_load_acquire(&poll->head);
>>>   
>>> -	spin_lock_irq(&head->lock);
>>> -	list_del_init(&poll->wait.entry);
>>> -	poll->head = NULL;
>>> -	spin_unlock_irq(&head->lock);
>>> +	if (head) {
>>> +		spin_lock_irq(&head->lock);
>>> +		list_del_init(&poll->wait.entry);
>>> +		poll->head = NULL;
>>> +		spin_unlock_irq(&head->lock);
>>> +	}
>>>   }
>>>   
>>>   static void io_poll_remove_entries(struct io_kiocb *req)
>>> @@ -5475,10 +5477,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>>>   	struct io_poll_iocb *poll = io_poll_get_single(req);
>>>   	struct io_poll_iocb *poll_double = io_poll_get_double(req);
>>>   
>>> -	if (poll->head)
>>> -		io_poll_remove_entry(poll);
>>> -	if (poll_double && poll_double->head)
>>> +	/*
>>> +	 * While we hold the waitqueue lock and the waitqueue is nonempty,
>>> +	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
>>> +	 * lock in the first place can race with the waitqueue being freed.
>>> +	 *
>>> +	 * We solve this as eventpoll does: by taking advantage of the fact that
>>> +	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
>>> +	 * we enter rcu_read_lock() and see that the pointer to the queue is
>>> +	 * non-NULL, we can then lock it without the memory being freed out from
>>> +	 * under us.
>>> +	 *
>>> +	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
>>> +	 * case the caller deletes the entry from the queue, leaving it empty.
>>> +	 * In that case, only RCU prevents the queue memory from being freed.
>>> +	 */
>>> +	rcu_read_lock();
>>> +	io_poll_remove_entry(poll);
>>> +	if (poll_double)
>>>   		io_poll_remove_entry(poll_double);
>>> +	rcu_read_unlock();
>>>   }
>>>   
>>>   /*
>>> @@ -5618,13 +5636,37 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>   						 wait);
>>>   	__poll_t mask = key_to_poll(key);
>>>   
>>> +	if (unlikely(mask & POLLFREE)) {
>>> +		io_poll_mark_cancelled(req);
>>> +		/* we have to kick tw in case it's not already */
>>> +		io_poll_execute(req, 0);
>>> +
>>> +		/*
>>> +		 * If the waitqueue is being freed early but someone is already
>>> +		 * holds ownership over it, we have to tear down the request as
>>> +		 * best we can. That means immediately removing the request from
>>> +		 * its waitqueue and preventing all further accesses to the
>>> +		 * waitqueue via the request.
>>> +		 */
>>> +		list_del_init(&poll->wait.entry);
>>> +
>>> +		/*
>>> +		 * Careful: this *must* be the last step, since as soon
>>> +		 * as req->head is NULL'ed out, the request can be
>>> +		 * completed and freed, since aio_poll_complete_work()
>>> +		 * will no longer need to take the waitqueue lock.
>>> +		 */
>>> +		smp_store_release(&poll->head, NULL);
>>> +		return 1;
>>> +	}
>>> +
>>>   	/* for instances that support it check for an event match first */
>>>   	if (mask && !(mask & poll->events))
>>>   		return 0;
>>>   
>>>   	if (io_poll_get_ownership(req)) {
>>>   		/* optional, saves extra locking for removal in tw handler */
>>> -		if (mask && poll->events & EPOLLONESHOT) {
>>> +		if (mask && (poll->events & EPOLLONESHOT)) {
>>>   			list_del_init(&poll->wait.entry);
>>>   			poll->head = NULL;
>>>   		}
>>
>> Nice work, and good job documenting it too. Just one minor comment -
> 
> Comments are copy-pasted from aio, all credit to Eric

Well, good job to Eric then :-)

>> this last change here seems like it was a leftover thing, mind if I drop
>> this non-functional change from the patch?
> 
> Sure, it doesn't hurt but whatever way is easier

OK done, thanks for the fix, applied.

-- 
Jens Axboe

