Return-Path: <io-uring+bounces-4535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2649C0447
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE9D12843DE
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2399220ADCE;
	Thu,  7 Nov 2024 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="evV7Nvhg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FAC201010
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979572; cv=none; b=Zcn7D2uLtC4vRWD1760d9pH643MJVDdy6A2QAV68oYcj+H+x3o5KGwBewJyu8ofr0dU94+sQsAGb1uKj2bvRKFie+63YK5axT5gy0z4UnT6FTa+CsXlDXkyIBAFKG6QhWBiFUkHDZLzDM1k/DlewxSHzfpaiEHcsO2fhiBB3aGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979572; c=relaxed/simple;
	bh=TFtvS1q5kUepVa5YhrZAczvFsxz8JJWRDx+FKldl5i8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=AXOm7T1tzOIJQh5fOtDHj2qNx+xkAQJwq5qRYkazj2jTaSRkTXzlAPcs7NiHxmm8jigRUIa/lizgTyGoqQJvtfCIfsOgbC7wffzObXiGy3TwizVgyuDCIDdR+8lkaGwy/5cQm6Cpq+wFKNkfXhUi+ecB27To92mp3rWNA8tthWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=evV7Nvhg; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241107113927epoutp02e688e149dc28f7f4497e9979a8e604df~FrL7gXgjC2119521195epoutp02Z
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:39:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241107113927epoutp02e688e149dc28f7f4497e9979a8e604df~FrL7gXgjC2119521195epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730979567;
	bh=lrrcKZqRu6tWQmWOSZtN/5IH749WUidg7sI+DMsaAus=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=evV7NvhgDD8yZAOAf1WS0lfq+f1tGjGhZKZu/c5t0GpxlxxA4s/NiYq9XNkqUq8gU
	 1JReS8z9NDzLWNlFvZrvYb0Qz4C9BGNlh81GVNkFAYWrzv0POHn3giMvIp8Zs2r1Xf
	 EmwEeSAlV/VLza4iFrY/gRFatO6FMicyScdEtu9E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241107113926epcas5p3cbe3e70392154cf77044fbe633ae8216~FrL6nAAjC1277512775epcas5p3k;
	Thu,  7 Nov 2024 11:39:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xkg8X754rz4x9Ps; Thu,  7 Nov
	2024 11:39:24 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.82.09420.CE6AC276; Thu,  7 Nov 2024 20:39:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241107104744epcas5p3027a7b237c4311619dae45fa9335f772~FqexuKCeP1043510435epcas5p3l;
	Thu,  7 Nov 2024 10:47:44 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241107104744epsmtrp2dddca2c120c29e4e0b0c617dbfddeb78~FqextQ4VJ0176501765epsmtrp2R;
	Thu,  7 Nov 2024 10:47:44 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-89-672ca6ec4d17
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.46.07371.0DA9C276; Thu,  7 Nov 2024 19:47:44 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241107104742epsmtip149217f8d6d4879cc54a5fb3adbf4072e~FqevYkJ1l0893108931epsmtip1T;
	Thu,  7 Nov 2024 10:47:42 +0000 (GMT)
