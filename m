Return-Path: <io-uring+bounces-6935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 906A2A4E55B
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B29F8A6E7A
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057DF255231;
	Tue,  4 Mar 2025 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJe2IuyF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DED2BF3EE
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102776; cv=none; b=mHV2/i7ZUF7wdzTWQ6KCWpOOr4OFHm2OUplbd1J6wmWojvfmwyffnl6gZhA6LbcDtd8k5cKK++hz5RSEj6IPhSLiA5dDkIBA1ZoqLFQ/QSzmqqUDK/wJStq+dEzwFBkgt2w7HV4BqJKcvxMrO9X+GiOGfr2q2htk8ow09Otm0lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102776; c=relaxed/simple;
	bh=1d6ejyiPzFsCP/aRWcF09WW+bogzzbEaHRwv2dQmFps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1Ubq68t2G1OuyojDxt+/vMamIF6myVKBHfL3cFg5IsFmh5J5YAFfOyYSSVaqqoIT1+dIEB50ATfllWpTjBmwxSBHbFYCjvibtg1JMOC6NRPaNtqKkxcxrzd7Wuv4Nl1wN0txwQrQXPiZtyPysnMDNdnFj7SRC2ELFGothJqosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJe2IuyF; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso839141166b.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102773; x=1741707573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t91HrX4L7T7hAfZHnOYG8rdRL8w+TWHVfgfNwFTUYR0=;
        b=hJe2IuyFDaDSLeEW6KqnPVlU7WYKsMaRreM8Xbr47dnmMr7vlYl/yJE3mvDbryFhLG
         eerXJeq7lGzVTwZBipAsKOP0Fyksk0mcNuZD1s86fK72FwtA+IBDO3tFUmL9HJyyUSmZ
         YMZuuoCsbTDJ4UnmSlBPGfINVqnEMwLBukDIaUdmDDiLyswOh4+pEtQo5q5oOYqZi2GA
         vGtCyaelIhsiZY3aKBrp/p5NYecj8sO2xXPoUALz6zyNPs3I121rQIgr/LQ+tNW2qbKs
         o3oZ0Aps0xj1oKRM6Z9NQgEyiwi0ehD6E9uwuAoGYQt6YKk68zyT51DyUi9zR/t6d2Xw
         NwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102773; x=1741707573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t91HrX4L7T7hAfZHnOYG8rdRL8w+TWHVfgfNwFTUYR0=;
        b=XouXJqK8bBa8Cf8qD9OYq64Ai9GQLw7aCv2KbWWvaptSUMyYfDJKGOdDKd3TpCGP/+
         sasDH42mK9I92/LySHAB03ynq9O6kpxMyMgVNevOvQcYGhVZ0D+9Q8KQquiMQzbhGXX9
         onWbEOHjCnMVsK/fuFY8EOYmdrTqzE9QR21jjQvBJMaZmWT0E8Nd/gU7MwotbIKO2HHf
         k8sdP4HuvT+vXbC72QgsjzPh3BRIQPDuGFCBRbbWLqHaB8JmwUfOy00i/hKMmhno4bo4
         mNaCEVuPsWeCUAjwMGfw4DXKZit6uHbnUG0QhHQFg76jYdKupFPzkZR5/OlBg785y7M2
         YrCA==
X-Gm-Message-State: AOJu0Yx0/TaZePxQzF26gSUKtjAgud5jpvfBFogsun7SdQlbFhXU2M18
	v76eJivAdCM2Wnu2HKPaDx+pkQntdJiTqyB5B5v+3IpoKwkCO3e/z84SWg==
X-Gm-Gg: ASbGnctiiARZgARFcSmgQa+R4Li436hIcrm+qmqOdy7SlI0vM6Shrp+R75fZ6UHgX7w
	JicV/DyVi9ohWH3IhkRCtZUqF/HzeUvGKkc3tCCUoAlv4MpFtVekUt6k8ansjWVWthmxPBF1fUB
	TJX1bciH3DUAQBUOJZVNhhn1jhfdYOuI124ucAuURpHNTW0a7GLC1yBPRz5qoknCkxXHIVdHiPL
	8+5VMxF2Mnjm6KFALVAxiwfs+tIeuzYElC7jva3BZ3lFheMKvUrdtWXzFJeGG7jnNDbCm8FDdRn
	Q5gyL5e87OAJNu+17XMVHRP9w2dg
X-Google-Smtp-Source: AGHT+IF+gX1CuwYUt5SAiOpKhQHMz0CxBZWBVNKjgKuy/Laqtd/JRSNMG0aJsMwYqsDi8FpDN+yLdw==
X-Received: by 2002:a17:907:2d0b:b0:abf:77f3:d1d8 with SMTP id a640c23a62f3a-abf77f3d653mr972926366b.19.1741102772620;
        Tue, 04 Mar 2025 07:39:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:31 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 1/9] io_uring: introduce struct iou_vec
Date: Tue,  4 Mar 2025 15:40:22 +0000
Message-ID: <c7ce0c6574e31005d193e0f8eafdadfb638cba5d.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
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
 io_uring/rw.h                  |  4 ++--
 5 files changed, 40 insertions(+), 12 deletions(-)

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
index 284e300e63fb..ff78ead6bc75 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include <linux/io_uring_types.h>
 
 enum {
 	IORING_RSRC_FILE		= 0,
@@ -145,4 +146,20 @@ static inline void __io_unaccount_mem(struct user_struct *user,
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


