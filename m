Return-Path: <io-uring+bounces-3729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B42399A09F6
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D82B61C23C89
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BBF207A15;
	Wed, 16 Oct 2024 12:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E53Udn/g"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966AB208D7E
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082220; cv=none; b=Z9KYtZs1ZuH90Q9Q3KclB/Dh9JXc0U7UE1iFuXPe1ha1reJ6je9HiAjR7zpjxfrS4x1kEFDFkMizus4lbgZAxyEyblNezgSziEDMiB1gRohGbvCjIikR4OlH/w1+XO6IJK8ZRGMr0Gjzu0o1ghGbVq9ZrZH5deIgZh3xBfBFpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082220; c=relaxed/simple;
	bh=AFxgKf2CMX7UNneAa1dPUe538R2nji7Q/4SWY/M9j3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ap10cdWmhnqVBlBIjHB+ZtqHVp9koVCj1DVjEw5PfY7gb8neonAZ7aS/mBbSFZFJjMWZTTglraG8c+kAkL7lNsNbqulfxX374XFA9fdsLiFZ9M17HhlHrdLUnNEE0+UDI+7j5JtOxIrLJP8js8Jqj3uAks455LR1lv27s7WU17U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E53Udn/g; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241016123656epoutp03e59ce274ae17b6f48585b19fcb851ecf~_7x13nBGq1102511025epoutp03F
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241016123656epoutp03e59ce274ae17b6f48585b19fcb851ecf~_7x13nBGq1102511025epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082216;
	bh=O39Go3fokUwZDWd7rBK8ZXZOW5p4wPCNqPYj2KzQgs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E53Udn/gnHiNCBebXklaOd7wKsg7xwfExftYL4UfvTYuZyy8wm+x1ldF9R5zj1jJX
	 DZsrGR63wn9hP39RNsl590jTsz27FoiUX4NrNUHIODyjBezs4TloNzSq5hu85dg2Ht
	 4EdsNrgRUdlsVSld/MFqOUSHhveyvStdAM0KkPhI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241016123656epcas5p175030dfc059206de463d20baff9a97c1~_7x1X84gm0838008380epcas5p1v;
	Wed, 16 Oct 2024 12:36:56 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XT9T23fNTz4x9Pt; Wed, 16 Oct
	2024 12:36:54 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DA.37.08574.663BF076; Wed, 16 Oct 2024 21:36:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4~_6_MxwORC2712227122epcas5p4e;
	Wed, 16 Oct 2024 11:37:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241016113747epsmtrp1f416b0972e498ffb7e22bae5484e113b~_6_Mvz4fa0254402544epsmtrp1t;
	Wed, 16 Oct 2024 11:37:47 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-26-670fb366331e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.9A.07371.B85AF076; Wed, 16 Oct 2024 20:37:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113745epsmtip1125d8d26ee15ee70412c75ac746a6bf6~_6_KnXcxQ2871328713epsmtip15;
	Wed, 16 Oct 2024 11:37:45 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 07/11] io_uring/rw: add support to send meta along with
 read/write
Date: Wed, 16 Oct 2024 16:59:08 +0530
Message-Id: <20241016112912.63542-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJsWRmVeSWpSXmKPExsWy7bCmlm7aZv50g7vLJSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDMq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6HwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWh
	gYGRKVBhQnZG294pbAXbbCua1s5hamCcYNTFyMkhIWAiMXV7H3MXIxeHkMBuRomF7T/ZIJxP
	jBJnzsxjhHC+MUoc7L7GCNNypmsmC4gtJLCXUWLGfmGIos+MEhPOTGYHSbAJqEsced4K1iAi
	MIlR4vnlUJAiZoH3jBLv9y9nBUkIC4RL/NzyjQ3EZhFQleg9/BoszitgKTH/6Hw2iG3yEjMv
	fQcbyilgJXHq3EF2iBpBiZMzn4BdwQxU07x1NtgTEgJ7OCTWrD4L1ewiceTMLyYIW1ji1fEt
	7BC2lMTL/jYoO13ix+WnUDUFEs3H9kG9aS/ReqofaCgH0AJNifW79CHCshJTT61jgtjLJ9H7
	+wlUK6/EjnkwtpJE+8o5ULaExN5zDVC2h8Tir3tZISHXyyixZrLYBEaFWUjemYXknVkImxcw
	Mq9ilEwtKM5NT002LTDMSy2Hx3Jyfu4mRnCS1nLZwXhj/j+9Q4xMHIyHGCU4mJVEeCd18aYL
	8aYkVlalFuXHF5XmpBYfYjQFhvdEZinR5HxgnsgriTc0sTQwMTMzM7E0NjNUEud93To3RUgg
	PbEkNTs1tSC1CKaPiYNTqoFp4dSc148OruJ6K1l95tfpK0cz3au3TX19PGyL5I7JL/bO8CpV
	Xzi5aUbeG0Zd66CEUrGash8T/d5w2CRcfGhzTV+l4Em94xL3+W8bls9MeJv+4rCQlNBzhRUz
	1/afLpovJHn+Ufq6QCmGC5PP9PnxTDf6rBYWVtXrd/aBoLTlsdnWa6vnxjwqOnvG60Izo/hx
	jVLrrqC382avnbNgvxNTtov0bdG3592r3zM2Tcq4ujBWenHxeoXPSfEShSo89vE7ZsarpMr7
	HfrDnGz52nSd57wbaVErTxc5t3MX1a+P159XO1Nl0vHp0y3NjKq21fPG5aWWZXWqaWzde2Fn
	HEPSd5HW+yc/p2W6JJ+davtQiaU4I9FQi7moOBEAO0BONFsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJTrd7KX+6wa+txhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYHP3/ls1i0qFrjBbbzyxltth7S9ti/rKn7Bbd
	13ewWSw//o/J4vysOewO/B47Z91l97h8ttRj06pONo/NS+o9dt9sYPP4+PQWi0ffllWMHptP
	V3t83iQXwBnFZZOSmpNZllqkb5fAldG2dwpbwTbbiqa1c5gaGCcYdTFyckgImEic6ZrJ0sXI
	xSEksJtRYtaxZ4wQCQmJUy+XQdnCEiv/PWeHKPrIKPFo1il2kASbgLrEkeetjCAJEYFZjBKH
	Z81nAnGYBb4zSkxbfo0FpEpYIFRi5ZMtYDaLgKpE7+HXrCA2r4ClxPyj89kgVshLzLz0HWwq
	p4CVxKlzB8FsIaCaf5M/MELUC0qcnPkEbA4zUH3z1tnMExiB1iKkZiFJLWBkWsUomVpQnJue
	m2xYYJiXWq5XnJhbXJqXrpecn7uJERxLWho7GO/N/6d3iJGJg/EQowQHs5II76Qu3nQh3pTE
	yqrUovz4otKc1OJDjNIcLErivIYzZqcICaQnlqRmp6YWpBbBZJk4OKUamK53h9/+uUwzd4Le
	tZnrdiatvHb5/uY79z5Lm3Pf8/z6nWUj+6a3mQfSfS7ftLjDrJU1kz895eL6T9kSHNIm3p8z
	C172SLF2vy9xONvtVNlQ2nHNbhlfIuN2k6L9h3N+s8foXrN0s4uofV2sYpqnF7XI9eF5gyUx
	YU/Tt4q+iPeb7hWe3pFQYZj5pyeDLfPd01UMLKuM/nGx2l0/2v+1N2HHbP16yRdhqw08zzvY
	f1x/Pu7Wn/Anz6rOnTVjOeHR0x1VaOeycLd/04fVuQGJb13uXrYpWutl1GJbZePd1WXy6XD9
	D6H+fRcy1G5X1pt+syts8bh4snKPbOIhyaOVhcW7TL69/7KRJ+aGeKyeEktxRqKhFnNRcSIA
	PssA2RQDAAA=
