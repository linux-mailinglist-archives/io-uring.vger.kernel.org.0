Return-Path: <io-uring+bounces-2910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 793FD95CAD6
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D362B1F23D79
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE917187FE0;
	Fri, 23 Aug 2024 10:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QahR06O/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F4F18787D
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410111; cv=none; b=HBAq33zQGCLuA208RR+aYLUsW8KX93bhHWoI5IQRguRDQf1iU5naSVDl3ecbCKoDcYoQ3aBV28xCHhcyyvdxIWuBGAQfa8Laur+Xcj6Bqxksl/xiTYFbJIgYMr7BDLKTejktKEsORNJeNLl5sSBjD7Z5jojB0vbJ5hXEefZrniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410111; c=relaxed/simple;
	bh=Hymx3xj0OF6Ct6HDNu4MIPToW/smUveCIpQzAHntiLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nAuFYWSlF/j9jcg8PEOK/8RldlRjWZprhnq2eC9vSmBMTfSF7SElbJfpqhfN50X47fK3t86i1yo/t5Z/dMFtEIQ5eoJ46oteKPFtH5f44l2sZifO//ewiC3AdZYnFeebtbGzBdHlWIQmTmQxVST5jA6LTxG7zlhm148XXboLAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QahR06O/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240823104828epoutp025b7a9891b4973bf9b9338cb84c125835~uVdtnwBej0951809518epoutp02b
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240823104828epoutp025b7a9891b4973bf9b9338cb84c125835~uVdtnwBej0951809518epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410108;
	bh=/S/IL8F0kHSzv8YcpPPzosRpcJVevp1vPtYpcSap8Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QahR06O/N7ZGRJ3TASy6z6f+7uNZD+Z2hEcArlx29qLzxc6QdU53dMiloCA9LeXR6
	 t8Nv8izM5EOeA/bG0HH7TqtoqdewNoJWqR6moX0P1Aekw6V9Bzj89ButRZDHDPFxYm
	 jmXqkaAaAy3rh5byKlhEPHZCnUPuIJu7/oIOW0FU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240823104827epcas5p20f7de225a7e03763b30067136044adff~uVdtX2nbW0721607216epcas5p2w;
	Fri, 23 Aug 2024 10:48:27 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Wqxcp21T8z4x9Px; Fri, 23 Aug
	2024 10:48:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EA.8A.19863.AF868C66; Fri, 23 Aug 2024 19:48:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104627epcas5p2abcd2283f6fb3301e1a8e828e3c270ae~uVb9DF6XS1853818538epcas5p2I;
	Fri, 23 Aug 2024 10:46:27 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240823104627epsmtrp158812ea9fe28ab7f6179f5339307bbdf~uVb9CV9RK0257302573epsmtrp1G;
	Fri, 23 Aug 2024 10:46:27 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-15-66c868fa3dc9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	34.0B.08456.38868C66; Fri, 23 Aug 2024 19:46:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104625epsmtip29a9701ab44fd472934b7b30010847784~uVb69w52b1442714427epsmtip2c;
	Fri, 23 Aug 2024 10:46:24 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 06/10] io_uring/rw: add support to send meta along with
 read/write
