Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2348D72321A
	for <lists+io-uring@lfdr.de>; Mon,  5 Jun 2023 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjFEVUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 17:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjFEVUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 17:20:37 -0400
Received: from 66-220-144-179.mail-mxout.facebook.com (66-220-144-179.mail-mxout.facebook.com [66.220.144.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733D7FD
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 14:20:35 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 3295769921A9; Mon,  5 Jun 2023 14:20:22 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
Subject: [PATCH v14 3/8] net: split off _napi_busy_loop()
Date:   Mon,  5 Jun 2023 14:20:04 -0700
Message-Id: <20230605212009.1992313-4-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230605212009.1992313-1-shr@devkernel.io>
References: <20230605212009.1992313-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the function _napi_busy_loop from the commonality of
napi_busy_loop() and napi_busy_loop_rcu().

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 net/core/dev.c | 66 ++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fcd4a6a70646..2a2d9bae1eb4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6214,39 +6214,10 @@ static inline void __napi_busy_poll(struct napi_b=
usy_poll_ctx *ctx,
 	local_bh_enable();
 }
=20
-/*
- * Warning: can exit without calling need_resched().
- */
-void napi_busy_loop_rcu(unsigned int napi_id,
-		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
-{
-	unsigned long start_time =3D loop_end ? busy_loop_current_time() : 0;
-	struct napi_busy_poll_ctx ctx =3D {};
-
-	ctx.napi =3D napi_by_id(napi_id);
-	if (!ctx.napi)
-		return;
-
-	preempt_disable();
-	for (;;) {
-		__napi_busy_poll(&ctx, prefer_busy_poll, budget);
-
-		if (!loop_end || loop_end(loop_end_arg, start_time))
-			break;
-		if (unlikely(need_resched()))
-			break;
-
-		cpu_relax();
-	}
-	if (ctx.napi_poll)
-		busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budget)=
;
-	preempt_enable();
-}
-
-void napi_busy_loop(unsigned int napi_id,
+static void _napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget,
+		    bool rcu)
 {
 	unsigned long start_time =3D loop_end ? busy_loop_current_time() : 0;
 	struct napi_busy_poll_ctx ctx =3D {};
@@ -6254,7 +6225,8 @@ void napi_busy_loop(unsigned int napi_id,
 restart:
 	ctx.napi_poll =3D NULL;
=20
-	rcu_read_lock();
+	if (rcu)
+		rcu_read_lock();
=20
 	ctx.napi =3D napi_by_id(napi_id);
 	if (!ctx.napi)
@@ -6268,8 +6240,12 @@ void napi_busy_loop(unsigned int napi_id,
 			break;
=20
 		if (unlikely(need_resched())) {
+			if (rcu)
+				break;
+
 			if (ctx.napi_poll)
-				busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budge=
t);
+				busy_poll_stop(ctx.napi, ctx.have_poll_lock,
+					       prefer_busy_poll, budget);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6283,7 +6259,27 @@ void napi_busy_loop(unsigned int napi_id,
 		busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budget)=
;
 	preempt_enable();
 out:
-	rcu_read_unlock();
+	if (rcu)
+		rcu_read_unlock();
+}
+
+/*
+ * Warning: can exit without calling need_resched().
+ */
+void napi_busy_loop_rcu(unsigned int napi_id,
+		    bool (*loop_end)(void *, unsigned long),
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	_napi_busy_loop(napi_id, loop_end, loop_end_arg, prefer_busy_poll,
+			budget, true);
+}
+
+void napi_busy_loop(unsigned int napi_id,
+		    bool (*loop_end)(void *, unsigned long),
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	_napi_busy_loop(napi_id, loop_end, loop_end_arg, prefer_busy_poll,
+			budget, false);
 }
 EXPORT_SYMBOL(napi_busy_loop);
=20
--=20
2.39.1

