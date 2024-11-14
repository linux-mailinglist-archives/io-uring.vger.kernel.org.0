Return-Path: <io-uring+bounces-4681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D489C8933
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07826B25656
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4497518C02F;
	Thu, 14 Nov 2024 11:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="c9bj50yI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7341F9403
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583070; cv=none; b=M4N2akQHCdjFW1Mi1Nt0ayHtD8zNcrSHyMnuBVrgkt4lMiEul8Ito/0oRxFtciYxW44z9YVCUkDq11Enn95uZR4nhozecIDI6+lGZyao3+hZWcNVqxGoCYdnkq1Q5E4e1GkWd106Ds8NF4ZHRiBUmj+qg2eEE325S+YIbvaQD4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583070; c=relaxed/simple;
	bh=PyfcMAMGeZJg51IyMSZk4QQAUN0KrHf8jzVl+O0XVOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=psy78HC+20RejAY1EpobuRUqxhXpO7l3uhAaSVRMyrOUvzf0Le38jK8HrLm33o1jo/SBerKDoj1v5dz4CqrJssC6RlNkkRjd9yXWBKjID4jaj8qHervLTQ99/BwoXUmLWXXLWOT5umnPPnKR70RAyDKMe7Cn5K+tj2NbbtZmaYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=c9bj50yI; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241114111745epoutp02566a2a373eff2f0a8a50955d65ea0f4c~H0Z_tqd6w0203502035epoutp02H
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241114111745epoutp02566a2a373eff2f0a8a50955d65ea0f4c~H0Z_tqd6w0203502035epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583065;
	bh=tZZIY0MH0UpA8H3aJms9Q19PBOI9eFg3Maw9wcJIZ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9bj50yIOUcxgXm68TaemLMasL3FIrV5PsGsN2noJy7MKDWUKtGnfg+of9DsDPxpr
	 u4SEpnzPL/xe7kchrdYAZWAc9h4MP4nzgcPZErHAJVeC6YOxA6dMxqvpgh43XDqMex
	 25NXAnUaxGylC/XmdwLc2xzhJZ1esmFOS54tqRpY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241114111744epcas5p38ca87425dbc104df262cec71a0585b04~H0Z_D16aB2860228602epcas5p3A;
	Thu, 14 Nov 2024 11:17:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XpyLH0Klsz4x9Pw; Thu, 14 Nov
	2024 11:17:43 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	93.A9.09770.65CD5376; Thu, 14 Nov 2024 20:17:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739~H0FUG_oPd1716917169epcas5p2L;
	Thu, 14 Nov 2024 10:54:05 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241114105405epsmtrp2a9b6c23a8130ecc72bb42f54c9d522c2~H0FUGE-Zn2090520905epsmtrp2X;
	Thu, 14 Nov 2024 10:54:05 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-ed-6735dc566311
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	25.C6.18937.DC6D5376; Thu, 14 Nov 2024 19:54:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105402epsmtip25f2a68912a8179078ecbb54411c30476~H0FRnf2GX1403514035epsmtip2b;
	Thu, 14 Nov 2024 10:54:02 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v9 06/11] io_uring: introduce attributes for read/write and
 PI support
