Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F6430B41A
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBBA07 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhBBA06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394A9C06178B
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id p15so18510851wrq.8
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uM69xuKo9U36Ni7YJWNp3wrSdDzxeS+YrNJJPxSaI/U=;
        b=nDjjYDTwrbzZuA/AgOxdWv8HHvkGME3jcbung9zsOVkGxXqDG3kj9H0WLLybXrmje3
         hbJNd2nq8USYB1AMOFAvAWLmbpOAh5abduunS5jNN4t7Q7V85xm4ZFIX+VlxfSjTF2w6
         W6hJDYI1ZsEJgaR3YoULP69xuj498ceyWnHPRg9c92XSK5AwQbRVtKdxGOi0F6Snvz76
         fB1BijepnTV9c5TEo6m9JPCVqU/gb+DgXLKD/CgiwyUYnSY86ZIINmsY6wRBsEdUbkWQ
         wPRyHOux+qr47y55SqGtGdFI8zD497mLUFmUeRchvyqtJtCkof1pmXhg+XqnehQO3NZ9
         8AMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uM69xuKo9U36Ni7YJWNp3wrSdDzxeS+YrNJJPxSaI/U=;
        b=LvO1S18isVQg4t1seGzSUWyEKYXl3jehpIjeAlHRpNJ3OHJnp2O3uGnjnmhvvvPS0G
         Nx4KWL3pdwA6rzhZQ+rrQKepichhUtFBfC0hBlhdC3hFZWSozuJTS9e0tepzvf0bGjsJ
         ReWAcqTy55Jkqo65H37jybV3z354oo06e3w1og9hZWaSqE5slFhVxGK/hDLMpW7Q8D9l
         H6OhfGUq0IhOGbpRGjfrY8unlGvjSywOSdu1c7MnZT8oCxL/BFrttu97si4GFaqFWKnI
         +CCrIx894TNE1flIyhUysGVG/niQdXxIVgCGmR7EQZi7yMEjGHjh14qv6SkeWvAJHe1i
         HO+Q==
X-Gm-Message-State: AOAM532YiFpuoeBL98oOex7n/n5SYp/Ri3+x6o0vFqv8XOK3Ivu+X/AS
        tYCh0ik6i79c3iHBAwGSSCI=
X-Google-Smtp-Source: ABdhPJwpOww2x5VNrvK/T/HWsx06JMXVRCYozDwy/balzQxadx9xZQr14erolSzvnXO6N5mS8cpCtw==
X-Received: by 2002:a5d:4dcd:: with SMTP id f13mr20750527wru.10.1612225543051;
        Mon, 01 Feb 2021 16:25:43 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: inline io_read()'s iovec freeing
Date:   Tue,  2 Feb 2021 00:21:46 +0000
Message-Id: <66e116c8982cf36b3774ec52a31ab29d975e6902.1612223954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_read() has not the simpliest control flow with a lot of jumps and
it's hard to read. One of those is a out_free: label, which frees iovec.
However, from the middle of io_read() iovec is NULL'ed and so
kfree(iovec) is no-op, it leaves us with two place where we can inline
it and further clean up the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e648c0e6b8d..17a3736661c6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3530,14 +3530,18 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
-	if (unlikely(ret))
-		goto out_free;
+	if (unlikely(ret)) {
+		kfree(iovec);
+		return ret;
+	}
 
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
-		ret = 0;
-		goto out_free;
+		/* it's faster to check here then delegate to kfree */
+		if (iovec)
+			kfree(iovec);
+		return 0;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3562,8 +3566,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		return ret2;
 
 	rw = req->async_data;
-	/* it's copied and will be cleaned with ->io */
-	iovec = NULL;
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
 retry:
@@ -3582,21 +3584,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	 * do, then just retry at the new offset.
 	 */
 	ret = io_iter_do_read(req, iter);
-	if (ret == -EIOCBQUEUED) {
-		ret = 0;
-		goto out_free;
-	} else if (ret > 0 && ret < io_size) {
-		/* we got some bytes, but not all. retry. */
+	if (ret == -EIOCBQUEUED)
+		return 0;
+	/* we got some bytes, but not all. retry. */
+	if (ret > 0 && ret < io_size)
 		goto retry;
-	}
 done:
 	kiocb_done(kiocb, ret, cs);
-	ret = 0;
-out_free:
-	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
-	return ret;
+	return 0;
 }
 
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.24.0

