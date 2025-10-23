Return-Path: <io-uring+bounces-10173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC3AC0390C
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 23:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5E93B3C35
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 21:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198BB245006;
	Thu, 23 Oct 2025 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Xx41vVak"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1DCEEB3
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 21:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761255574; cv=none; b=T0mC850Ph1GBRMmnxmDAoLc8nhn3RpxPCqCb4jS4TQgbV3076Noh4t6feuyL9doKPbqQvXg7ibC7hqmrlO9M1vg2g/9k6bvnjZKbSlzMUrFOpWFLqAfxCbENJd5Lnezay7XgKc4iXEAzsCUmjZWBPv8szJ3zezMjGYFbE7n5Mxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761255574; c=relaxed/simple;
	bh=vktg7TzNejM4HGzP62nJe3a3/sSTdo6B9txohbxks2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a1LDcetxTEpgQ1apm18Yhm44VlYQPmlOLT9B1X70sBY+DSmnZUwvNEiO4nJcZPbKJt9mQf9Bg7jR9C1vnWhj5x0pASTRgXsxy55qR6SnG7Shrwk9MGhmAL32MeEp2ZloqvyxiqYjyZe7MTDKjGBhJ4+xYEqIUPncUdbmWhakFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Xx41vVak; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c2804d48caso1618791a34.1
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 14:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761255571; x=1761860371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RusTwYzmfQt1i/MMnUWOiMy7mTgUsaeXYk3E3ujdD8A=;
        b=Xx41vVak7F9pjtkyhztRXXlCXV8F0atVK1j0zyh1EDOqkU+47gzLhfqdQrKU9mgH2u
         y7Ghxf2AaWAAShzW+xGtuvubRz5nG3XM/jin3AN59cqJ6ljhVCPzhxPxd1XouupiiCaG
         kpSSprNBX7DA0eLxSBYJ1SITglgGd7IA2/HktUBY/oqnLOrWjc21aBDicECowMWPkqZb
         dpk+OoktumsIPoWSCLL4zGsMw3/GnCJQdK+R1i2VJpTaKpcan70DpiMLZ0SZIPCeur8/
         zDcXPdOxcsD02xzTShlglXnmuZCVGfQc7Jv8dG6SyFOjmqQ8E43qWP0CLgQ7nMNenJoo
         suig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761255571; x=1761860371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RusTwYzmfQt1i/MMnUWOiMy7mTgUsaeXYk3E3ujdD8A=;
        b=Iu2jTqTUB/3mPU5ht9h566cxOm+mBqSffEFnVE5lgZ4zbyBdnVB11KserTZF/HWy7g
         1fUzx8qjEHobRq0zBiquA0+cdp+9/WeEb7rs45cPDqsCt07jsJtBj+T5ZBCIUO5DngVX
         Hosqy94gEKIxaHLiTuuFXmq5bkyvIIe5k8eiXXRvEENiiWOehBalQEMrABfHpX2m+zOK
         vBJDZbX7nZ/ArM/NZUsjDPlgvADV0fQ/kafJBukY8b8qLyAu5y22nisQVxfoU+Z9X9Mm
         KW1LUaWMjJPsutmJmYQfrK+YWFB8I8d6gIX1EJ6z3GZe9CBPz6+xLtSTOu174RkN4JWH
         j3KQ==
X-Gm-Message-State: AOJu0Yy23Cw3+d85wVNR4M3jvBACc7sWYJCvsjquMUI0W5JmOUdVb9V+
	nskEkjxhC0es+P4pzd4JWJJFpgeMDQgQwk7tchQLQCEDvv2lIfi06jluObjR1ztd9Q9DdLeX1re
	QHPLJ
