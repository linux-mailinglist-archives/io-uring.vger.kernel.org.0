Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDC53E7D97
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhHJQiB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbhHJQh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:37:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA3AC0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a5so6199393plh.5
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WC4ejIUmrNi+MIoz5Vp544UpW+vl/SQ46veVxKdleWg=;
        b=GMsnua/vFwRz60BeydnigsA4jcIWrr8FxK1Im4OgUtG5IXYvqCO6MYvEMtZ1f1MfID
         8VxLc67WcHLO0RGiJpFcSjHJaCzIfPYCKkBS9rIjgA/zxjgLKb/opTzJVf9W9ynE727y
         biFhDxLYxZbIjcUiwkilKwCiXrfcPskJ/l5mNBgmjkPoBmg/DEXcKM8PEcoSv9tfcUjX
         vQnk/zxdfAog53x9c7o85MuCDaDyX8lMQYQywy+9VBHHiyLdnrDgq7czCwkZNE4Xtowf
         +FMNHuG/22wruIcqwViZcIx91ZLjCCWBgLayeZDpUUQgcyxDSM8Rxi8be1O55CuE9AJh
         RekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WC4ejIUmrNi+MIoz5Vp544UpW+vl/SQ46veVxKdleWg=;
        b=DH0SyBhnSK+VIxXvskiU61dM1nlZEVG6kZbDNjN/FllHGfU/AMtN4D7sdI8VaVD2jb
         c1XTtw0AUwhOdDpBJKC/K02JKOAUxE092dE1kakDzEDA1eFL+RLRJxhryPASs4lY8GLU
         GT5G1MH1mVSQ3jjbY7ex/0qJyiNRWXcFbwXkw6Gww61LlfXwye6vTPa3HPhDU4q2PiLc
         pdsuj5yrSs86/E4xkReTvF10QY5p6vSuuQCDE6loFC+R0rQCAy85vUxCCTyU/1xsmXTj
         i2aFXDy0Z/zbkkSsZTLB22m+5+mENvI4QpGkihU0pSN6hTg6zCjLAl8TOXCxy+Ym3CnN
         jx+w==
X-Gm-Message-State: AOAM533wxEdEVZ4ldgwNkvIueAQr+j1czuYu6KeQ898x4vT8VWC3oClR
        zbcNlIxdJkAvVYvqxxthOsZhF5YOaDjxBZ4L
X-Google-Smtp-Source: ABdhPJz7dVXHqThkKzn8IurG1da0CB8RjNEa6kAteOMr84OllC+qHW6Krjbg+fDI/TnpgZ/r+hrCLQ==
X-Received: by 2002:a17:90b:102:: with SMTP id p2mr5927180pjz.126.1628613456131;
        Tue, 10 Aug 2021 09:37:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm3517744pjb.38.2021.08.10.09.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:37:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: use kiocb->private to hold rw_len
Date:   Tue, 10 Aug 2021 10:37:25 -0600
Message-Id: <20210810163728.265939-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
References: <20210810163728.265939-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need a separate member in io_rw for this, we can just use the
kiocb->private field as we're not using it for anything else anyway.
This saves 8 bytes in io_rw, which we'll be needing once kiocb grows
a new member.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91a301bb1644..f35b54f016f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -557,7 +557,6 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
 };
 
 struct io_connect {
@@ -2675,6 +2674,16 @@ static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 	return __io_file_supports_nowait(req->file, rw);
 }
 
+static inline void *u64_to_ptr(__u64 ptr)
+{
+	return (void *)(unsigned long) ptr;
+}
+
+static inline __u64 ptr_to_u64(void *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2732,7 +2741,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
-	req->rw.len = READ_ONCE(sqe->len);
+	req->rw.kiocb.private = u64_to_ptr(READ_ONCE(sqe->len));
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -2799,7 +2808,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
 			     struct io_mapped_ubuf *imu)
 {
-	size_t len = req->rw.len;
+	size_t len = ptr_to_u64(req->rw.kiocb.private);
 	u64 buf_end, buf_addr = req->rw.addr;
 	size_t offset;
 
@@ -2997,7 +3006,7 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 		iov[0].iov_len = kbuf->len;
 		return 0;
 	}
-	if (req->rw.len != 1)
+	if (ptr_to_u64(req->rw.kiocb.private) != 1)
 		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
@@ -3012,7 +3021,7 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 			   struct iov_iter *iter, bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
-	size_t sqe_len = req->rw.len;
+	size_t sqe_len = ptr_to_u64(req->rw.kiocb.private);
 	u8 opcode = req->opcode;
 	ssize_t ret;
 
@@ -3030,7 +3039,7 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
 			if (IS_ERR(buf))
 				return PTR_ERR(buf);
-			req->rw.len = sqe_len;
+			req->rw.kiocb.private = u64_to_ptr(sqe_len);
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
@@ -3063,6 +3072,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct file *file = req->file;
+	unsigned long rw_len;
 	ssize_t ret = 0;
 
 	/*
@@ -3075,6 +3085,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	rw_len = ptr_to_u64(req->rw.kiocb.private);
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3083,7 +3094,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 			iovec = iov_iter_iovec(iter);
 		} else {
 			iovec.iov_base = u64_to_user_ptr(req->rw.addr);
-			iovec.iov_len = req->rw.len;
+			iovec.iov_len = rw_len;
 		}
 
 		if (rw == READ) {
@@ -3102,7 +3113,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
-		req->rw.len -= nr;
+		rw_len -= nr;
 		req->rw.addr += nr;
 		iov_iter_advance(iter, nr);
 	}
-- 
2.32.0

