Return-Path: <io-uring+bounces-4979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 072A79D61E2
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C19DD283427
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6371C1DF759;
	Fri, 22 Nov 2024 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JwUEncMp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877C11DF738
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292219; cv=none; b=XoiJ4MJvE0iPJXT1zM4ttfnBVDcRgUh9poCNw5oZ5e+o/gyQ43dgZ34FnibNcf+9WFUQJIpmyyiqdFTquX199BpDKL99CBnusArLP0JYiorlVblTHEDBSaAOMQ06Q/ZdBItK5eSf56r3wQgQ2bSl8EfoZl6HHxCRNFJRNlY6jPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292219; c=relaxed/simple;
	bh=xF3F0FOjBfPlxMd+dGq+wT4hyDi9iVYRTYBV+kH3y7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV8ErlcEzQx+rGtcddjDAsy+EL7PVvDNwjdIvRyAlSsdLKlOuX5jnQeGKGd+f3l4jkOFMwuz/dsXrhfJIzjTuLnF7cOcpamm+pAkUNzKVHsp5dhkstjaNgXUka6CzD28uMaWq8jC1UWHX2MOpEWgawboW7bIovBn4eZAkHNwLDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JwUEncMp; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-71a6c05dc10so1658901a34.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292216; x=1732897016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZyZMmV9iblLjdCcfE3CRt2M+y2t90QN+C7X66Z7Ik8=;
        b=JwUEncMpaXFmEqa2rP0g/KhR1SfXL51xTB9+k4y8I6b+sh7RZDU9WRX/B2c6IQVWNJ
         8Uh2dV/EeUV4rTnh3u/vkA8CXUN23RpTsXVJtA5C+HMwPbO1e3esyhCdcbBC3GiGefAR
         qPqSCXq3WQJrHlsT9AIDPyRRZpwpkwITmMuDdizF7mmxjt7EH/woonqwvQvLH51zb8CE
         S//41+F0HhwTIHkVtGgLt+EJKm3NmoEiTknRUvTqfN6Hunf8KOjuIo5LVEk9Vhw4oiB/
         hAJoVmozGmpxoiaJ6KxiCWmsHg/6XrwySymY58/vFgsaf8eiUb9odQ2aESABZKbA3e/B
         PK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292216; x=1732897016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZyZMmV9iblLjdCcfE3CRt2M+y2t90QN+C7X66Z7Ik8=;
        b=RQz4M+rIsYy4phfTnHobyxdJzSZAynDeQo1PwU0B2kcdVcgWTCC2vkz9vvc27LikCf
         a3DxKSl4w2AmmuFq4W80ANo+PQ2VeP3ejDav/n4u8zooUcNyw0j93c1wMB3pszGJbW2x
         ru8CbIxJmlADdIvJ5iiZej68wY6szQFvdfH4clxtu0z/grZSnMf68yMUA8rQSdCPN2AJ
         JKuQm5DFQG7Ll0ViF0PCYjBWE2g/AAt5i1MnOo7F6zQDDsa1uJV2GFCWXQrjTcnIW3FN
         B+VvFT964EV0KFRgEbYx09dTMb1zXi8/42KYqI3limBlMaQIx5Sc5dLGKe4nQUKBIH+6
         hm8Q==
X-Gm-Message-State: AOJu0Yw50ItphcvzlNfZT7qnMAVM89ZFAWE+JqKuZVTyuxQSgGwT37uP
	GA9Tw2p9Vg2MhaNTPrM2QWXWt0b2GxqlWYVKiFdOCvupVPH32S7SlH0QZ9aKenzIiBkvfREsyAC
	9u5M=
X-Gm-Gg: ASbGncswfW1JSm7t70AdhDqAFTkr+YIy/TF1s48Hra1pcY8QGYBqyHMYY4p42/mBWxI
	NtywqtSHiFYZ7xZeo73mIgYgr6kAnK99ubzHNRn575wDy4cuQLTfKN3FfeVemw3RQBupteikmXW
	RHGDpISZfmjzf0UnJpYv/smZs/AauXvqHQjRfIiKGjLENnzwg3LO4VxkNdM7Y04A2BC5fRiwO30
	ZWIzwdG+36Pifj0iUS2N9eFQwQ2LlPX/2fHftTvOp6x6ba3l0AxVg==
X-Google-Smtp-Source: AGHT+IHfb/QVESXZsxfxYuZvkTUz7HN0XWWtLskg9UiBf5Pi3ZIV68U3amZ2CMhIEhkvAiNKTi4wBg==
X-Received: by 2002:a05:6830:1e90:b0:718:d38:7bbe with SMTP id 46e09a7af769-71b0e598d3cmr4116649a34.11.1732292216260;
        Fri, 22 Nov 2024 08:16:56 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: add __tctx_task_work_run() helper
Date: Fri, 22 Nov 2024 09:12:43 -0700
Message-ID: <20241122161645.494868-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122161645.494868-1-axboe@kernel.dk>
References: <20241122161645.494868-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most use cases only care about running all of the task_work, and they
don't need the node passed back or the work capped. Rename the existing
helper to __tctx_task_work_run(), and add a wrapper around that for the
more basic use cases.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 18 ++++++++++++------
 io_uring/io_uring.h |  9 +++------
 io_uring/sqpoll.c   |  2 +-
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bb93c77ac3f..bc520a67fc03 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1137,9 +1137,9 @@ static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	__io_fallback_tw(&tctx->task_list, &tctx->task_lock, sync);
 }
 
-struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx,
-					   unsigned int max_entries,
-					   unsigned int *count)
+struct io_wq_work_node *__tctx_task_work_run(struct io_uring_task *tctx,
+					     unsigned int max_entries,
+					     unsigned int *count)
 {
 	struct io_wq_work_node *node;
 
@@ -1167,14 +1167,20 @@ struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx,
 	return node;
 }
 
+unsigned int tctx_task_work_run(struct io_uring_task *tctx)
+{
+	unsigned int count = 0;
+
+	__tctx_task_work_run(tctx, UINT_MAX, &count);
+	return count;
+}
+
 void tctx_task_work(struct callback_head *cb)
 {
 	struct io_uring_task *tctx;
-	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
-	if (tctx_task_work_run(tctx, UINT_MAX, &count))
-		WARN_ON_ONCE(1);
+	tctx_task_work_run(tctx);
 }
 
 static inline void io_req_local_work_add(struct io_kiocb *req,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0b5181b128aa..2b0e7c5db30d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -93,8 +93,9 @@ void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
 struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
 	unsigned int *count, unsigned int max_entries);
-struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx,
+struct io_wq_work_node *__tctx_task_work_run(struct io_uring_task *tctx,
 	unsigned int max_entries, unsigned int *count);
+unsigned int tctx_task_work_run(struct io_uring_task *tctx);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
@@ -332,12 +333,8 @@ static inline int io_run_task_work(void)
 			resume_user_mode_work(NULL);
 		}
 		if (current->io_uring) {
-			unsigned int count = 0;
-
 			__set_current_state(TASK_RUNNING);
-			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
-			if (count)
-				ret = true;
+			ret = tctx_task_work_run(current->io_uring) != 0;
 		}
 	}
 	if (task_work_pending(current)) {
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 615707260f25..aec6c2d56910 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -232,7 +232,7 @@ static unsigned int io_sq_tw(struct io_wq_work_node **retry_list, int max_entrie
 			goto out;
 		max_entries -= count;
 	}
-	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
+	*retry_list = __tctx_task_work_run(tctx, max_entries, &count);
 out:
 	if (task_work_pending(current))
 		task_work_run();
-- 
2.45.2


