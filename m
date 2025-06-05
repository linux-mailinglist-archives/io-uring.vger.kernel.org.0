Return-Path: <io-uring+bounces-8236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D018ACF847
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 21:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AB4B3B056B
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC7927C84F;
	Thu,  5 Jun 2025 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x0xoGLYt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E927703E
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152857; cv=none; b=p6qm7iSLoJxuo84i+abkhCsmWbzeFeD8HAKv7X6O5gMTMpcsTfbgyjhRNM/MZKTGIm1FiqplLSnzUQ7uiPsHH+s20kEf88PRiZuSYfmQlTNLISS5qYXi9vlpz1+w86JxCUZ8aJlgw2ENwkQR0RqTL5glGezAEFvDajfSHS0QxGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152857; c=relaxed/simple;
	bh=rO1+AmNcEMbujvKWBxgTc71zxxJuvtsxH21kFG9veBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6M5xTv2iBhK06nERc7P42XlymzGjJvEcVTl0LsKO4IisXS8lvylkFxO8zmF90XDbiYqYhuScGw4S8BqVxQLGSetTypeqh1f+/zlPyZ1n682GvEmsnkq2WUeC+mNO1zIHSjV1sstc9Z9g4bCz79LzSSgiDIF6l7rAxbN6RKz258=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x0xoGLYt; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-864a22fcdf2so53752639f.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 12:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749152854; x=1749757654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmThwQYmZqmc/QX7eIdrKRPRgxKgQ+77wOx09x5j6wM=;
        b=x0xoGLYtO75eG1B+EGaHXhoF/V78brGVipSDWxOqHR+rCSmfPRGWvRJo8zdW94mP6I
         AdupwoO8EgPES619/AD1RmVN0mT0IFySY9LsMb6M+aF5vXiG9PwldQCCiA5GAzIqMfN4
         AM2ngbnZ+8N/9ewPEgaHTamA9cF2+KEAOyhddtZLuu07CGHT5Ll+wTSwNbAtSHNRj99m
         0BOF5IBult5nSwKlVgkgnkYGmuNsgE/mTwNRnKDM819l4+2ncQZi7HTiB0zG1WJZFZhh
         QxXEMg0riYCgFuel/IC3m0OOtoIaSGgtneo/UalCF92VbNgo441A6/DIRjKtSpnzJcTT
         m1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152854; x=1749757654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmThwQYmZqmc/QX7eIdrKRPRgxKgQ+77wOx09x5j6wM=;
        b=ilMZZRwf4eZHvEZaT0yBYXh0fqp2Ij32ShgOXJXjA8P954JoNLnBWYB8Jl/NoAv0/2
         IHUuLg3oAKr4noJ6LrVaMI0nVgPy4wOP1KSqzrqGnXVWhQXSbgs0c78MFkRjrsRR25Wp
         Rq8l6L2Hk68XCLdEuUURx8L8KTFuF37Tq7qsY0u0m9IPDNPEKLjDnAhyxTLsIgD3MTnF
         v+da6bakt1gBgjLSMOp71ufdMTHFof6w9E+w4yGVBBcofv4j1QVakOeODVwTH68CChuT
         /u9Lx9FZ9+GA4jYu/7cAYEzIv1J/vB9Ss1Zs2jMaWPwdu+4NUrJJA4uxBXon1Puh7SqL
         W7ow==
X-Gm-Message-State: AOJu0Ywol5LOsVUjY8S3lmKhO5+ECWILiyTOByjTGtCZRvO5vDyIjqa7
	hVF69Y0MKsIIEEDvbIaxiHF0QDgHSconVqW1aduPjgrX6wDVfYB17nv57PamQmA4dpiNyys+nOb
	i6oTG
