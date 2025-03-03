Return-Path: <io-uring+bounces-6906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1744EA4C5AD
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EF153A4E2B
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B296214A6E;
	Mon,  3 Mar 2025 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1dYdYvB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F0213E67
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017005; cv=none; b=C+Lh6RF/cL0UbeiqwLnvD7t1+1o3jRjFMeiVhih+Nu8syNQhuYogIxJIijLzkorHUJWstHHRUKJEhJTUQ/iCxczBYxAU7jNXR4EeZO1QEDEBClY2vtw0aeYt6lHj6V9nnnF7XTzLq2VU4K9lr0+MJSW9UyYyd46MZcRxp2BhVJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017005; c=relaxed/simple;
	bh=eb7zhO5hrORnDMVtuvQJNO7Eek1fNmob5BJW+IsWq7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAQekfM/0lS5Oyk9L5s8jCoeX2GL2C6CmkXTNrveDODAPQTb/SYzfAPVCqcqvlqpKqiDPVaWjd30BTN32wibHKEjIh3lzzdjb5Ju+MVBw1NRzYDFpA6b2zj0WC1VYXEWP/MK7e/euGR0cisG5f4THm3JB6qDyB3eVW+9Pu2hPr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1dYdYvB; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abf615d5f31so330221866b.2
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017002; x=1741621802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5aJ+LTP0iCupC2CddhzwQvv8bbrm69RkycI+0Z/um4=;
        b=J1dYdYvBvQN04hITLW89jxiYQUVPpbUiRspq2RyfBgzhL85nnG9JG1zJiZeCLZjYxh
         oYSlzzAGkaB1/o/mLD2VYEsi5yEBBHAmDJ2OGIWgi4/MEs9BlvL8zyc41ZbiFuL4IBi4
         EKjKBfrZN0DEhgqHIdYSNxc4tH/KGyGJUY9kRkT+80KjJMAdJkaSEJm6X9Zqu5FQ8v3H
         0DFfoG5ZTQgO6SPKesxecQQSSKRRC5fmP9u+Z8eZx+j/3KH75crvJ7VKkLoFs9Q/tk/P
         zzmogKAqFTLKRrGgD+Ym2xGJa4zQFo23b4RxSg/yOlWWbXC5t/ofsf/G+DF6YkMocgsJ
         ImPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017002; x=1741621802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5aJ+LTP0iCupC2CddhzwQvv8bbrm69RkycI+0Z/um4=;
        b=XbT0abyAcNylEdmQxVJmZZnR/HfbnVJLtCqIcuzYgvmHw1oRzh3Gd8UFUmt5mcCEMW
         y336Iq7r0BHFE1ohO7f3HQ4IpuQ++NqojPm1Pm1oz5P7a5cbiPfK2m2/HVKrEo6MDkpB
         Pppvbalqz3ar6WK9mIW74nagVMxzjKj80Jqu3FlUGQ/gqQNcldvUOmtSHETM71RvSHoD
         ee6x84RcJQ5XFPNlAU4ssR4Nw1b58BvX33Da+n0w8nQf0jFcWL6l5DChwAWVm/rmIljO
         BFQKOKvwXLgAYSZu53aDt9o06pGA8fIUav3FQ67BpJ64hw2PEq5QQsZ19Mt+0gEsRtSM
         x6Tg==
X-Gm-Message-State: AOJu0Yzj0Ma6gNURPJWM0r7w9WXygEI8gvpDV+eUUPaiHk/Wvbz1CUS7
	/JslHceM6dNRm4x8Bv2f1B+/+RyJlBSJ2RhdFunHeXeE1YB6vU+PQWFwQA==
X-Gm-Gg: ASbGncsAaxLcvWY0DCVu6b5J/lHfO5dmQoxAfVL2QLssNxtzh0YZWntHEzvjgwGIw/5
	snXz/cXyTdisjov7ENShmJRHL88aErdUVGZuq/yiy9MfBKx86XciIqKrU+nJvfTePnBPRHaBvf7
	oUtu8/H5IbRoV/e1B9n0yA8PIidiOgErSAP2Xn2Jk2iKvb55Q9h5CpGdYwZq5GO11RSkB4raFiP
	hmc5gxDyd8CP9ZE2LEAR31SBE1/BqGkqd0Sxbydn68j98P+GCToRyLaqFEo5kOTHmllfcU9tlLH
	phAH/JyNanznqfbw0HJYwQ/Kl6Ze
X-Google-Smtp-Source: AGHT+IFLSSgRqADlfOBo5Y3PcN8Gtoj/a1bP99JLnQppEzvqPfXAFuzp1PEJgNNGwrki8ZvH52mEwA==
X-Received: by 2002:a17:907:3f90:b0:ac1:db49:99b8 with SMTP id a640c23a62f3a-ac1db49aa62mr293249766b.20.1741017001746;
        Mon, 03 Mar 2025 07:50:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 1/8] io_uring: introduce struct iou_vec
Date: Mon,  3 Mar 2025 15:50:56 +0000
Message-ID: <c76dd6eddfe98a9b714f577f28bdf20fa0a11dd4.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
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
 io_uring/rsrc.h                | 17 +++++++++++++++++
 io_uring/rw.c                  | 17 +++++++----------
 io_uring/rw.h                  |  6 ++++--
 5 files changed, 42 insertions(+), 12 deletions(-)

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
index d6ac41840900..9b05e614819e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1264,3 +1264,12 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
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
index 662244282b2c..e3f1cfb2ff7b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -3,6 +3,7 @@
 #define IOU_RSRC_H
 
 #include <linux/lockdep.h>
+#include <linux/io_uring_types.h>
 
 enum {
 	IORING_RSRC_FILE		= 0,
@@ -144,4 +145,20 @@ static inline void __io_unaccount_mem(struct user_struct *user,
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
index bf121b81ebe8..e86a3858f48b 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -3,19 +3,21 @@
 #include <linux/io_uring_types.h>
 #include <linux/pagemap.h>
 
+#include "rsrc.h"
+
 struct io_meta_state {
 	u32			seed;
 	struct iov_iter_state	iter_meta;
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


