Return-Path: <io-uring+bounces-7191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C43A6C828
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 08:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E15B4612A5
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 07:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83CC81D516A;
	Sat, 22 Mar 2025 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MuTRZQM/"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BC61C860E
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 07:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742630201; cv=none; b=NLXMGaCCJyXL9EwNyEeamLwc4WkEY700yR1AAlvLC6XqBy1UCAQ0z/Vy5YALRjDJWns36PfNbDQ+NkXEL++Tf9Hk/Qg7fVuh9eYMMCunt45ZFR3ODsQL7J+cae2rEgo9234Xy0To2WTauWCvdG8rk5L37iqqpdAg2T9qcfM6bM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742630201; c=relaxed/simple;
	bh=QSvtom5fsDb52XtQ6HOZOSMxA2ctImsYQxGNr+cuy40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RRPUOWQi87dSOPsUcmBdLi1EnNon1z2LT0gHp6OqnExXsB+vq56shkfsBM7PbmdENGAaNG8c3bd1ENNIHKSya/kD+LRnMw4OsLdaLgVjHIqhuf+jy4/magQ9ayUJD4LrVp7mkYSc7wSzkH+8WZwpbagMyqpUqEh/iVnuMuYSW2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MuTRZQM/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742630198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkReyEssk8mtVLdddgNO73P+Syi/NSlotrhzaKcHGOA=;
	b=MuTRZQM/6bYXjqdzg0PAz5XjFUYdY5/qD1izEgEgVahQnZO819ENVQVpi+KgQsCZ2FHoZ9
	QJe2qki4aPCoRdCku3n/QqgXAQ/ua+OteP76AcHSZ5QUMEBl1JVt9zWK+Z9PXG1Svm1ac5
	L3B64HjG3GVD0+qxuvgku5cbRBy1hQc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-nVCST-3UOLGOD8CDP4LxwQ-1; Sat,
 22 Mar 2025 03:56:34 -0400
X-MC-Unique: nVCST-3UOLGOD8CDP4LxwQ-1
X-Mimecast-MFC-AGG-ID: nVCST-3UOLGOD8CDP4LxwQ_1742630193
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B12C9180035C;
	Sat, 22 Mar 2025 07:56:33 +0000 (UTC)
Received: from localhost (unknown [10.72.120.5])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C1F91955BFE;
	Sat, 22 Mar 2025 07:56:32 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH] io_uring: zero remained bytes when reading to fixed kernel buffer
Date: Sat, 22 Mar 2025 15:56:25 +0800
Message-ID: <20250322075625.414708-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

So far fixed kernel buffer is only used for FS read/write, in which
the remained bytes need to be zeroed in case of short read, otherwise
kernel data may be leaked to userspace.

Add two helpers for fixing this issue, meantime replace one check
with io_use_fixed_kbuf().

Cc: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>
Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.h | 16 ++++++++++++++++
 io_uring/rw.c   |  8 +++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index b52242852ff3..6996eb8e5b7d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -169,4 +169,20 @@ static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
 		io_vec_free(iv);
 }
 
+/* do not call it before assigning buffer node to request */
+static inline bool io_use_fixed_kbuf(struct io_kiocb *req)
+{
+	return (req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf;
+}
+
+/* zero remained bytes of kernel buffer for avoiding to leak data */
+static inline void io_req_zero_remained(struct io_kiocb *req,
+					struct iov_iter *iter)
+{
+	size_t left = iov_iter_count(iter);
+
+	if (left > 0 && iov_iter_rw(iter) == READ)
+		iov_iter_zero(left, iter);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 039e063f7091..67dc1a6710c9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -541,6 +541,12 @@ static void __io_complete_rw_common(struct io_kiocb *req, long res)
 	} else {
 		req_set_fail(req);
 		req->cqe.res = res;
+
+		if (io_use_fixed_kbuf(req)) {
+			struct io_async_rw *io = req->async_data;
+
+			io_req_zero_remained(req, &io->iter);
+		}
 	}
 }
 
@@ -692,7 +698,7 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
-	if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
+	if (io_use_fixed_kbuf(req))
 		return -EFAULT;
 
 	ppos = io_kiocb_ppos(kiocb);
-- 
2.47.1


