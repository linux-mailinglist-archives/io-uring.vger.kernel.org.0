Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44851635B09
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiKWLHd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbiKWLHA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:00 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561AEF597
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB5AJa011730
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=tT9SXXgL4qAiH0CLnlUBy9F9WnDDxv+tpt2rXyxWWtY=;
 b=bCts4UVhLfCOUGOFD8dpZDNkS5PcedwkeCPTeiWXx5nQiWqopEtOg4Z7IkqVNOo5vP7Y
 gtz6LqZad0/UdzamGgMD+cjsGGVNdDjn99L2oBRAY7G81PGO49/dXwWfI8t8xE53mKqt
 xEsIcZQmv0ZSOw50dqPtcHkIqvMwtVc6d3dbToFmLmINV9TthuX+VvvNj02P3C+H6ux/
 1240xcwwlAwWNFeLHNkSk1JuVhU9zxTVkHqx1tR3xspeTvsusBPl/ZGXqpC94xKrl+oE
 +4cBpcHqfWOFATVBTj/3WZOXgZO7z1h5Kes31wKQZfFgjHG+HbTY9sx3fbYZK/ydQx/5 9w== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0m19unf1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:40 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 88050A0804D4; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 07/13] io_uring: make io_req_complete_post static
Date:   Wed, 23 Nov 2022 03:06:08 -0800
Message-ID: <20221123110614.3297343-8-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oNDQgSNfRKOnL7-vGmRGpwhc3Ti0SVTt
X-Proofpoint-GUID: oNDQgSNfRKOnL7-vGmRGpwhc3Ti0SVTt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is only called from two functions in io_uring.c so remove the header
export.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 912f6fefc665..43db84fe001d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -845,7 +845,7 @@ static void __io_req_complete_put(struct io_kiocb *re=
q)
 	}
 }
=20
-void io_req_complete_post(struct io_kiocb *req)
+static void io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
=20
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ffab0d2d33c0..3c3a93493239 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -32,7 +32,6 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *=
locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
 		     bool allow_overflow);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
--=20
2.30.2

