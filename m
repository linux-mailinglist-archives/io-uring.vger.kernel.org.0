Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79C214699
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgGDOzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 10:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGDOzl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 10:55:41 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEE8C061794
        for <io-uring@vger.kernel.org>; Sat,  4 Jul 2020 07:55:41 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o22so10086053pjw.2
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2020 07:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Ugas+37ZNxM7niEceAhG3i5qtktNRO1rjK/Mbm8Rpo=;
        b=2CaJBkZ4/x3bJaybheDeM4wIlIp2JfSmfUTunCWUU69ETXzaT3SHDRSO+W6Hnd4tqe
         yZwZzx4RdPCHqaxj5cryOnom1C0f66sUeAL9MFO4rUdJ3LL6Qq3wqx61F551DCNBVYPB
         kIDClinWeTZT3r0gt25nQiwSy25ewshJ/5PICqpZncUyahzYtrMTQSixNu874VEIxt6W
         xmsrjBtSxg1Tr5hhJDBixy96ZIdLgK65kgA77eYg7c2RzkxSqeOpAqf/wztd5rN200Ok
         gcDKGgCNYwzOHnUKO/6EyfAgYc0Mlfq9RL7yzMlLKggrBWs3Hv6bZIposAzvXY/a3sF3
         ZRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Ugas+37ZNxM7niEceAhG3i5qtktNRO1rjK/Mbm8Rpo=;
        b=Df6xeqDH4fhCFjok+6TAN/oI0l9i+iK/rIrXweBhECWXCQLnmvGjGDz4t9qFn286WE
         qpLAOTuEoVTTwwp5heVfUqVupSIyh/yCQ1zjDJbensmPCfZ8I7C0NdqphgZteueNieFl
         QhGEuhi+cEsq0K0kBL4wUmolAjXTnzsntzVizdhIuqWw1PBQ6E1y1YpvolHIijS1iFn0
         5LoBn1HadmqLe2h/0azYO1+mgqb8JEliq49Ps2qDk9ETjRBNlMkE1M1RGqPotbL7eO+z
         SysB3Omft4E7Y/fRjVU+9B+JDCIvTsiF2Y6oCfKUSz1lZh1Rma8ggYSP4dg1VINb8iq6
         tHEg==
X-Gm-Message-State: AOAM533PsP+OzoS2kr93A48JsKbDJGTPisjyhWZlucVgviUA4OUHwJgR
        /FRayEgJ6joYhlJJXv/oP3PetMYyz3JaQw==
X-Google-Smtp-Source: ABdhPJziXhi9gpYdKtt9ZkHLic1+wYMJkGqX6B9wBXISPJBWz3/5D1oDn5m0xL5kFaOT/RSdjhrBeg==
X-Received: by 2002:a17:90a:de0c:: with SMTP id m12mr30287551pjv.228.1593874541127;
        Sat, 04 Jul 2020 07:55:41 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p8sm14777141pgs.29.2020.07.04.07.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 07:55:40 -0700 (PDT)
Subject: Re: signals not reliably interrupting io_uring_enter anymore
From:   Jens Axboe <axboe@kernel.dk>
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
 <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
 <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
 <f2620bef-4b4c-1a5d-a1e8-f97f445f78ef@kernel.dk>
 <c83cfb86-7b8e-550b-5c04-395c34415171@kernel.dk>
 <624c0af9-886e-0c5f-0c35-dd245496b365@kernel.dk>
