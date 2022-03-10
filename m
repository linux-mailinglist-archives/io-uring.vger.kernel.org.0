Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00874D44AC
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbiCJKdn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241432AbiCJKde (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:33:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D512410B9
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:32:30 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 6C3777E2E3;
        Thu, 10 Mar 2022 10:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646908350;
        bh=9c9fB5ZL/A6dacc6FIIfmkx2Uclcb4MSLDA4QQEQJyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVcQm/7Cb6w7WRZ7nmiJGJk4fm6faogny64c+w2GZbDXKtzXgzi8WDc1KECAdtydF
         eNZ8mhHpTQF1bemBVByI5+P4iDfFZGnO/b7dDv5IPPQt2qIBYZEdif0SQMMy8k0FXR
         FzUncQ7LEJ4QCU+RPDI8RLbhqE7bLsnlsKE2yvVqOS1Iuj3MoDt8O2Xvyy+TsIBxQz
         dBBY5g92cQcf6FN1cHDZft+6Sf86Zsyg8bIhRYyVuSZxDI1kWDt8F8zFcUaX8gbJ+E
         vXTMFNTmrOhV+6meXM+WkVjH9+VgOQifDybJ+7tHHmRIh6RPJz5Xmqow3ahWhIs2f6
         rBB6TjOKGP7iA==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 2/4] src/Makefile: Add header files as dependency
Date:   Thu, 10 Mar 2022 10:32:22 +0000
Message-Id: <20220310103224.1675123-3-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
References: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
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

When the header files are modified, the compiled objects are not going
to be recompiled because the header files are not marked as a dependency
for the objects.

  - Instruct the compiler to generate dependency files.

  - Include those files from src/Makefile. Ensure if any changes are
    made, files that depend on the changes are recompiled.

Suggested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 src/Makefile | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index f19d45e..bb165fa 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -43,19 +43,20 @@ else
 	liburing_srcs += syscall.c
 endif
 
+override CPPFLAGS += -MT "$@" -MMD -MP -MF "$@.d"
 liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
 liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
 
-$(liburing_srcs): syscall.h lib.h
-
-$(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
-
 %.os: %.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(SO_CFLAGS) -c -o $@ $<
 
 %.ol: %.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(L_CFLAGS) -c -o $@ $<
 
+# Include compiler generated dependency files.
+-include $(liburing_objs:%=%.d)
+-include $(liburing_sobjs:%=%.d)
+
 AR ?= ar
 RANLIB ?= ranlib
 liburing.a: $(liburing_objs)
@@ -78,8 +79,6 @@ ifeq ($(ENABLE_SHARED),1)
 	ln -sf $(relativelibdir)$(libname) $(libdevdir)/liburing.so
 endif
 
-$(liburing_objs): include/liburing.h
-
 clean:
 	@rm -f $(all_targets) $(liburing_objs) $(liburing_sobjs) $(soname).new
 	@rm -f *.so* *.a *.o
-- 
2.25.1

