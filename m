Return-Path: <io-uring+bounces-4102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B45649B4DAA
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DB21C216A5
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E072D193074;
	Tue, 29 Oct 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hcLQSWnO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7C192B73
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215358; cv=none; b=NoiaiFPcosthNr/yctE8izhYX6xIYQwQed12Y2DkKtePYnHn2Tg9x1wUiGvN0WWMiYQ+98KL1t+shhQ/7Nricpf7oSd8YqHaBdDqXLiYLdcAnQ1/vlQR7qiPKEFOYC43n6hx5GaN2Fb6/2aEklQitlp6W7hJnyhS0CCaBuxvqv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215358; c=relaxed/simple;
	bh=GatvhlV7oUxm3X13UhOaSbBplvyWZ8hbwVUR2itl5VY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlfQEF+MxEhlIp8G/WGNNoeXRm5ECmAPygORXSAEfJe6fhMQ5neTc4xT3McobtOKxTzbFBtvWdLaNPzGwRZIETPDp6aG6MLgP+sj9igbXp5Wz27kLDgr75Hh6CzWyXetDPAK+5CRKmXSuGnajSQcxwTlbKnDrUHGMccKBrFH234=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=hcLQSWnO; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49TD7E7O021389
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:22:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=XTdC5rR2uiEoWSlqFgEly23JIAf0RJlPvmvSok+NdlE=; b=hcLQSWnOVHOI
	0qRKrNYi6oeZ0MEUslUgWB/VQcN7Dfo9RWgtsJbJLgVh4p1+J7FfzmXzyKZdKbFc
	jB3FjoYh5QJ3L5wwr2hY+ScSm1Xl9xqvltzrPvHSUoil8dByH6YrFzXLlSBSRz2M
	SchBlvcsTKzBC7BadT/zqK793ECEr+4emLrPQxLb7Jtv07LBgoNo/wLHHSWFMW60
	bA5keRS4PSyg6jK4GI/kINLciLVpnNaWz2A/PZ0FPi+ZVXh+g9OuRSwffYGNNkWo
	vxrrDzfP5HWlq3UNkY27aFy3Itsf+ObcRtbPy+DI5dX4zYMZLT+rXp+YdMAJBOp5
	rENyqe23aw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 42k0af14pv-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:22:35 -0700 (PDT)
Received: from twshared10900.35.frc1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 29 Oct 2024 15:22:12 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 24BAC14920EA8; Tue, 29 Oct 2024 08:19:44 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <hch@lst.de>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, <bvanassche@acm.org>,
        Nitesh Shetty
	<nj.shetty@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv10 6/9] io_uring: enable per-io hinting capability
Date: Tue, 29 Oct 2024 08:19:19 -0700
Message-ID: <20241029151922.459139-7-kbusch@meta.com>
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
X-Proofpoint-GUID: zE5rhtJ_Q0lwxibYu5ImHIswcKUfn67k
X-Proofpoint-ORIG-GUID: zE5rhtJ_Q0lwxibYu5ImHIswcKUfn67k
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
 io_uring/rw.c                 | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 0247452837830..6e1985d3b306c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,10 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			__u16	write_hint;
+			__u16	__pad4[1];
+		};
 	};
 	union {
 		struct {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4514644fdf52e..65b8e29b67ec7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,7 +3875,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  write_hint);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad4[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7ce1cbc048faf..b5dea58356d93 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -279,7 +279,8 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio =3D get_current_ioprio();
 	}
 	rw->kiocb.dio_complete =3D NULL;
-
+	if (ddir =3D=3D ITER_SOURCE)
+		rw->kiocb.ki_write_hint =3D READ_ONCE(sqe->write_hint);
 	rw->addr =3D READ_ONCE(sqe->addr);
 	rw->len =3D READ_ONCE(sqe->len);
 	rw->flags =3D READ_ONCE(sqe->rw_flags);
--=20
2.43.5


