Return-Path: <io-uring+bounces-535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBC184BADB
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60954B2929A
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5EC134CE0;
	Tue,  6 Feb 2024 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b2w/iF0y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D9134CDF
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236654; cv=none; b=M60ljcL9qjBdRo4whBMzq4ptGcPncgHXCsxB+joJ3nt2qn76xhx4SpYWdwZPF5A7pEONZ+OnBJgJ18IA5UwREEha/Lqj6+c+4w6ynwKl1/BwOWKb/pH5zgLU4cbrM64NQPQTSjDLY8WYvAq09WpR+/dPVjHwTbel6FpOFmAwIeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236654; c=relaxed/simple;
	bh=HhjKqV0xRqk0fe+Dd+ki5LLmlYDvpCTZd1lvic2Xklo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhWACxi+ZNZZ5QOS2YmvXWwnGufXJPLvlHMWM8DWA9HZiwWp43IVd4X/J24aG/LfqHb32pzXOyWhGFwqaAO6cLs+umbiYNch4hjObHOVHHhWVGyyAPeu/cNkVqctK4axrwi/XOUSVBvHv0tideMqZLStmJz0MshOl0ODcaiSzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b2w/iF0y; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c3df9489d2so27612639f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236651; x=1707841451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfTea7CHpcEUgf68SvNCkLAG4dRHDhWc4mmdjJHmlfs=;
        b=b2w/iF0y1ogv4G9wmAKtqEjmmdmECOuw8Qm+wiuq+g0JjFyLsiMDSR5YxGMEG28Spw
         d8jHlGvN6aqZrRskXqZPEUSXgi8CctQtTn809Y4dxXueOFUXth3eczEDwtBc4zInAkVD
         Bm+uTu5fmm4XdmFCxxSHLVYXLMKTUl7TvXknFxmyL6XBMSdp3kHlNcuRWHSlTihRbwQg
         yaX9IHu6KQLfpE1izhgxQzlYc1HvVjnudHnkfSnzhsHoffPU3GrccX2XT+hcMYdUAko3
         psTiGKEcJZQH6s6Nc4YNOfPF1h2EfrGqCTVkaYkUpXh8F6Gg9rFV4CK/h9JDyodJdX/U
         Mu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236651; x=1707841451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfTea7CHpcEUgf68SvNCkLAG4dRHDhWc4mmdjJHmlfs=;
        b=ryFF0JFJN8dMnBMDKWAUbxjHhxvpbRoQAW4X8Eri9muBAANn3EJIwIdH2pDs5Ks8Ri
         IvTi7RPwE+NlWfq59REqtHXc3dICFp9nAhA3eGIASA+jYTFH43D7LvCxbs2RNBBqTNck
         zQk3lWxk6RPtd90AwbTeYR1hBAqi+n77TNGp4ee929jurZ91xee5SgXkQ4ZvJ2Ob0Kyq
         SWrco+q6ZEqCAKZLqd5bk1B6Jnc+ArIPjqnCC8exgbpZ0L9rCfW582apt4Lyp41v+Ir9
         VoWd6qZtlInbCaqAnkxnrMRXfTMXm4YF1jocCS5n6Vv6EH3roRa7LvcGeX1RwFYYe6F+
         3HHw==
X-Gm-Message-State: AOJu0YzmVCf9SNtaIBZj78UQXy9VA1/SnE5YiEAPJ3H9xtTJUe8tqQ1G
	RRGvd111wOdjgBcqdmwCF4xFjhppE0Rs8Rf4lw8pR7s487rREU42Rxy62Mu+a4URgmeFKnaxLY6
	A9NE=
X-Google-Smtp-Source: AGHT+IFZFUU19go7kMBjaJ3Yb7Fq7e2N8LWVGkaBHh+0YFhBIEoEel4pgrrC4jksXZtya6PLiBw9HA==
X-Received: by 2002:a05:6602:2410:b0:7c3:f2c1:e8aa with SMTP id s16-20020a056602241000b007c3f2c1e8aamr2234585ioa.0.1707236651104;
        Tue, 06 Feb 2024 08:24:11 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: add io_file_can_poll() helper
Date: Tue,  6 Feb 2024 09:22:48 -0700
Message-ID: <20240206162402.643507-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162402.643507-1-axboe@kernel.dk>
References: <20240206162402.643507-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a flag to avoid dipping dereferencing file and then f_op
to figure out if the file has a poll handler defined or not. We
generally call this at least twice for networked workloads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            |  2 +-
 io_uring/io_uring.h            | 12 ++++++++++++
 io_uring/kbuf.c                |  2 +-
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  |  6 +++---
 6 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 5ac18b05d4ee..7f06cee02b58 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -463,6 +463,7 @@ enum io_req_flags {
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
+	REQ_F_CAN_POLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -535,6 +536,8 @@ enum {
 	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
+	/* file is pollable */
+	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 360a7ee41d3a..d0e06784926f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1969,7 +1969,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
-		if (opcode_poll && file_can_poll(req->file)) {
+		if (opcode_poll && io_file_can_poll(req)) {
 			needs_poll = true;
 			issue_flags |= IO_URING_F_NONBLOCK;
 		}
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c178..2952551fe345 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/kasan.h>
+#include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -398,4 +399,15 @@ static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
 		return 2 * sizeof(struct io_uring_sqe);
 	return sizeof(struct io_uring_sqe);
 }
+
+static inline bool io_file_can_poll(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_CAN_POLL)
+		return true;
+	if (file_can_poll(req->file)) {
+		req->flags |= REQ_F_CAN_POLL;
+		return true;
+	}
+	return false;
+}
 #endif
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 18df5a9d2f5e..71880615bb78 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -180,7 +180,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
+	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here, otherwise nothing ensures that the buffer won't
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7513afc7b702..4afec733fef6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -727,7 +727,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
-	if (!file_can_poll(req->file))
+	if (!io_file_can_poll(req))
 		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..0fb7a045163a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -682,7 +682,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
 	 */
-	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
 	wait->wait.func = io_async_buf_func;
@@ -831,7 +831,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * If we can poll, just do that. For a vectored read, we'll
 		 * need to copy state first.
 		 */
-		if (file_can_poll(req->file) && !io_issue_defs[req->opcode].vectored)
+		if (io_file_can_poll(req) && !io_issue_defs[req->opcode].vectored)
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -930,7 +930,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	/*
 	 * Multishot MUST be used on a pollable file
 	 */
-	if (!file_can_poll(req->file))
+	if (!io_file_can_poll(req))
 		return -EBADFD;
 
 	ret = __io_read(req, issue_flags);
-- 
2.43.0


