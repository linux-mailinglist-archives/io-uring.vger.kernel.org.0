Return-Path: <io-uring+bounces-9574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E3BB4465C
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 21:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E766C3BEFA7
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22123271A9D;
	Thu,  4 Sep 2025 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="aMmggpi1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B2525B1D2
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014081; cv=none; b=DKZ9RHibMf+KHTytFNTD+Wcv6ZPDu43r/zH/xhMAV4HemMQ+AwlJe72So6808b03ldLcJNUOzLTAG133X7ivBU56GapmloEUmYL0fqPEu5UYmu16HF8ehP6G8XLPcQw1sb4KaralOdFZd7oBtJGcE1gTGro6HEw4TzWrmVAYPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014081; c=relaxed/simple;
	bh=EdTR/PWJvhm8O2Pe8dVcrD0mqJKv1WsdcKBcp2NYyxg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjm+n38OC1CpXDdR8DhtPXD8p8KNCUzSa+lpVIvB20evHJmFbvaaZr/jNReLWOqaisx9fbmuh8kFVQf5+arZwcdLvKaYhBU9v58Ith40YALomL/tNoFSOuvxiZvl+/E0INEAFhcELTfBhm29P87NHSaG4b/Dh72azLtHNetfA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=aMmggpi1; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 584J82Om2388864
	for <io-uring@vger.kernel.org>; Thu, 4 Sep 2025 12:27:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=XZLXMjtXK728V+nrnYf39zUW1rE+y2LCuOJyKj3XKeg=; b=aMmggpi1yJmf
	og7ocrwuSpf8nLWhFT5YslX0s3P+qkRNIztGmsKalBAMJTiV4N3w97IhfC4O3ttn
	jDcW4kxhnAXqUFy6iNSxN2kqKYrLZZsNCoiJRHCJxS9fZBSWQwGDbZNwwu9Zv5Vm
	ffKLVKuQaBTaRg9Ucu0BF4LscpFmDiroQlJkMUTsaq7kBVEvAxDkJCoqD98lQgVb
	AbhY4L4Sk6gS9V+AAXK2qlwuc/DRUblz1IlfSQ3LjMmSK5ieqS1iG74ndgVCCPBm
	ZAw3Utl0PYRkgVsyAQL8pKuyyQ9f6xKdDeGSP8QU7u1gIpewtoaXxGzYbAD2nRRi
	oR9rVCxQuA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48ye06a6h8-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 12:27:58 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 4 Sep 2025 19:27:25 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 875271578784; Thu,  4 Sep 2025 12:27:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCHv2 1/3] Add support IORING_SETUP_SQE_MIXED
Date: Thu, 4 Sep 2025 12:27:13 -0700
Message-ID: <20250904192716.3064736-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250904192716.3064736-1-kbusch@meta.com>
References: <20250904192716.3064736-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 42zSolOfimEqZfg5SIeZghvaNVjfE1YE
X-Proofpoint-GUID: 42zSolOfimEqZfg5SIeZghvaNVjfE1YE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE5MiBTYWx0ZWRfX+Av3zoqMvm4N
 0hhsnFNCbXm9cBEpa3dhLm7JHg6ly8oudpT3hz5e+a8shX8hZISOGhhKDXs3KRJ2jOvZphP8zWJ
 CUFFvfQqUjTHKwZYGZfRBeZWz0s1qOr2D0f5xPyXtOq9DGWyZEPhHCNTeTISma0BjHpXl1c/189
 KkM0+7tdsj7GNZR8nJDyfQoWB6K1K0ZiNOQNS5gE3Sq9AYocgD21ahmZ2Ed7edGu4NhZTbwIIKs
 V2YHHgCMks0OgVeRLkrJzqwr8cV2LlOvv8VMUTcxbKuYIoHgF8g2jogJ0I3SSpvKRCPf0DjNmmG
 0zOYn4gU7HlbUGXDtjwCqPcalp0JZNm32jw3I/Vm86YMx1jTmLeSX347J/rwGs=
X-Authority-Analysis: v=2.4 cv=IY+HWXqa c=1 sm=1 tr=0 ts=68b9e83e cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=cZUIjA7GoH1rrATRsXgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01

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
index 7ea876e1..97c70fa7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1853,6 +1853,37 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
qe(struct io_uring *ring)
 	return sqe;
 }
=20
+IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128_mixed(struct io_u=
ring *ring)
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


