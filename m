Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D12592F6B
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbiHONJ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiHONJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:09:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937621BEAF
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:19 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FD37eo030819
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=lgtn1V59FCaESuHF6mKbLUrQP5lax4PFUHgHWEQelYA=;
 b=Nd69FeQ3ilM6QTKbzEI03iES/RbHUM7697sL5Gk2879iKCvYrTLYgxTCTEV8nLucDYIl
 gxtig8Kfev0jM431EZV9m8h2tn8Y8r3VYmRhU8XDK619FGGakzhhHIymikNe7c9zGcAJ
 H5CELqcZ7dFGTk5RqNPCAQ9uYujHraQdzP8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hx9nqt0t9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:19 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:09:17 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4C26449B6CB3; Mon, 15 Aug 2022 06:09:15 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 4/7] io_uring: do not always run task work at the start of io_uring_enter
Date:   Mon, 15 Aug 2022 06:09:08 -0700
Message-ID: <20220815130911.988014-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130911.988014-1-dylany@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: tW6Io5tBpSt5kThTPztzWehZQfnSL2vf
X-Proofpoint-ORIG-GUID: tW6Io5tBpSt5kThTPztzWehZQfnSL2vf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is normally better to wait for task work until after submissions. This
will allow greater batching if either work arrives in the meanwhile, or i=
f
the submissions cause task work to be queued up.

For SQPOLL this also no longer runs task work, but this is handled inside
the SQPOLL loop anyway.

For IOPOLL io_iopoll_check will run task work anyway

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8cc4b28b1725..3b08369c3c60 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2990,8 +2990,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u=
32, to_submit,
 	struct fd f;
 	long ret;
=20
-	io_run_task_work();
-
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP =
|
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING)))
@@ -3060,7 +3058,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, =
u32, to_submit,
 		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
 			goto iopoll_locked;
 		mutex_unlock(&ctx->uring_lock);
+		io_run_task_work();
+	} else {
+		io_run_task_work();
 	}
+
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
 		if (ctx->syscall_iopoll) {
--=20
2.30.2

