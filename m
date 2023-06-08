Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA4728544
	for <lists+io-uring@lfdr.de>; Thu,  8 Jun 2023 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbjFHQj2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbjFHQjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 12:39:14 -0400
Received: from 66-220-144-179.mail-mxout.facebook.com (66-220-144-179.mail-mxout.facebook.com [66.220.144.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E9B3582
        for <io-uring@vger.kernel.org>; Thu,  8 Jun 2023 09:38:53 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id BE0566BD0FB8; Thu,  8 Jun 2023 09:38:40 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
Subject: [PATCH v15 1/7] net: split off __napi_busy_poll from napi_busy_poll
Date:   Thu,  8 Jun 2023 09:38:33 -0700
Message-Id: <20230608163839.2891748-2-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230608163839.2891748-1-shr@devkernel.io>
References: <20230608163839.2891748-1-shr@devkernel.io>
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

This splits off the key part of the napi_busy_poll function into its own
function __napi_busy_poll. The new function has an additional rcu
parameter. This new parameter can be used when the caller is already
holding the rcu read lock.

This is done in preparation for an additional napi_busy_poll() function,
that doesn't take the rcu_read_lock(). The new function is introduced
in the next patch.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 net/core/dev.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e041935..ae90265f4020 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6179,9 +6179,10 @@ static void busy_poll_stop(struct napi_struct *nap=
i, void *have_poll_lock, bool
 	local_bh_enable();
 }
=20
-void napi_busy_loop(unsigned int napi_id,
-		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+void __napi_busy_loop(unsigned int napi_id,
+		      bool (*loop_end)(void *, unsigned long),
+		      void *loop_end_arg, bool prefer_busy_poll, u16 budget,
+		      bool rcu)
 {
 	unsigned long start_time =3D loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6191,7 +6192,8 @@ void napi_busy_loop(unsigned int napi_id,
 restart:
 	napi_poll =3D NULL;
=20
-	rcu_read_lock();
+	if (!rcu)
+		rcu_read_lock();
=20
 	napi =3D napi_by_id(napi_id);
 	if (!napi)
@@ -6237,6 +6239,8 @@ void napi_busy_loop(unsigned int napi_id,
 			break;
=20
 		if (unlikely(need_resched())) {
+			if (rcu)
+				break;
 			if (napi_poll)
 				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
 			preempt_enable();
@@ -6252,7 +6256,16 @@ void napi_busy_loop(unsigned int napi_id,
 		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
 	preempt_enable();
 out:
-	rcu_read_unlock();
+	if (!rcu)
+		rcu_read_unlock();
+}
+
+void napi_busy_loop(unsigned int napi_id,
+		    bool (*loop_end)(void *, unsigned long),
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	__napi_busy_loop(napi_id, loop_end, loop_end_arg, prefer_busy_poll,
+			 budget, false);
 }
 EXPORT_SYMBOL(napi_busy_loop);
=20
--=20
2.39.1

