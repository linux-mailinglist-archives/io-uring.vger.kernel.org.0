Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B4509BFA
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387450AbiDUJUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387441AbiDUJT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:59 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D189C11A09
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:10 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L7E8W7001703
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dOWQsXWrlscVSXwcUY7oiVZY2tYgB27g3OF+R0KAHOY=;
 b=WEvYnH9zQRwSv6ZKHLUbnYlZjK+jq2oQfTyBOKE6CgPCYnKWiiGnGeLZpC6UtreFRoj0
 Q+c7aTTJ3zzmQLFXb6bIgdE0A6EYY7U1EOFYqn3DqBPox+XlSu3knR63b9+wio3BNzt/
 W2Both0ib1XKM/HIPKMxxwmHfI88ScbQ51k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhub7eq43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:09 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:17:09 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 152E37CA7602; Thu, 21 Apr 2022 02:14:02 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 5/6] io_uring: return an error when cqe is dropped
Date:   Thu, 21 Apr 2022 02:13:44 -0700
Message-ID: <20220421091345.2115755-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9YH4lFDpaOizjdwnaWoOEumVcp215WBK
X-Proofpoint-ORIG-GUID: 9YH4lFDpaOizjdwnaWoOEumVcp215WBK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Right now io_uring will not actively inform userspace if a CQE is
dropped. This is extremely rare, requiring a CQ ring overflow, as well as
a GFP_ATOMIC kmalloc failure. However the consequences could cause for
example applications to go into an undefined state, possibly waiting for =
a
CQE that never arrives.

Return an error code (EBADR) in these cases. Since this is expected to be
incredibly rare, try and avoid as much as possible affecting the hot code
paths, and so it only is returned lazily and when there is no other
available CQEs.

Once the error is returned, reset the error condition assuming the user i=
s
either ok with it or will clean up appropriately.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index db878c114e16..e46dc67c917c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -905,6 +905,7 @@ struct io_cqe {
=20
 enum {
 	IO_CHECK_CQ_OVERFLOW_BIT,
+	IO_CHECK_CQ_DROPPED_BIT,
 };
=20
 /*
@@ -2119,6 +2120,7 @@ static bool io_cqring_event_overflow(struct io_ring=
_ctx *ctx, u64 user_data,
 		 * on the floor.
 		 */
 		io_account_cq_overflow(ctx);
+		set_bit(IO_CHECK_CQ_DROPPED_BIT, &ctx->check_cq);
 		return false;
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
@@ -2959,16 +2961,26 @@ static int io_iopoll_check(struct io_ring_ctx *ct=
x, long min)
 {
 	unsigned int nr_events =3D 0;
 	int ret =3D 0;
+	unsigned long check_cq;
=20
 	/*
 	 * Don't enter poll loop if we already have events pending.
 	 * If we do, we can potentially be spinning for commands that
 	 * already triggered a CQE (eg in error).
 	 */
-	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
+	check_cq =3D READ_ONCE(ctx->check_cq);
+	if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
 		__io_cqring_overflow_flush(ctx, false);
 	if (io_cqring_events(ctx))
 		return 0;
+
+	/*
+	 * Similarly do not spin if we have not informed the user of any
+	 * dropped CQE.
+	 */
+	if (unlikely(check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)))
+		return -EBADR;
+
 	do {
 		/*
 		 * If a submit got punted to a workqueue, we can have the
@@ -8298,15 +8310,18 @@ static inline int io_cqring_wait_schedule(struct =
io_ring_ctx *ctx,
 					  ktime_t timeout)
 {
 	int ret;
+	unsigned long check_cq;
=20
 	/* make sure we run task_work before checking for signals */
 	ret =3D io_run_task_work_sig();
 	if (ret || io_should_wake(iowq))
 		return ret;
+	check_cq =3D READ_ONCE(ctx->check_cq);
 	/* let the caller flush overflows, retry */
-	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
+	if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
 		return 1;
-
+	if (unlikely(check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)))
+		return -EBADR;
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
@@ -10958,9 +10973,18 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd=
, u32, to_submit,
 			}
 		}
=20
-		if (!ret)
+		if (!ret) {
 			ret =3D ret2;
=20
+			/*
+			 * EBADR indicates that one or more CQE were dropped.
+			 * Once the user has been informed we can clear the bit
+			 * as they are obviously ok with those drops.
+			 */
+			if (unlikely(ret2 =3D=3D -EBADR))
+				clear_bit(IO_CHECK_CQ_DROPPED_BIT,
+					  &ctx->check_cq);
+		}
 	}
=20
 out:
--=20
2.30.2

