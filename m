Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054A5691425
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 00:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjBIXCV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 18:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBIXCU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 18:02:20 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864875EBD2
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 15:02:16 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id ADCAA6AB6771; Thu,  9 Feb 2023 15:02:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v8 2/7] io-uring: add napi fields to io_ring_ctx
Date:   Thu,  9 Feb 2023 15:01:39 -0800
Message-Id: <20230209230144.465620-3-shr@devkernel.io>
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

Add the napi fields to the io_ring_ctx data structure. It contains of a
list, a hash table and two settings. The settings are the busy poll
timeout and prefer busy poll.

The list and the hash table operate on the same data structure. The hash
table is used when adding elements and the list is used when executing
the busy poll loop.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/linux/io_uring_types.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 0efe4d784358..fe4033aacc4c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -2,6 +2,7 @@
 #define IO_URING_TYPES_H
=20
 #include <linux/blkdev.h>
+#include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
@@ -276,6 +277,15 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct list_head	napi_list;	/* track busy poll napi_id */
+	spinlock_t		napi_lock;	/* napi_list lock */
+
+	DECLARE_HASHTABLE(napi_ht, 4);
+	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
+	bool			napi_prefer_busy_poll;
+#endif
+
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
--=20
2.30.2

