Return-Path: <io-uring+bounces-6713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC90A42F1C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A2D03AF8B6
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EAB1DF969;
	Mon, 24 Feb 2025 21:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Gs5by91E"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B43B784
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432693; cv=none; b=b0mNVwNq9dW+gzbFyDGSsAy03tEsQxt9aalO8txTskOJz/cbE4qWSUAOlRIVH6avL9vAhLtV7ibqftjikoEkvxjqHvJ+Di/5ACen8J+/l/eV7DtL9AQ7sPZRkWyUG6SEHL1kAaF6eX7oFqH6LxLvhPcF1myuhx7JyIard0SuEJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432693; c=relaxed/simple;
	bh=LW1kgTOAVjw7bfyBhK06dkc9l4d8chusojr5bZpVtv0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4+ya70YYBzc7A64oZDiccrWWbplE0nV5kCBoge4Wlx2IP67U+DXzEBqAf7VQn9jEfuJQ1SQK4OgW4e8e6F1M/JkSAdF556rV8MW5V7JOyoycNat3G+65oMT06QWPsGM97sHRbI8RQvYPURMApdeRgaD+2WtxzKX1NziIr/nFTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Gs5by91E; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OFDHRg023683
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=NMzl8MMdACNuLkhkecw/0spruZ4BE8hsOxbXOlcyQnI=; b=Gs5by91EjFyD
	63Hk5sALlN6ESCEtm1RmOScK9sc9DJmWadBD9nYhGNCV3DReKqRoxaDpaD5pT+ck
	5RnoEFu207Wqt6IKcheEUPybt0HLjn44xYcqjjUd0xCoVjPJDXQ4MEsS661+vTu2
	gJW9m8qhU7HmgaEg+uoOSZCDWCN0ulUz4NmjOfm3DgZEw3G4IMxB/lWTpSqtQNVD
	UXVmLrkOlgmWCN9v58e99Mmh/2xNrxZHs6PpX3hh6L1+epACNYHuib7DxOFewVoR
	TnnD6nszCRaS8dewNZo/ctmnTtqCJR+PaRVCKbtNQ/V9ZxSV6y1UBeRND0z3P0gv
	uPVl3jyRuQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450tdcufr4-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:30 -0800 (PST)
Received: from twshared29376.33.frc3.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:16 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 68D4F1868C4EE; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 04/11] io_uring/nvme: pass issue_flags to io_uring_cmd_import_fixed()
Date: Mon, 24 Feb 2025 13:31:09 -0800
Message-ID: <20250224213116.3509093-5-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
References: <20250224213116.3509093-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6iMiFRvuLgUKDt0Pa9XTOPGJrKKcvLUZ
X-Proofpoint-ORIG-GUID: 6iMiFRvuLgUKDt0Pa9XTOPGJrKKcvLUZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Pavel Begunkov <asml.silence@gmail.com>

io_uring_cmd_import_fixed() will need to know the io_uring execution
state in following commits, for now just pass issue_flags into it
without actually using.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c    | 10 ++++++----
 include/linux/io_uring/cmd.h |  6 ++++--
 io_uring/uring_cmd.c         |  3 ++-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index e8930146847af..e0876bc9aacde 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -114,7 +114,8 @@ static struct request *nvme_alloc_user_request(struct=
 request_queue *q,
=20
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		struct io_uring_cmd *ioucmd, unsigned int flags)
+		struct io_uring_cmd *ioucmd, unsigned int flags,
+		unsigned int iou_issue_flags)
 {
 	struct request_queue *q =3D req->q;
 	struct nvme_ns *ns =3D q->queuedata;
@@ -142,7 +143,8 @@ static int nvme_map_user_request(struct request *req,=
 u64 ubuffer,
 		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC))
 			return -EINVAL;
 		ret =3D io_uring_cmd_import_fixed(ubuffer, bufflen,
-				rq_data_dir(req), &iter, ioucmd);
+				rq_data_dir(req), &iter, ioucmd,
+				iou_issue_flags);
 		if (ret < 0)
 			goto out;
 		ret =3D blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
@@ -194,7 +196,7 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	req->timeout =3D timeout;
 	if (ubuffer && bufflen) {
 		ret =3D nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, NULL, flags);
+				meta_len, NULL, flags, 0);
 		if (ret)
 			return ret;
 	}
@@ -514,7 +516,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 	if (d.addr && d.data_len) {
 		ret =3D nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, ioucmd, vec);
+			d.metadata_len, ioucmd, vec, issue_flags);
 		if (ret)
 			return ret;
 	}
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index abd0c8bd950ba..87150dc0a07cf 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -39,7 +39,8 @@ static inline void io_uring_cmd_private_sz_check(size_t=
 cmd_sz)
=20
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-			      struct iov_iter *iter, void *ioucmd);
+			      struct iov_iter *iter, void *ioucmd,
+			      unsigned int issue_flags);
=20
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @io=
ucmd
@@ -67,7 +68,8 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *i=
oucmd);
=20
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,=
 int rw,
-			      struct iov_iter *iter, void *ioucmd)
+			      struct iov_iter *iter, void *ioucmd,
+			      unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 14086a2664611..28ed69c40756e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -257,7 +257,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
 }
=20
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-			      struct iov_iter *iter, void *ioucmd)
+			      struct iov_iter *iter, void *ioucmd,
+			      unsigned int issue_flags)
 {
 	struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
 	struct io_rsrc_node *node =3D req->buf_node;
--=20
2.43.5


