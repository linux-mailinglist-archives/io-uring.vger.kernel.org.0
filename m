Return-Path: <io-uring+bounces-5119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D5A9DB6CE
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7D84B226C3
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB5D19ADA4;
	Thu, 28 Nov 2024 11:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pLogFCxh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD7819C558
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794377; cv=none; b=numbUmiiHc94Djp1ynDz4fd4hVH/ss4xfkyRSEr8thrfe9cgicudQHLob8LUlFtf7AGWPHzRFblpXfoEXbR/IUa6ANpRx8TokCoKmqywQxQNCt8HTYYyFeY0t4w9UbyM9Seodz9ESgeTAC7rBfdvQfm54V75ES4oYwrD1zdUctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794377; c=relaxed/simple;
	bh=5J3NXYra2/YxPZxu5qRQTtUikmlmRPaCldNiAhVHLLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Nh1ZFmcBYyIGNLCVjgiKqtGJFIGgu3Oc2hvA2JySYZe73JuDGQz7WbmaHF8A0aEa8b4OHIlxA3KvrwdzJGu6wuV7JY6paT/Dm5ggtsDYQbdLeuXgtH4QV9YU0kREsH2o+l493NdUuAGQ9Vn/Q3h387TDzDQrmf8vQ9xWw/RavOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pLogFCxh; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241128114613epoutp03623d8c9212740dcd60286bccb1cde717~MH01cH-SQ3198531985epoutp03N
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241128114613epoutp03623d8c9212740dcd60286bccb1cde717~MH01cH-SQ3198531985epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794373;
	bh=282tku0al61IXFMRfq2A0Kwta4pxflaZcBhYE+AaiEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLogFCxhynHZyXGhC8S3ai9ccMcmCcUAOide6FOdRJJ2nERsYKE1Nv6dBotXjV8Xx
	 3vQ8upIHIKgXH9QlJo+T4gGxJhhJ1cPqVQ7S+YvFVz6ok3ZA7XKzhz2bBwwhKW42gJ
	 5PzZdHs9BnnLueLyoLvoTdCZ8/HI0qwwMOHQXv9A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241128114613epcas5p3bbeff532cffe0119eed07eb0e2dccff3~MH00841Rg2826028260epcas5p3k;
	Thu, 28 Nov 2024 11:46:13 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XzZJg6jyKz4x9Py; Thu, 28 Nov
	2024 11:46:11 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.29.29212.30858476; Thu, 28 Nov 2024 20:46:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241128113109epcas5p46022c85174da65853c85a8848b32f164~MHnrNiK-T1913419134epcas5p4d;
	Thu, 28 Nov 2024 11:31:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241128113109epsmtrp18368a72fd836e00ec7ed9d4dd183dc91~MHnrMBRWd0066100661epsmtrp1y;
	Thu, 28 Nov 2024 11:31:09 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-e3-674858030750
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	56.0D.18729.D7458476; Thu, 28 Nov 2024 20:31:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113106epsmtip2d1db4db4999be4111c857546de05b560~MHnoodbys2693826938epsmtip2F;
	Thu, 28 Nov 2024 11:31:06 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v11 06/10] io_uring: introduce attributes for read/write and
 PI support
