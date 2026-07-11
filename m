Return-Path: <io-uring+bounces-13984-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uicDBQggUmohMQMAu9opvQ
	(envelope-from <io-uring+bounces-13984-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C68F741524
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X1Zp9wP2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13984-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13984-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6693E302C5CC
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387F43C140D;
	Sat, 11 Jul 2026 10:49:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD763C1093
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:49:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766988; cv=none; b=fm8sv966nPxj9Zp6Hh08TbekVXDihoAVr2GEYw5cabJgC7IitLIQdQbulpDqbYCVHZpWyhWIb8C0GWLggdfGMmuDD2uueSReFuVjTVUc14iVBXse8ExXU7SBAon2qdKKxa+Kc2GLETv/Qdm7kAOAJh8cj087mv/n7VYDqoxNXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766988; c=relaxed/simple;
	bh=gTTCHV83GZb/Bal+gYck7KNo+qjn7TgNAMB/9wGRqpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StktlkBBB3hXc0VBFeOyKMieXizv1H/3WnZ/+TLmG9pD8PMMeiCIzaShgooPkQ0Wd0vKI8/u76crtSc64s6vnG+oCXu8QGYMEclMnI9kmNNS5RrZbaYYn9WybuOW8DwRwe5ibgwNbqrOmqIZBBUK4eqS6j3XI708z73idph9TE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X1Zp9wP2; arc=none smtp.client-ip=209.85.218.45
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15b33f7b23so236598566b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766980; x=1784371780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOJdFaFfa4SOaUQ4BYQlac8x7/4MpWuU+Vg+fcYphng=;
        b=X1Zp9wP20NZtG/jSb49zWtiMQJ8rZje+UZMmJDGT9pHBrnlRfGTuezN+NBkYRnrC+g
         KOUqub9yxGAjHGzUzMF8Q9/xfrXHDZXVhNJn2K58XFZbgwEnRtL/xsiM9+L8PNEyPDLh
         G6RhtL/WuRYyP4cXSddOm8QXWYxkogAHAolhZK16jFO/kKVZGeRpD8S6ewRKKVH1efQv
         c/nDOIdXy057WkKVJaPRXO4gVgMKzm55F4hfW6EMRKq0uffU11A0DsgMhfYsJimpKGMg
         /pB69B8wyldMOuqOJPFfP05tpywj8eTNRjw+jEI5bNSh5S1I1642UtjHtiTaTjVIf9T7
         rTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766980; x=1784371780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xOJdFaFfa4SOaUQ4BYQlac8x7/4MpWuU+Vg+fcYphng=;
        b=N2FN3Jj31f93eK59Jb7KJnrFALxeEhJsXiZ3oI6Dt5fZ1/3YxasKJC9zuMkn9XgoM5
         P4JN3Faq1bq4jd6gKcsAzF+Js7DH2F/88wni8/dzLlr+hnEaTLIKL3PxINrCGWhTs27z
         MXXBx3pi6QRrNR5NbDBDYaB0ZMkXGkIqjJHvxuK4Wh15xUTVxFQ0JtudM0a5bxLlcKZk
         guyAslDAH/Jyc3ugg8vwx79mMCILxoOSlgJW34PcZjbV3blapyyRBvsGmsaOEX8o9XEE
         2+XqYUA8Sj5FDsnIX+fI7qwnj622AY5tf0lYLUYH93LbhlpbFuoOH6890Lu2il5pt+0e
         2bzw==
X-Forwarded-Encrypted: i=1; AHgh+Rrlm3eFCmx26sLvWPpj5StTrQBsk8JMe4yn4zaZ+gHWuzmhX1iXu8JBAH4Shu7TSaWzqEgRaVFpOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0NQb072fku15fmcaj9s+Aa739kjxvaMyIZhNK54r/Tpai1Isn
	bB3cwJvPlmUr0CL1UnUJ7P+hX7+DLsh0pzcjWSnwVmtBMCBszqaByiXS
X-Gm-Gg: AfdE7cmkBjaxjqvBpeVw2IoHtcUgYPedF9dR3Bw5TG/k+opnin2VCFdlWMtOl6C04/h
	DXDSbX/tRvHTNqo8ZnmDFaujdjZn2Duu72Yj2rBaEe5Z7umyznF0QwvhzUCPpqR2NEWvNP0al4F
	+cPL3wkpFpLPjalznYiR9YlCdNl11brjC3MsqJfhyNrMoJ0024A5DHkmbIcnGNFsfTloQg/pLAX
	MyYej4uq2cmyZ04mK1jygnMtT13sSQFaALZBTjVn1MKEHRUnFwm8XbpuF8JyfU0h665GV0kafDY
	WGF8BxSFGGE/8ExAyHTYcvu33lGvCamOLqZHtxSTzvXnQpfL6J3GSVkLDnQzbtN3ray4TVosIkC
	88oCW4CKDk5meeym/p1SuS0SwmsA/+FF9WpOlKZXapeTO1xOMkiQUB80br+ZRX2eiFOMDSQLId4
	HQ1p+E868bjnVR9oNh3vlpkV+QAhw1GfYy3AX9i8wIj7vswqF+P4iP7jKu9XnMDss0kBlUY+6JX
	jm5V0dNVJQ2MoXgMoGjmP1tX/IVBeJYoXk2szSzTduwnCxWBw==
X-Received: by 2002:a17:906:b814:b0:c15:c203:c778 with SMTP id a640c23a62f3a-c161f3d1e84mr56050666b.55.1783766980048;
        Sat, 11 Jul 2026 03:49:40 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15beb53b86sm609123166b.25.2026.07.11.03.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:49:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 09/10] io_uring/rsrc: add zcrx backed registered buffers
