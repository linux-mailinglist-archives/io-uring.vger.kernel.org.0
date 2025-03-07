Return-Path: <io-uring+bounces-6993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC63DA56CE2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 086E7188310F
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC8221573;
	Fri,  7 Mar 2025 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxwjClCx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB7B22156A
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363189; cv=none; b=KDnxADcDClj2aDhDNLbHiXliB9V2xfVwU1+hXMIxqfj7id+1RqZiWfdHPi9e7w0708jUyWRUcp9AR5S/qAnF9xM+CfbN5VntXVXPpxlcp4/qIWS/uNesIfxzRi9hlprnSB+Eug95/V/6if+XrBkWwl+r5GwmxAAHNVKrkY+sJog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363189; c=relaxed/simple;
	bh=1ZJTXrPZn6vLFzJGF1fV1gJqddlvwbfkmv7zOk/8R78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opcr8i6kczZK21H/5XBZKFOkjIx5X3IfMwKaJxLOWECN6GYwamFbSwx0VZM3QVSZBtiqRCA2o6FXFf9vU8++yWlzhkDh/yW9dd53VIRDBZYym4WDBcdoQkvClKX7CxhTG1XC0WaP7S8nWeKj0pYNvwEOy51hMzs7C7GcDlCgNPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxwjClCx; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac25520a289so154799166b.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363185; x=1741967985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHR5hQJDkdouKch6tQfcQ2eHsBRq8rM+srmvQwbKcbs=;
        b=AxwjClCxwmPpiQlldVnIgLCHTph9wWIdm9CE7iZ2Uzaw+V2PlJkE559/zYG7QyrqWR
         cdEih6u92AAZpWKq3ozAbPyw1WBcN8XiqcqT6V3tMxamrYvC7nSk+/lKVpWL6/x/H8bW
         rcGYmXjHk0gD19Ak+QVNdsSOmvvw23AwmP2rkyhxN2Z5KKfWilLsXmKCIKIknv5TQlZE
         +0YyeZLjzXdoOPRY0KoIcnOXhzcmF5fmQxXXzYAXha0kWCrU+0GjlS99RVMUmaUTgCyj
         XwkkdUyrhEA1AQ3G4S2MH1RU3acK7esQGEZERLyYtys9ccku1C7Uv18bzA6gJVHQr0wf
         kMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363185; x=1741967985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHR5hQJDkdouKch6tQfcQ2eHsBRq8rM+srmvQwbKcbs=;
        b=e39AJE95PhiYJZQBDuHOsB+xNoi0v118h/o67NTmCcwQ9q9pevbixefOxFrBhSc/UJ
         KRR11I2DCAkQPx9IHeFgt1sJreVtyZ/7F7fMi3/1694Bwej/uEW2uIOk9f06UYfXx+Wv
         Z/1eHbEHSHuI1inLA1CPX26wAf5enflTQm4Id/6oQaqIX3qrA6/UJdtZp1YXrSl342+R
         G4g3V6030pzTXvsoaWKLS6uBStsdbbKc2jfNQm5P9iAG1ZI0AgunJ2s7mlVscIGiktIF
         CrruaJKGxIXdal87zL5UjtbYPOWk+8XoIvJCycQ0Ls1Qiqluj0guWpHLvo5X7h63FtkG
         cTNA==
X-Gm-Message-State: AOJu0YxgOTZQtfXokwxAg2QVEQdhdkSxI3IB+3xi9NXdtQlqYq71cnjK
	GnPgi6oygPZlFP6IoiozygSBunscNptnFjd2K22uPWXCWZfrEYF5oss0RQ==
X-Gm-Gg: ASbGncvG2I9WGQHPEztjP1L9BAvqj7EWq5JyBslBv+kwQoH5w8LnDAtPnTopSBQBseI
	DtTXLxfXiS4rPt8xHUbrvPc6DFU4KlGYl0GpaHu8WKmIIPb3KHwuhwWMdK9kBooQ4cevMvnPZiM
	ULPnaOyz6bWYIl11QPP0/pNa2JAbGHNmXNsbzfGQPUG+kQcARkion7IReD40mwt5co6RP0+GCxX
	lk9oyiaVEPb0ZLFjrw9pv6EswisIaDpxBhSabdTWCjRMpTC4lHwLR3pw43UrwVRQwvxZWXjhOVU
	3D3/FTvbAqrYDErokh/dt9qCvXwk
