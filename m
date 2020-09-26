Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B60E279BE2
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 20:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgIZSf5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 14:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZSf4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 14:35:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C4C0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 11:35:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d19so1127398pld.0
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 11:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w5kVvmGe2Xwz2eVnmNj+YCW9Kx9XZ7HdatC4wyGdito=;
        b=BKB15pPicLXqvhcK97vsToWCGSeAdyqmWfE2bnXldaWY73JLfa+mQLEWLMJTrdJmjz
         3yyaRXWEduQ7OHpq1FDrozrzpywI/8nKjkxfN5cZktJrWs4o2e1WjYbdSfLz6nky3/ro
         jspk30yni2BF2PvCzt10NhFQfxxTOSBEqhFDpQqi71mY41VJHoF6Rs6eCw7f0Yv2FDk2
         yvxk6E9xqr/qx6LraWY7gSTcWC/lYHQDXIBDd/SUAW86CRXWdTrEkiBFs+UkWJ1tckk9
         4nyAckHWh9q/+JIy0bhKhJroKvDLR+yn1wf5YHX7zr+8QFObgCVHuJnTk7Zvj6Rc1lkO
         cD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5kVvmGe2Xwz2eVnmNj+YCW9Kx9XZ7HdatC4wyGdito=;
        b=Zbwc32r873r8TUcs+ZJDxzndePnlik6uNJkopJM5GCFeHjuQfh9vVXK9CZ+1tkrnEe
         j0MJfhAqF463pfBbn5WcmiiXUOsa/nFpD4WCX++ysKOUqlIvnzJKAnP6pkVpSbXSnpKn
         vH7PWJ1bHk8jDC0Bbo3qS9ky21carn+2IYex2AehWuxDiYCZE0tSiitAMlmv/qpVFruJ
         394o4xNqRPMMqiQJKaNS9V6tstItc7hZkJSfXjEewVrOljJ+lXpYnO0M2qveLFrmB2Ws
         PyrhDzeevHwq80UtJLcbolldaByPru/uvvFTn1aLmDjgFGypdz4qpXTddOXdQ57jLENf
         moSQ==
X-Gm-Message-State: AOAM53107gChm9dO6ncGtcmG7BpuHXH4ES+eGEIB5N21Z2IruQ1cPWpL
        OcZ2jg9iU6DtWj9v169mDHVI0w==
X-Google-Smtp-Source: ABdhPJzsq4QiZVJO8VoayArCCpkOVLhvCEMYvMT283ZN+5L6yGJfakD8dcTQNO0UQe/W5Cva2Rlvcg==
X-Received: by 2002:a17:90a:6a0d:: with SMTP id t13mr3048547pjj.208.1601145355884;
        Sat, 26 Sep 2020 11:35:55 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p6sm6352900pfn.63.2020.09.26.11.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 11:35:55 -0700 (PDT)
Subject: Re: [PATCH next] io-wq: fix use-after-free in io_wq_worker_running
From:   Jens Axboe <axboe@kernel.dk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com,
        syzbot+9af99580130003da82b1@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200926132655.6192-1-hdanton@sina.com>
 <1ac425e8-f302-4e91-0c1d-3ebb0a40cf96@kernel.dk>
