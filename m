Return-Path: <io-uring+bounces-3140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C67C6975883
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAFC21C23848
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE681AE87E;
	Wed, 11 Sep 2024 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8m9LrkG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976971AB6DA;
	Wed, 11 Sep 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072467; cv=none; b=NUTyH5yjjJp+ktpDOKQhGWdojRirrqz7pV8nz+d20VTEBdpY979RIIg72Y88upnaXn4BANo3gTEZtBtK1ER979AyIgyJbGTVZ+oumC/E6n2RgNi33kQI1qKlSkfrPHIvGTe47Ryz6/ew6kZBTcWlVlx7qeGDgq2ZPsHgdq9dEJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072467; c=relaxed/simple;
	bh=2vI0bIvl9+D8oswmBaa6Rx1hzhaGczPhBrLqovoOrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRXRm//JtF2yydHWc5tb5zY4SkNNySMkCHDak9aVcJvZOvZRigIRAg+vIlGYOuzc63au2rtntHyEll8za2B3zXrfmXhkFMvxHi5QhDqjnaDBGyM2zUAR3uHPeZFqBg/kuSh+5+roA+BWp4LZ36gYXFCOpPTSst7oYJzooaVYRhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8m9LrkG; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5365aa568ceso14564e87.0;
        Wed, 11 Sep 2024 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072463; x=1726677263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=K8m9LrkGqbyVhXQheilOU/ZAIWUGKen+T5lGhdBjtZfLDJ2ijYC169s6jjl/N1Whpn
         uMob1BMS18bwK/jhKsRadhlSKbsW9FzDQ5nlVFRNUlO7W207ANDw406K8mDXn3owZFpt
         YYV2TRW1SstgukfdIR0xlRDOe/tEsC2K/FnZIIQz3bXhy5/Uw3f5GFG7fUGGCX6mEkWt
         e8GyeCFGF/hrTXt6uk3+8UQTJ40NxBoFfA6nsCedHXlpUmen3AmJO2hkSyfXtCvDKhXX
         V7Utd9MT05v6RZhBsC751K9OSqrpWJcgE50wYipv7XNHeK9+gauVLkAMNnWygCzrrKOJ
         S4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072463; x=1726677263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=W2VVLlT7Q1TesRwiJwbrcOVzKdFeGn/BDldprVHND/Av2bAAg9LnJxnJ3urboSEJVs
         eIp8RmXagbfft797h8VHwjW4TGGgLHNND4sUw/GNkB4MOyZacIw+ImPk5zEONOwphdG0
         X/l+SveCEbO0E0t9zUS+juczySwSXr2jMSqDgeisK1uGr/iqya4OqKb14ZoX0itpPAWk
         UjR24vSpYXhtyxfqzNaRghFwr+XV2eEr+Q1ZDT5HbDEb+WV1ir/46O8l4o1EmZfGtiV+
         NhYiU0jsmxR/6Y3SIJmANCh/G4LZp6iZsNnEbLL/52wAv5tYtNKtSx/0pBD3zCGo2/nQ
         HrZw==
X-Forwarded-Encrypted: i=1; AJvYcCUFurCcFCs/8CuT27Rq8Pf8KuZ0y+Xqy/FjXjZiVGGgq3eeOKWvmXKJIkQbgB7KyrAcvaiLjEH/oddBCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzK3XRVqLyps/v31jAaM7UMoq0iWq+kz64nSXY/9DZLilcdSmZO
	BPxKP2lZAcuDnWIzcmHeU6AM3vXZb53VnhKwQ8T5psQOZTfKVq0wnpyJCGPq
X-Google-Smtp-Source: AGHT+IEG2kHGTzNGAdSjpEaXDSIgfMbjRxkjuMwMgmsa9Moi42gUvNZP3GJN98tnR/Gf0UwGcIEW0Q==
X-Received: by 2002:a05:6512:10d5:b0:535:681d:34b0 with SMTP id 2adb3069b0e04-5365880bc04mr17121594e87.47.1726072462342;
        Wed, 11 Sep 2024 09:34:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 1/8] io_uring/cmd: expose iowq to cmds
Date: Wed, 11 Sep 2024 17:34:37 +0100
Message-ID: <f735f807d7c8ba50c9452c69dfe5d3e9e535037b.1726072086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1726072086.git.asml.silence@gmail.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
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


