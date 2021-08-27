Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2183F9E1A
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhH0Rja (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhH0Rj3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 13:39:29 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8C0C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 10:38:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m11so1123220ioo.6
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 10:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EHltz5FVFDlRhXHF2mzOntDuos0/L8Mp6xJh47Nfqt4=;
        b=Vg0WS6QVvwdOq8KI47HEx8XhxPzdzhu4XvPXoB/Jkv5/zSzmxGpM7aWJdqjoTVaMeu
         TSa8JujQXmeDrYyk5FalpLUPW/byL6xN2NWAjNmJB2PcuN6WPz6kzjLkwO6aCK+35B1p
         hh5+Dp9QSfW0Ea92OrePsbOagcGFWwpBoXdRlbCpXEpJWlwpz8uztahutwUBMND19BjZ
         sycFbigK3/vctbsPq0/sLHlwLDnUBqrvVNaZ6b5ysxMLuzLcp/KxAT5IHjmLW4Oi6NxQ
         7jpcUt/oUmmkopMsc7POgQBikyai9GDcMYkfthMWWBXtNaMX0zTmTiurVpGwep6IQTlt
         chHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EHltz5FVFDlRhXHF2mzOntDuos0/L8Mp6xJh47Nfqt4=;
        b=ElOXbXFgU4dFN+Kth224Z2f4ybmCm1lCb083utHxSDWQwY4/c8seTiSSoia1NHCWtq
         mXNwkK566pw/rbO66BN57/997rEDBapwZalXZKgATMMXBbhaB+i7CBNoxIl1iFtkHzIF
         AvNcbMwyps7n/T4KMxGIF7+JXmxsHOIf3Gx6IB8lefPd1MweRsb25r6bdrPF7OTeZqlt
         SW0ZTrZ2zd360YXLUwvGDyQo5zhy5duszwDD8ybh4rz+FsknGJ/KihP42BlLOcj48X8X
         XD1rR35AIlbrXHB11EjrhoWq7JajJMJlaBGDUH19zGuHItewTqFdAgsgamoK7IXsSQTW
         lGcw==
X-Gm-Message-State: AOAM531K2w+4oybVxonXieLlXQpv97S76wRUGRd6orJD1q1I69JhTWKo
        5CJzdY8gRZQD6ho2XG6xP9xGGw==
X-Google-Smtp-Source: ABdhPJzRQJyNKgTaDF5wdRhFRpUoOaxnzbL1vxJIIAqGs43n4WSIeE69XnGBWj+k5tfiGTZ0tP9pEg==
X-Received: by 2002:a5d:9486:: with SMTP id v6mr8605831ioj.163.1630085919820;
        Fri, 27 Aug 2021 10:38:39 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r18sm3790990ilo.38.2021.08.27.10.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:38:39 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Johannes Lundberg <johalun0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: provide a way to limit max number of unbounded workers
Message-ID: <0c69e06b-f771-7c19-5e98-64aec8743872@kernel.dk>
Date:   Fri, 27 Aug 2021 11:38:38 -0600
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
amount of pending unbounded workers. Provide a way to do with with a new
IORING_REGISTER_IOWQ_MAX_UNBOUND operation.

IORING_REGISTER_IOWQ_MAX_UNBOUND takes an integer and sets the max worker
count to what is being passed in, and returns the old value (or an error).
If 0 is being passed in, it simply returns the current value.

The value is capped at RLIMIT_NPROC. This actually isn't that important
as it's more of a hint, if we're exceeding the value then our attempt
to fork a new worker will fail. This happens naturally already if more
than one node is in the system, as these values are per-node internally
for io-wq.

Reported-by: Johannes Lundberg <johalun0@gmail.com>
Link: https://github.com/axboe/liburing/issues/420
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8da9bb103916..18698662d354 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1152,6 +1152,29 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
 	return 0;
 }
 
+/*
+ * Set max number of unbounded workers, returns old value. If new_count is 0,
+ * then just return the old value.
+ */
+int io_wq_max_unbound(struct io_wq *wq, int new_count)
+{
+	int i, prev = 0;
+
+	if (new_count > task_rlimit(current, RLIMIT_NPROC))
+		new_count = task_rlimit(current, RLIMIT_NPROC);
+
+	rcu_read_lock();
+	for_each_node(i) {
+		struct io_wqe *wqe = wq->wqes[i];
+
+		prev = max_t(int, wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers, prev);
+		if (new_count)
+			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = new_count;
+	}
+	rcu_read_unlock();
+	return prev;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 308af3928424..d6631c5fca11 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -128,6 +128,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_max_unbound(struct io_wq *wq, int new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53326449d685..0f827fbe8e6c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10233,6 +10233,22 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 	return io_wq_cpu_affinity(tctx->io_wq, NULL);
 }
 
+static int io_register_iowq_max_unbound(struct io_ring_ctx *ctx,
+					void __user *arg)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	__u32 new_count;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+	if (copy_from_user(&new_count, arg, sizeof(new_count)))
+		return -EFAULT;
+	if (new_count > INT_MAX)
+		return -EINVAL;
+
+	return io_wq_max_unbound(tctx->io_wq, new_count);
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -10250,6 +10266,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_BUFFERS_UPDATE:
 	case IORING_REGISTER_IOWQ_AFF:
 	case IORING_UNREGISTER_IOWQ_AFF:
+	case IORING_REGISTER_IOWQ_MAX_UNBOUND:
 		return false;
 	default:
 		return true;
@@ -10406,6 +10423,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_iowq_aff(ctx);
 		break;
+	case IORING_REGISTER_IOWQ_MAX_UNBOUND:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_iowq_max_unbound(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 45a4f2373694..bb6845e14629 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -309,6 +309,9 @@ enum {
 	IORING_REGISTER_IOWQ_AFF		= 17,
 	IORING_UNREGISTER_IOWQ_AFF		= 18,
 
+	/* set/get max number of unbounded workers */
+	IORING_REGISTER_IOWQ_MAX_UNBOUND	= 19,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
-- 
Jens Axboe

