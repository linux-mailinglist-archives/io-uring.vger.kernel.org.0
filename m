Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6314AD05
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA1AQh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:16:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40752 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1AQh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:16:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so13939244wrn.7;
        Mon, 27 Jan 2020 16:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N6+HRSgh5NtNpvQxQs/5HFHZ5OA3rO0AVcskLic05y0=;
        b=nO/vop58ef4AEzY3z3aCWmEFpkVvaxoRW++lw/uTnGovXQm2a+DCZU+NgN1H6Lrx84
         1bRw0WGZepOpSZ/He2ymqzEqoiAyP9xupEa+6NTfZVDRHFawjpOe0MtKr1mUGDmyTYxI
         s01w8iugJXmcSHJHXFeVBNUfiLFqmoIK1AQlROjq+DHImoZbQmrGbvWlAz9oresuy3f/
         sWLxOq1yA1M9iS15+KdKbFPC7MTaLCfroF0KM7ecuEopY1CuisRP3+ao2mLc4AgwGt+z
         0YDZVwZKd+HzTPWqY95JmbVQ6fR7oJbMHluBTzFfdWlXGmVlEB3PNLtO+FCLbRFIOpvb
         hFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6+HRSgh5NtNpvQxQs/5HFHZ5OA3rO0AVcskLic05y0=;
        b=BuauZ4PNj7yR8EScXNlqbwdx/hztsKZ9yqrqcfj/KGf8B8HkA9bgtKBkztiRB7lJrS
         OC28vRUxaGqg6zIPWVjlE7K3LivCDhjE0a3Xsv6BVEoQNcv7cbyNEdRFeGJvcQiVv5zL
         w1P2xq6JgtdWdV5Z0m1hQDEEsZKItMgnenAmkq6WNVsVAtRc2P0i0x3yeQ5kYHyXxgII
         5sq6o6s5RANzajUYWcT6H0YjHhlJpr5ScEaiC6qRADV/E9mLfxWjuTE7tpI6elIsrXPf
         rEb+KBW/haR04mUHo7LWYzl9E71Dvg5SU2cOmDaN0U7oMALer7G4HikTOGqtcIcSj2cT
         VHZw==
X-Gm-Message-State: APjAAAXovjV6dZJBKjoVNbd68naoFlN4ZniMLQTtk1zpCrFD9zhXzfnI
        coBIyywDGYvDGeafrCRrGAQ=
X-Google-Smtp-Source: APXvYqxc8F97rapZPetenTBmT03CW7NbvkIW05z1fTcFXBV6eO7FWHGk16KDxOlixrP+UF250p8/nA==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr25202163wre.156.1580170594577;
        Mon, 27 Jan 2020 16:16:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z21sm638426wml.5.2020.01.27.16.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:16:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Daurnimator <quae@daurnimator.com>
Subject: [PATCH v2 2/2] io_uring: add io-wq workqueue sharing
Date:   Tue, 28 Jan 2020 03:15:48 +0300
Message-Id: <c40338a9989a45ec38f36e5937365eca6a089795.1580170474.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580170474.git.asml.silence@gmail.com>
References: <cover.1580170474.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_SETUP_ATTACH_WQ is set, it expects wq_fd in io_uring_params to
be a valid io_uring fd io-wq of which will be shared with the newly
created io_uring instance. If the flag is set but it can't share io-wq,
it fails.

This allows creation of "sibling" io_urings, where we prefer to keep the
SQ/CQ private, but want to share the async backend to minimize the amount
of overhead associated with having multiple rings that belong to the same
backend.

Reported-by: Jens Axboe <axboe@kernel.dk>
Reported-by: Daurnimator <quae@daurnimator.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 68 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  4 ++-
 2 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ec6428933c3..de1cb3135721 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5692,11 +5692,56 @@ static void io_get_work(struct io_wq_work *work)
 	refcount_inc(&req->refs);
 }
 
+static int io_init_wq_offload(struct io_ring_ctx *ctx,
+			      struct io_uring_params *p)
+{
+	struct io_wq_data data;
+	struct fd f;
+	struct io_ring_ctx *ctx_attach;
+	unsigned int concurrency;
+	int ret = 0;
+
+	data.user = ctx->user;
+	data.get_work = io_get_work;
+	data.put_work = io_put_work;
+
+	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
+		/* Do QD, or 4 * CPUS, whatever is smallest */
+		concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
+
+		ctx->io_wq = io_wq_create(concurrency, &data);
+		if (IS_ERR(ctx->io_wq)) {
+			ret = PTR_ERR(ctx->io_wq);
+			ctx->io_wq = NULL;
+		}
+		return ret;
+	}
+
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return -EBADF;
+
+	if (f.file->f_op != &io_uring_fops) {
+		ret = -EOPNOTSUPP;
+		goto out_fput;
+	}
+
+	ctx_attach = f.file->private_data;
+	/* @io_wq is protected by holding the fd */
+	if (!io_wq_get(ctx_attach->io_wq, &data)) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
+	ctx->io_wq = ctx_attach->io_wq;
+out_fput:
+	fdput(f);
+	return ret;
+}
+
 static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			       struct io_uring_params *p)
 {
-	struct io_wq_data data;
-	unsigned concurrency;
 	int ret;
 
 	init_waitqueue_head(&ctx->sqo_wait);
@@ -5740,18 +5785,9 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-	data.user = ctx->user;
-	data.get_work = io_get_work;
-	data.put_work = io_put_work;
-
-	/* Do QD, or 4 * CPUS, whatever is smallest */
-	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-	ctx->io_wq = io_wq_create(concurrency, &data);
-	if (IS_ERR(ctx->io_wq)) {
-		ret = PTR_ERR(ctx->io_wq);
-		ctx->io_wq = NULL;
+	ret = io_init_wq_offload(ctx, p);
+	if (ret)
 		goto err;
-	}
 
 	return 0;
 err:
@@ -6577,7 +6613,11 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+		return -EINVAL;
+
+	/* wq_fd isn't valid without ATTACH_WQ being set */
+	if (!(p.flags & IORING_SETUP_ATTACH_WQ) && p.wq_fd)
 		return -EINVAL;
 
 	ret = io_uring_create(entries, &p);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9988e82f858b..e067b92af5ad 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -75,6 +75,7 @@ enum {
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
+#define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 
 enum {
 	IORING_OP_NOP,
@@ -183,7 +184,8 @@ struct io_uring_params {
 	__u32 sq_thread_cpu;
 	__u32 sq_thread_idle;
 	__u32 features;
-	__u32 resv[4];
+	__u32 wq_fd;
+	__u32 resv[3];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
-- 
2.24.0

