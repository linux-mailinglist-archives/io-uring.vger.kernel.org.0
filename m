Return-Path: <io-uring+bounces-6801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD02A46922
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8392D7A8B13
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C6E235BFB;
	Wed, 26 Feb 2025 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fzubWNqH"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AA6236420
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593424; cv=none; b=Y15IML/CQM2kZgV05NxSOyX4TrMtafz6nSfkdoYimRaaXW2v5bjN3OSBSLbDmgN98FaAOmURNDYj7UbdLZ86HQ2UiZgQEL5lDRWqRgzVj2UmGSARmyMXhuxF5DWdBucbegaowWxScqfLM2q/HFvNyeQuSFR0fxeG5RLOt112xY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593424; c=relaxed/simple;
	bh=dTwn1OBTOCnfmKkMGRk3k1UBYGieZ5Xe61oqEFDuBks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zg//C2Sq/CKRE1pURs9ggECn1yIMtEZFy3SkKd9G31moK1aW9RQ3emz7U5WVYXEV6sfS7ufjiQ0ptFJBfQ7LCZIkeDsFGV/p5b7+FjaaRgHVu4EtetOHaybnUQ+DfG2sZB6dPHCSkecRES+gQoGL6nVc62tbIRNZZH0KPbLCXSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fzubWNqH; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QBHDHr021853
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=nwmAP8sUV6CYBzcCZL2YWO0LfzfSw2Y16cunh72RRkE=; b=fzubWNqH/j45
	tn6PWkXaVTYAzhdt1hpST0yWexLCxC7tAGKnY9xs7LrSRsXGB7VfKGT5wjuT7EoF
	bq4CzrtB+aLt+P7PCZBxtC7SyKPtSi846stkk4ooD1XSddPhkBsY6wFC28VtPvsu
	2sAwxOteNPxhmac90igySbE6oc7fooPaluFzpo/Zb4RRlBdDY88DUNecAl6V+vZh
	SyxIGv3pre6crQUBuo8u3R5kHx56mjcb4TL/NxPio/agHFup/MxsUolw5PDQRntQ
	HJLzZz14RmQ+YItwx/2yZMmJZobE50iZuo1Un4nRPQwaruzciPp6ub67q+AkqEn5
	znENuAX8nA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4521xrjngk-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:21 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:10:04 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id D9661187C4ADF; Wed, 26 Feb 2025 10:10:06 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 3/5] ublk: zc register/unregister bvec
Date: Wed, 26 Feb 2025 10:09:57 -0800
Message-ID: <20250226181002.2574148-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250226181002.2574148-1-kbusch@meta.com>
References: <20250226181002.2574148-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DRTR9SQesduYUjqjbjaktnQ7ZQQg74qF
X-Proofpoint-ORIG-GUID: DRTR9SQesduYUjqjbjaktnQ7ZQQg74qF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide new operations for the user to request mapping an active request
to an io uring instance's buf_table. The user has to provide the index
it wants to install the buffer.

A reference count is taken on the request to ensure it can't be
completed while it is active in a ring's buf_table.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/block/ublk_drv.c      | 119 +++++++++++++++++++++++-----------
 include/uapi/linux/ublk_cmd.h |   4 ++
 2 files changed, 86 insertions(+), 37 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 529085181f355..dc9ff869aa560 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -51,6 +51,9 @@
 /* private ioctl command mirror */
 #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
=20
+#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
+#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)
+
 /* All UBLK_F_* have to be included into UBLK_F_ALL */
 #define UBLK_F_ALL (UBLK_F_SUPPORT_ZERO_COPY \
 		| UBLK_F_URING_CMD_COMP_IN_TASK \
@@ -201,7 +204,7 @@ static inline struct ublksrv_io_desc *ublk_get_iod(st=
ruct ublk_queue *ubq,
 						   int tag);
 static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
 {
-	return ub->dev_info.flags & UBLK_F_USER_COPY;
+	return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COP=
Y);
 }
=20
 static inline bool ublk_dev_is_zoned(const struct ublk_device *ub)
@@ -581,7 +584,7 @@ static void ublk_apply_params(struct ublk_device *ub)
=20
 static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
 {
-	return ubq->flags & UBLK_F_USER_COPY;
+	return ubq->flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
 }
=20
 static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
@@ -1747,6 +1750,77 @@ static inline void ublk_prep_cancel(struct io_urin=
g_cmd *cmd,
 	io_uring_cmd_mark_cancelable(cmd, issue_flags);
 }
