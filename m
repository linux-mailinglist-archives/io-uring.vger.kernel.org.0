Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4355507F4
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 04:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiFSCH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 22:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiFSCHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 22:07:23 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A72BE12
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so6135621pjm.4
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/gZKEItjgM5ODXShu2bv021xYTS6+ZaZ035kwYe5/M=;
        b=atB+TAFqKYVH7BLdHqxTVpVEg6DaQqomkNNuNKLjHRwQuMUTiqFpyfm6H4SGC0apIf
         Oa9cxy0JvnpXSsyv/j1gfXbD35ar+Bh5mqdf0+Tu4PakvxLimzXJUbFBhlVU1NX4QR2k
         q2OCnSbXllI8dtliZlP9yTU1VILYeSJjcqpe5gex1K0OpT7zLIp5T/yGtcdHTw92UMvD
         KQkJhwymEfCtY07jDUa3vkqGqCd7ePAgMpHYu/1m1CcLvowJA7QtlYIStSmGeffvRlyY
         HvtnIAXVgrnoE+/J63qs9UsfjP0cyjsde1vcP03xwshuU14rpgnUwLCNs/Rh9VzzsEOc
         CdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/gZKEItjgM5ODXShu2bv021xYTS6+ZaZ035kwYe5/M=;
        b=uIDVEUyBgcIbwNx/INrzOmuhyGvPKGDuzItj6Aa0zH5ck9pMwk1fy8tFgY2vL72xia
         3cfPw2ao1jZC/8ZI/AbdC4oheBovemBHK+jbnBVBCIP5q/kMVTd37Jx2S97XzaEt76bP
         Luu5kSas5WF1B90uJUYhXostJKB0/dJWCwb4pwuE8Hcs0uDr647LNF6XaEaZ+CdDRHvp
         2dthO95Ayhe6kbdF1OhMLsf9gyjzou5ZGxLouDyAdb3o8PIIGqZ2R+95iv1eWm6G0OAB
         KQR3fL8Qd1aXKU77U/Y5Z6/YVVQU/DP8w+U5EIcEYQ167lWQNbC6Vhp7ZHdx44QVevCA
         s1Qg==
X-Gm-Message-State: AJIora8xtRAHp3OjsiWEyc6i9KevTghKXpDSVNYAceicljMFsZe2a5ks
        l3FzGCu458dcgkxXLosAxtdVGLSVtxT4PQ==
X-Google-Smtp-Source: AGRyM1sE0FjanCZEkGK183Iu+p3FH2gU6Oi43uuik4YZkDpMhqdtGtautfwbTbT38dahQZq34WrRWg==
X-Received: by 2002:a17:90b:4c85:b0:1e5:42ef:a921 with SMTP id my5-20020a17090b4c8500b001e542efa921mr29859884pjb.75.1655604441282;
        Sat, 18 Jun 2022 19:07:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0051c7038bd52sm6118598pfn.220.2022.06.18.19.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 19:07:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add sync cancelation API through io_uring_register()
Date:   Sat, 18 Jun 2022 20:07:15 -0600
Message-Id: <20220619020715.1327556-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220619020715.1327556-1-axboe@kernel.dk>
References: <20220619020715.1327556-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The io_uring cancelation API is async, like any other API that we expose
there. For the case of finding a request to cancel, or not finding one,
it is fully sync in that when submission returns, the CQE for both the
cancelation request and the targeted request have been posted to the
CQ ring.

However, if the targeted work is being executed by io-wq, the API can
only start the act of canceling it. This makes it difficult to use in
some circumstances, as the caller then has to wait for the CQEs to come
in and match on the same cancelation data there.

Provide a IORING_REGISTER_SYNC_CANCEL command for io_uring_register()
that does sync cancelations, always. For the io-wq case, it'll wait
for the cancelation to come in before returning. The only expected
returns from this API is:

0		Request found and canceled fine.
> 0		Requests found and canceled. Only happens if asked to
		cancel multiple requests, and if the work wasn't in
		progress.
-ENOENT		Request not found.
-ETIME		A timeout on the operation was requested, but the timeout
		expired before we could cancel.

and we won't get -EALREADY via this API.

If the timeout value passed in is -1 (tv_sec and tv_nsec), then that
means that no timeout is requested. Otherwise, the timespec passed in
is the amount of time the sync cancel will wait for a successful
cancelation.

