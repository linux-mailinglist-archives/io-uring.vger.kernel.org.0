Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411EA560830
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 20:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiF2R7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiF2R7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:51 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3F0C7F
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:50 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id E3015800EF;
        Wed, 29 Jun 2022 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525590;
        bh=sgazs96gJXhuLUrcrg8QV44lnrofUqELK9IkwXdhdvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDlS1y9uUown8thKLJr6nydxaHlAB/ZU4qJSQAPk9zwsRhsEfhct6zic4HHMsn1K5
         pMcvUciDwREwTB5yu7TJp2JypmQxMF+BdCy28GxAfYDBhQuJOg4iHPwzedX+b2z98A
         iANx7McYCTkFY0HjCAiMVMCZb517LRW1WfLMqTrlIylO71J1clJ8ceXOiQ58XsLmDL
         MtxrZXAPIiEOwqTqdVwYFwt+7mME9dv08pU/sEvmf6f/HXqnHTn7h+xKB5FaBFxOUj
         tZIe2vB0uMmbg/7Urg57owi/LAL3wgByjPDTwFo5izJ8xDizLixP9nEXVRLvciKzC/
         h3P7ioI50WDVA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 6/8] arch: Enable nolibc support for aarch64
Date:   Thu, 30 Jun 2022 00:58:28 +0700
Message-Id: <20220629175255.1377052-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629175255.1377052-1-ammar.faizi@intel.com>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
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

Support nolibc build for aarch64. While in there, don't indent the
block inside #if / #elif / #else / #endif.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index e5f3680..399467c 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -7,28 +7,30 @@
 #include <unistd.h>
 
 #if defined(__x86_64__) || defined(__i386__)
-	#include "arch/x86/lib.h"
+#include "arch/x86/lib.h"
+#elif defined(__aarch64__)
+#include "arch/aarch64/lib.h"
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
+/* libc wrappers. */
+#include "arch/generic/lib.h"
 #endif
 
 
 #ifndef offsetof
-	#define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
+#define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
 #endif
 
 #ifndef container_of
-	#define container_of(PTR, TYPE, FIELD) ({			\
-		__typeof__(((TYPE *)0)->FIELD) *__FIELD_PTR = (PTR);	\
-		(TYPE *)((char *) __FIELD_PTR - offsetof(TYPE, FIELD));	\
-	})
+#define container_of(PTR, TYPE, FIELD) ({			\
+	__typeof__(((TYPE *)0)->FIELD) *__FIELD_PTR = (PTR);	\
+	(TYPE *)((char *) __FIELD_PTR - offsetof(TYPE, FIELD));	\
+})
 #endif
 
 void *__uring_malloc(size_t len);
-- 
Ammar Faizi

