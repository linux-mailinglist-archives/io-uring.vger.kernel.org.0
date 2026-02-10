Return-Path: <io-uring+bounces-12120-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CTmBsF8imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12120-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAD3115A4F
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A1C0303CA7B
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6E01F37D3;
	Tue, 10 Feb 2026 00:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYiYLApS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027D1DE3DB
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683510; cv=none; b=PMUFSBacelFaQOdB+uibd7+O5tDz/pN8UsEN+5aUrCV1LZ/i2n1OTjDT826wCA+UnrMLKsA01gr+XM9jG204yZtGH0UFVqTYzJ4KCQerNRcP8KqORXjMYe3PlmKJlPvU5ac678cewLUpq3oHESNMlWYUWPJ1b9ZrP+I+zpFn8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683510; c=relaxed/simple;
	bh=ImsrZTnAq0Yis0fFuPjQhlH5hUa4cDm8twMqj2OBvNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjvY1ffLQLD4+dh4WkzzzKUu/1JmQYHfO9tafmwxcMKApgjdVaYnG81htHoR2HLKqjey2z9n5bQ5FyKOLk77Y5sjrEMggR+f0ogUdVM54N2WvUL51Lt1kpNza7pesBloqrg6BGK/X5VzT9+hujgPihZ2c5TyewgVQc4arxKMe6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYiYLApS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-823210d1d8eso2016430b3a.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683509; x=1771288309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBKqq8iSnKwHr/PbDpqehowzL5SD+t5lcmJGBhlII7M=;
        b=MYiYLApSkWxIxVRT+kUUfMro+fsa9bO/CHvofYrWoJNbwxZupPYmNFoOtP35ZIfQrz
         rkS1SHarDHB076Wb9veYCyYHMf23RDrhrgLm5tzS5+CVQ07u2Q6gnhOEbp7SF+VW2BRE
         ypJYs+xjgm5poKysZrf4tp7Xur4KMwXS3aIEXTzu6tlqS0LBIQaV/+6yGRKVzyahUUPl
         4wZ7Ct/82T487e7H4NzcoX3IggWe4qlWPnX5qvnOrpGL75rEcsPuP5oUVpw289F5ig/Z
         NC9ngJXhZvAndyLXTFfMSa78EnLeYPhE/c1e3LVVkWY24tML3iaK2+Wiyui32ubNj+Qg
         fviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683509; x=1771288309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lBKqq8iSnKwHr/PbDpqehowzL5SD+t5lcmJGBhlII7M=;
        b=MiAL4UOBOrvK+/AUbxr1BzJa9CvYwtCbH8pIi32W9BSvETP3SPcwSvOjkjP8ib23is
         Y2zSKITuFq1eMFKaeEWkaOe9vJ6I6+0bm8gmK1x/i37NnksRlELhrJDbfv6Fmu7iY3yl
         XyU3Vz970Z/K4y7QwLW1ESYOmuJhMNGR4CoO0VhGLqXQT/+6hxDL8uIiiKF5gDZQZWUU
         /7fE+QchS+nnL4zcZxDJqLrRzepm0z/1eHHxuB49TfdkcyCLMQZWpAcrSbCBkqYsCIWo
         VD8pZzAMZB4/fmpMl0GVhADLEPsFD5iLVwXd8nzDV2P0oMMMTH9uhewy+N6quyA2zstJ
         ZdGw==
X-Forwarded-Encrypted: i=1; AJvYcCVnVcKxR8sQdBZ2mgj5yyn3qvLQ2MjyHBM/c9d7CVCzG8eK+0/pjLzrwYNfIBv5JTOQFx5PAYYvSA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5zs4Ldd1Ui/8yKMPwDDfghGUqRS6+t8d9fm4wuQPFyys4qO6D
	EyyjhdUsDcaob+4rPb0RdYs6DeN1LZbjQKf2SGO9eL9Na+oSsqv4ZrMo
X-Gm-Gg: AZuq6aIPVeXxLb/iFz2dShXPebCFIKrmRQW07RLP0LfPaC2lAJPk5Z5ClhOp6wg0pGl
	1mgonRWo/MmAWNJgOtbcUa7B9z2J9zQEWt1hVKgE+MRlAPoX6R06Ebc8Lof03VJndduhgtloG+Q
	mxUMGjg403pZbdmmFAfPfV2yaEPDX4IH809Oqx7CRwu6kwj/4Ts7LNx6ZRlcSPchol1AFKBhT2G
	mFXvmtli9gIIY7SBc+xTeUe3tq7biqi2Zk/f/7GVFrwPDM/gZOBgkeFWcKlJl9HY1LGvP0ji7EE
	vWkk9ehfTE7n7mt9yqib2wexOGzWtFresOAACx+h3DYGEpCh0emehXD4pGNzw2HTYhr+BWt6BzW
	JtK9tILRIDnPpI6ZmhLK7+D3QJ2TIi5ZD2xf4gRQEHsc+XhFFgofhm8IyIp4CHx7ky20jD8SItD
	UIhCSE
X-Received: by 2002:a05:6a20:7f8c:b0:35d:e4b2:b389 with SMTP id adf61e73a8af0-393ad366d00mr11026868637.58.1770683508875;
        Mon, 09 Feb 2026 16:31:48 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb61d85esm10117585a12.25.2026.02.09.16.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:48 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 06/11] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Mon,  9 Feb 2026 16:28:47 -0800
Message-ID: <20260210002852.1394504-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12120-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AFAD3115A4F
X-Rspamd-Action: no action

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
index 1e8395270227..dee1764ed19f 100644
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
 
@@ -747,6 +793,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
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


