Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DFF565E03
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 21:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiGDTcl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 15:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiGDTck (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 15:32:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA075DFAC
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 12:32:39 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id E7DC58024B;
        Mon,  4 Jul 2022 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656963159;
        bh=RZUNWCvb6CfPewwuaMjfuJRp0z32RubJz4HZjneKwdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwTsrSDecds3OIfgO+t9xHJwr/ucHbYvRyIackIiYJobVPRUVUeMbclMJtJVAacWV
         4HOgzkMX+B7sC6mH6a4vd2w0eNPCDmBo04xox5pdzfUsz9JkB8cPsa1B7lvTVdPmIU
         pgY8TMDGYi2MHjffORp4E2myaJ/PgB2qI3ktLT4XJieiMGaz6Nu4mABvLhSf4qa0+G
         6BnICki6hubj+jmkJ3sLBMqoIo1BcHZfeZOoAroFkhhMZjgIrT8ghFrqx17aP+XStU
         eVQGrFOfIm1g5yQLSpDKSw5cZWjoNoo0zD3gNbgkFBaIV08lPOcVL9B+bI6C5WAkaZ
         nulC3UDtKYeoA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v4 06/10] lib: Style fixup for #if / #elif / #else / #endif
Date:   Tue,  5 Jul 2022 02:31:51 +0700
Message-Id: <20220704192827.338771-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704192827.338771-1-ammar.faizi@intel.com>
References: <20220704192827.338771-1-ammar.faizi@intel.com>
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

Don't indent the block inside #if / #elif / #else / #endif.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 7bbacb9..a966c77 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -7,28 +7,28 @@
 #include <unistd.h>
 
 #if defined(__x86_64__) || defined(__i386__)
-	#include "arch/x86/lib.h"
+#include "arch/x86/lib.h"
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
 
 #define __maybe_unused		__attribute__((__unused__))
-- 
Ammar Faizi

