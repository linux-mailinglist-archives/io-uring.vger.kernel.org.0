Return-Path: <io-uring+bounces-10334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB7AC2DBC4
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 258AF34BB3E
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11705325726;
	Mon,  3 Nov 2025 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VHtgrqwW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D8325707
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195789; cv=none; b=gGS0aj29jXlrEL362+08pvcj596VFTq1HV7dcCrXgjmKQ0zlSKUHUU/pilKPAb5zALZkY1HMzlMy4QASa9UzOAnNubJfOKwfgPhF42Ny9AkJcIko/QVpMyDAwBu/gaZ67bJy06ZSrTr4hE6Ora80oAlfAc+b/P+/6XJ2D/BVbmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195789; c=relaxed/simple;
	bh=nzDGO1lnGAR+QXdWBvW5R4vQqR9a9uATf14I30O4NE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G49mkkvHlXm6DCxHYOo0X1J+qvYnkvp4Nqe56v7drKQtkUPMkngeohbQKv6Is6W+jixVSNiTTeTxxQLBV0KCqaJYwIQd2+63ZmJmtFA1TitJEcpnFFV53PsM38QaC+GWsxEMaWSJAMABlaWLWgW3m+DNkxukoHG+0yYOY0f1EXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VHtgrqwW; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-43320988dcfso7583145ab.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195787; x=1762800587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiO4B9zF6zHV7TZPGBtnXoEcO3LZiTacHVKXbuAW71E=;
        b=VHtgrqwWF/WbqW2TMFdAX1jWt/8/HVEeplWk9KSZ0gEGGLf/qzdd0RfsfZNA5RSa93
         7IBHgcRY0SO8b915wDZ3q6iQ+iZtzXFpIWWjV7KFlQrCcGo/B1y47r0Tua2JtWBCSHmg
         zsHUMtyIdiVTnyvNSG7wug/a1vFyal2Of2LrJqfjGWwNR5N71FtEgtOKUlgYtcyfjgfJ
         RoWYUNhu9j6v+Jg7jvRUrL7fRdpeS5BzWB6p+E9t3WyJaLhy8Zu9RhFJRWm8ynRBnelL
         ptwptwPAhwH7Y9SVpO+2Y1EWPvP+gPtjOTbntJoPreKEsmy2neTkbYC8t+nf0h46wdKt
         ESpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195787; x=1762800587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiO4B9zF6zHV7TZPGBtnXoEcO3LZiTacHVKXbuAW71E=;
        b=FofS3NX3KX3EHY51cFYpG7vpMui0wDP1zZo/mKyXmNWFkDP9b41tyehSwUf/xTz9kp
         Gl83mtNMli4Nib/QJu3TkRFnon9guCNEYifSlqBToTEI7iSbQBOOH++BLvepf5Zjwpjo
         dvzs5P42fe4OUKAOr1+CLKSXgzesPtxLsjIYyWVKVF3nDpkQCs9GZORR/dgZq49tfjS2
         1BBpZZHLesw/liqCqqpEIgzskQI1YftiL1imx2AssTqQkqDOQHUCjEsUdlzO27n9s+nv
         KR4ARIX8m4qGVVEEU/BZPfx46zCZmc2fUHxuTNZp4gG8xvtX2/zTiRItp3NDLDE2MnnY
         /4Dg==
X-Gm-Message-State: AOJu0YxfB4ua7lZsQBbPmnLs4KN1OSAYHmX7KU4nC6kM1r0dzlMHWMgy
	zTNOP4JonvVQMW7Tfuojtbqlouz5sQNLeaTCFl03ch2nnE5LD+aZiaE5OjV9QAQq0X8BOJudguK
	3jWGH
X-Gm-Gg: ASbGncvH/hvj6bkCJtUrD+yEofs33PNYuZ9HxmCUHlWQN4iUi9mk966t8Gi5hrGZCXy
	oWIkClNPuZlrK6Lm582BCN0CEPZM7GsigR0YBG02nBjA2UsPcWWPCN4gRLHbZIvBIXq5k6zZ/Uj
	Re7UvqoiYECPZlZppYFD0ODFEVIfw/UkbuXauMHSGpHNzD1DDvTnVDeWjsiSoYTUv7LcDRzjaF7
	lysb596+r9VUr8TUELkWWrtgVzJjN21e8XePF8ld5Y5ARhbrzfJX0Xtc8ynpsEBAzWk/zfHAb9o
	1wMwdZ+ttAXezvoBqg1CYaJ3r4x8Yno9CAx7ZN4CokB5sTmJmkgqv8YbJtRJsgW0zAuzyp0kTgp
	dQuZfJsZ+WANn4jfCpdV5ce7dWeYfRy+ZbiRciNkpH6yD15SYxolw+8ITkyY=
X-Google-Smtp-Source: AGHT+IGrodo20EgOnaEqyu8eMXolunUlAjNjmKOZR6TJQWMm/sgmgBnv4DusNydhz7/Vq51MHx/8NQ==
X-Received: by 2002:a05:6e02:2701:b0:432:ffc4:b3f9 with SMTP id e9e14a558f8ab-4330d1c5cf5mr179343275ab.23.1762195786885;
        Mon, 03 Nov 2025 10:49:46 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/cancel: move request/task cancelation logic into cancel.c
Date: Mon,  3 Nov 2025 11:48:02 -0700
Message-ID: <20251103184937.61634-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move io_match_task_safe() and helpers into cancel.c, where it belongs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c   | 38 ++++++++++++++++++++++++++++++++++++++
 io_uring/cancel.h   |  2 ++
 io_uring/io_uring.c | 38 --------------------------------------
 io_uring/io_uring.h |  3 ---
 4 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 64b51e82baa2..2754ea80e288 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -384,3 +384,41 @@ int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return nr ?: -ENOENT;
 }
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * As io_match_task() but protected against racing with linked timeouts.
+ * User must not hold timeout_lock.
+ */
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
+			bool cancel_all)
+{
+	bool matched;
+
+	if (tctx && head->tctx != tctx)
+		return false;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		raw_spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 43e9bb74e9d1..6d5208e9d7a6 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -23,6 +23,8 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
+			bool cancel_all);
 
 bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  struct hlist_head *list, bool cancel_all,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 01631b6ff442..75bd049a1efd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -207,44 +207,6 @@ static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
 	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
 }
 
-static bool io_match_linked(struct io_kiocb *head)
-{
-	struct io_kiocb *req;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-/*
- * As io_match_task() but protected against racing with linked timeouts.
- * User must not hold timeout_lock.
- */
-bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
-			bool cancel_all)
-{
-	bool matched;
-
-	if (tctx && head->tctx != tctx)
-		return false;
-	if (cancel_all)
-		return true;
-
-	if (head->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = head->ctx;
-
-		/* protect against races with linked timeouts */
-		raw_spin_lock_irq(&ctx->timeout_lock);
-		matched = io_match_linked(head);
-		raw_spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		matched = io_match_linked(head);
-	}
-	return matched;
-}
-
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
 {
 	req_set_fail(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f97356ce29d0..2f4d43e69648 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -174,9 +174,6 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
-bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
-			bool cancel_all);
-
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
-- 
2.51.0


