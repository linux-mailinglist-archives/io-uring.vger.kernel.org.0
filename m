Return-Path: <io-uring+bounces-6330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF888A2D8B2
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 21:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD4733A4E3A
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 20:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6413318C011;
	Sat,  8 Feb 2025 20:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RJIwAaxi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f226.google.com (mail-il1-f226.google.com [209.85.166.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AE6243946
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 20:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739047347; cv=none; b=tM4AvNeECv1aVNb/0wGfKLPNq9odyfUNNflhmEC2GO+Dzo5cI7ifpon/kd7Qfm2rBSyXWycJCK+qHb2ZTLASSp5dE2up+f/vEY0P8ErAwvLBkSJUvMojGpicmoPDgGo3lFMPWaMni7QpNEUAMslHv4iEjTEDbkrOquUi2m7VMag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739047347; c=relaxed/simple;
	bh=3kK5Hxyr/aJhwGzAFiwDO5Kz9JZ+xPTsz1vD21g4Vz8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Tl8wDvjQClDEzW+GgSJn8DdGWZo4r8kWqlU5DsoO1vdvRFiO7hjClEvinoO8nnHCB3xM8Py1RwWCB00xDlDV7sB9ZdkdE6bia29taxBWl02mdencS0DlJgh67bxbwNFUXqCAKQn/bqJOhzg/ea9VeRIq++mBR9xhsnzhlTCxSJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RJIwAaxi; arc=none smtp.client-ip=209.85.166.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f226.google.com with SMTP id e9e14a558f8ab-3d0558c61f4so10428935ab.0
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2025 12:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739047344; x=1739652144; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vkSDcudyQNBFX7vkCWwUHhcJCg0qiHa5NHkG+m9azLM=;
        b=RJIwAaxijCpU3XjOPBl9hLn7OD17CB7P+wmOg29PcCPBQGw0BkKJAddx1mhzN/rh+F
         4ACCDg9xDWhSxx9prJbiEXxYBXPCAIolP/pTf0gf8BX/IkOkwcy2KJhQZW4f2dK0g6Dm
         S+ZCLHx18SDW5O2vTdgJE5fG7p0u9p7wfe76tyXcaPVmjjEQkx9sMlO5N01qOfmt5zhk
         NP3icfxbKaV7JcJ2JnkQQxTIFdCTly2DM30mkY5iGl5Id1jL49LZJYUKAN2HrtLVmFND
         bHtXEpfNPoZMf1VQ47SXG2Qz6A4bMIeckI6HBCRXKK/RmR5gsrun1+lW/5HLbFts0v77
         iNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739047344; x=1739652144;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vkSDcudyQNBFX7vkCWwUHhcJCg0qiHa5NHkG+m9azLM=;
        b=QKqmikjsCeqKmP4gWTC6axZoy82GV/1A/ZVLSCr+nVhU98aizjLmR+h89Qd0G4bcqw
         5DN99BcL/AZT/mNTQ3sLx9Zq660n8Cl9Vm0v4pxOIHnO0SpJ2SyRB9K7WRzdl01rCaZ4
         lLA/nrk/0sYOaEjiphpC36TN0PMMssnEmo5ASjVLHUjyCOeVmdQfsoaF6bKAa2C07XRy
         l2OtXjjnggYO2KwT8INF2gtcUYJZ7VHOABdB/xB2eM7Sab8vWpX4Fw2IUbgecweUYYBg
         7RTP6GhYrrdLecslYt/2NoaBSWkeBgGh8+eKLPbXhOCg485VmbeABOR3SVCrw1dVYSMD
         O+Dw==
X-Gm-Message-State: AOJu0Yyo/YsIKaf3pDLF6v6qVrRv+3tJEhn1Mzybp6v8cFqy5nSA3h/Q
	qooLnSQ7AK7lyE1HpaQYY2cvneJNI2upfT76mw/gU03ZQfS8XH0Ndvyg4+F/J807L7rGL12JzNc
	w9k3ogCfF8odInK8mTulpVE8Y2TGsHpwCiIFBRjvl+i8d4bJD
X-Gm-Gg: ASbGncubFmzfhIybFFxUgSuauL/6pt8WCT728zegnAQO6P9AUTMHrb+q+nBqEZ0WNwt
	dVySUfvuUQteOxSpOQV8+s6spUWU5Ok1Xrak0ihb5OBbTER/uPfAzyZr0ob0nCMcZjEikzbmxUc
	qm8zIAadCROj2Toktth+qJ8Yrq8w2bw4+P9akh5zKZFVzHmfQMLjNpIgl1mi2bwYf/yBkDs0Evi
	MFSsVrCgSLCFcr3tofxQtYrMb5UM29eM/s5u/X9mE4TeXwpcEORlwdw09pt2NZg+ArCWnkIGm98
	ysYm7Ei/bvXtFjUiexh45Gd6
X-Google-Smtp-Source: AGHT+IFUi4uCtAlJRkwCDylnYJezEGgITa4jrO4HAqZTF3OZwWV0ZbBQgulJF0FBlhO5zHEKEWpFDUzzUfV2
X-Received: by 2002:a92:cf44:0:b0:3d1:4747:f387 with SMTP id e9e14a558f8ab-3d14747fbe8mr38164155ab.0.1739047344166;
        Sat, 08 Feb 2025 12:42:24 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d05e6d7213sm4357605ab.0.2025.02.08.12.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2025 12:42:24 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [IPv6:2620:125:9007:640:7:70:36:0])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5FC933402F6;
	Sat,  8 Feb 2025 13:42:22 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id 511B9E55B0C; Sat,  8 Feb 2025 13:42:22 -0700 (MST)
From: Uday Shankar <ushankar@purestorage.com>
Date: Sat, 08 Feb 2025 13:42:13 -0700
Subject: [PATCH v2] io-wq: backoff when retrying worker creation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
X-B4-Tracking: v=1; b=H4sIAKTBp2cC/22MwQ6DIBAFf8XsuTRAA4ae+h+NaRQW5VC1i6U1h
 n8veu5xXt7MBhEpYIRrtQFhCjFMYwF5qsAO7dgjC64wSC4Vl1yzz+tBuNDKhO1qr6wwF+Wg3Gd
 CH75H6t4UHkJcJlqPchL7+ieSBBNMu9p0DgVq42/zm3AX2x7PdnpCk3P+Aaoo/w2mAAAA
X-Change-ID: 20250206-wq_retry-1cb7f5c1935d
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>
X-Mailer: b4 0.14.2

When io_uring submission goes async for the first time on a given task,
we'll try to create a worker thread to handle the submission. Creating
this worker thread can fail due to various transient conditions, such as
an outstanding signal in the forking thread, so we have retry logic with
a limit of 3 retries. However, this retry logic appears to be too
aggressive/fast - we've observed a thread blowing through the retry
limit while having the same outstanding signal the whole time. Here's an
excerpt of some tracing that demonstrates the issue:

First, signal 26 is generated for the process. It ends up getting routed
to thread 92942.

 0)   cbd-92284    /* signal_generate: sig=26 errno=0 code=-2 comm=psblkdASD pid=92934 grp=1 res=0 */

