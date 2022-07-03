Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6854B564739
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiGCMAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 08:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 08:00:32 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5494AAE50
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 05:00:31 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 9227B80216;
        Sun,  3 Jul 2022 12:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656849631;
        bh=w5s6oUerDDFvYFFlLAPyXpc38jkhxolT3M5gD97Lyaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MulVqdwUVTWGEfl1Tq6ISM5cNRl0fCJiOaNI6aA3N+WlXpv2JR1nj736EWL6KKTIn
         edSyFNgqMD0ziZG0yBiCkXGI8k5gBE5J4rLXbz+Mj2XExycCPuY0MSOwCV0ftAI7uM
         VWGtkcpjc0L6IjVhTfcofArmcAeTDSD3CfYtdSFY4ecOaDYgakSjHG3xRIwjzBxGBG
         8lsj1/8GXh1KxBmQqSu5zYyjuLr4I/O4keKKPlif39T1Wad+GOWOK488U7U90JjNU4
         Bw0aoQIjlLXz2f9wZad496F/RNcu0UIL9imWMAe9LrIEn/3SnqxUlCtmhRQfPYnFV6
         +TdBs3xbcQjhw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/2] lib: Add __hot and __cold macros
Date:   Sun,  3 Jul 2022 18:59:11 +0700
Message-Id: <20220703115240.215695-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220703115240.215695-1-ammar.faizi@intel.com>
References: <20220703115240.215695-1-ammar.faizi@intel.com>
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

A prep patch. These macros will be used to annotate hot and cold
functions. Currently, the __hot macro is not used, we will only use
the __cold macro at the moment.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/lib.h b/src/lib.h
index 5844cd2..89a40f2 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -34,6 +34,8 @@
 #endif
 
 #define __maybe_unused		__attribute__((__unused__))
+#define __hot			__attribute__((__hot__))
+#define __cold			__attribute__((__cold__))
 
 void *__uring_malloc(size_t len);
 void __uring_free(void *p);
-- 
Ammar Faizi

