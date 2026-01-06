Return-Path: <io-uring+bounces-11403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F7DCF7BAB
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF14E30D8FFF
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED8E30FC2A;
	Tue,  6 Jan 2026 10:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTXVc4rr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFD30CDAE
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694320; cv=none; b=bRll0LRj3IhhlcKjZeyivuovYmvBziVC2GsIsTA6Wbs4VNFjJ7PyWE6eAT9C3Kj/vFQA/2CaCcHUFo5XDOZSKc/oKAQm20WFcorpRTHw/p4ro505sjyQi6eVVi86snEXw7+TOzGeiCVaB7/CjG8HPFA60Fw41A8Dt2T7vgcBePI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694320; c=relaxed/simple;
	bh=cgzugxSDTmtzSR8exf7Hgm/DoYPK65rFz72w18Unhzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J88CnsXEonqowYp34fbLhI4DkFDAOVUDf9HPt7sjMjexgr4dRJSu7bMNz/b7fsxTBVDG4SDOWESOf7J5tyXvGNyqH5VLwYeZXr14jyccoFCg2MWpiQNmJxWFTJSgWHAigHGgyYHnIohjVG00vX9wyC/KqsZ5Ja3p9XkMeoCrAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTXVc4rr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSd/ppsQChIxDKrSyspdUTohvq+UtTFL+kJi7YUNAn8=;
	b=eTXVc4rr3oIdZcurUeWUHV1+Js6bQSFgxq2+hwiqhQ2xcBo77c3VmYSCJE6fAHRaiJjx/R
	95t8pPfsQWUyvGUhC6+BUL6o5lD5ornikPyOxXgWahSIvm6r5Rtq4cf1gPC9B1B19jBbqI
	WfxxNa+66jRzoyUp3IthzXPFCWn6k5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-c6CV7GKqMkCQ6JYFJSbMIg-1; Tue,
 06 Jan 2026 05:11:51 -0500
X-MC-Unique: c6CV7GKqMkCQ6JYFJSbMIg-1
X-Mimecast-MFC-AGG-ID: c6CV7GKqMkCQ6JYFJSbMIg_1767694310
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9E2E1800654;
	Tue,  6 Jan 2026 10:11:49 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C28D1180044F;
	Tue,  6 Jan 2026 10:11:48 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 03/13] io_uring: refactor io_import_reg_vec() for BPF kfunc use
Date: Tue,  6 Jan 2026 18:11:12 +0800
Message-ID: <20260106101126.4064990-4-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
index ec716e14d467..7eb2c70185e4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1476,23 +1476,14 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
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
 
@@ -1531,7 +1522,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 
 		*vec = tmp_vec;
 		iov = vec->iovec + iovec_off;
-		req->flags |= REQ_F_NEED_CLEANUP;
+		if (need_clean)
+			*need_clean = true;
 	}
 
 	if (imu->is_kbuf)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2a29da350727..3203277ac289 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -77,9 +77,32 @@ static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
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
2.47.0