This causes create_io_thread in the signalled thread to fail with
ERESTARTNOINTR, and thus a retry is queued.

13) task_th-92942  /* io_uring_queue_async_work: ring 000000007325c9ae, request 0000000080c96d8e, user_data 0x0, opcode URING_CMD, flags 0x8240001, normal queue, work 000000006e96dd3f */
13) task_th-92942  io_wq_enqueue() {
13) task_th-92942    _raw_spin_lock();
13) task_th-92942    io_wq_activate_free_worker();
13) task_th-92942    _raw_spin_lock();
13) task_th-92942    create_io_worker() {
13) task_th-92942      __kmalloc_cache_noprof();
13) task_th-92942      __init_swait_queue_head();
13) task_th-92942      kprobe_ftrace_handler() {
13) task_th-92942        get_kprobe();
13) task_th-92942        aggr_pre_handler() {
13) task_th-92942          pre_handler_kretprobe();
13) task_th-92942          /* create_enter: (create_io_thread+0x0/0x50) fn=0xffffffff8172c0e0 arg=0xffff888996bb69c0 node=-1 */
13) task_th-92942        } /* aggr_pre_handler */
...
13) task_th-92942        } /* copy_process */
13) task_th-92942      } /* create_io_thread */
13) task_th-92942      kretprobe_rethook_handler() {
13) task_th-92942        /* create_exit: (create_io_worker+0x8a/0x1a0 <- create_io_thread) arg1=0xfffffffffffffdff */
13) task_th-92942      } /* kretprobe_rethook_handler */
13) task_th-92942    queue_work_on() {
...

The CPU is then handed to a kworker to process the queued retry:

------------------------------------------
 13) task_th-92942  => kworker-54154
------------------------------------------
13) kworker-54154  io_workqueue_create() {
13) kworker-54154    io_queue_worker_create() {
13) kworker-54154      task_work_add() {
13) kworker-54154        wake_up_state() {
13) kworker-54154          try_to_wake_up() {
13) kworker-54154            _raw_spin_lock_irqsave();
13) kworker-54154            _raw_spin_unlock_irqrestore();
13) kworker-54154          } /* try_to_wake_up */
13) kworker-54154        } /* wake_up_state */
13) kworker-54154        kick_process();
13) kworker-54154      } /* task_work_add */
13) kworker-54154    } /* io_queue_worker_create */
13) kworker-54154  } /* io_workqueue_create */

And then we immediately switch back to the original task to try creating
a worker again. This fails, because the original task still hasn't
handled its signal.

-----------------------------------------
 13) kworker-54154  => task_th-92942
