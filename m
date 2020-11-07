Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73052AA54F
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 14:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgKGNTm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 08:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 08:19:41 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026D8C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 05:19:41 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id y12so4117084wrp.6
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 05:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9Fpi1X+WE4z68F8Hh9suhZKjCTFjlQyYEBI0HnTFwuI=;
        b=P+kbtLdGb19yjymnyHVfhE3EEhBtvdf+elyhnUH7xzTe2GJg4uXSHOPvXGovKvs48U
         4mVVnrxmiwYZ+6kY6PBs3D7w0p80tr+YxKWyCjWeWtKHD9EgISTgYUBEONFJPGdM30hT
         KI3LXWmIWNyqU4dCLFKkh6TzbpdGhM7IGZeRcUNtW4Eu9SMfI9I4bTYbBag4nycLV3la
         8EqFFThStfg+Y7TNHWCwzhFVm87Aykt4HY3IL+ASZrJeoCZ4t3qijVpDFgPrcYWK+VNK
         Z8a7Khpac/IbCFTx7TnXmxlwPaoMX161wWYnyl53CZxNWJzFpBFDztqM+1XeoB4kNDxY
         Tctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Fpi1X+WE4z68F8Hh9suhZKjCTFjlQyYEBI0HnTFwuI=;
        b=LPuE6YN9PameDdBEBU4QsiERGfMuom/7O0bjCcvpNOlBfC4/5Rzlo29aFi+1OggYla
         787S2N/o6JqSZtoKz6DLzDeqVEEx94tCBHzfHe3J5Vr7h9AKirV3HF+EC4mff/uFdhVM
         CSuruAGvSklktMb5RHIwL1k2blwtJ9mj+Q/dlV9wUe/FzbAmzHbGUKF7ph2zVQmE6nf4
         3ieyRd76qdW+LpF02qbC07WWQIAclda7exQArBKEyuwagHNhx+5TB7ZfDVRvTQ2rlfD/
         UsSQtphnOXGlBY4FYKvYqgx5COH2FLGTAZdFcHfF6kcmp6B4tvauSbcmHvyh8S3l//jX
         vI1w==
X-Gm-Message-State: AOAM533EaA+EmLb8NtJVcmDCwsvghFwgrWBw0b+F8A5GIrQvRbYZ6Pr2
        N/o5wSHxwhcQCFh2+o8J1A00OuZvUCY=
X-Google-Smtp-Source: ABdhPJwBhBzMNen7wb4wiy2wQPwcnylYBBhxGH0kwIF2uI4aWPYTfin8uCrHEVr6e6T2fRFydxYPhA==
X-Received: by 2002:adf:f382:: with SMTP id m2mr8414047wro.342.1604755179681;
        Sat, 07 Nov 2020 05:19:39 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id f1sm6411810wmj.3.2020.11.07.05.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:19:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH 3/3] io_uring: inline io_import_iovec()
Date:   Sat,  7 Nov 2020 13:16:27 +0000
Message-Id: <684967bb875a968eac626607b729b33c2512bba1.1604754823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604754823.git.asml.silence@gmail.com>
References: <cover.1604754823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_import_iovec() and leave only its former __io_import_iovec()
renamed to the original name. That makes it more obious what is reused in
io_read/write().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3033e3929c1..2e435b336927 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3135,7 +3135,7 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, needs_lock);
 }
 
-static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
+static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 				 struct iovec **iovec, struct iov_iter *iter,
 				 bool needs_lock)
 {
@@ -3181,18 +3181,6 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 			      req->ctx->compat);
 }
 
-static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-			       struct iovec **iovec, struct iov_iter *iter,
-			       bool needs_lock)
-{
-	struct io_async_rw *iorw = req->async_data;
-
-	if (!iorw)
-		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
-	*iovec = NULL;
-	return 0;
-}
-
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
 {
 	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
@@ -3316,7 +3304,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	struct iovec *iov = iorw->fast_iov;
 	ssize_t ret;
 
-	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, false);
+	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3451,12 +3439,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ssize_t io_size, ret, ret2;
 	bool no_async;
 
-	if (rw)
+	if (rw) {
 		iter = &rw->iter;
-
-	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
-	if (ret < 0)
-		return ret;
+		iovec = NULL;
+	} else {
+		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
+		if (ret < 0)
+			return ret;
+	}
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 	ret = 0;
@@ -3577,12 +3567,14 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct io_async_rw *rw = req->async_data;
 	ssize_t ret, ret2, io_size;
 
-	if (rw)
+	if (rw) {
 		iter = &rw->iter;
-
-	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
-	if (ret < 0)
-		return ret;
+		iovec = NULL;
+	} else {
+		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
+		if (ret < 0)
+			return ret;
+	}
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 
-- 
2.24.0

