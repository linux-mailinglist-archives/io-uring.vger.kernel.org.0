Return-Path: <io-uring+bounces-4234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC0E9B6BCA
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D0481F222A4
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925481C3F3B;
	Wed, 30 Oct 2024 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D4Za6GJp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E476A1CF7C2
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311820; cv=none; b=NrgmHkl42LjYKUG9SQMmlMWs1DMmSUiGGBAW6hwfk/6GmjPZ6WEG6GSgfhJJjqaKR2Zbu0NPHkntiKkaALxdFxOUtT3y70SKk2c0InMZ9zuBbrs19wjPj3jOgAqcIb2GWsFP7rVGnFtm3d1/GawRBjlMBKnz/Ll5eX/FvH0Mcmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311820; c=relaxed/simple;
	bh=h61XHxtGBrHbySmSN02hKHgmG5g4G7WHzdsPAzbYfm8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LUvHdZHrEF0ux+2RT87ycfIpy8BWnJ5MtT2F5i7bwfNwp41yRa48JEIAqApyoqP9CTkECZnnJy5ea2JLvxrkWNT2vPEoQSpFPCoyrHxtOvKxs7Y9tL0jZoGfQPyq5zndbxsp5VpG5+UL8ABxeQKGv3uuGiwXH44nDAHo4tHmt+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=D4Za6GJp; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241030181016epoutp0117502e72a6ff9e75a2bcd64368b83b34~DTW3ZKhua2841628416epoutp01e
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241030181016epoutp0117502e72a6ff9e75a2bcd64368b83b34~DTW3ZKhua2841628416epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311816;
	bh=5dd6k7v+UY0om6PeVSUR7s0B1t3uJAXmfinngCFpk1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4Za6GJpWfyf4nCcwWCbr5+X9LhoM1ZMxeMRXxPlgxoDOHzSpIHkNzTQjj5EIiZqj
	 iA6z+PhqzXdChhXnnWrns07OSoxqSwwSZ7462se6a7o+bDvzyETn7kZkZxPUcGUkLU
	 UkKcN+kusNri58GnLZNpWU0jk1rYLusWqxwJN+4k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241030181015epcas5p2794e489d89aa91e8f2874c02a9fe9736~DTW2wncmu2064320643epcas5p2D;
	Wed, 30 Oct 2024 18:10:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdwCB1Dn5z4x9Pt; Wed, 30 Oct
	2024 18:10:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	08.84.09800.68672276; Thu, 31 Oct 2024 03:10:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181013epcas5p2762403c83e29c81ec34b2a7755154245~DTW1PNGss2977629776epcas5p2B;
	Wed, 30 Oct 2024 18:10:13 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241030181013epsmtrp214ca5e4a527ae130fe7e2b15a6fc637e~DTW1N4vn81079110791epsmtrp2K;
	Wed, 30 Oct 2024 18:10:13 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-b8-67227686650c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	28.69.07371.58672276; Thu, 31 Oct 2024 03:10:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181011epsmtip223d455f1a907e45b745108614a8aeb73~DTWywP6is0686406864epsmtip2i;
	Wed, 30 Oct 2024 18:10:10 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