X-Gm-Gg: ASbGnctjyvsg5iIQ3qdbqSlEuLiM4yFI/dfqP/EGu0GUAqqJ5nEoHEDy849Vzk+iEXc
	8Ab6rnt7Rnx5ntIan/Ts51b5n4dFavsDGrlBRfjgu8DZRCVSe/r2fMFJZHQ/DYdaahWHpKUIGSJ
	3AB8+DhAHSjKrfI7PWXo+wkoCbVQ8l/ge3wCCUjjoi9OIxmDZHTn7m+HVw8lEpTXK1gsYqRv6/K
	fff/3YHZu6rmcKMVB2HlVnl6ssfACdRIoGUKkLcSZ4EN+M0vDHqkBSOnKcnuw4Zlc3YB7yoLX7W
	ODszbA/t+77qYlUIfMKXyvgSzaaPRAlYCjzbdFdaTTE4bxsEAN9zwAGE9wHC9qC3FQ==
X-Google-Smtp-Source: AGHT+IEkjJT/kkYJFhNNzRawHK5qHe4FhGWNV823uygcwAyvKl9hc5S4QSRFFipZMaBAg6YiD7n8VQ==
X-Received: by 2002:a05:6602:358c:b0:85b:4310:a91c with SMTP id ca18e2360f4ac-873370774ccmr79503939f.1.1749152854393;
        Thu, 05 Jun 2025 12:47:34 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm317783639f.19.2025.06.05.12.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 12:47:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
Date: Thu,  5 Jun 2025 13:40:42 -0600
Message-ID: <20250605194728.145287-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605194728.145287-1-axboe@kernel.dk>
References: <20250605194728.145287-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be called by the core of io_uring, if inline issue is not going
to be tried for a request. Opcodes can define this handler to defer
copying of SQE data that should remain stable.

Called with IO_URING_F_INLINE set if this is an inline issue, and that
flag NOT set if it's an out-of-line call. The handler can use this to
determine if it's still safe to copy the SQE. The core should always
guarantee that it will be safe, but by having this flag available the
handler is able to check and fail.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 32 ++++++++++++++++++++++++--------
 io_uring/opdef.h    |  1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 079a95e1bd82..fdf23e81c4ff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all,
 					 bool is_sqpoll_thread);
 
-static void io_queue_sqe(struct io_kiocb *req);
+static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
 static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
@@ -1377,7 +1377,7 @@ void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
 	else
-		io_queue_sqe(req);
+		io_queue_sqe(req, NULL);
 }
 
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1935,14 +1935,30 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 	return file;
 }
 
-static void io_queue_async(struct io_kiocb *req, int ret)
+static int io_req_sqe_copy(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   unsigned int issue_flags)
+{
+	const struct io_cold_def *def = &io_cold_defs[req->opcode];
+
+	if (!def->sqe_copy)
+		return 0;
+	return def->sqe_copy(req, sqe, issue_flags);
+}
+
+static void io_queue_async(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
+fail:
 		io_req_defer_failed(req, ret);
 		return;
 	}
 
+	ret = io_req_sqe_copy(req, sqe, 0);
+	if (unlikely(ret))
+		goto fail;
+
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -1957,7 +1973,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	__must_hold(&req->ctx->uring_lock)
 {
 	int ret;
@@ -1970,7 +1986,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (unlikely(ret))
-		io_queue_async(req, ret);
+		io_queue_async(req, sqe, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
@@ -2200,7 +2216,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		link->last = req;
 
 		if (req->flags & IO_REQ_LINK_FLAGS)
-			return 0;
+			return io_req_sqe_copy(req, sqe, IO_URING_F_INLINE);
 		/* last request of the link, flush it */
 		req = link->head;
 		link->head = NULL;
@@ -2216,10 +2232,10 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 fallback:
 			io_queue_sqe_fallback(req);
 		}
-		return 0;
+		return io_req_sqe_copy(req, sqe, IO_URING_F_INLINE);
 	}
 
-	io_queue_sqe(req);
+	io_queue_sqe(req, sqe);
 	return 0;
 }
 
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 719a52104abe..71bfaa3c8afd 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -38,6 +38,7 @@ struct io_issue_def {
 struct io_cold_def {
 	const char		*name;
 
+	int (*sqe_copy)(struct io_kiocb *, const struct io_uring_sqe *, unsigned int issue_flags);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
 };
-- 
2.49.0


