Return-Path: <io-uring+bounces-2351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2FA918004
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D07FAB218C6
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF3117F4E8;
	Wed, 26 Jun 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jzrBw7G4"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568812AF1A
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402182; cv=none; b=ATUookZ7HRQdHmDYnLt3msE5PqzvKvKOLG6KX+bjX+38zwt6US6V3fTWyMU+vCwSWHxDhY5DHAoAfubr+JGZMnIYIP9DXE0Ejm5Q4I3e2CKiILNDIbaXTTk/1WHjD0hHAib5R7nZZ3m4gQScihkBpv8hg7JvitvndywpNvK6IEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402182; c=relaxed/simple;
	bh=EpWtZHYTQiB3/19IHJw0HPh6rzE07MqEQ9BceeF06eg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FH1wyFtPVA11vcYl6RpXstAhIQmxsSHGs6PhnMSEc/RJKc2PFvj0o4na4VRTHm7cuAP14e1oL9ryfcZfn3iG8SqMUu+9h2Fvn1VOXYBV7+gXRjauEoIuZbs1pLPDCHUvIAmypeiIbfKOq5p7QdnP/mfCAU3Ak4buNxR0WxSu4Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jzrBw7G4; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240626114258epoutp039df8f431262ccff7c8b5f488c4fb6d8e~ciyvtwX0O0791607916epoutp03Y
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240626114258epoutp039df8f431262ccff7c8b5f488c4fb6d8e~ciyvtwX0O0791607916epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402178;
	bh=cyyohgc9kguPnz4TuUAHQZPA34igWJ87jYDppv5Wf+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzrBw7G4mTLzoN/bY+GOhAAXf4ukJg2fvJ5B6UOXsDcc8rDmA3MNtMbSZaZX74AIi
	 JZxn81vJTH+b7oofDKX69/npB9WX5aI+3iMScyIqWTbND9fJrQbDZsDYy15jWul+Xs
	 IbaHpyQEU5/NCmeUdZhtBJhmU+TzpCmQqxD6MoF4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240626114257epcas5p28023ccbe8f36aaa55565c3c4778dab9e~ciyuT4IaD2974929749epcas5p2M;
	Wed, 26 Jun 2024 11:42:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W8KZR1By4z4x9Pw; Wed, 26 Jun
	2024 11:42:55 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	08.75.11095.FBEFB766; Wed, 26 Jun 2024 20:42:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521~chmTVXSrt2295722957epcas5p4h;
	Wed, 26 Jun 2024 10:15:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101525epsmtrp128101f7cce08a95e97aa20203016d957~chmTUot2E1052710527epsmtrp1F;
	Wed, 26 Jun 2024 10:15:25 +0000 (GMT)
X-AuditID: b6c32a49-423b770000012b57-ec-667bfebfd1a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A1.7B.29940.D3AEB766; Wed, 26 Jun 2024 19:15:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101523epsmtip1c44f5558bf00537373e796428a83c878~chmRrELpQ0256902569epsmtip1k;
	Wed, 26 Jun 2024 10:15:23 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 08/10] io_uring/rw: add support to send meta along with
 read/write
Date: Wed, 26 Jun 2024 15:36:58 +0530
Message-Id: <20240626100700.3629-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmhu7+f9VpBtMusFg0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLZYf/8dkMbHjKpMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dw+Pr3F4vF+31U2j74tqxg9Pm+SC+CMyrbJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG9n
	U5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdcWBFI0tBn2vFg3m/
	2BsYOy26GDk5JARMJF41/mbqYuTiEBLYzShx9GwTM4TziVFi//4p7BDON0aJG+v2scG0vNz9
	kBHEFhLYyygxc7YzRNFnRomOhpfsIAk2AXWJI89bwYpEBGolVrZOB5vELLCUUeLDg+tAOzg4
	hAXCJe7PUwYxWQRUJR60R4GYvAIWEg9a6iBWyUvMvPQdbCKngKXEnc3bwSbyCghKnJz5hAXE
	Zgaqad46G+xoCYG5HBLrp9xkh2h2kejq38cEYQtLvDq+BSouJfGyvw3KTpf4cfkpVE2BRPOx
	fYwQtr1E66l+sCuZBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CtvBI75sHYShLtK+dA2RISe881
	QNkeEgcfL2OBBFUPo8T1bV3MExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3PbXYtMAwL7UcHsfJ
	+bmbGMGpV8tzB+PdBx/0DjEycTAeYpTgYFYS4Q0tqUoT4k1JrKxKLcqPLyrNSS0+xGgKDO6J
	zFKiyfnA5J9XEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVANTx+N7
	Vm3JJ6fd2fb4hduvjXfnGj5x2vHkWre/0l2/P9G9c1ud5v7sffcnqbb5iHtlT5TM1uJTMpde
	lXoV2CQ3Tc9aW/Nv8lxf/rX9Avyckvevmb5MyvHj01/i1Vo9XXvvtP3Hf6x3W3b4cr7bbtW0
	7L7nDjv6xX7d1pi5add61wmKk2ztVKr7GX237grZ4v45wbEgcVJg9Je+b+5HWQ1fr2HQ5rne
	LjRRRypy829/ldWlKg23uO4s+7JdcNut2Rpi9g0TfcJdQk6t4gp6u3hD2Kefz1LSZRWchKYu
	acy1bzM1rkxtTvnH9bJ2z9Wo+A9HDU++2b67aJfO2rCSl/eaOxctVtbZ/yz4w8JzS1YaKbEU
	ZyQaajEXFScCAFY+04RGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSnK7tq+o0g8ZnQhZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+XH/zFZTOy4yuTA7bFz1l12
	j8tnSz02repk89i8pN5j980GNo+PT2+xeLzfd5XNo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0S
	uDIOrGhkKehzrXgw7xd7A2OnRRcjJ4eEgInEy90PGbsYuTiEBHYzSnyb1s8KkZCQOPVyGSOE
	LSyx8t9zdoiij4wSz/dOYwJJsAmoSxx53grWLSLQyihxYGoLmMMssJJR4vaiF2BVwgKhEusW
	zQcay8HBIqAq8aA9CsTkFbCQeNBSB7FAXmLmpe/sIDangKXEnc3bwRYLgZQ8bwY7iFdAUOLk
	zCcsIDYzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cT
	IzhCtDR3MG5f9UHvECMTB+MhRgkOZiUR3tCSqjQh3pTEyqrUovz4otKc1OJDjNIcLErivOIv
	elOEBNITS1KzU1MLUotgskwcnFINTCuXtfzcqfA9WH06W1L96duRH+LF0uIX3cnsPejOaOtp
	7nqgzF5bJXuh+m9XK3v1YO4ze1Odf0WcKbZ+0vLOgffJMn2dZ0VtT+t05gS8c35nfvPE+v7n
	kvo/JGXFVRNN7nxgeDvFLP5NXnJZ5f7vjAePL3Krjq940ZCtH3SVWSH4S/S3YtMUprwZ6lk+
	nza9tJb+tkRGbE1e9rS/Fe3lHTUrwwP/r2+J+Wrc4vzhDZ9w7/+AWzaCZz6Fckd2PNn8+sRm
	x25D953lbUsn36zOl7BoNsn0YOu/dbBYIcCv7c7hvwuuhdwSz/416ca0/7O1nhns/tXWOdf0
	nnVG9GGbHZyCc1du2mx+6V+08p1yJZbijERDLeai4kQAt/q5rf8CAAA=
