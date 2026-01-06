Return-Path: <io-uring+bounces-11402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D09CECF7BA8
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AFDD30D84F4
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89A03101D8;
	Tue,  6 Jan 2026 10:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IiUdCWgw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E656130EF8F
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694318; cv=none; b=HGk6C6fCEi9gJTh06pnBEqpMZlFzj3/QYCiPhxjGZgFJcW/2fMKvk5Okope5R0sWwYAkyXLIzFwA2XLfEghrkmqFhqHLfOZcHYgnHfg37hibGiPuOxoSNhiKxxGX90abaKigUVL5xVejx0UlVdGvDv3nqEVr3Y9JDmg3tbaoO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694318; c=relaxed/simple;
	bh=CTyjOdikIllXz8BI25Nj46Whmoo3Z8pMVo8y/8bvoyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1ViH3Jc0Yb9Q3NHLQ9lQOAMVDI4RywoCpx41/NJOO5Y0ajeB0qXqDk43kmXaZeCRO9xKOTSDcKMDE6wcmlESlYhjwBQTWZwVn+zIsle3vmOc8KtHqk2gDoM/GTurNQduKdjmeNS2pb3EC35VfoVoau3IhGeUMym03p+QLu+BPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IiUdCWgw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1mSA7L3QnAz8RBbc9mI88OVQmAvLBm3BQSiom7v/4DI=;
	b=IiUdCWgw1RzCxpgy9GIkM3fL8yYRvy3IR4Aw4dCy3sl6O7TyXE4ykBXBW3oVAAj3vjzb1X
	T+0AU1HL6OmnjuVmYGP5f22TpNQ0xQqDYLlccfzqIQXF1kfHX32mri2aZJ8wntQ3xxNgn7
	9xnFS/fYbpha5vWcAZrontO7nu8Gxlw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-i7AS0tSbMmCjOjcrXIW1gQ-1; Tue,
 06 Jan 2026 05:11:47 -0500
X-MC-Unique: i7AS0tSbMmCjOjcrXIW1gQ-1
X-Mimecast-MFC-AGG-ID: i7AS0tSbMmCjOjcrXIW1gQ_1767694306
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1476C1800365;
	Tue,  6 Jan 2026 10:11:46 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28A2230001A8;
	Tue,  6 Jan 2026 10:11:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 02/13] io_uring: refactor io_prep_reg_iovec() for BPF kfunc use
Date: Tue,  6 Jan 2026 18:11:11 +0800
Message-ID: <20260106101126.4064990-3-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Split io_prep_reg_iovec() into:
- __io_prep_reg_iovec(): core logic without request association
- io_prep_reg_iovec(): inline wrapper handling request flags

The core function takes explicit 'compat' and 'need_clean' parameters
instead of accessing req directly. This allows BPF kfuncs to prepare
vectored buffers without request association, enabling support for
multiple buffers per request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 11 +++++------
 io_uring/rsrc.h | 21 +++++++++++++++++++--
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8aa2f7473c89..ec716e14d467 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1540,8 +1540,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 }
 
-int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
-		      const struct iovec __user *uvec, size_t uvec_segs)
+int __io_prep_reg_iovec(struct iou_vec *iv, const struct iovec __user *uvec,
+			size_t uvec_segs, bool compat, bool *need_clean)
 {
 	struct iovec *iov;
 	int iovec_off, ret;
@@ -1551,17 +1551,16 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 		ret = io_vec_realloc(iv, uvec_segs);
 		if (ret)
 			return ret;
-		req->flags |= REQ_F_NEED_CLEANUP;
+		if (need_clean)
+			*need_clean = true;
 	}
 
 	/* pad iovec to the right */
 	iovec_off = iv->nr - uvec_segs;
 	iov = iv->iovec + iovec_off;
-	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
-			      io_is_compat(req->ctx));
+	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov, compat);
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
-	req->flags |= REQ_F_IMPORT_BUFFER;
 	return 0;
 }
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index bf77bc618fb5..2a29da350727 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include "io_uring.h"
 
 #define IO_VEC_CACHE_SOFT_CAP		256
 
@@ -79,8 +80,24 @@ static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
-int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
-			const struct iovec __user *uvec, size_t uvec_segs);
+int __io_prep_reg_iovec(struct iou_vec *iv, const struct iovec __user *uvec,
+			size_t uvec_segs, bool compat, bool *need_clean);
+
+static inline int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
+				    const struct iovec __user *uvec,
+				    size_t uvec_segs)
+{
+	bool need_clean = false;
+	int ret;
+
+	ret = __io_prep_reg_iovec(iv, uvec, uvec_segs,
+				  io_is_compat(req->ctx), &need_clean);
+	if (need_clean)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		req->flags |= REQ_F_IMPORT_BUFFER;
+	return ret;
+}
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
-- 
2.47.0


