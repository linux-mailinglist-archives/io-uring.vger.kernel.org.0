Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB3942DDBE
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhJNPO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhJNPOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058C3C0613E3
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:19 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r18so20584764wrg.6
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e923M7LVThaWLUvRQ1BuK+s8SPCRLtjQDrK66z4n6GI=;
        b=Ez47UzaEgxfDFqnV9cIlmLaECVYvTrfxHce9E+IhQnW2CxP9yQlTzWxeOcfaWvQ/uP
         wfyM7dVBTwqU58PQPbaCJHH9Tv87FLn4yENXz7l29l2oRn5JHS870bV7Mt82YlNRfpS2
         y0bBkclkT9eN4oDVtZYbkaahKoqG7qshgtkypVMdtrLu+XIhYz3CvUihHM/VkQ905YP4
         3eUNC8FWeqGkTGPy2DWBNca2EMXLAdc49gdt2pI8KO33LNILIi1PQXuYWCjiKQOKQ339
         ky5CfVLrNV79+LgxcxRVxcybC3Rsc2I4dcAFU9mytUrdi+qb5PQWdyC1bni7lYtc/7ii
         D+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e923M7LVThaWLUvRQ1BuK+s8SPCRLtjQDrK66z4n6GI=;
        b=G2KoNXtPmuzy3GH8bMhxvzaRfe9COfT7BcatSevXHf8bPAQimPnjEPJw4T84mulcS0
         zbTLLizaUgkbxnXYGxiWbhmLgMrOXCu16BdKQ9LwgDMRclFcu7mOC5z+PPCZJvwqp1sC
         606egKAglqYItAJMjVov679mR1t7UCFoqo0YYldnbpDr+cd5LL5klBcUy9McwHvjSV0S
         YJqOxikNf9/son4u6hI7l2PhfQgrctPrkVl4eRdIlDHM5r5ix1ujRkf5ff2hMYffaqxv
         5gSzlqZoRZ6XUcZE18c438t4LNtl5rHLyKvIV5Ll4bdii8NjG12ZAULyc8iWsEO8OLDy
         KY+Q==
X-Gm-Message-State: AOAM533V/cmFuKHiLycn++PbQ+aPWv9CcWdIC8Z0ksP/THaomfxc3qgF
        9vYwh9TTbNDjFpvjNLhvRZ2wokA2LI8=
X-Google-Smtp-Source: ABdhPJwS6Br0gSmjadNhujhcGhvU9WsKBa5+QLmOaJ0euv8BHrzl7Hlu6ng9DdmNT2ibvt2NJoNC8Q==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr6582295wmi.122.1634224275103;
        Thu, 14 Oct 2021 08:11:15 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring: rearrange io_read()/write()
Date:   Thu, 14 Oct 2021 16:10:19 +0100
Message-Id: <2c2536c5896d70994de76e387ea09a0402173a3f.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Combine force_nonblock branches (which is already optimised by
compiler), flip branches so the most hot/common path is the first, e.g.
as with non on-stack iov setup, and add extra likely/unlikely
attributions for errror paths.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 75 +++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9af54b10238..8bbbe7ccad54 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3395,7 +3395,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 
 static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 {
-	if (req->file->f_op->read_iter)
+	if (likely(req->file->f_op->read_iter))
 		return call_read_iter(req->file, &req->rw.kiocb, iter);
 	else if (req->file->f_op->read)
 		return loop_rw_iter(READ, req, iter);
@@ -3411,14 +3411,18 @@ static bool need_read_all(struct io_kiocb *req)
 
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rw_state __s, *s;
+	struct io_rw_state __s, *s = &__s;
 	struct iovec *iovec;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
-	if (req_has_async_data(req)) {
+	if (!req_has_async_data(req)) {
+		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
+		if (unlikely(ret < 0))
+			return ret;
+	} else {
 		rw = req->async_data;
 		s = &rw->s;
 		/*
@@ -3428,24 +3432,19 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
-	} else {
-		s = &__s;
-		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
-		if (unlikely(ret < 0))
-			return ret;
 	}
 	req->result = iov_iter_count(&s->iter);
 
-	/* Ensure we clear previously set non-block flag */
-	if (!force_nonblock)
-		kiocb->ki_flags &= ~IOCB_NOWAIT;
-	else
+	if (force_nonblock) {
+		/* If the file doesn't support async, just async punt */
+		if (unlikely(!io_file_supports_nowait(req, READ))) {
+			ret = io_setup_async_rw(req, iovec, s, true);
+			return ret ?: -EAGAIN;
+		}
 		kiocb->ki_flags |= IOCB_NOWAIT;
-
-	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
-		ret = io_setup_async_rw(req, iovec, s, true);
-		return ret ?: -EAGAIN;
+	} else {
+		/* Ensure we clear previously set non-block flag */
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
@@ -3541,40 +3540,40 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rw_state __s, *s;
-	struct io_async_rw *rw;
+	struct io_rw_state __s, *s = &__s;
 	struct iovec *iovec;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	ssize_t ret, ret2;
 
-	if (req_has_async_data(req)) {
-		rw = req->async_data;
-		s = &rw->s;
-		iov_iter_restore(&s->iter, &s->iter_state);
-		iovec = NULL;
-	} else {
-		s = &__s;
+	if (!req_has_async_data(req)) {
 		ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+	} else {
+		struct io_async_rw *rw = req->async_data;
+
+		s = &rw->s;
+		iov_iter_restore(&s->iter, &s->iter_state);
+		iovec = NULL;
 	}
 	req->result = iov_iter_count(&s->iter);
 
-	/* Ensure we clear previously set non-block flag */
-	if (!force_nonblock)
-		kiocb->ki_flags &= ~IOCB_NOWAIT;
-	else
-		kiocb->ki_flags |= IOCB_NOWAIT;
+	if (force_nonblock) {
+		/* If the file doesn't support async, just async punt */
+		if (unlikely(!io_file_supports_nowait(req, WRITE)))
+			goto copy_iov;
 
-	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_nowait(req, WRITE))
-		goto copy_iov;
+		/* file path doesn't support NOWAIT for non-direct_IO */
+		if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
+		    (req->flags & REQ_F_ISREG))
+			goto copy_iov;
 
-	/* file path doesn't support NOWAIT for non-direct_IO */
-	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
-	    (req->flags & REQ_F_ISREG))
-		goto copy_iov;
+		kiocb->ki_flags |= IOCB_NOWAIT;
+	} else {
+		/* Ensure we clear previously set non-block flag */
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	}
 
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret))
-- 
2.33.0

