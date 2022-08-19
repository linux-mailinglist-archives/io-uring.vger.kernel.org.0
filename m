Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE51599BC9
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348731AbiHSMUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 08:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348826AbiHSMUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 08:20:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4792FF227
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:48 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JB5OuT017403
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=S4wibo6KdH5x8fXmpdrBini7Q7NgRoWfIPbFs0fX9aE=;
 b=oJYo6TKt16ZD/llVwJJ6vBkOHGIeG03O4dfvRn+6oxs/9lWhCY7GB3C9hr57yjuSvckz
 SaOIDQcyin2QeeVP3IXpRd3RxAiEHV0YX6RMfNodJCnZNQ975mn2+U7Z0QHrAAF3pOo7
 EviFotUbrJcWHFlCMs6Gfmj1GlWtJkyd+bU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j1sdvwvd1-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:20:48 -0700
Received: from twshared1866.09.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 05:20:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DA4DB4CEF05F; Fri, 19 Aug 2022 05:20:27 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v3 7/7] io_uring: trace local task work run
Date:   Fri, 19 Aug 2022 05:19:46 -0700
Message-ID: <20220819121946.676065-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819121946.676065-1-dylany@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XWzgoUt2zfUoNfXjOJA9ULGdt0xRW6hP
X-Proofpoint-GUID: XWzgoUt2zfUoNfXjOJA9ULGdt0xRW6hP
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

Add tracing for io_run_local_task_work

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 29 +++++++++++++++++++++++++++++
 io_uring/io_uring.c             |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index c5b21ff0ac85..936fd41bf147 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -655,6 +655,35 @@ TRACE_EVENT(io_uring_short_write,
 			  __entry->wanted, __entry->got)
 );
=20
+/*
+ * io_uring_local_work_run - ran ring local task work
+ *
+ * @tctx:		pointer to a io_uring_ctx
+ * @count:		how many functions it ran
+ * @loops:		how many loops it ran
+ *
+ */
+TRACE_EVENT(io_uring_local_work_run,
+
+	TP_PROTO(void *ctx, int count, unsigned int loops),
+
+	TP_ARGS(ctx, count, loops),
+
+	TP_STRUCT__entry (
+		__field(void *,		ctx	)
+		__field(int,		count	)
+		__field(unsigned int,	loops	)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		=3D ctx;
+		__entry->count		=3D count;
+		__entry->loops		=3D loops;
+	),
+
+	TP_printk("ring %p, count %d, loops %u", __entry->ctx, __entry->count, =
__entry->loops)
+);
+
 #endif /* _TRACE_IO_URING_H */
=20
 /* This part must be outside protection */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 774ca31cb763..acb5aaa80164 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1164,6 +1164,7 @@ int io_run_local_work(struct io_ring_ctx *ctx, bool=
 locked)
 	struct llist_node fake;
 	struct llist_node *current_final =3D NULL;
 	int ret;
+	unsigned int loops =3D 1;
=20
 	if (unlikely(ctx->submitter_task !=3D current)) {
 		if (locked)
@@ -1197,6 +1198,7 @@ int io_run_local_work(struct io_ring_ctx *ctx, bool=
 locked)
=20
 	node =3D io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
 	if (node !=3D &fake) {
+		loops++;
 		current_final =3D &fake;
 		node =3D io_llist_xchg(&ctx->work_llist, &fake);
 		goto again;
@@ -1206,6 +1208,7 @@ int io_run_local_work(struct io_ring_ctx *ctx, bool=
 locked)
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
+	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
 }
=20
--=20
2.30.2

