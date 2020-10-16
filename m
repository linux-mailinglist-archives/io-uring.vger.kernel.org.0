Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B529290BF0
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392769AbgJPS44 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 14:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390142AbgJPS44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 14:56:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1046AC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 11:56:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h4so2017720pjk.0
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 11:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LoT9oBdFaI9Ywn1tgaI4p34qYm9FPjhWjZO8MO5AP+4=;
        b=h56pwQXrOS+nikRKdT4feJmI7vaw+D17yp60CiGasZOUK8aqZt23fNXvsTy1NhULF4
         6sPDcAHr3z9vq8OeGOOHTqEiFv0OgcZsGzUQtEWyCUtqznlun1WnN/+AsbnifqOV6f4P
         Ho+l4QNDEr0DxG21qD7wVRT0/kcXQm9JwkRnhob0CJLanTqENhwe3UR4ZJqGKzrkwbxn
         gSFAgVJXKForgY9v2hGy+yACqnqIkm9yljosX2edOr1bSRMAgZaueEgGY9imZBf+VdEC
         0HN/0P2wghUzniU+X1/7ewLbjZnDdpajVpFOHSvn0sdlhLo9/54fmSZORATP/hm+en2e
         Nk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LoT9oBdFaI9Ywn1tgaI4p34qYm9FPjhWjZO8MO5AP+4=;
        b=Ylh4l04iqcRFJpneR4JDTpmxp8ShU+Yn/gIrd0QWLu/ZH1Adk7DmDDiXvCo2yaN0VS
         5IugwIr2MRp2i7Is0pk8WjpmimjqkEkSBzgSu2gyPRLv6m27uolUQPn+ts2OXl7NOym5
         4oxx4ZtuvqOgyQsHUh0Ro8ZSSDIninJi4q9DrU9CLUudTaq9xjgJPISux1q7kt3Lo0oZ
         mnXBNPW7olSjhP9E2MQ5TidpsyakPS96EHvxvzaC9PZX5TogP2QynYlCD/gWKutAQImP
         Yra94ZcBETQMKNCHICReFIru5ouXa/D0N3vIsmyWjMLuJyDFkWwlWE1IDucAzS9nhzvy
         qBag==
X-Gm-Message-State: AOAM5318bW5eQTK1tozfsuzdhGym7K0exdTXRrNIpeAWRmVv1PKDrtR1
        VaHKJwoVVy99Y34afs8PPn4JQ+i52KxkGMRa
X-Google-Smtp-Source: ABdhPJzuyHqQaZ5/O7NK5RizfsM8THx4HnoNQIPYETxYI/dYB7rbYVZozRVZ/lMx4lwmn7zowPlqcA==
X-Received: by 2002:a17:90a:c901:: with SMTP id v1mr5420378pjt.103.1602874613918;
        Fri, 16 Oct 2020 11:56:53 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x4sm3563441pfj.114.2020.10.16.11.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 11:56:53 -0700 (PDT)
Subject: Re: Samba with multichannel and io_uring
To:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
 <efb8b619-ca06-5c6b-e052-0c40b64b9904@kernel.dk>
 <6e7ea4e7-8ef7-9ad4-1377-08749f9bae0b@samba.org>
 <72a7edd7-3bc7-22ad-39be-fd2d4d567825@samba.org>
 <5e052fc2-a513-1f9b-d939-fc79ef41d96c@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82a9e2df-27ed-308e-7fa7-489bbb6a3ba3@kernel.dk>
Date:   Fri, 16 Oct 2020 12:56:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e052fc2-a513-1f9b-d939-fc79ef41d96c@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 6:40 AM, Stefan Metzmacher wrote:
> Am 16.10.20 um 14:28 schrieb Stefan Metzmacher via samba-technical:
>>> I just found that proc_task_name() handles PF_WQ_WORKER special
>>> and cat /proc/$pid/comm can expose something like:
>>>   kworker/u17:2-btrfs-worker-high
>>>
>>> ps and top still truncate, but that can be fixed.
>>
>> I commented on https://gitlab.com/procps-ng/procps/-/issues/51
> 
> Ok, it's already fixed in newer versions:
> https://gitlab.com/procps-ng/procps/-/commit/2cfdbbe897f0d4e41460c7c2b92acfc5804652c8
> 
> So it would be great to let proc_task_name() expose more verbose
> for io-wq tasks in order to avoid the limit of set_task_comm().

