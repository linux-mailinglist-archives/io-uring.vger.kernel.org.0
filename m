Return-Path: <io-uring+bounces-12822-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBPoLVLAwmnalQQAu9opvQ
	(envelope-from <io-uring+bounces-12822-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:48:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 507DC319554
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:48:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 727AD308452B
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C74C3F20F5;
	Tue, 24 Mar 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9V+Lz2f"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89663F8E01
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370303; cv=none; b=YdKmb9v8AQb4OS0XHUigNYV7rAM4VL0+BJiW7+h/f9xRQxtJLPQTJkyEbgje+PZ5yET+jVvL+NK7Mvx4tXreMw2kG+ysJKpEKfJlcr/hZzcMH4UKo1jlHo1a9OoLc7Epm+ybVI6kCjhmlHgtMfaLF1obgsQQ+L5XL7esDLwfuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370303; c=relaxed/simple;
	bh=12PbHE1tAUlHTB8D8yEF0NmbNdWrPPHSg2u7P/0K+wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6Qgdp5ox92C3aMj3I+eJfdUUCp/K5eqnidiqiRY/k2kQzW1dxUgC2+aUV/rmtSOQJDO4dA0EM+qjuh3paFsYnJt2PhVVFh7Xs6f0Qg0ZD0s3tqtkhF4zNgfZR24RncG0BuCYsdBaDAK/UYtiFJPp+C12N0UUZD2cLecvM5cM2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9V+Lz2f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=48gM7sFc7DhtonuB8fpcBwKyWL8tEU8LgGAsIqrqlUs=;
	b=a9V+Lz2fOGqEWQYG/fBdwbuT2nkIv4ttONoTzLszz42ng2Q1jmiDmh9hMNeJ6Ba5bU5not
	M4O0DuMeE0cNfC4saPS/ds7kMARG8f++0wpw9UlU4XgemyeGY+nPw9sbfW5EVikDks/BDP
	68Tz6UpGidfzUQrhNc/ZmAnSGfsL+58=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-_GUpUxY7OqylLPWLs_XKYA-1; Tue,
 24 Mar 2026 12:38:18 -0400
X-MC-Unique: _GUpUxY7OqylLPWLs_XKYA-1
X-Mimecast-MFC-AGG-ID: _GUpUxY7OqylLPWLs_XKYA_1774370296
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26E91180034E;
	Tue, 24 Mar 2026 16:38:16 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21044180035F;
	Tue, 24 Mar 2026 16:38:14 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 02/12] io_uring: refactor io_prep_reg_iovec() for BPF kfunc use
Date: Wed, 25 Mar 2026 00:37:23 +0800
Message-ID: <20260324163753.1900977-3-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12822-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
X-Rspamd-Queue-Id: 507DC319554
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index d65d3b4149f8..0b3e4cb5e879 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1517,8 +1517,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 }
 
-int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
-		      const struct iovec __user *uvec, size_t uvec_segs)
+int __io_prep_reg_iovec(struct iou_vec *iv, const struct iovec __user *uvec,
+			size_t uvec_segs, bool compat, bool *need_clean)
 {
 	struct iovec *iov;
 	int iovec_off, ret;
@@ -1528,17 +1528,16 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
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
index cc68cba919ab..c2c729a9f568 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include "io_uring.h"
 
 #define IO_VEC_CACHE_SOFT_CAP		256
 
@@ -83,8 +84,24 @@ static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
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
2.53.0


