Return-Path: <io-uring+bounces-3019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA25996C001
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FFB728B9D8
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622C21DC048;
	Wed,  4 Sep 2024 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpH+eCji"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A6F1DC061;
	Wed,  4 Sep 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459467; cv=none; b=B/Y23Aj0yCWOEdLKEj+0Ysl2duVorsXhK5+PDbxFg7l9AE4Th/dAU9tJSyBdj+VvdJszOhLkfmY8KTKNdH07WiOmBfn6SyGzHxeQEAU88VrX4R3bYTfyuCAS/s5g8N5ZoOxXamcPikN0PpIodqZ4WC0I3FmW0zKY1jy7w6oy8FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459467; c=relaxed/simple;
	bh=2vI0bIvl9+D8oswmBaa6Rx1hzhaGczPhBrLqovoOrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1r3Sm8/ibhqnOCRRSO0thKvJSKEwf5NzpdzOi5OKKzihysffa5AlQ+cB8IVY3rJRqY31JioFaMrIsy68+eCWVUx3OylTu3sdjA65xfoPWLBTImAVwkrFkoxoRcP4RhYkaKapLTFjf2U0+OB5oPH2lWDpYYl1EcdZvqWdRAb0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PpH+eCji; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a869f6ce2b9so720257366b.2;
        Wed, 04 Sep 2024 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459464; x=1726064264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=PpH+eCjiJ+OI85hYTRBQPZKPD8oOMsDSurH5VPcCZcfkrla9yAJ7JOD+onWYeRrK82
         ne5T7gLEiPN0LMz0Bht1j+TKRtwX3JH8TurFBpeWHOE27E1x2XTNUBOot5HpjYXp55h+
         m5APIDRChpGrl+dhubE6RwycrSwFEcIMIydAtw6H3WeqEwmjjRHzlxUryvkjMuZHPyGL
         Ewfp40KwqgJYySkxunGsw5TVQgd/bL9k2bWf71URY67gbc2qMYRFl4BhEPbiVZPx0Q7w
         vcXgzTqG4mMxbNSYut+ht3s6VXSt7u79QOCJWpfVeMySI6iUbNuLQoUg0sQNFXNjgIWA
         dFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459464; x=1726064264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=tNYuUmHz0+qEZC0NjKqAq1iD9DRst6CjqZOcq8sNHDDsPnQ4waRSNlKIVIMcPAZbDG
         vs2dbXfJjBoLr5/e3oTRvEjgoWcab43CqpSYncQ+2VQdQ0e+UTavrcw8ZZfA7HApiA1N
         rGIHEoBTQztCOffjPJmu/AU8xhxOrcgW012BSa1yU3ZeOtoG2dn8wnd5GDqEo++sAlTI
         VzQQ4XawsurcyuOSdTuCJ3d09NF+vE0LcwzP14KSMaDD6UbCVfO/CFS10MTjGdLufZLg
         B+MvLFPgbS+NtDrjhspqlsbiMLqCO7P4q5HpIhBUhdh1W6w9usw/kmqKdeQj/AE4sI7w
         q9cQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRzNWS8bBrdx7DeXNoJBMTspLqiQwJBQg2mcIeJw/sFRTdt71V2N1omG4yMQDsKBOfMRhpwFfbr8O2gg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyazpzdMTGdH5ACxlqS2DFdwLTeeoGoLdM0q9OLFrFAW0qH4dY1
	gqQ0DmouNDHUvqZBtoB1FOA7/x7ZXCLbguF7lm8wdv1JpMbspM8kT14RxA==
X-Google-Smtp-Source: AGHT+IH097ivB/9WxgCVpcO8B8ihxC+WO/gvLLOLQq9DQZmLBk0QFnqSJuSVFdgCDV3eF0HI2K1RcQ==
X-Received: by 2002:a17:907:7289:b0:a86:9f56:21e6 with SMTP id a640c23a62f3a-a8a32ed6109mr297583066b.33.1725459462834;
        Wed, 04 Sep 2024 07:17:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 1/8] io_uring/cmd: expose iowq to cmds
Date: Wed,  4 Sep 2024 15:18:00 +0100
Message-ID: <f735f807d7c8ba50c9452c69dfe5d3e9e535037b.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725459175.git.asml.silence@gmail.com>
References: <cover.1725459175.git.asml.silence@gmail.com>
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
index 1aca501efaf6..86cf31902841 100644
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


