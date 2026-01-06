Return-Path: <io-uring+bounces-11401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1396CF7BA5
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 659B030C9B10
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CB031064A;
	Tue,  6 Jan 2026 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqGMQon2"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E830F94D
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694315; cv=none; b=b+E9kOkqUbn8IVo7K2/BV3beXg9fnjEnU9oV4mYijmw199bY/fI5+SqK15PBY5Ig2lJ0bDbba8Q88waD1yvrXyfD07WSvylDqGhijIzh5WikrMUFoKvWGG/OndKrvoLB5+70qs4cgBoo9nObjnuKBkFneIsKSXq5K1ZdB5h8BXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694315; c=relaxed/simple;
	bh=M9OzmV0GY8BoajeoVrKvvGsIhiRrF795D8K8CMbjTA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDdKiN25xHgUQ2yCpuSzg+lwK+f/FOGQdca4p/77q8sDfb+EqyRwt4ey4KQ0pk4EOP34+cXbNv0VjfSW2yeV890CjhLLrU4/t/QnpbGKjdz2BD33edtBbSgPRxOwqeJomNY5Xd/YE9sPK+fM+5tcxA3V8wvKK4/K8F6pN1PI/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqGMQon2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U9N11oCln4XxEkYDO1PkcpxUNQsemqrZYTRzvie6Sw4=;
	b=aqGMQon2rx/CzFYk0WB1TdSfav/KCkogTNSvBTQZfQk/vwctAVT8qhvBVQ9WxU0EC8T12C
	WBG/2z3Qn+KPTKuLM2ptrutgvcGIpRLmYKd7/EwzLPWLpK47tE3j/OcodGg7laFYyZ9FvC
	+HUWEmX2f0VmU0gQ3l80DZansFHbb+M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-r8xWLMVbNCqHdlHgMS_6cg-1; Tue,
 06 Jan 2026 05:11:43 -0500
X-MC-Unique: r8xWLMVbNCqHdlHgMS_6cg-1
X-Mimecast-MFC-AGG-ID: r8xWLMVbNCqHdlHgMS_6cg_1767694302
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BD11800358;
	Tue,  6 Jan 2026 10:11:42 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A8841956048;
	Tue,  6 Jan 2026 10:11:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 01/13] io_uring: make io_import_fixed() global
Date: Tue,  6 Jan 2026 18:11:10 +0800
Message-ID: <20260106101126.4064990-2-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Refactor buffer import functions:
- Make io_import_fixed() global so BPF kfuncs can use it directly
- Make io_import_reg_buf() static inline in rsrc.h

This allows BPF kfuncs to import buffers without associating them
with a request, useful when one request has multiple buffers.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 17 +++--------------
 io_uring/rsrc.h | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..8aa2f7473c89 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1069,9 +1069,9 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+int io_import_fixed(int ddir, struct iov_iter *iter,
+		    struct io_mapped_ubuf *imu,
+		    u64 buf_addr, size_t len)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1140,17 +1140,6 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
-{
-	struct io_rsrc_node *node;
-
-	node = io_find_buf_node(req, issue_flags);
-	if (!node)
-		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
-}
 
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..bf77bc618fb5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -61,9 +61,21 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
+int io_import_fixed(int ddir, struct iov_iter *iter,
+		    struct io_mapped_ubuf *imu,
+		    u64 buf_addr, size_t len);
+
+static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+				    u64 buf_addr, size_t len, int ddir,
+				    unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+}
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
-- 
2.47.0