------------------------------------------
13) task_th-92942  create_worker_cont() {
13) task_th-92942    kprobe_ftrace_handler() {
13) task_th-92942      get_kprobe();
13) task_th-92942      aggr_pre_handler() {
13) task_th-92942        pre_handler_kretprobe();
13) task_th-92942        /* create_enter: (create_io_thread+0x0/0x50) fn=0xffffffff8172c0e0 arg=0xffff888996bb69c0 node=-1 */
13) task_th-92942      } /* aggr_pre_handler */
13) task_th-92942    } /* kprobe_ftrace_handler */
13) task_th-92942    create_io_thread() {
13) task_th-92942      copy_process() {
13) task_th-92942        task_active_pid_ns();
13) task_th-92942        _raw_spin_lock_irq();
13) task_th-92942        recalc_sigpending();
13) task_th-92942        _raw_spin_lock_irq();
13) task_th-92942      } /* copy_process */
13) task_th-92942    } /* create_io_thread */
13) task_th-92942    kretprobe_rethook_handler() {
13) task_th-92942      /* create_exit: (create_worker_cont+0x35/0x1b0 <- create_io_thread) arg1=0xfffffffffffffdff */
13) task_th-92942    } /* kretprobe_rethook_handler */
13) task_th-92942    io_worker_release();
13) task_th-92942    queue_work_on() {
13) task_th-92942      clear_pending_if_disabled();
13) task_th-92942      __queue_work() {
13) task_th-92942      } /* __queue_work */
13) task_th-92942    } /* queue_work_on */
13) task_th-92942  } /* create_worker_cont */

The pattern repeats another couple times until we blow through the retry
counter, at which point we give up. All outstanding work is canceled,
and the io_uring command which triggered all this is failed with
ECANCELED:

13) task_th-92942  io_acct_cancel_pending_work() {
...
13) task_th-92942  /* io_uring_complete: ring 000000007325c9ae, req 0000000080c96d8e, user_data 0x0, result -125, cflags 0x0 extra1 0 extra2 0  */

Finally, the task gets around to processing its outstanding signal 26,
but it's too late.

13) task_th-92942  /* signal_deliver: sig=26 errno=0 code=-2 sa_handler=59566a0 sa_flags=14000000 */

Try to address this issue by adding a small scaling delay when retrying
worker creation. This should give the forking thread time to handle its
signal in the above case. This isn't a particularly satisfying solution,
as sufficiently paradoxical scheduling would still have us hitting the
same issue, and I'm open to suggestions for something better. But this
is likely to prevent this (already rare) issue from hitting in practice.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
---
Changes in v2:
- Indentation fixes (Jens Axboe)
- Link to v1: https://lore.kernel.org/r/20250206-wq_retry-v1-1-6d79bde1e69f@purestorage.com
---
 io_uring/io-wq.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f7d328feb7225d809601707e423c86a85ebb1c3c..04a75d66619510211ed36711327a513835224fd9 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -63,7 +63,7 @@ struct io_worker {
 
 	union {
 		struct rcu_head rcu;
-		struct work_struct work;
+		struct delayed_work work;
 	};
 };
 
@@ -784,6 +784,18 @@ static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 	}
 }
 
+static void queue_create_worker_retry(struct io_worker *worker)
+{
+	/*
+	 * We only bother retrying because there's a chance that the
+	 * failure to create a worker is due to some temporary condition
+	 * in the forking task (e.g. outstanding signal); give the task
+	 * some time to clear that condition.
+	 */
+	schedule_delayed_work(&worker->work,
+			      msecs_to_jiffies(worker->init_retries * 5));
+}
+
 static void create_worker_cont(struct callback_head *cb)
 {
 	struct io_worker *worker;
@@ -823,12 +835,13 @@ static void create_worker_cont(struct callback_head *cb)
 
 	/* re-create attempts grab a new worker ref, drop the existing one */
 	io_worker_release(worker);
-	schedule_work(&worker->work);
+	queue_create_worker_retry(worker);
 }
 
 static void io_workqueue_create(struct work_struct *work)
 {
-	struct io_worker *worker = container_of(work, struct io_worker, work);
+	struct io_worker *worker = container_of(work, struct io_worker,
+						work.work);
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	if (!io_queue_worker_create(worker, acct, create_worker_cont))
@@ -866,8 +879,8 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 		kfree(worker);
 		goto fail;
 	} else {
-		INIT_WORK(&worker->work, io_workqueue_create);
-		schedule_work(&worker->work);
+		INIT_DELAYED_WORK(&worker->work, io_workqueue_create);
+		queue_create_worker_retry(worker);
 	}
 
 	return true;

---
base-commit: ec4ef55172d4539abff470568a4369a6e1c317b8
change-id: 20250206-wq_retry-1cb7f5c1935d

Best regards,
-- 
Uday Shankar <ushankar@purestorage.com>


