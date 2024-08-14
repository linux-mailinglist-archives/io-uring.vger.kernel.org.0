Return-Path: <io-uring+bounces-2763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49639951948
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E2BE1C22EC9
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2C71AE85A;
	Wed, 14 Aug 2024 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOwHo5Sp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF3A1AE043;
	Wed, 14 Aug 2024 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632326; cv=none; b=TGcr0Yq7/94JXj4MnxviYrw/HadmR0dpz+E5Igmq9dSd5i/OoXm5Rq6jCEwvq6lqvngKCIedG0NogHzgO9UIl8VSN99FxEgWc0RkVW2wHipBxSMRez/JGm7AlcFzK2KHOV1vIFqFEIAO9UzySrD/qB28DuBZywLCXb5bF094FYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632326; c=relaxed/simple;
	bh=D5/M3jfkzlm1q0HAxOF7tvUuDwKusrC3BWOgtmCzAYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZxUp9hixTquPsfj+Gp0AyElKjren+TOrLp9HeczOZLHkILW2J2iAXhr2NdtcVgw6SgY08jnKpvjUC+QXXmmLP/JarBnXEQnnirRctez6DJBgghBbGtMkmoGlTS/4MRWeKwOGjO+9n+SqfWRaj4ItnkSk1xq4fdKKEusxRMxXQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOwHo5Sp; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-530c2e5f4feso6643087e87.0;
        Wed, 14 Aug 2024 03:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632323; x=1724237123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGCUwVa5Kyp0Pg2+kUxIsl/LPJjPrI+WqiYx+qtKk3Q=;
        b=QOwHo5SpGtw1GePy3ddoUvcI9fkE4lAg4+QK94F3ddC95Gs3Hd7uxxxCGf6C6VbiPs
         FUZCZLM94YL5roljyCcweYVXQkY/PGL7/ADLqq3l6srnoeVY5Ke+rfOsY8lUPqqMBF2p
         Ka9J0T9LDE3wp9AasorNIDLo4wg9F4VzSrEvu4JyoBDPammBlEweCOGyi1I7xQ4/evF/
         3fAm1dHCypNM1HXO4KuL2xqJrh16W98g86gR6OwcY5EQGA2qvHGdws0RiLROo2G6N74R
         Bcxbj2PA6xULzCwcT63FLdvZSy9G7C0YXWtNmFTdhZchell6eo46SdZxUiQRj4O0m+lF
         kbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632323; x=1724237123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGCUwVa5Kyp0Pg2+kUxIsl/LPJjPrI+WqiYx+qtKk3Q=;
        b=EVbBexynoJMbLr67yEJAIxRMvK1wiirfHEwr9O5Q11bmzt4YlzQT7c7170XIkuo2cT
         fowYHqCsAvDAptlZwOXO+Bl6hYugfXp5p57D6aHBz3+0VGarign2YEajyOycyHwNk8eu
         arccOGcAzUG9Dv9xyaWoyh/4LSx9MLu4yukuVBD35jAcr687RS/HRKIWIZuwU6F/HTir
         v9LJi34tSFj2FyliQKj9GufBp7KIRxJO0j0VMF7P/73gytTJ2i6dCWmqwWlkyz14DLGH
         uB4NZ4ql/z+jY6phwzR5Vo/GH3OaZJ8FbVDaCWXvVwX+WbA5MAa8fKvhn8Ph63+fW8rA
         hIIw==
X-Forwarded-Encrypted: i=1; AJvYcCVHWpp5CRGs/AeWh0ZMKYAE3kX8Y+1sTHigK73RS84NY+9FCGyE/euiqKbxfTOOXte6RzxJudLog/gdOIrvJVz3HHskfCAuiSNCCRY=
X-Gm-Message-State: AOJu0YyKOxvAOHdys1qkfYnTpSGF/LdRRN7f+vYRiiWyN9XcaknIJ66b
	M2+0aeu7iPIh5NJTroOQ50W2TWRWr272GurVsh+e20KG2LEWqKGUCPK6CosK
X-Google-Smtp-Source: AGHT+IHhdpdAhXAFGJZHpDxWh8B1Ms2Ng2AgCkdonuHrS94jDeJvM4fNY2m5pVGUUhNgCJJpgyCaZQ==
X-Received: by 2002:a05:6512:1591:b0:52e:be50:9c66 with SMTP id 2adb3069b0e04-532edbbe548mr1283237e87.53.1723632322432;
        Wed, 14 Aug 2024 03:45:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 1/5] io_uring/cmd: expose iowq to cmds
Date: Wed, 14 Aug 2024 11:45:50 +0100
Message-ID: <0e94fb94c3d627dbd5c210d00bd6cc3e644d00ff.1723601134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723601133.git.asml.silence@gmail.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
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
index 3942db160f18..da819018088d 100644
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
index c2acf6180845..2896587a5221 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -90,6 +90,7 @@ int io_uring_alloc_task_context(struct task_struct *task,
 
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


