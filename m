Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556EA5A932C
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiIAJdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiIAJdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:02 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9352B132EF6
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:01 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2811JjQi031467
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=agxdowrQ7gRHD5E6P2FiwHR8TBxCukgmzURPbdtpIfs=;
 b=NWdlJCGjsXp9sdeG2lpEAYZsRkCSUt0G+i7Y8LydfRa+PIWhoxYElkYNT4td0OlDD/qr
 eVb+SXOyl+SzRAKmpX60nMW4ZEe/fLiHU9wVbRzna4dxUYUDrBER+L8FAic+WDwhMjP/
 +/dDlkiQuL+QNrsN3qN/EddeWdrNm/Qg+K0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaab2wgfv-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:00 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:32:49 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EEBB9576932F; Thu,  1 Sep 2022 02:32:37 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next] io_uring: do not double call_rcu with eventfd
Date:   Thu, 1 Sep 2022 02:32:32 -0700
Message-ID: <20220901093232.1971404-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fBXz2-aDQ-Ek08lv-gJy1p6Gy-8UdfEv
X-Proofpoint-ORIG-GUID: fBXz2-aDQ-Ek08lv-gJy1p6Gy-8UdfEv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is not allowed to use call_rcu twice with the same rcu head. This coul=
d
have happened with multiple signals occurring concurrently.

Instead keep track of ops in a bitset and only queue up the call if it is
not already queued up.

The refcounting is still required since as far as I can tell there is
otherwise no protection from a call to io_eventfd_ops being started and
before it completes another call being started.

Fixes: "io_uring: signal registered eventfd to process deferred task work=
"
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

Note I did not put a hash in the Fixes tag as it has not yet been merged.
You could also just merge it into that commit if you like.

Dylan

 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 41 +++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 42494176434a..aa4d90a53866 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -185,6 +185,7 @@ struct io_ev_fd {
 	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
 	atomic_t		refs;
+	atomic_t		ops;
 };
=20
 struct io_alloc_cache {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cdd8d10e9638..15c7b2f4c5a3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -125,6 +125,11 @@ enum {
 	IO_CHECK_CQ_DROPPED_BIT,
 };
=20
+enum {
+	IO_EVENTFD_OP_SIGNAL_BIT,
+	IO_EVENTFD_OP_FREE_BIT,
+};
+
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
@@ -479,29 +484,24 @@ static __cold void io_queue_deferred(struct io_ring=
_ctx *ctx)
 }
=20
=20
-static inline void __io_eventfd_put(struct io_ev_fd *ev_fd)
+static void io_eventfd_ops(struct rcu_head *rcu)
 {
+	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
+	int ops =3D atomic_xchg(&ev_fd->ops, 0);
+
+	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
+		eventfd_signal(ev_fd->cq_ev_fd, 1);
+
+	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
+	 * ordering in a race but if references are 0 we know we have to free
+	 * it regardless.
+	 */
 	if (atomic_dec_and_test(&ev_fd->refs)) {
 		eventfd_ctx_put(ev_fd->cq_ev_fd);
 		kfree(ev_fd);
 	}
 }
=20
-static void io_eventfd_signal_put(struct rcu_head *rcu)
-{
-	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
-
-	eventfd_signal(ev_fd->cq_ev_fd, 1);
-	__io_eventfd_put(ev_fd);
-}
-
-static void io_eventfd_put(struct rcu_head *rcu)
-{
-	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
-
-	__io_eventfd_put(ev_fd);
-}
-
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd =3D NULL;
@@ -529,7 +529,10 @@ static void io_eventfd_signal(struct io_ring_ctx *ct=
x)
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
 	} else {
 		atomic_inc(&ev_fd->refs);
-		call_rcu(&ev_fd->rcu, io_eventfd_signal_put);
+		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
+			call_rcu(&ev_fd->rcu, io_eventfd_ops);
+		else
+			atomic_dec(&ev_fd->refs);
 	}
=20
 out:
@@ -2509,6 +2512,7 @@ static int io_eventfd_register(struct io_ring_ctx *=
ctx, void __user *arg,
 	ctx->has_evfd =3D true;
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	atomic_set(&ev_fd->refs, 1);
+	atomic_set(&ev_fd->ops, 0);
 	return 0;
 }
=20
@@ -2521,7 +2525,8 @@ static int io_eventfd_unregister(struct io_ring_ctx=
 *ctx)
 	if (ev_fd) {
 		ctx->has_evfd =3D false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		call_rcu(&ev_fd->rcu, io_eventfd_put);
+		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_FREE_BIT), &ev_fd->ops))
+			call_rcu(&ev_fd->rcu, io_eventfd_ops);
 		return 0;
 	}
=20

base-commit: 32bde07ca566822d14f5faadcce86629d89b072b
--=20
2.30.2