Date: Fri, 23 Aug 2024 16:08:06 +0530
Message-Id: <20240823103811.2421-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmuu6vjBNpBseb2CyaJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOqGyb
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCjlRTKEnNK
	gUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGRf3
	fWUt2O5aMX3/KpYGxh0WXYycHBICJhIf3nWydDFycQgJ7GGUmDbrNSOE84lRYtGid2wQzjdG
	iWNnnrDAtNxZNpkZIrGXUeLxkQVMEM5nRonVX6ayg1SxCahLHHneyghiiwhUSjzf9QNsCbPA
	TUaJQ3ufMYMkhAXCJZ5/OMsKYrMIqEps7ZvMBGLzClhIfJt2jRVinbzEzEvfwYZyClhKNM1u
	YIGoEZQ4ORPiJGagmuats8FOkhBYyyFx4vR7RohmF4l7DfuZIWxhiVfHt7BD2FISL/vboOx0
	iR+XnzJB2AUSzcf2QfXaS7Se6gfq5QBaoCmxfpc+RFhWYuqpdUwQe/kken8/gWrlldgxD8ZW
	kmhfOQfKlpDYe66BCWSMhICHxJHPLpDA6mGUmDTvE/MERoVZSN6ZheSdWQibFzAyr2KUSi0o
	zk1PTTYtMNTNSy2Hx3Nyfu4mRnBS1grYwbh6w1+9Q4xMHIyHGCU4mJVEeJPuHU0T4k1JrKxK
	LcqPLyrNSS0+xGgKDPCJzFKiyfnAvJBXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZq
	akFqEUwfEwenVAPT5JRfBu0xbZ9rtVqb4yo+vpfJEOX+87TzhXRjGof336oF11i36WdV7upg
	WPis2OY2k2rDeiG2HWWaYY6zXv2Q9Jmw/lmnfWhHkPwt05LPvWFbt3rF9zMETb/dmNVdNrdT
	UGAmZyzvvNnmRvu7o1V2rlP68PTP17iK7LtbJhlG6ezYrduyx2Vevs6GVT9PBEvkNuotDVh+
	uvzQ3i+NRovcs+KUm86cLTiReKfg7aNC/lMXp3R/lCq/wzDxmyHTyYT22S3Ppx+oE9I/pcFW
	uP1qbljowh3Kr+0OBUi/e5LyRIPh9tl3O5mvRWzzPnlZRE7FpGzSSl7uGe0v770vFVzz/nGn
	lbZP/vEj28vzDB4qsRRnJBpqMRcVJwIA3A10MFMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvG5zxok0gxVb2S2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6Mi/u+shZsd62Yvn8VSwPjDosuRk4OCQETiTvLJjN3MXJxCAnsZpRovnSK
	FSIhIXHq5TJGCFtYYuW/5+wQRR8ZJXbOuAWWYBNQlzjyvJURJCEi0MgosaX5CwtIglngPqPE
	gu4QEFtYIFTi6vRONhCbRUBVYmvfZCYQm1fAQuLbtGtQ2+QlZl76zg5icwpYSjTNbgCbIwRU
	s2z5GUaIekGJkzOfQM2Xl2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YW
	l+al6yXn525iBEeNltYOxj2rPugdYmTiYDzEKMHBrCTCm3TvaJoQb0piZVVqUX58UWlOavEh
	RmkOFiVx3m+ve1OEBNITS1KzU1MLUotgskwcnFINTLlbb01fftj0Q6T3G+UDVTvm+NbIKSVM
	mm6VsrPf+ee/6fzPOFYZ/XFJ+9r1Qul/pPqMv2ttUgqmu319d0/qX48Fl82fr1smGclPW3Eh
	OPHbUjM5xpXsMpJJUjL/pv69Z1X63FGqwDNawfRUDNf2Z7UmV4+tuGzze/LC6wXL9h4y+6ml
	tv3EhUb71+bzl5kf9uosk74ct0HVmKdedN785P2fOJV6T/vJl3hfcF7ydCLrHaG5u3U3pemm
	GX3cVlJdV9s/Yf+EtvzCiScNX4WIfl+79lmN8EzrxvYrB3I/Hk2tXHC5aK7tipPz/2zcYsHq
	dMg3slvq3tTjO57+v8k37f+NldtS7auXO9zqPrIhWrRHiaU4I9FQi7moOBEAohtJBQkDAAA=
X-CMS-MailID: 20240823104627epcas5p2abcd2283f6fb3301e1a8e828e3c270ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104627epcas5p2abcd2283f6fb3301e1a8e828e3c270ae
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104627epcas5p2abcd2283f6fb3301e1a8e828e3c270ae@epcas5p2.samsung.com>

This patch adds the capability of sending meta along with read/write.
This meta is represented by a newly introduced 'struct io_uring_meta'
which specifies information such as meta type/flags/buffer/length and
apptag.
Application sets up a SQE128 ring, prepares io_uring_meta within the
second SQE.
The patch processes the user-passed information to prepare uio_meta
descriptor and passes it down using kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h | 32 ++++++++++++++++
 io_uring/io_uring.c           |  6 +++
 io_uring/rw.c                 | 70 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 | 10 ++++-
 5 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index fb0426f349fc..aec78bf3040c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -330,6 +330,7 @@ struct readahead_control;
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+#define IOCB_HAS_META		(1 << 22)
 /*
  * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
  * iocb completion can be passed back to the owner for execution from a safe
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 042eab793e26..09e6cc022669 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -105,8 +105,40 @@ struct io_uring_sqe {
 		 */
 		__u8	cmd[0];
 	};
+	/*
+	 * If the ring is initialized with IORING_SETUP_SQE128, then
+	 * this field is starting offset for 64 bytes of data. For meta io
+	 * this contains 'struct io_uring_meta'
+	 */
+	__u8	big_sqe_cmd[0];
 };
 
