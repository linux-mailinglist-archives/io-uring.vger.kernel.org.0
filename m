Return-Path: <io-uring+bounces-10698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC15EC750AB
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 16:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3808C363A68
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 15:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFF66A8D2;
	Thu, 20 Nov 2025 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Nt8cLLCm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4942F9C3D
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652279; cv=none; b=FYqGhU14lGvg7OM55vqtEDRWCq/WmDsRIEfOJQBdE29JwYujhia9KOlBSFdWNQMk0R+fo9FHdB/WnzYkYVHXg7ESqZARL2SSbDJjmooMo+fojdbi1UqhHfnLNt9RI3HrkXNjkga97RKDXSqUFnm/V9WMal/Iz1v9zdQthSgtDrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652279; c=relaxed/simple;
	bh=zSxOYKVfA/vPGolnd1JCb6YSBnstubyRe9yppRD54M8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gebiX52re4OUDfWCK76c1iBraHa26ny54pEWtUq6/9OQ7ITHyEov5my3D1QMkVvh9ySt9ddgiLqYiisx/LgC0KSbu3+I5KphUqmCmnzLNmgvsKYZYVgZ/hG51xCtSP59j8Ro2AEXb55CigtktLL3i4KyGMwHLII+Q9GIJFqtkbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Nt8cLLCm; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 5AK4ZvoP550900
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 07:24:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=Y/2J6O9gzuX2CvjQOX
	eU75bJPKcqKD94IE4ngw7VxbU=; b=Nt8cLLCmU8tYisbwbYqvohZ2IpSriXk5PD
	Wrbg3UF8wos0wf7+oBsanLjDvXk0ayuq6hIlmhPNRyxD859GmvJjk8OsLdqBJzr8
	O0p2hLsI8u3f+e6y8k6chKD0m8ecs0O0+whTxgLhDjaOqY36dSsDpDDPoBdlFW3i
	rTIsW5oxDerEhPHil6U3K2l/PC/xy3BMzxlZRuF8sLvfKTPfRrr+xrglqP3y9hzA
	YWEmFPs7W0qgGNJHRtaiB7hsC8g4wuKeTy4rAit1hn4wiEnL6vugYMu40GPSHACW
	3sro5ncFkHZOZVOeCNUosG5ldFEcduw8pib4CMSErF0WCXOW7lrQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4ahv3tkua6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 07:24:36 -0800 (PST)
Received: from twshared22076.03.snb1.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Thu, 20 Nov 2025 15:24:36 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0D5373FA6DA6; Thu, 20 Nov 2025 07:24:35 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] liburing: sync pi attributes with kernel uapi
Date: Thu, 20 Nov 2025 07:24:27 -0800
Message-ID: <20251120152427.452869-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIwMDEwMSBTYWx0ZWRfX/mGvhJ+qZul2
 rsxmYrjN0FwgczV+wvHi5cARxzoj3eJDh3pevWrgq9k+zy5OTDJ5+NFVxeUrZYZyoHHahOuGJPv
 Z1I9SzdjIG5o3VZrN3XPdhV9D7tE6NUxpwLh7HeCqera67lMqqEwrHgBq0Cd2C3gfsMK50t0NAn
 u4qtBDaZ2GlCbTzS8Ttrvk7R3lPjWBYlXzMeBuRBPH4kvaCC/bD6PWn6wW1X2daYOSHS7fh4TOx
 R4d+SG10HGudBuGgZG+YIegHQHb2Is+xHXlJbXKk7MlKy/Fu2VXQB5wAJFRjgfRyPQhM87ikUiP
 L//ysS0SFTT5fu/ABbxeO+g6S4ALA0QcrRbCCG9Sy93Ot038OlvEWcGU2VrgNNqCgd+ShJfSPpZ
 m4OcAKTqb7GUlNDRytIqeptcVa5GWg==
X-Proofpoint-ORIG-GUID: m4FD3VpUi1I11P030IyzTojafde3GxKf
X-Proofpoint-GUID: m4FD3VpUi1I11P030IyzTojafde3GxKf
X-Authority-Analysis: v=2.4 cv=YIWSCBGx c=1 sm=1 tr=0 ts=691f32b5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=8iLFYBD6hOO-n47D1RwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_05,2025-11-20_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

These were introduced in kernel release 6.13.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing/io_uring.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 44ce8229..a54e5b42 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -100,6 +100,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64   attr_ptr; /* pointer to attribute information */
+			__u64   attr_type_mask; /* bit mask of attributes */
+                };
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -109,6 +113,18 @@ struct io_uring_sqe {
 	};
 };
=20
+/* sqe->attr_type_mask flags */
+#define IORING_RW_ATTR_FLAG_PI  (1U << 0)
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
  * direct descriptor (like openat/openat2/accept), then io_uring will al=
locate
--=20
2.47.3


