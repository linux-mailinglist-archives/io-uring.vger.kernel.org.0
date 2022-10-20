Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52049605F6C
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 13:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJTLxM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 07:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJTLxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 07:53:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28707B58D
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:53:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id C1BEC8060C;
        Thu, 20 Oct 2022 11:53:07 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666266790;
        bh=AzQErpK2u3zRMFBEAk1HPuph+7o59AjPDxcA9cnyZPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nupol7u9WDUIdSn9d51zOfTrgLegmq4kcq6ZBygsR3ItamzjxSbW2y90BuAz/aBMx
         Fo9kzA+ayserSXiK17cGcpO/wlRJZ9wI5gjrg36Aq4jbKbodLtHte9/TNjUHDgLy78
         sVsisoPj2XDmKrTdqq6JyFUcnUWkc3NpOW+skxAYWxahgG8+dxj8eQ5j4eHcFhVR4P
         iRKOtE5GKCOU4MSX9VE003GkgXGhZuwBmxq0IdWZ3aLqO+hyW6RS5WEqL+EW5Z6rNM
         IiADqE/Y+CS6ctw0Z0iyiMZbXcFXiXIkwtG5Ca2Ar/evKVUpT2WmWJu4ZjC7C/Qrik
         oLNZmgtB3cqzw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 2/3] Makefile: Introduce `LIBURING_CFLAGS` variable
Date:   Thu, 20 Oct 2022 18:52:05 +0700
Message-Id: <20221020114814.63133-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020114814.63133-1-ammar.faizi@intel.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
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

Co-authored-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
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

