Return-Path: <io-uring+bounces-4886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E069D43D8
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF733B23700
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 22:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74571802DD;
	Wed, 20 Nov 2024 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="PNg6y3GG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E31413C3D3
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 22:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732140899; cv=none; b=E0UJlPeWTX58juCvY99ebwKepSOZ01i2j6OJz3wBAzmgcxONtIbi2/BZzGZlyCwjo8CsO/O54DXCpoEXvUIGb5T2hDsVaaO2FNBpdQDRW5l9uz6PiWtfYz5pddZuQ8gsT5u6eElHX4e8KS2B3fRukCM3By4BXjacyUNOaMIzITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732140899; c=relaxed/simple;
	bh=0L672kBSX3QwnyGap8Jjf0ZzME04VkgJwp3olpFRJ8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS8IcwS+DfEJ0GGt0qVwTt8X78dzeD+vlgL0gmQaQn8fSM/A8P/x4I/vS90pXi6/3QwDvWuG1UJTOC+kQD1aTVgob21B8I+BpTzNReYME9GqRsxAzjNdJ8yImyDQTG+BF/CPm2/4fgKOY7EJNTQGmg4yksP2sIatZ21rysyJPDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=PNg6y3GG; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7f8cc29aaf2so208183a12.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 14:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1732140897; x=1732745697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlTZmi11+GwqGzSy9kTb3NoT1Grn8NSsFFqh6K9C1aM=;
        b=PNg6y3GGe1tvkOytII8nNdJjQd8NAucNQiy6cspxmoXfZx7Dn+4bKWyEcc15Z3yQgh
         ovaDHsFEQPsnV785022lfqockRrjYWX0Q4NsX+zX1DCmNf/AbKQ7QVO34RK3tG+mRZCX
         fIU2H7I87YQ1Ue1cHB1dPb2Oe/Z6uDMonF2GZRpFqqfykhF3EgImiK3WKmt/QmLsf3fl
         kPuCH96Ey1S6MRx7LmmuDjmPi8i001DM0NgvfXfGNwsBT7wlBSfUmvZu4bcX6z+iCcxc
         uNCiicIgXHY4KFrG7yJE5fSfImJZE3/EyjW8l5DiKcxTHneM0C3LpApivAkKYa+7FoNl
         +qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732140897; x=1732745697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlTZmi11+GwqGzSy9kTb3NoT1Grn8NSsFFqh6K9C1aM=;
        b=nH7RKCWy/q3BK/K0MXnwpBMBHfv02ZkqUbD749xONGpA91pnsXaV+In0GD7azqOEOg
         baNbmhBUIfuAdanavtQb5ihFVC5vZAyT17Mu2dFSOb7TfOj8eOoLk6mBzZ+a6tSFbIp3
         Ezlia33y9BPe0hlc0ykbN88/LtymI+2ggRLTCJi2VgFQVohEi7QObDgUzywoVFbcFCK+
         pGe/z7CElfST0IFsnOhCKO7Pj9TiA1LXzaPlj0rFTMbBFQLsa7py1Eu9l1lMCF5ur+cR
         TgVjid3DYNZgGW1QqizKbeQJY82u0aspWg6wXMWNP2wnadLdcWpPOMARw4545zeeYHUS
         sUxQ==
X-Gm-Message-State: AOJu0YxakNc4gq90Uq13bPINxmkE1ePlkk3JbYqc4WeVgVvvjhfPu8qe
	b2DT6k/koX25V81c9oBAD5ohFrdaERV4s6nXyaxgTN0OiQ0i4QRsy94bUhE05rYryocTQQhMWiS
	3
X-Gm-Gg: ASbGnctz9vkE96Kaqw2W2gaSj11rylGTC0QzU8VcimjaxSF0R7k4/Iz3gNC5oTfSZ7F
	RgqwFSXwQ/WeUYFrqfqaHPKtOdsco6Kg1I31iocsJWeYnb/24sMoyg0Kty5naohFcVyg3yaW/yz
	CgHHl9rMc9zDQVOKCyH/jrW8ayvlCT3JDm1nUG4Vt2yEsVms7aaCqKdXUoKoCN6dBr7iAqbJ6PC
	AN7dVS42zZatcF9Bge65vct2dRtKM3tQ/DfwAlApMg1vJmjOvE4i0w/hAF/smS9G/PCEM4=