X-Gm-Gg: ASbGncvnf8SfQ7Nd3r24V8dDCVeZ4eArRLMJXcp8y15CRnrVr2QB0VnUPNT6EeY2gfW
	o5jsqn5WQQDhr4AWwzMU51PiLFAkNPFQOAJwgh+huUfBpid7oeGbqi9lpc+lXxc6aPCF7BBbEGO
	D+2KL49T+cs2Jz8652K0jkTyig6QrxBFI+jwG/wMfvJHj4XadHf9DRVBxIcizhi1/L+/ru97raL
	F9rRfD3R7nq+FVbZxVOjhMc+q9GLc4ghoU3GMsroRlmfm+XZL9soNhjcMQTEjrvFrlIylqWsn/r
	QZxM6fp0Zy4OuSJDYgTHi6uvdi76aldRirjM+v16l0LuG3fekP1eBB7ALksFlgWPQLPzTeZisrs
	ORUYshY2+xeYsUpOHF0hwHDSVwvZeHUhyWQU5+jDcqgXy3NqL+1T99LfCoCvVZfppE5Y6eT1Jd8
	macxEKRwuZdalRhgg=
X-Google-Smtp-Source: AGHT+IGgUK5gvXJyPWAdvjPmbwbyrBbJXLLjTwwhrM34BooBIU9ikpp8WOZFSTBcvUor7L6A/kDRjQ==
X-Received: by 2002:a05:6808:1984:b0:443:a3c0:893c with SMTP id 5614622812f47-44d918b6e6amr199835b6e.24.1761255571217;
        Thu, 23 Oct 2025 14:39:31 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44bd44c22ccsm739380b6e.20.2025.10.23.14.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 14:39:30 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1] io_uring zcrx: allow sharing of ifqs with other instances
Date: Thu, 23 Oct 2025 14:39:22 -0700
Message-ID: <20251023213922.3451751-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each ifq is bound to a HW RX queue with no way to share this across
multiple io_uring instances. It is possible that one io_uring instance
will not be able to fully saturate an entire HW RX queue. To handle more
work the only way is to add additional io_uring instances w/ ifqs, but
HW RX queues are a limited resource on a system.

From userspace it is possible to move work from this io_uring instance
w/ an ifq to other threads, but this will incur context switch overhead.
What I'd like to do is share an ifq (and hence a HW RX queue) across
multiple rings.

Add a way for io_uring instances to clone an ifq from another. This is
done by passing a new flag IORING_ZCRX_IFQ_REG_CLONE in the registration
struct io_uring_zcrx_ifq_reg, alongside the fd and ifq id of the ifq to
be cloned.

The cloned ifq holds two refs:
  1. On the source io_ring_ctx percpu_ref
  2. On the source ifq refcount_t

This ensures that the source ifq and ring ctx remains valid while there
are proxies.

The only way to destroy an ifq today is to destroy the entire ring, so
both the real ifq and the proxy ifq are freed together.

At runtime, io_zcrx_recv_frag checks the ifq in the net_iov->priv field.
This is expected to be the primary ifq that is bound to a HW RX queue,
and is what prevents another ring from issuing io_recvzc on a zero copy
socket. Once a secondary ring clones the ifq, this check will pass.

It's expected for userspace to coordinate the sharing and
synchronisation of the refill queue when returning buffers. The kernel
is not involved at all.

It's also expected userspace to distributed accepted sockets with
connections steered to zero copy queues across multiple rings for load
balancing.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  4 ++
 io_uring/net.c                |  2 +
 io_uring/rsrc.c               |  2 +-
 io_uring/rsrc.h               |  1 +
 io_uring/zcrx.c               | 90 +++++++++++++++++++++++++++++++++--
 io_uring/zcrx.h               |  3 ++
 6 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..8e4227a40d09 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1055,6 +1055,10 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum io_uring_zcrx_ifq_reg_flags {
+	IORING_ZCRX_IFQ_REG_CLONE	= 1,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/net.c b/io_uring/net.c
index a95cc9ca2a4d..8eb6145e0f4d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1250,6 +1250,8 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
 	if (!zc->ifq)
 		return -EINVAL;
+	if (zc->ifq->proxy)
+		zc->ifq = zc->ifq->proxy;
 
 	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..aae5f2acfcf1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1148,7 +1148,7 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 }
 
 /* Lock two rings at once. The rings must be different! */
