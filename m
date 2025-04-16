Return-Path: <io-uring+bounces-7492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C81BA908F6
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 18:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97A3B446715
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 16:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444B4211A38;
	Wed, 16 Apr 2025 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hFmNgp3A"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6704C212D8A
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820914; cv=none; b=FxMvVvyiGoY4/R1xg40RcKNTZr5da8pgPkiQoF1DfSFnkRf6xKHHLs3cU1r8f2jTcDVOilAqrObDdNxNspHyWT0qEZk/71laUH2i7SLWwXzPw00Hlc7DsV+xkjM71gtO/cD2FHeUTZUHPoGPJa460KN+NcaTTZIyCx3hZLsZxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820914; c=relaxed/simple;
	bh=Z+kMjhspGHSNg5C0M6NZoqL+m6CyPP37mRh30J8MTOo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i1+kdTVUwoqP0H/FzxLpXh1V3ZhyPeI4HoABswvHUsdPEt2gUxCA1/MK4xXzvZ4Uv/S0t02w6YCaaJOq0+SJhtaJ24kHn0MTlYoD6+cViT3COhIxBPz8y3PAed/i4jzDmpy+sE2BiN6dh+E8bTv7WWC3r/C88wZyrdoauYw4tL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=hFmNgp3A; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 53GF6w0s003190
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=2CAx0zndR8kw+WwSos
	uULyHlN4brk2LFu25zyUnfFhs=; b=hFmNgp3AwRjHSrkeIhTz6e6UVAx3PEP6P5
	Fyr0WKW4qwHWUNVTL1PFesTDqCd9cm5qRvy1dU6bPGo4vUTXX5kSQZX6idqqcaAO
	GKcirQyo+m8nU127KXmF2+VBC5fXO10qNN3wIA5DcFi9VwYqU7HBtju6UMQKpCWb
	9pN5WMHCVZk/VUWxRRqcuDQ+fxzgegRP8HC7cyvMkGxxoEq5iJHHe3/TUZZEPvn3
	DtYDbEdqw7QuvvjXAzMw8Th9K5nM9+XzbfFFjzRgNFfywf4AYfD5sCRWLFQZxMAR
	S0DPQ5svf7ZExLYmFC+7zdvNy5LIYxk2y0RbiM+4qApaExa+KmNw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4623tpcke9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:28:29 -0700 (PDT)
Received: from twshared60378.16.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 16 Apr 2025 16:28:20 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 18D2D1A552C7C; Wed, 16 Apr 2025 09:28:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] liburing/io_passthrough: use metadata if format requires it
Date: Wed, 16 Apr 2025 09:28:02 -0700
Message-ID: <20250416162802.3614051-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FyB09nLpehLQNKd8FBDChmY5_cLNVL7k
X-Authority-Analysis: v=2.4 cv=dLammPZb c=1 sm=1 tr=0 ts=67ffdaad cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=ECus0urKE0Kxf4j2yicA:9
X-Proofpoint-GUID: FyB09nLpehLQNKd8FBDChmY5_cLNVL7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_06,2025-04-15_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/io_uring_passthrough.c | 16 ++++++++++++++++
 test/nvme.h                 |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index bea4f39..66c97da 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -17,6 +17,7 @@
 #define BS		8192
 #define BUFFERS		(FILE_SIZE / BS)
=20
+static void *meta_mem;
 static struct iovec *vecs;
 static int no_pt;
=20
@@ -193,6 +194,12 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int tc, int read,
 			cmd->addr =3D (__u64)(uintptr_t)&vecs[i];
 			cmd->data_len =3D 1;
 		}
+
+		if (meta_size) {
+			cmd->metadata =3D (__u64)(uintptr_t)(meta_mem +
+						meta_size * i * (nlb + 1));
+			cmd->metadata_len =3D meta_size * (nlb + 1);
+		}
 		cmd->nsid =3D nsid;
=20
 		offset +=3D BS;
@@ -404,6 +411,12 @@ static int test_io_uring_submit_enters(const char *f=
ile)
 		cmd->addr =3D (__u64)(uintptr_t)&vecs[i];
 		cmd->data_len =3D 1;
 		cmd->nsid =3D nsid;
+
+		if (meta_size) {
+			cmd->metadata =3D (__u64)(uintptr_t)(meta_mem +
+						meta_size * i * (nlb + 1));
+			cmd->metadata_len =3D meta_size * (nlb + 1);
+		}
 	}
=20
 	/* submit manually to avoid adding IORING_ENTER_GETEVENTS */
@@ -451,6 +464,9 @@ int main(int argc, char *argv[])
 		return T_EXIT_SKIP;
=20
 	vecs =3D t_create_buffers(BUFFERS, BS);
+	if (meta_size)
+		t_posix_memalign(&meta_mem, 0x1000,
+				 meta_size * BUFFERS * (BS >> lba_shift));
=20
 	for (i =3D 0; i < 32; i++) {
 		int read =3D (i & 1) !=3D 0;
diff --git a/test/nvme.h b/test/nvme.h
index 1254b92..9c3cfa1 100644
--- a/test/nvme.h
+++ b/test/nvme.h
@@ -59,6 +59,7 @@ enum nvme_io_opcode {
=20
 static int nsid;
 static __u32 lba_shift;
+static __u32 meta_size;
=20
 struct nvme_lbaf {
 	__le16			ms;
@@ -157,6 +158,7 @@ static int nvme_get_info(const char *file)
=20
 	lba_size =3D 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
 	lba_shift =3D ilog2(lba_size);
+	meta_size =3D ns.lbaf[(ns.flbas & 0x0f)].ms;
=20
 	close(fd);
 	return 0;
--=20
2.47.1


