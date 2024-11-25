Return-Path: <io-uring+bounces-5033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A99DC9D7C7D
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 697912823FA
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FA7188006;
	Mon, 25 Nov 2024 08:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nO82tyHu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63E154BE3
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522103; cv=none; b=eUIgGaKfa+qpNoEnsANn8Q7i6Ck9HcTfEDR77Yo9pXwN011e/oB5AyMmYGZG8+MLbvxypQQUU8yZUSQ5yIQG8lE1qOCrWpKyeAIrVUIPV9zhdf9WTmb/geIT8iBSea9EVvPMThyzCgwVxBfW/3nhFMtMUnuYSURlv4IWHsYFUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522103; c=relaxed/simple;
	bh=c+P5GWK64P6uvOS5S4lo6E9Ft1ukPyp92Zww4rzKibo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=gEcbMebX7LB5KtrlJWLKr2HqfQZmfkIQej07s336uxIva1cXc8SZ6aG2WsN+aLhbie9ldryir0LRR9YPDEnSRmWkS9T55SLYoI6vmVKGkPNss4av5fZh7/7UqOmlPer8xKXaHXl7lcIrnnNqIMeXUNWMzBNHxiYZvWjYyX+8wwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nO82tyHu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241125080819epoutp033ad4dd5ed90ee659f6d5c70aa0711728~LJ6uS4SnR0835008350epoutp03l
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241125080819epoutp033ad4dd5ed90ee659f6d5c70aa0711728~LJ6uS4SnR0835008350epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522099;
	bh=oSIHEQgo5+twq6ZY9Vqvg0w2/SzcvR7jssNhix7seL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nO82tyHuXl74MF42HwMoAPb+GpCVyeAiYMAHYneLGeEWYt6P66UeW24tHj86Zx0Sw
	 Dj1Z71BpV2kLascBZ6+h49KJHuZLXjRMtzl3lWmKaoLdvhxUvrgXeEyTbCI+HxLoTc
	 eQUaIshYWIaTx2lTirEaBEtN2vob4DpQ4xu9rnj8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241125080818epcas5p36e1c9876f4c6006f02558a9f9764b88c~LJ6tXNY2N0905409054epcas5p3J;
	Mon, 25 Nov 2024 08:08:18 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xxdcc4v6Mz4x9QM; Mon, 25 Nov
	2024 08:08:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F3.F1.19933.07034476; Mon, 25 Nov 2024 17:08:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241125071502epcas5p46c373574219a958b565f20732797893f~LJMM0X9GY1896918969epcas5p4y;
	Mon, 25 Nov 2024 07:15:02 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241125071502epsmtrp138f304d34c6c9f5c13a6d81ea8f61796~LJMMzIGWO0343503435epsmtrp1K;
	Mon, 25 Nov 2024 07:15:02 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-09-67443070df7e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.45.19220.6F324476; Mon, 25 Nov 2024 16:15:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071459epsmtip17c73e13dbfc7db4011a0cc888ee952d2~LJMKVj5TP0361403614epsmtip1f;
	Mon, 25 Nov 2024 07:14:59 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v10 06/10] io_uring: introduce attributes for read/write and
 PI support
Date: Mon, 25 Nov 2024 12:36:29 +0530
Message-Id: <20241125070633.8042-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmlm6BgUu6wfRGVYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuqGybjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCflBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2
	SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGVf2TGEtmO1QcfvLJ8YGxmaTLkZODgkB
	E4n5exYwdjFycQgJ7GaUeLCslQ3C+cQose7DNmaQKiGBb4wSXTfUYTrWv57CAlG0l1Fi76ZH
	7BDOZ0aJRVcmM4JUsQmoSxx53go2V0RgD6NE78LTYC3MAhOYJNonzgFq4eAQFoiU+Lw0GKSB
	RUBVomfBE1YQm1fAQmLh1+dMEOvkJWZe+s4OYnMKWEq8bTvAAlEjKHFy5hMwmxmopnnrbGaQ
	+RICNzgkzlzpZQOZLyHgIjG9XR5ijrDEq+Nb2CFsKYmX/W1QdrrEj8tPoXYVSDQf28cIYdtL
	tJ7qZwYZwyygKbF+lz5EWFZi6ql1TBBr+SR6fz+BauWV2DEPxlaSaF85B8qWkNh7rgHK9pA4
	sXwPNOR6GCVOP2him8CoMAvJO7OQvDMLYfUCRuZVjJKpBcW56anFpgVGeanl8FhOzs/dxAhO
	51peOxgfPvigd4iRiYPxEKMEB7OSCC+fuHO6EG9KYmVValF+fFFpTmrxIUZTYHhPZJYSTc4H
	ZpS8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqY7M/Fd/b96xQz
	SZh81KW8QPFhpBv/14Aq9ejQX+45jna3/3v639QMtClbpFOu3zz1xvzqmVLHta6fszr/embF
	623CiXlrDNX/8rCIPoqN6wycZvjpTk6c8Iparj3CRa9SV1xetzDY/OFfr8pfV08z+/I2HTx9
	75Qhn0XJul/ZJzaducw4X2RfyJlXU8Tk38r+u7DnyLoJMedncx+ULHM6emHKjusbPsS+z/13
	9eVeI54pi/elsdyx0noeVuzUfeL5tw7PPyWvb6Zd6hLQks8vCapYaNT338zIS99JVmnWXvFH
	hSenXfa//XO/0YHgO/P3z/mrJWA06/P/raI5LnL7w7NWfW7sSN++cvGz0P+/eJRYijMSDbWY
	i4oTAfYINIhwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnO43ZZd0g/mTxCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgyruyZwlow26Hi
	9pdPjA2MzSZdjJwcEgImEutfT2HpYuTiEBLYzSixYs9/doiEhMSpl8sYIWxhiZX/nrNDFH1k
	lDj0/yMTSIJNQF3iyPNWsCIRgROMEvMnuoEUMQvMYJLo+bWCDSQhLBAuMevaYjCbRUBVomfB
	E1YQm1fAQmLh1+dMEBvkJWZe+g62mVPAUuJt2wEWEFsIqGZW50qoekGJkzOfgMWZgeqbt85m
	nsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMExp6W1g3HPqg96
	hxiZOBgPMUpwMCuJ8PKJO6cL8aYkVlalFuXHF5XmpBYfYpTmYFES5/32ujdFSCA9sSQ1OzW1
	ILUIJsvEwSnVwDTpzdEU4yYBX5ObnGyXyoxDhfR2T5SNnN7U1iW9jT3lg2nUv85jKkpLHepW
	+G/nXlRvu1PMbInev2KDiXN4VMsXcB7es6L0q5HO33kTi3NLjl7hWqTH88l/siRPiZTk9cj/
	3WcY5S+sE/4QEbD+iv2irlchze3a1jmVApqzLNw4ti+vyn09Zcvng5N5/r3U2M9YeCCnXpZL
	bNILCwPp9u/eZkbMnzNS9h8LP+u2d4/Juvbnkx7q1F3Y9FryQeKbnQ5yl5ZGebv2dbCtyHAX
	zY16+urDw8TXi7OtZu2/bM/40U1ATbbwkkiljFjksacHEj0lqx699lB7vZ5z5lme4IbuaVGG
	ciudUgoTWnYxKrEUZyQaajEXFScCANJ8jAcoAwAA
