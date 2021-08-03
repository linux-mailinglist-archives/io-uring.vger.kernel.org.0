Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD733DF603
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 21:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhHCTyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 15:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240269AbhHCTyH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 15:54:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40620C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 12:53:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a8so8066836pjk.4
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 12:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tlr6DmqLMQjRkkqTQlUgZkhCgcYE4aKRWByNvhANosE=;
        b=xYXVP9T+eV4xYwvXP75TJ409hMMeMqVYkr+7UuwDWBqxx3LW2BamGWKEKiEhzGngzE
         s9dI2a/HLKWvoyHFH40hXq2+UMtfzlxzLiPyCnhmYbxQ4pV2BlAPIZUBS9enCI0RLwV9
         6Nr7PVc8ooHBYQiHNa90koqLEchYXpdAA/GVANHBWZiUecNLtasikJzivsQuSmZ8w8Kr
         vQSKK1vBBnv3tgjOEA5Jdv5gctk+mg8eMZG2Rk7uCwdxph1pHlswcct3DMqPhoKv+oeP
         kRZ5qC3LfnKxKIAz1XExDN5dshyg1zabGcdz6FDykOUQ6sMuA+khUT/XFBOjmQTrpJNE
         BTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tlr6DmqLMQjRkkqTQlUgZkhCgcYE4aKRWByNvhANosE=;
        b=cnplakDILbRJ/zMKBE75MnJ+VzHSp7mqMY947tYDICv9LpupmDnPV+rF02OmfRarjm
         Qalupp2mQeahGKg8QrRu4riyeLjLJx+TtKpNj56BH7TWGVi5+KiXLprL5SkHIJTXJgTA
         f+wqGUHpKqy14UGpm06GQGBoNy+LvnFOGwDzs+xS6zWhnlLgusK1jkQsAizB4Z7oDex2
         8Zd204xMbV2+ejP+p7qBUUf4hh/D1JaJp1TPregp1dty+cG4tL/wSZKedh3xCzMpgXce
         RR3R+xb3C5BU+5QlcrESYFFs1rNlXoRAG322AQvF5lw8NCHKSguPco1Pzmm8+Z4I4L8m
         Omtg==
X-Gm-Message-State: AOAM531BIeAk8OizKdzCY+6NHMAWUqeMFZYNRf2+21iCBHza4U6IpdV3
        1zvgk95USk9lMhBFDCmyf82eu+Dmsw5Q/TFn
X-Google-Smtp-Source: ABdhPJzY8Q1fhy+qaCNft8faqTMiR8qX7XYB1sl5c1mYklJ9sGLYCjl/ueGh0+pJXzgnoP9GPL5+7A==
X-Received: by 2002:a17:90a:ff03:: with SMTP id ce3mr5940083pjb.232.1628020435421;
        Tue, 03 Aug 2021 12:53:55 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id f18sm17195pfe.25.2021.08.03.12.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:53:55 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
From:   Jens Axboe <axboe@kernel.dk>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
 <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
 <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
 <5f574edb-86ca-2584-dd40-b25fa7bf0517@kernel.dk>
Message-ID: <6b51481c-c45e-adf4-51ed-7f7fe927e6b9@kernel.dk>
Date:   Tue, 3 Aug 2021 13:53:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5f574edb-86ca-2584-dd40-b25fa7bf0517@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 1:24 PM, Jens Axboe wrote:
> On 8/3/21 1:20 PM, Nadav Amit wrote:
>>
>>
>>> On Aug 3, 2021, at 11:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 8/3/21 12:04 PM, Nadav Amit wrote:
>>>>
>>>>
>>>> Thanks for the quick response.
>>>>
>>>> I tried you version. It works better, but my workload still gets stuck
>>>> occasionally (less frequently though). It is pretty obvious that the
>>>> version you sent still has a race, so I didn’t put the effort into
>>>> debugging it.
>>>
>>> All good, thanks for testing! Is it a test case you can share? Would
>>> help with confidence in the final solution.
>>
>> Unfortunately no, since it is an entire WIP project that I am working
>> on (with undetermined license at this point). But I will be happy to
>> test any solution that you provide.
> 
> OK no worries, I'll see if I can tighten this up. I don't particularly
> hate your solution, it would just be nice to avoid creating a new worker
> if we can just keep running the current one.
> 
> I'll toss something your way in a bit...

How about this? I think this largely stems from the fact that we only
do a partial running decrement on exit. Left the previous checks in
place as well, as it will reduce the amount of times that we do need
to hit that case.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index cf086b01c6c6..f072995d382b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -35,12 +35,17 @@ enum {
 	IO_WQE_FLAG_STALLED	= 1,	/* stalled on hash */
 };
 
+enum {
+	IO_WORKER_EXITING	= 0,	/* worker is exiting */
+};
+
 /*
  * One for each thread in a wqe pool
  */
 struct io_worker {
 	refcount_t ref;
 	unsigned flags;
+	unsigned long state;
 	struct hlist_nulls_node nulls_node;
 	struct list_head all_list;
 	struct task_struct *task;
@@ -130,6 +135,7 @@ struct io_cb_cancel_data {
 };
 
 static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -168,26 +174,21 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	unsigned flags;
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
 	wait_for_completion(&worker->ref_done);
 
-	preempt_disable();
-	current->flags &= ~PF_IO_WORKER;
-	flags = worker->flags;
-	worker->flags = 0;
-	if (flags & IO_WORKER_F_RUNNING)
-		atomic_dec(&acct->nr_running);
-	worker->flags = 0;
-	preempt_enable();
-
 	raw_spin_lock_irq(&wqe->lock);
-	if (flags & IO_WORKER_F_FREE)
+	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	acct->nr_workers--;
+	preempt_disable();
+	io_wqe_dec_running(worker);
+	worker->flags = 0;
+	current->flags &= ~PF_IO_WORKER;
+	preempt_enable();
 	raw_spin_unlock_irq(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
@@ -214,15 +215,20 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	struct hlist_nulls_node *n;
 	struct io_worker *worker;
 
-	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
-	if (is_a_nulls(n))
-		return false;
-
-	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
-	if (io_worker_get(worker)) {
-		wake_up_process(worker->task);
+	/*
+	 * Iterate free_list and see if we can find an idle worker to
+	 * activate. If a given worker is on the free_list but in the process
+	 * of exiting, keep trying.
+	 */
+	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+		if (!io_worker_get(worker))
+			continue;
+		if (!test_bit(IO_WORKER_EXITING, &worker->state)) {
+			wake_up_process(worker->task);
+			io_worker_release(worker);
+			return true;
+		}
 		io_worker_release(worker);
-		return true;
 	}
 
 	return false;
@@ -560,8 +566,17 @@ static int io_wqe_worker(void *data)
 		if (ret)
 			continue;
 		/* timed out, exit unless we're the fixed worker */
-		if (!(worker->flags & IO_WORKER_F_FIXED))
+		if (!(worker->flags & IO_WORKER_F_FIXED)) {
+			/*
+			 * Someone elevated our refs, which could be trying
+			 * to re-activate for work. Loop one more time for
+			 * that case.
+			 */
+			if (refcount_read(&worker->ref) != 1)
+				continue;
+			set_bit(IO_WORKER_EXITING, &worker->state);
 			break;
+		}
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {

-- 
Jens Axboe