X-Google-Smtp-Source: AGHT+IF2MHboKdA9+T38PGP3XzJnMxx60yoUGgR38nYPWNcxHR2BqRlHUK0DPID8YN/AvjSMpFvxEQ==
X-Received: by 2002:a17:907:3204:b0:abf:38a:6498 with SMTP id a640c23a62f3a-ac2530295d1mr410388766b.55.1741363185042;
        Fri, 07 Mar 2025 07:59:45 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:44 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 1/9] io_uring: introduce struct iou_vec
Date: Fri,  7 Mar 2025 16:00:29 +0000
Message-ID: <d39fadafc9e9047b0a292e5be6db3cf2f48bb1f7.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I need a convenient way to pass around and work with iovec+size pair,
put them into a structure and makes use of it in rw.c

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +++++
 io_uring/rsrc.c                |  9 +++++++++
 io_uring/rsrc.h                | 16 ++++++++++++++++
 io_uring/rw.c                  | 17 +++++++----------
 io_uring/rw.h                  |  4 ++--
 5 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 35fc241c4672..9101f12d21ef 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -110,6 +110,11 @@ struct io_uring_task {
 	} ____cacheline_aligned_in_smp;
 };
 
+struct iou_vec {
+	struct iovec		*iovec;
+	unsigned		nr;
+};
+
 struct io_uring {
 	u32 head;
 	u32 tail;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 28783f1dde00..bac509f85c80 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1260,3 +1260,12 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	fput(file);
 	return ret;
 }
+
+void io_vec_free(struct iou_vec *iv)
+{
+	if (!iv->iovec)
+		return;
+	kfree(iv->iovec);
+	iv->iovec = NULL;
+	iv->nr = 0;
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 284e300e63fb..f35e1a07619a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -145,4 +145,20 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 	atomic_long_sub(nr_pages, &user->locked_vm);
 }
 
+void io_vec_free(struct iou_vec *iv);
+
+static inline void io_vec_reset_iovec(struct iou_vec *iv,
+				      struct iovec *iovec, unsigned nr)
+{
+	io_vec_free(iv);
+	iv->iovec = iovec;
+	iv->nr = nr;
+}
+
+static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
+{
+	if (IS_ENABLED(CONFIG_KASAN))
+		io_vec_free(iv);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5ee9f8949e8b..ad7f647d48e9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -87,9 +87,9 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 	int ret, nr_segs;
 	struct iovec *iov;
 
-	if (io->free_iovec) {
-		nr_segs = io->free_iov_nr;
-		iov = io->free_iovec;
+	if (io->vec.iovec) {
+		nr_segs = io->vec.nr;
+		iov = io->vec.iovec;
 	} else {
 		nr_segs = 1;
 		iov = &io->fast_iov;
@@ -101,9 +101,7 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 		return ret;
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
-		io->free_iov_nr = io->iter.nr_segs;
-		kfree(io->free_iovec);
-		io->free_iovec = iov;
+		io_vec_reset_iovec(&io->vec, iov, io->iter.nr_segs);
 	}
 	return 0;
 }
@@ -151,7 +149,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		return;
 
-	io_alloc_cache_kasan(&rw->free_iovec, &rw->free_iov_nr);
+	io_alloc_cache_vec_kasan(&rw->vec);
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -201,7 +199,7 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	rw = io_uring_alloc_async_data(&ctx->rw_cache, req);
 	if (!rw)
 		return -ENOMEM;
-	if (rw->free_iovec)
+	if (rw->vec.iovec)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	rw->bytes_done = 0;
 	return 0;
@@ -1327,7 +1325,6 @@ void io_rw_cache_free(const void *entry)
 {
 	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
-	if (rw->free_iovec)
-		kfree(rw->free_iovec);
+	io_vec_free(&rw->vec);
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index bf121b81ebe8..529fd2f96a7f 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,13 +9,13 @@ struct io_meta_state {
 };
 
 struct io_async_rw {
+	struct iou_vec			vec;
 	size_t				bytes_done;
-	struct iovec			*free_iovec;
+
 	struct_group(clear,
 		struct iov_iter			iter;
 		struct iov_iter_state		iter_state;
 		struct iovec			fast_iov;
-		int				free_iov_nr;
 		/*
 		 * wpq is for buffered io, while meta fields are used with
 		 * direct io
-- 
2.48.1


