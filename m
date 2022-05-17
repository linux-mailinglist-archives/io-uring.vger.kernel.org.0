Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9678852AEDB
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 01:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiEQXwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 19:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiEQXwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 19:52:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854CE52E48
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 16:52:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so234007plg.7
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 16:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XJTnzIVwKKP2159kKSUS1BPKhBYNJeW8HbtdFHHy4iE=;
        b=btuV0tJiD7pGnwKvvbQErl6mxwh+SGFL78yB20r9JCvzvaP0zYwMvi4eaThuEoUsWF
         Xn4xx6FDgnx/IOoCtz1gqtpTGNB1wYzQinlYEVBXxglHhnXk0mxRlOupN7YcygC6hRM2
         KQ74U/Gfi233jnL+9r7E/9oRStOt6eTTP2if+vBdD8ikLIzTx8UuNa/4e6+lgZlW0X4j
         GzIzF0li7U0IGfSYGTxtDNS4PTbYOt/ELyiNfED6iXwEaMYcYlZrqAB4IWTOfO1XZKQL
         IIe7bRFfukTOjX4IvefuxbO2fsVPu829r8+0g89NKQC6FDYbl5f+lyQ0eAHdcXeLeGfY
         JR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XJTnzIVwKKP2159kKSUS1BPKhBYNJeW8HbtdFHHy4iE=;
        b=HdBpF4embcyfwRgqHyqreB8QWssvT+Jmz1zgVZW/u8VDD5O/inmJnu0J4nVNGQba3o
         5OmP5Xx7MTSzfBeYeUDWqXRPgl3ycz6NBhBUQqYKgcd2SmqOssarOsNQCCsO6HBKmbWO
         rCCKd0bn3YCdiaOFDzHNMDitUviiAMa+TRVVF0Yc19+s5gXE1U7ss6MRjXEKcmIhTSW7
         3qblKktKCfvg/64RtRHqXkzTs61t57CsyPUAmWe5+1OuWrc2kS6DUHePoMTQimCIMNu8
         lLq0rlHkSYoAQos0NT+2n0CAHZLDDjsDza9L0pY0oz7X1O5s4H9mnRccMc6w9HYVidcD
         tG1Q==
X-Gm-Message-State: AOAM530wap6Fov50d2ACu8RhGPqjniVEHiI9VGXxveNPj3GOZHh1G3no
        wzf/SKAYeK7o+c+7x6w4mZT7ew==
X-Google-Smtp-Source: ABdhPJxBuUJ6jRQmUBj89KENzVfnvjJ/Pw/8kwPGKN6UP+F2fpjWv0AMGDAtFKMAQU9QdMbf2FwdGA==
X-Received: by 2002:a17:902:e948:b0:15e:cd79:2a1a with SMTP id b8-20020a170902e94800b0015ecd792a1amr24409818pll.109.1652831555862;
        Tue, 17 May 2022 16:52:35 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id iz15-20020a170902ef8f00b001619b38701bsm186571plb.72.2022.05.17.16.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 16:52:35 -0700 (PDT)
Message-ID: <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
Date:   Tue, 17 May 2022 17:52:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoOcYR15Jhkw2XwL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 7:00 AM, Lee Jones wrote:
> On Tue, 17 May 2022, Jens Axboe wrote:
> 
>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>
>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>
>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>> in Stable v5.10.y.
>>>>>>>
>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>
>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>
>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>
>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>
>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>
>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>
>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>
>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>
>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> Does this fix it:
>>>>>>
>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>
>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>
>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>> rectify that.
>>>>>
>>>>> Thanks for your quick response Jens.
>>>>>
>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>
>>>> This is probably why it never made it into 5.10-stable :-/
>>>
>>> Right.  It doesn't apply at all unfortunately.
>>>
>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>
>>>> Let me know if you into issues with that and I can help out.
>>>
>>> I think the dependency list is too big.
>>>
>>> Too much has changed that was never back-ported.
>>>
>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>> bad, I did start to back-port them all but some of the big ones have
>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>> from v5.10 to the fixing patch mentioned above).
>>
>> The problem is that 5.12 went to the new worker setup, and this patch
>> landed after that even though it also applies to the pre-native workers.
>> Hence the dependency chain isn't really as long as it seems, probably
>> just a few patches backporting the change references and completions.
>>
>> I'll take a look this afternoon.
> 
> Thanks Jens.  I really appreciate it.

Can you see if this helps? Untested...


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3d5fc76b92d0..35af489bcaf6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -125,6 +125,9 @@ struct io_wq {
 	refcount_t refs;
 	struct completion done;
 
+	atomic_t worker_refs;
+	struct completion worker_done;
+
 	struct hlist_node cpuhp_node;
 
 	refcount_t use_refs;
@@ -250,8 +253,8 @@ static void io_worker_exit(struct io_worker *worker)
 	raw_spin_unlock_irq(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
-	if (refcount_dec_and_test(&wqe->wq->refs))
-		complete(&wqe->wq->done);
+	if (atomic_dec_and_test(&wqe->wq->worker_refs))
+		complete(&wqe->wq->worker_done);
 }
 
 static inline bool io_wqe_run_queue(struct io_wqe *wqe)
@@ -695,9 +698,13 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	worker->wqe = wqe;
 	spin_lock_init(&worker->lock);
 
+	atomic_inc(&wq->worker_refs);
+
 	worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
 				"io_wqe_worker-%d/%d", index, wqe->node);
 	if (IS_ERR(worker->task)) {
+		if (atomic_dec_and_test(&wq->worker_refs))
+			complete(&wq->worker_done);
 		kfree(worker);
 		return false;
 	}
@@ -717,7 +724,6 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
 
-	refcount_inc(&wq->refs);
 	wake_up_process(worker->task);
 	return true;
 }
@@ -822,17 +828,18 @@ static int io_wq_manager(void *data)
 		task_work_run();
 
 out:
-	if (refcount_dec_and_test(&wq->refs)) {
-		complete(&wq->done);
-		return 0;
-	}
 	/* if ERROR is set and we get here, we have workers to wake */
-	if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
-		rcu_read_lock();
-		for_each_node(node)
-			io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-		rcu_read_unlock();
-	}
+	rcu_read_lock();
+	for_each_node(node)
+		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+	rcu_read_unlock();
+
+	if (atomic_read(&wq->worker_refs))
+		wait_for_completion(&wq->worker_done);
+
+	if (refcount_dec_and_test(&wq->refs))
+		complete(&wq->done);
+
 	return 0;
 }
 
@@ -1135,6 +1142,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	init_completion(&wq->done);
 
+	init_completion(&wq->worker_done);
+	atomic_set(&wq->worker_refs, 0);
+
 	wq->manager = kthread_create(io_wq_manager, wq, "io_wq_manager");
 	if (!IS_ERR(wq->manager)) {
 		wake_up_process(wq->manager);
@@ -1179,11 +1189,6 @@ static void __io_wq_destroy(struct io_wq *wq)
 	if (wq->manager)
 		kthread_stop(wq->manager);
 
-	rcu_read_lock();
-	for_each_node(node)
-		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	rcu_read_unlock();
-
 	wait_for_completion(&wq->done);
 
 	for_each_node(node)


-- 
Jens Axboe

