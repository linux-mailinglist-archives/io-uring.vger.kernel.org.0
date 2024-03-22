Return-Path: <io-uring+bounces-1197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B5088737A
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 19:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00457B23657
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07FE762D6;
	Fri, 22 Mar 2024 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W99mHN2K"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1838C768F4
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133861; cv=none; b=sTx91SprqhX+hG3N5IZjUctzZTv8P1PRSfLaHprq+Vn+svNxmSeUWD9qJKOipacWKhk3elqJYVXPJxBYUSDV8l/GKOVectSK+4zqe5jMl5yJKQzhCk66pnGX8M7+cNz91d4Hpjqbeu3SFFEMnUtg3pVDLEd1+F213gFhlXaVA/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133861; c=relaxed/simple;
	bh=na/CenVLb5Xu/o39DMpZBv4uvSTAi9NHfTka/puvBWM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=mVOcg0hCmUQIQ9pto8g7WLWfUsae/H+xUrHxsEyJnH16opv55Lwgzy2xG22GE65bK64mO3ZGd8fJ/gOE30TwcCJvAoO3ko+fJpCPAg6RqfijDjvBNCi0U3qW3lX9gEIJkvhfWSHvs/fs7BVOslipuPmN/W/VD+34H5I+H/V7AAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W99mHN2K; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240322185736epoutp01017182bc94864ca4d6ba3d2bc6bd61c9~-Ky1MiUCt2534625346epoutp01M
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240322185736epoutp01017182bc94864ca4d6ba3d2bc6bd61c9~-Ky1MiUCt2534625346epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711133857;
	bh=WbJRm7ihfrQleNCaP9iJo5NVm6Oew/wSd0fYC2SwHjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W99mHN2KTYBwI+DwbA/5LqgfNtn6/wojD1KnYJW+p360C1hKJ6M4slNvoFQu3oYd4
	 /tVHnw36iv1tt1hegAZQEa0o4kT2VEJ7Y0xW5T+rlVhcsoqalaAYNgYDLK9Eo9uNqv
	 ECGoLfPLOk/RvR0Fx0NAYoIfMZcIuzilQxH74Zz4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240322185736epcas5p443ec97f425f93a33323d011834e90c4c~-Ky0X0-Jv2613626136epcas5p4x;
	Fri, 22 Mar 2024 18:57:36 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4V1WmG6RD3z4x9Pv; Fri, 22 Mar
	2024 18:57:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.A1.08600.E94DDF56; Sat, 23 Mar 2024 03:57:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240322185734epcas5p2cd407dac97cd157c1833c4022ea84805~-KyytCQe71964119641epcas5p2F;
	Fri, 22 Mar 2024 18:57:34 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240322185734epsmtrp143c54e9b3662640908b2ed37cb6ee018~-KyysWezb0917909179epsmtrp1p;
	Fri, 22 Mar 2024 18:57:34 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-e0-65fdd49e416a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.B3.19234.E94DDF56; Sat, 23 Mar 2024 03:57:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240322185731epsmtip1a3c5625e966ca33a68d133fe951f6461~-KywKWXNp1992619926epsmtip1e;
	Fri, 22 Mar 2024 18:57:31 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: martin.petersen@oracle.com, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Subject: [RFC PATCH 2/4] io_uring/rw: support read/write with metadata
