Return-Path: <io-uring+bounces-5261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDCA49E63B6
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 02:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 990AC28529D
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 01:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B24014901B;
	Fri,  6 Dec 2024 01:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="e/abHQ40"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD7D14D708
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733450014; cv=none; b=ZfFxAXPGE2ZGrBNTwRSyoElOV1MhV+uZOfmBO2ySp01wY9dhymM3kxNn0GWJUTTpr9QWu7kmP78CbHvZ765F7RaJHVAJiSqDmf+MJNrXVf1mXCXu8T9QzGqi/qRBgufH8r4DwiElApsQD+yIDKFUEn9tm09rHGv/6z/d4bdIz6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733450014; c=relaxed/simple;
	bh=TShGIinhtFGgvq8AU4aYd/uSo6I+vUdgnqrheypY8Fc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DxwwKqQL2bbVBnL8Qx3iAjQHRMvT5XHO7T73U53wwQ6XM+njjI3JafqrYn3PJqgFvrDjG+obN+D5vAoc4JzBpzWhuWwLZ6ISKiyxDMOusCJiN8sZjNXvoXKv8souGtlFrrVoQWQr3didPysOkSDNDebZ1p0+gaxl8DynnFWcvRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=e/abHQ40; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4B605dJ4013872
	for <io-uring@vger.kernel.org>; Thu, 5 Dec 2024 17:53:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=qdL6YTuP4C1ftheSaTqqa06tk40Qi3hfBfSgmatUaHM=; b=e/abHQ40oZkx
	4PpLiZCdAbi9CnSWu/1sB1QRUfaHgxSM8Cqx4Zh+juhU3i0EUE3qoW6bz+q37dZm
	QI0XEDG1Em3/f9HGlDVMg9/hbjggIyP5BSZX4GXcF7qIAlutm0Sm/nSw3PxwWq3P
	3IV4xDfGDObKgScfBgeg1TadSGYqOHcI2KsjyyGTZNMbn3fvl0HlZaUFKyKI3r1a
	VpFxBXCE9Q6y1mwUjznJ9WPlP8bR6mg6qImKxQMtgrYEczsQTH4NF4YYjzSajxQx
	pGQ1mSz0njwRtFjgt88xhQm+IgQC+94aPxyr1xvKIGqg779AADzDXlZ6ri2WP1Za
	mxgwGJ76eg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 43bmrwh5m0-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 05 Dec 2024 17:53:30 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 01:53:23 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id F086D15B2114D; Thu,  5 Dec 2024 17:53:08 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 02/10] io_uring: protection information enhancements
Date: Thu, 5 Dec 2024 17:53:00 -0800
Message-ID: <20241206015308.3342386-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206015308.3342386-1-kbusch@meta.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 1d9lJ6CiZflj39NIOy40-S5TcI16MEVP
X-Proofpoint-ORIG-GUID: 1d9lJ6CiZflj39NIOy40-S5TcI16MEVP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Just fixing up some formatting, removing unused parameters,  and paving
the way to allow chaining additional arbitrary attributes.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h | 14 ++++++++------
 io_uring/rw.c                 | 10 +++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 38f0d6b10eaf7..5fa38467d6070 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -115,14 +115,16 @@ struct io_uring_sqe {
 #define IORING_RW_ATTR_FLAG_PI	(1U << 0)
 /* PI attribute information */
 struct io_uring_attr_pi {
-		__u16	flags;
-		__u16	app_tag;
-		__u32	len;
-		__u64	addr;
-		__u64	seed;
-		__u64	rsvd;
+	__u16	flags;
+	__u16	app_tag;
+	__u32	len;
+	__u64	addr;
+	__u64	seed;
+	__u64	rsvd;
 };
=20
+#define IORING_RW_ATTR_FLAGS_SUPPORTED (IORING_RW_ATTR_FLAG_PI)
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will al=
locate
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 04e4467ab0ee8..a2987aefb2cec 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -272,14 +272,14 @@ static inline void io_meta_restore(struct io_async_=
rw *io, struct kiocb *kiocb)
 }
=20
 static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddi=
r,
-			 u64 attr_ptr, u64 attr_type_mask)
+			 u64 *attr_ptr)
 {
 	struct io_uring_attr_pi pi_attr;
 	struct io_async_rw *io;
 	int ret;
=20
-	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
-	    sizeof(pi_attr)))
+	if (copy_from_user(&pi_attr, u64_to_user_ptr(*attr_ptr),
+			   sizeof(pi_attr)))
 		return -EFAULT;
=20
 	if (pi_attr.rsvd)
@@ -295,6 +295,7 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct=
 io_rw *rw, int ddir,
 		return ret;
 	rw->kiocb.ki_flags |=3D IOCB_HAS_METADATA;
 	io_meta_save_state(io);
+	*attr_ptr +=3D sizeof(pi_attr);
 	return ret;
 }
=20
@@ -335,8 +336,7 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
 	if (attr_type_mask) {
 		u64 attr_ptr;
=20
-		/* only PI attribute is supported currently */
-		if (attr_type_mask !=3D IORING_RW_ATTR_FLAG_PI)
+		if (attr_type_mask & ~IORING_RW_ATTR_FLAGS_SUPPORTED)
 			return -EINVAL;
=20
 		attr_ptr =3D READ_ONCE(sqe->attr_ptr);
--=20
2.43.5


