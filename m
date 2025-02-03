Return-Path: <io-uring+bounces-6230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90DE8A26017
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E7B318864E1
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C4620B805;
	Mon,  3 Feb 2025 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2WV48dbb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227F20B7EC
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600292; cv=none; b=gt5tU0uRvUVpQpYy9PzCQ1RBS/oMMdbM+WOuqewuhxD1EIJBtOlpi1xEYpL9+hDg7tzNKh8qrJ90Mejq1stcsymqOXghTF8ePOakXPuksYbXOlY3gHmZzXqiwbLIlmAf/TNgQO+8XMUMss1RV1UFTxm0duFqLggIMKBm4uDSP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600292; c=relaxed/simple;
	bh=im1ntOsYLHYjJiEvx6njeC6vx3wirWuYtKuqP171Gs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxIpJGUKmXmTT1SFQbrqDkDjtB5LI9sG9aUEco00pVpYsI5naihjukzCwTxV9Pk3DYtsqKW61uRJxa9e3WTQgZd4x3wA7Q1T71HojC2cH9T6vvchxMp6C8Wxo+ocwQyxYdM392VWiKVqZmRC2dyjASXcfglNjpCUFaQia+N771w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2WV48dbb; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-84a1ce51187so125330139f.1
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600290; x=1739205090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=2WV48dbbfKhGaSERDCCzZF60fGOeZyC03tkpBZK7RgjcKch27ArVCY3GVA5Hu0IZ7g
         GDdZd6C329mlV4MdXKJfiBRbRBuEqtEYwLsg2IjIm93/REwy3wUC0xyFaJf+DOf0cyfu
         pVFdvT9HYWKiGYhc17JYskY7kHZw+QcSAhe+Puw0QXemx67vG6DXEM/D02DlmUDWT518
         qCiU+Uvrr2rIpS5gD8t5MRG8HqPSPebin5aphGYbjJRN5mVlRK94b9/dhxb3UEqgQnvQ
         PlBmhaXEfHsQDxRLErCo8KC4JsF/vIVG1FcjDm73jyFUJgwaRdzzpJ0s6j97yDUvSxeR
         SIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600290; x=1739205090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=WPcKrdRWUdk4OQvPZjNAJAxh4H7hkukdum8v/jrbXJGa5/49Ygww0vD/GRs5yQmyi0
         qJwlPpT0sRVNIRSUgs3Ko5scydi6Y9+GO8jIj7pYpc8PnZAH1cHFq56OwBJnANDEzwMH
         RdSYv89T0SGi4OHPlNExZOgQYOwukagWdT4s1fODmCtCUy7Q+b8yOqM0NIqJUOFy3aLM
         Ts3l9Emq0CFhKw/BqddfQ/YuwtSZ6afxZeG5fdqRvBa0ximYrTlK8tqrmm//IpNy0L2M
         wK+9lFo+fjEF1OsNnJHKLUGObdwrxXNrNsIGArrSis1rzRXEHw6vwaUMv9LRKRykLLuO
         kqVw==
X-Gm-Message-State: AOJu0YwadlIqANEE0FPwtlIx7Huucfk3xoJN9oNMeOr8b3OwqF5ws+zb
	OIUQPnSXLYk/Z/YIwRPczoI4M6NmwW+TokZ1q4qunMbFNE6r8YKAPCo3anqb9jtRYDvL5f2yH8E
	l2CM=
X-Gm-Gg: ASbGncsfnDCvkCaUGm8+roB0CpRvdvW0kv3JglccWl1o8RumpGWsMOZkbMcR3gyIy0b
	dunOmSIGAgHG792wDw4nqgyYdyyfUEzpLbo4Fkw0ADid/w5Nf1xH83JW8ez/rHVi6U1pvc3COmp
	CHtgHWrWxNuiYP4ozdb2q773KIyNJbeyvGlZgblQj1bZUvLlhN7oh+3daNYP7oHDJ/JUXNxj09X
	2kd7iPuXSM5VsFQnDVopi0PzR7rtt8B2IZJKtAoSNx5N6MPr/3QOk72K4uwRs/rxGX5/Xyl/ElT
	9gQOhmnCWuhH3fsUfs4=
X-Google-Smtp-Source: AGHT+IHbguIeZfHTdu65ziKGW6ATBjS2yiHfTO/r9nckYu6FLpo07OrSWeS6IHMC5zGBM2+H37rscA==
X-Received: by 2002:a05:6602:394e:b0:83a:a305:d9ee with SMTP id ca18e2360f4ac-85439fbbbf9mr2298125539f.12.1738600289812;
        Mon, 03 Feb 2025 08:31:29 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/poll: pull ownership handling into poll.h
Date: Mon,  3 Feb 2025 09:23:45 -0700
Message-ID: <20250203163114.124077-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163114.124077-1-axboe@kernel.dk>
References: <20250203163114.124077-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using it from somewhere else. Rather than try and
duplicate the functionality, just make it generically available to
io_uring opcodes.

Note: would have to be used carefully, cannot be used by opcodes that
can trigger poll logic.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 30 +-----------------------------
 io_uring/poll.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bb1c0cd4f809..5e44ac562491 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -41,16 +41,6 @@ struct io_poll_table {
 	__poll_t result_mask;
 };
 
-#define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_RETRY_FLAG	BIT(30)
-#define IO_POLL_REF_MASK	GENMASK(29, 0)
-
-/*
- * We usually have 1-2 refs taken, 128 is more than enough and we want to
- * maximise the margin between this amount and the moment when it overflows.
- */
-#define IO_POLL_REF_BIAS	128
-
 #define IO_WQE_F_DOUBLE		1
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -70,7 +60,7 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
-static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
 {
 	int v;
 
@@ -85,24 +75,6 @@ static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
-/*
- * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
- * bump it and acquire ownership. It's disallowed to modify requests while not
- * owning it, that prevents from races for enqueueing task_work's and b/w
- * arming poll and wakeups.
- */
-static inline bool io_poll_get_ownership(struct io_kiocb *req)
-{
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
-		return io_poll_get_ownership_slowpath(req);
-	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
-}
-
-static void io_poll_mark_cancelled(struct io_kiocb *req)
-{
-	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
-}
-
 static struct io_poll *io_poll_get_double(struct io_kiocb *req)
 {
 	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 04ede93113dc..2f416cd3be13 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -21,6 +21,18 @@ struct async_poll {
 	struct io_poll		*double_poll;
 };
 
+#define IO_POLL_CANCEL_FLAG	BIT(31)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+bool io_poll_get_ownership_slowpath(struct io_kiocb *req);
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
+
 /*
  * Must only be called inside issue_flags & IO_URING_F_MULTISHOT, or
  * potentially other cases where we already "own" this poll request.
@@ -30,6 +42,25 @@ static inline void io_poll_multishot_retry(struct io_kiocb *req)
 	atomic_inc(&req->poll_refs);
 }
 
+/*
+ * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
+ * bump it and acquire ownership. It's disallowed to modify requests while not
+ * owning it, that prevents from races for enqueueing task_work's and b/w
+ * arming poll and wakeups.
+ */
+static inline bool io_poll_get_ownership(struct io_kiocb *req)
+{
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
+static inline void io_poll_mark_cancelled(struct io_kiocb *req)
+{
+	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
+}
+
+
 int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
 
-- 
2.47.2


