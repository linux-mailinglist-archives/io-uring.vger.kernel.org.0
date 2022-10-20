Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F105660617A
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJTNX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 09:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiJTNX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 09:23:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F5C19ABE6
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 06:23:07 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id A05D08120D;
        Thu, 20 Oct 2022 13:15:15 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666271718;
        bh=OaMVTSsfEcYCFvthGnXb2jIni7Cl0Y4rJzTrZVc6Uls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTEOyS4dLnmxIigdk8bGMnJb3ETyZWzUi8C/bB5u7IncXkSISTs36ep8FSnf0lldp
         jm4+DXvcDYmPpXB2cH2VWI07P72VPEdxcYJC/Q+8Ra0f9BbbAAJzZOgDMvQThUiedq
         N2KPdGyr2M2djSMfrHoQaXnt0YrVwkUoNxgjSLK2zInddGGNqdz109v/WGuYtasN3n
         DFWbRrS4vP1EB5XS4g/QFGhDQqpw7xNhyzciGEcaYpXJYaxB99JHJjPjMGXkPTT6q0
         5GaHygKejJaJB5Bgt9VBuEK+nHIYRCnpc9txwFypw5ORSUgMVA1PZj3Cc1eZrbObn5
         SkP3GcWRLE34A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
Subject: [PATCH liburing v2 2/3] Makefile: Introduce `LIBURING_CFLAGS` variable
Date:   Thu, 20 Oct 2022 20:14:54 +0700
Message-Id: <20221020131118.13828-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020131118.13828-1-ammar.faizi@intel.com>
References: <20221020131118.13828-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

`LIBURING_CFLAGS` will be appended to `CFLAGS` but it only applies
to files in the `src/` directory (the main library). The first use
case of this variable is for appending a clang-specific flag,
`-Wshorten-64-to-32` in the GitHub bot.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/Makefile b/src/Makefile
index 73a98ba..09617fb 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -5,11 +5,14 @@ includedir ?= $(prefix)/include
 libdir ?= $(prefix)/lib
 libdevdir ?= $(prefix)/lib
 
+LIBURING_CFLAGS ?=
 CPPFLAGS ?=
 override CPPFLAGS += -D_GNU_SOURCE \
 	-Iinclude/ -include ../config-host.h
 CFLAGS ?= -g -O3 -Wall -Wextra -fno-stack-protector
-override CFLAGS += -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL
+override CFLAGS += -Wno-unused-parameter -Wno-sign-compare \
+	-DLIBURING_INTERNAL \
+	$(LIBURING_CFLAGS)
 SO_CFLAGS=-fPIC $(CFLAGS)
 L_CFLAGS=$(CFLAGS)
 LINK_FLAGS=
-- 
Ammar Faizi

