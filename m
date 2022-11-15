Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E762A425
	for <lists+io-uring@lfdr.de>; Tue, 15 Nov 2022 22:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbiKOVap (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 16:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbiKOVan (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 16:30:43 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30892C1C;
        Tue, 15 Nov 2022 13:30:43 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.117])
        by gnuweeb.org (Postfix) with ESMTPSA id 0A587815D8;
        Tue, 15 Nov 2022 21:30:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668547842;
        bh=Xn8f4c/AFH0Ra0/h2Gix+NhkQDSMoiw3WSJtA+3ePEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI1QqcBLYHv9bzz8GHTKtY/0som5LvguT6zF43bsRHQFtMaR2AiNtIFZeNTbzxo8o
         BjMf1xsaROAGSN+ZnxjbzBHMkSBitq0cvYGP1US0NY2S8askxicY+7cUZxPvQFtlxz
         qE/AB5pvIPmMG39QhvKUltBpFssQJRcm2X6WFa2YkWhtsb1RNbWjLQgKx2VVk/j6qw
         nFko6DF9lVeJ9mYZqri9MFwPe97HRMD69z/Z7j0u6MBJvHcc286ZnjO+Ze3cmFzjW9
         R3j8l2kYakkGyg9XfQxyhhsuNkTtrxXsFrd73xmY2ObDDijy8Xmh8dhjfj6yM13o+j
         9ws8vKNx16KLA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
Date:   Wed, 16 Nov 2022 04:29:52 +0700
Message-Id: <20221115212614.1308132-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115212614.1308132-1-ammar.faizi@intel.com>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

include/uapi/linux/io_uring.h is synced 1:1 into
liburing:src/include/liburing/io_uring.h.

liburing has a configure check to detect the need for
linux/time_types.h.

Fixes: 78a861b9495920f8609dee5b670dacbff09d359f ("io_uring: add sync cancelation API through io_uring_register()")
Link: https://github.com/axboe/liburing/issues/708
Link: https://github.com/axboe/liburing/pull/709
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 include/uapi/linux/io_uring.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2df3225b562f..77027cbaf786 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1,25 +1,34 @@
 /* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
 /*
  * Header file for the io_uring interface.
  *
  * Copyright (C) 2019 Jens Axboe
  * Copyright (C) 2019 Christoph Hellwig
  */
 #ifndef LINUX_IO_URING_H
 #define LINUX_IO_URING_H
 
 #include <linux/fs.h>
 #include <linux/types.h>
+/*
+ * This file is shared with liburing and it has to autodetect
+ * if linux/time_types.h is available
+ */
+#ifdef __KERNEL__
+#define HAVE_LINUX_TIME_TYPES_H 1
+#endif
+#ifdef HAVE_LINUX_TIME_TYPES_H
 #include <linux/time_types.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 /*
  * IO submission data structure (Submission Queue Entry)
  */
 struct io_uring_sqe {
 	__u8	opcode;		/* type of operation for this sqe */
 	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
-- 
Ammar Faizi

