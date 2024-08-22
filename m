Return-Path: <io-uring+bounces-2880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C3095ABF9
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2085F1F22111
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53AF38DD3;
	Thu, 22 Aug 2024 03:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MIxi7/wJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114C623741;
	Thu, 22 Aug 2024 03:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297740; cv=none; b=EliF+lJJXRSXIh0J7eu3nkdRZWgJiHdnOfKN3UlfEO3wJV+HcBFluKOCmcncizYRuf6DvmTfPaijfQcj7q2QjJ9X6m2Kl8Bfqzs/w3wCwNNptj1BoYHO2HmEV3UDT2IEUk/AmLq1321hm1VCZzZF2BpaKF6XRDRwYqn0XkhlT+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297740; c=relaxed/simple;
	bh=GlHe35fp35rXqkAwWGeMGxR0hGwDzfbkl8e7VR9Dt9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enCKtCtUTP9Sl3G2s8tsDZT9z01uabBPOnodhSh2yh+G5nZ6BWAt24RTwR7p+a8c/W+sAdrP1Aae7ibDI6lQ54+Pko0ImyUimAcPf5C+dGRBLMJwI1tcwEQbGIJEKfFXh3CQxPZvBd38t6wRCFV8a0uGqepiS2Vooa3myNbqr08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MIxi7/wJ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-428e3129851so1961795e9.3;
        Wed, 21 Aug 2024 20:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297737; x=1724902537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oq1dmJmhMQ/ONS/9FcWt2dsBOZ/rQa7CJ2HEombNkGY=;
        b=MIxi7/wJBUOD5XF+n4Q4NHTIjuhgWpMP4Pj3RbPN+QU9lq7leVEpx396brHuNbKChL
         7z5pHeQEYoMi/gqh7qRScRYG7T+tC80N3dBkZlp82fSc8ckdGCzB159ltEnsysLn9ctA
         PHEq5cuEpRe/ux0WPgZUXxdefzqfNQRcwzH/OUa2o6oNZ+dTJhtyZ/SfIJix34YrfeOz
         vODuP8nsRDylIXFfPi7q3dZVC85/c0Z8NM4jX/+b0Y4gOUHx/tjhV/+u6fbcG8qUnm/j
         A1gTRGmGDIWcznfrq0Gic/IUH8lb3Rk0kHBnXPm5gbp8pdGBFi8f9Qv91W2EVJv9aC1a
         w/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297737; x=1724902537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oq1dmJmhMQ/ONS/9FcWt2dsBOZ/rQa7CJ2HEombNkGY=;
        b=R7WdS6AGmYPIlOn6l9l6+5xJZ4cFuq9PL5Y0Mz2IYMeFlgmx5abHGGxQL/yNGZd+SE
         K1USNIx7WXQGub9B+xwPcJziUt5Um0bfNNC2KP3M6ij0DRbXxQtIwStSPsdwTCgaGbfc
         5ECF5fc+anFgYDMzG29vCdwTbSbcDbPaAMVnqT+Bc28pFBzYoY5rY57IS3rOEwg+HuMC
         +6CanRxcN6ABdRyHhTjQl39cXtdrlSyMKiiK9pKMERK+oGMSW1IoFz9at3a1bEPrNpMS
         dWgqQi1c14JK20pw5Y/BwbffhPyeQRC1K4ClUuXszP+8T3wYFdwXtaAnX9S/O51CJrX4
         sokw==
X-Forwarded-Encrypted: i=1; AJvYcCXegY05eHPAZKdieE/kqos6PSfeg55Bimd4NT4LhjMvdV7nk5TcyxWMi2CxlETluOo6k+cAzC+Bdi8Aog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8degUNnrZKp2V9BmJ/Nc9X/QnkhuuOe0zCENFbAuk+Qf9Q28b
	Rse3zvf7xpSUh+Yj54cd9eGx32hnVo5Wl5sT5JY6w2Sz9S5ryKsjs1v3jw==
X-Google-Smtp-Source: AGHT+IF1YE9cTCYPQ6lqJcA/bVj+/okCLizbljJ5bkv4iDV+o0PRhQhkc+Im1+k1WARHaBsjsN01GQ==
X-Received: by 2002:a05:600c:5486:b0:429:e637:959e with SMTP id 5b1f17b1804b1-42abd2125d2mr33760875e9.10.1724297736489;
        Wed, 21 Aug 2024 20:35:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/7] io_uring/cmd: expose iowq to cmds
Date: Thu, 22 Aug 2024 04:35:51 +0100
Message-ID: <55ce8b5b813a7ca40597457b9afc8fd17d4ff11b.1724297388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724297388.git.asml.silence@gmail.com>
References: <cover.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an io_uring request needs blocking context we offload it to the
io_uring's thread pool called io-wq. We can get there off ->uring_cmd
by returning -EAGAIN, but there is no straightforward way of doing that
from an asynchronous callback. Add a helper that would transfer a
command to a blocking context.

Note, we do an extra hop via task_work before io_queue_iowq(), that's a
limitation of io_uring infra we have that can likely be lifted later
if that would ever become a problem.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h |  6 ++++++
 io_uring/io_uring.c          | 11 +++++++++++
 io_uring/io_uring.h          |  1 +
 io_uring/uring_cmd.c         |  7 +++++++
 4 files changed, 25 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 447fbfd32215..86ceb3383e49 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -48,6 +48,9 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
 
+/* Execute the request from a blocking context */
+void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
+
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -67,6 +70,9 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 }
+static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
+{
+}
 #endif
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a53f2f25a80b..323cad8175e9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -533,6 +533,17 @@ static void io_queue_iowq(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
+static void io_req_queue_iowq_tw(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	io_queue_iowq(req);
+}
+
+void io_req_queue_iowq(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_req_queue_iowq_tw;
+	io_req_task_work_add(req);
+}
+
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->defer_list)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 65078e641390..9d70b2cf7b1e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -94,6 +94,7 @@ int io_uring_alloc_task_context(struct task_struct *task,
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
+void io_req_queue_iowq(struct io_kiocb *req);
 
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8391c7c7c1ec..39c3c816ec78 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -277,6 +277,13 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	io_req_queue_iowq(req);
+}
+
 static inline int io_uring_cmd_getsockopt(struct socket *sock,
 					  struct io_uring_cmd *cmd,
 					  unsigned int issue_flags)
-- 
2.45.2


