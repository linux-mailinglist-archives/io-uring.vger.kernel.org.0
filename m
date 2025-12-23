Return-Path: <io-uring+bounces-11257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E6945CD7812
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1B5C30329C7
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837011FE45D;
	Tue, 23 Dec 2025 00:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Db5aKKlv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BF020010C
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450197; cv=none; b=jmHNomfYSMbB83+0vy6IySDxJt9Y4UJQh8Lu3bfMzS7dlT1H08LSSpFub7im2pGuwOyRJBGMRbkhOP92WAz/VFB5Y3WG7y8Pc4v/2lBW1a9tLY/vCeMwGPJJS8EZCwfAwGEEI0U2V3so/wKX3riP6x7HRVZFuSSiGY4TGelhc1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450197; c=relaxed/simple;
	bh=HuX7Fp1kQvS5+9jqwRIESTuJ4c7EJm2lu8/5dMMcR/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNfzD+z3f2jZk7ELp5SDl7PP9indDmHRZttcLabuOAYl5fkdnsljVRgFlYYqFU+pJvZKvlItm3zrr+4xksp7pYnv9znasYBj5X2+zFQx08lwLDxa0m9v7Gyob6SOcCvpgWkbfuZYu3pktKHhs3fr6hDi0PgVw9Hjm0YjXkH6wpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Db5aKKlv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29f0f875bc5so64855145ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450195; x=1767054995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05FjmTfkSMR2IxEZMf3kZcvKZ7phCksVi0KMcuf7LKQ=;
        b=Db5aKKlvwBZmOMUq/vFOQwc1aLJhRBLD7VX7Bv2FzmUS7XX6ESlal9pjY7PQmb5w4p
         e+gNSTkg1LgWg2Acw62K17xyLQ6TIcEJYzhQo1u8/cm/n1n8c19/cxrxlS9S2dHO1sbZ
         aVTn0S1FYqBMP5VYY65HjjQyQqUDVI3AYAzeikc+UwSL/U6T3bmZcEQ8H5y2tnhEzRlW
         0jBnZ91eN3UHGgq50pU31iaTGZMa/TwBQC3x4n953scVtEfEhZW5n9ga7p7eqHoTD6yj
         X5YC1RirTs5I1ca5u11qoOa+w3Z5/VEC9dIqN66pskhp3wUoIK9rSYuRm5Bl0j5eldhc
         LYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450195; x=1767054995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=05FjmTfkSMR2IxEZMf3kZcvKZ7phCksVi0KMcuf7LKQ=;
        b=fLrvWgMRcJMg6r2NDiR5QYnH4xboILhYwgDHx/Af9UJkByX+U4jAXVPzYZDRIbk5X9
         pH1ANUKK7IErkJieEE2szSA6I77UqtV/HvJT3M430CZdmkqg9TMP8Lpjmk25WHbpGmOH
         KKTqT8oh1gYAiqGplt3PfEJ8Yair5lewgCM/QCjxVlNEDy0a6slpytsNjCQjGcAtRu+Y
         NAl3ykdJLnvVAeFkeqmxLWmzuATMIMAgUf+HWFZVUrPkO4kJJQ2tqo4RhkO+vPmHhLRi
         lfDVMbZKeiAOefuxG2wzZWDNOizCMOHwAKrd7xwsM56uDVbcMsQ2aMhj++eN5sEVxM1p
         0d8g==
X-Forwarded-Encrypted: i=1; AJvYcCWoXGLJeN7sauS0xvHMM2fxl80rW8Ffhvl59BoTvuM0E5c1F2lRMOEdr/a72cnBYVGM7lJ/8+sxgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyANRSSuggVa1NIo3pOaDfl37RMTRJYm0XYnA/WjhmnTAuPdp1N
	X57lhFx17P99EpAPe/WcKx7M1l6o5BaMRMDqPY6hlYY/uEixKBC+vYdc
X-Gm-Gg: AY/fxX61sP6smrb9T8wYhWjpAJJzLn7IpWw2zPKNxSHpcLRUSFs6koFesM60TW5iFMT
	2AmZj6bcvHFxuqIXjNO0Ah6UbxIVklbcGHIFkAWRo5l2f48UFMJEW84SN9qzKrqHot0COC5lHW8
	nw02WtUR5T+8ggC6JN9ssEX29kATNtvh0BVlFzKIY9D2Ar0uA4CWuEZHH9AsIpLzU/gjVnSpJJp
	5hy7DaznyP+pBQJZaMcfvnsWFrePrtjkUFDq9TZ4Qx9d9mOsR0+j0V8ZjFz3rD5upAXrsqpGZPC
	fF4S4+mxRhlMPcAZB2+y7fbC9rKkF2jKGkmHjCHLUE6oDG2lyLbR3RjIYF6jDSSd4ZAdiRmFEdW
	tfDn4n3l4qAgwGKfEtqAneLDTcEQvOYfXUToafhEo2XSR7gBjh+Gnp4c7S3xNgkf5kgXm4cqDuO
	AV0t0hwzM+Zbtn5exGJQ==
X-Google-Smtp-Source: AGHT+IEmGhlUTNg7urRDoZvMzlPQrU8SjSvVjEpf+MtwlwMSrACuurcsGMG8JMoB4Sd3EfH9n/DU9Q==
X-Received: by 2002:a17:903:234c:b0:2a0:b7d3:eec5 with SMTP id d9443c01a7336-2a2f2736de4mr117128745ad.33.1766450194977;
        Mon, 22 Dec 2025 16:36:34 -0800 (PST)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82a9asm109453205ad.30.2025.12.22.16.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:34 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Mon, 22 Dec 2025 16:35:03 -0800
Message-ID: <20251223003522.3055912-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
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
 io_uring/kbuf.c              | 46 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              | 10 ++++++++
 io_uring/uring_cmd.c         | 18 ++++++++++++++
 4 files changed, 91 insertions(+)

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
index 8f63924bc9f7..03e05bab023a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -238,6 +238,50 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
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
+
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
@@ -744,6 +788,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
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