Date: Sat, 23 Mar 2024 00:20:21 +0530
Message-Id: <20240322185023.131697-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmhu68K39TDT6d07T4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xWWz7PZ/Zgctj56y77B6Xz5Z6
	bFrVyeax+2YDm8fHp7dYPPq2rGL0+LxJLoA9KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpB
	Sk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xuQu34IzwRVz/29jb2Bscu5i5OSQEDCRmDHn
	EFsXIxeHkMBuRom5928ygiSEBD4xSrzo8odIANkfd05ghOnYfO4xVMdORonWX8uZIDo+M0o0
	H4/qYuTgYBPQlLgwuRQkLCIQIPH09zmwemaBw4wSU3euZgZJCAu4Saw/+gCsl0VAVeLW4Utg
	cV4BS4mjm69ALZOXmHnpOzuIzSlgJXH96k8WiBpBiZMzn4DZzEA1zVtnM4MskBBo5ZD40DCP
	GaLZReJk2wUmCFtY4tXxLewQtpTEy/42KDtZ4tLMc1A1JRKP9xyEsu0lWk/1M4M8wwz0zPpd
	+hC7+CR6fz9hAglLCPBKdLQJQVQrStyb9JQVwhaXeDhjCStEiYfE+2+CkKDqZZQ4cOkN2wRG
	+VlIPpiF5INZCMsWMDKvYpRMLSjOTU9NNi0wzEsth8dqcn7uJkZwCtVy2cF4Y/4/vUOMTByM
	hxglOJiVRHh3/P+TKsSbklhZlVqUH19UmpNafIjRFBjEE5mlRJPzgUk8ryTe0MTSwMTMzMzE
	0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJpl/bMW3/Nlr+C9XnVKuWnlc25Bf7Euk
	91MZQa4zEZ+CPJo3slx79HH//nnm/MHVn+X2iJ9fnrHKJshbPSvwdKOd4q56xfYzaqndTuev
	z7unMKnkfm3Vhl/5E9Ilb/YyH7EXvPWrft6KgztP/OW9fmIC8zW7OcIbvgqddTmra9Txmfvz
	o7zTZvHiTy+f1t31rG5thCTT9U697TbHz4kymylIORhEHNi02uzlXrZ337jC787zzVlSu+nL
	wbQN5T5lLl+f8PgIXxZl3lvlPvv3M93PzaIxLjypte++v5A70nCO13bNrhVlx+rsdkv+OLE/
	PObWscjOuTObLR+pvu++K2h+rUvk6e3rm2Yz8KZbH1RiKc5INNRiLipOBACfapMeKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnO68K39TDR5M4rb4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xWWz7PZ/Zgctj56y77B6Xz5Z6
	bFrVyeax+2YDm8fHp7dYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStjcpdvwZngirn/t7E3
	MDY5dzFyckgImEhsPveYrYuRi0NIYDujxL3GdywQCXGJ5ms/2CFsYYmV/56zQxR9ZJS4cWgr
	kMPBwSagKXFhcilIjYhAiMSy1gnMIDXMAicZJSZf2MkKkhAWcJNYf/QBE4jNIqAqcevwJWYQ
	m1fAUuLo5iuMEAvkJWZe+g62jFPASuL61Z9gRwgB1Ux/vpoVol5Q4uTMJ2BxZqD65q2zmScw
	CsxCkpqFJLWAkWkVo2hqQXFuem5ygaFecWJucWleul5yfu4mRnDoawXtYFy2/q/eIUYmDsZD
	jBIczEoivDv+/0kV4k1JrKxKLcqPLyrNSS0+xCjNwaIkzquc05kiJJCeWJKanZpakFoEk2Xi
	4JRqYLKe8eGHQ3ZkxYEDUr0zdrnapv0qbD/3UuffMyX9yOKbYmfTnfOYtyWmKT0wnuH99NMH
	n4O271QE134z1e2NVjxyOzd+gaXC+ce9japJp11S6td2XwoWsGix3yXocXUGp++f8q+Hdp/i
	XvzDf1LK/D/zrkubGT06wnPw6y9rpsTL72W+hYeJ/azqDO61MOV6IfxNf4PVNqa3if0ai6yd
	P241W++5gC3HnsG8YMelD6u23J3lKL15Uq4Dv7WZ+rliS7/8ajv3ErkZ04IF15f0ets8OqJa
	/TnQtn8K4/u8vOhb5mclTq4WrksS+SEUlLH1VZ2dW5UN5/Ofi7iXMi+5fsnyemLdKn2+exMl
	Cxd2KbEUZyQaajEXFScCAK4Eg9jsAgAA
X-CMS-MailID: 20240322185734epcas5p2cd407dac97cd157c1833c4022ea84805
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185734epcas5p2cd407dac97cd157c1833c4022ea84805
References: <20240322185023.131697-1-joshi.k@samsung.com>
	<CGME20240322185734epcas5p2cd407dac97cd157c1833c4022ea84805@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

This patch introduces IORING_OP_READ_META and IORING_OP_WRITE_META
opcodes which allow sending a meta buffer along with read/write.

Application can do that by using the newly added meta_buf and meta-len
fields of the SQE.

These opcodes are supported only for direct IO.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h |  6 +++
 io_uring/io_uring.c           |  2 +
 io_uring/opdef.c              | 29 ++++++++++++
 io_uring/rw.c                 | 86 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 |  8 ++++
 6 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0a22b7245982..c3a483a4fdac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -327,6 +327,7 @@ struct readahead_control;
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+#define IOCB_USE_META		(1 << 22)
 /*
  * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
  * iocb completion can be passed back to the owner for execution from a safe
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..87bd44098037 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -97,6 +97,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	meta_addr;
+			__u32	meta_len;
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -256,6 +260,8 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
+	IORING_OP_READ_META,
+	IORING_OP_WRITE_META,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 49a124daa359..7c380cac4465 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4134,7 +4134,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
+	BUILD_BUG_SQE_ELEM(48, __u64,  meta_addr);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(56, __u32,  meta_len);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9c080aadc5a6..cb31573ac4ad 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -146,6 +146,26 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READ_META] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.prep			= io_prep_rw_meta,
+		.issue			= io_rw_meta,
+	},
+	[IORING_OP_WRITE_META] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.prep			= io_prep_rw_meta,
+		.issue			= io_rw_meta,
+	},
 	[IORING_OP_RECVMSG] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -501,6 +521,15 @@ const struct io_cold_def io_cold_defs[] = {
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
+	[IORING_OP_READ_META] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "READ_META",
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITE_META] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "WRITE_META",
+	},
 	[IORING_OP_FSYNC] = {
 		.name			= "FSYNC",
 	},
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 40f6c2a59928..87a6304052f0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -27,6 +27,7 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u32				len;
+	u32				meta_len;
 };
 
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
@@ -107,6 +108,22 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct kiocb *kiocb = &rw->kiocb;
+	int ret;
+
+	ret = io_prep_rw(req, sqe);
+	if (unlikely(ret))
+		return ret;
+	kiocb->private = u64_to_user_ptr(READ_ONCE(sqe->meta_addr));
+	rw->meta_len = READ_ONCE(sqe->meta_len);
+
+	kiocb->ki_flags |= IOCB_USE_META;
+	return 0;
+}
+
 int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	int ret;
@@ -571,9 +588,18 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	}
 }
 
+static inline void io_req_map_meta(struct io_async_rw *iorw, struct io_rw_state_meta *sm)
+{
+	memcpy(&iorw->s_meta.iter_meta, &sm->iter_meta, sizeof(struct iov_iter));
+	iov_iter_save_state(&iorw->s_meta.iter_meta, &iorw->s_meta.iter_state_meta);
+}
+
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     struct io_rw_state *s, bool force)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct kiocb *kiocb = &rw->kiocb;
+
 	if (!force && !io_cold_defs[req->opcode].prep_async)
 		return 0;
 	/* opcode type doesn't need async data */
