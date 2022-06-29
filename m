Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3255F267
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiF2A2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C43F2F643
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:43 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id C5284800BA;
        Wed, 29 Jun 2022 00:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462523;
        bh=xxtuR21w6prt5YvyZJHHtTVW6LyjbO6UFx3Rrcqdgxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daSUZQxD7OG5ILMdVUJpU/xhHeNyv5dhbxVCRHd8jMFLq3nXvh88mFyjeiFIYRamA
         /Tg39GyCBzfvHgosJpNlVTDak28tYmbbzQrOcVkRbGAmFXwoe5qOf3mr0sTwPd3wo4
         H5sTlHX7CCkItgpDyGecUSS61bykG3ZTkxEvekcLGYN1xZ3wFMtROAV9FOkHUhO+kH
         Nfpp89ssrVBv3BE/yVpIxIXzfCiFI3YAIvabkKvdDbg4TfMCLJ3gJecXBan3k7ZSXX
         F59dKffGcTt2Cw7FjG1TjUeIgyxu9o+aW8w+IFpRK0sqb0WLyNaMGuK0tf6ZaHWH4s
         00YvNDNtk/Ibw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 8/9] arch: Enable nolibc support for arm64
Date:   Wed, 29 Jun 2022 07:27:52 +0700
Message-Id: <20220629002028.1232579-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Support nolibc build for arm64.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 6672cc5..e1419f8 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -8,16 +8,19 @@
 
 #define __INTERNAL__LIBURING_LIB_H
 #if defined(__x86_64__) || defined(__i386__)
-	#include "arch/x86/lib.h"
+#include "arch/x86/lib.h"
+#elif defined(__aarch64__)
+#include "arch/arm64/lib.h"
 #else
-	/*
-	 * We don't have nolibc support for this arch. Must use libc!
-	 */
-	#ifdef CONFIG_NOLIBC
-		#error "This arch doesn't support building liburing without libc"
-	#endif
-	/* libc wrappers. */
-	#include "arch/generic/lib.h"
+/*
+ * We don't have nolibc support for this arch. Must use libc!
+ */
+#ifdef CONFIG_NOLIBC
+#error "This arch doesn't support building liburing without libc"
+#endif
+
+/* libc wrappers. */
+#include "arch/generic/lib.h"
 #endif
 #undef __INTERNAL__LIBURING_LIB_H
 
-- 
Ammar Faizi