+enum io_uring_sqe_meta_type_bits {
+	META_TYPE_INTEGRITY_BIT,
+	/* not a real meta type; just to make sure that we don't overflow */
+	META_TYPE_LAST_BIT,
+};
+
+/* meta type flags */
+#define META_TYPE_INTEGRITY	(1U << META_TYPE_INTEGRITY_BIT)
+
+/* this goes to SQE128 */
+struct io_uring_meta {
+	__u16		meta_type;
+	__u16		meta_flags;
+	__u32		meta_len;
+	__u64		meta_addr;
+	__u16		app_tag;
+	__u8		pad[46];
+};
+
+/*
+ * flags for integrity meta
+ */
+#define INTEGRITY_CHK_GUARD	(1U << 0) /* enforce guard check */
+#define INTEGRITY_CHK_APPTAG	(1U << 1) /* enforce app tag check */
+#define INTEGRITY_CHK_REFTAG	(1U << 2) /* enforce ref tag check */
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a53f2f25a80b..743201d37611 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3814,6 +3814,12 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_meta) >
+		     sizeof(struct io_uring_sqe));
+
+	BUILD_BUG_ON(META_TYPE_LAST_BIT >
+		     8 * sizeof_field(struct io_uring_meta, meta_type));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..fadc17813f76 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -23,6 +23,8 @@
 #include "poll.h"
 #include "rw.h"
 
+#define	INTEGRITY_VALID_FLAGS (INTEGRITY_CHK_GUARD | INTEGRITY_CHK_APPTAG | \
+			       INTEGRITY_CHK_REFTAG)
 struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
@@ -247,6 +249,42 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	return 0;
 }
 
+static int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_rw *rw, int ddir)
+{
+	const struct io_uring_meta *md = (struct io_uring_meta *)sqe->big_sqe_cmd;
+	u16 meta_type = READ_ONCE(md->meta_type);
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (!meta_type)
+		return 0;
+	if (!(meta_type & META_TYPE_INTEGRITY))
+		return -EINVAL;
+
+	/* should fit into two bytes */
+	BUILD_BUG_ON(INTEGRITY_VALID_FLAGS >= (1 << 16));
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(md->meta_flags);
+	if (io->meta.flags && (io->meta.flags & ~INTEGRITY_VALID_FLAGS))
+		return -EINVAL;
+
+	io->meta.app_tag = READ_ONCE(md->app_tag);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(md->meta_addr)),
+			  READ_ONCE(md->meta_len), &io->meta.iter);
+	if (unlikely(ret < 0))
+		return ret;
+	rw->kiocb.ki_flags |= IOCB_HAS_META;
+	iov_iter_save_state(&io->meta.iter, &io->iter_meta_state);
+	return ret;
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
@@ -269,11 +307,18 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 	rw->kiocb.dio_complete = NULL;
+	rw->kiocb.ki_flags = 0;
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-	return io_prep_rw_setup(req, ddir, do_import);
+	ret = io_prep_rw_setup(req, ddir, do_import);
+
+	if (unlikely(ret))
+		return ret;
+	if (unlikely(req->ctx->flags & IORING_SETUP_SQE128))
+		ret = io_prep_rw_meta(req, sqe, rw, ddir);
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -400,7 +445,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (unlikely(rw->kiocb.ki_flags & IOCB_HAS_META))
+		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -768,8 +816,12 @@ static inline int io_iter_do_read(struct io_rw *rw, struct iov_iter *iter)
 
 static bool need_complete_io(struct io_kiocb *req)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	/* Exclude meta IO as we don't support partial completion for that */
 	return req->flags & REQ_F_ISREG ||
-		S_ISBLK(file_inode(req->file)->i_mode);
+		S_ISBLK(file_inode(req->file)->i_mode) ||
+		!(rw->kiocb.ki_flags & IOCB_HAS_META);
 }
 
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
@@ -786,7 +838,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -815,6 +867,14 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (unlikely(kiocb->ki_flags & IOCB_HAS_META)) {
+		struct io_async_rw *io = req->async_data;
+
+		if (!(req->file->f_flags & O_DIRECT))
+			return -EOPNOTSUPP;
+		kiocb->private = &io->meta;
+	}
+
 	return 0;
 }
 
@@ -881,6 +941,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (unlikely(kiocb->ki_flags & IOCB_HAS_META))
+		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 
 	do {
 		/*
@@ -1091,6 +1153,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		if (unlikely(kiocb->ki_flags & IOCB_HAS_META))
+			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3f432dc75441..ce7a865fac95 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/pagemap.h>
+#include <linux/bio-integrity.h>
 
 struct io_async_rw {
 	size_t				bytes_done;
@@ -9,7 +10,14 @@ struct io_async_rw {
 	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
 	int				free_iov_nr;
-	struct wait_page_queue		wpq;
+	/* wpq is for buffered io, while meta fields are used with direct io*/
+	union {
+		struct wait_page_queue		wpq;
+		struct {
+			struct uio_meta			meta;
+			struct iov_iter_state		iter_meta_state;
+		};
+	};
 };
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.25.1


