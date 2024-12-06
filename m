Return-Path: <io-uring+bounces-5284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD639E7BC9
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AB2B16B0F1
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7E0212F96;
	Fri,  6 Dec 2024 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="M+EE+KSh"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054B320458C
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733524207; cv=none; b=d/21Er7/xYxbW549jZcghhOO2w7gmSUQodluGLoDC81XOjW9vM/NUEW4RZSmAFrMbsqsdZalzdcVH5msV5iLakh2XPrmenWWjwLU8L4NszdMl3MZP6pa/PVsPamJ6WMmAyrVZPB+mrExuT/EdHb1+/NmyqsK+kNsRcYzY5N3nLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733524207; c=relaxed/simple;
	bh=3DQXd4yJtDB6BYisNYWGe/g9nDmYCbca6TMBeVLuqls=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=doXYy7c8q0tO/qV7+XmuxBHZoCDosciqCDnjwHc6mKFQb5iRQ4XUUWVkKPtO9ZIKUuh8hnvOiBUYDnw/kerzgfgt/hvkKxoblXAvq729FgeEpk9CJzJUzuIAAklIq9oRoBir4G+cIXt6DG4MR6trNgyI+W1OUZ5gLQsQ2uKF75I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=M+EE+KSh; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4B6Lh0CF021619
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:30:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=R9M24a6ylRLzXnir6ciiUs6+m+tvkucIQYlBzr9gqaU=; b=M+EE+KShOfku
	JfkC7f/NloEFOPkHP7tJELbCox8qTlakVfbc278w65KOW30+ojsqvz6uT8v27G0J
	qq701yzAHnwvTFOUa3+BYJpmf2klPnDsd164LJTCyBlY04xXtusYMAJ76+VwVYjF
	vYO22fQ3Y0uVdbCDB9EQwPsRRvTrR8/CiZ+9Dw8ZnYkpRcs82jCfUHCCvX3rsRCa
	NoQr6TBxAlj3BigunL1FxA6y+gfgy5p+mCbyd8ig1KIR25qM7Tk1pkRvXLk8lWpm
	3GDfkEIzeA+crYIMgaSi3mzWma9LRvWjDSLJhiYKNavUJLPTW/Ld99rHocHKYGe2
	OF0uB11I9g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 43c7neh2ax-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:30:04 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:30:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 4113F15B8CB82; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 07/12] io_uring: enable per-io write streams
Date: Fri, 6 Dec 2024 14:17:56 -0800
Message-ID: <20241206221801.790690-8-kbusch@meta.com>
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
X-Proofpoint-GUID: raIqYqkFg9HKHacZ6EqRXqwWOQvDXZWG
X-Proofpoint-ORIG-GUID: raIqYqkFg9HKHacZ6EqRXqwWOQvDXZWG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Allow userspace to pass a per-I/O write stream in the SQE:

      __u8 write_stream;

The __u8 type matches the size the filesystems and block layer support.

Application can query the supported values from the statx
max_write_streams field. Unsupported values are ignored by file
operations that do not support write streams or rejected with an error
by those that support them.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/io_uring.c           | 2 ++
 io_uring/rw.c                 | 1 +
 3 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 38f0d6b10eaf7..986a480e3b9c2 100644
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
index a8cbe674e5d63..978d0617d7af8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3868,6 +3868,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u8,   write_stream);
+	BUILD_BUG_SQE_ELEM(45, __u8,   __pad4[0]);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 04e4467ab0ee8..b8aa2dfcbf48c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -322,6 +322,7 @@ static int io_prep_rw(struct io_kiocb *req, const str=
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


