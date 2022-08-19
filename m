Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC68599BE2
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348329AbiHSMUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 08:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348731AbiHSMUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 08:20:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34D0100F34
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:36 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J9GqEG025284
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=V329A0k++xK/PFVPubNpbm1rj3kPgFHzDDIMShBu9OQ=;
 b=CMkLrR9hviCtoz/6wTbP7kP0+ufT4t22n5sdDcFmUqc4NQg00QUsm5pfQETD4gayeo16
 48/bqXSlQWCZEi/MWIfKEu3n3hinWFV49mHOQswKwf9NtNaLlnkTe11ipX4cXGELCKWj
 AE+gbY+xoBR/6YDGLMMjAJRZybG70lUZgPc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j27ra9760-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:35 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 05:20:34 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 91EB34CEF046; Fri, 19 Aug 2022 05:20:25 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v3 1/7] io_uring: remove unnecessary variable
Date:   Fri, 19 Aug 2022 05:19:40 -0700
Message-ID: <20220819121946.676065-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819121946.676065-1-dylany@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fwyu-sCmNAX_HFc7t5hx9ShNK0mBfybk
X-Proofpoint-GUID: fwyu-sCmNAX_HFc7t5hx9ShNK0mBfybk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

'running' is set once and read once, so can easily just remove it

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ebfdb2212ec2..0c9fe0f1c174 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1052,12 +1052,9 @@ void io_req_task_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx =3D req->task->io_uring;
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct llist_node *node;
-	bool running;
-
-	running =3D !llist_add(&req->io_task_work.node, &tctx->task_list);
=20
 	/* task_work already pending, we're done */
-	if (running)
+	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
=20
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
--=20
2.30.2

