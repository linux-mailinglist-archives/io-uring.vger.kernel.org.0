Return-Path: <io-uring+bounces-9854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6AFB8B195
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 21:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDFC1565B97
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 19:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBAF217F3D;
	Fri, 19 Sep 2025 19:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="A3Q61V+s"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296E11E5B63
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758310747; cv=none; b=Xjp3MFxuyQlgO7b6boI1xw/H4ya7ojUQ0y/OWxqiKU4s+Kt6Y9cGObb8hJsIp7bL5lJfjrRF3x+UFwnTEW99e3vRJsQH7QNmy6t7r7gWKRpU9Cl2nnQ5ZDwu4gQbNmysSkyaFpMEfGBs2cQY9V8gkxyzhBgPEyb4FjXjkZIjuvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758310747; c=relaxed/simple;
	bh=eyvLtKTL/t+/j40g2zLKI91xFb4FABRbFCR4IgVm32o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=frZq4UkLgpgPNKhuQVfKa7BpchyPwiV7y0NjX/NwZEGWcgJdy4+KUQJ4jYIGwTpLfvYOMadJ5SS0I0FwIejXuL3dKSiwysakRpjQ0QrVCcU+dvwysMfxUT4ujuZUSGCLHHnM6pT0catO1lfqYzTZQsTAdZm1r2VC4FdywjHpqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=A3Q61V+s; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58JIOIWe3628128
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 12:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=ooGbL3N6dz82M4OGs3
	PehkRaQpuimNWh5nUqkGX7vjw=; b=A3Q61V+sduwSig0e5nOrKy1rDfw/gLXD7Y
	pU0rFb8UXTcbw4mFBKGXbsCreFWNpcYIWONqoPA7zBuOK7mCL30G9hpN5E/RhdFY
	HHFihTpOYlzNnl9m30kDgQv8kLHvBQy/sFqQ7PSLO2Bb4F5eEPZE0JiL603AvTgV
	mdMFbGbXXWDdmGUrDQkYPgv8kpqrpuPAv4skKKRGZJU6PQn2uv0oStQgrZ5+r+dB
	LpfRBvjAqMiesSkksPh28xO33I1g73Vjvqjo1D4zwz+yQ0Xq6s44OqkbD9MqjsMO
	yxahkqCjbnKbYe6hKFWeHswXo3uSyveW4iN3kH1Vbj2GudFJZTEg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 499ce1rj89-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 12:39:05 -0700 (PDT)
Received: from twshared52133.15.frc2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 19 Sep 2025 19:39:03 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id E784F1DCEB6F; Fri, 19 Sep 2025 12:38:58 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH] io_uring: fix nvme's 32b cqes on mixed cq
Date: Fri, 19 Sep 2025 12:38:58 -0700
Message-ID: <20250919193858.1542767-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDE4MiBTYWx0ZWRfX7lBteDvv4Evo
 ILJ2AdgBqDYLt7vzALpdbMXpLS+uCZP+39kWA21OK7CI6iQx8y1dkaRP+UB/bV1flE5LtWmXX1O
 SDigDt8TDc7jV/+vjvcDUG3I+ipH1qOnJiaterwqHhL9NyG/kKNNNgAg4i9dNVUQUgEur3n2aru
 LLexp4B1Uy+bVLDraVevZ/jm6mWX2ztEqlj4tJSAevBZRvfUaXRvVps6/xYZhSVDCGqIoCwXBcO
 kHXtsLqQv6ceUtKK9KQN+3DY5h/UuvAvDQ6FX8nDr32RSUm99nor5cgPS9ZFUPH3pjj8Wzi26ve
 MlY36sl4HNRitD/469xT6W5qnWUdHeACaqOS8NOuPUAMJTN+U7qyDR4ZsGeC2M=
