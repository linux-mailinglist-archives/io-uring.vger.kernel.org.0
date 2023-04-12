Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110566E01CD
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 00:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDLW1v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 18:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLW1u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 18:27:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A674228
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:27:49 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CI9mtv023707
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:27:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=ffEmIXc7sElmoOeTgE5XfXkaNGpTIANyn+gYOE9PmgI=;
 b=GHd5gpFLx3cYCPOTr2sWQsuey4/ks1Om6lCOMnA4Slegj1B0NTxMAEd4ObIxMgfjjsUU
 s2MipHHx8UgEQC9kJOB2jio16gI7nULegm4Xunux6IUy/4FcyRjlk73LpOKYT8+Pd3SF
 N43FXVraWks9goSsk6ahmoNpTidDt2xkDeaik+k7tLx2bteGgH0t3XVCLDh6LzU9JlNa
 CL2z1bOQn50OdXPI5TMBHyA/Xz5pO+s35PbcXeuBDAeUAmLK7HwcING1FnbRktmPFd+V
 E1aFgEh26DlVbXJ1i8DrkgZstGZXr/WcrpLI9pc5fOjtuEncIREvG1p56FZSFd39NlI7 2A== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pwrt4n00g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:27:48 -0700
Received: from twshared29562.14.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 12 Apr 2023 15:27:47 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id C591F8C27072; Wed, 12 Apr 2023 15:27:38 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH v2] io_uring: add support for multishot timeouts
Date:   Wed, 12 Apr 2023 15:27:32 -0700
Message-ID: <20230412222732.1623901-1-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: kycwGqbORAwM0gfT6Vc4hGQ2JTVHV3VO
X-Proofpoint-ORIG-GUID: kycwGqbORAwM0gfT6Vc4hGQ2JTVHV3VO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_12,2023-04-12_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A multishot timeout submission will repeatedly generate completions with
the IORING_CQE_F_MORE cflag set. Depending on the value of the `off' fiel=
d
in the submission, these timeouts can either repeat indefinitely until
cancelled (`off' =3D 0) or for a fixed number of times (`off' > 0).

Only noseq timeouts (i.e. not dependent on the number of I/O
completions) are supported.

An indefinite timer will be cancelled with EOVERFLOW if the CQ ever
overflows.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/timeout.c            | 59 +++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index f8d14d1c58d3..0716cb17e436 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -250,6 +250,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_REALTIME		(1U << 3)
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
+#define IORING_TIMEOUT_MULTISHOT	(1U << 6)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIME=
OUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_=
TIMEOUT_UPDATE)
 /*
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 5c6c6f720809..61b8488565ce 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -17,6 +17,7 @@ struct io_timeout {
 	struct file			*file;
 	u32				off;
 	u32				target_seq;
+	u32				repeats;
 	struct list_head		list;
 	/* head of the link, used by linked timeouts only */
 	struct io_kiocb			*head;
@@ -37,8 +38,9 @@ struct io_timeout_rem {
 static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 {
 	struct io_timeout *timeout =3D io_kiocb_to_cmd(req, struct io_timeout);
+	struct io_timeout_data *data =3D req->async_data;
=20
-	return !timeout->off;
+	return !timeout->off || data->flags & IORING_TIMEOUT_MULTISHOT;
 }
=20
 static inline void io_put_req(struct io_kiocb *req)
@@ -49,6 +51,45 @@ static inline void io_put_req(struct io_kiocb *req)
 	}
 }
=20
+static inline bool io_timeout_finish(struct io_timeout *timeout,
+				     struct io_timeout_data *data)
+{
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		return true;
+
+	if (!timeout->off || (timeout->repeats && --timeout->repeats))
+		return false;
+
+	return true;
+}
+
+static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer);
+
+static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state=
 *ts)
+{
+	struct io_timeout *timeout =3D io_kiocb_to_cmd(req, struct io_timeout);
+	struct io_timeout_data *data =3D req->async_data;
+	struct io_ring_ctx *ctx =3D req->ctx;
+
+	if (!io_timeout_finish(timeout, data)) {
+		bool filled;
+		filled =3D io_aux_cqe(ctx, false, req->cqe.user_data, -ETIME,
+				      IORING_CQE_F_MORE, false);
+		if (filled) {
+			/* re-arm timer */
+			spin_lock_irq(&ctx->timeout_lock);
+			list_add(&timeout->list, ctx->timeout_list.prev);
+			data->timer.function =3D io_timeout_fn;
+			hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode=
);
+			spin_unlock_irq(&ctx->timeout_lock);
+			return;
+		}
+		io_req_set_res(req, -EOVERFLOW, 0);
+	}
+
+	io_req_task_complete(req, ts);
+}
+
 static bool io_kill_timeout(struct io_kiocb *req, int status)
 	__must_hold(&req->ctx->timeout_lock)
 {
@@ -212,7 +253,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrti=
mer *timer)
 		req_set_fail(req);
=20
 	io_req_set_res(req, -ETIME, 0);
-	req->io_task_work.func =3D io_req_task_complete;
+	req->io_task_work.func =3D io_timeout_complete;
 	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
@@ -470,16 +511,28 @@ static int __io_timeout_prep(struct io_kiocb *req,
 		return -EINVAL;
 	flags =3D READ_ONCE(sqe->timeout_flags);
 	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
-		      IORING_TIMEOUT_ETIME_SUCCESS))
+		      IORING_TIMEOUT_ETIME_SUCCESS |
+		      IORING_TIMEOUT_MULTISHOT)) {
 		return -EINVAL;
+	}
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
 		return -EINVAL;
+	/* multishot requests only make sense with rel values */
+	if (!(~flags & (IORING_TIMEOUT_MULTISHOT | IORING_TIMEOUT_ABS)))
+		return -EINVAL;
=20
 	INIT_LIST_HEAD(&timeout->list);
 	timeout->off =3D off;
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used =3D true;
+	/*
+	 * for multishot reqs w/ fixed nr of repeats, target_seq tracks the
+	 * remaining nr
+	 */
+	timeout->repeats =3D 0;
+	if ((flags & IORING_TIMEOUT_MULTISHOT) && off > 0)
+		timeout->repeats =3D off;
=20
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
--=20
2.34.1

