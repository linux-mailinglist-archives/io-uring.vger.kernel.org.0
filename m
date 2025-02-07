Return-Path: <io-uring+bounces-6310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D449A2CA5C
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FD8A3AC981
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5C01A3147;
	Fri,  7 Feb 2025 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w/U7/PWj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5201A23B9
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949813; cv=none; b=ZlIxpOL51I7PM7z5eod9x8wW1NqwLYmz0k6YSuLDULdofIRD2yI+QHygh5O0TwdRXac5einJ2jAqNcJ9ymC8W3TMu3EZ22QcxnUhxngAsiocJAatDSU0W2p31Qz4rhz6jBFgmdONSkGAZuIqGx1ZOOd+fL+eo1QdsyxEGdB499o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949813; c=relaxed/simple;
	bh=im1ntOsYLHYjJiEvx6njeC6vx3wirWuYtKuqP171Gs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKQ3i9JzipkgP8u7Si1OAjuHkaa11IutX6tLpU27tRPumUq0HJrVtHOBYTPKWtRGwojqhBw/qsZVTT9h4/EmXiiZroya+vHc8yh5sBpn42ho5WCEOxE4RpqKT+8zGOmZTda1Bgzi/CTgH/7EQSKkQCqffMsxRHyxKwUGPRzjVsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w/U7/PWj; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844eac51429so183442439f.2
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949811; x=1739554611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=w/U7/PWjm0jUCptV/X671ti0JCD+43RtYOiJ+rnkve21x7fQVTIm4TlS8wnSl4Azra
         86PZ3Zi8SVGwmqwN5wPgexPbMxsPsjTlcqa8KhRZiWjTDb65LOggFvMTJIiGCCRdXSJ1
         EB3whJXVmgXWPZsz2D6CJfbRHrmKNuEfPsf0vspFK/VL3bXfhhAuLD8EicE89Et4wyDk
         5QiyxFpq3z241dkE1OEDugR1IQmXCyEhWWirCL8IjD1+tVZPZ0a5iF5wp0WY9eeY+cCg
         utfMxC/6AJLmMPai1YJ+5FbN5LT61IdQaCmGkOmRh8hOMs73ikDKkN8NrFJQNNNc23mp
         f5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949811; x=1739554611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=Esu8LY8MXHAy/bwAoV5SvJjscLx6JJ530BOC0PTXuR3G1Dod5l0fdXWXwlC0C2mYX3
         j85RqsHTBmnzs1989Nta1/TK7jb3B4EWi9ylpe2G2OuY75y525PcqFWk8cZ7eESjpiM8
         +xs/sdIbc9fN6VOLXNirmlTJTUPkKoSu2Y6UQo/rTwYt4W8ibCMY7xI+v+7YtYa6R2R0
         srj2f03xWB7nrlGIwg65M3nv3cdmhgtuAyVw2F/hFZZXGaPUso0QlpX2dqGqv5enOoQO
         tiTzgrJbkIHL1EEy3zYAjYApV5xoF7CCPLnePcUihUyMZUl90BTnShtxT9N7CMR8EptR
         fRMA==
X-Gm-Message-State: AOJu0Yx0vJNcoH/Az8vYyQNW1eq/+6bbkqPz7AhNx+7wJGpTDZMEhVBG
	KAGHsWUCLm/T01X7IZHrbRSjfGFAyOl+AvGrP1zhVo+0dqsyaHb06kH8pSZUO96HnAf8AZhF0T3
	g
X-Gm-Gg: ASbGncsB5W8Mx4pthCmZOMmKog4Bmx+cVFedV3/rje/BCERxQTCqU8Q7ajyDLiOEVKl
	t82xu5Pq/tcrYfIy9bj2VhLdndped1cvv0MxlkZRW5cchQo3JUPAM3zmT7I5rE1Y0iZ5cGw/fHV
	4d6zpi44iGDk4oXfXsJahR+IvOTMzBDFr8qjynvwA4vArcPQlZTzKvk0PzpQyUMqDSsyxAgBt1h
	SoH4iKi+IuwY/0iDhkZhULryQvnEULOdO+eXyUrM1V0OXwV4+8a0mgdOG67tcdLU3cQuR0u0oi7
	3+N52vlIyTyq/vzsJfY=
X-Google-Smtp-Source: AGHT+IGTfHeUMPey2BvLVdDpKeNQRJC8LAYlSXA0VI1/YyMFocNIej7iZLHyFztOXS6Jz5PYpOKPgg==
X-Received: by 2002:a05:6602:3991:b0:849:a2bb:ffde with SMTP id ca18e2360f4ac-854fd89a878mr510739039f.4.1738949810703;
        Fri, 07 Feb 2025 09:36:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring/poll: pull ownership handling into poll.h
Date: Fri,  7 Feb 2025 10:32:29 -0700
Message-ID: <20250207173639.884745-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207173639.884745-1-axboe@kernel.dk>
References: <20250207173639.884745-1-axboe@kernel.dk>
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


