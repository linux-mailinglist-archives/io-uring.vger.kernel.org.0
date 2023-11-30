Return-Path: <io-uring+bounces-181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC7C7FFE02
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 22:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4E4B281754
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 21:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C734A998;
	Thu, 30 Nov 2023 21:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="a7OkFp5r"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F59E10DC
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:21 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AULK8Ff028718
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=D8cR7pIBLts6CZuwL4HPtzl3bRNq46X/OdD7NBfGzuQ=;
 b=a7OkFp5rTNqnycKL2HMjNd0Eaf1MOs4iEq+bBxBvDQi+aowFXosWjyy+JmGmnr77i3H0
 oni97y4wDGsoUgpe3apEv/mXWbdLp4LXlksOGxkwZFQqmsAEgu3WzqYqHn5Jfr+4Qvym
 Ygt+8Hy8Zo1Ixp1mD07I9lNy4DO3uGa8hK0qGEw7ALm3zWG6wR3KLYVWplPPfZcCniAa
 fGXatxPifU4PSp0PBHx2ewQ2CmCDbQV5m5VkEmyjZ9FASoR5+QOwUyeOXvLOU8guCwor
 2y01FH+w97lQY8Q04Gvl4339Hm3KTBdb+BLBXQC+dq6vO2thmN8XiU4xETt8L+8tkTPW /A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uphtvxqhd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:19 -0800
Received: from twshared13322.02.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 13:53:15 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 5F9BB226BF686; Thu, 30 Nov 2023 13:53:10 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 2/4] nvme: use bio_integrity_map_user
Date: Thu, 30 Nov 2023 13:53:07 -0800
Message-ID: <20231130215309.2923568-3-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130215309.2923568-1-kbusch@meta.com>
References: <20231130215309.2923568-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sW1kYIy_j8Vbaf8CfUMi1fN693ffOU2D
X-Proofpoint-GUID: sW1kYIy_j8Vbaf8CfUMi1fN693ffOU2D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-30_22,2023-11-30_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Map user metadata buffers directly. Now that the bio tracks the
metadata, nvme doesn't need special metadata handling and tracking with
callbacks and additional fields in the pdu.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c | 197 ++++++--------------------------------
 1 file changed, 29 insertions(+), 168 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 529b9954d2b8c..32c9bcf491a33 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -96,58 +96,6 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
=20
-static void *nvme_add_user_metadata(struct request *req, void __user *ub=
uf,
-		unsigned len, u32 seed)
-{
-	struct bio_integrity_payload *bip;
-	int ret =3D -ENOMEM;
-	void *buf;
-	struct bio *bio =3D req->bio;
-
-	buf =3D kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		goto out;
-
-	if (req_op(req) =3D=3D REQ_OP_DRV_OUT) {
-		ret =3D -EFAULT;
-		if (copy_from_user(buf, ubuf, len))
-			goto out_free_meta;
-	} else {
-		memset(buf, 0, len);
-	}
-
-	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, 1);
-	if (IS_ERR(bip)) {
-		ret =3D PTR_ERR(bip);
-		goto out_free_meta;
-	}
-
-	bip->bip_iter.bi_sector =3D seed;
-	ret =3D bio_integrity_add_page(bio, virt_to_page(buf), len,
-			offset_in_page(buf));
-	if (ret !=3D len) {
-		ret =3D -ENOMEM;
-		goto out_free_meta;
-	}
-
-	req->cmd_flags |=3D REQ_INTEGRITY;
-	return buf;
-out_free_meta:
-	kfree(buf);
-out:
-	return ERR_PTR(ret);
-}
-
-static int nvme_finish_user_metadata(struct request *req, void __user *u=
buf,
-		void *meta, unsigned len, int ret)
-{
-	if (!ret && req_op(req) =3D=3D REQ_OP_DRV_IN &&
-	    copy_to_user(ubuf, meta, len))
-		ret =3D -EFAULT;
-	kfree(meta);
-	return ret;
-}
-
 static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, blk_opf_t rq_flags,
 		blk_mq_req_flags_t blk_flags)
