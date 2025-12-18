Return-Path: <io-uring+bounces-11186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D3FCCAF44
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E016530B42A4
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C02B2F1FF1;
	Thu, 18 Dec 2025 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKQOagvo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EABE330650
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046887; cv=none; b=i6pG0pQjqU1jATRssdNrg/dUuY4oMqrE1toMOPZ8TS3u4YVVAOGwBaYIlZoBZjN8pYVecWIQifNG5gfiNjjQavVfmoTBxraytC7+zcJZCeO5ZBPaFpbaKbfKf5iD7bmJDIXShU2ByAO32eq3KmswbSt7oSd3LqnVJS1+nCyzjZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046887; c=relaxed/simple;
	bh=/4RZHLoCb4GiD4zAnYngKfei8dqwc+KX7vdsWyFBqzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy1ZGzZWKoqId/BG1Fudpl1n4BZvUo37fUUJR+CamOQrEjJLl3Ejg2cpkrqE4lzvqm89CLxsItfim0LYkqvZTofR1WeCHelUeeUEBWAdX2P8PxG4d6gJRRn9EKribA6nNGXh7COy5pQHBlqSBvikPQL02RgESrOvMvw9Tywl9+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKQOagvo; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c868b197eso449523a91.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046883; x=1766651683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDr/pVQGl4RyBMOb2VLE9p8tCJeLDlxrykePUeVpwtY=;
        b=UKQOagvo6TGmQMdJQLArICiylU7/c59TR6A1K/GELwUB2ZLbIlVw4wuw62cYyGIQng
         jfxJiisZbPLTM+lyqbVfcxaY2fB8iDHRA8owXVJZqWAyd4DHj1R0HvvKCKzKYVJqO7l1
         aN02c3lS/IgpMW49P2JlViTalNg8swMAzMT0i9XXikfJGqZhElck3q5ft5GWgdOqqVuk
         Dvn5ptHxBiRwij5IMHNCGwtQCYDZwGB+Uco9ihXsuwRlN14lGD6FftVx8+RoFeHxbXKw
         XzVNkKHJHkpBsjdcTHvZ4PxSMk5owzqcj6WD6kLM0GG6QDKx7U4zTA1ooMgZm+lhm6rS
         bsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046883; x=1766651683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xDr/pVQGl4RyBMOb2VLE9p8tCJeLDlxrykePUeVpwtY=;
        b=O6zK6+dWDam0PgQDabmPIgrs+dyop86SKH6AL8VosrNSRY8H+uOx1/W1+2NAEJ8njh
         2oXMYOjuzJ56LUMaSOL4FJNWJawcoC4jUjca4RjAGd3FBH8idT4cHqlEPh8Y+Obfd9le
         zqdg0f7DRxOhTSkMxfw4M7udTqgYiLIUwttCHSpytsOL9dQJ3zdE7oELp8qaMdPBmyNd
         aC5GFeuOW8I1aF8Imp9/aI8NuBQGcDgB+wNWRY/6h2ftFUgY/P5cSvcB+UZkJF0YSha6
         5lPmwseDP8VlEjv7bu6VgVzSp4Cm2OKj0qq8WN/IH5DiO0rMB5P+Ni2aZWuNgw8kfKo9
         g5yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBKCrZgW6t6pF+wp0zrv9IVVF5jzi2yNlP56hyuJASjOgk/XIgLTFJXU4rpc4Q8YnWTBWOcOAewg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOHymHhOg96ZGXcIbdivRj/5BCFgd3kzehkzu+qcOx7F3si0u2
	bpscMUjOc1BN1gsGAL+8J21H8ZK2O+k6hfEmlc+8mq7/VR00ym4AILyD
X-Gm-Gg: AY/fxX7SxT9YvB4phqR/3FMiAsJl/g2HyxqMu+NJk9EfpvJaEUQKXEVm8lDB9OcrtIK
	Ihp8lDX9SugwsAWvlmYEHWcw1BYCa0hrrcbLOmzGdYCjm2Gl5IUsZ9IHCSLDJ1pf3C9Z25mM41y
	TgWWdZWlPlOuvDATKm/45j836iixCMWHC/QU4bLdCwZhgmEJDf//R/CmMeAHD8M/QB048DgWsE+
	iQkWS9z41dG/Phgm2XoJHIUb6Gx6rYq00R2Vyx65SL+kBdE7xp6WA/NlsRzMI71Dq+KSvRp5Ftb
	wU2MWtAGVfHa2X0pc/BWQaunnMoQTGQrWAYtNQfJWcDEA/Uw2UCmxe2ZHs9zYnbRF9rtcFeN3td
	Pb+TvP3eqiSP7sYvGNtlMqOMf931p2CjxNoqwES4tSl/DYorwDB7/9+Wh1n5oOeyZKSk6bvuOpe
	kzcCzghWimRGBSE3b3kQ==
