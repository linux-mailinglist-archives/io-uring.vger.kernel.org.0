Return-Path: <io-uring+bounces-542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C9784BAE4
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6BF288E02
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9C8134CCA;
	Tue,  6 Feb 2024 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mJvEukce"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3872132C0B
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236853; cv=none; b=efgZIsNeIw/lQ3lIHX4FMLEQtbYFxF9KXU3dGMPVH8VfU+1Pok7JUEHQpdOHKy/GHLiJn7MfRTtWQg5ffg02R9Q62qKqQ9FUGkVPSIomjGnfCYf6dnPm6WyzXZf2DRQB0scMF5/OEKqHxOknRRVN2F/gHPuf1f+BZGEzp17j/J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236853; c=relaxed/simple;
	bh=y23njzJyZvBNI+yR2UGEyk7+lERQN57YsvIg+McJRFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+kCWdsltc1gxCLT/YsxtHSgFVqVD/M4oo4LqEnZCtmnfgBaUGhDDp9WA4tXITeLOaog5usOrRA9xZnxMfRs7U2eqIvuOQOgk7e+lDmiZpUmPaVFUi0anAjSFkdqjXDLKrk1p3PgO8hqotgjSGY2m1wsggxv+y+LbT4Ig0ZDBJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mJvEukce; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso74149539f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236850; x=1707841650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmuhgQ1hV2C6uVdY7mANEs6y5wJeAVYVu12IM+UxdUk=;
        b=mJvEukcet9B8vcgVuy2UBUfpX96Ex24RJfBOL5goI7KrfnQLfyTzXKk7hBMUYUdvaa
         clwR3a73iD2d/PZ9Qy/6vn7nQBLG+q4ZLa9AI6ATzLYbxKO2PK8YoZpTvwGoJhpXMyty
         uJJA4TyUoza52nVCmd15qak63fgKqfcnsA1xQxmwVCIwm+1gUCUuaLZU91tWx/SYswTB
         7ZUTrwJcLjZGsa9afQPCH753pNVoESIi+kEmmhhYL/EfXt7kPEi6XTy8VrEjnL0BQ4DP
         dBgePI8xLFhQEBb0WanfGRe9SwBNl05bCQBRuABYAr2gpXCrbI+PbB9YZnD7UHi0LndY
         kOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236850; x=1707841650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VmuhgQ1hV2C6uVdY7mANEs6y5wJeAVYVu12IM+UxdUk=;
        b=NNuaYdOZEkC0fUEMGCfT2KKnyvMgw2D+pa0w0gDXeyVX4pNZYat1FSOuW3fa8+zVy9
         oiSetprsa6pvBgvDeU8XzJxlSjDnyZFcqTLEqqqMOiXplWuXlSaK6TuiUbXfeJY5+jtL
         bJxakR006C7PK/xi7IpAUcJ6Z13pRzvyXkOhIL48PTBgyjDbMkaIF07K4WcMZatD1Qz4
         Lqi5uQqOwDNYvRCak64Jwzqsl6V6IRzHHFNRx05uuTLi8SZKoFOi1eT0Oo87jZcLub90
         I1IDP6nlbL9xPEvaFpVnhsnFS1MUk+LCedYh8vDqCTFgTYUmrntb3O/idtjpDC0jvhk2
         VmVw==
X-Gm-Message-State: AOJu0YyqLD7pjSOon1mzAONdf16vsV+Y/Vu5YwQ0Hp9K+7vC0MJI960d
	WzEH0jxap4KANu6xfOMT9Tlal3D98cAPHS5exSvjhAfd7p61IoeqPB0W9CIM64jBxOEBLHVbcGH
	YyBM=