X-CMS-MailID: 20241125071502epcas5p46c373574219a958b565f20732797893f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071502epcas5p46c373574219a958b565f20732797893f
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>

Add the ability to pass additional attributes along with read/write.
Application can populate attribute type and attibute specific information
in 'struct io_uring_attr' and pass its address using the SQE field:
	__u64	attr_ptr;

Along with setting a mask indicating attributes being passed:
	__u64	attr_type_mask;

Overall 64 attributes are allowed and currently one attribute
'ATTR_TYPE_PI' is supported.

With PI attribute, userspace can pass following information:
- flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- len: length of PI/metadata buffer
- addr: address of metadata buffer
- seed: seed value for reftag remapping
- app_tag: application defined 16b value

Process this information to prepare uio_meta_descriptor and pass it down
using kiocb->private.

PI attribute is supported only for direct IO.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 31 +++++++++++++
 io_uring/io_uring.c           |  2 +
 io_uring/rw.c                 | 82 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 4 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index aac9a4f8fa9a..bf28d49583ad 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	attr_ptr; /* pointer to attribute information */
+			__u64	attr_type_mask; /* bit mask of attributes */
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -107,6 +111,33 @@ struct io_uring_sqe {
 	};
 };
 
+
+/* Attributes to be passed with read/write */
+enum io_uring_attr_type {
+	ATTR_TYPE_PI,
+	/* max supported attributes */
+	ATTR_TYPE_LAST = 64,
+};
+
+/* sqe->attr_type_mask flags */
+#define ATTR_FLAG_PI	(1U << ATTR_TYPE_PI)
+/* PI attribute information */
+struct io_uring_attr_pi {
+		__u16	flags;
+		__u16	app_tag;
+		__u32	len;
+		__u64	addr;
+		__u64	seed;
+		__u64	rsvd;
+};
+
+/* attribute information along with type */
+struct io_uring_attr {
+	enum io_uring_attr_type	attr_type;
+	/* type specific struct here */
+	struct io_uring_attr_pi	pi;
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c3a7d0197636..02291ea679fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3889,6 +3889,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(48, __u64, attr_ptr);
+	BUILD_BUG_SQE_ELEM(56, __u64, attr_type_mask);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0bcb83e4ce3c..71bfb74fef96 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,54 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
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
+static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
+			 u64 attr_ptr, u64 attr_type_mask)
+{
+	struct io_uring_attr pi_attr;
+	struct io_async_rw *io;
+	int ret;
+
+	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
+	    sizeof(pi_attr)))
+		return -EFAULT;
+
+	if (pi_attr.attr_type != ATTR_TYPE_PI)
+		return -EINVAL;
+
+	if (pi_attr.pi.rsvd)
+		return -EINVAL;
+
+	io = req->async_data;
+	io->meta.flags = pi_attr.pi.flags;
+	io->meta.app_tag = pi_attr.pi.app_tag;
+	io->meta.seed = READ_ONCE(pi_attr.pi.seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(pi_attr.pi.addr),
+			  pi_attr.pi.len, &io->meta.iter);
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
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
+	u64 attr_type_mask;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -279,11 +322,27 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
+	if (attr_type_mask) {
+		u64 attr_ptr;
+
+		if (attr_type_mask != ATTR_FLAG_PI)
+			return -EINVAL;
+
+		attr_ptr = READ_ONCE(sqe->attr_ptr);
+		ret = io_prep_rw_pi(req, rw, ddir, attr_ptr, attr_type_mask);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +468,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -794,7 +856,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -828,6 +890,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -902,6 +976,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1125,6 +1201,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