Message-ID: <515725f2-5932-4735-17d7-6bfddaa61512@kernel.dk>
Date:   Sat, 26 Sep 2020 12:35:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ac425e8-f302-4e91-0c1d-3ebb0a40cf96@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/20 12:07 PM, Jens Axboe wrote:
> On 9/26/20 7:26 AM, Hillf Danton wrote:
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -200,7 +200,6 @@ static void io_worker_exit(struct io_wor
>>  {
>>  	struct io_wqe *wqe = worker->wqe;
>>  	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
>> -	unsigned nr_workers;
>>  
>>  	/*
>>  	 * If we're not at zero, someone else is holding a brief reference
>> @@ -228,15 +227,11 @@ static void io_worker_exit(struct io_wor
>>  		raw_spin_lock_irq(&wqe->lock);
>>  	}
>>  	acct->nr_workers--;
>> -	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
>> -			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
>>  	raw_spin_unlock_irq(&wqe->lock);
>>  
>> -	/* all workers gone, wq exit can proceed */
>> -	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
>> -		complete(&wqe->wq->done);
>> -
>>  	kfree_rcu(worker, rcu);
>> +	if (refcount_dec_and_test(&wqe->wq->refs))
>> +		complete(&wqe->wq->done);
>>  }
> 
> Nice, we came up with the same fix, thanks a lot for looking into this.
> I pushed this one out for syzbot to test:
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=41d5f92f60a61e264dafbada79175dad0bc60c5b
> 
> which is basically identical. I did consider the EXIT check as well, but
> we don't really need it, so I'd prefer to leave that out of it.
> 
> I'll queue yours up.

I made some edits - some cleanups, but also for the error handling case
of failing to create a worker that isn't the first one.

This is my current version, let me know if you are fine with this one.


commit a6f353e50fb3cd78aae98277cfc34aa25831fff1
Author: Hillf Danton <hdanton@sina.com>
Date:   Sat Sep 26 21:26:55 2020 +0800

    io-wq: fix use-after-free in io_wq_worker_running
    
    The smart syzbot has found a reproducer for the following issue:
    
     ==================================================================
     BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
     BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
     BUG: KASAN: use-after-free in io_wqe_inc_running fs/io-wq.c:301 [inline]
     BUG: KASAN: use-after-free in io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
     Write of size 4 at addr ffff8882183db08c by task io_wqe_worker-0/7771
    
     CPU: 0 PID: 7771 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc4-syzkaller #0
     Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
     Call Trace:
      __dump_stack lib/dump_stack.c:77 [inline]
      dump_stack+0x198/0x1fd lib/dump_stack.c:118
      print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
      __kasan_report mm/kasan/report.c:513 [inline]
      kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
      check_memory_region_inline mm/kasan/generic.c:186 [inline]
      check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
      instrument_atomic_write include/linux/instrumented.h:71 [inline]
      atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
      io_wqe_inc_running fs/io-wq.c:301 [inline]
      io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
      schedule_timeout+0x148/0x250 kernel/time/timer.c:1879
      io_wqe_worker+0x517/0x10e0 fs/io-wq.c:580
      kthread+0x3b5/0x4a0 kernel/kthread.c:292
      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
    
     Allocated by task 7768:
      kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
      kasan_set_track mm/kasan/common.c:56 [inline]
      __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
      kmem_cache_alloc_node_trace+0x17b/0x3f0 mm/slab.c:3594
      kmalloc_node include/linux/slab.h:572 [inline]
      kzalloc_node include/linux/slab.h:677 [inline]
      io_wq_create+0x57b/0xa10 fs/io-wq.c:1064
      io_init_wq_offload fs/io_uring.c:7432 [inline]
      io_sq_offload_start fs/io_uring.c:7504 [inline]
      io_uring_create fs/io_uring.c:8625 [inline]
      io_uring_setup+0x1836/0x28e0 fs/io_uring.c:8694
      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
      entry_SYSCALL_64_after_hwframe+0x44/0xa9
    
     Freed by task 21:
      kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
      kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
      kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
      __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
      __cache_free mm/slab.c:3418 [inline]
      kfree+0x10e/0x2b0 mm/slab.c:3756
      __io_wq_destroy fs/io-wq.c:1138 [inline]
      io_wq_destroy+0x2af/0x460 fs/io-wq.c:1146
      io_finish_async fs/io_uring.c:6836 [inline]
      io_ring_ctx_free fs/io_uring.c:7870 [inline]
      io_ring_exit_work+0x1e4/0x6d0 fs/io_uring.c:7954
      process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
      worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
      kthread+0x3b5/0x4a0 kernel/kthread.c:292
      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
    
     The buggy address belongs to the object at ffff8882183db000
      which belongs to the cache kmalloc-1k of size 1024
     The buggy address is located 140 bytes inside of
      1024-byte region [ffff8882183db000, ffff8882183db400)
     The buggy address belongs to the page:
     page:000000009bada22b refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2183db
     flags: 0x57ffe0000000200(slab)
     raw: 057ffe0000000200 ffffea0008604c48 ffffea00086a8648 ffff8880aa040700
     raw: 0000000000000000 ffff8882183db000 0000000100000002 0000000000000000
     page dumped because: kasan: bad access detected
    
     Memory state around the buggy address:
      ffff8882183daf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
      ffff8882183db000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     >ffff8882183db080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                           ^
      ffff8882183db100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
      ffff8882183db180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ==================================================================
    
    which is down to the comment below,
    
            /* all workers gone, wq exit can proceed */
            if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
                    complete(&wqe->wq->done);
    
    because there might be multiple cases of wqe in a wq and we would wait
    for every worker in every wqe to go home before releasing wq's resources
    on destroying.
    
    To that end, rework wq's refcount by making it independent of the tracking
    of workers because after all they are two different things, and keeping
    it balanced when workers come and go. Note the manager kthread, like
    other workers, now holds a grab to wq during its lifetime.
    
    Finally to help destroy wq, check IO_WQ_BIT_EXIT upon creating worker
    and do nothing for exiting wq.
    
    Cc: stable@vger.kernel.org # v5.5+
    Reported-by: syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com
    Reported-by: syzbot+9af99580130003da82b1@syzkaller.appspotmail.com
    Cc: Pavel Begunkov <asml.silence@gmail.com>
    Signed-off-by: Hillf Danton <hdanton@sina.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1be0d70f8673..98f9c74b25d2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -213,7 +213,6 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
-	unsigned nr_workers;
 
 	/*
 	 * If we're not at zero, someone else is holding a brief reference
@@ -241,15 +240,11 @@ static void io_worker_exit(struct io_worker *worker)
 		raw_spin_lock_irq(&wqe->lock);
 	}
 	acct->nr_workers--;
-	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
-			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
 	raw_spin_unlock_irq(&wqe->lock);
 
-	/* all workers gone, wq exit can proceed */
-	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
-		complete(&wqe->wq->done);
-
 	kfree_rcu(worker, rcu);
+	if (refcount_dec_and_test(&wqe->wq->refs))
+		complete(&wqe->wq->done);
 }
 
 static inline bool io_wqe_run_queue(struct io_wqe *wqe)
