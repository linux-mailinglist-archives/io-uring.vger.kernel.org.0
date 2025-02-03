Return-Path: <io-uring+bounces-6221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B361EA25F23
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 445493A43CE
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 15:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D667620ADD4;
	Mon,  3 Feb 2025 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cfGD/XrJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E53209F5E
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597540; cv=none; b=h/EfT/AMGt+DewaPd27R1jKNmXB1fKGUkBPs1mxPqXFMixvYZ9Q24zO+RNv2cPYqYc14iLizSVKIqZvhYNO2S78keZHX+llr4dRD8EMXzQMRBqgR5DQaiXkfrdU3V/XU0T82/HFGhGhX649/ensPrlysSkZINOiBvyxy6IHGXqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597540; c=relaxed/simple;
	bh=ZwK2pTZPzRlNSlj9Qz7gSjaKpkPAhiWv9hTfPleYMTY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phQkP0+YnYbf8stg+fUJ927koQzBYNUTLrqqqUb485+mrepXA5v/lRpS1tTQYxQ1sdwGGCsVFG8bOd9qNdCNa8SwPg9GyaA+VJt++IlEnVqne9uY2gqCGd6qpufNiCinKX3pW2VJ52wOKx1nseroVqF6cmPBQNGsQGD1EDNssD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cfGD/XrJ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513FjCw3004352
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 07:45:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=tqd4ldYb1MFOCFON2/4vIH7lbh7LQK7BJO0RRotffbE=; b=cfGD/XrJfXpL
	AHT3SebFNrZn+IypkAMv+VUvrbO3yR1gKbkuw55eG6iU3ARvG147sUc+Uv/1BBjP
	ubi/o4W9gWKbdgtva4t8KFZRrHtfNf7DZaSUly3lMowVX1c8WjxRZ2hcHOMos1LP
	QHSQZXDd3KqzLH4q6dEZwETq1QvG+zwUycJVvzmPCIZsWKpIAoCCH21FGG3fqAOK
	4Zs7NJrGwMjEgfJAvfl5wALQ+M8DQL5bh9BwD4tVsJqwaDdhG6Vevk/fbUZpNK4h
	lloJNXSHIa6dI3erxJPEtbTNMwQLo6W77xxiXBakYQ7R0p7nSnMxJ25hQKXxmuWS
	vi1G/SjkAg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k0q6r041-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 07:45:37 -0800 (PST)
Received: from twshared24170.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 15:45:30 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B8EA7179A9849; Mon,  3 Feb 2025 07:45:21 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/6] io_uring: use node for import
Date: Mon, 3 Feb 2025 07:45:13 -0800
Message-ID: <20250203154517.937623-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>
References: <20250203154517.937623-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: G1DmDRKtjgu8I4Y8NUJgehkQgKGGhQ6l
X-Proofpoint-GUID: G1DmDRKtjgu8I4Y8NUJgehkQgKGGhQ6l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_06,2025-01-31_02,2024-11-22_01

From: Jens Axboe <axboe@kernel.dk>

Replace the mapped buffer to the parent node. This is preparing for a
future for different types with specific handling considerations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/net.c       | 3 +--
 io_uring/rsrc.c      | 6 +++---
 io_uring/rsrc.h      | 5 ++---
 io_uring/rw.c        | 2 +-
 io_uring/uring_cmd.c | 2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 85f55fbc25c94..4e9d0f04b902d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1359,8 +1359,7 @@ static int io_send_zc_import(struct io_kiocb *req, =
unsigned int issue_flags)
 			return ret;
=20
 		ret =3D io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
-					node->buf, (u64)(uintptr_t)sr->buf,
-					sr->len);
+					node, (u64)(uintptr_t)sr->buf, sr->len);
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter =3D io_sg_from_iter;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index af39b69eb4fde..4d0e1c06c8bc6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -860,10 +860,10 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
 	return ret;
 }
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+int io_import_fixed(int ddir, struct iov_iter *iter, struct io_rsrc_node=
 *node,
+		    u64 buf_addr, size_t len)
 {
+	struct io_mapped_ubuf *imu =3D node->buf;
 	u64 buf_end;
 	size_t offset;
=20
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 190f7ee45de93..abd0d5d42c3e1 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,9 +50,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct =
io_rsrc_node *node);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *dat=
a);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len);
+int io_import_fixed(int ddir, struct iov_iter *iter, struct io_rsrc_node=
 *node,
+		    u64 buf_addr, size_t len);
=20
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)=
;
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index a9a2733be8420..d6332d019dd56 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -393,7 +393,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe
 	io_req_assign_buf_node(req, node);
=20
 	io =3D req->async_data;
-	ret =3D io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
+	ret =3D io_import_fixed(ddir, &io->iter, node, rw->addr, rw->len);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index fc94c465a9850..b7b9baf30d728 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -281,7 +281,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
 len, int rw,
=20
 	/* Must have had rsrc_node assigned at prep time */
 	if (node)
-		return io_import_fixed(rw, iter, node->buf, ubuf, len);
+		return io_import_fixed(rw, iter, node, ubuf, len);
=20
 	return -EFAULT;
 }
--=20
2.43.5


