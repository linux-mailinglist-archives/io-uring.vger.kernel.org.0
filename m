Return-Path: <io-uring+bounces-12821-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C5/CZO/wmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12821-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:45:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF2031949D
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1D8A308B241
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9902C38B13F;
	Tue, 24 Mar 2026 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUUl1Gnw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552893F20F5
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370301; cv=none; b=WHSJCSlDEShyAQGBM0ouUbMnku+B61WdUOnsvW8rnkHHXeY6fUA97OqXJF8xOtmkQCD4oDfFcsrKY/YMQcOZDxqAZ2v0RKjIDtdJbTFwtFNrxO7VX90vK++4tD/TpjdsSzghNxrHpazLay+kwfnc21HCRQcu8pn75vtKkfrFAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370301; c=relaxed/simple;
	bh=7oJx0y/cefMmwkpRYoxWVtAiRHqX2i8rUXOSpQdRbnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5jcCY+h3UMb9Crd18V75AuN0PHOY46Egd82fxA+pBXHMDxJeNb+it7u7ZBLWQTotm7d35wxoB5aBZW8H29c361tyqvYhb4ev+bpfsDZg3URxAabxmgc1WdO401bXmdcvV157mqpuA3YTQSqq3TYWCog/M6Ya5S96l6WUy3rTpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUUl1Gnw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2p367JjHvbIGM3vsXDgeydV6qwFkTGOj/cTJTWEYdw=;
	b=CUUl1GnwotSOKKvuKPXD842LYd2KDPA1ElwQh8BEOknnGMB3mLJc3LJ9jKXqs8XkmPpNW5
	LtZABXz7xgU3GSRwcsXTY7mZvwmihIYe6pLuBvOeNn3R+k5bHTpi5MzQYQoA3h7JkkmjuC
	WZ/NelnXOwg+OzHdDA6EWTKJypBTi3U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-RWxcYAGuMMqgupeQVxTxkQ-1; Tue,
 24 Mar 2026 12:38:14 -0400
X-MC-Unique: RWxcYAGuMMqgupeQVxTxkQ-1
X-Mimecast-MFC-AGG-ID: RWxcYAGuMMqgupeQVxTxkQ_1774370292
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A67918002D0;
	Tue, 24 Mar 2026 16:38:12 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 973501800107;
	Tue, 24 Mar 2026 16:38:11 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 01/12] io_uring: make io_import_fixed() global
Date: Wed, 25 Mar 2026 00:37:22 +0800
Message-ID: <20260324163753.1900977-2-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12821-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7CF2031949D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index 52554ed89b11..d65d3b4149f8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1046,9 +1046,9 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
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
@@ -1117,17 +1117,6 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
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
index cff0f8834c35..cc68cba919ab 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,9 +65,21 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
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
2.53.0