@@ -164,14 +112,12 @@ static struct request *nvme_alloc_user_request(stru=
ct request_queue *q,
=20
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
-		unsigned int flags)
+		u32 meta_seed, struct io_uring_cmd *ioucmd, unsigned int flags)
 {
 	struct request_queue *q =3D req->q;
 	struct nvme_ns *ns =3D q->queuedata;
 	struct block_device *bdev =3D ns ? ns->disk->part0 : NULL;
 	struct bio *bio =3D NULL;
-	void *meta =3D NULL;
 	int ret;
=20
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
@@ -193,18 +139,17 @@ static int nvme_map_user_request(struct request *re=
q, u64 ubuffer,
=20
 	if (ret)
 		goto out;
+
 	bio =3D req->bio;
-	if (bdev)
+	if (bdev) {
 		bio_set_dev(bio, bdev);
-
-	if (bdev && meta_buffer && meta_len) {
-		meta =3D nvme_add_user_metadata(req, meta_buffer, meta_len,
-				meta_seed);
-		if (IS_ERR(meta)) {
-			ret =3D PTR_ERR(meta);
-			goto out_unmap;
+		if (meta_buffer && meta_len) {
+			ret =3D bio_integrity_map_user(bio, meta_buffer, meta_len,
+						     meta_seed);
+			if (ret)
+				goto out_unmap;
+			req->cmd_flags |=3D REQ_INTEGRITY;
 		}
-		*metap =3D meta;
 	}
=20
 	return ret;
@@ -225,7 +170,6 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	struct nvme_ns *ns =3D q->queuedata;
 	struct nvme_ctrl *ctrl;
 	struct request *req;
-	void *meta =3D NULL;
 	struct bio *bio;
 	u32 effects;
 	int ret;
@@ -237,7 +181,7 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	req->timeout =3D timeout;
 	if (ubuffer && bufflen) {
 		ret =3D nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, NULL, flags);
+				meta_len, meta_seed, NULL, flags);
 		if (ret)
 			return ret;
 	}
@@ -249,9 +193,6 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	ret =3D nvme_execute_rq(req, false);
 	if (result)
 		*result =3D le64_to_cpu(nvme_req(req)->result.u64);
-	if (meta)
-		ret =3D nvme_finish_user_metadata(req, meta_buffer, meta,
-						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);
@@ -446,19 +387,10 @@ struct nvme_uring_data {
  * Expect build errors if this grows larger than that.
  */
 struct nvme_uring_cmd_pdu {
-	union {
-		struct bio *bio;
-		struct request *req;
-	};
-	u32 meta_len;
-	u32 nvme_status;
-	union {
-		struct {
-			void *meta; /* kernel-resident buffer */
-			void __user *meta_buffer;
-		};
-		u64 result;
-	} u;
+	struct request *req;
+	struct bio *bio;
+	u64 result;
+	int status;
 };
=20
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
@@ -467,31 +399,6 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_=
cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
=20
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd,
-				    unsigned issue_flags)
-{
-	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-	struct request *req =3D pdu->req;
-	int status;
-	u64 result;
-
-	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
-		status =3D -EINTR;
-	else
-		status =3D nvme_req(req)->status;
-
-	result =3D le64_to_cpu(nvme_req(req)->result.u64);
-
-	if (pdu->meta_len)
-		status =3D nvme_finish_user_metadata(req, pdu->u.meta_buffer,
-					pdu->u.meta, pdu->meta_len, status);
-	if (req->bio)
-		blk_rq_unmap_user(req->bio);
-	blk_mq_free_request(req);
-
-	io_uring_cmd_done(ioucmd, status, result, issue_flags);
-}
-
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
 			       unsigned issue_flags)
 {
@@ -499,8 +406,7 @@ static void nvme_uring_task_cb(struct io_uring_cmd *i=
oucmd,
=20
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-
-	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, issue_flags)=
;
+	io_uring_cmd_done(ioucmd, pdu->status, pdu->result, issue_flags);
 }
=20
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -509,53 +415,24 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(str=
uct request *req,
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
=20
-	req->bio =3D pdu->bio;
-	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
-		pdu->nvme_status =3D -EINTR;
-	} else {
-		pdu->nvme_status =3D nvme_req(req)->status;
-		if (!pdu->nvme_status)
-			pdu->nvme_status =3D blk_status_to_errno(err);
-	}
-	pdu->u.result =3D le64_to_cpu(nvme_req(req)->result.u64);
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		pdu->status =3D -EINTR;
+	else
+		pdu->status =3D nvme_req(req)->status;
+	pdu->result =3D le64_to_cpu(nvme_req(req)->result.u64);
=20
 	/*
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (blk_rq_is_poll(req)) {
-		WRITE_ONCE(ioucmd->cookie, NULL);
+	if (blk_rq_is_poll(req))
 		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	} else {
+	else
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
-	}
=20
 	return RQ_END_IO_FREE;
 }
=20
-static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req=
,
-						     blk_status_t err)
-{
-	struct io_uring_cmd *ioucmd =3D req->end_io_data;
-	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-
-	req->bio =3D pdu->bio;
-	pdu->req =3D req;
-
-	/*
-	 * For iopoll, complete it directly.
-	 * Otherwise, move the completion to task work.
-	 */
-	if (blk_rq_is_poll(req)) {
-		WRITE_ONCE(ioucmd->cookie, NULL);
-		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
-	} else {
-		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_meta_cb);
-	}
-
-	return RQ_END_IO_NONE;
-}
-
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
@@ -567,7 +444,6 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 	struct request *req;
 	blk_opf_t rq_flags =3D REQ_ALLOC_CACHE;
 	blk_mq_req_flags_t blk_flags =3D 0;
