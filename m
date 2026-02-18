Return-Path: <io-uring+bounces-12304-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kL7JHnIqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12304-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5F1152C1C
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 715FD3009E2B
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6A92874E0;
	Wed, 18 Feb 2026 02:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYXyVglg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF142DEA77
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383404; cv=none; b=Hg/wHCbqUbqzwe/dlbzh0d3Uee0qB96839PID+7Ye25qDyARffvG1HMazfOD78hMaC1bUkSyPJdA8acG6oKqCttptNpGpbhNahBnc9U7qMhqQ++Rqa91yqif+773/CAddKihg8K0LPtPWJu9zD7SjjU4tyIRmKJCkzIV/bG/PBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383404; c=relaxed/simple;
	bh=6wjOoGCF5WiyhqL83Iw6esoNLldwEPdbmIszWskf6rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdQI19H8FZ1dCTuIFXJj9BqWztJNZQRqRyz3zKU/y+321Mvkm4Y6EvTKd9kHrDdLM5hecZhLdr/8UynLxULOYudtRNw/ZJVe5C/MQW6bhDTba9eC+WheRq7pBcElWOEpMIhFs1aYoQxKicc4MWIKA2IRWTgfYQEJN8zLIytnawI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYXyVglg; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bde0f62464cso1513576a12.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383402; x=1771988202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8yoKDqRtoaIXaObFK9KxsuMy6hUo5txHuMcmhQ4IAdY=;
        b=fYXyVglgBlrV+ADjHIUxbaLs5eJogcVj39Sa/R85Yc7OOg1QtGbxh3TcNXWB6oky/b
         /m/SquhQbEHMc/VinfOFADl2nGRpE2yEYJdN+zZ+xMluTzvS6jyTKX+XxpzIu9hDVvfS
         iaQYEN5oXbjVBySx0AaWbLJmHh+/z65Zdd3aQtsoccdBaV/SVddHWWz8MZun9Ld00QEe
         uUXDOyPM4+bYv3fCzkp5Jm3ZJ5Js9qTYxbNjZCjsOobV63TCNi1Gnt1oOtlOC7Glj5VD
         Q6O7td4WyFI3X2Rv53afygCk6y+crqhqCqPfxbmMi4AXL//vBzJd6sK/ffRBvBNRBPGo
         ppJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383402; x=1771988202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8yoKDqRtoaIXaObFK9KxsuMy6hUo5txHuMcmhQ4IAdY=;
        b=TalxEtkL63P3HpAoB6cm0zxs+tqZ8OSCAl2n+kygZ0GQGUFytmd63ebsl+x2b1/NwM
         XlPnKCTNGHD/c9lfraLO13sMfvsq7wb/xZ1eY48be7ttt2yDY3MaYHVX+rHBULgRb9dK
         szeQRT+OGrlyQsX6NzDbXgGVmrkSs6s87LM+E2vfpsc3/v8VQmyXag/Lr+/n6uHnRCT4
         H5OC6kGEjTPysbXnPlcYq0FSRJO9ZsZfCkQxBYWS/bM3NAPixYY7P1x9TvxSfS99c0Nq
         FbL9Fhi3xvOBqBsLkiP8JA3Ga16b0W18exZTG0oC1HVEcg9MOXWn8ifTzZwGlDHXynwS
         yWHA==
X-Forwarded-Encrypted: i=1; AJvYcCWywSP22iOqIKJiSewy/aR0j+Ycw5/UzxZnOk77Zj6y34zfsIC2Vw0hCBPLcQ8cjubQMYanccWuww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2jyms78r9Baxk50ufAo0ClCsQ/rkqoJz0f8YFlOTRg67QLvo1
	9orNaIT8yOmUfF8El/EZ5B0gbyJzO1rVoDuWvB4Skn602s3nbBM6D52p
X-Gm-Gg: AZuq6aLu/4PcJdGjqgOQx3vQAXu4kua9wLs4TQgi+k2NqOY+it1w52PPcHRkDm8lHbA
	hcddMmrJm+1mrk47kzBGw18fmrc1uHk2w4AwCSyNXslQqj9KzqduESU9HB14Ncn/0/dQK/v0d5Z
	330SZyqQUqGGwN9kq79CSpwDIqkTFnTrMI7yApxRCRiMOuI4U1ByOHWrrJS59btw9Uewu96gMc/
	lCQRU8H9y7S2dE2TqgntOtWk5ki96EeOqmK+7YtLiJ6g095Ln8207WBCJaZODFY0oAyIOkrQTYY
	MBp0Z1C/uM03WQhYgYWdQvc82Osmt+sCqYEj00WqRxnpLsyX6IPVVDWUmu571+3wrN5m8fyxkLF
	jdC3kGw6ys7tvg8U+oW4UFqQaDlQp9e3E2OAAfLcjzQP50LezE5cGeONsParLuUHRZCWsykPjxl
	cynHltc3I8cgoWunKc9A==
X-Received: by 2002:a17:903:1ad0:b0:2aa:e3d1:1438 with SMTP id d9443c01a7336-2ad17431b9amr129107605ad.12.1771383402204;
        Tue, 17 Feb 2026 18:56:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:24::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d5bd3sm112173905ad.44.2026.02.17.18.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:41 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 4/9] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Tue, 17 Feb 2026 18:52:02 -0800
Message-ID: <20260218025207.1425553-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12304-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 9E5F1152C1C
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
 include/linux/io_uring/cmd.h | 17 +++++++++++
 io_uring/kbuf.c              | 55 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              |  5 ++++
 3 files changed, 77 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..bd681d8ab1d4 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 				 struct io_br_sel *sel, unsigned int issue_flags);
 
+int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **out_bl);
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
index efcc6540f948..1d86ad7803fd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -237,6 +238,58 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 	return sel;
 }
 
+int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **out_bl)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (!bl || !(bl->flags & IOBL_BUF_RING))
+		goto err;
+
+	if (unlikely(bl->flags & IOBL_PINNED)) {
+		ret = -EALREADY;
+		goto err;
+	}
+
+	bl->flags |= IOBL_PINNED;
+	ret = 0;
+	*out_bl = bl;
+err:
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
+	unsigned int required_flags;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (!bl)
+		goto err;
+
+	required_flags = IOBL_BUF_RING | IOBL_PINNED;
+	if ((bl->flags & required_flags) == required_flags) {
+		bl->flags &= ~IOBL_PINNED;
+		ret = 0;
+	}
+err:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_ring_unpin);
+
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
@@ -768,6 +821,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -ENOENT;
 	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
+	if (bl->flags & IOBL_PINNED)
+		return -EBUSY;
 
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 38dd5fe6716e..006e8a73a117 100644
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