Message-ID: <a82e680a-7db6-3569-2b53-e43e087ef464@kernel.dk>
Date:   Sat, 4 Jul 2020 08:55:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <624c0af9-886e-0c5f-0c35-dd245496b365@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 8:56 PM, Jens Axboe wrote:
> On 7/3/20 8:08 PM, Jens Axboe wrote:
>> On 7/3/20 7:52 PM, Jens Axboe wrote:
>>> On 7/3/20 7:13 PM, Andres Freund wrote:
>>>> Hi, 
>>>>
>>>> On July 3, 2020 5:48:21 PM PDT, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 7/3/20 6:15 PM, Andres Freund wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
>>>>>>> I haven't yet fully analyzed the problem, but after updating to
>>>>>>> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres
>>>>> does
>>>>>>> not work reliably anymore.
>>>>>>>
>>>>>>> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
>>>>>>> interrupted by signals anymore. The signal handler executes, but
>>>>>>> afterwards the syscall is restarted. Previously io_uring_enter
>>>>> reliably
>>>>>>> returned EINTR in that case.
>>>>>>>
>>>>>>> Currently postgres relies on signals interrupting io_uring_enter().
>>>>> We
>>>>>>> probably can find a way to not do so, but it'd not be entirely
>>>>> trivial.
>>>>>>>
>>>>>>> I suspect the issue is
>>>>>>>
>>>>>>> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag:
>>>>> io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>> Date:   2020-06-30 12:39:05 -0600
>>>>>>>
>>>>>>>     io_uring: use signal based task_work running
>>>>>>>
>>>>>>> as that appears to have changed the error returned by
>>>>>>> io_uring_enter(GETEVENTS) after having been interrupted by a signal
>>>>> from
>>>>>>> EINTR to ERESTARTSYS.
>>>>>>>
>>>>>>>
>>>>>>> I'll check to make sure that the issue doesn't exist before the
>>>>> above
>>>>>>> commit.
>>>>>>
>>>>>> Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue
>>>>> doesn't
>>>>>> exist, which pretty much confirms that the above commit is the issue.
>>>>>>
>>>>>> What was the reason for changing EINTR to ERESTARTSYS in the above
>>>>>> commit? I assume trying to avoid returning spurious EINTRs to
>>>>> userland?
>>>>>
>>>>> Yeah, for when it's running task_work. I wonder if something like the
>>>>> below will do the trick?
>>>>>
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 700644a016a7..0efa73d78451 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx
>>>>> *ctx, int min_events,
>>>>> 	do {
>>>>> 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
>>>>> 						TASK_INTERRUPTIBLE);
>>>>> -		/* make sure we run task_work before checking for signals */
>>>>> -		if (current->task_works)
>>>>> -			task_work_run();
>>>>> 		if (signal_pending(current)) {
>>>>> -			ret = -ERESTARTSYS;
>>>>> +			if (current->task_works)
>>>>> +				ret = -ERESTARTSYS;
>>>>> +			else
>>>>> +				ret = -EINTR;
>>>>> 			break;
>>>>> 		}
>>>>> 		if (io_should_wake(&iowq, false))
>>>>> @@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx
>>>>> *ctx, int min_events,
>>>>> 	} while (1);
>>>>> 	finish_wait(&ctx->wait, &iowq.wq);
>>>>>
>>>>> -	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
>>>>> +	restore_saved_sigmask_unless(ret == -EINTR);
>>>>>
>>>>> 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret :
>>>>> 0;
>>>>> }
>>>>
>>>> I'll try in a bit. Suspect however that there'd be trouble if there
>>>> were both an actual signal and task work pending?
>>>
>>> Yes, I have that worry too. We'd really need to check if we have an
>>> actual signal pending - if we do, we still do -EINTR. If not, then we
>>> just do -ERESTARTSYS and restart the system call after task_work has
>>> been completed. Half-assed approach below, I suspect this won't _really_
>>> work without appropriate locking. Which would be unfortunate.
>>>
>>> Either that, or we'd need to know if an actual signal was delivered when
>>> we get re-entered due to returning -ERESTARTSYS. If it was just
>>> task_work being run, then we're fine. But if an actual signal was
>>> pending, then we'd need to return -EINTR.
>>>
>>> CC'ing Oleg to see if he has any good ideas here.
>>
>> This might be simpler:
> 
> Or... That's it for today, I'll check in after the weekend.

This tests out fine for me, and it avoids TWA_SIGNAL if we're not using
an eventfd.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 700644a016a7..d37d7ea5ebe5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4072,14 +4072,22 @@ struct io_poll_table {
 	int error;
 };
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
-				int notify)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 {
 	struct task_struct *tsk = req->task;
-	int ret;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret, notify = TWA_RESUME;
 
-	if (req->ctx->flags & IORING_SETUP_SQPOLL)
+	/*
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
+	 * If we're not using an eventfd, then TWA_RESUME is always fine,
+	 * as we won't have dependencies between request completions for
+	 * other kernel wait conditions.
+	 */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
+	else if (ctx->cq_ev_fd)
+		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
 	if (!ret)
@@ -4110,7 +4118,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work, TWA_SIGNAL);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
@@ -6201,7 +6209,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (current->task_works)
 			task_work_run();
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			if (current->jobctl & JOBCTL_TASK_WORK) {
+				spin_lock_irq(&current->sighand->siglock);
+				current->jobctl &= ~JOBCTL_TASK_WORK;
+				recalc_sigpending();
+				spin_unlock_irq(&current->sighand->siglock);
+				continue;
+			}
+			ret = -EINTR;
 			break;
 		}
 		if (io_should_wake(&iowq, false))
@@ -6210,7 +6225,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
+	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }

-- 
Jens Axboe