Link: https://github.com/axboe/liburing/discussions/608
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  15 +++++
 io_uring/cancel.c             | 107 ++++++++++++++++++++++++++++++++++
 io_uring/cancel.h             |   2 +
 io_uring/io_uring.c           |   6 ++
 4 files changed, 130 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d69dac9bb02c..09e7c3b13d2d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,6 +10,7 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+#include <linux/time_types.h>
 
 /*
  * IO submission data structure (Submission Queue Entry)
@@ -425,6 +426,9 @@ enum {
 	IORING_REGISTER_PBUF_RING		= 22,
 	IORING_UNREGISTER_PBUF_RING		= 23,
 
+	/* sync cancelation API */
+	IORING_REGISTER_SYNC_CANCEL		= 24,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -560,4 +564,15 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+/*
+ * Argument for IORING_REGISTER_SYNC_CANCEL
+ */
+struct io_uring_sync_cancel_reg {
+	__u64				addr;
+	__s32				fd;
+	__u32				flags;
+	struct __kernel_timespec	timeout;
+	__u64				pad[4];
+};
+
 #endif
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index da486de07029..78b5a3088ab3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -206,3 +207,109 @@ void init_hash_table(struct io_hash_table *table, unsigned size)
 		INIT_HLIST_HEAD(&table->hbs[i].list);
 	}
 }
+
+static int __io_sync_cancel(struct io_uring_task *tctx,
+			    struct io_cancel_data *cd, int fd)
+{
+	struct io_ring_ctx *ctx = cd->ctx;
+
+	/* fixed must be grabbed every time since we drop the uring_lock */
+	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
+	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
+		unsigned long file_ptr;
+
+		if (unlikely(fd > ctx->nr_user_files))
+			return -EBADF;
+		fd = array_index_nospec(fd, ctx->nr_user_files);
+		file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+		cd->file = (struct file *) (file_ptr & FFS_MASK);
+		if (!cd->file)
+			return -EBADF;
+	}
+
+	return __io_async_cancel(cd, tctx, 0);
+}
+
+int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_cancel_data cd = {
+		.ctx	= ctx,
+		.seq	= atomic_inc_return(&ctx->cancel_seq),
+	};
+	ktime_t timeout = KTIME_MAX;
+	struct io_uring_sync_cancel_reg sc;
+	struct fd f = { };
+	DEFINE_WAIT(wait);
+	int ret;
+
+	if (copy_from_user(&sc, arg, sizeof(sc)))
+		return -EFAULT;
+	if (sc.flags & ~CANCEL_FLAGS)
+		return -EINVAL;
+	if (sc.pad[0] || sc.pad[1] || sc.pad[2] || sc.pad[3])
+		return -EINVAL;
+
+	cd.data = sc.addr;
+	cd.flags = sc.flags;
+
+	/* we can grab a normal file descriptor upfront */
+	if ((cd.flags & IORING_ASYNC_CANCEL_FD) &&
+	   !(cd.flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
+		f = fdget(sc.fd);
+		if (!f.file)
+			return -EBADF;
+		cd.file = f.file;
+	}
+
+	ret = __io_sync_cancel(current->io_uring, &cd, sc.fd);
+
+	/* found something, done! */
+	if (ret != -EALREADY)
+		goto out;
+
+	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+		struct timespec64 ts = {
+			.tv_sec		= sc.timeout.tv_sec,
+			.tv_nsec	= sc.timeout.tv_nsec
+		};
+
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+	}
+
+	/*
+	 * Keep looking until we get -ENOENT. we'll get woken everytime
+	 * every time a request completes and will retry the cancelation.
+	 */
+	do {
+		cd.seq = atomic_inc_return(&ctx->cancel_seq),
+
+		prepare_to_wait(&ctx->cq_wait, &wait, TASK_INTERRUPTIBLE);
+
+		ret = __io_sync_cancel(current->io_uring, &cd, sc.fd);
+
+		if (ret != -EALREADY)
+			break;
+
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_run_task_work_sig();
+		if (ret < 0) {
+			mutex_lock(&ctx->uring_lock);
+			break;
+		}
+		ret = schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS);
+		mutex_lock(&ctx->uring_lock);
+		if (!ret) {
+			ret = -ETIME;
+			break;
+		}
+	} while (1);
+
+	finish_wait(&ctx->cq_wait, &wait);
+
+	if (ret == -ENOENT || ret > 0)
+		ret = 0;
+out:
+	fdput(f);
+	return ret;
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 1bc7e917ce94..6a59ee484d0c 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -19,3 +19,5 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 		  unsigned int issue_flags);
 void init_hash_table(struct io_hash_table *table, unsigned size);
+
+int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 430e65494989..8abb841e424d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3911,6 +3911,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_pbuf_ring(ctx, arg);
 		break;
+	case IORING_REGISTER_SYNC_CANCEL:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_sync_cancel(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.35.1