X-Google-Smtp-Source: AGHT+IH8tRrmHSIMC7s+zxgNFfNVnkChYYW5peZHy6Ue5AQBF4pWwdQ/cH5BqA7p3sXXR6VhPek0ug==
X-Received: by 2002:a5e:990c:0:b0:7c3:f75f:7b12 with SMTP id t12-20020a5e990c000000b007c3f75f7b12mr858400ioj.0.1707236850347;
        Tue, 06 Feb 2024 08:27:30 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/10] io_uring/kbuf: cleanup passing back cflags
Date: Tue,  6 Feb 2024 09:24:35 -0700
Message-ID: <20240206162726.644202-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have various functions calculating the CQE cflags we need to pass
back, but it's all the same everywhere. Make a number of the putting
functions void, and just have the two main helps for this, io_put_kbuf()
and io_put_kbuf_comp() calculate the actual mask and pass it back.

While at it, cleanup how we put REQ_F_BUFFER_RING buffers. Before
this change, we would call into __io_put_kbuf() only to go right back
in to the header defined functions. As clearing this type of buffer
is just re-assigning the buf_index and incrementing the head, this
is very wasteful.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 14 ++++----------
 io_uring/kbuf.h | 41 +++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 71880615bb78..ee866d646997 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -102,10 +102,8 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	return true;
 }
 
-unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
+void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
 {
-	unsigned int cflags;
-
 	/*
 	 * We can add this buffer back to two lists:
 	 *
@@ -118,21 +116,17 @@ unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
 	 * We migrate buffers from the comp_list to the issue cache list
 	 * when we need one.
 	 */
-	if (req->flags & REQ_F_BUFFER_RING) {
-		/* no buffers to recycle for this case */
-		cflags = __io_put_kbuf_list(req, NULL);
-	} else if (issue_flags & IO_URING_F_UNLOCKED) {
+	if (issue_flags & IO_URING_F_UNLOCKED) {
 		struct io_ring_ctx *ctx = req->ctx;
 
 		spin_lock(&ctx->completion_lock);
-		cflags = __io_put_kbuf_list(req, &ctx->io_buffers_comp);
+		__io_put_kbuf_list(req, &ctx->io_buffers_comp);
 		spin_unlock(&ctx->completion_lock);
 	} else {
 		lockdep_assert_held(&req->ctx->uring_lock);
 
-		cflags = __io_put_kbuf_list(req, &req->ctx->io_buffers_cache);
+		__io_put_kbuf_list(req, &req->ctx->io_buffers_cache);
 	}
-	return cflags;
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 53dfaa71a397..f74c910b83f4 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -57,7 +57,7 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx);
 
-unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
+void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
@@ -108,41 +108,54 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
-static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
-					      struct list_head *list)
+static inline void __io_put_kbuf_ring(struct io_kiocb *req)
 {
-	unsigned int ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	if (req->buf_list) {
+		req->buf_index = req->buf_list->bgid;
+		req->buf_list->head++;
+	}
+	req->flags &= ~REQ_F_BUFFER_RING;
+}
 
+static inline void __io_put_kbuf_list(struct io_kiocb *req,
+				      struct list_head *list)
+{
 	if (req->flags & REQ_F_BUFFER_RING) {
-		if (req->buf_list) {
-			req->buf_index = req->buf_list->bgid;
-			req->buf_list->head++;
-		}
-		req->flags &= ~REQ_F_BUFFER_RING;
+		__io_put_kbuf_ring(req);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
 		req->flags &= ~REQ_F_BUFFER_SELECTED;
 	}
-
-	return ret;
 }
 
 static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
+	unsigned int ret;
+
 	lockdep_assert_held(&req->ctx->completion_lock);
 
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
-	return __io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
+
+	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
+	return ret;
 }
 
 static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 				       unsigned issue_flags)
 {
+	unsigned int ret;
 
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
+	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbuf(req, issue_flags);
+
+	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	if (req->flags & REQ_F_BUFFER_RING)
+		__io_put_kbuf_ring(req);
+	else
+		__io_put_kbuf(req, issue_flags);
+	return ret;
 }
 #endif
-- 
2.43.0