X-Google-Smtp-Source: AGHT+IGoBO4dAvcNnka005zSlBVJcUV2ZzsGa6EJKqY1jr7ZHUX60Dabv0NOIujzg6oiUz3pkbLRkg==
X-Received: by 2002:a17:90a:d450:b0:34c:f92a:ad05 with SMTP id 98e67ed59e1d1-34cf92ac1ebmr5214742a91.11.1766046883446;
        Thu, 18 Dec 2025 00:34:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e74546993sm1620838a91.7.2025.12.18.00.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Thu, 18 Dec 2025 00:33:00 -0800
Message-ID: <20251218083319.3485503-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kernel APIs to pin and unpin buffer rings, preventing userspace from
unregistering a buffer ring while it is pinned by the kernel.

This provides a mechanism for kernel subsystems to safely access buffer
ring contents while ensuring the buffer ring remains valid. A pinned
buffer ring cannot be unregistered until explicitly unpinned. On the
userspace side, trying to unregister a pinned buffer will return -EBUSY.

This is a preparatory change for upcoming fuse usage of kernel-managed
buffer rings. It is necessary for fuse to pin the buffer ring because
fuse may need to select a buffer in atomic contexts, which it can only
do so by using the underlying buffer list pointer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 17 +++++++++++++
 io_uring/kbuf.c              | 48 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              | 10 ++++++++
 io_uring/uring_cmd.c         | 18 ++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..424f071f42e5 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 				 struct io_br_sel *sel, unsigned int issue_flags);
 
+int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
+			      unsigned issue_flags, struct io_buffer_list **bl);
+int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
+				unsigned issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -126,6 +130,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 {
 	return true;
 }
+static inline int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd,
+					    unsigned buf_group,
+					    unsigned issue_flags,
+					    struct io_buffer_list **bl)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd,
+					      unsigned buf_group,
+					      unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c98cecb56b8c..49dc75f24432 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -238,6 +238,52 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 	return sel;
 }
 
+int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
+		     unsigned issue_flags, struct io_buffer_list **bl)
+{
+	struct io_buffer_list *buffer_list;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	buffer_list = io_buffer_get_list(ctx, buf_group);
+	if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BUF_RING)) {
+		if (unlikely(buffer_list->flags & IOBL_PINNED)) {
+			ret = -EALREADY;
+		} else {
+			buffer_list->flags |= IOBL_PINNED;
+			ret = 0;
+			*bl = buffer_list;
+		}
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_kbuf_ring_pin);
+
+int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
+		       unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && likely(bl->flags & IOBL_BUF_RING) &&
+	    likely(bl->flags & IOBL_PINNED)) {
+		bl->flags &= ~IOBL_PINNED;
+		ret = 0;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_kbuf_ring_unpin);
+
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
@@ -744,6 +790,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -ENOENT;
 	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
+	if (bl->flags & IOBL_PINNED)
+		return -EBUSY;
 
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 11d165888b8e..c4368f35cf11 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -12,6 +12,11 @@ enum {
 	IOBL_INC		= 2,
 	/* buffers are kernel managed */
 	IOBL_KERNEL_MANAGED	= 4,
+	/*
+	 * buffer ring is pinned and cannot be unregistered by userspace until
+	 * it has been unpinned
+	 */
+	IOBL_PINNED		= 8,
 };
 
 struct io_buffer_list {
@@ -136,4 +141,9 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
 		return 0;
 	return __io_put_kbufs(req, bl, len, nbufs);
 }
+
+int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
+		     unsigned issue_flags, struct io_buffer_list **bl);
+int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
+		       unsigned issue_flags);
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..8ac79ead4158 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -398,3 +398,21 @@ bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 	return true;
 }
 EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
+
+int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
+			      unsigned issue_flags, struct io_buffer_list **bl)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_kbuf_ring_pin(req, buf_group, issue_flags, bl);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_pin);
+
+int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
+				unsigned issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_kbuf_ring_unpin(req, buf_group, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
-- 
2.47.3


