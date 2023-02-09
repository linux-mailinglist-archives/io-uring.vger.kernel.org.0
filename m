Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44E691427
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 00:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjBIXCZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 18:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBIXCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 18:02:24 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738345EBE1
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 15:02:17 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id B254D6AB6773; Thu,  9 Feb 2023 15:02:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v8 3/7] io-uring: add busy poll timeout, prefer busy poll to io_wait_queue
Date:   Thu,  9 Feb 2023 15:01:40 -0800
Message-Id: <20230209230144.465620-4-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209230144.465620-1-shr@devkernel.io>
References: <20230209230144.465620-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the two fields busy poll timeout and prefer busy poll to the
io_wait_queue structure. They are used during the busy poll processing.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 io_uring/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 021f9af37c74..2e1b8de8505a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -34,6 +34,10 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 	ktime_t timeout;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned int napi_busy_poll_to;
+	bool napi_prefer_busy_poll;
+#endif
 };
=20
 static inline bool io_should_wake(struct io_wait_queue *iowq)
--=20
2.30.2