Date: Thu, 7 Nov 2024 16:10:00 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj gupta <anuj1072538@gmail.com>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241107104000.GB9730@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241107073852.GA5195@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0xbZRjHfU/b0wNZtwMb4x1jWg+LZlzbra2nStEg6sEtDp37MKbD2h5b
	bm3taXdRkxGREQaUjTCR0ilGwqAQCNAQsFY3YDQjMJxMboHgIh0CAwYbsIFjtrSo337P//0/
	l/eGsQLvoCFYqsZA6zXyDAL1Z7d07AuPulcVqRLUNojIhaU1NmmxtgCydqwIJWc6FgE5fLUN
	IWtqryPkXM5NNllemo2Q15/OomRx+wAgHSMR5E+OG2zyuyoXl8wfbEXJK851hOx74uSQfWYL
	97UAqs08xqX6e41UkzUPpZorz1L24SyUWnCNsCmTzQqonopOLvWg6VmqaWIWSfJPTo9V03Il
	refTGoVWmapRyYiDR1JeTxFLBMIooZR8ieBr5Jm0jEg4lBT1ZmqGezsE/6Q8w+iWkuQMQ8TE
	xeq1RgPNV2sZg4ygdcoMnUgXzcgzGaNGFa2hDS8LBYL9Yrfxo3R1Rz1PN3vo9MrqIyQL9Med
	B34YxEVwra0EPQ/8sUDcDmBJ0Q/AGywC2OV86AuWAZzsuc/dTKn+fYrjXXAA6LrW6AvuAjhg
	XwIeFxvfC39p7EE8jOIvws7JnA19B05A13TvRlkWXsWCLVlz7u4Yth1PgfXjMo+Hh0fC2mET
	6uUAeKNsgu1hPzwCFt9r4Hg4CA+DV1uciKcOxP/C4Lnvf/ONlwCnR0cRL2+H006bTw+BD+Yc
	qJdV8FG/y+fRweyun4GXX4U53UUszzwsXA1NazKvvAde6q7fsLPwrbBwbcKXyoOt324yAXNr
	LD6G0HEzC/GUgTgFpwal3vNpR6DNWgkugOfM/9ua+b9u5o0OkbDCvoh65d3wyjrmxX2w4ceY
	CsCxgl20jslU0YxYJ9TQp/69boU2swlsvPXwxFYw9sf96HaAYKAdQIxF7OAdTo5QBfKU8jOf
	0Xptit6YQTPtQOy+qYuskCCF1v1ZNIYUoUgqEEkkEpH0gERIBPNmci4rA3GV3ECn07SO1m/m
	IZhfSBbCzTcvfJ7byKxsrb586725D+2mp/sfD/Udi9+55ULh+nI1+or/p3e3HA5S9HL4aQ0l
	ljSNqY7pmv4qNjigpo5XdeZO2dzRmYq/344ZXxHU7SwI41164mguf0g4AoWW3cYvj7Y63jqo
	/FW4JzT4SGd8aa4979iy8/HtUZ0q+52L8VG2VLQL2k8JR1ZDc7+49cnQ9ImApfBtZaOhsKjq
	XMJeKae7/N1Sadi4PnFgsvFa8QtnA8ayc5cmZj4OYaIjjxdMygb4cYr4eefXbxScEE8MfnB7
	14FKRWuz7f35obWO/Klvnk+eH+1aPZ6mzYsMe0Zt7RSvWP88SS8VnrZsQxMXXVbZLMFm1HJh
	OEvPyP8Btn80XXQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCSnO6FWTrpBnuWKFt8/PqbxWLOqm2M
	Fqvv9rNZvD78idHi5oGdTBYrVx9lsnjXeo7FYvb0ZiaLo//fsllMOnSN0WLvLW2LPXtPsljM
	X/aU3aL7+g42i+XH/zFZnP97nNXi/Kw57A6CHjtn3WX3uHy21GPTqk42j81L6j1232xg8/j4
	9BaLR9+WVYweZxYcYff4vEnOY9OTt0wBXFFcNimpOZllqUX6dglcGT+WHGQpWOtVsaCtk72B
	cY1NFyMnh4SAicSKqy9Zuxi5OIQEdjNKrN+1mxEiISFx6uUyKFtYYuW/5+wQRU8YJVZPeMcK
	kmARUJHYv/EME4jNJqAuceR5K1iDiICSxNNXZxlBGpgFVjBLHJyyiBkkISwQL3Frx3WwBl4B
	HYnVN/vYIKYeYZI4vnAeO0RCUOLkzCcsIDazgJbEjX8vgRo4gGxpieX/OEDCnALaEpPerAc7
	QlRAWeLAtuNMExgFZyHpnoWkexZC9wJG5lWMkqkFxbnpucmGBYZ5qeV6xYm5xaV56XrJ+bmb
	GMFxqaWxg/He/H96hxiZOBgPMUpwMCuJ8PpHaacL8aYkVlalFuXHF5XmpBYfYpTmYFES5zWc
	MTtFSCA9sSQ1OzW1ILUIJsvEwSnVwBTgsm0fR5Fd+ZaZur7T/zp0r+08/9SbobZGdGdZKHv7
	IgeF2us8jwLZ/3UsvuG1K6MiepfLlYW+bzMsJSZzZrAffrKv/XTbhuv6UgkMT+pV9zs9sCqY
	3+JhL7PiX4ZSdqi72l/u3J4bk/N2rGY+pbr/btWR7z/NVpycXrCXS1GgbZNkRuOlwG1HuU+f
	KNUv7OE8s2nS/AUpu1dMOzCjyVlmwcmU9nU/5j7xNL+iEPTu2MbaVe6bZHabNO8IUE19FMNl
	0Viu3x385bizFv/X8IbUq3k9DrU3G3TOX3O7Vi3TGWxWtvr45VUl4qcb51tJ1skfmHiq+dWq
	8knSoiIlviLyGyNNv557MU/vkcjEH0osxRmJhlrMRcWJADgZa646AwAA
