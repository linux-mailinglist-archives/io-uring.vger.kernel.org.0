Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2F509C11
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387433AbiDUJT5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387544AbiDUJTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D90B289A6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:56 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23L0VLYv019884
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=crGBemUctK2aDiXsGbr+Y1XDXp3SStzaORv3NA8oNCo=;
 b=L2RAueuJTX4ZLpLHMg2Gr/69UroX8HuWGqK6brm8b02sB4l0xEguqeO1B5tdnmMpQxSp
 47U3Zwozjj0wNPXLbCHnyVKGQ+BQeh7IIbMR/GhnalBA5RO2xynP/ACz41HRwm0dveQJ
 TGk6zE1sn9d+cS+EJQwOQILj9GOxH/NdJtA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fjvsvstve-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:55 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:16:54 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 09E967CA7600; Thu, 21 Apr 2022 02:14:02 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 4/6] io_uring: use constants for cq_overflow bitfield
Date:   Thu, 21 Apr 2022 02:13:43 -0700
Message-ID: <20220421091345.2115755-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: LaaFfGbUG4ZwPfyGDxgIXw9dPMeDzhQ0
X-Proofpoint-ORIG-GUID: LaaFfGbUG4ZwPfyGDxgIXw9dPMeDzhQ0
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

Prepare to use this bitfield for more flags by using constants instead of
magic value 0

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1837b3afa47f..db878c114e16 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -431,7 +431,7 @@ struct io_ring_ctx {
 	struct wait_queue_head	sqo_sq_wait;
 	struct list_head	sqd_list;
=20
-	unsigned long		check_cq_overflow;
+	unsigned long		check_cq;
=20
 	struct {
 		/*
@@ -903,6 +903,10 @@ struct io_cqe {
 	};
 };
=20
+enum {
+	IO_CHECK_CQ_OVERFLOW_BIT,
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -2024,7 +2028,7 @@ static bool __io_cqring_overflow_flush(struct io_ri=
ng_ctx *ctx, bool force)
=20
 	all_flushed =3D list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
-		clear_bit(0, &ctx->check_cq_overflow);
+		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		WRITE_ONCE(ctx->rings->sq_flags,
 			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
@@ -2040,7 +2044,7 @@ static bool io_cqring_overflow_flush(struct io_ring=
_ctx *ctx)
 {
 	bool ret =3D true;
=20
-	if (test_bit(0, &ctx->check_cq_overflow)) {
+	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
@@ -2118,7 +2122,7 @@ static bool io_cqring_event_overflow(struct io_ring=
_ctx *ctx, u64 user_data,
 		return false;
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
-		set_bit(0, &ctx->check_cq_overflow);
+		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		WRITE_ONCE(ctx->rings->sq_flags,
 			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
=20
@@ -2961,7 +2965,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx,=
 long min)
 	 * If we do, we can potentially be spinning for commands that
 	 * already triggered a CQE (eg in error).
 	 */
-	if (test_bit(0, &ctx->check_cq_overflow))
+	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		__io_cqring_overflow_flush(ctx, false);
 	if (io_cqring_events(ctx))
 		return 0;
@@ -8271,7 +8275,8 @@ static int io_wake_function(struct wait_queue_entry=
 *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->check_cq_overflow))
+	if (io_should_wake(iowq) ||
+	    test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &iowq->ctx->check_cq))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -8299,7 +8304,7 @@ static inline int io_cqring_wait_schedule(struct io=
_ring_ctx *ctx,
 	if (ret || io_should_wake(iowq))
 		return ret;
 	/* let the caller flush overflows, retry */
-	if (test_bit(0, &ctx->check_cq_overflow))
+	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		return 1;
=20
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
@@ -10094,7 +10099,8 @@ static __poll_t io_uring_poll(struct file *file, =
poll_table *wait)
 	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
 	 * pushs them to do the flush.
 	 */
-	if (io_cqring_events(ctx) || test_bit(0, &ctx->check_cq_overflow))
+	if (io_cqring_events(ctx) ||
+	    test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		mask |=3D EPOLLIN | EPOLLRDNORM;
=20
 	return mask;
--=20
2.30.2

