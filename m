Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89373A71F
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjFVRVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjFVRUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:20:49 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673BA19AF;
        Thu, 22 Jun 2023 10:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687454447;
        bh=+XRDjI36PEd0caHlici2GUhkWoB0ec/qz+50JPGebKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SsVgkH/skY1v3CBQPy8YxPB6zH2PSH6cl5wZBHVUzgHJ5Pe5jlPkRaW7VNIe5OKAo
         5umKypCl5cmKqqa1lNVqwijyq+27ib9x4PjOyRCdXLQfk1hnzTi/C9gkPyN1ZAIHbp
         feTSdwiDUrNvD9XQpski4z3VmbEoWMm0ck+OJa5M+FKTpvxgjDpVL5NSQr5mu38GIg
         OFzVve1ZhMjZvaA8kUgwfBxZ4J8z0uOtk1akdSJcbaLg/6Px4I+ibUT0Y/mA88au87
         t0zoR/q0drsQTbEywHwHuzXuOwrclHLaW0+Z+QKoHuxAxdYGP0mH+B7J/slThQ+9xN
         +3o2Hn9pFapSQ==
Received: from integral2.. (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 18B5A249D86;
        Fri, 23 Jun 2023 00:20:43 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Matthew Patrick <ThePhoenix576@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 3/3] src/Makefile: Allow using stack protector with libc
Date:   Fri, 23 Jun 2023 00:20:29 +0700
Message-Id: <20230622172029.726710-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
References: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
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

Currently, the stack protector is forcefully disabled. Let's allow using
the stack protector feature only if libc is used.

The stack protector will remain disabled by default if no custom CFLAGS
are provided. This ensures the default behavior doesn't change while
still offering the option to enable the stack protector.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Guillem Jover <guillem@hadrons.org>
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 951c48fc6797be75..c4c28cbe87c7a8de 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,9 +10,8 @@ CPPFLAGS ?=
 override CPPFLAGS += -D_GNU_SOURCE \
 	-Iinclude/ -include ../config-host.h \
 	-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
-CFLAGS ?= -g -O3 -Wall -Wextra
+CFLAGS ?= -g -O3 -Wall -Wextra -fno-stack-protector
 override CFLAGS += -Wno-unused-parameter \
-	-fno-stack-protector \
 	-DLIBURING_INTERNAL \
 	$(LIBURING_CFLAGS)
 SO_CFLAGS=-fPIC $(CFLAGS)
@@ -46,8 +45,8 @@ liburing_srcs := setup.c queue.c register.c syscall.c version.c
 
 ifeq ($(CONFIG_NOLIBC),y)
 	liburing_srcs += nolibc.c
-	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin
-	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin
+	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin -fno-stack-protector
+	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin -fno-stack-protector
 	override LINK_FLAGS += -nostdlib -nodefaultlibs
 endif
 
-- 
Ammar Faizi