Date: Thu, 14 Nov 2024 16:15:12 +0530
Message-Id: <20241114104517.51726-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0wTZxjOd3e7FrLCgaCfTZzdZSqiFCptORygCWSeboksLsawGHbSSyGU
	a+21m5ORNSDBwRBUHFIQ0LApuLiBivzqhvUHoUy6itmkEaYEnFhp5IfBiMBKW5z/Pc/7Pc/7
	5nm/7xOiof/gYmEWZ2D1HKMh8UCs9cbGiKi9DxTqmJfPYqnJF3MYlV8+j1I1Ta2AujhUhlOu
	G1OAGuxuR6jGi7cQyl3Yj1HVlQUIdWtxAqdOWP8ClMW5ieqy9GJU3U9jAqrk7zacOt+zgFD2
	+Z53KLu5RrA9lG43DwnogTtGuqXpO5y+3PAt3TlowunJMSdGH7vSBOg/6m8K6OmW9+iW0Qkk
	NTAtOyGTZVSsXsJyGVpVFqdOJD/ek56crlDGyKJk8VQcKeGYHDaRTPkkNeqjLI0nEyn5ktEY
	PaVUhufJ6KQEvdZoYCWZWt6QSLI6lUYn10l5Joc3cmopxxq2ymJitig8wi+yMy1nHZjuxc5D
	zVVlmAl0fVgMAoSQkMPWQTNaDAKFoUQngK8cDsRHpgCssJ/E35Dumcdg2WLtqfSr2gEcnmsF
	PjINoP1hg1eFExvgzX8LvQdhRBeApWf7sCWCEuUILDpeI1hSrSD2wTOvz+FLGCPWQdNTp9ct
	IuJhn60D9c1bC6vuznr1AcRWeMF0FfVpQmBv1Si2hFGPpuBqtTcGJO4J4axtxGMQekgKfLyI
	+fqsgE97rgh8WAyn3Rbch9Xw5cAY4sM6WHD7N3/ObbDQVoYutUGJjfCXjmhfeQ08ZbuE+MYG
	wdK5Ub9VBNtqlzEJixpr/BhCS7/Jj2n4+kmNf3Wlnp1WP8PLgcT8VhzzW3HM/4+uB2gTWM3q
	+Bw1yyt0Wzj2qzf3nKHNaQHelx65qw08evhcagWIEFgBFKJkmMiWHKsOFamYrw+zem263qhh
	eStQePZ9HBWHZ2g9X4UzpMvk8TFypVIpj49VyshVIlfhGVUooWYMbDbL6lj9sg8RBog9YZJy
	GxNyv58JVlxzPPj5aML6PHvVrpX67H7UETw1ZFsn1gR/0BeWKlXhtRf0MGSiwJgPnREppyPL
	O74ZbK2L+MFq7srfv8HiUjgPnShqNAZVvp9hPqhsvre6xBjXe7s4/Noj8bFLkto1d7e7xpXu
	oIpPiR/Lh1fJdkzMxo2M70H6r5ed7AyZytsnf7cny3VkCP1McAA3C+xNf97ZpiCetEEufLxR
	kRdsD1qYZCrp3JLT6orni9xwcdGv5yt+JzYdOZAbJ60/HLjZtTl5JK22eyZy/27t8Mr5WLzu
	fnAQmrtQXNa88757x6uk3Za1Zj667nJkw+fXpe6ptI7ovQcHjpIYn8nIIlE9z/wH2CLG43IE
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvO7Za6bpBqc38Ft8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBl7F14kaXgq2fF
	xpn9LA2Me6y7GDk5JARMJA4dn87UxcjFISSwnVHiwMe3rBAJCYlTL5cxQtjCEiv/PWeHKPrI
	KNH29iobSIJNQF3iyPNWsCIRgROMEvMnuoEUMQvMYJLo+bUCrEhYIExi28d3YEUsAqoSDa9u
	gdm8ApYSp0/tYobYIC8x89J3dhCbU8BKYkXDVqA4B9A2S4nv60UgygUlTs58wgJiMwOVN2+d
	zTyBUWAWktQsJKkFjEyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3MYIjTStoB+Oy9X/1DjEy
	cTAeYpTgYFYS4T3lbJwuxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUI
	JsvEwSnVwNR1tdvU9LWKmN+XtNxdRVwnfpa9CeY18qjQNpu4qrvq+tRDf9iNV0b4ZP7z+H3c
	/Hji/sDQo0aT/2/bvbHG+btWyXLLXY1hIjmmwvs5a6q/MLqaTH7cwt+m4enodDF/4f52g1CZ
	bzMmSk96HF62LdY7weHQqhUn9Zad0d5m1Jv3ceLfw235P7UspsmuddjJc3zDS5HNr5lvfHov
	dKw8KM1ZQtyEsc3gguQzW1mZnTc/efkeWFX031HP6pRBSuxqk6AZ+mqPedqSXls/jfd/m9fY
	1ff07k/zWS6fNU3EWN/NYVbhiVa555x0dnKWstFh7aRVrfkvKk8sbD5Tv0h6z3XfiseKiv+O
	C71KODTphBJLcUaioRZzUXEiAARm4AcjAwAA
X-CMS-MailID: 20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>

Add the ability to pass additional attributes along with read/write.
Application can populate an array of 'struct io_uring_attr_vec' and pass
its address using the SQE field:
	__u64	attr_vec_addr;

Along with number of attributes using:
	__u8	nr_attr_indirect;

Overall 16 attributes are allowed and currently one attribute
'ATTR_TYPE_PI' is supported.

With PI attribute, userspace can pass following information:
- flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- len: length of PI/metadata buffer
- addr: address of metadata buffer
- seed: seed value for reftag remapping
- app_tag: application defined 16b value

