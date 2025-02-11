Return-Path: <io-uring+bounces-6343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D6AA2FFCB
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76D6A1883440
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF3A1805E;
	Tue, 11 Feb 2025 00:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VhUJjR0Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261272AF12
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235442; cv=none; b=Mrx9nZr+AwTQzHdtJkgX00xgHIVVV8XmH3PvkIEMLgn3l4qROfpQlSmGjIFgPNiWH8Olb6YWryfJT+feJPl3Pdtozg00OR8tShuQT5+FDkMbi+msJcqmzU5c6k7yrirl/vLZaUvKhTHn2CsIFasyUFYUIb/uaGg81EQjOAVN4uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235442; c=relaxed/simple;
	bh=nukutWW51oSk/fRTc20Hqo5GtL2WEygpdwp+WbbFKb8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEvKEJ/ckCnvYV9URjn73tn7nZwCwHynkg3Ldvs5iWJY77uG5iqnXbd+gKEwIbwKWVVoyCjcCQwtK/A494VSxvtVog96KFl/LOMF+WMepXOm0knkb3F6KaSht68ekh2oRGYHyoKsefFlJvRQaa3j/jPUk/M70YZrUJKlo67g0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VhUJjR0Q; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0oXGR027408
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=jLLIHfW+mKONINFmqcybC+5D/sdcEJrut1FJWmazW78=; b=VhUJjR0QnFtF
	YIY14Anb5n6ak9y8e6NGHPIDmbv+QzbqsSG+QW2x3sHaZBLSEUQaeeAId+TaWjim
	GkjMz/L5PAl4B+4qR09stiij443PhO+8hfrep3VTuihxVnoRrux9vG9cluOVv9nv
	xd1WI0t8+QyUKLGl1vmaMB2pYuJo8aSDhdNGbz4ZkZAlSoGxtqtcD3hjxhr+5Yi2
	MyMBdbYC1iWmwVcaVGveh44xn/ZmoBaRTUJ49YzN3qHN0jvjMcLC2b6Kt9j7N+jp
	2TEi/uOQsIBluU2ZMwYoWvil1EF2VDnUyAPNyF16nZ3yosI+pE9OJMVJCCxsWPTR
	0TN+H4tkvA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qpm92u3k-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:57:01 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7AFE117E18F7E; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/6] io_uring: use node for import
Date: Mon, 10 Feb 2025 16:56:41 -0800
Message-ID: <20250211005646.222452-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250211005646.222452-1-kbusch@meta.com>
References: <20250211005646.222452-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yMGOeD5tAKwMUK8Hvk5aCrPyxzJhCkTB
X-Proofpoint-ORIG-GUID: yMGOeD5tAKwMUK8Hvk5aCrPyxzJhCkTB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_01,2025-02-10_01,2024-11-22_01

From: Jens Axboe <axboe@kernel.dk>

Replace the mapped buffer to the parent node. This is preparing for a
future for different types with specific handling considerations.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/net.c       | 3 +--
 io_uring/rsrc.c      | 6 +++---
 io_uring/rsrc.h      | 5 ++---
 io_uring/rw.c        | 2 +-
 io_uring/uring_cmd.c | 2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 10344b3a6d89c..280d576e89249 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1377,8 +1377,7 @@ static int io_send_zc_import(struct io_kiocb *req, =
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
index 7aa1e4c9f64a3..c25e0ab5c996b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -369,7 +369,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, con=
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
index 1f6a82128b475..aebbe2a4c7183 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -274,7 +274,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
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