Date: Wed, 30 Oct 2024 23:31:08 +0530
Message-Id: <20241030180112.4635-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmhm5bmVK6wZVlrBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM/53nWUvaLWqmNj8ma2BsUu/i5GTQ0LA
	RGJ63x32LkYuDiGB3YwSezbfYYNwPjFKrNozgRXC+cYocbb7BQtMy8yH0xghEnsZJY5+mgDV
	/5lR4sXXJ0AtHBxsApoSFyaXgjSICCxllFh5PRqkhllgOZPEu/VTGEESwgLREj0LtoFNZRFQ
	ldg3ewcziM0rYC6x5MxVRoht8hIzL31nB7E5BSwkPuy4yQJRIyhxcuYTMJsZqKZ562xmiPo7
	HBKH9qVA2C4S6760Ql0tLPHq+BZ2CFtK4vO7vWwQdrbEg0cPoGpqJHZs7mOFsO0lGv7cAPuF
	GeiX9bv0IVbxSfT+fsIEEpYQ4JXoaBOCqFaUuDfpKVSnuMTDGUugbA+JLW93QMOqGxg8G9pZ
	JjDKz0LywSwkH8xC2LaAkXkVo2RqQXFuemqxaYFxXmo5PGKT83M3MYKTtpb3DsZHDz7oHWJk
	4mA8xCjBwawkwmsZpJguxJuSWFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OBeSOvJN7QxNLAxMzM
	zMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+Jg5OqQamvOdNO5fo3d8ssXdG+43yReoqT3Wf
	dpg/bMzyX/PTNCTz5oqdP5K3O3OE7ji+feHZXRM/J8z3+7FOW3oLx633Fz8vPRyn8du726FL
	3mo17/7a+8VPf6Q9zxFSTU05d4a//W5zkdiuqowwtyjvViOeXefDJVTqb+78otQRrddix8yo
	MaVtC0exRmCBxn/Nw29O5ZnPuru4MzzMTy2f/5t459fPF0JWxHrO3bHs77YZT5juTLJ5HWe/
	yuQUw8vAXS1+1/IqQxqaGBX2ba5xqqq6Xzs1xTNGlbP3+fRlN1+tFc+aMnHHik7Fg4K7KxOV
	kw+JHNw8l0vIeIaoa4z/S+eK0guWWQ+XGM29llHxr2i/EktxRqKhFnNRcSIALFfmX2MEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvG5rmVK6wekVKhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZ/7vOshe0WlVM
	bP7M1sDYpd/FyMkhIWAiMfPhNMYuRi4OIYHdjBKrHnczQyTEJZqv/WCHsIUlVv57zg5R9JFR
	4sGt00AOBwebgKbEhcmlIHERgfWMEmf3TmABcZgFNjJJTNl4jhGkW1ggUuLkhBOsIDaLgKrE
	vtk7wDbwCphLLDlzlRFig7zEzEvfwbZxClhIfNhxkwXEFgKqub7wDDtEvaDEyZlPwOLMQPXN
	W2czT2AUmIUkNQtJagEj0ypGydSC4tz03GTDAsO81HK94sTc4tK8dL3k/NxNjOCY09LYwXhv
	/j+9Q4xMHIyHGCU4mJVEeC2DFNOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKa
	nZpakFoEk2Xi4JRqYEp4f3Plbunbpxs9mr0Pnu/z7uT607BkV4n3bjbZsnkN/hwX2+2aaqVy
	003TtiQLh/NK886L+RO4PLo2sVNU2d3saYnOL2tn+YUpm0/FSZ389CTSgOVH7lHWdq4wc52z
	c4+5ZFawO99c8mda3dXeL1lBDp0xui+OHXr6hvGZwqOC/jjBZuOemoprB/d9O1AkI/lc0U78
	qOnxXwuXhQWsOvCzXYvZ7RlfzepJKdbSflazNWdmuvmUMYhxBN9x4hHZ/eTKXDvd3zMN3B+d
	jLF2WHVnMU+91ul3yUUnvtftzFpy1+3+7+kPslOd+Zd/Ed3/85fIIvv2lTpnbXd9vXK59Lpt
	n7zAt6DvQcU/vNa9VmIpzkg01GIuKk4EAFI9WC8oAwAA
X-CMS-MailID: 20241030181013epcas5p2762403c83e29c81ec34b2a7755154245
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181013epcas5p2762403c83e29c81ec34b2a7755154245
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

This patch adds the capability of passing integrity metadata along with
read/write.

Introduce a new 'struct io_uring_meta_pi' that contains following:
- pi_flags: integrity check flags namely
IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- len: length of the pi/metadata buffer
- buf: address of the metadata buffer
- seed: seed value for reftag remapping
- app_tag: application defined 16b value