X-CMS-MailID: 20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com>

This patch adds the capability of sending meta along with read/write.
This meta is represented by a newly introduced 'struct io_uring_meta'
which specifies information such as meta type,flags,buffer,length,seed
and apptag.
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
 include/uapi/linux/io_uring.h | 26 ++++++++++++
 io_uring/io_uring.c           |  6 +++
 io_uring/rw.c                 | 75 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 | 15 ++++++-
 4 files changed, 118 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 86cb385fe0b5..1cd165720fcc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -105,6 +105,32 @@ struct io_uring_sqe {
 		 */
 		__u8	cmd[0];
 	};
+	/*
+	 * If the ring is initialized with IORING_SETUP_SQE128, then
+	 * this field is starting offset for 64 bytes of data. For meta io
+	 * this contains 'struct io_uring_meta'
+	 */
+	__u8	big_sqe_cmd[0];
+};
+
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
+	__u32		seed;
+	__u16		app_tag;
+	__u8		pad[42];
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d7ad4ea5f40b..e5551e2e7bde 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3857,6 +3857,12 @@ static int __init io_uring_init(void)
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
index 80ae3c2ebb70..b727e5ef19fc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,6 +257,49 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
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
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(md->meta_flags);
+	io->meta.app_tag = READ_ONCE(md->app_tag);
+	io->meta.seed = READ_ONCE(md->seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(md->meta_addr)),
+			  READ_ONCE(md->meta_len), &io->meta.iter);
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
@@ -279,11 +322,18 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -410,7 +460,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (unlikely(rw->kiocb.ki_flags & IOCB_HAS_METADATA))
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -777,8 +830,12 @@ static inline int io_iter_do_read(struct io_rw *rw, struct iov_iter *iter)
 
 static bool need_complete_io(struct io_kiocb *req)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	/* Exclude meta IO as we don't support partial completion for that */
 	return req->flags & REQ_F_ISREG ||
-		S_ISBLK(file_inode(req->file)->i_mode);
+		S_ISBLK(file_inode(req->file)->i_mode) ||
+		!(rw->kiocb.ki_flags & IOCB_HAS_METADATA);
 }
 
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
@@ -795,7 +852,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -824,6 +881,14 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA)) {
+		struct io_async_rw *io = req->async_data;
+
+		if (!(req->file->f_flags & O_DIRECT))
+			return -EOPNOTSUPP;
+		kiocb->private = &io->meta;
+	}
+
 	return 0;
 }
 
@@ -898,6 +963,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA))
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1102,6 +1169,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA))
+			io_meta_restore(io);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3f432dc75441..af9e338b2bd8 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -1,6 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/pagemap.h>
+#include <linux/bio-integrity.h>
+
+struct io_meta_state {
+	u32			seed;
+	struct iov_iter_state	iter_meta;
+};
 
 struct io_async_rw {
 	size_t				bytes_done;
@@ -9,7 +15,14 @@ struct io_async_rw {
 	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
 	int				free_iov_nr;
-	struct wait_page_queue		wpq;
+	/* wpq is for buffered io, while meta fields are used with direct io*/
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