X-Proofpoint-ORIG-GUID: bEv7wg36RZ1q0WPsI8k8tjxYtONAzPlE
X-Authority-Analysis: v=2.4 cv=YOGfyQGx c=1 sm=1 tr=0 ts=68cdb159 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=PIsfVjHBvBJFoMHPKsMA:9
X-Proofpoint-GUID: bEv7wg36RZ1q0WPsI8k8tjxYtONAzPlE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_02,2025-09-19_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The nvme uring_cmd only uses 32b CQEs. If the ring uses a mixed CQ, then
we need to make sure we flag the completion as a 32b CQE.

On the other hand, if nvme uring_cmd was using a dedicated 32b CQE, the
posting was missing the extra memcpy because it only applied to bit CQEs
on a mixed CQ.

Fixes: e26dca67fde1943 ("io_uring: add support for IORING_SETUP_CQE_MIXED=
")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
Testing this is actually a bit difficult. The nvme uring command only
accepts IO commands, and none of the usual nvme IO commands return
anything in the big cqe extra fields. So had to pre-fill the CQ with
bogus data and see if it was being overwritten as expected.

 drivers/nvme/host/ioctl.c    |  2 +-
 include/linux/io_uring/cmd.h | 20 ++++++++++++++++----
 io_uring/io_uring.h          |  2 +-
 io_uring/uring_cmd.c         | 11 +++++++----
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index f778f3b5214bd..c212fa952c0f4 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -405,7 +405,7 @@ static void nvme_uring_task_cb(struct io_uring_cmd *i=
oucmd,
=20
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-	io_uring_cmd_done(ioucmd, pdu->status, pdu->result, issue_flags);
+	io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, issue_flags);
 }
=20
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index c8185f54fde9d..02d50f08f668e 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -56,8 +56,8 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *=
ioucmd,
  * Note: the caller should never hard code @issue_flags and is only allo=
wed
  * to pass the mask provided by the core io_uring code.
  */
-void io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
-			unsigned issue_flags);
+void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
+			 unsigned issue_flags, bool is_cqe32);
=20
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    io_uring_cmd_tw_t task_work_cb,
@@ -104,8 +104,8 @@ static inline int io_uring_cmd_import_fixed_vec(struc=
t io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
-static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
-		u64 ret2, unsigned issue_flags)
+static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret=
,
+		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd=
,
@@ -159,6 +159,18 @@ static inline void *io_uring_cmd_ctx_handle(struct i=
o_uring_cmd *cmd)
 	return cmd_to_io_kiocb(cmd)->ctx;
 }
=20
+static inline void io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 re=
t,
+				     u64 res2, unsigned issue_flags)
+{
+	return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, false);
+}
+
+static inline void io_uring_cmd_done32(struct io_uring_cmd *ioucmd, s32 =
ret,
+				       u64 res2, unsigned issue_flags)
+{
+	return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, true);
+}
+
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a60ff7fc13b2f..45365abb51ec7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -276,7 +276,7 @@ static __always_inline bool io_fill_cqe_req(struct io=
_ring_ctx *ctx,
 		return false;
=20
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
-	if (is_cqe32) {
+	if (ctx->flags & IORING_SETUP_CQE32 || is_cqe32) {
 		memcpy(cqe->big_cqe, &req->big_cqe, sizeof(*cqe));
 		memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 	}
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0b05d5769eebb..074a6ff2b09f9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -151,8 +151,8 @@ static inline void io_req_set_cqe32_extra(struct io_k=
iocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
-		       unsigned issue_flags)
+void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
+		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
=20
@@ -165,8 +165,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, =
s32 ret, u64 res2,
 		req_set_fail(req);
=20
 	io_req_set_res(req, ret, 0);
-	if (req->ctx->flags & IORING_SETUP_CQE32)
+	if (is_cqe32) {
+		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
+			req->cqe.flags |=3D IORING_CQE_F_32;
 		io_req_set_cqe32_extra(req, res2, 0);
+	}
 	io_req_uring_cleanup(req, issue_flags);
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
@@ -180,7 +183,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, s=
32 ret, u64 res2,
 		io_req_task_work_add(req);
 	}
 }
-EXPORT_SYMBOL_GPL(io_uring_cmd_done);
+EXPORT_SYMBOL_GPL(__io_uring_cmd_done);
=20
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
 {
--=20
2.47.3


