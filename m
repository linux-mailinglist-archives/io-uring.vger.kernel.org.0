Return-Path: <io-uring+bounces-5281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A699E7BB1
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFFBE16AB51
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190C422C6C0;
	Fri,  6 Dec 2024 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MiSC5NA4"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72725212F95
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523859; cv=none; b=Egvq9OzJH2X7XZ8ksLzRzzdxIfdUBSbV9/naM+dhQtDR5IkSxos3hii6TS54AU9OK5Fs5+IMh2GAY8spK+fnG8YalHKFUsTparDIkPSe0/QCV/Df6tJEgRD2G1+cL+0iqllotYqwT4mpzXPZlQy8L+xLHjURFSbMDlSZRDYCKYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523859; c=relaxed/simple;
	bh=ukAn3Puk+mzSpgUH5QpxvX6oj/B9tKT9Zod2gBrrNxk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uj9nV3GLy3om6fx4CQJgEKtCOhaPOJGV815UmrdlSo0lrz6J7Q+l5yp9hkPpzM6D4z4BHxijk8auXCEFk12aA3MRvltvjLgM2qHXkqFRdW4YQfGxR/OKJlXbwKs/Hzh0iTe5SU8+0NXU+xgvmSS8in45aPPHtGd5DX9DYiz+6ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MiSC5NA4; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4B6LhBv0028062
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:24:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=RnKIfSUe6w2ixzU7OG+SwOm9cN3Gu+YpiZw9DKhX7pk=; b=MiSC5NA4E991
	g1Z2rOz099KsCp+9EKpGa4+eBiIZiIF3d+kZgjr6MjcZV97/5BYM8FYWJaqP3YXu
	ijUhSgLFDJ+g7d/AET0NYt3oacsXLKgFa4r2bky+jXc2We7Ef0zUpnlk9R47AsHP
	h99gZpgv6BT4KOcs3mZR9Z0rXQDY9ZSVwvMofHcWDzuJr8pojpLV28CfR7uX3X8y
	CUBemLCIkhvCF8MJQrd7T/yUbdcmw3Secb/XPot84udgT/XKR61ixaeKwQlbtmM+
	0wxFvg0737T5D9A0h1Urw7Xgvkj7Vu4rkJBwzY3z5+N+T0yaFwd4XK7oOq8z4bgA
	eLjVcCjtdA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 43c1ggkvjs-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:24:16 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:24:03 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id EA02015B8CB69; Fri,  6 Dec 2024 14:18:26 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 01/12] fs: add write stream information to statx
Date: Fri, 6 Dec 2024 14:17:50 -0800
Message-ID: <20241206221801.790690-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: CAaXa7gGqO59selpzAVnnhFbCj_fFbJE
X-Proofpoint-ORIG-GUID: CAaXa7gGqO59selpzAVnnhFbCj_fFbJE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Add new statx field to report the maximum number of write streams
supported and the granularity for them.

Signed-off-by: Keith Busch <kbusch@kernel.org>
[hch: rename hint to stream, add granularity]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c                 | 2 ++
 include/linux/stat.h      | 2 ++
 include/uapi/linux/stat.h | 7 +++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 0870e969a8a0b..00e4598b1ff25 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -729,6 +729,8 @@ cp_statx(const struct kstat *stat, struct statx __use=
r *buffer)
 	tmp.stx_atomic_write_unit_min =3D stat->atomic_write_unit_min;
 	tmp.stx_atomic_write_unit_max =3D stat->atomic_write_unit_max;
 	tmp.stx_atomic_write_segments_max =3D stat->atomic_write_segments_max;
+	tmp.stx_write_stream_granularity =3D stat->write_stream_granularity;
+	tmp.stx_write_stream_max =3D stat->write_stream_max;
=20
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 3d900c86981c5..36d4dfb291abd 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -57,6 +57,8 @@ struct kstat {
 	u32		atomic_write_unit_min;
 	u32		atomic_write_unit_max;
 	u32		atomic_write_segments_max;
+	u32		write_stream_granularity;
+	u16		write_stream_max;
 };
=20
 /* These definitions are internal to the kernel for now. Mainly used by =
nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 887a252864416..547c62a1a3a7c 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -132,9 +132,11 @@ struct statx {
 	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
 	/* 0xb0 */
 	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment coun=
t */
-	__u32   __spare1[1];
+	__u32   stx_write_stream_granularity;
 	/* 0xb8 */
-	__u64	__spare3[9];	/* Spare space for future expansion */
+	__u16   stx_write_stream_max;
+	__u16	__sparse2[3];
+	__u64	__spare3[8];	/* Spare space for future expansion */
 	/* 0x100 */
 };
=20
@@ -164,6 +166,7 @@ struct statx {
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_i=
d */
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields=
 */
+#define STATX_WRITE_STREAM	0x00020000U	/* Want/got write_stream_* */
=20
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx=
 expansion */
=20
--=20
2.43.5


