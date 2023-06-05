Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEC72321C
	for <lists+io-uring@lfdr.de>; Mon,  5 Jun 2023 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjFEVUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 17:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjFEVUi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 17:20:38 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD866F3
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 14:20:37 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id EFDBE6992199; Mon,  5 Jun 2023 14:20:21 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
Subject: [PATCH v14 2/8] net: introduce napi_busy_loop_rcu()
Date:   Mon,  5 Jun 2023 14:20:03 -0700
Message-Id: <20230605212009.1992313-3-shr@devkernel.io>
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

This introduces the napi_busy_loop_rcu() function. If the caller of
napi_busy_loop() function is also taking the rcu read lock, it is possibl=
e
that napi_busy_loop() is releasing the read lock if it invokes schedule.
However the caller is expecting that the rcu read lock is not released
until the function completes. This new function avoids that problem. It
expects that the caller MUST hold the rcu_read_lock while calling this
function.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/net/busy_poll.h |  4 ++++
 net/core/dev.c          | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index f90f0021f5f2..622623f5740e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,10 @@ void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
=20
+void napi_busy_loop_rcu(unsigned int napi_id,
+			bool (*loop_end)(void *, unsigned long),
+			void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index f4677aa20f84..fcd4a6a70646 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6213,6 +6213,37 @@ static inline void __napi_busy_poll(struct napi_bu=
sy_poll_ctx *ctx,
 				LINUX_MIB_BUSYPOLLRXPACKETS, work);
 	local_bh_enable();
 }
+
+/*
+ * Warning: can exit without calling need_resched().
+ */
+void napi_busy_loop_rcu(unsigned int napi_id,
+		    bool (*loop_end)(void *, unsigned long),
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	unsigned long start_time =3D loop_end ? busy_loop_current_time() : 0;
+	struct napi_busy_poll_ctx ctx =3D {};
+
+	ctx.napi =3D napi_by_id(napi_id);
+	if (!ctx.napi)
+		return;
+
+	preempt_disable();
+	for (;;) {
+		__napi_busy_poll(&ctx, prefer_busy_poll, budget);
+
+		if (!loop_end || loop_end(loop_end_arg, start_time))
+			break;
+		if (unlikely(need_resched()))
+			break;
+
+		cpu_relax();
+	}
+	if (ctx.napi_poll)
+		busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budget)=
;
+	preempt_enable();
+}
+
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
--=20
2.39.1