X-Google-Smtp-Source: AGHT+IG+mG9Ia3JUuPCfbjctJXvO1EBDDb55Rk0DK7PuhHttOsfImnobkmWd1aPmqlPFsJcEiwkkDg==
X-Received: by 2002:a05:6a20:12ce:b0:1db:f732:d177 with SMTP id adf61e73a8af0-1ddaedcbf4fmr6730938637.25.1732140897028;
        Wed, 20 Nov 2024 14:14:57 -0800 (PST)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724bef00cdasm2146769b3a.79.2024.11.20.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 14:14:56 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH next v1 2/2] io_uring: limit local tw done
Date: Wed, 20 Nov 2024 14:14:52 -0800
Message-ID: <20241120221452.3762588-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241120221452.3762588-1-dw@davidwei.uk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of eagerly running all available local tw, limit the amount of
local tw done to the max of IO_LOCAL_TW_DEFAULT_MAX (20) or wait_nr. The
value of 20 is chosen as a reasonable heuristic to allow enough work
batching but also keep latency down.

Add a retry_llist that maintains a list of local tw that couldn't be
done in time. No synchronisation is needed since it is only modified
within the task context.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 43 +++++++++++++++++++++++++---------
 io_uring/io_uring.h            |  2 +-
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 593c10a02144..011860ade268 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -336,6 +336,7 @@ struct io_ring_ctx {
 	 */
 	struct {
 		struct llist_head	work_llist;
+		struct llist_head	retry_llist;
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 83bf041d2648..c3a7d0197636 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -121,6 +121,7 @@
 
 #define IO_COMPL_BATCH			32
 #define IO_REQ_ALLOC_BATCH		8
+#define IO_LOCAL_TW_DEFAULT_MAX		20
 
 struct io_defer_entry {
 	struct list_head	list;
@@ -1255,6 +1256,8 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 	struct llist_node *node = llist_del_all(&ctx->work_llist);
 
 	__io_fallback_tw(node, false);
+	node = llist_del_all(&ctx->retry_llist);
+	__io_fallback_tw(node, false);
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
@@ -1269,37 +1272,55 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 	return false;
 }
 
+static int __io_run_local_work_loop(struct llist_node **node,
+				    struct io_tw_state *ts,
+				    int events)
+{
+	while (*node) {
+		struct llist_node *next = (*node)->next;
+		struct io_kiocb *req = container_of(*node, struct io_kiocb,
+						    io_task_work.node);
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				req, ts);
+		*node = next;
+		if (--events <= 0)
+			break;
+	}
+
+	return events;
+}
+
 static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 			       int min_events)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
-	int ret = 0;
+	int ret, limit;
 
 	if (WARN_ON_ONCE(ctx->submitter_task != current))
 		return -EEXIST;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	limit = max(IO_LOCAL_TW_DEFAULT_MAX, min_events);
 again:
+	ret = __io_run_local_work_loop(&ctx->retry_llist.first, ts, limit);
+	if (ctx->retry_llist.first)
+		goto retry_done;
+
 	/*
 	 * llists are in reverse order, flip it back the right way before
 	 * running the pending items.
 	 */
 	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
-	while (node) {
-		struct llist_node *next = node->next;
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-		INDIRECT_CALL_2(req->io_task_work.func,
-				io_poll_task_func, io_req_rw_complete,
-				req, ts);
-		ret++;
-		node = next;
-	}
+	ret = __io_run_local_work_loop(&node, ts, ret);
+	ctx->retry_llist.first = node;
 	loops++;
 
+	ret = limit - ret;
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
+retry_done:
 	io_submit_flush_completions(ctx);
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 69eb3b23a5a0..12abee607e4a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -349,7 +349,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 {
-	return !llist_empty(&ctx->work_llist);
+	return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry_llist);
 }
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
-- 
2.43.5


