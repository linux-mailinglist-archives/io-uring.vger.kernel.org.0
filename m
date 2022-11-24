Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BBD6371DC
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 06:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKXFqq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 00:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXFqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 00:46:43 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6EBC6885
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 21:46:43 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id E8706816DF;
        Thu, 24 Nov 2022 05:46:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669268802;
        bh=qgV5FykmPhJtSvUeQYLGYU/72vFDkyoNrBstNLVDWs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFomMt/w6JdTnNUIX4dnqkVdfYaJt0lbTGK4sPpvSi1Xs56RMLTGfmyJlwAtKe6cS
         nzHq6YdOEKDVQbIGwujFI9QJODJZLMgrBwqAgVkPDBK4iniWQG21R4LHX8yIBqqpP7
         O9WSKScbXPDBmZoAffyxqpUVVhoB03kBpFmmCh4osdedPC6nEQKHBLzRkB1nN+LH0Q
         XR96GPE+L1ZJ0zV7Ymvw4TixqOvt4ypshUSocxgjxLfwZQxYCjEZwXqqHwUev47grs
         SsnjzXpDdvCpozlaF3iHd2pjj9lbfDc6qSwOC/JL9pgeVGjbg4DT2j2P75vMhzRP1w
         H5PGH0Z9qfBRw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org
Subject: [RFC PATCH liburing v1 2/2] nolibc: Simplify function naming
Date:   Thu, 24 Nov 2022 12:46:16 +0700
Message-Id: <20221124054345.3752171-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124054345.3752171-1-ammar.faizi@intel.com>
References: <20221124054345.3752171-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Define malloc() and free() as __uring_malloc() and __uring_free() with
macros when CONFIG_NOLIBC is enabled. This way the callers will just
use malloc() and free() instead of uring_malloc() and uring_free().

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h   | 22 +++-------------------
 src/setup.c |  6 +++---
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 5a9b87c..a3081da 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -37,29 +37,13 @@
 #define __hot			__attribute__((__hot__))
 #define __cold			__attribute__((__cold__))
 
+#ifdef CONFIG_NOLIBC
 void *__uring_memset(void *s, int c, size_t n);
 void *__uring_malloc(size_t len);
 void __uring_free(void *p);
 
-static inline void *uring_malloc(size_t len)
-{
-#ifdef CONFIG_NOLIBC
-	return __uring_malloc(len);
-#else
-	return malloc(len);
-#endif
-}
-
-static inline void uring_free(void *ptr)
-{
-#ifdef CONFIG_NOLIBC
-	__uring_free(ptr);
-#else
-	free(ptr);
-#endif
-}
-
-#ifdef CONFIG_NOLIBC
+#define malloc(LEN)		__uring_malloc(LEN)
+#define free(PTR)		__uring_free(PTR)
 #define memset(PTR, C, LEN)	__uring_memset(PTR, C, LEN)
 #endif
 
diff --git a/src/setup.c b/src/setup.c
index d918f86..324f76b 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -215,7 +215,7 @@ __cold struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	int r;
 
 	len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
-	probe = uring_malloc(len);
+	probe = malloc(len);
 	if (!probe)
 		return NULL;
 	memset(probe, 0, len);
@@ -224,7 +224,7 @@ __cold struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	if (r >= 0)
 		return probe;
 
-	uring_free(probe);
+	free(probe);
 	return NULL;
 }
 
@@ -245,7 +245,7 @@ __cold struct io_uring_probe *io_uring_get_probe(void)
 
 __cold void io_uring_free_probe(struct io_uring_probe *probe)
 {
-	uring_free(probe);
+	free(probe);
 }
 
 static inline int __fls(unsigned long x)
-- 
Ammar Faizi

