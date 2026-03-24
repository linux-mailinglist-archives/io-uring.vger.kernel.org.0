Return-Path: <io-uring+bounces-12823-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WI2AJoHAwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12823-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:49:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0933195A0
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C59530E0832
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777DD3FB059;
	Tue, 24 Mar 2026 16:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TDUlEZrY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274723E5EC5
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370307; cv=none; b=fcbEa8wwZAcbPW6EVru0coiXWmcnBLLMMB9/HD6hgAgLhleYaJjUNQwbonLS02Lp6FjEYWsuuygLqoygYcTNNGq6Eo1O40jrxUO9M/PdTs+r6XvYiO1vFmC1grkgmfC7C2daw9/MbmsxkGaTBn9ysY7t/gCAB3Jt2VQsBUMxEfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370307; c=relaxed/simple;
	bh=2uiAGOZMzwS2AU1xbr9rip9UicGOt8hjiQX1y4LeSPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbvfsVXLMxqv6FyR9xmQPq5sNxFbKzxBpst03JrrvPTV9+YGaDjJkHOCXxBKAj7MBSiDh52etVB4SDSHj+kr3YUwioMKFKUSCLirvIVJLjEjXd1Hn/MG5KbVjFu6C4DAfNy8PgmIWKT6AvW+Jkuw8c2p1IkuKhIr9lC/TLstCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TDUlEZrY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mPtJ37TRrzlJTC6iXy5hCQJrY9b1hS1zwNGerPRFB0=;
	b=TDUlEZrYjUabw4xF/oTcKye9oMCAC5OdnoFgyMmHWdu3b0LA02VBa1s79qWpznHB5k9LuQ
	oKOuiFsU8Fe1NHhNaGy+podOTJMl4/uD9X6o0nBR+SVF7XMgE/WmXbWOTJeH0QJqppWF7S
	sTxFumB93LAHMEXA+/O5yT6HxdxNzrc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-xrDAg1NdOWOh-p8zrk9JYw-1; Tue,
 24 Mar 2026 12:38:21 -0400
X-MC-Unique: xrDAg1NdOWOh-p8zrk9JYw-1
X-Mimecast-MFC-AGG-ID: xrDAg1NdOWOh-p8zrk9JYw_1774370300
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E36381800561;
	Tue, 24 Mar 2026 16:38:19 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B1A59300019F;
	Tue, 24 Mar 2026 16:38:18 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 03/12] io_uring: refactor io_import_reg_vec() for BPF kfunc use
Date: Wed, 25 Mar 2026 00:37:24 +0800
Message-ID: <20260324163753.1900977-4-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12823-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0E0933195A0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Split io_import_reg_vec() into:
- __io_import_reg_vec(): core logic taking io_mapped_ubuf directly
- io_import_reg_vec(): inline wrapper handling buffer lookup and
  request flags

The core function takes 'imu' and 'need_clean' parameters instead of
accessing req directly. This allows BPF kfuncs to import vectored
buffers without request association, enabling support for multiple
buffers per request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 18 +++++-------------
 io_uring/rsrc.h | 29 ++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0b3e4cb5e879..49d9f0b05e7c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1453,23 +1453,14 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
-			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_mapped_ubuf *imu, struct iou_vec *vec,
+			unsigned nr_iovs, bool *need_clean)
 {
-	struct io_rsrc_node *node;
-	struct io_mapped_ubuf *imu;
 	unsigned iovec_off;
 	struct iovec *iov;
 	unsigned nr_segs;
 
-	node = io_find_buf_node(req, issue_flags);
-	if (!node)
-		return -EFAULT;
-	imu = node->buf;
-	if (!(imu->dir & (1 << ddir)))
-		return -EFAULT;
-
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
@@ -1508,7 +1499,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 
 		*vec = tmp_vec;
 		iov = vec->iovec + iovec_off;
-		req->flags |= REQ_F_NEED_CLEANUP;
+		if (need_clean)
+			*need_clean = true;
 	}
 
 	if (imu->flags & IO_REGBUF_F_KBUF)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c2c729a9f568..87ee5a76cbfc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -81,9 +81,32 @@ static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 		return -EFAULT;
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
-			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_mapped_ubuf *imu, struct iou_vec *vec,
+			unsigned nr_iovs, bool *need_clean);
+
+static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
+				    struct io_kiocb *req, struct iou_vec *vec,
+				    unsigned nr_iovs, unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	bool need_clean = false;
+	int ret;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	imu = node->buf;
+	if (!(imu->dir & (1 << ddir)))
+		return -EFAULT;
+
+	ret = __io_import_reg_vec(ddir, iter, imu, vec, nr_iovs, &need_clean);
+	if (need_clean)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
 int __io_prep_reg_iovec(struct iou_vec *iv, const struct iovec __user *uvec,
 			size_t uvec_segs, bool compat, bool *need_clean);
 
-- 
2.53.0


