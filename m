Return-Path: <io-uring+bounces-6264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 518A7A27BEF
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1C2E188632E
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55B121A928;
	Tue,  4 Feb 2025 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P455PtdB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A132185BC
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698514; cv=none; b=gOnUfnAv+PVk0pRNWZMJVP7Z5CUTr8Rvqc5435D/LoxoVW/J3loF24Mrydwdg/MTBpb2Oymw6EmS/eL9LvE3P/yKqPfhL36Hq9KA0663LS7c08NkvNi7kb7UC8Ltyc+/U/XTewM2CMruhUWwgYxf62Z6noLCr0yoY2q6lLRYhas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698514; c=relaxed/simple;
	bh=7NCJa/YUkbrD14iVC5Fo7E+HifsEy18miILjbxUpvpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWIYYdp8j/+9YX/TFkQKVw7g4IjIyyVgW7gJFCh4ch+UPreOX8OY3AW2by2uWUfJ8yE/kRZBJLnMgnEjs4cIf8e70KHzKFeG2yG3e0jGwzzvwVhQEhEeGykDOo9l48f5DIxgCXKvv5l9wiwMIGpZR3ojfnzFhaF4FutFP4sfOZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P455PtdB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso17716985ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698512; x=1739303312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0n2mNjkTDU5O7DP6W32rHso6Kfv5rwx5G4baOMJXIqA=;
        b=P455PtdBDi5iPMZVb2rEpFQ+2R9b6VTgNwJw0kfBSU7pzgp3NGznRN6bdbPucGBaZZ
         GxnUCOGR1CgeXl1n1iDPySYZQ60y+RLy+W7IVKLuh7IQEtpqEHMOOiv+y2aBwtOxraOD
         3cc4KPq/0lRPrH9EGBXchochg3KmZSk/hwdjfyQSAtp7DM2aI3e36bo6n7h2hNBU9uqt
         lmZwOd0Y/zE67KHLlde1xpcxcy89a+akslbU/+drkFd9r6zgUuKH2S3zETerCNOHxw/o
         RJD+yaws08tFnCGdBE5g9FOcIMmkDiOZ+SlZtVpJLDZr54vulKLzTCJSULXpYu4m3mhb
         6qlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698512; x=1739303312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0n2mNjkTDU5O7DP6W32rHso6Kfv5rwx5G4baOMJXIqA=;
        b=MIC9//f+Paf5EblvOoFQy8ko4MuHbMRnUtnZLmGowtM0PAyfQdCE60AX/UMBSB3+28
         TlRrhPBDjUo915klbQsXgTmvrSb0qtmLyYO4Dj+wAf8fKN9q8nqLtDZtG0zAz6ym825H
         HO0EhvBTCj32DTKAXcK8Gvwp4AzwGGAXZmZQigE0il/WKdtNjOUgQeCeQZzjb0eKrRZE
         yRJSLELjW9+GYenCkUaJh6gG3bFELePGliIt7LhduR9PP9kKDbMe11fK2V2gRXrkY4jE
         qRFb0i4cFP+Ex9ic6G5GebE4CNOd38hpRj73OKE1yDHFH8gvguKlM9YIRkyTi7S8xAM3
         tMcA==
X-Gm-Message-State: AOJu0Yyx7KkK3BUU8dQWtRBBCM6HD7Uue1y0t09UkD8snosnC6/g4GIL
	z8j6TkGr7ZnTgX5z7swi2x9XtKUEyqht/wHepj5uAPgWKHrcMr7Z2c/Nd4444yMlACM3fare5dr
	W
X-Gm-Gg: ASbGncu1cQ0har6hLnuv5zqzvzdnmHf3Sg/+lmBiAuErLW/s4KCpAAcBcmr1iWx7Ly1
	YzRGID2hTYiAKhazgTbWnCKSMom1QH+vBwlFluSoOGKwLesw2AFok90cGNGuLQHPsIy/W4iSIOZ
	6KPGCksw7yvg3wHqOc1PJ0LmV/Li2w50rz6FOqNcQmDcBmQKGJnxA4HhirVX0//8w0VQ3u6zamC
	84GONxjbvVinh/uCOhZ9ex1gOf2DN1y+N5xn7EXzcPXQng2RdHxV8d0pOk3X5kDwjwjrb5+NX4E
	XLn4ZT8vRA4Ai358riQ=
X-Google-Smtp-Source: AGHT+IHlV5dF+b2i226E432f8IFH3lV+HH0PKBbcEE5SLTTpyRfoD/A14429fAVuvD4sVNwCMDE13Q==
X-Received: by 2002:a05:6e02:13a5:b0:3cf:cd3c:bdfd with SMTP id e9e14a558f8ab-3d04f461636mr1942345ab.12.1738698511915;
        Tue, 04 Feb 2025 11:48:31 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:30 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] io_uring/epoll: add multishot support for IORING_OP_EPOLL_WAIT
