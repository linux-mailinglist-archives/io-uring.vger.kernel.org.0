Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE81767E718
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjA0Nwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjA0Nwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:52:47 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E34C0C
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:46 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RDflPd000991
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=10lC6GqiHz27HDL/00pKqXdUGhZqRkEoxEj00/A7Orc=;
 b=IocGZqkHevbQkpNKjcrgfS87Mv8FfEPc3Qnsh3aNaRBJfJVh7ZHqIbP1G0//Cb47IR3R
 wOhCyVuMSZ9AZz1x4q+caqzYhjjhk6oo89eYmk4mu3XK6fWxj44BmmLaKcuv+TjBxgFk
 /KUApcBZJMfqE3mV8tG7I+3sfeO2YzpDMqJRbwctiR706/YT83h6WBcMzWdE5nAYtudS
 /z3XH7Y+kb++xy52HpzoAn0xeF9tREYJWAnK8O0byLGNpyp20Z9LFsAAXY/s6Wf3k1GQ
 c/c6s5fEmS9QKW3QLJupSdnMoW3AMNyVInr+O+YShcxClxZCRuhfUzsaXgIUJ1JarhSd nw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbw3dne44-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:45 -0800
Received: from twshared18048.08.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 05:52:44 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EE4B6EA2811F; Fri, 27 Jan 2023 05:52:34 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 1/4] io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async
Date:   Fri, 27 Jan 2023 05:52:24 -0800
Message-ID: <20230127135227.3646353-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127135227.3646353-1-dylany@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DgySmjEvrhy2m9a3Tc5q2h6IrS1TRVl5
X-Proofpoint-GUID: DgySmjEvrhy2m9a3Tc5q2h6IrS1TRVl5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_FORCE_ASYNC was being ignored for re-queueing linked
requests. Instead obey that flag.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db623b3185c8..980ba4fda101 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1365,10 +1365,12 @@ void io_req_task_submit(struct io_kiocb *req, boo=
l *locked)
 {
 	io_tw_lock(req->ctx, locked);
 	/* req->task =3D=3D current here, checking PF_EXITING is safe */
-	if (likely(!(req->task->flags & PF_EXITING)))
-		io_queue_sqe(req);
-	else
+	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
+	else if (req->flags & REQ_F_FORCE_ASYNC)
+		io_queue_iowq(req, locked);
+	else
+		io_queue_sqe(req);
 }
=20
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
--=20
2.30.2

