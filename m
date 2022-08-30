Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29E35A63DF
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 14:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiH3Muu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 08:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiH3Mut (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 08:50:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A041EB2D8E
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:48 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TMpLa5020037
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=INkrT8gD4GI6jBOyEXw3GPXdNvWYN7HGXZSqC/8tnME=;
 b=PM19hIldYL4KkVWo3d0pLOnCvl7spltgyqRx9iB+MCXMg/1/5GeJg+VWKTLRK8g0UNNv
 VMMNqfV8zbpPfKlGxN8XSPnsiudDNznxvI0Ylyabd9wq2jmCgOQSyRDOfEDDiE5kK2Qy
 +PA3OGTR21B0efqcj/HYJ5Y2yoaeK0riAE0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j94gyc393-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:47 -0700
Received: from twshared8288.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:50:44 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0EAB055BF515; Tue, 30 Aug 2022 05:50:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v4 6/7] io_uring: signal registered eventfd to process deferred task work
Date:   Tue, 30 Aug 2022 05:50:12 -0700
Message-ID: <20220830125013.570060-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830125013.570060-1-dylany@fb.com>
References: <20220830125013.570060-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5CGGXBeqc2aU1fO5gqdQh82tCf-5ElLc
X-Proofpoint-GUID: 5CGGXBeqc2aU1fO5gqdQh82tCf-5ElLc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_07,2022-08-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some workloads rely on a registered eventfd (via
io_uring_register_eventfd(3)) in order to wake up and process the
io_uring.

In the case of a ring setup with IORING_SETUP_DEFER_TASKRUN, that eventfd
also needs to be signalled when there are tasks to run.

This changes an old behaviour which assumed 1 eventfd signal implied at
least 1 CQE, however only when this new flag is set (and so old users wil=
l
not notice). This should be expected with the IORING_SETUP_DEFER_TASKRUN
flag as it is not guaranteed that every task will result in a CQE.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 75 ++++++++++++++++++++++++----------
 2 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index d56ff2185168..42494176434a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -184,6 +184,7 @@ struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
+	atomic_t		refs;
 };
=20
 struct io_alloc_cache {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c6e416be7ed3..fffa81e498a4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -478,33 +478,33 @@ static __cold void io_queue_deferred(struct io_ring=
_ctx *ctx)
 	}
 }
=20
+
+static inline void __io_eventfd_put(struct io_ev_fd *ev_fd)
+{
+	if (atomic_dec_and_test(&ev_fd->refs)) {
+		eventfd_ctx_put(ev_fd->cq_ev_fd);
+		kfree(ev_fd);
+	}
+}
+
+static void io_eventfd_signal_put(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_signal(ev_fd->cq_ev_fd, 1);
+	__io_eventfd_put(ev_fd);
+}
+
 static void io_eventfd_put(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
=20
-	eventfd_ctx_put(ev_fd->cq_ev_fd);
-	kfree(ev_fd);
+	__io_eventfd_put(ev_fd);
 }
=20
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
-	struct io_ev_fd *ev_fd;
-	bool skip;
-
-	spin_lock(&ctx->completion_lock);
-	/*
-	 * Eventfd should only get triggered when at least one event has been
-	 * posted. Some applications rely on the eventfd notification count onl=
y
-	 * changing IFF a new CQE has been added to the CQ ring. There's no
-	 * depedency on 1:1 relationship between how many times this function i=
s
-	 * called (and hence the eventfd count) and number of CQEs posted to th=
e
-	 * CQ ring.
-	 */
-	skip =3D ctx->cached_cq_tail =3D=3D ctx->evfd_last_cq_tail;
-	ctx->evfd_last_cq_tail =3D ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-	if (skip)
-		return;
+	struct io_ev_fd *ev_fd =3D NULL;
=20
 	rcu_read_lock();
 	/*
@@ -522,13 +522,43 @@ static void io_eventfd_signal(struct io_ring_ctx *c=
tx)
 		goto out;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		goto out;
+	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
+		goto out;
=20
-	if (!ev_fd->eventfd_async || io_wq_current_is_worker())
+	if (likely(eventfd_signal_allowed())) {
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
+	} else {
+		atomic_inc(&ev_fd->refs);
+		call_rcu(&ev_fd->rcu, io_eventfd_signal_put);
+	}
+
 out:
 	rcu_read_unlock();
 }
=20
+static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
+{
+	bool skip;
+
+	spin_lock(&ctx->completion_lock);
+
+	/*
+	 * Eventfd should only get triggered when at least one event has been
+	 * posted. Some applications rely on the eventfd notification count
+	 * only changing IFF a new CQE has been added to the CQ ring. There's
+	 * no depedency on 1:1 relationship between how many times this
+	 * function is called (and hence the eventfd count) and number of CQEs
+	 * posted to the CQ ring.
+	 */
+	skip =3D ctx->cached_cq_tail =3D=3D ctx->evfd_last_cq_tail;
+	ctx->evfd_last_cq_tail =3D ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+	if (skip)
+		return;
+
+	io_eventfd_signal(ctx);
+}
+
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
 	if (ctx->off_timeout_used || ctx->drain_active) {
@@ -540,7 +570,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx=
)
 		spin_unlock(&ctx->completion_lock);
 	}
 	if (ctx->has_evfd)
-		io_eventfd_signal(ctx);
+		io_eventfd_flush_signal(ctx);
 }
=20
 static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
@@ -1071,6 +1101,8 @@ static void io_req_local_work_add(struct io_kiocb *=
req)
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
=20
+	if (ctx->has_evfd)
+		io_eventfd_signal(ctx);
 	io_cqring_wake(ctx);
=20
 }
@@ -2473,6 +2505,7 @@ static int io_eventfd_register(struct io_ring_ctx *=
ctx, void __user *arg,
 	ev_fd->eventfd_async =3D eventfd_async;
 	ctx->has_evfd =3D true;
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	atomic_set(&ev_fd->refs, 1);
 	return 0;
 }
=20
--=20
2.30.2