-	void *meta =3D NULL;
 	int ret;
=20
 	c.common.opcode =3D READ_ONCE(cmd->opcode);
@@ -615,27 +491,16 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl=
, struct nvme_ns *ns,
 	if (d.addr && d.data_len) {
 		ret =3D nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, ioucmd, vec);
+			d.metadata_len, 0, ioucmd, vec);
 		if (ret)
 			return ret;
 	}
=20
-	if (blk_rq_is_poll(req)) {
-		ioucmd->flags |=3D IORING_URING_CMD_POLLED;
-		WRITE_ONCE(ioucmd->cookie, req);
-	}
-
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio =3D req->bio;
-	pdu->meta_len =3D d.metadata_len;
+	pdu->req =3D req;
 	req->end_io_data =3D ioucmd;
-	if (pdu->meta_len) {
-		pdu->u.meta =3D meta;
-		pdu->u.meta_buffer =3D nvme_to_user_ptr(d.metadata);
-		req->end_io =3D nvme_uring_cmd_end_io_meta;
-	} else {
-		req->end_io =3D nvme_uring_cmd_end_io;
-	}
+	req->end_io =3D nvme_uring_cmd_end_io;
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 }
@@ -786,16 +651,12 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cm=
d *ioucmd,
 				 struct io_comp_batch *iob,
 				 unsigned int poll_flags)
 {
-	struct request *req;
-	int ret =3D 0;
-
-	if (!(ioucmd->flags & IORING_URING_CMD_POLLED))
-		return 0;
+	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
+	struct request *req =3D pdu->req;
=20
-	req =3D READ_ONCE(ioucmd->cookie);
 	if (req && blk_rq_is_poll(req))
-		ret =3D blk_rq_poll(req, iob, poll_flags);
-	return ret;
+		return blk_rq_poll(req, iob, poll_flags);
+	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
--=20
2.34.1


