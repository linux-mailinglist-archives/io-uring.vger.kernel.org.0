Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849ED3F3699
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhHTWm5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhHTWm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:42:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC14C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:42:17 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so10011038wme.1
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7+UD3ZNQKjRahjqRJQUY/OD3oe1RS2Ys852KcdnogWI=;
        b=U/zVkAb7QHQXZ3uSe/4zwf5JRgQN89qfbgkOUoPd3Y3ifWiDDjsKuzUWknCMlH2ZRE
         09pS62BWEWvnYJ0XEoEWIz7uLn9aGttCS903XjYb9E4fe92naaDD80PiaTfpInwhj40F
         LvnaetjzWhms6yT9yDH+n+QDmAj6sYEhImQ1DsdklreQC9wcdCYjOrPxT65jKiReJy30
         9zLv6x8cx/gpHZnP70mE24AWD6DwKh368b6K76AjGyLO1osY6QuoAoozu6sZdm6I+Rwx
         XaeDWiKfI/LrpD4xjxrzBluowqMela1BvUATPO65n3lhIvWlsB+GRPYd7v1OzoJSz7gm
         omcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7+UD3ZNQKjRahjqRJQUY/OD3oe1RS2Ys852KcdnogWI=;
        b=irbMIzUyn1EEHgDQoEiRQUZ6nR9CDjV+dKQBH/Dg0IwrT3m+apfXRTc2xelhx9zRHz
         1HvXESBeNB34Au5UNe0E+LLsZA2E+td4xkWf6uyFkWxMWVAJ+w5+2rKwyYbo4aNoTqUB
         8sZuDr+SRMEkFehwgI/PLjv2UCrBs4y1h2hslGDu2NIQCo42NA3a+YnsNwJ///PYcgNg
         chhWaXCDKd2adCDuUoFonhvw2FLnqxbye1N2BC6F4X3hj4CnjcmmFNcAGn0vtc8vDf2z
         uJzrcMV7Q+EblXLmdHtil2uD7nNx990Ckjo1pN+04FQLInFPGUU26uBq8EsHDSRsiHVs
         kTPw==
X-Gm-Message-State: AOAM530+Dq3dm+OJAK35SC9U/yG3VqEkUnaSWRIiqFlhJc40fnvVNmI4
        Musi3knj0kngvphCgQjTcCo=
X-Google-Smtp-Source: ABdhPJzsCYjEninycify4MHv0o7ePLwP2g7gFd5brca2nsXNz8vK15wzAdomh4M7WEta7Rm4h9NJDA==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr5814177wmj.56.1629499336326;
        Fri, 20 Aug 2021 15:42:16 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id u10sm7164079wrt.14.2021.08.20.15.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:42:15 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
 <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
 <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <34b4d60a-d3c5-bb7d-80c9-d90a98f8632d@gmail.com>
Date:   Fri, 20 Aug 2021 23:41:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 11:30 PM, Jens Axboe wrote:
> On 8/20/21 4:28 PM, Pavel Begunkov wrote:
>> On 8/20/21 11:09 PM, Jens Axboe wrote:
>>> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>>>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>>>> may cause problems when accessing it parallelly.
>>>>>>
>>>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>>>
>>>>>> The trick is that it's only responsible to flush requests added
>>>>>> during execution of current call to tctx_task_work(), and those
>>>>>> naturally synchronised with the current task. All other potentially
>>>>>> enqueued requests will be of someone else's responsibility.
>>>>>>
>>>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>>>> 0 there, but actually enqueued a request, it means someone
>>>>>> actually flushed it after the request had been added.
>>>>>>
>>>>>> Probably, needs a more formal explanation with happens-before
>>>>>> and so.
>>>>> I should put more detail in the commit message, the thing is:
>>>>> say coml_nr > 0
>>>>>
>>>>>   ctx_flush_and put                  other context
>>>>>    if (compl_nr)                      get mutex
>>>>>                                       coml_nr > 0
>>>>>                                       do flush
>>>>>                                           coml_nr = 0
>>>>>                                       release mutex
>>>>>         get mutex
>>>>>            do flush (*)
>>>>>         release mutex
>>>>>
>>>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>>>
>>>> I wouldn't care about overhead, that shouldn't be much
>>>>
>>>>> call io_cqring_ev_posted() which I think we shouldn't.
>>>>
>>>> IMHO, users should expect spurious io_cqring_ev_posted(),
>>>> though there were some eventfd users complaining before, so
>>>> for them we can do
>>>
>>> It does sometimes cause issues, see:
>>
>> I'm used that locking may end up in spurious wakeups. May be
>> different for eventfd, but considering that we do batch
>> completions and so might be calling it only once per multiple
>> CQEs, it shouldn't be.
> 
> The wakeups are fine, it's the ev increment that's causing some issues.

If userspace doesn't expect that eventfd may get diverged from the
number of posted CQEs, we need something like below. The weird part
is that it looks nobody complained about this one, even though it
should be happening pretty often. 


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 761f4d99a1a9..7a0fc024d857 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1463,34 +1463,39 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return !ctx->eventfd_async || io_wq_current_is_worker();
 }
 
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static void __io_cqring_ev_posted(struct io_ring_ctx *ctx, unsigned events)
 {
 	/* see waitqueue_active() comment */
 	smp_mb();
 
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, events);
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
 	if (waitqueue_active(&ctx->cq_wait)) {
 		wake_up_interruptible(&ctx->cq_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
 }
 
-static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
+static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+{
+	__io_cqring_ev_posted(ctx, 1);
+}
+
+static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx, unsigned events)
 {
 	/* see waitqueue_active() comment */
 	smp_mb();
 
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, events);
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (waitqueue_active(&ctx->wait))
 			wake_up(&ctx->wait);
 	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
 	if (waitqueue_active(&ctx->cq_wait)) {
 		wake_up_interruptible(&ctx->cq_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
@@ -2223,7 +2228,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_ev_posted(ctx);
+	__io_cqring_ev_posted(ctx, nr);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
 
@@ -2336,6 +2341,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
+	unsigned int events = 0;
 
 	/* order with ->result store in io_complete_rw_iopoll() */
 	smp_rmb();
@@ -2360,15 +2366,16 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result, cflags,
 					req->cq_idx);
-		(*nr_events)++;
+		events++;
 
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
 	io_commit_cqring(ctx);
-	io_cqring_ev_posted_iopoll(ctx);
+	io_cqring_ev_posted_iopoll(ctx, events);
 	io_req_free_batch_finish(ctx, &rb);
+	*nr_events += events;
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -5404,7 +5411,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (posted)
-		io_cqring_ev_posted(ctx);
+		__io_cqring_ev_posted(ctx, posted);
 
 	return posted != 0;
 }
@@ -9010,7 +9017,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 		io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	if (canceled != 0)
-		io_cqring_ev_posted(ctx);
+		__io_cqring_ev_posted(ctx, canceled);
 	return canceled != 0;
 }