Date: Tue,  4 Feb 2025 12:46:45 -0700
Message-ID: <20250204194814.393112-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As with other multishot requests, submitting a multishot epoll wait
request will keep it re-armed post the initial trigger. This allows
multiple epoll wait completions per request submitted, every time
events are available. If more completions are expected for this
epoll wait request, then IORING_CQE_F_MORE will be set in the posted
cqe->flags.

For multishot, the request remains on the epoll callback waitqueue
head. This means that epoll doesn't need to juggle the ep->lock
writelock (and disable/enable IRQs) for each invocation of the
reaping loop. That should translate into nice efficiency gains.

Use by setting IORING_EPOLL_WAIT_MULTISHOT in the sqe->epoll_flags
member. Must be used with provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  6 +++++
 io_uring/epoll.c              | 46 ++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a559e1e1544a..93f504b6d4ec 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		epoll_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -405,6 +406,11 @@ enum io_uring_op {
 #define IORING_ACCEPT_DONTWAIT	(1U << 1)
 #define IORING_ACCEPT_POLL_FIRST	(1U << 2)
 
+/*
+ * epoll_wait flags, stored in sqe->epoll_flags
+ */
+#define IORING_EPOLL_WAIT_MULTISHOT	(1U << 0)
+
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 134112e7a505..2474f2e069ef 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -25,6 +25,7 @@ struct io_epoll {
 struct io_epoll_wait {
 	struct file			*file;
 	int				maxevents;
+	int				flags;
 	struct epoll_event __user	*events;
 	struct wait_queue_entry		wait;
 };
@@ -151,11 +152,12 @@ static void io_epoll_retry(struct io_kiocb *req, struct io_tw_state *ts)
 	io_req_task_submit(req, ts);
 }
 
-static int io_epoll_execute(struct io_kiocb *req)
+static int io_epoll_execute(struct io_kiocb *req, __poll_t mask)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
-	list_del_init_careful(&iew->wait.entry);
+	if (mask & EPOLL_URING_WAKE || !(req->flags & REQ_F_APOLL_MULTISHOT))
+		list_del_init_careful(&iew->wait.entry);
 	if (io_poll_get_ownership(req)) {
 		req->io_task_work.func = io_epoll_retry;
 		io_req_task_work_add(req);
@@ -164,13 +166,13 @@ static int io_epoll_execute(struct io_kiocb *req)
 	return 1;
 }
 
-static __cold int io_epoll_pollfree_wake(struct io_kiocb *req)
+static __cold int io_epoll_pollfree_wake(struct io_kiocb *req, __poll_t mask)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
 	io_poll_mark_cancelled(req);
 	list_del_init_careful(&iew->wait.entry);
-	io_epoll_execute(req);
+	io_epoll_execute(req, mask);
 	return 1;
 }
 
@@ -181,20 +183,28 @@ static int io_epoll_wait_fn(struct wait_queue_entry *wait, unsigned mode,
 	__poll_t mask = key_to_poll(key);
 
 	if (unlikely(mask & POLLFREE))
-		return io_epoll_pollfree_wake(req);
+		return io_epoll_pollfree_wake(req, mask);
 
-	return io_epoll_execute(req);
+	return io_epoll_execute(req, mask);
 }
 
 int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
-	if (sqe->off || sqe->rw_flags || sqe->splice_fd_in)
+	if (sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 
 	iew->maxevents = READ_ONCE(sqe->len);
 	iew->events = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iew->flags = READ_ONCE(sqe->epoll_flags);
+	if (iew->flags & ~IORING_EPOLL_WAIT_MULTISHOT) {
+		return -EINVAL;
+	} else if (iew->flags & IORING_EPOLL_WAIT_MULTISHOT) {
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+	}
 	if (req->flags & REQ_F_BUFFER_SELECT && iew->events)
 		return -EINVAL;
 
@@ -217,7 +227,7 @@ int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	io_ring_submit_lock(ctx, issue_flags);
-
+retry:
 	if (io_do_buffer_select(req)) {
 		size_t len = iew->maxevents * sizeof(*evs);
 
@@ -238,14 +248,32 @@ int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret > 0) {
 		cflags = io_put_kbuf(req, ret * sizeof(*evs), 0);
+		if (req->flags & REQ_F_BL_EMPTY)
+			goto stop_multi;
+		if (req->flags & REQ_F_APOLL_MULTISHOT) {
+			if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
+				goto retry;
+			goto stop_multi;
+		}
 	} else if (!ret) {
 		io_kbuf_recycle(req, 0);
 	} else {
 err:
 		req_set_fail(req);
+		if (req->flags & REQ_F_APOLL_MULTISHOT) {
+stop_multi:
+			atomic_or(IO_POLL_FINISH_FLAG, &req->poll_refs);
+			io_poll_multishot_retry(req);
+			if (!list_empty_careful(&iew->wait.entry))
+				epoll_wait_remove(req->file, &iew->wait);
+			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+		}
 	}
-	hlist_del_init(&req->hash_node);
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 	io_req_set_res(req, ret, cflags);
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		return IOU_STOP_MULTISHOT;
 	return IOU_OK;
 }
-- 
2.47.2