Process this information to prepare uio_meta_descriptor and pass it down
using kiocb->private.

PI attribute is supported only for direct IO. Also, vectored read/write
operations are not supported with PI currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h |  29 ++++++++
 io_uring/io_uring.c           |   1 +
 io_uring/rw.c                 | 128 +++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 |  14 +++-
 4 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5d08435b95a8..2e6808f6ba28 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,12 +92,18 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			/* number of elements in the attribute vector */
+			__u8	nr_attr_indirect;
+			__u8	__pad4[3];
+		};
 	};
 	union {
 		struct {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		__u64	attr_vec_addr;
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -107,6 +113,29 @@ struct io_uring_sqe {
 	};
 };
 
+
+/* Attributes to be passed with read/write */
+enum io_uring_attr_type {
+	ATTR_TYPE_PI,
+	/* max supported attributes */
+	ATTR_TYPE_LAST = 16,
+};
+
+struct io_uring_attr_vec {
+	enum io_uring_attr_type	type;
+	__u64			addr;
+};
+
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
index bd71782057de..e32dd118d7c8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3867,6 +3867,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(44, __u8,   nr_attr_indirect);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index cce8bc2ecd3f..93d7451b9370 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,98 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
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
+			 const struct io_uring_attr_pi *pi_attr)
+{
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (READ_ONCE(pi_attr->rsvd))
+		return -EINVAL;
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(pi_attr->flags);
+	io->meta.app_tag = READ_ONCE(pi_attr->app_tag);
+	io->meta.seed = READ_ONCE(pi_attr->seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(pi_attr->addr)),
+			  READ_ONCE(pi_attr->len), &io->meta.iter);
+	if (unlikely(ret < 0))
+		return ret;
+	rw->kiocb.ki_flags |= IOCB_HAS_METADATA;
+	io_meta_save_state(io);
+	return ret;
+}
+
+
+static inline int io_prep_pi_indirect(struct io_kiocb *req, struct io_rw *rw,
+				      int ddir, u64 pi_attr_addr)
+{
+	struct io_uring_attr_pi pi_attr;
+
+	if (copy_from_user(&pi_attr, (void __user *)pi_attr_addr, sizeof(pi_attr)))
+		return -EFAULT;
+	return io_prep_rw_pi(req, rw, ddir, &pi_attr);
+}
+
+static int io_prep_attr_vec(struct io_kiocb *req, struct io_rw *rw, int ddir,
+			      u64 attr_addr, u8 nr_attr)
+{
+	struct io_uring_attr_vec attr_vec[ATTR_TYPE_LAST];
+	size_t attr_vec_size = sizeof(struct io_uring_attr_vec) * nr_attr;
+	u8 dup[ATTR_TYPE_LAST] = {0};
+	enum io_uring_attr_type t;
+	int i, ret;
+
+	if (nr_attr > ATTR_TYPE_LAST)
+		return -EINVAL;
+	if (copy_from_user(attr_vec, (void __user *)attr_addr, attr_vec_size))
+		return -EFAULT;
+
+	for (i = 0; i < nr_attr; i++) {
+		t = attr_vec[i].type;
+		if (t >= ATTR_TYPE_LAST)
+			return -EINVAL;
+		/* allow each attribute only once */
+		if (dup[ATTR_TYPE_PI])
+			return -EBUSY;
+		dup[ATTR_TYPE_PI] = 1;
+
+		switch (t) {
+		case ATTR_TYPE_PI:
+			ret = io_prep_pi_indirect(req, rw, ddir, attr_vec[i].addr);
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+		}
+		if (unlikely(ret))
+			return ret;
+	}
+	return 0;
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
+	u8 nr_attr_indirect;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -279,11 +366,29 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	nr_attr_indirect = READ_ONCE(sqe->nr_attr_indirect);
+	if (nr_attr_indirect) {
+		u64 attr_vec_usr_addr = READ_ONCE(sqe->attr_vec_addr);
+
+		if (READ_ONCE(sqe->__pad4[0]) || READ_ONCE(sqe->__pad4[1]) ||
+		    READ_ONCE(sqe->__pad4[2]))
+			return -EINVAL;
+
+		ret = io_prep_attr_vec(req, rw, ddir, attr_vec_usr_addr,
+					 nr_attr_indirect);
+	}
+
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +514,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -794,7 +902,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -828,6 +936,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -902,6 +1022,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1125,6 +1247,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


