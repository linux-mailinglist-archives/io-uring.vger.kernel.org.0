Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1DA4D246C
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 23:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiCHWlZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 17:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbiCHWlZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 17:41:25 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D07658E6A
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 14:40:27 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 67B4C7E6DC;
        Tue,  8 Mar 2022 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646779227;
        bh=YZ99/v2IkQ3nUDjC52EJQ5rDYxp0n4E75irwdwYG5Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gApM0MlJfXCZD9G9DNF3k7YkeFi/Z5/dP8WG3KEdTAmoM3FUcD2S1A08VYJIv5ppi
         zSetmp9KkTIHm1os0k+Hu1MRnvlDqeD1BytAh80Qm8bFvkuI9NfTZ6sZx1EITSKU7B
         rbsfxQKAHCQY5feOlsLZ8som+7VPDvTSaG+QrPkDAq4SGJlMxyuj+88OHDHwH2bd62
         whFuu/7Y6h/M01C+ofzQTXhaThrvm1MB9Dmrhf7+PyTV+hD185oEVfUZiRUxavbhSN
         6tfRnC3L0i0N4O61xevVOz8EpyYviVPhkGoEwc2YQAQHk3kPRF7j7UqrakQeALcpjt
         1G2CMg4YyYNiQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring@vger.kernel.org, gwml@vger.gnuweeb.org
Subject: [PATCH liburing 2/2] src/Makefile: Add header files as dependency
Date:   Tue,  8 Mar 2022 22:40:02 +0000
Message-Id: <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the header files are modified, the compiled object are not going
to be recompiled because the header files are not marked as dependency
for the objects. Add those header files as dependency so it is safe
not to do "make clean" after changing those files.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 src/Makefile | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index f19d45e..b9428b7 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -46,9 +46,16 @@ endif
 liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
 liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
 
-$(liburing_srcs): syscall.h lib.h
-
-$(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
+$(liburing_objs) $(liburing_sobjs): \
+	syscall.h \
+	lib.h \
+	arch/syscall-defs.h \
+	arch/x86/syscall.h \
+	arch/x86/lib.h \
+	arch/aarch64/syscall.h \
+	arch/generic/syscall.h \
+	arch/generic/lib.h \
+	include/liburing/io_uring.h
 
 %.os: %.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(SO_CFLAGS) -c -o $@ $<
@@ -78,8 +85,6 @@ ifeq ($(ENABLE_SHARED),1)
 	ln -sf $(relativelibdir)$(libname) $(libdevdir)/liburing.so
 endif
 
-$(liburing_objs): include/liburing.h
-
 clean:
 	@rm -f $(all_targets) $(liburing_objs) $(liburing_sobjs) $(soname).new
 	@rm -f *.so* *.a *.o
-- 
2.32.0

