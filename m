Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196C23FAC1B
	for <lists+io-uring@lfdr.de>; Sun, 29 Aug 2021 16:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhH2OHR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Aug 2021 10:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhH2OHQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Aug 2021 10:07:16 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8439C061575
        for <io-uring@vger.kernel.org>; Sun, 29 Aug 2021 07:06:24 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id a13so15966206iol.5
        for <io-uring@vger.kernel.org>; Sun, 29 Aug 2021 07:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xdT/3Qm2CHXrsALJlJ53Pz+5MSOn3ezbdyKN0mbzcIk=;
        b=QO7Fzm/IloiyyMdBPHyvAHFFC2I23CrR7eQ4gheV3pEVQT7b07/PiA7dDbAftfMJxy
         Jt8Z6A9F19Jp2azuT72Otx3rhy0YPA2a7hjOaYoTKNry2TeCPyJLnd0yRjaJO1z5Lg7s
         p6kymNXx00Z+qCFNXu6w68t+eLeJK3XZuW3OSGWsWkJeTX5Wz+rPhRZqgYgXBsDbNZ3b
         2ffAIt05uWmTRh1ftMxWEHrbOOzoeEWzbLf9AUfyzltIEFDEedcTrd66Jw5IPHTYtvl3
         ptACX9U11v9RAfukpnznGBwXAcI54ynIwXmHDURpvbZ3a3bWcrwJk8OK9Yv30VevtCZj
         Cyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xdT/3Qm2CHXrsALJlJ53Pz+5MSOn3ezbdyKN0mbzcIk=;
        b=IJT96ijX6CznO0V6voeC639+f48v0ZHHUtbjuR4KOsklTNvEuFzUgqE0hzjjJB23kX
         XXuOdhviYsypuJqj/35uMsbnanL3cVmVz9uJC4iHxSSUaDv2P40Li9obDXLILv6ACxwh
         +8+ouQPcW16LIZLdMs6WnUKKfbT50Q2xgPDGH1lPHrJoz1V5vbLmH/9cDpmlsxNHgC1f
         k4UVgL0uKs+gSQds5ycOzw7X6eDSfOAyMuJF6YnY/AlqxELlaM0oLKEazMbTvhoVqIQB
         pgX+Pe3mIoe7GKabxkcD3IvMS4NMjbNZoU7fFPfjLKO7x4QxkK5jEvTLpw2kBYA30pU7
         bVig==
X-Gm-Message-State: AOAM533IUBQJun+r4fXD9wLHBCnnxn7RXi9ymPZb6i883qH33C3QaB7+
        iNY2GXvukmH5YiW9iShMKHB4PpAa+v0PLA==
X-Google-Smtp-Source: ABdhPJzpAsKgTtkIAtxsF7nihegC+dVKHkURLSMH5StoZB+J1DsUWd54X7lG8C7fMmTWievDxDBKVw==
X-Received: by 2002:a02:9608:: with SMTP id c8mr3070842jai.133.1630245983649;
        Sun, 29 Aug 2021 07:06:23 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i14sm6481775iog.47.2021.08.29.07.06.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 07:06:23 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io-wq: provide a way to limit max number of workers
Message-ID: <6619adf5-2f85-e21d-d8f2-6e5088a28e83@kernel.dk>
Date:   Sun, 29 Aug 2021 08:06:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq divides work into two categories:

1) Work that completes in a bounded time, like reading from a regular file
   or a block device. This type of work is limited based on the size of
   the SQ ring.

2) Work that may never complete, we call this unbounded work. The amount
   of workers here is just limited by RLIMIT_NPROC.

For various uses cases, it's handy to have the kernel limit the maximum
amount of pending workers for both categories. Provide a way to do with
with a new IORING_REGISTER_IOWQ_MAX_WORKERS operation.

IORING_REGISTER_IOWQ_MAX_WORKERS takes an array of two integers and sets
the max worker count to what is being passed in for each category. The
old values are returned into that same array. If 0 is being passed in for
either category, it simply returns the current value.

The value is capped at RLIMIT_NPROC. This actually isn't that important
as it's more of a hint, if we're exceeding the value then our attempt
to fork a new worker will fail. This happens naturally already if more
than one node is in the system, as these values are per-node internally
for io-wq.

Reported-by: Johannes Lundberg <johalun0@gmail.com>
Link: https://github.com/axboe/liburing/issues/420
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: allow setting/getting both types of workers. It'd be silly to
have to add bounded workers later, and there are already cases where
it makes sense to change that value as well. The current max for
bounded work is just a function of number of CPUs and SQ ring size,
which is a good default but doesn't cover all cases.

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8da9bb103916..4b5fc621ab39 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1152,6 +1152,35 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
 	return 0;
 }
 
+/*
+ * Set max number of workers, returns old value. If new_count is 0,
+ * then just return the old value.
+ */
+int io_wq_max_workers(struct io_wq *wq, int *new_count)
+{
+	int i, node, prev = 0;
+
+	for (i = 0; i < 2; i++) {
+		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
+			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
+	}
+
+	rcu_read_lock();
+	for_each_node(node) {
+		struct io_wqe_acct *acct;
+
+		for (i = 0; i < 2; i++) {
+			acct = &wq->wqes[node]->acct[i];
+			prev = max_t(int, acct->max_workers, prev);
+			if (new_count[i])
+				acct->max_workers = new_count[i];
+			new_count[i] = prev;
+		}
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 308af3928424..bf5c4c533760 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -128,6 +128,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_max_workers(struct io_wq *wq, int *new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53326449d685..edbda88142f9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10233,6 +10233,31 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 	return io_wq_cpu_affinity(tctx->io_wq, NULL);
 }
 
+static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
+					void __user *arg)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	__u32 new_count[2];
+	int i, ret;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+	if (copy_from_user(new_count, arg, sizeof(new_count)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i] > INT_MAX)
+			return -EINVAL;
+
+	ret = io_wq_max_workers(tctx->io_wq, new_count);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, new_count, sizeof(new_count)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -10250,6 +10275,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_BUFFERS_UPDATE:
 	case IORING_REGISTER_IOWQ_AFF:
 	case IORING_UNREGISTER_IOWQ_AFF:
+	case IORING_REGISTER_IOWQ_MAX_WORKERS:
 		return false;
 	default:
 		return true;
@@ -10406,6 +10432,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_iowq_aff(ctx);
 		break;
+	case IORING_REGISTER_IOWQ_MAX_WORKERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 2)
+			break;
+		ret = io_register_iowq_max_workers(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 45a4f2373694..64fe809c4e36 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -309,6 +309,9 @@ enum {
 	IORING_REGISTER_IOWQ_AFF		= 17,
 	IORING_UNREGISTER_IOWQ_AFF		= 18,
 
+	/* set/get max number of workers */
+	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
-- 
Jens Axboe