Here's a first cut, format is explained in the last hunk in io-wq.
We can't easily get the fd in there, so for sequence, it's just
an incrementing long. It shows up in fdinfo as well, so you can
match them up.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0c852b75384d..3e2cab10e6f3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -41,6 +41,8 @@ enum {
 	IO_WQE_FLAG_STALLED	= 1,	/* stalled on hash */
 };
 
+static atomic_long_t seq;
+
 /*
  * One for each thread in a wqe pool
  */
@@ -117,6 +119,8 @@ struct io_wq {
 	free_work_fn *free_work;
 	io_wq_work_fn *do_work;
 
+	long seq;
+
 	struct task_struct *manager;
 	struct user_struct *user;
 	refcount_t refs;
@@ -671,7 +675,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	spin_lock_init(&worker->lock);
 
 	worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
-				"io_wqe_worker-%d/%d", index, wqe->node);
+				"io_wq");
 	if (IS_ERR(worker->task)) {
 		kfree(worker);
 		return false;
@@ -1084,6 +1088,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
+	wq->seq = atomic_long_inc_return(&seq);
 
 	/* caller must already hold a reference to this */
 	wq->user = data->user;
@@ -1177,3 +1182,39 @@ struct task_struct *io_wq_get_task(struct io_wq *wq)
 {
 	return wq->manager;
 }
+
+long io_wq_get_seq(struct io_wq *wq)
+{
+	return wq ? wq->seq : 0;
+}
+
+void io_wq_comm(char *buf, size_t size, struct task_struct *task)
+{
+	struct io_worker *worker = kthread_data(task);
+	struct io_wqe *wqe;
+	int off;
+
+	off = strscpy(buf, task->comm, size);
+	if (off < 0)
+		return;
+
+	rcu_read_lock();
+	if (!io_worker_get(worker)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	spin_lock_irq(&worker->lock);
+	wqe = worker->wqe;
+
+	/*
+	 * Format: -seq-node-U/B for bound or unbound. Seq can be found in
+	 * the ring fd fdinfo as well.
+	 */
+	scnprintf(buf + off, size - off, "-%ld-%d%c%c", wqe->wq->seq, wqe->node,
+		worker->flags & IO_WORKER_F_RUNNING ? '+' : '-',
+		worker->flags & IO_WORKER_F_BOUND ? 'B' : 'U');
+	spin_unlock_irq(&worker->lock);
+	io_worker_release(worker);
+}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index be21c500c925..bede7ab5ac95 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -136,6 +136,7 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 					void *data, bool cancel_all);
 
 struct task_struct *io_wq_get_task(struct io_wq *wq);
+long io_wq_get_seq(struct io_wq *wq);
 
 #if defined(CONFIG_IO_WQ)
 extern void io_wq_worker_sleeping(struct task_struct *);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39c38e48dc11..83df6a326903 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8980,6 +8980,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 
 	seq_printf(m, "SqThread:\t%d\n", sq ? task_pid_nr(sq->thread) : -1);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
+	seq_printf(m, "WqSeq:\t%ld\n", io_wq_get_seq(ctx->io_wq));
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct fixed_file_table *table;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 65ec2029fa80..d8f8fbbe9639 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -91,6 +91,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/io_uring.h>
 
 #include <asm/processor.h>
 #include "internal.h"
@@ -104,6 +105,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
+	else if (p->flags & PF_IO_WORKER)
+		io_wq_comm(tcomm, sizeof(tcomm), p);
 	else
 		__get_task_comm(tcomm, sizeof(tcomm), p);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 28939820b6b0..507077f3dac9 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -34,6 +34,7 @@ struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
 void __io_uring_files_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
+void io_wq_comm(char *buf, size_t size, struct task_struct *task);
 
 static inline void io_uring_task_cancel(void)
 {
@@ -64,6 +65,9 @@ static inline void io_uring_files_cancel(struct files_struct *files)
 static inline void io_uring_free(struct task_struct *tsk)
 {
 }
+static inline void io_wq_comm(char *buf, size_t size, struct task_struct *task)
+{
+}
 #endif
 
 #endif

-- 
Jens Axboe

