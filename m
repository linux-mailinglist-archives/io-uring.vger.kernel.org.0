Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303A91EBBC2
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgFBMfg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFBMfe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 08:35:34 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBEDC08C5C1;
        Tue,  2 Jun 2020 05:35:34 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r9so2759000wmh.2;
        Tue, 02 Jun 2020 05:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GWnwsndMUFY9LbquBFm/jfHKBWZW/WFWSjyLmrgL/NM=;
        b=fmUuB2mK4tx0D5m5tR8YUggXnSHEmV6iDXgo6qGblxl01CP4a+zvb/z7giM885pPKc
         WFbGLL9eMJVkHnwA3hLtbCJ5km+16BZmFiUd8X2HDHAsikrC7s9B5UUlpc39INNNfLQb
         HXZxMOusidA/W+7vWw2+WVN/1cpeFygoP5dlT6J2QNyzkog7CO/Cf7mDeiDOFXdwqjeS
         h3Esj2F+4PfKVWjwWEaz0x/bW0VFWosj8XJ5o4P/Y9o07aHwbcn/pIAEMl4MTGHCrS6l
         Lc6FIsIV0yFgAQu4MuHI+b2jlnIa8uE/2lStp77vmMLkwukW7KWT2bxbgvjfl+QsnA4D
         xQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWnwsndMUFY9LbquBFm/jfHKBWZW/WFWSjyLmrgL/NM=;
        b=U+OwT2bgahDw8dtZ7QJdpIAcwE1V7MDErP8q/mUq2i+32n7ukppDYdfXE18fWSkS5T
         SLl3ZsEVdFV7vfypKenZqYQ5kMSUIrbez2XbGlxeV7n0wHbV7FmJ1GNoO37a44naCBGh
         mfp5noPYsFqNSu7MPWDgFxN9++GUsTARitfaq2W/roXfqy37xdVtWLkOC0+vhdKIfylY
         eZi3RQSae2SoMwOfOxAIr4GkP2ow6vKVdOMu0wf9xZ2sH9mVG+gpkP7lVanpvXN0Oryg
         YFROrwVhPnrMK9ofpSH6q+Uobj681PkYG6MWNqHsbxrpaiPkby4RsUY7gjOVZ5euvGbZ
         z7Mg==
X-Gm-Message-State: AOAM5300ISJ4j3ByZL+0CUnRRe47w5EWsrbiXVtojlcG1F7AVchFazK0
        4OUPAdBv8+LFErW7h0VSgig=
X-Google-Smtp-Source: ABdhPJyc0cxob7HKSo7byrAJlNjyGRFTPvbmmWypnas1K2yAcQHTWoHrsVyhe92NMZCRrOe3oveiww==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr3696965wmk.96.1591101332696;
        Tue, 02 Jun 2020 05:35:32 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z22sm3347711wmf.9.2020.06.02.05.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:35:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: deduplicate io_openat{,2}_prep()
Date:   Tue,  2 Jun 2020 15:34:03 +0300
Message-Id: <ad8a7956e99a4aee62ca353c53746a93e608bed5.1591100205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591100205.git.asml.silence@gmail.com>
References: <cover.1591100205.git.asml.silence@gmail.com>
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
index cdfffc23e10a..9fe90a66a31e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2985,26 +2985,21 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
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
@@ -3014,33 +3009,33 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -3049,19 +3044,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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

