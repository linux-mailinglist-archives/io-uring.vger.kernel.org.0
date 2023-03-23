Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F596C73E7
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 00:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCWXKr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 19:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWXKr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 19:10:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F7EFF29
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:10:44 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLZ9hi029835
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:10:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=Kqco6iLIHaEkvzLsuwyRM/naecBssWKytsxFPrxzv3c=;
 b=U/Jmx6SGVgcKf18HVlvmDcJrn/xjHPpKgh8PAjTxdTnnLdtInm66fYRzZaTl6xiiG3uw
 HziLIfP++Qkru31ZhroxNnbVeqTXK1zlkxxFBbJUUSqe1w+LwFWIic6siSiXxNuw5v0H
 j/99aG8ffAb0mSXgZ/jfo/knpauBO7HETElXJZCds+aHatzjmXoIFJEzWtvQN85p2X43
 M0rybxB7uapE8AmHrATTintNspqwSpXXjbzovLpW9Rz8rKiVP72DyHbbom68tgKNpf88
 Z2NZ5G3UyqLlDi/3zMfzEZ+QeovvNHov+riDU3XlTxESwXPy6pHHkxo1Wo/XCF74jrr+ pA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pgxmprh92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:10:43 -0700
Received: from twshared21760.39.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 23 Mar 2023 16:10:42 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id 6920272128C1; Thu, 23 Mar 2023 16:10:37 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH] io_uring: add support for multishot timeouts
Date:   Thu, 23 Mar 2023 16:10:15 -0700
Message-ID: <20230323231015.2170096-1-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PEB5_UBAmn05qhWeSPER--OWxooURiXf
X-Proofpoint-ORIG-GUID: PEB5_UBAmn05qhWeSPER--OWxooURiXf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-23_13,2023-03-23_02,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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

For the second case, the `target_seq' field in `struct io_timeout' is
re-purposed to track the remaining number of timeouts.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/timeout.c            | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 1d59c816a5b8..59b9112adb04 100644
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
index 826a51bca3e4..219fd30fed5b 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -37,8 +37,9 @@ struct io_timeout_rem {
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
@@ -49,6 +50,18 @@ static inline void io_put_req(struct io_kiocb *req)
 	}
 }
=20
+static inline bool io_timeout_finish(struct io_timeout *timeout,
+				     struct io_timeout_data *data)
+{
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		return true;
+
+	if (!timeout->off || (timeout->target_seq && --timeout->target_seq))
+		return false;
+
+	return true;
+}
+
 static bool io_kill_timeout(struct io_kiocb *req, int status)
 	__must_hold(&req->ctx->timeout_lock)
 {
@@ -202,6 +215,13 @@ static enum hrtimer_restart io_timeout_fn(struct hrt=
imer *timer)
 	struct io_ring_ctx *ctx =3D req->ctx;
 	unsigned long flags;
=20
+	if (!io_timeout_finish(timeout, data)) {
+		io_aux_cqe(req->ctx, false, req->cqe.user_data, -ETIME,
+			   IORING_CQE_F_MORE, true);
+		hrtimer_forward_now(&data->timer, timespec64_to_ktime(data->ts));
+		return HRTIMER_RESTART;
+	}
+
 	spin_lock_irqsave(&ctx->timeout_lock, flags);
 	list_del_init(&timeout->list);
 	atomic_set(&req->ctx->cq_timeouts,
@@ -470,16 +490,27 @@ static int __io_timeout_prep(struct io_kiocb *req,
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
+	if ((flags & IORING_TIMEOUT_MULTISHOT) && off > 0)
+		timeout->target_seq =3D off;
=20
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
--=20
2.34.1

