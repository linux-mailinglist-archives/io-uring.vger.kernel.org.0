Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19773AB9BD
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhFQQcI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhFQQb5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 12:31:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B6AC0617A8
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d9so3818686ioo.2
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgPSd/fShs8k9QJtE0jYQK4uOrLxEsNd3CPdRdVV/cM=;
        b=ucwr2ytP3Xnq6WlNXScfzpmBreikTZsJvHQIG/qwS2Kd0uBfuZRaMw0T1dzDmIsdeJ
         Hklg21IgNjAJ/dLzA5QGd9wl9HtpTKXBGQG0+iHEljhAoLFl83zM+I2joD2HGtuwquUB
         k2F1DQ9B6rFSZ12GzVoJ8UNoqcikAx88yH8eMfjOPVjHHxeqzABaawVPh/rAdL6QaRPB
         VuG9X9CdDezhHuTRuPBFBKdX38iF8RK590k1NMPIoc+WrVOwEaII1YsMHjfOYMq3tKli
         5YBgVQpbvlvQoE8CHtjU/wNIYPdsHiwRTWcj+v72NXZmLHB8ndZO+JF7oxW6p6CWCSLA
         xNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgPSd/fShs8k9QJtE0jYQK4uOrLxEsNd3CPdRdVV/cM=;
        b=iYLotm48fmPXTKQoVRkUjPK+dQwN5tZtmftmx+L2YmuVFIt+1882KucVgcVYy34eo3
         vM0JIHJ6gOAck3RcORTixmcEwSa0cgRgH/1uV50NKQM4g2vXNZdRCqpVmYS1ggHmtWIP
         T6T0OP1d+5d7I5fN0W/FVyN/qq3gIgS3TnHoDmaoo6mMU+ufeAGorZ12Mmu92/layBHD
         rT3FKEX1hJ0tGn3u9ZpJUxr6CuO8OIPsuyI2hAMTsSK5YLjPLS5jyCnu3bJAe640JwdC
         RrZ68trvKf/np27MKgexXDkmyAbezmAYL8fe5rarLZmtqfWU7yyO3Zi4HYlIrQyb2qw0
         u6zQ==
X-Gm-Message-State: AOAM530L32+QIjoZOVnIiKrDPovwR2MqFnuqLl1KWvSj6Z0Rh53T+qzn
        X+aHOlC4fOykzuqEnKCFgV4rVvUE4nlwcf8e
X-Google-Smtp-Source: ABdhPJx5QDkCkf6CW1TGDzgTLNibIByW/JFcPalQAdR+Z9JEwwUOREu8MHt6S2X/2CTbXyaOxPpY3A==
X-Received: by 2002:a05:6602:2587:: with SMTP id p7mr4698551ioo.12.1623947387855;
        Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm2856359ilj.33.2021.06.17.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: allow user configurable IO thread CPU affinity
Date:   Thu, 17 Jun 2021 10:29:44 -0600
Message-Id: <20210617162944.524917-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617162944.524917-1-axboe@kernel.dk>
References: <20210617162944.524917-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq defaults to per-node masks for IO workers. This works fine by
default, but isn't particularly handy for workloads that prefer more
specific affinities, for either performance or isolation reasons.

This adds IORING_REGISTER_IOWQ_AFF that allows the user to pass in a CPU
mask that is then applied to IO thread workers, and an
IORING_UNREGISTER_IOWQ_AFF that simply resets the masks back to the
default of per-node.

Note that no care is given to existing IO threads, they will need to go
through a reschedule before the affinity is correct if they are already
running or sleeping.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c                    | 17 ++++++++++++
 fs/io-wq.h                    |  2 ++
 fs/io_uring.c                 | 51 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  4 +++
 4 files changed, 74 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2af8e1df4646..bb4d3ee9592e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1087,6 +1087,23 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 	return __io_wq_cpu_online(wq, cpu, false);
 }
 
+int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
+{
+	int i;
+
+	rcu_read_lock();
+	for_each_node(i) {
+		struct io_wqe *wqe = wq->wqes[i];
+
+		if (mask)
+			cpumask_copy(wqe->cpu_mask, mask);
+		else
+			cpumask_copy(wqe->cpu_mask, cpumask_of_node(i));
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index af2df0680ee2..02299cdcf55c 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -128,6 +128,8 @@ void io_wq_put_and_exit(struct io_wq *wq);
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
+int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
 	return work->flags & IO_WQ_WORK_HASHED;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d916eb2cef09..46a25a7cb70a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9983,6 +9983,43 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
+static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
+				unsigned len)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	cpumask_var_t new_mask;
+	int ret;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(new_mask);
+	if (len > cpumask_size())
+		len = cpumask_size();
+
+	if (copy_from_user(new_mask, arg, len)) {
+		free_cpumask_var(new_mask);
+		return -EFAULT;
+	}
+
+	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	free_cpumask_var(new_mask);
+	return ret;
+}
+
+static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
+	return io_wq_cpu_affinity(tctx->io_wq, NULL);
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -9998,6 +10035,8 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_FILES_UPDATE2:
 	case IORING_REGISTER_BUFFERS2:
 	case IORING_REGISTER_BUFFERS_UPDATE:
+	case IORING_REGISTER_IOWQ_AFF:
+	case IORING_UNREGISTER_IOWQ_AFF:
 		return false;
 	default:
 		return true;
@@ -10137,6 +10176,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_register_rsrc_update(ctx, arg, nr_args,
 					      IORING_RSRC_BUFFER);
 		break;
+	case IORING_REGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (!arg || !nr_args)
+			break;
+		ret = io_register_iowq_aff(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_unregister_iowq_aff(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 162ff99ed2cb..f1f9ac114b51 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -306,6 +306,10 @@ enum {
 	IORING_REGISTER_BUFFERS2		= 15,
 	IORING_REGISTER_BUFFERS_UPDATE		= 16,
 
+	/* set/clear io-wq thread affinities */
+	IORING_REGISTER_IOWQ_AFF		= 17,
+	IORING_UNREGISTER_IOWQ_AFF		= 18,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
-- 
2.32.0

