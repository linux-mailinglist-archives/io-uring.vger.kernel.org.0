Return-Path: <io-uring+bounces-9481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81486B3C340
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 21:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DE0E3BCEDC
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 19:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2853237172;
	Fri, 29 Aug 2025 19:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nTIlmw38"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9B242D9D
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496402; cv=none; b=a0VXIvNIiFdDq6okBfT/W7jpkamAfzIma3uXjUAybsK3WpmSiBZrZmNDRK0KjY/lrxy1ZLTVqu7eknQn4NY04IRcQ2C4gel3PCbsWddSR29cG9LzfSVC/axKfBPgwuUZreDKMYONjhNZ4/gQBdX2tddjoxW08D1st5qL8e2ciBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496402; c=relaxed/simple;
	bh=mlEuANvaszP4H1DUY7nLus2iWHAIQiYc4ZfMSWS1yaA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9ExjTmxQhd8sUreRUiCvhtPFcxXTbligUu0FxkeO6L12csd4ZnUxqazmdX0RrG/2EMIhSYA1+M0xVLdWm8/aLpId6Y/N9N9OpjRW4soTLEcr2hJBOkAoN5tDxSCuz7kW1bYa0tobsxlM5L313WxPUQ7RMINE+B7/7LAgkUAzLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nTIlmw38; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 57TIMBcd792748
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:40:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=C2DeyarDBtC1csduhUxGjPaQzdfwycw104o1n+5Ozug=; b=nTIlmw38I/S3
	0HrULBDSJzP0gcIxmim/OisDPs5kTfW5Yu0YKrG7rxZ7hdQKT1FBrZwhAn80qQw4
	kEzmj72J6aONrdPqAaKig25MqpJKeY1n22+oj+pB5Vrx9AWhsqQctXVHjiy8GRL8
	08mEFZiQmaFHTMaKSURasTR107SndMNNjGmoPqhnGo71Syv7pdLcpnT/+3NpxC0U
	xyvvl2eggZ0r9uR9HPaYXoosz2j4FRxS3DxIsZRPxw4HIIpZALGHanLsoJLo12F6
	HwgHk7xtHabWRrv8yt3Wq8uinw+j/Eafc7oq0ZfW8s1xOODMhZqg1LuriCgtqFw5
	+dN0CZGpNA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48uhdx0jdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:39:59 -0700 (PDT)
Received: from twshared52133.15.frc2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Fri, 29 Aug 2025 19:39:58 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id A6DDC121EBB7; Fri, 29 Aug 2025 12:39:43 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH liburing 1/2] Add support IORING_SETUP_SQE_MIXED
Date: Fri, 29 Aug 2025 12:39:33 -0700
Message-ID: <20250829193935.1910175-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829193935.1910175-1-kbusch@meta.com>
References: <20250829193935.1910175-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gza8s-AmyjiKFoTcmxb8s_YR-XIagxD1
X-Authority-Analysis: v=2.4 cv=bOQWIO+Z c=1 sm=1 tr=0 ts=68b2020f cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=cZUIjA7GoH1rrATRsXgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI5MDE3NSBTYWx0ZWRfX/3xFuDakfVyy
 EG/CZdeMZtd72JLpbFfcqP1zM0EBd93UWA9esBVvtyWHW8N21vr9P/PAK+eau4l3tvQfd32Un+f
 bscsaqiS2c74HLgYiMSktfQk+jtxWESe/NhiYeJBjwtO3jKwuwIVTFZ21d7FJuT4QP2eQufW/96
 o/yWV5nm1uuGBnnG8qnPceewMMukvC9OFo9AfyaNMA5h9remFvz7VjKM9IDxynrrs3X6W1jkjuP
 fxbjpPW/XgdH7cMHkj18EWGZIVIIWhhIYxURdIcgTcCVr7i/Eh3vUdOTS9in/FVXbjahB2arTVL
 uh96PNscLNSsW4Uu+wjXYn4Gyf/ah3k9V2sEQbOkzAKfzSWC7xDL+xrDeGJovw=
X-Proofpoint-GUID: gza8s-AmyjiKFoTcmxb8s_YR-XIagxD1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

This adds core support for mixed sized SQEs in the same SQ ring. Before
this, SQEs were either 64b in size (the normal size), or 128b if
IORING_SETUP_SQE128 was set in the ring initialization. With the mixed
support, an SQE may be either 64b or 128b on the same SQ ring. If the
SQE is 128b in size, then IOSQE_SQE_128B will be set in the sqe flags.
The client may post a NOP SQE with IOSQE_CQE_SKIP_SUCCESS set that the
kernel should simply ignore as it's just a pad filler that is posted
when required.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing.h          | 31 +++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  9 +++++++++
 2 files changed, 40 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 7ea876e1..dc94ad13 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1853,6 +1853,37 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
qe(struct io_uring *ring)
 	return sqe;
 }
=20
+IOURINGINLINE struct io_uring_sqe *_io_uring_get_sqe128_mixed(struct io_=
uring *ring)
+	LIBURING_NOEXCEPT
+{
+	struct io_uring_sq *sq =3D &ring->sq;
+	unsigned head =3D io_uring_load_sq_head(ring), tail =3D sq->sqe_tail;
+	struct io_uring_sqe *sqe;
+
+	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
+		return NULL;
+
+	if ((tail & sq->ring_mask) + 1 =3D=3D sq->ring_entries) {
+		sqe =3D _io_uring_get_sqe(ring);
+		if (!sqe)
+			return NULL;
+
+		io_uring_prep_nop(sqe);
+		sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
+		tail =3D sq->sqe_tail;
+	}
+
+	if ((tail + 1) - head >=3D sq->ring_entries)
+		return NULL;
+
+	sqe =3D &sq->sqes[tail & sq->ring_mask];
+	sq->sqe_tail =3D tail + 2;
+	io_uring_initialize_sqe(sqe);
+	sqe->flags |=3D IOSQE_SQE_128B;
+
+	return sqe;
+}
+
 /*
  * Return the appropriate mask for a buffer ring of size 'ring_entries'
  */
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 643514e5..fd02fa52 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -126,6 +126,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_SQE_128B_BIT,
 };
=20
 /*
@@ -145,6 +146,8 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* this is a 128b/big-sqe posting */
+#define IOSQE_SQE_128B          (1U << IOSQE_SQE_128B_BIT)
=20
 /*
  * io_uring_setup() flags
@@ -211,6 +214,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
=20
+/*
+ *  Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
+ *  IOSQE_SQE_128B set in sqe->flags.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
--=20
2.47.3


