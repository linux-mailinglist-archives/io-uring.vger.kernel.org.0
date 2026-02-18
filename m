Return-Path: <io-uring+bounces-12302-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJ2cOGwqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12302-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2016152C15
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CE26303A859
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B6B2DEA89;
	Wed, 18 Feb 2026 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPSAfiXd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA74DC2EA
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383401; cv=none; b=EaJ+/bAC11MWVoEg4be3ZJVMLuEae8d8JZ44d4jIzDQrG0kyNkCtyefVNmr9sj71N7vvXei6g95fnGSVtfoNX4mV2BJLCGZq0UId/OftuzUYH+nDHrZR+tqQFwOK9hCVS7sGiLOlFsrF+tfvpteysojkAnxFvBe+0XnDfBF1ZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383401; c=relaxed/simple;
	bh=xBYrjpzIn32InVgBtj52opkvOUTntSn7oMyugfS2YLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBpxYuNjXVP7ARYaV9cn5UB7VWegH4+n3y27B/ygpV8sHCthDAsH9V3CHZJNRutdeofOuouxamI3Vn7LFXyUZRCPWy15krQ0o5UfEKZbjfajhcewT7aSmXwaFe5HIgPVrCMa0nU0f2F6PuCenoO69amcbOrR54p5kRBOpVdoxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPSAfiXd; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c6e1dc5c5edso2023380a12.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383399; x=1771988199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZda/7TX8IKtLByQwU7GmFX9uL68jTkjq+OIERFl8I0=;
        b=VPSAfiXdzpBEOf3zKipdPW1qVPCRutefsmmx5kCRyvGK0tja1kjF41QySdae4ZDpWu
         MSRgKjea6+IYn0mw+tNZse0Chk2qCGSPOPUN664Qvvb1ny2g4vOhGBYCBX1m+CyI7t/1
         6FWZQPBCrrL+eW/fN6lBe+v8ZpiWVMEIiZRKff9+MY38uWj6ju6yhZ71hzJDwac5H4AT
         qb6vE/662CHKoLrwOxjx0H8fDmNXGCWZCZfJXraK7xZZiiI0u7bcclPy2zjjoHvtjmFV
         +7dF18D5xu+shd38viBSHsOwsio8ucdb0YTu81x5ZfJ7FaBChTg2s70iGCxPkCJxPVSQ
         xR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383399; x=1771988199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hZda/7TX8IKtLByQwU7GmFX9uL68jTkjq+OIERFl8I0=;
        b=PptNvfRrZ3n9gfzrAGjXmHt8WZGvOlmsrd4ypwZHr6O1gN6RH7cBm8WewnsZO3hFmr
         doBvavqCuLk2oHI/HCQibHv3fzRV6qxafMvjb5DIYPZ6D8FqYpYwHRPhyjfxafoczUrD
         F55qaxXznp8rLaizqqjZbxs5eogfI3+mEnfOz8XNX8guLclvW/jkER8QDz1rJKXr/OpP
         Pz8G2fzZb4tG46e+nHILDpMOyetPfNIiS/qgHhpZxX361AHCzxI+VQF1B+27sAcmVzW8
         Mgimend2BTNYVe9wCd5sjuzUtx3v6ttl8aw5XZuF+TVvnCKleqyvsULRir8UW1o2VGvL
         04zA==
X-Forwarded-Encrypted: i=1; AJvYcCU5SdK7Vx7KyRJbxLeiZgZmMgfKhUieqnEV9KE/pXRWBZJBMzEA6EYwxbOWDyj9QKmLy560bHejVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkJhCUIqirN3PWI/faa6saRJyZvqAmipdT7lPENEr68w0JPObf
	wleTDvOUH1+oTzPqtdJtVy1BC4j79IPAlyqTK516zCG3y8iQ2VHLgeVw
