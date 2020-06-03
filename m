Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BBC1ED2F1
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgFCPFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgFCPFD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 11:05:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA1FC08C5C0;
        Wed,  3 Jun 2020 08:05:02 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q11so2759429wrp.3;
        Wed, 03 Jun 2020 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=adTUwB8kFzg3Vi8cjoAvjCQW+SEJ9Zz8VHcinsh+jT4=;
        b=UxAM9xbYeUHbvzklZsdyoEsZ07zz5rIAI73gVkEWfQ8gCcbmTve201mDhzFT4r3hMR
         i9QZZfhkBNzBQKk0khFOZEV+puc249miL3zyszNsEhVLHbIPnRLhHS9aBv9Q+pYdvFQd
         CAqkJevnk9TXZrPec4BNz5aPt6pAvYq/3U67ioBDkOjOOYCzn18fz0VA4qzWb/SaKknP
         IRNtyGOmht9/HDKNcAJZChOogehWS7asHCfN8WehPXzb0EJhCxxYgb0+i+eFsnwcZ9Z4
         Y6c3mhFI/gcptrQZ5wpsKMws1sU7m1/EFRhU9ho7M1m2djAWNVPmHxcaSRykb8ghGR+y
         7jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=adTUwB8kFzg3Vi8cjoAvjCQW+SEJ9Zz8VHcinsh+jT4=;
        b=YSMrdoObHq1feY9mEWD84BBaMZnqrJ8Sy26yPEinCEWLVrZHxpnnJ/PfIvZu8STdFG
         FgJkYhYURfnOA/ZjDodcnd7DMZ2JyqP+aBr7OQPtjUT+0gsBvehfyMQn6Q3mELSOTfd4
         yvi2Ori91RbKueLbnynvsLhQV9JerEVFSCMLn1R8vnesAQoYkJihyqp3cbdowAVNxvPN
         PSVfWPQp416lOBB0aEPEEVoE0DQpT2lAxFN2LKXgtXw5dTsmLBOja+V7CpBdMkSShhpT
         woL9kH00DkNl0ApW0t/nuVWiqY1ziAI1jNXnkCko+vp6bi0gIbzZ0/mG9JEvbeE3E346
         Xl8A==
X-Gm-Message-State: AOAM533pYTQZYQyNUX81moNg079fqoviXqjQ83SkAiwDkPjCCcvqCsCy
        OexettUsUVZlOMVmYcon9pkvi7uT
X-Google-Smtp-Source: ABdhPJwIzqYlvqmS32s0MYSwSjOvZXWYdPXQ77PIvHYK+st6d95QfeoBIYcr9DL2U84+MknbbLQ+eg==
X-Received: by 2002:a5d:628c:: with SMTP id k12mr30949523wru.211.1591196701307;
        Wed, 03 Jun 2020 08:05:01 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f71sm3074808wmf.22.2020.06.03.08.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:04:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] io_uring: deduplicate io_openat{,2}_prep()
Date:   Wed,  3 Jun 2020 18:03:24 +0300
Message-Id: <4649f4618d70811f765ec39714204d6de8502e13.1591196426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591196426.git.asml.silence@gmail.com>
References: <cover.1591196426.git.asml.silence@gmail.com>
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
index e3cd914557ae..134627cbe86b 100644
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