Application sets up a SQE128 ring, prepares io_uring_meta_pi within
the second SQE.
The patch processes this information to prepare uio_meta descriptor
and passes it down using kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 16 ++++++++
 io_uring/io_uring.c           |  4 ++
 io_uring/rw.c                 | 71 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 ++++++-
 4 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 024745283783..48dcca125db3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -105,6 +105,22 @@ struct io_uring_sqe {
 		 */
 		__u8	cmd[0];
 	};
+	/*
+	 * If the ring is initialized with IORING_SETUP_SQE128, then
+	 * this field is starting offset for 64 bytes of data. For meta io
+	 * this contains 'struct io_uring_meta_pi'
+	 */
+	__u8	big_sqe[0];
+};
+
+/* this is placed in SQE128 */
+struct io_uring_meta_pi {
+	__u16		pi_flags;
+	__u16		app_tag;
+	__u32		len;
+	__u64		addr;
+	__u64		seed;
+	__u64		rsvd[2];
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 44a772013c09..c5fd74e42c04 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3879,6 +3879,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
+	BUILD_BUG_SQE_ELEM_SIZE(64, 0, big_sqe);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
@@ -3902,6 +3903,9 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_meta_pi) >
+		     sizeof(struct io_uring_sqe));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 30448f343c7f..cbb74fcfd0d1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,6 +257,46 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	return 0;
 }
 
+static inline void io_meta_save_state(struct io_async_rw *io)
+{
+	io->meta_state.seed = io->meta.seed;
+	iov_iter_save_state(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static inline void io_meta_restore(struct io_async_rw *io)
+{
+	io->meta.seed = io->meta_state.seed;
+	iov_iter_restore(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_rw *rw, int ddir)
+{
+	const struct io_uring_meta_pi *md = (struct io_uring_meta_pi *)sqe->big_sqe;
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (READ_ONCE(md->rsvd[0]) || READ_ONCE(md->rsvd[1]))
+		return -EINVAL;
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(md->pi_flags);
+	io->meta.app_tag = READ_ONCE(md->app_tag);
+	io->meta.seed = READ_ONCE(md->seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(md->addr)),
+			  READ_ONCE(md->len), &io->meta.iter);
+	if (unlikely(ret < 0))
+		return ret;
+	rw->kiocb.ki_flags |= IOCB_HAS_METADATA;
+	io_meta_save_state(io);
+	return ret;
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
@@ -279,11 +319,19 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+
+	if (req->ctx->flags & IORING_SETUP_SQE128)
+		ret = io_prep_rw_meta(req, sqe, rw, ddir);
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +457,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -794,7 +845,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -823,6 +874,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (kiocb->ki_flags & IOCB_HAS_METADATA) {
+		struct io_async_rw *io = req->async_data;
+
+		/*
+		 * We have a union of meta fields with wpq used for buffered-io
+		 * in io_async_rw, so fail it here.
+		 */
+		if (!(req->file->f_flags & O_DIRECT))
+			return -EOPNOTSUPP;
+		kiocb->private = &io->meta;
+	}
+
 	return 0;
 }
 
@@ -897,6 +960,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1101,6 +1166,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		if (kiocb->ki_flags & IOCB_HAS_METADATA)
+			io_meta_restore(io);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3f432dc75441..2d7656bd268d 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -2,6 +2,11 @@
 
 #include <linux/pagemap.h>
 
+struct io_meta_state {
+	u32			seed;
+	struct iov_iter_state	iter_meta;
+};
+
 struct io_async_rw {
 	size_t				bytes_done;
 	struct iov_iter			iter;
@@ -9,7 +14,14 @@ struct io_async_rw {
 	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
 	int				free_iov_nr;
-	struct wait_page_queue		wpq;
+	/* wpq is for buffered io, while meta fields are used with direct io */
+	union {
+		struct wait_page_queue		wpq;
+		struct {
+			struct uio_meta			meta;
+			struct io_meta_state		meta_state;
+		};
+	};
 };
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.25.1