X-CMS-MailID: 20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521@epcas5p4.samsung.com>

This patch adds the capability of sending meta along with read/write.
This meta is represented by a newly introduced 'struct io_uring_meta'
which specifies information such as meta type/flags/buffer/length and
apptag.
Application sets up a SQE128 ring, prepares io_uring_meta within the SQE
at offset pointed by sqe->cmd.
The patch processes the user-passed information to prepare uio_meta
descriptor and passes it down using kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h | 30 +++++++++++++++-
 io_uring/io_uring.c           |  7 ++++
 io_uring/rw.c                 | 68 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 |  9 ++++-
 5 files changed, 110 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index db26b4a70c62..0132565288c2 100644
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
index 2aaf7ee256ac..9140c66b315b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -101,12 +101,40 @@ struct io_uring_sqe {
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
-		 * this field is used for 80 bytes of arbitrary command data
+		 * this field is starting offset for 80 bytes of data.
+		 * This data is opaque for uring command op. And for meta io,
+		 * this contains 'struct io_uring_meta'.
 		 */
 		__u8	cmd[0];
 	};
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
+struct io_uring_meta {
+	__u16	meta_type;
+	__u16	meta_flags;
+	__u32	meta_len;
+	__u64	meta_addr;
+	/* the next 64 bytes goes to SQE128 */
+	__u16	apptag;
+	__u8	pad[62];
+};
+
+/*
+ * flags for integrity meta
+ */
+#define INTEGRITY_CHK_GUARD	(1U << 0)	/* enforce guard check */
+#define INTEGRITY_CHK_APPTAG	(1U << 1)	/* enforce app tag check */
+#define INTEGRITY_CHK_REFTAG	(1U << 2)	/* enforce ref tag check */
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7ed1e009aaec..0d26ee1193ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3704,6 +3704,13 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_meta) >
+		     2 * sizeof(struct io_uring_sqe) -
+		     offsetof(struct io_uring_sqe, cmd));
+
+	BUILD_BUG_ON(META_TYPE_LAST_BIT >
+		     8 * sizeof_field(struct io_uring_meta, meta_type));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..e8f5b5af4d2f 100644
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
+	const struct io_uring_meta *md = (struct io_uring_meta *)sqe->cmd;
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
+	if (io->meta.flags & ~INTEGRITY_VALID_FLAGS)
+		return -EINVAL;
+
+	io->meta.apptag = READ_ONCE(md->apptag);
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
@@ -269,11 +307,16 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	if (unlikely(req->ctx->flags & IORING_SETUP_SQE128 && !ret))
+		ret = io_prep_rw_meta(req, sqe, rw, ddir);
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -400,7 +443,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (unlikely(rw->kiocb.ki_flags & IOCB_HAS_META))
+		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -768,8 +814,12 @@ static inline int io_iter_do_read(struct io_rw *rw, struct iov_iter *iter)
 
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
@@ -786,7 +836,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -815,6 +865,14 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -881,6 +939,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (unlikely(kiocb->ki_flags & IOCB_HAS_META))
+		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 
 	do {
 		/*
@@ -1091,6 +1151,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		if (unlikely(kiocb->ki_flags & IOCB_HAS_META))
+			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3f432dc75441..49944b539c51 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,7 +9,14 @@ struct io_async_rw {
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


