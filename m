Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEF74D4569
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiCJLOM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241458AbiCJLOK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:14:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875FBBF523
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:13:09 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id A0B347E2E2;
        Thu, 10 Mar 2022 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646910789;
        bh=5mUI6Qrr1lfn/TAn4CvXth+4B3ls2pCnAwpgjwnBHm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMXX9u+qwX+2BVVaCjKWRRF8/9aHDldO8wr0KbsAVZ7PDB+mrhFudDSTXt4dXxjm0
         eLzmXswy1WTSOuj9g7MbYdAN5yWloVhHx9cEq6cYCEfctPHQ04VsFJAc6iSpPJ3Xw8
         4mqgt4gw13IoV1MTkupSxdidGuN/bjOC2fiIPE40pXCWz3Rn8943CXeXsFfx+fLQ/1
         kUdzuZjBjQw7r9XxloeM8RStsnb5ktSC4DLiEdTHl9OPND2nyquv88J7ocp1OYwtH7
         pqfgbNIy8X2/2iuUKf5v3LbgPzhLwckebrx2sc+w6Z/BFQuITH4UTYDLf7M1ym7Tse
         WR83ViwPeUOrA==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 2/4] src/Makefile: Add header files as dependency
Date:   Thu, 10 Mar 2022 11:12:29 +0000
Message-Id: <20220310111231.1713588-3-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
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

v2 -> v3: 
  - Add dependency files to .gitignore.
  - Remove dependency files when running "make clean".

 .gitignore   |  1 +
 src/Makefile | 13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/.gitignore b/.gitignore
index c9dc77f..9b74880 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,6 +3,7 @@
 *~
 /*.patch
 
+*.d
 *.o
 *.o[ls]
 
diff --git a/src/Makefile b/src/Makefile
index f19d45e..0e04986 100644
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
@@ -78,11 +79,9 @@ ifeq ($(ENABLE_SHARED),1)
 	ln -sf $(relativelibdir)$(libname) $(libdevdir)/liburing.so
 endif
 
-$(liburing_objs): include/liburing.h
-
 clean:
 	@rm -f $(all_targets) $(liburing_objs) $(liburing_sobjs) $(soname).new
-	@rm -f *.so* *.a *.o
+	@rm -f *.so* *.a *.o *.d
 	@rm -f include/liburing/compat.h
 
 	@# When cleaning, we don't include ../config-host.mak,
-- 
2.25.1