@@ -664,7 +659,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
-	struct io_wqe_acct *acct =&wqe->acct[index];
+	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
 
 	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
@@ -697,6 +692,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
 
+	refcount_inc(&wq->refs);
 	wake_up_process(worker->task);
 	return true;
 }
@@ -712,28 +708,63 @@ static inline bool io_wqe_need_worker(struct io_wqe *wqe, int index)
 	return acct->nr_workers < acct->max_workers;
 }
 
+static bool io_wqe_worker_send_sig(struct io_worker *worker, void *data)
+{
+	send_sig(SIGINT, worker->task, 1);
+	return false;
+}
+
+/*
+ * Iterate the passed in list and call the specific function for each
+ * worker that isn't exiting
+ */
+static bool io_wq_for_each_worker(struct io_wqe *wqe,
+				  bool (*func)(struct io_worker *, void *),
+				  void *data)
+{
+	struct io_worker *worker;
+	bool ret = false;
+
+	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
+		if (io_worker_get(worker)) {
+			/* no task if node is/was offline */
+			if (worker->task)
+				ret = func(worker, data);
+			io_worker_release(worker);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static bool io_wq_worker_wake(struct io_worker *worker, void *data)
+{
+	wake_up_process(worker->task);
+	return false;
+}
+
 /*
  * Manager thread. Tasked with creating new workers, if we need them.
  */
 static int io_wq_manager(void *data)
 {
 	struct io_wq *wq = data;
-	int workers_to_create = num_possible_nodes();
 	int node;
 
 	/* create fixed workers */
-	refcount_set(&wq->refs, workers_to_create);
+	refcount_set(&wq->refs, 1);
 	for_each_node(node) {
 		if (!node_online(node))
 			continue;
-		if (!create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
-			goto err;
-		workers_to_create--;
+		if (create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
+			continue;
+		set_bit(IO_WQ_BIT_ERROR, &wq->state);
+		set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		goto out;
 	}
 
-	while (workers_to_create--)
-		refcount_dec(&wq->refs);
-
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
@@ -765,12 +796,18 @@ static int io_wq_manager(void *data)
 	if (current->task_works)
 		task_work_run();
 
-	return 0;
-err:
-	set_bit(IO_WQ_BIT_ERROR, &wq->state);
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (refcount_sub_and_test(workers_to_create, &wq->refs))
+out:
+	if (refcount_dec_and_test(&wq->refs)) {
 		complete(&wq->done);
+		return 0;
+	}
+	/* if ERROR is set and we get here, we have workers to wake */
+	if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
+		rcu_read_lock();
+		for_each_node(node)
+			io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+		rcu_read_unlock();
+	}
 	return 0;
 }
 
@@ -877,37 +914,6 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
 }
 
-static bool io_wqe_worker_send_sig(struct io_worker *worker, void *data)
-{
-	send_sig(SIGINT, worker->task, 1);
-	return false;
-}
-
-/*
- * Iterate the passed in list and call the specific function for each
- * worker that isn't exiting
- */
-static bool io_wq_for_each_worker(struct io_wqe *wqe,
-				  bool (*func)(struct io_worker *, void *),
-				  void *data)
-{
-	struct io_worker *worker;
-	bool ret = false;
-
-	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
-		if (io_worker_get(worker)) {
-			/* no task if node is/was offline */
-			if (worker->task)
-				ret = func(worker, data);
-			io_worker_release(worker);
-			if (ret)
-				break;
-		}
-	}
-
-	return ret;
-}
-
 void io_wq_cancel_all(struct io_wq *wq)
 {
 	int node;
@@ -1140,12 +1146,6 @@ bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
 	return refcount_inc_not_zero(&wq->use_refs);
 }
 
-static bool io_wq_worker_wake(struct io_worker *worker, void *data)
-{
-	wake_up_process(worker->task);
-	return false;
-}
-
 static void __io_wq_destroy(struct io_wq *wq)
 {
 	int node;

-- 
Jens Axboe

