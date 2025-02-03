Return-Path: <io-uring+bounces-6240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC77A262EC
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF8483A3833
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2238B20E00D;
	Mon,  3 Feb 2025 18:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="An0L3zW8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D27D20E001
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608421; cv=none; b=kXS7rHlY4T1SHk6nCGAKmRUfvzWSHAMBYsfCMKKmhEAkuSzd5PrSw2+c1tOGS8F92m1mqNtuR/WSOt88wINJ8KvGtxzGqu6MIPv0JOda5xsx0huTa9RYIr6VRwiR4/LEpKPDDo1FtJu2+AYDW17751hyCccen2eZ+P+XjbfnFD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608421; c=relaxed/simple;
	bh=hBTdVLWotElbjiKrJMGMO0Vizdmv5SGCkBv7KTRDkYA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PGhp7bEfzL3A13DzbG5lAeJkXgyGOVYbleUQ/gxUikbwAL4FeY1XRzsn+szGsxDhtR9BqBTEEmv5TSvNYKirxZOsEfz19Nt6OZjZY2KxxZxeuX0xf0gIfkiVO6hVEexEBfw5cIag8tCBq6xQkzlOYaN5hvf+wV8v6M/nR00aolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=An0L3zW8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513IHrgo029278
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:46:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=rTPoyzw51Yec8rpjP1Uz2mSVpEeoAASdS67qh/SGUII=; b=An0L3zW8RuKD
	uKOaaOPi1Ge4984Vsh3aVVqxwvBlzZimK7RElx7D+sKrPzjjoi/n1TRNp+rB25/P
	KWmjTalU5E8l1bcU9PQpC3WmstCSuyps0UgfoZjNYt3+IeLn/VrQy1braIQl8Mfn
	NogxsMLAYxFsz7ZcARAeBYpnUdOCGm3kcwJHkT3m+u5sWteidEAl0P0aezofsEZm
	5z8PASaDRWcGOMHNmQ8+EYXM2d1syukgMWCL9qvjjOM/0idOmxjpkCPC/G7X6P+q
	natJ/aiMLmHZdNNoMDIbp1IpVVka8DWbt9LwYTiC07OnVYhqecaF2tzdhvlQyHzJ
	i9t0s8JHWw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k2e9gja4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:46:58 -0800 (PST)
Received: from twshared29376.33.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:46:56 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B7B05179C262D; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Keith Busch
	<kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCHv2 06/11] io_uring: enable per-io write streams
Date: Mon, 3 Feb 2025 10:41:24 -0800
Message-ID: <20250203184129.1829324-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
References: <20250203184129.1829324-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ajysz3pSOeVvcSB9Vq2D1S4EF0a2XscF
X-Proofpoint-GUID: ajysz3pSOeVvcSB9Vq2D1S4EF0a2XscF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Allow userspace to pass a per-I/O write stream in the SQE:

      __u8 write_stream;

The __u8 type matches the size the filesystems and block layer support.

Application can query the supported values from the block devices
max_write_streams sysfs attribute. Unsupported values are ignored by
file operations that do not support write streams or rejected with an
error by those that support them.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/io_uring.c           | 2 ++
 io_uring/rw.c                 | 1 +
 3 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index e11c826385277..df191ccbcd7bf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,10 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			__u8	write_stream;
+			__u8	__pad4[3];
+		};
 	};
 	union {
 		struct {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263e504be4a8b..944ce66d4f1e2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,6 +3875,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u8,   write_stream);
+	BUILD_BUG_SQE_ELEM(45, __u8,   __pad4[0]);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 991ecfbea88e3..641d484d2a9e8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -298,6 +298,7 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
 	}
 	rw->kiocb.dio_complete =3D NULL;
 	rw->kiocb.ki_flags =3D 0;
+	rw->kiocb.ki_write_stream =3D READ_ONCE(sqe->write_stream);
=20
 	rw->addr =3D READ_ONCE(sqe->addr);
 	rw->len =3D READ_ONCE(sqe->len);
--=20
2.43.5


