Return-Path: <io-uring+bounces-4096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E93F9B4D85
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 510A31C20ECB
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398D2193416;
	Tue, 29 Oct 2024 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ay2frHnQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED87F194C92
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215198; cv=none; b=YddRxJpSJ7WuGNMPU+2jHyPaC2LxYVJHiK1CC/SUbJ8cF6Bej54b2ZmQOeCLbWvb8FRispBKQhsGbQToZwQ6aydBsID9/ncySZZWH6UfUTnkyosVxkdJDEDsnA33M4DIlIxhAH0R4tgpJVRXPgxPCJ8s8p8BsrtLds4KG+Kt87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215198; c=relaxed/simple;
	bh=bLVs+NUjXqkb64uW7DX9xzl2BkYI8JF3mYXsk/Fl4uY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seC5S9T0ZBHgj3kVgzFU4uqQn1aldIEjeeLIr+J6UPiGYImmPC/v7QfXr8xZeoIEYwFhY2huuSRPauonaUQ6LnN4PgHlWlNiSKt0t53zmyCY1bJDzatz6mVaUqrejPR0sEt+i7P23y+PUSw+4MIyyhGlkalQLtX7WtI5x9lYT/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ay2frHnQ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49T72Trg012612
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:19:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=YaxUJJnRZ28AJAdK6cvper+b/ynFQDqHd29QjSNk8fc=; b=ay2frHnQBoz3
	7Ne1TVmq/1c7UPH78vZxWhsnfpe1X2s/gMcA22+1LPYEbFzY6tEM0X8ziK5Ir6b5
	vo0stBS0x8rZkyjK+2M0jb5KR/XCSleMALdE1FMBrWD6NPlS/Ps/4kThvfUoyBxp
	JTKbdK3kkuvpHRTkoJv5QWmXRrMYA0CON8Xw0j3c/J1EOybmElLKPn838819Tebc
	xPUryeS4nxIaC0fnkDpgff6K4b1FpFS8vpnl0qfBxdgLQ55www/LU9N8RecMUsQs
	y7ZFPQDgmc+H6UldklgDliXIn73s6UnF39rhS+d3mXEx6ODhz3rVfkbiqgCcXZ+3
	Hwq9r0shmg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42jty7asby-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:19:55 -0700 (PDT)
Received: from twshared23455.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 29 Oct 2024 15:19:52 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 0228614920EA1; Tue, 29 Oct 2024 08:19:44 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <hch@lst.de>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, <bvanassche@acm.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv10 3/9] statx: add write hint information
Date: Tue, 29 Oct 2024 08:19:16 -0700
Message-ID: <20241029151922.459139-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029151922.459139-1-kbusch@meta.com>
References: <20241029151922.459139-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZFWGEwwJg-8pmWb8dJaqr5zln5xLBYzV
X-Proofpoint-GUID: ZFWGEwwJg-8pmWb8dJaqr5zln5xLBYzV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

If requested on a raw block device, report the maximum write hint the
block device supports.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bdev.c              | 5 +++++
 fs/stat.c                 | 1 +
 include/linux/stat.h      | 1 +
 include/uapi/linux/stat.h | 3 ++-
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 738e3c8457e7f..9a59f0c882170 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1296,6 +1296,11 @@ void bdev_statx(struct path *path, struct kstat *s=
tat,
 		stat->result_mask |=3D STATX_DIOALIGN;
 	}
=20
+	if (request_mask & STATX_WRITE_HINT) {
+		stat->write_hint_max =3D bdev_max_write_hints(bdev);
+		stat->result_mask |=3D STATX_WRITE_HINT;
+	}
+
 	if (request_mask & STATX_WRITE_ATOMIC && bdev_can_atomic_write(bdev)) {
 		struct request_queue *bd_queue =3D bdev->bd_queue;
=20
diff --git a/fs/stat.c b/fs/stat.c
index 41e598376d7e3..60bcd5c2e2a1d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -704,6 +704,7 @@ cp_statx(const struct kstat *stat, struct statx __use=
r *buffer)
 	tmp.stx_atomic_write_unit_min =3D stat->atomic_write_unit_min;
 	tmp.stx_atomic_write_unit_max =3D stat->atomic_write_unit_max;
 	tmp.stx_atomic_write_segments_max =3D stat->atomic_write_segments_max;
+	tmp.stx_write_hint_max =3D stat->write_hint_max;
=20
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 3d900c86981c5..48f0f64846a02 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -57,6 +57,7 @@ struct kstat {
 	u32		atomic_write_unit_min;
 	u32		atomic_write_unit_max;
 	u32		atomic_write_segments_max;
+	u32		write_hint_max;
 };
=20
 /* These definitions are internal to the kernel for now. Mainly used by =
nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 887a252864416..10f5622c21113 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -132,7 +132,7 @@ struct statx {
 	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
 	/* 0xb0 */
 	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment coun=
t */
-	__u32   __spare1[1];
+	__u32   stx_write_hint_max;
 	/* 0xb8 */
 	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
@@ -164,6 +164,7 @@ struct statx {
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_i=
d */
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields=
 */
+#define STATX_WRITE_HINT	0x00020000U	/* Want/got write_hint_max */
=20
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx=
 expansion */
=20
--=20
2.43.5