Date: Thu, 28 Nov 2024 16:52:36 +0530
Message-Id: <20241128112240.8867-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHOfeW9tKtcFcwO2EZIzcuGxoexbYeOhEFHzcZmJppNrcEdqU3
	BSlt04duZGPdClN0hdKIxBYUsmUqsBewCs4agjwmAt1EYRgQWdpsijjBAJOHW0vL5n+f8zvf
	3/eb33kQuHCCG03kqw2sTs2oKC6f47waFxePv0Mrk05ZktHM3BIHfWZdwVFNgxOgxvEKLpq6
	OgvQaEc7hi40dmPoYekgBzmqzRjq/meai2ydwwC5bm9El13XOOjs114eOjHSxkXnep9iyL3S
	G4rc9hreNiHdbh/n0UMDRrq5oYxLt3z1Cf3TqIlLz3hvc+jy1gZA99d18ejHzTF0s2cak/Pf
	LdiSxzIKVhfLqnM1iny1MpV6862cjByJNEkUL0pBm6lYNVPIplI7MuXxu/JVvpmo2MOMyugr
	yRm9nkrcukWnMRrY2DyN3pBKsVqFSivWJuiZQr1RrUxQswaZKCkpWeITvl+Q9+iElad1pn3Q
	tPBlqAnUbjoOwghIiuH1RhP3OOATQvIygGZzOQgsZgGceODgBBbzAHrOevC1ll8HvFhgwwXg
	79VLof4NIfkYwPPncv3MJV+DXX+UrlpF+X0t9ddXrXDSisGjlTU8vyqSPACPPWnF/MwhX4WL
	LTOrEQISQet4CS8Q9wo8fWNhlcPIFOgYng8NaF6A1057OH7GfRrzjw7cHwDJMQJ6vGPB5h3w
	SosNBDgS3u9tDdaj4b2Kz4OshH8PebEAa6G550pQnwZL+yp8poQvIA5+dykxUH4ZVvV9iwVy
	w6FlyRNsFcC2M2tMwaMXaoIMoWvQhPltIEnDsRJV4OS+APBOxxmeFcTanxnH/sw49v+T6wDe
	AKJZrb5QyeZKtKJ4NXvkv3vO1RQ2g9WXvkHeBhq/X0noBBgBOgEkcCpKoH1ut1IoUDAfFrE6
	TY7OqGL1nUDiO/BKPHpdrsb3VdSGHJE4JUkslUrFKZukIupFwVRprUJIKhkDW8CyWla31ocR
	YdEmTDZx8oYxItFyd1m8f33vpMDEekLb606e35sV0vLLzYuOnj2tloSGiL9mPXxJd/uIV6F2
	b6sF+w8P7iySLm6cq0w31x5x/uZq0WTkVS8eKquPQlV3OXuSJz9azhg8UPh8U1x2arasdevo
	QSZrr81dcGe4bUg3WW+VJW6feolHu5emrfe1TR2WHzLT3xsZl2WXkX3yJ+mRA4KYdfREJn+z
	ox+st9286CYeZcm/ufX6oZASZTGZUd//84IpfDaNN78r9aHzz3tzdplAFravxyUe6XJTVcVF
	by9P62uPSYYfHAzr2/700r6VtPBbkdJTwyEZH38a8QZhC48pnpOUlfOdOymOPo8RbcB1euZf
	mf9aNHIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvG5tiEe6we4zQhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZH7onsBdss69Y
	830xawPjXOMuRk4OCQETiYtnnzJ1MXJxCAnsZpToeXSMESIhIXHq5TIoW1hi5b/n7BBFHxkl
	Tr9dzQ6SYBNQlzjyvBWsSETgBKPE/IluIEXMAjOYJHp+rWADSQgLhEtMWPWTCcRmEVCV+LX5
	IzOIzStgITHhbgs7xAZ5iZmXvoPZnAKWErOvfWMFsYWAai4/vs4KUS8ocXLmExYQmxmovnnr
	bOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHHNamjsYt6/6
	oHeIkYmD8RCjBAezkghvAbd7uhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe8Re9KUIC6Yklqdmp
	qQWpRTBZJg5OqQamTL3Tz3PNxYQ+TN/ab1J8/3pj7vIbuTKbEzMfee5R8ZpYnmx+rjKDYf39
	m9vbdZsu7Zwq4XR7gop1ayhrTudPv093exmdGp/v+KtlcnWnrV3C0kusTQlvpKyqJ0qnxkdN
	+5x9avXlexFFpzcyvW+et+Z7Ya/9udc9F/Z+dpBe6rDo+c5XkkevOu1jmfLKWn/HJJFGMYH/
	BqZVq633C8Vempkht1CoK3JyAEe1jTNTSLR6i3C4WuH1E/ZVTk82hTzc/VGN5z33/E6/xbad
	Ql25V/b88eJJs5p9vUzgpiRzt2luUPGyfy+O3JZW4uYpO1woGjdt2iWhljD2PPHCNRsbZKw/
	f97PvPM+X7j26ftKLMUZiYZazEXFiQAQ1UYJKAMAAA==
X-CMS-MailID: 20241128113109epcas5p46022c85174da65853c85a8848b32f164
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113109epcas5p46022c85174da65853c85a8848b32f164
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>

Add the ability to pass additional attributes along with read/write.
Application can prepare attibute specific information and pass its
address using the SQE field:
	__u64	attr_ptr;

Along with setting a mask indicating attributes being passed:
	__u64	attr_type_mask;

Overall 64 attributes are allowed and currently one attribute
'IORING_RW_ATTR_FLAG_PI' is supported.

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
 include/uapi/linux/io_uring.h | 16 +++++++
 io_uring/io_uring.c           |  2 +
 io_uring/rw.c                 | 83 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 4 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index aac9a4f8fa9a..38f0d6b10eaf 100644
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
@@ -107,6 +111,18 @@ struct io_uring_sqe {
 	};
 };
 
+/* sqe->attr_type_mask flags */
+#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
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
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 06ff41484e29..e4891f1ce52d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3893,6 +3893,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(48, __u64, attr_ptr);
+	BUILD_BUG_SQE_ELEM(56, __u64, attr_type_mask);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0bcb83e4ce3c..04e4467ab0ee 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,53 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	return 0;
 }
 
+static inline void io_meta_save_state(struct io_async_rw *io)
+{
+	io->meta_state.seed = io->meta.seed;
+	iov_iter_save_state(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static inline void io_meta_restore(struct io_async_rw *io, struct kiocb *kiocb)
+{
+	if (kiocb->ki_flags & IOCB_HAS_METADATA) {
+		io->meta.seed = io->meta_state.seed;
+		iov_iter_restore(&io->meta.iter, &io->meta_state.iter_meta);
+	}
+}
+
+static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
+			 u64 attr_ptr, u64 attr_type_mask)
+{
+	struct io_uring_attr_pi pi_attr;
+	struct io_async_rw *io;
+	int ret;
+
+	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
+	    sizeof(pi_attr)))
+		return -EFAULT;
+
+	if (pi_attr.rsvd)
+		return -EINVAL;
+
+	io = req->async_data;
+	io->meta.flags = pi_attr.flags;
+	io->meta.app_tag = pi_attr.app_tag;
+	io->meta.seed = pi_attr.seed;
+	ret = import_ubuf(ddir, u64_to_user_ptr(pi_attr.addr),
+			  pi_attr.len, &io->meta.iter);
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
@@ -279,11 +321,28 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+		/* only PI attribute is supported currently */
+		if (attr_type_mask != IORING_RW_ATTR_FLAG_PI)
+			return -EINVAL;
+
+		attr_ptr = READ_ONCE(sqe->attr_ptr);
+		ret = io_prep_rw_pi(req, rw, ddir, attr_ptr, attr_type_mask);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +468,9 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	io_meta_restore(io, &rw->kiocb);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -744,6 +805,10 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
 		return false;
 
+	/* never retry for meta io */
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		return false;
+
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
@@ -794,7 +859,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -828,6 +893,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -902,6 +979,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	io_meta_restore(io, kiocb);
 
 	do {
 		/*
@@ -1125,6 +1203,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		io_meta_restore(io, kiocb);
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


