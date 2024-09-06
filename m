Return-Path: <io-uring+bounces-3075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA8096FE2E
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 403861F2439C
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804DA15B10D;
	Fri,  6 Sep 2024 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwR8lEJ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B739B15B0F2;
	Fri,  6 Sep 2024 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663419; cv=none; b=hNzKIkaRhUQx8tBdZYqU56vvh2fCACvNkgjvPyZOogicq5Q0ytrpPSIC1MijlisguVwoM9CBTOsh88WkfZosJjvkE7YtGAaVbtj+DT2hm39inD79sJ5h6cVKVuIOwZ90Qeiij38E9wMzXjj52SmBBKZ20gREictEiGxdctVtQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663419; c=relaxed/simple;
	bh=2vI0bIvl9+D8oswmBaa6Rx1hzhaGczPhBrLqovoOrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O03UiZUSTEuFNn7Zv29VUJNoS81fNMM3wykHCYmsKPl2NbJSx0fOj9BKqbFBWEanJ2jH8bZ5JPlfPa+vWsXOAmAr4+pmZv+iqv+m0D799TCFucuBK0xq0ebaMM3thzt4gbqxAK2fBWIfR+A3q1gKm4CiT8Sq2scaj6h/wVW+5M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwR8lEJ5; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86910caf9cso656010866b.1;
        Fri, 06 Sep 2024 15:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663415; x=1726268215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=SwR8lEJ5ondmHg/1e9TsKsQFdULJuXaDKO/CJ1PX6Aa+RnORvkZqOwG7iYcXRs+7XM
         mtLxrm/mMz5b2lsucTjTGnMVbUCP1ixBvumAB8lBvZfqf1OyTk4MNQKdsABelDMhYlAB
         LDn/ariGe1ewP1jSa8NF+TeGgvdItFIIUx95MObdLBME2lIoLnI0xBDUUvEdWSm1xRHQ
         8RODGEThzPXSTlNdMAO/e7GxkR5UyVxPPimeC1jH26hds6Wf/2Hj8D4J7HE5LNvNyAOe
         Zd81IevGzueFq79TfHzms3sxIfr8rZtyngGMrA7r1bdeqHU7he848wYw3FgK4Md1XB2f
         Mg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663415; x=1726268215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZ8pkxfeOzRC4kA801xaO2cK98vlGCE9d9luTt+J2Kg=;
        b=NeBJokr4yywidkmVUG6GOp7+/9ruUs7AoVhPppGaNn+m22bD8H1tXVt+ovf10CQ8EC
         rUN28Z+PHJbUW7ZciRdxtxCDwSnMgdLJA0dZLm2DtHqzZIzdNZEP7uV5dxKnoiHNOc5w
         4RV52mRu1HYefv5iz/IWz4oTq31dOvz9rPMp1MbpjW4FbnBXh9W+D5OhJffizmdJnSur
         0VGLYvTJHsoRCX/hJwUV3NiedWZiHC94/8O/rINuyltL90Sl3VVtDBdwBtXWclaiul7l
         O6gkUxZvCYc9uEmPklBgBwLCsVeK7pV63GBj0TXJQGybTQ1vEhQtJgrpPWhZHXnS6lqu
         1uAA==
X-Forwarded-Encrypted: i=1; AJvYcCV/9iraSgTK1hMx23znzXVCxXFm0gRHJ/hn8GoGi8ay6H3YO8fVB4tv7FouaJo81VUGnhA/vuIt4x5C8w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Dc8rzJ+ny5zFjRq7Qxq+gRx5pnl9sE9H8gEAHnVDlO0eMjqo
	lKnjCctQa0nZ/QwgxdMqMGO+2TVhrQpIk1ekDMr3ibjRM5uaRQhWZ32ISPSb
X-Google-Smtp-Source: AGHT+IHyXvN1ue7B3ODRoTm6YInUy1vTPF5mt5XLGTBYTGrDKLCROG5nKHfbHCNql8pi+pUWW0OV0g==
X-Received: by 2002:a17:907:2d2b:b0:a8b:58e3:ac1f with SMTP id a640c23a62f3a-a8b595ddc9bmr313555066b.12.1725663415255;
        Fri, 06 Sep 2024 15:56:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:56:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 1/8] io_uring/cmd: expose iowq to cmds
Date: Fri,  6 Sep 2024 23:57:18 +0100
Message-ID: <f735f807d7c8ba50c9452c69dfe5d3e9e535037b.1725621577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
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


