Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9D41ED0D5
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgFCNbP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgFCNbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:31:05 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C59C08C5C0;
        Wed,  3 Jun 2020 06:31:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l11so2417756wru.0;
        Wed, 03 Jun 2020 06:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9ndkIlZSg/mH+rbFHIDBj/zBoeKcA9h8ZR9NNtsZznk=;
        b=E+Yp9fYfWadZ0gzjYHm3X2TfmpLUtWSjKvklNVPqZnSag3B4KVMDcfui6NdLsYinAa
         JIj4D3xuYQPGyTqVomV5a+qvsWc0YIR898x58s6qiPJVk+QvKi5rqHa2L8IdERI68ufv
         RFo5QYCOzcRxyUEbCudBGjhEztI/heInEv6Nh3zGsyUTLxU22MSEnJ3LdJy1HVFSHfPh
         b2xtSHpSiyNWlmyZZBGtX4gD5XypllxXyv9O49KclzVmS8EqHdDiNKAXbMOh4tGUOOSM
         QmBaI8QGRzd3xrr3AqW7Pk8Sv6Ui7wRm5zy5ENb/3GVXrw1cd7WveYKfGnl8gHZlZDOl
         Pk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ndkIlZSg/mH+rbFHIDBj/zBoeKcA9h8ZR9NNtsZznk=;
        b=oFw33OJcQ5rSVPF0jN8nrJQdvX3GFT52VX58VsEc2SEJlUkpLx3bekk2RXmhl2gDrj
         M4X0WFtJns4lYPd29OK3Mssh/JYcWERTxuF3vsjWCfXPYghICBXT0irjZc1sG2mc6faJ
         CDVIGvzLtPS+3Kt/GvpmcZ247v+Wxsaa8vv09p9FViDt9fsfOx5+oYQ+0n2NGG0c5jW5
         bLhIa5D+S9+teLHwvAprtprGq67yrH2+eypBdFAYLzS99mauTtprc0+mKGvbsAZE0UOh
         aWyAMTK64MEuHXxhk732JdDjACRS043YRG90zjUJwTq57eLhtNic5C6diR7SPQdZ430E
         jtjA==
X-Gm-Message-State: AOAM5302382ggpts7RLz76rn6KM3ymZZqIf0Fa4o0uQ8LuoZmnL87d3a
        oqDy+uu0Gv9nZztcxRo+t0Q=
X-Google-Smtp-Source: ABdhPJyROjyiwDarvK/ah2mGur021WnF8FGsgCBJMO9LNVB53aoXhCWMlGy23wCQiFIhUNaWiY+03w==
X-Received: by 2002:a05:6000:1146:: with SMTP id d6mr30436877wrx.400.1591191064098;
        Wed, 03 Jun 2020 06:31:04 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id a1sm3189716wmd.28.2020.06.03.06.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 06:31:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] io_uring: deduplicate io_openat{,2}_prep()
Date:   Wed,  3 Jun 2020 16:29:31 +0300
Message-Id: <163d20dc646c414830096778965f1b828965f86a.1591190471.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591190471.git.asml.silence@gmail.com>
References: <cover.1591190471.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_openat_prep() and io_openat2_prep() are identical except for how
struct open_how is built. Deduplicate it with a helper.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 ++++++++++++++++++---------------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75ff635bb30e..7d49bcba859c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2989,26 +2989,21 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
-static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *fname;
-	u64 flags, mode;
 	int ret;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
-	if (req->flags & REQ_F_FIXED_FILE)
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
 
-	mode = READ_ONCE(sqe->len);
-	flags = READ_ONCE(sqe->open_flags);
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
-	req->open.how = build_open_how(flags, mode);
+	/* open.how should be already initialised */
+	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
+		req->open.how.flags |= O_LARGEFILE;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -3018,33 +3013,33 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->open.filename = NULL;
 		return ret;
 	}
-
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
+static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	u64 flags, mode;
+
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
+	mode = READ_ONCE(sqe->len);
+	flags = READ_ONCE(sqe->open_flags);
+	req->open.how = build_open_how(flags, mode);
+	return __io_openat_prep(req, sqe);
+}
+
 static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct open_how __user *how;
-	const char __user *fname;
 	size_t len;
 	int ret;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
-		return -EINVAL;
-	if (req->flags & REQ_F_FIXED_FILE)
-		return -EBADF;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
-
-	req->open.dfd = READ_ONCE(sqe->fd);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	len = READ_ONCE(sqe->len);
-
 	if (len < OPEN_HOW_SIZE_VER0)
 		return -EINVAL;
 
@@ -3053,19 +3048,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret)
 		return ret;
 
-	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
-		req->open.how.flags |= O_LARGEFILE;
-
-	req->open.filename = getname(fname);
-	if (IS_ERR(req->open.filename)) {
-		ret = PTR_ERR(req->open.filename);
-		req->open.filename = NULL;
-		return ret;
-	}
-
-	req->open.nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
+	return __io_openat_prep(req, sqe);
 }
 
 static int io_openat2(struct io_kiocb *req, bool force_nonblock)
-- 
2.24.0