X-Gm-Gg: AZuq6aKzwrsIG/G5eMEG6GrpQGPDQ2hhC3gM2/a4JucpfJ+aBq7FFRl/BpGPuen+SU+
	5odBbaoFz6c7MRdDFe4fEnFnp8wyoln7FRpqUyAtpNmnsJu1vmwqNQtGDBm0dWxKzOKxYRjXosx
	Lg9hJpFGblpUOcia/G8hn5/L2TAVfaEBoesTEL65IrLKDRPeJBua5+X++0RwCNdHVZcubk3FWpt
	J6yeLbN1bo1eNlw8f7Q0H0PMXx4hK8mQJ5lR/1ayNdRmEiUyAbGxKSoEWTi18UnMqWJNc7w62I/
	3R6dOeopmJQcXh4qMssNwqIqJoOO4L/P3VayS7pa7RH9l/Jwk0A0PQ5Rt1k3ITHff+mHi+BMj65
	kwQrFv585u0/hlz60rEmZjm7IlVRid1wbkoaEDdDijo64Mz7D9gb9AaWzFzwO1zyzN2svgVjSuy
	nBHMyPMH4vptRtjJ9J
X-Received: by 2002:a17:902:e811:b0:2ab:3ac6:8cf4 with SMTP id d9443c01a7336-2ad50f37a59mr5080725ad.31.1771383399081;
        Tue, 17 Feb 2026 18:56:39 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d595fsm108344585ad.43.2026.02.17.18.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:38 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 2/9] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Tue, 17 Feb 2026 18:52:00 -0800
Message-ID: <20260218025207.1425553-3-joannelkoong@gmail.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12302-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A2016152C15
X-Rspamd-Action: no action

Add support for kernel-managed buffer rings, which allow the kernel to
allocate and manage the backing buffers for a buffer ring, rather than
requiring the application to provide and manage them.

Internally, the IOBL_KERNEL_MANAGED flag marks buffer lists as
kernel-managed for appropriate handling in the I/O path.

At the uapi level, kernel-managed buffer rings are created through the
pbuf interface with the IOU_PBUF_RING_KERNEL_MANAGED flag set. The
io_uring_buf_reg struct is modified to allow taking in a buf_size
instead of a ring_addr. To create a kernel-managed buffer ring, the
caller must set the IOU_PBUF_RING_MMAP flag as well to indicate that the
kernel will allocate the memory for the ring. When the caller mmaps the
ring, they will get back a virtual mapping to the buffer memory.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/uapi/linux/io_uring.h | 14 +++++-
 io_uring/kbuf.c               | 95 +++++++++++++++++++++++++++++------
 io_uring/kbuf.h               |  6 ++-
 3 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6750c383a2ab..278b56a87745 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -885,15 +885,27 @@ struct io_uring_buf_ring {
  *			use of it will consume only as much as it needs. This
  *			requires that both the kernel and application keep
  *			track of where the current read/recv index is at.
+ * IOU_PBUF_RING_KERNEL_MANAGED: If set, kernel allocates the memory for the
+ *			ring and its buffers. The application must set the
+ *			buffer size through reg->buf_size. The buffers are
+ *			recycled by the kernel. IOU_PBUF_RING_MMAP must be set
+ *			as well. When the caller makes a subsequent mmap call,
+ *			the virtual mapping returned is a contiguous mapping of
+ *			the buffers. IOU_PBUF_RING_INC is not yet supported.
  */
 enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
 	IOU_PBUF_RING_INC	= 2,
+	IOU_PBUF_RING_KERNEL_MANAGED = 4,
 };
 
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
 struct io_uring_buf_reg {
-	__u64	ring_addr;
+	union {
+		__u64	ring_addr;
+		/* used if reg->flags & IOU_PBUF_RING_KERNEL_MANAGED */
+		__u32   buf_size;
+	};
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	flags;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 67d4fe576473..816200e91b1f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -427,10 +427,13 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
-	if (bl->flags & IOBL_BUF_RING)
+	if (bl->flags & IOBL_BUF_RING) {
 		io_free_region(ctx->user, &bl->region);
-	else
+		if (bl->flags & IOBL_KERNEL_MANAGED)
+			kfree(bl->buf_ring);
+	} else {
 		io_remove_buffers_legacy(ctx, bl, -1U);
+	}
 
 	kfree(bl);
 }