=20
+static inline struct request *__ublk_check_and_get_req(struct ublk_devic=
e *ub,
+		struct ublk_queue *ubq, int tag, size_t offset)
+{
+	struct request *req;
+
+	if (!ublk_need_req_ref(ubq))
+		return NULL;
+
+	req =3D blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
+	if (!req)
+		return NULL;
+
+	if (!ublk_get_req_ref(ubq, req))
+		return NULL;
+
+	if (unlikely(!blk_mq_request_started(req) || req->tag !=3D tag))
+		goto fail_put;
+
+	if (!ublk_rq_has_data(req))
+		goto fail_put;
+
+	if (offset > blk_rq_bytes(req))
+		goto fail_put;
+
+	return req;
+fail_put:
+	ublk_put_req_ref(ubq, req);
+	return NULL;
+}
+
+static void ublk_io_release(void *priv)
+{
+	struct request *rq =3D priv;
+	struct ublk_queue *ubq =3D rq->mq_hctx->driver_data;
+
+	ublk_put_req_ref(ubq, rq);
+}
+
+static int ublk_register_io_buf(struct io_uring_cmd *cmd,
+				struct ublk_queue *ubq, unsigned int tag,
+				const struct ublksrv_io_cmd *ub_cmd,
+				unsigned int issue_flags)
+{
+	struct ublk_device *ub =3D cmd->file->private_data;
+	int index =3D (int)ub_cmd->addr, ret;
+	struct request *req;
+
+	req =3D __ublk_check_and_get_req(ub, ubq, tag, 0);
+	if (!req)
+		return -EINVAL;
+
+	ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
+				      issue_flags);
+	if (ret) {
+		ublk_put_req_ref(ubq, req);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
+				  const struct ublksrv_io_cmd *ub_cmd,
+				  unsigned int issue_flags)
+{
+	int index =3D (int)ub_cmd->addr;
+
+	io_buffer_unregister_bvec(cmd, index, issue_flags);
+	return 0;
+}
+
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags,
 			       const struct ublksrv_io_cmd *ub_cmd)
@@ -1798,6 +1872,10 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
 *cmd,
=20
 	ret =3D -EINVAL;
 	switch (_IOC_NR(cmd_op)) {
+	case UBLK_IO_REGISTER_IO_BUF:
+		return ublk_register_io_buf(cmd, ubq, tag, ub_cmd, issue_flags);
+	case UBLK_IO_UNREGISTER_IO_BUF:
+		return ublk_unregister_io_buf(cmd, ub_cmd, issue_flags);
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
 		if (ublk_queue_ready(ubq)) {
@@ -1872,36 +1950,6 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd=
 *cmd,
 	return -EIOCBQUEUED;
 }
=20
-static inline struct request *__ublk_check_and_get_req(struct ublk_devic=
e *ub,
-		struct ublk_queue *ubq, int tag, size_t offset)
-{
-	struct request *req;
-
-	if (!ublk_need_req_ref(ubq))
-		return NULL;
-
-	req =3D blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
-	if (!req)
-		return NULL;
-
-	if (!ublk_get_req_ref(ubq, req))
-		return NULL;
-
-	if (unlikely(!blk_mq_request_started(req) || req->tag !=3D tag))
-		goto fail_put;
-
-	if (!ublk_rq_has_data(req))
-		goto fail_put;
-
-	if (offset > blk_rq_bytes(req))
-		goto fail_put;
-
-	return req;
-fail_put:
-	ublk_put_req_ref(ubq, req);
-	return NULL;
-}
-
 static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
@@ -2459,7 +2507,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *c=
md)
 		 * buffer by pwrite() to ublk char device, which can't be
 		 * used for unprivileged device
 		 */
-		if (info.flags & UBLK_F_USER_COPY)
+		if (info.flags & UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)
 			return -EINVAL;
 	}
=20
@@ -2527,9 +2575,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *c=
md)
 		goto out_free_dev_number;
 	}
=20
-	/* We are not ready to support zero copy */
-	ub->dev_info.flags &=3D ~UBLK_F_SUPPORT_ZERO_COPY;
-
 	ub->dev_info.nr_hw_queues =3D min_t(unsigned int,
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
 	ublk_align_max_io_size(ub);
@@ -2860,7 +2905,7 @@ static int ublk_ctrl_get_features(struct io_uring_c=
md *cmd)
 {
 	const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp =3D (void __user *)(unsigned long)header->addr;
-	u64 features =3D UBLK_F_ALL & ~UBLK_F_SUPPORT_ZERO_COPY;
+	u64 features =3D UBLK_F_ALL;
=20
 	if (header->len !=3D UBLK_FEATURES_LEN || !header->addr)
 		return -EINVAL;
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.=
h
index a8bc98bb69fce..74246c926b55f 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -94,6 +94,10 @@
 	_IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
 #define	UBLK_U_IO_NEED_GET_DATA		\
 	_IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
+#define	UBLK_U_IO_REGISTER_IO_BUF	\
+	_IOWR('u', 0x23, struct ublksrv_io_cmd)
+#define	UBLK_U_IO_UNREGISTER_IO_BUF	\
+	_IOWR('u', 0x24, struct ublksrv_io_cmd)
=20
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
--=20
2.43.5


