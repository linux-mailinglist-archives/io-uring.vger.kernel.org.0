Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FAE6DB405
	for <lists+io-uring@lfdr.de>; Fri,  7 Apr 2023 21:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDGTRa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 15:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDGTR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 15:17:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D815BB98
        for <io-uring@vger.kernel.org>; Fri,  7 Apr 2023 12:17:17 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337GhV1o030727
        for <io-uring@vger.kernel.org>; Fri, 7 Apr 2023 12:17:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=jnhpZENk/xcLV2g88wDxXsdXF0VZ73uIc8pUlWQlfgk=;
 b=FipN7gqaWccdnx0Ru8b6j0swgGQA6exOU3PegXSroFE5AIzPrh3BiteE1OneqUGGZs3R
 C0/LdfVHOJ6RAUUayQDWreJCdxULESHP4zAqdLPlj5WTfD2Kaj9NvAcj3i/lQ6pvoZIV
 o1IIQWpP3KpOpG57gF5F2E7pEScY0pDFYZfgowrDraG9zdMaVDU4jG76SI2XSOlZCDtl
 sxKXZjeKXFvq7TxcFmwW/DGgh4OlgHvnoMweMuUeSxBnbnJWF76X+k96O/Im/+Vxuf/H
 9/i0hLT+sp5C5EOY//GYLtn2yu0YnPLG6CvOiAFVc4uVnPq0ArTTZ+njm60ZitcdrVjS jw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pt7e6np55-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Apr 2023 12:17:17 -0700
Received: from twshared0333.05.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 7 Apr 2023 12:17:00 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 2FEA8157B5F85; Fri,  7 Apr 2023 12:16:47 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/5] nvme: unify nvme request end_io
Date:   Fri, 7 Apr 2023 12:16:34 -0700
Message-ID: <20230407191636.2631046-4-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407191636.2631046-1-kbusch@meta.com>
References: <20230407191636.2631046-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2W9GCQD4fmAAVO3leW4C6NUV8Ajc8FfE
X-Proofpoint-GUID: 2W9GCQD4fmAAVO3leW4C6NUV8Ajc8FfE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

We can finish the metadata copy inline with the completion. After that,
there's really nothing else different between the meta and non-meta data
end_io callbacks, so unify them.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c | 57 +++++++--------------------------------
 1 file changed, 9 insertions(+), 48 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 278c57ee0db91..a1e0a14dadedc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -465,29 +465,6 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_=
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
-	blk_mq_free_request(req);
-
-	io_uring_cmd_done(ioucmd, status, result, issue_flags);
-}
-
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
 			       unsigned issue_flags)
 {
@@ -502,11 +479,16 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(str=
uct request *req,
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
 	void *cookie =3D READ_ONCE(ioucmd->cookie);
+	int status =3D nvme_req(req)->status;
=20
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
-		pdu->nvme_status =3D -EINTR;
-	else
-		pdu->nvme_status =3D nvme_req(req)->status;
+		status =3D -EINTR;
+
+	if (pdu->meta_len)
+		status =3D nvme_finish_user_metadata(req, pdu->u.meta_buffer,
+					pdu->u.meta, pdu->meta_len, status);
+
+	pdu->nvme_status =3D status;
 	pdu->u.result =3D le64_to_cpu(nvme_req(req)->result.u64);
=20
 	/*
@@ -521,25 +503,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(stru=
ct request *req,
 	return RQ_END_IO_FREE;
 }
=20
-static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req=
,
-						     blk_status_t err)
-{
-	struct io_uring_cmd *ioucmd =3D req->end_io_data;
-	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-	void *cookie =3D READ_ONCE(ioucmd->cookie);
-
-	/*
-	 * For iopoll, complete it directly.
-	 * Otherwise, move the completion to task work.
-	 */
-	if (cookie !=3D NULL && blk_rq_is_poll(req))
-		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
-
-	return RQ_END_IO_NONE;
-}
-
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
@@ -620,12 +583,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl=
, struct nvme_ns *ns,
 	pdu->req =3D req;
 	pdu->meta_len =3D d.metadata_len;
 	req->end_io_data =3D ioucmd;
+	req->end_io =3D nvme_uring_cmd_end_io;
 	if (pdu->meta_len) {
 		pdu->u.meta =3D meta;
 		pdu->u.meta_buffer =3D nvme_to_user_ptr(d.metadata);
-		req->end_io =3D nvme_uring_cmd_end_io_meta;
-	} else {
-		req->end_io =3D nvme_uring_cmd_end_io;
 	}
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
--=20
2.34.1

