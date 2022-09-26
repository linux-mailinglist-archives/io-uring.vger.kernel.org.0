Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02F55EAA1A
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiIZPRn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiIZPQt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:16:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010DD14039
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:26 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q4MFiX026435
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QjTyb5cqB8JpM+faMD/4F0TT8m42x/Q1YTWctvgR8EE=;
 b=VOkC8FQpC4zEdwZGjv8fsTnFHjzx11x0ZIHzXALRfqbJai3D+nSPMcVHXjeYWtZPngaS
 py8aeP9W/ETmNQVOXK9sEN+jkRf8WlzTkRXW8DXU5Dnyzv3uBEqbbsMkH0EOslV8Kc56
 RQLYpWeoLlS37/SjxTAVLsl6t7xE5w2NoXU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jsydxtwrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:25 -0700
Received: from twshared14494.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 07:03:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8CC906AEBEFC; Mon, 26 Sep 2022 07:03:17 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 3/3] io_uring: remove io_register_submitter
Date:   Mon, 26 Sep 2022 07:03:04 -0700
Message-ID: <20220926140304.1973990-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926140304.1973990-1-dylany@fb.com>
References: <20220926140304.1973990-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PNAM7hDsd9EWP7USUqz_xomtnLEPfAJ0
X-Proofpoint-GUID: PNAM7hDsd9EWP7USUqz_xomtnLEPfAJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

this is no longer needed, as submitter_task is set at creation time.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/tctx.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index dd0205fcdb13..4324b1cf1f6a 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -91,20 +91,6 @@ __cold int io_uring_alloc_task_context(struct task_str=
uct *task,
 	return 0;
 }
=20
-static int io_register_submitter(struct io_ring_ctx *ctx)
-{
-	int ret =3D 0;
-
-	mutex_lock(&ctx->uring_lock);
-	if (!ctx->submitter_task)
-		ctx->submitter_task =3D get_task_struct(current);
-	else if (ctx->submitter_task !=3D current)
-		ret =3D -EEXIST;
-	mutex_unlock(&ctx->uring_lock);
-
-	return ret;
-}
-
 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx =3D current->io_uring;
@@ -151,11 +137,9 @@ int __io_uring_add_tctx_node_from_submit(struct io_r=
ing_ctx *ctx)
 {
 	int ret;
=20
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
-		ret =3D io_register_submitter(ctx);
-		if (ret)
-			return ret;
-	}
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
+	    && ctx->submitter_task !=3D current)
+		return -EEXIST;
=20
 	ret =3D __io_uring_add_tctx_node(ctx);
 	if (ret)
--=20
2.30.2