@@ -596,6 +599,51 @@ int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
+			       struct io_buffer_list *bl,
+			       const struct io_uring_buf_reg *reg)
+{
+	struct io_uring_region_desc rd;
+	struct io_uring_buf_ring *ring;
+	unsigned long ring_size;
+	void *buf_region;
+	unsigned int i;
+	int ret;
+
+	/* allocate pages for the ring structure */
+	ring_size = flex_array_size(ring, bufs, reg->ring_entries);
+	ring = kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return -ENOMEM;
+
+	memset(&rd, 0, sizeof(rd));
+	rd.size = (u64)reg->buf_size * reg->ring_entries;
+
+	ret = io_create_region(ctx, &bl->region, &rd, 0);
+	if (ret) {
+		kfree(ring);
+		return ret;
+	}
+
+	/* initialize ring buf entries to point to the buffers */
+	buf_region = io_region_get_ptr(&bl->region);
+	for (i = 0; i < reg->ring_entries; i++) {
+		struct io_uring_buf *buf = &ring->bufs[i];
+
+		buf->addr = (u64)(uintptr_t)buf_region;
+		buf->len = reg->buf_size;
+		buf->bid = i;
+
+		buf_region += reg->buf_size;
+	}
+	ring->tail = reg->ring_entries;
+
+	bl->buf_ring = ring;
+	bl->flags |= IOBL_KERNEL_MANAGED;
+
+	return 0;
+}
+
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
@@ -612,7 +660,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -EFAULT;
 	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
 		return -EINVAL;
-	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
+	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC |
+			  IOU_PBUF_RING_KERNEL_MANAGED))
 		return -EINVAL;
 	if (!is_power_of_2(reg.ring_entries))
 		return -EINVAL;
@@ -620,6 +669,15 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
+	if (reg.flags & IOU_PBUF_RING_KERNEL_MANAGED) {
+		if (!(reg.flags & IOU_PBUF_RING_MMAP))
+			return -EINVAL;
+		if (reg.flags & IOU_PBUF_RING_INC)
+			return -EINVAL;
+		if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))
+			return -EINVAL;
+	}
+
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -634,17 +692,26 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
 	ring_size = flex_array_size(br, bufs, reg.ring_entries);
-
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(ring_size);
-	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
-		rd.user_addr = reg.ring_addr;
-		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+
+	if (reg.flags & IOU_PBUF_RING_KERNEL_MANAGED) {
+		ret = io_setup_kmbuf_ring(ctx, bl, &reg);
+		if (ret) {
+			kfree(bl);
+			return ret;
+		}
+	} else {
+		rd.size = PAGE_ALIGN(ring_size);
+		if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
+			rd.user_addr = reg.ring_addr;
+			rd.flags |= IORING_MEM_REGION_TYPE_USER;
+		}
+		ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
+		if (ret)
+			goto fail;
+		bl->buf_ring = io_region_get_ptr(&bl->region);
 	}
-	ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
-	if (ret)
-		goto fail;
-	br = io_region_get_ptr(&bl->region);
+	br = bl->buf_ring;
 
 #ifdef SHM_COLOUR
 	/*
@@ -666,15 +733,13 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl->nr_entries = reg.ring_entries;
 	bl->mask = reg.ring_entries - 1;
 	bl->flags |= IOBL_BUF_RING;
-	bl->buf_ring = br;
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
 	ret = io_buffer_add_list(ctx, bl, reg.bgid);
 	if (!ret)
 		return 0;
 fail:
-	io_free_region(ctx->user, &bl->region);
-	kfree(bl);
+	io_put_bl(ctx, bl);
 	return ret;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..38dd5fe6716e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -7,9 +7,11 @@
 
 enum {
 	/* ring mapped provided buffers */
-	IOBL_BUF_RING	= 1,
+	IOBL_BUF_RING		= 1,
 	/* buffers are consumed incrementally rather than always fully */
-	IOBL_INC	= 2,
+	IOBL_INC		= 2,
+	/* buffers are kernel managed */
+	IOBL_KERNEL_MANAGED	= 4,
 };
 
 struct io_buffer_list {
-- 
2.47.3


