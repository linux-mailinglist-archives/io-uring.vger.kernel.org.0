Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71E728594
	for <lists+io-uring@lfdr.de>; Thu,  8 Jun 2023 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbjFHQm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 12:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbjFHQmz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 12:42:55 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4813030C4
        for <io-uring@vger.kernel.org>; Thu,  8 Jun 2023 09:42:33 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 1F54B6BD0FBA; Thu,  8 Jun 2023 09:38:40 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
Subject: [PATCH v15 2/7] net: add napi_busy_loop_rcu()
Date:   Thu,  8 Jun 2023 09:38:34 -0700
Message-Id: <20230608163839.2891748-3-shr@devkernel.io>
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

This adds the napi_busy_loop_rcu() function. This function assumes that
the calling function is already holding the rcu read lock and
napi_busy_loop() does not need to take the rcu read lock.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/net/busy_poll.h |  4 ++++
 net/core/dev.c          | 11 +++++++++++
 2 files changed, 15 insertions(+)

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
index ae90265f4020..60fc54c4aa42 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6260,6 +6260,17 @@ void __napi_busy_loop(unsigned int napi_id,
 		rcu_read_unlock();
 }
=20
+/* Warning: can exit without calling need_resched(). */
+void napi_busy_loop_rcu(unsigned int napi_id,
+			bool (*loop_end)(void *, unsigned long),
+			void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	__napi_busy_loop(napi_id, loop_end, loop_end_arg, prefer_busy_poll,
+			 budget, true);
+}
+
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
--=20
2.39.1

