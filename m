Return-Path: <io-uring+bounces-1115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EB687F2C8
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8C0F1C21460
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFB959B77;
	Mon, 18 Mar 2024 22:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haccvG1b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5035A781;
	Mon, 18 Mar 2024 22:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799335; cv=none; b=GpFS26109JCSdxJmCZz67qlg4paip8kG0WJ032vHFOzr6YmHKf1Y8J44VTpmAFgHINVK1ulgewmdmeSD1kyBZTuOpY7+tyXeXlqrDYGNi3IXYLgMK15wyKh5ZPRy7ZUU54NFZQ69gp6b7xjfty67PxqP8B9Dh+x8MRGsHiTXfrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799335; c=relaxed/simple;
	bh=D2/O6AEH2zUmAJbf6CgZefbxyFofmhE4vCawTBwn1Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/NRYhqESdToNKLHrF6EEMBxG9jO0hBoKXhdwcRxNuU2bEP9eMiq/f2aGEADmFhQrMdGdTFm54pXcuVWKc/BhW1IeVfJLxv/x+vH7KT+O464iAKuf52DKrcD5LFHYaAqQVebc+K4quzUpkd5Pez/hPVSzwZC1g8pH6ngNAmteTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=haccvG1b; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-34169f28460so1050417f8f.2;
        Mon, 18 Mar 2024 15:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799331; x=1711404131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9YjALaP/hn1N1s+9XuXIoyFFiEVJsOMKt0K7ANflvs=;
        b=haccvG1b4rMuY4uMNyqfygBWFJGtbQnpAz1g+kBi5EkpE0vp9pWvBtCDaEqm6YfWxN
         k1duWhY0RhQLCjjuTfS+fXG3thKZZWyjia+7Gx/KbMUqj6n2zS7pzrgCH/NExLRPMp8V
         Ni1944w3UY0X9uBmBoXx4Cmx1r36Bk9SLRPJ6jiK2DCnK6TnB7tysQ58ugn3mFb2uBI1
         faS4ORFfsr+AJTf6Vl4fAQIpC1YUo6CaSr7uVCU+vBQG8WKxaRSzDvQobZiQwkyyBe8Q
         aNN4318zkBK1AkGCAfhF8r5nisv8FP37WE99PK9evmosnxU+t/Z1sOjKAjdOwYL9bIFF
         JTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799331; x=1711404131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9YjALaP/hn1N1s+9XuXIoyFFiEVJsOMKt0K7ANflvs=;
        b=oPzu8qdo+cutSpnMJY7WPcbcuQLtUTkp1s8e3fPGWOIVqF5Ay2LuJNe6cP+VV10G9/
         mmweJ13p7MOdv+n0ltErXr+16VmDowmgeJydEISTSX1BIRJzjexGWouC8nheTTHqr6lX
         pg5Kh+1+zeYdKC4YrZ9js6v3XaoCumcUAeVP23WyoWPRX/AmtjXe5U1ckOHTLwZhOSyO
         nCLP6xsDko8BinzPeSN+GIvkuSDspxPjsQ+ZtotMLl6OjGjIXGchetfBDJoLaUiCybYK
         F0CgdEsyVeDSFjNXW8zlb4sshTgI2ZxoL1RkEaGIayYwG1RPuiBs+fVv9wS4GvD6HGeE
         tovg==
X-Gm-Message-State: AOJu0YzRSpTebWlG8huQ29vG1yNo6Vi2qWm2j/o3mLlt5cIGervVl7pH
	3wYWwDYmG/CJhStqRKE+C2Y/35An/oIYGgBK1Qo3yMnFXVZhKVdFJBcYNw0k
X-Google-Smtp-Source: AGHT+IF6E9o7zGLit5II2+ujC29Av45Yd6zdndxagmMTsSpmB7gG1ceZwEHDk7JDl2w6NWCN8ZPu+Q==
X-Received: by 2002:a05:6000:2a1:b0:33e:7750:781d with SMTP id l1-20020a05600002a100b0033e7750781dmr591137wry.56.1710799330795;
        Mon, 18 Mar 2024 15:02:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 01/13] io_uring/cmd: move io_uring_try_cancel_uring_cmd()
Date: Mon, 18 Mar 2024 22:00:23 +0000
Message-ID: <43a3937af4933655f0fd9362c381802f804f43de.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_try_cancel_uring_cmd() is a part of the cmd handling so let's
move it closer to all cmd bits into uring_cmd.c

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  | 39 +--------------------------------------
 io_uring/io_uring.h  |  7 +++++++
 io_uring/uring_cmd.c | 30 ++++++++++++++++++++++++++++++
 io_uring/uring_cmd.h |  3 +++
 4 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..6ca7f2a9c296 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "napi.h"
+#include "uring_cmd.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -173,13 +174,6 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 };
 #endif
 
-static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
-{
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
-	    ctx->submit_state.cqes_count)
-		__io_submit_flush_completions(ctx);
-}
-
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
@@ -3237,37 +3231,6 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-		struct task_struct *task, bool cancel_all)
-{
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	bool ret = false;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
-			hash_node) {
-		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
-				struct io_uring_cmd);
-		struct file *file = req->file;
-
-		if (!cancel_all && req->task != task)
-			continue;
-
-		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
-			/* ->sqe isn't available if no async data */
-			if (!req_has_async_data(req))
-				cmd->sqe = NULL;
-			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
-			ret = true;
-		}
-	}
-	io_submit_flush_completions(ctx);
-
-	return ret;
-}
-
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct task_struct *task,
 						bool cancel_all)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276..935d8d0747dc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -154,6 +154,13 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 	__io_req_task_work_add(req, 0);
 }
 
+static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
+{
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
+	    ctx->submit_state.cqes_count)
+		__io_submit_flush_completions(ctx);
+}
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 42f63adfa54a..1551848a9394 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -14,6 +14,36 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
+bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
+				   struct task_struct *task, bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool ret = false;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
+			hash_node) {
+		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
+				struct io_uring_cmd);
+		struct file *file = req->file;
+
+		if (!cancel_all && req->task != task)
+			continue;
+
+		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
+			/* ->sqe isn't available if no async data */
+			if (!req_has_async_data(req))
+				cmd->sqe = NULL;
+			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
+			ret = true;
+		}
+	}
+	io_submit_flush_completions(ctx);
+	return ret;
+}
+
 static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 8117684ec3ca..7356bf9aa655 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -3,3 +3,6 @@
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_uring_cmd_prep_async(struct io_kiocb *req);
+
+bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
+				   struct task_struct *task, bool cancel_all);
\ No newline at end of file
-- 
2.44.0


