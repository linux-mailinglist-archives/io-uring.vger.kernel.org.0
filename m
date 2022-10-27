Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7960FAB7
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 16:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiJ0Opf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 10:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiJ0OpR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 10:45:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6BD50538
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:46 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RCQoDL016566
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=05X4luiSjwJIKYwwo1UsKsWxuMGPsXi1tm04DzyeZZQ=;
 b=fL/PKXNi+gugVCYoOOgs069UltQW6NdN8xZBwnLQGnoR4cIk9CwZr5BzAQBzH2EiqeCb
 zHhECtV6MtM6pHTZKZ/cCBb8dhzncRRK1iOFE6xOnXswXZ8gttK/FZ1wSX3eXpcty44R
 2Vwa+9rcfTcphq9L+IMSFxjG4Ltr8D/FvzkcGozMnn7IkIVH4gsKx9LQBRDFaXYxAMag
 BVvya3WXDyl4kKwUXfdPxpDQ1yizX+zEOSDLJeaiya1ElQ1RLLx0UjIXlJd/oK+GLtsL
 KaUfYSVfVChpA4q5lEoOJmr8u/Us9zlevDw8MLMc21yPGY9oPbgjdXIjc87uEsdXIKf0 AA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kfagwhr8n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:46 -0700
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:44:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 39F5B8673CD6; Thu, 27 Oct 2022 07:44:36 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH 2/2] io_uring: unlock if __io_run_local_work locked inside
Date:   Thu, 27 Oct 2022 07:44:29 -0700
Message-ID: <20221027144429.3971400-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027144429.3971400-1-dylany@meta.com>
References: <20221027144429.3971400-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZsB2Vflt7F5MPhu43pvRT7_ij4CtElnt
X-Proofpoint-ORIG-GUID: ZsB2Vflt7F5MPhu43pvRT7_ij4CtElnt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is possible for tw to lock the ring, and this was not propogated out t=
o
io_run_local_work. This can cause an unlock to be missed.

Instead pass a pointer to locked into __io_run_local_work.

Fixes: 8ac5d85a89b4 ("io_uring: add local task_work run helper that is en=
tered locked")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c |  8 ++++----
 io_uring/io_uring.h | 12 ++++++++++--
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8a0ce7379e89..ac8c488e3077 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1173,7 +1173,7 @@ static void __cold io_move_task_work_from_local(str=
uct io_ring_ctx *ctx)
 	}
 }
=20
-int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
+int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 {
 	struct llist_node *node;
 	struct llist_node fake;
@@ -1192,7 +1192,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bo=
ol locked)
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 						    io_task_work.node);
 		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-		req->io_task_work.func(req, &locked);
+		req->io_task_work.func(req, locked);
 		ret++;
 		node =3D next;
 	}
@@ -1208,7 +1208,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bo=
ol locked)
 		goto again;
 	}
=20
-	if (locked)
+	if (*locked)
 		io_submit_flush_completions(ctx);
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
@@ -1225,7 +1225,7 @@ int io_run_local_work(struct io_ring_ctx *ctx)
=20
 	__set_current_state(TASK_RUNNING);
 	locked =3D mutex_trylock(&ctx->uring_lock);
-	ret =3D __io_run_local_work(ctx, locked);
+	ret =3D __io_run_local_work(ctx, &locked);
 	if (locked)
 		mutex_unlock(&ctx->uring_lock);
=20
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ef77d2aa3172..331ec2869212 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -27,7 +27,7 @@ enum {
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow=
);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
-int __io_run_local_work(struct io_ring_ctx *ctx, bool locked);
+int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
@@ -277,9 +277,17 @@ static inline int io_run_task_work_ctx(struct io_rin=
g_ctx *ctx)
=20
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
 {
+	bool locked;
+	int ret;
+
 	if (llist_empty(&ctx->work_llist))
 		return 0;
-	return __io_run_local_work(ctx, true);
+
+	locked =3D true;
+	ret =3D __io_run_local_work(ctx, &locked);
+	if (WARN_ON(!locked))
+		mutex_lock(&ctx->uring_lock);
+	return ret;
 }
=20
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
--=20
2.30.2