-static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
+void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
 	if (ctx1 > ctx2)
 		swap(ctx1, ctx2);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3ca6ba66596..3a9b9e398249 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -70,6 +70,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
+void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2);
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..753614820f8f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -22,10 +22,10 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
-#include "kbuf.h"
 #include "memmap.h"
 #include "zcrx.h"
 #include "rsrc.h"
+#include "register.h"
 
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
 
@@ -519,6 +519,8 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	if (ifq->proxy)
+		goto free;
 	io_close_queue(ifq);
 
 	if (ifq->area)
@@ -528,6 +530,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 
 	io_free_rbuf_ring(ifq);
 	mutex_destroy(&ifq->pp_lock);
+free:
 	kfree(ifq);
 }
 
@@ -541,6 +544,73 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+static int io_clone_zcrx_ifq(struct io_ring_ctx *ctx,
+			     struct io_uring_zcrx_ifq_reg __user *arg,
+			     struct io_uring_zcrx_ifq_reg *reg)
+{
+	struct io_zcrx_ifq *ifq, *src_ifq;
+	struct io_ring_ctx *src_ctx;
+	struct file *file;
+	int src_fd, ret;
+	u32 src_id, id;
+
+	src_fd = reg->if_idx;
+	src_id = reg->if_rxq;
+
+	file = io_uring_register_get_file(src_fd, false);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	src_ctx = file->private_data;
+	if (src_ctx == ctx)
+		return -EBADFD;
+
+	mutex_unlock(&ctx->uring_lock);
+	lock_two_rings(ctx, src_ctx);
+
+	percpu_ref_get(&src_ctx->refs);
+	ret = -EINVAL;
+	src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
+	if (!src_ifq)
+		goto err_unlock;
+	refcount_inc(&src_ifq->refs);
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	ifq->proxy = src_ifq;
+	ifq->ctx = ctx;
+	ifq->if_rxq = src_ifq->if_rxq;
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			goto err_free;
+
+		ret = -ENOMEM;
+		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL)) {
+			xa_erase(&ctx->zcrx_ctxs, id);
+			goto err_free;
+		}
+	}
+
+	reg->zcrx_id = id;
+	if (copy_to_user(arg, reg, sizeof(*reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+	mutex_unlock(&src_ctx->uring_lock);
+	fput(file);
+	return 0;
+err:
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->zcrx_ctxs, id);
+err_free:
+	kfree(ifq);
+err_unlock:
+	mutex_unlock(&src_ctx->uring_lock);
+	fput(file);
+	return ret;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -566,6 +636,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
+	if (reg.flags & IORING_ZCRX_IFQ_REG_CLONE)
+		return io_clone_zcrx_ifq(ctx, arg, &reg);
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
@@ -587,6 +659,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq)
 		return -ENOMEM;
 	ifq->rq_entries = reg.rq_entries;
+	refcount_set(&ifq->refs, 1);
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
 		/* preallocate id */
@@ -730,8 +803,19 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
-		io_zcrx_scrub(ifq);
-		io_close_queue(ifq);
+		if (ifq->if_rxq == -1)
+			continue;
+
+		if (!ifq->proxy) {
+			if (refcount_read(&ifq->refs) > 1)
+				continue;
+			io_zcrx_scrub(ifq);
+			io_close_queue(ifq);
+		} else {
+			refcount_dec(&ifq->proxy->refs);
+			percpu_ref_put(&ifq->proxy->ctx->refs);
+			ifq->if_rxq = -1;
+		}
 	}
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 33ef61503092..0df956cb9592 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -60,6 +60,9 @@ struct io_zcrx_ifq {
 	 */
 	struct mutex			pp_lock;
 	struct io_mapped_region		region;
+
+	refcount_t			refs;
+	struct io_zcrx_ifq		*proxy;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.47.3


