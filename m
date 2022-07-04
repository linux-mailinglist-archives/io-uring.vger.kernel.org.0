Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C88F565D3D
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiGDRzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiGDRzS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:18 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13367DE83
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:18 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 0F7A080250;
        Mon,  4 Jul 2022 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957317;
        bh=RZUNWCvb6CfPewwuaMjfuJRp0z32RubJz4HZjneKwdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKvifU3rzBNUNbxlQU4n/KJm9+dIkle08JLDdgEbJY5P5QAIhwMl2s1vZhzM9z4RT
         PIXJ5wJGJG0klljR1HUZt0XsAoLMEHKQs3c9/pq64VR8apiGXIjYLtcGv2ISwXWAkZ
         jir2Mlr+qANVOFSPNsCTNqIdKOfpR6+SctVB4YJoZhdIfUU1l3MID9hY4/vKzn85KT
         mU5FgaU19G3IDpdL9y/AFdg535dZkzc4N8RGqdrUYYtWFxEXoPXn5x8FEcEdCum0oQ
         NtmGcAccWzZcF7p+4mv4QMc3+KzN/j5qX9FZwM5Yxv+h12Bblno1OiGtYn68E/4xwv
         3mQfIrfJTWnUQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 06/10] lib: Style fixup for #if / #elif / #else / #endif
Date:   Tue,  5 Jul 2022 00:54:32 +0700
Message-Id: <20220704174858.329326-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704174858.329326-1-ammar.faizi@intel.com>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
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

