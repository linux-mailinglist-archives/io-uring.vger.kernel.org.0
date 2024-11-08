Return-Path: <io-uring+bounces-4576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3EB9C261F
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 21:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E28C82839B7
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1501EABA2;
	Fri,  8 Nov 2024 20:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VPtbd3Y/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680BC1F26E6
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731096322; cv=none; b=f6beCFvQdJYwekdGbkJfpVA0cfw3WmNARF09A06Ex27pqGJ4tbYfDJ801pUNCZEqMIW/pRU1j2fL5OoItKvG49aIv+vI/zEiARpEk1sjD1Nbu3XE/UqYXf1bihRMFbdm0RY354TE/rT9E7hLcM97P4G2AwTQ1++kwEOPf5BV/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731096322; c=relaxed/simple;
	bh=DMSc5tz9jrIHoidVsK/PYPAouaSun5T57ModES7HZis=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGd0N6w2X8i+nizDu6eccSD5QxvPcK1nGUXg48O+pHQBf7tHYWQ1Ckr+B8mdCTLU3RDc3EVEJlai0mLwCZtyc7rw9wMu8fwf2gQ03w6dr8imTAARLCCIPrDhczE582uU/poO0l/7m63yJeqnOFvjK70/BBPxVxBZ+Fb8ALzptEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VPtbd3Y/; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8HPfPT013959
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 12:05:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=YZD1lyriaTdTAo7xj8F47G4Z4f/YwLOtay5hq6Zxzmo=; b=VPtbd3Y/0aGh
	ViYVeslDUPnLVOKyWrbgKeQXHnTtMB7tiSkymLTFgdB3/H3DKeh6mYsqovwbx4FG
	DkyFRT5s5zbmMjWVdOIBtE3+VsAKdWccOT9u3LsGyQk7jBiSfu3EPSiGbxgL9pET
	PfUSK5b/ZQ5+mmDkKP/XM8a85Epduu8i8BOt6MxTv6wPwNkvmFw46KbUuDRZMhhz
	qcu6ACU/VoTR2SX3XB4crF6sGeSMQb8EgDFGBb5sg4fRX7ME+y7FLqkaiOAg+Pgm
	cSwX4IWwB6kPqkJc5iwxzOjbdTzY3avQJOGhRwj2hTz+Sp45OiEaiy+4vlfek1yS
	8lnwhbvKCg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42sp2t9srg-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 12:05:19 -0800 (PST)
Received: from twshared26967.08.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 20:04:59 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id A640814E3A03A; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Nitesh Shetty
	<nj.shetty@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv11 6/9] io_uring: enable per-io hinting capability
Date: Fri, 8 Nov 2024 11:36:26 -0800
Message-ID: <20241108193629.3817619-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241108193629.3817619-1-kbusch@meta.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ukwXsvjAlINp_m7R76rZgIJyerjZpLy8
X-Proofpoint-ORIG-GUID: ukwXsvjAlINp_m7R76rZgIJyerjZpLy8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Kanchan Joshi <joshi.k@samsung.com>

With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
all the subsequent writes on the file pass that hint value down. This
can be limiting for block device as all the writes will be tagged with
only one lifetime hint value. Concurrent writes (with different hint
values) are hard to manage. Per-IO hinting solves that problem.

Allow userspace to pass additional metadata in the SQE.

	__u16 write_hint;

If the hint is provided, filesystems may optionally use it. A filesytem
may ignore this field if it does not support per-io hints, or if the
value is invalid for its backing storage. Just like the inode hints,
requesting values that are not supported by the hardware are not an
error.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/io_uring.c           | 2 ++
 io_uring/rw.c                 | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 56cf30b49ef5f..4a6c95c923eb4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	__pad4[1];
+			__u16	write_hint;
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 076171977d5e3..115af82b9151f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4169,6 +4169,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(48, __u64,  __pad4);
+	BUILD_BUG_SQE_ELEM(56, __u16,  write_hint);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
=20
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=3D
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 93526a64ccd60..fdab23424f386 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -279,7 +279,7 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio =3D get_current_ioprio();
 	}
 	rw->kiocb.dio_complete =3D NULL;
-
+	rw->kiocb.ki_write_hint =3D READ_ONCE(sqe->write_hint);
 	rw->addr =3D READ_ONCE(sqe->addr);
 	rw->len =3D READ_ONCE(sqe->len);
 	rw->flags =3D READ_ONCE(sqe->rw_flags);
--=20
2.43.5


