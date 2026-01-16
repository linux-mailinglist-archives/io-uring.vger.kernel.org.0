Return-Path: <io-uring+bounces-11774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6DED38A1A
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6A90306C3E8
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E3315760;
	Fri, 16 Jan 2026 23:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COTU+o5r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B7019E968
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606275; cv=none; b=q20Ia8Wr78zFUQJc5ENxL/LcvSHqN+qAT4Z3A3pakIRRWUPDHyPYXaw7KOrtBl/zIqq63Mdq2MShGgYUQpT8xFluCTvNCuYN0XKLncZWLMplESRDSaiJ3pDhU1LIyQw46ubF0q3mxRQ/TXbbrL1/7RRazdsCvM0h88Ex8/DgJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606275; c=relaxed/simple;
	bh=k0eAhJDRXVC7dfOmvjoYjFkALeuOpZdfIZmyyrrTWS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRBuQU5Ec5MSz2iVkFHhez5WUnjWPWvvTQJ9pkdJ4Xp+XG3SqQlL9DztThOK8BSP5s5zX53g+0tFJKWwxwxPs4POZGnhhYFPcObxLkFxJYask27u7OFG7Gy8ZxDBxupOEPrvSSrb1YEWHf87uWGuZlTeLOVOtf9NrwAAya8+GCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COTU+o5r; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-81df6a302b1so2312318b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606273; x=1769211073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZG58lf4bS9ax7y8bZNaH2oVovcBQ39ltWCqrr6mRY8=;
        b=COTU+o5rNYbCZ+ahZ8Z0zezYWBm4IplShYj+v0TlyTX6fLyEOxzVsUgTpygJ9EFTXt
         aJNpaB5blWS/26+DX/zdK9OPsaNJ7zRtJ9VuI7k0zlmi6JPKyBfw160KyPqdP6HxfDDL
         iOEfLh9ePUAwjll2V1I/PZhwx7yPzCQkPCNPIObi+XrwXeF6WXmFuv79OFBddEBL+OjR
         a+VdpNCf+tIl4JsszR25yNZ3kncE4uNLgQ+GvF2S6TahO3ktgGmP6+ioQtdGwC4F7ZBN
         RMLycHmXqB1gIE1vrrkSiVdr4wzOWBPs/iVkNDZtsx/p2aYdOJPRxxXIaTlu97YkvWk9
         owjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606273; x=1769211073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CZG58lf4bS9ax7y8bZNaH2oVovcBQ39ltWCqrr6mRY8=;
        b=YQPuDo/ds8qeuI0Ef9gVacO+UCWqzjOn20dLVIjnosGdFi1b1+FfrtVfuUK8+UnQp+
         t8MgbImJxT+9l71CyPOJ6QdYX65T29lqSmESdG0iA1FVJQGk9pszzEI6luNwSBDS9GgJ
         2HI+F69bVgZujF/1pdSquqXC49iwEPbEQuyOKZPzhfeheGsR20vhfHF5XmIhrguAZ4Ov
         HdybdVwTMhq5o90EJJa8E66VSTAbx3oknqLRD8AAbpi/c7bZrHy0hv6X+gJdcXBXBNaX
         M8sMkXEFMQ2WeLo99C2a9GkY2YUumexC80NyKJX0smwJQvWzO4WS/kxA1wx0Y4hegL0i
         LWGg==
X-Forwarded-Encrypted: i=1; AJvYcCXsI+dFQwBZELSoEnD0KbbpQdOAdK0PTOfBVFVLG04fuZNPDbZfXq8vdZxKZSrtLbh2j102ydVQ5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKTyQ4fyW7mXZMuig8x1xptialkzKDDx604EA6J6mIyhq8fr7/
	1+aUEtdESj+QoAALIUexoL2rbl2QNuxLK4zR8+6R8FAmMXKhC6fRBoAA
X-Gm-Gg: AY/fxX5zShiM1xOXmcPEubALYYRTF+Cofj88eZSiUzAkdguHKV1t2WT67pLk+bpTvpw
	waoom/jYbtP5SVvqrnYVn4So0+khBVssil9KM1t1ZVQjAUoCMNcQjgWy/3TLETSK3p5kafk2TXI
	OB3DJBFQPiFZY5S/7N0+zsU9RtagIEZY/dmYV+jqTc7JjXJL9ly1NihmWgUdPNUjUO/XWgYjKuF
	Oo1PO0y8JgbVcwv33rAQ3teT0MmV84ddRvfUUW9+1EUwUyLFp1wtYvj1W2bz9K/OQnlWHKhu61v
	SWfLt6Kss/UEe6n+lh3o999csQAX2XZfZ/zoLn5NQdOKzgVPChHabjYp7arjFLx3fP7Gdnt4x2Q
	FF344sgHl/uNnEcZgtZPWWPUiHFeIZMaQxKjA7APD4y5w5f52mxikUckQPd7RBkE3DB5cSv6NqJ
	I2sfzysA==
X-Received: by 2002:a05:6a20:258a:b0:334:a11e:6bed with SMTP id adf61e73a8af0-38e00c6a775mr4281888637.29.1768606273587;
        Fri, 16 Jan 2026 15:31:13 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf249bdcsm2832317a12.8.2026.01.16.15.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:13 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Fri, 16 Jan 2026 15:30:25 -0800
Message-ID: <20260116233044.1532965-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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
 io_uring/kbuf.h              |  5 ++++
 3 files changed, 70 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..702b1903e6ee 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 				 struct io_br_sel *sel, unsigned int issue_flags);
 
+int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **bl);
+int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
+			    unsigned issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -126,6 +130,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 {
 	return true;
 }
+static inline int io_uring_buf_ring_pin(struct io_uring_cmd *cmd,
+					unsigned buf_group,
+					unsigned issue_flags,
+					struct io_buffer_list **bl)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
+					  unsigned buf_group,
+					  unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d9bdb2be5f13..94ab23400721 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -237,6 +238,51 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 	return sel;
 }
 
+int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **bl)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_buffer_list *buffer_list;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	buffer_list = io_buffer_get_list(ctx, buf_group);
+	if (buffer_list && (buffer_list->flags & IOBL_BUF_RING)) {
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
+EXPORT_SYMBOL_GPL(io_uring_buf_ring_pin);
+
+int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
+		       unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (bl && (bl->flags & IOBL_BUF_RING) && (bl->flags & IOBL_PINNED)) {
+		bl->flags &= ~IOBL_PINNED;
+		ret = 0;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_ring_unpin);
+
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
@@ -743,6 +789,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -ENOENT;
 	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
+	if (bl->flags & IOBL_PINNED)
+		return -EBUSY;
 
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 11d165888b8e..781630c2cc10 100644
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
-- 
2.47.3