Date: Sat, 11 Jul 2026 11:48:38 +0100
Message-ID: <cd188445aee6477a09e0908f090106517becc7c0.1783614400.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783614400.git.asml.silence@gmail.com>
References: <cover.1783614400.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,mojatatu.com,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13984-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:netdev@vger.kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:jhs@mojatatu.com,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8C68F741524

Allow the user to take an existing zcrx instance and wrap it into a
registered buffer that will later be used for tx path. We don't want
leaking zcrx instances to other rings, so mark the buffer uncloneable.
The buffer also doesn't ping zcrx but relies on that zcrx can't be
unregistered.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/rsrc.c               | 91 ++++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h               |  5 ++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98b259901185..4e86ad3ee977 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -810,6 +810,7 @@ enum io_uring_rsrc_reg_flags {
 enum io_uring_regbuf_type {
 	IO_REGBUF_TYPE_EMPTY,
 	IO_REGBUF_TYPE_UADDR,
+	IO_REGBUF_TYPE_ZCRX,
 
 	__IO_REGBUF_TYPE_MAX,
 };
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 05877b4c0ee5..583e51748c62 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -19,6 +19,7 @@
 #include "rsrc.h"
 #include "memmap.h"
 #include "register.h"
+#include "zcrx.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -881,6 +882,53 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	return true;
 }
 
+static void io_release_zcrx(void *priv)
+{
+}
+
+static struct io_rsrc_node *io_register_zcrx_buffer(struct io_ring_ctx *ctx,
+						    struct io_uring_regbuf_desc *desc)
+{
+	struct io_mapped_ubuf *imu = NULL;
+	struct io_rsrc_node *node;
+	struct io_zcrx_ifq *zcrx;
+	u32 ifq_idx = desc->uaddr;
+
+
+	if (ifq_idx != desc->uaddr)
+		return ERR_PTR(-EINVAL);
+	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+	zcrx = xa_load(&ctx->zcrx_ctxs, ifq_idx);
+	if (!zcrx)
+		return ERR_PTR(-EINVAL);
+
+	WARN_ON_ONCE(!zcrx->area);
+
+	if (zcrx->area->mem.size != desc->size)
+		return ERR_PTR(-EINVAL);
+
+	imu = io_alloc_imu(ctx, 0);
+	if (!imu) {
+		io_cache_free(&ctx->node_cache, node);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	imu->nr_bvecs = 0;
+	/* store original address for later verification */
+	imu->ubuf = 0;
+	imu->len = desc->size;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->release = io_release_zcrx;
+	imu->priv = zcrx;
+	imu->flags = IO_REGBUF_F_UNCLONEABLE | IO_REGBUF_F_ZCRX;
+	imu->dir = IO_IMU_SOURCE;
+	refcount_set(&imu->refs, 1);
+	node->buf = imu;
+	return node;
+}
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_regbuf_desc *desc)
 {
@@ -898,6 +946,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-EINVAL);
 	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)))
 		return ERR_PTR(-EINVAL);
+	if (desc->type == IO_REGBUF_TYPE_ZCRX)
+		return io_register_zcrx_buffer(ctx, desc);
 
 	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
 		if (uaddr || size)
@@ -1170,9 +1220,17 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
+static int io_import_from_zcrx(int ddir, struct iov_iter *iter,
+				struct io_mapped_ubuf *imu,
+				u64 buf_addr, size_t len)
+{
+	iov_iter_ubuf(iter, ddir, (void *)(unsigned long)buf_addr, len);
+	return 0;
+}
+
 static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+			   u64 buf_addr, size_t len, unsigned import_flags)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1185,6 +1243,13 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		return ret;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
+
+	if (imu->flags & IO_REGBUF_F_ZCRX) {
+		if (unlikely(!(import_flags & IO_REGBUF_IMPORT_ALLOW_ZCRX)))
+			return -EINVAL;
+		return io_import_from_zcrx(ddir, iter, imu, buf_addr, len);
+	}
+
 	if (unlikely(!len)) {
 		iov_iter_bvec(iter, ddir, NULL, 0, 0);
 		return 0;
@@ -1254,7 +1319,7 @@ int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	node = io_find_buf_node(req, issue_flags);
 	if (!node)
 		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+	return io_import_fixed(ddir, iter, node->buf, buf_addr, len, import_flags);
 }
 
 static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
@@ -1656,6 +1721,22 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
+static int import_reg_vec_zcrx(int ddir, struct iov_iter *iter, struct iovec *iov,
+				unsigned nr_iovs)
+{
+	size_t size;
+	unsigned i;
+
+	for (i = 0; i < nr_iovs; i++) {
+		if (check_add_overflow(size, (size_t)iov[i].iov_len, &size))
+			return -EOVERFLOW;
+	}
+	if (size > MAX_RW_COUNT)
+		return -EINVAL;
+	iov_iter_init(iter, ddir, iov, nr_iovs, size);
+	return 0;
+}
+
 int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags, unsigned import_flags)
@@ -1676,6 +1757,12 @@ int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
+	if (imu->flags & IO_REGBUF_F_ZCRX) {
+		if (unlikely(!(import_flags & IO_REGBUF_IMPORT_ALLOW_ZCRX)))
+			return -EINVAL;
+		return import_reg_vec_zcrx(ddir, iter, iov, nr_iovs);
+	}
+
 	if (imu->flags & IO_REGBUF_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f12abaf63270..a44f7dfcd470 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -31,6 +31,11 @@ enum {
 enum {
 	IO_REGBUF_F_KBUF		= 1 << 0,
 	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
+	IO_REGBUF_F_ZCRX		= 1 << 2,
+};
+
+enum {
+	IO_REGBUF_IMPORT_ALLOW_ZCRX	= 1 << 0,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0