X-CMS-MailID: 20241107104744epcas5p3027a7b237c4311619dae45fa9335f772
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_adec1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com>
	<20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de>
	<CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
	<20241107073852.GA5195@lst.de>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_adec1_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

I addressed your feedback in the patch below, does this look fine?

From e03fe5fe8ea057d01f5986b8add3769d1095da07 Mon Sep 17 00:00:00 2001
From: Anuj Gupta <anuj20.g@samsung.com>
Date: Wed, 6 Nov 2024 17:48:38 +0530
Subject: [PATCH] io_uring/rw: add support to send metadata along with
 read/write

This patch adds the capability of passing integrity metadata along with
read/write. A new ext_cap (extended_capability) field is introduced in SQE
which indicates the type of extra information being sent. A new
'struct io_uring_sqe_ext' represents the secondary SQE space for
read/write. In future if another extension needs to be added, then one
needs to:
1. Add extra fields in the sqe/secondary-sqe
2. Introduce a ext_cap flag indicating additional values that have been
passed

The last 32 bytes of secondary SQE is used to pass following PI related
information:

- flags: integrity check flags namely
IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- pi_len: length of the pi/metadata buffer
- pi_addr: address of the metadata buffer
- pi_seed: seed value for reftag remapping
- pi_app_tag: application defined 16b value

Application sets up a SQE128 ring, prepares PI information within the
second SQE and sets the ext_cap field to EXT_CAP_PI.  The patch processes
this information to prepare uio_meta descriptor and passes it down using
kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 28 +++++++++++
 io_uring/io_uring.c           |  5 ++
 io_uring/rw.c                 | 88 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 4 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 56cf30b49ef5..29f0b742004b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,11 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			/* flags indicating additional information being passed */
+			__u16	ext_cap;
+			__u16	__pad4[1];
+		};
 	};
 	union {
 		struct {
@@ -107,6 +112,29 @@ struct io_uring_sqe {
 	};
 };
 
+/*
+ * If sqe->ext_cap is set to this for IORING_OP_READ/WRITE, then the SQE
+ * contains protection information, and ring needs to be setup with SQE128
+ */
+#define EXT_CAP_PI	(1U << 0)
+
+/* Second half of SQE128 for IORING_OP_READ/WRITE */
+struct io_uring_sqe_ext {
+	/*
+	 * Reserved space for extended capabilities that are added down the
+	 * line. Kept in beginning to maintain contiguity with the free space
+	 * in first SQE
+	 */
+	__u64	rsvd0[4];
+	/* only valid when EXT_CAP_PI is set */
+	__u16	flags;
+	__u16	pi_app_tag;
+	__u32	pi_len;
+	__u64	pi_addr;
+	__u64	pi_seed;
+	__u64	rsvd1;
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 076171977d5e..5aa16bb60313 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4166,7 +4166,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  ext_cap);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad4[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
@@ -4193,6 +4195,9 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_ext) !=
+		     sizeof(struct io_uring_sqe));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 768a908ca2a8..4f8b7952d9be 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,64 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
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
+static inline const void *io_uring_sqe_ext(const struct io_uring_sqe *sqe)
+{
+	return (sqe + 1);
+}
+
+static int io_prep_rw_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_rw *rw, int ddir)
+{
+	const struct io_uring_sqe_ext *sqe_ext;
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (!(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EINVAL;
+
+	sqe_ext = io_uring_sqe_ext(sqe);
+	if (READ_ONCE(sqe_ext->rsvd0[0]) || READ_ONCE(sqe_ext->rsvd0[1])
+	    || READ_ONCE(sqe_ext->rsvd0[2]) || READ_ONCE(sqe_ext->rsvd0[3]))
+		return -EINVAL;
+	if (READ_ONCE(sqe_ext->rsvd1))
+		return -EINVAL;
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(sqe_ext->flags);
+	io->meta.app_tag = READ_ONCE(sqe_ext->pi_app_tag);
+	io->meta.seed = READ_ONCE(sqe_ext->pi_seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(sqe_ext->pi_addr)),
+			  READ_ONCE(sqe_ext->pi_len), &io->meta.iter);
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
+	u16 ext_cap;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -279,11 +332,23 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	ext_cap = READ_ONCE(sqe->ext_cap);
+	if (ext_cap) {
+		if (READ_ONCE(sqe->__pad4[0]) || !(ext_cap & EXT_CAP_PI))
+			return -EINVAL;
+		ret = io_prep_rw_pi(req, sqe, rw, ddir);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -410,7 +475,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -795,7 +863,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -829,6 +897,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -903,6 +983,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1126,6 +1208,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_adec1_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_adec1_--

