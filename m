Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AC930F462
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhBDN6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbhBDN4u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:50 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CF8C0617A9
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j21so357065wmj.0
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JB0IOJWfPu6SroqQQAZj0gnju13uZnG6xqmiYRTuRYY=;
        b=J9jFaFlTYOGdlcntPPzzNmskycnKams+ADaNlKJ5vhceTfbabWt00yX7QAeJywMyWZ
         PV34GHedWALkSIb8Wzh4xnIbbG21Qy6RBBQ5yMys8Isr4j4SjxTqKwirO1IfeVP5DWtq
         97BYSGI0zHjIMciyPULpRwlNNNXvzJdBpcu6+mWRDd6UhTkc1aVX6KbRw7hdw9ARQgjO
         d79ONCcR6zcFPDubIsAEaCJIBuBdgi+iy8OJVTqzkevzZ/Yfpl376ctJKO1cfNii9XrJ
         1paREHsNN2HF9PjIGKsOLUHSgkHLbiQgq5CYDDW7JCQnk1ks8nMeeTkq9b6bFgcObIWI
         AlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JB0IOJWfPu6SroqQQAZj0gnju13uZnG6xqmiYRTuRYY=;
        b=mHN2YM1qM4FhbXpd3IOfs+PW3ismzTebX+cVAnAJauvHSuGu4ZzCv0uSSvkYqzdxUn
         GiYbspm0jCJvgrHQ0P5kdP8yYXJWrniDrVwvtHoBLbZbZfM7jk37itD2+JSgIdaXSVGR
         G/oeagAjwvmdtjFRiJHeqTB+0XRydtKCPhvsJ+UZJ7pHTObxdELn45nlfpyNrVXQKWlC
         NSuhT/ZZyEXcGs8+/MLtPGOsX81wV/hMhs69c+Zpo4zFo972fB9o3djbQWYVe1hyEP3Q
         KRQUmrq0TdrQibhLzRBCvhKLiXZNOMjyI3moeRI7apj3unOQ4XF8tB+DzZibn2JDvdKu
         xqgw==
X-Gm-Message-State: AOAM530+YFaK374BCTkE6lxxuYdxhUQk7QkYgiG0oYVmeChvQDcNCMvw
        FU1K/ZlZEHBcWrBtVneQqr4=
X-Google-Smtp-Source: ABdhPJy9ORF3MlCjOBVt5Bd+XXsqaXo4f1cEDzQjvK9RUk/XgpcuoQFmbWFjGOqX64xoftpg56+WSg==
X-Received: by 2002:a7b:ce93:: with SMTP id q19mr7702793wmj.65.1612446965919;
        Thu, 04 Feb 2021 05:56:05 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 06/13] io_uring: let io_setup_async_rw take care of iovec
Date:   Thu,  4 Feb 2021 13:52:01 +0000
Message-Id: <323ee40e9cedea63734c5e312c6dc44c6f585d76.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we give out ownership of iovec into io_setup_async_rw(), so it
either sets request's context right or frees the iovec on error itself.
Makes our life a bit easier at call sites.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d1fa1f77332..f8492d62b6a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2721,11 +2721,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 	ret = io_import_iovec(rw, req, &iovec, &iter, false);
 	if (ret < 0)
 		return false;
-	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-	if (!ret)
-		return true;
-	kfree(iovec);
-	return false;
+	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 }
 #endif
 
@@ -3366,8 +3362,10 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!force && !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	if (!req->async_data) {
-		if (__io_alloc_async_data(req))
+		if (__io_alloc_async_data(req)) {
+			kfree(iovec);
 			return -ENOMEM;
+		}
 
 		io_req_map_rw(req, iovec, fast_iov, iter);
 	}
@@ -3528,9 +3526,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ)) {
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-		if (!ret)
-			return -EAGAIN;
-		goto out_free;
+		return ret ?: -EAGAIN;
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
@@ -3565,10 +3561,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-	if (ret2) {
-		ret = ret2;
-		goto out_free;
-	}
+	if (ret2)
+		return ret2;
+
 	rw = req->async_data;
 	/* it's copied and will be cleaned with ->io */
 	iovec = NULL;
@@ -3703,8 +3698,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (!ret)
-			return -EAGAIN;
+		return ret ?: -EAGAIN;
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-- 
2.24.0