@@ -591,6 +617,11 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 		iorw = req->async_data;
 		/* we've copied and mapped the iter, ensure state is saved */
 		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
+		if (unlikely(kiocb->ki_flags & IOCB_USE_META)) {
+			struct io_rw_state_meta *sm = kiocb->private;
+
+			io_req_map_meta(iorw, sm);
+		}
 	}
 	return 0;
 }
@@ -747,7 +778,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
 
-		kiocb->private = NULL;
+		if (likely(!(kiocb->ki_flags & IOCB_USE_META)))
+			kiocb->private = NULL;
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
@@ -766,6 +798,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_rw_state __s, *s = &__s;
 	struct iovec *iovec;
 	struct kiocb *kiocb = &rw->kiocb;
+	struct io_rw_state_meta *sm = kiocb->private;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_async_rw *io;
 	ssize_t ret, ret2;
@@ -840,13 +873,16 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
+		if (kiocb->ki_flags & IOCB_USE_META)
+			kiocb->private = sm;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		if (iovec)
 			kfree(iovec);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
+		   (kiocb->ki_flags & IOCB_USE_META)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
@@ -857,6 +893,12 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&s->iter, &s->iter_state);
+	if (unlikely(kiocb->ki_flags & IOCB_USE_META)) {
+		/* don't handle partial completion for read + meta */
+		if (ret > 0)
+			goto done;
+		iov_iter_restore(&sm->iter_meta, &sm->iter_state_meta);
+	}
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
 	iovec = NULL;
@@ -1070,7 +1112,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto copy_iov;
 
-		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)) {
+		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)
+				&& !(kiocb->ki_flags & IOCB_USE_META)) {
 			struct io_async_rw *io;
 
 			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
@@ -1111,6 +1154,43 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_rw_meta(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	void __user *meta_addr = u64_to_user_ptr((u64)rw->kiocb.private);
+	struct io_rw_state_meta __sm, *sm = &__sm;
+	struct kiocb *kiocb = &rw->kiocb;
+	int ret;
+
+	if (!(req->file->f_flags & O_DIRECT))
+		return -EOPNOTSUPP;
+	/* prepare iter for meta-buffer */
+	if (!req_has_async_data(req)) {
+		ret = import_ubuf(ITER_SOURCE, meta_addr, rw->meta_len, &sm->iter_meta);
+		iov_iter_save_state(&sm->iter_meta, &sm->iter_state_meta);
+		if (unlikely(ret < 0))
+			return ret;
+	} else {
+		struct io_async_rw *io = req->async_data;
+
+		sm = &io->s_meta;
+		iov_iter_restore(&sm->iter_meta, &sm->iter_state_meta);
+	}
+	/* Store iter for meta-buf in private, will be used later*/
+	kiocb->private = sm;
+	if (req->opcode == IORING_OP_READ_META) {
+		ret = __io_read(req, issue_flags);
+		if (ret >= 0)
+			return kiocb_done(req, ret, issue_flags);
+	} else {
+		ret = io_write(req, issue_flags);
+	}
+	if (ret == -EAGAIN)
+		kiocb->private = meta_addr;
+	return ret;
+
+}
+
 void io_rw_fail(struct io_kiocb *req)
 {
 	int res;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index f9e89b4fe4da..7c12216776bc 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -8,19 +8,27 @@ struct io_rw_state {
 	struct iovec			fast_iov[UIO_FASTIOV];
 };
 
+struct io_rw_state_meta {
+	struct iov_iter			iter_meta;
+	struct iov_iter_state		iter_state_meta;
+};
+
 struct io_async_rw {
 	struct io_rw_state		s;
+	struct io_rw_state_meta		s_meta;
 	const struct iovec		*free_iovec;
 	size_t				bytes_done;
 	struct wait_page_queue		wpq;
 };
 
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
+int io_rw_meta(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-- 
2.25.1


