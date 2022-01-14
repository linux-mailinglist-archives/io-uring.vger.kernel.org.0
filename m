Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD348EBB6
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiANOdS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 09:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiANOdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 09:33:16 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACC9C061574
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 06:33:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l4so6173197wmq.3
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 06:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Kd1LihyaKI856GI03agl1n60eRGvlTJu+GwUTwV0c0c=;
        b=AWWY97qzeN8cc9TW6jWjrTFcqn/jYTwBKxgrywjPzWxRfULZt0f6otkrpqH5NqkGxP
         ctNjp4IF58th5lAgK+d60IfcvCUavBW3QXdLEwaoDJP0wN0GotbPze2xCWr4FFOYbYas
         Y1up8aCy4b/Cji2Qbb0cQVX9J/AZu0nAcpH2Z7XeWq9+m2/QC75vpYQjSAv5RwNvoclW
         HEH388DHcjDNou7FOV1jBUJ7lQfDAa3wfHI2clcXSHPK1yUG7Que6W4jaVDb1Sd0jybX
         WpRYdOBVUUKaNvySx0tanhqWaBVgXKINWifJbO29TEqGt6DS+Kpfty8tsYNTOTWp3ss7
         o1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kd1LihyaKI856GI03agl1n60eRGvlTJu+GwUTwV0c0c=;
        b=Ig4kLnykJ8RxuY+46Dw9SPGlaMlJlrEjGnG3ddpSRiGV+oDKDY1MThBEkoJ1TIMeFE
         yd3Qwv6mDI4J2Nn44figX9XxXwgq8El1zxFrVHHUOwpLWMES3j+lu08EadU1lI3bn4hR
         yCsxB02+LOvleUhvBeuWrtUnIOq5uL5aY4w6zwfoA+Hb8Py2oZ3Mqvk+2uyFYOImWum9
         KOcdJx2GUgZmt8imHef6bqApc2gKB7GJUPl+j9d89FgYC8AF695gqw1X2Czdpm2EgIaT
         tYukGuZ1DS49OsPzV8sVrugxUL1NeosjuQpw6sdnxsArcFvvuD2+68uWkiROXJaII9pW
         GTPw==
X-Gm-Message-State: AOAM530m5+Yx22J3/qiErmE8WK1sMZMLuHijNpOB+7W8kGBHiDVbXG4K
        MHCCA5Ge5/AHnwiKcYInoaw=
X-Google-Smtp-Source: ABdhPJzkmt+cGjpmEl4nFwipN3pk6LXW9c3+OUbU4Igyk/FUrWLXnbZ86NOO8ywmrdocBWVSHS+Tpw==
X-Received: by 2002:a05:600c:3ac5:: with SMTP id d5mr8608369wms.32.1642170794703;
        Fri, 14 Jan 2022 06:33:14 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.103])
        by smtp.gmail.com with ESMTPSA id o8sm7202295wry.20.2022.01.14.06.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 06:33:14 -0800 (PST)
Message-ID: <768b1e93-23c1-8ab6-5891-771d5792aaac@gmail.com>
Date:   Fri, 14 Jan 2022 14:33:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] io_uring: fix UAF due to missing POLLFREE handling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
References: <4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com>
 <d812d4a0-5afb-5f55-cefc-72c9dbaaeb30@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d812d4a0-5afb-5f55-cefc-72c9dbaaeb30@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/22 13:47, Jens Axboe wrote:
> On 1/14/22 4:59 AM, Pavel Begunkov wrote:
>> Fixes a problem described in 50252e4b5e989
>> ("aio: fix use-after-free due to missing POLLFREE handling")
>> and copies the approach used there.
>>
>> In short, we have to forcibly eject a poll entry when we meet POLLFREE.
>> We can't rely on io_poll_get_ownership() as can't wait for potentially
>> running tw handlers, so we use the fact that wqs are RCU freed. See
>> Eric's patch and comments for more details.
>>
>> Reported-by: Eric Biggers <ebiggers@google.com>
>> Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
>> Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
>> Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 51 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index fa3277844d2e..bc424af1833b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5462,12 +5462,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
>>   
>>   static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
>>   {
>> -	struct wait_queue_head *head = poll->head;
>> +	struct wait_queue_head *head = smp_load_acquire(&poll->head);
>>   
>> -	spin_lock_irq(&head->lock);
>> -	list_del_init(&poll->wait.entry);
>> -	poll->head = NULL;
>> -	spin_unlock_irq(&head->lock);
>> +	if (head) {
>> +		spin_lock_irq(&head->lock);
>> +		list_del_init(&poll->wait.entry);
>> +		poll->head = NULL;
>> +		spin_unlock_irq(&head->lock);
>> +	}
>>   }
>>   
>>   static void io_poll_remove_entries(struct io_kiocb *req)
>> @@ -5475,10 +5477,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>>   	struct io_poll_iocb *poll = io_poll_get_single(req);
>>   	struct io_poll_iocb *poll_double = io_poll_get_double(req);
>>   
>> -	if (poll->head)
>> -		io_poll_remove_entry(poll);
>> -	if (poll_double && poll_double->head)
>> +	/*
>> +	 * While we hold the waitqueue lock and the waitqueue is nonempty,
>> +	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
>> +	 * lock in the first place can race with the waitqueue being freed.
>> +	 *
>> +	 * We solve this as eventpoll does: by taking advantage of the fact that
>> +	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
>> +	 * we enter rcu_read_lock() and see that the pointer to the queue is
>> +	 * non-NULL, we can then lock it without the memory being freed out from
>> +	 * under us.
>> +	 *
>> +	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
>> +	 * case the caller deletes the entry from the queue, leaving it empty.
>> +	 * In that case, only RCU prevents the queue memory from being freed.
>> +	 */
>> +	rcu_read_lock();
>> +	io_poll_remove_entry(poll);
>> +	if (poll_double)
>>   		io_poll_remove_entry(poll_double);
>> +	rcu_read_unlock();
>>   }
>>   
>>   /*
>> @@ -5618,13 +5636,37 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>   						 wait);
>>   	__poll_t mask = key_to_poll(key);
>>   
>> +	if (unlikely(mask & POLLFREE)) {
>> +		io_poll_mark_cancelled(req);
>> +		/* we have to kick tw in case it's not already */
>> +		io_poll_execute(req, 0);
>> +
>> +		/*
>> +		 * If the waitqueue is being freed early but someone is already
>> +		 * holds ownership over it, we have to tear down the request as
>> +		 * best we can. That means immediately removing the request from
>> +		 * its waitqueue and preventing all further accesses to the
>> +		 * waitqueue via the request.
>> +		 */
>> +		list_del_init(&poll->wait.entry);
>> +
>> +		/*
>> +		 * Careful: this *must* be the last step, since as soon
>> +		 * as req->head is NULL'ed out, the request can be
>> +		 * completed and freed, since aio_poll_complete_work()
>> +		 * will no longer need to take the waitqueue lock.
>> +		 */
>> +		smp_store_release(&poll->head, NULL);
>> +		return 1;
>> +	}
>> +
>>   	/* for instances that support it check for an event match first */
>>   	if (mask && !(mask & poll->events))
>>   		return 0;
>>   
>>   	if (io_poll_get_ownership(req)) {
>>   		/* optional, saves extra locking for removal in tw handler */
>> -		if (mask && poll->events & EPOLLONESHOT) {
>> +		if (mask && (poll->events & EPOLLONESHOT)) {
>>   			list_del_init(&poll->wait.entry);
>>   			poll->head = NULL;
>>   		}
> 
> Nice work, and good job documenting it too. Just one minor comment -

Comments are copy-pasted from aio, all credit to Eric

> this last change here seems like it was a leftover thing, mind if I drop
> this non-functional change from the patch?

Sure, it doesn't hurt but whatever way is easier


-- 
Pavel Begunkov
