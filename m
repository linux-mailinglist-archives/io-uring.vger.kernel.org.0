Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56BA53E3BB
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiFFGMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiFFGMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:37 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E1B218F
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:35 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id B087D7FA06;
        Mon,  6 Jun 2022 06:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495954;
        bh=aYSYkE3+A9+TQ9CjZcrIwWINA1KMjk4o3Pj624qbx9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKgXS9W7DpL5Zbn2vq0fzWgB45CUAemHtGxOol3J7pn/fsxEWuKcY6QfpSCWzdzY5
         Q4udYurkf70JGkhticxVoD3ZhDmit62+nXEys+Ji7zIsqzSJ3IJHbDeaGpGPkdmV0+
         rSub8mvbOt2WE3Af1YSAbxB3xKDF6FXipGv8Y2ugjB4I0dhYiybub60A72cG//xTqv
         GxyNgpZceGHRWvtqgGTnQy1h+WWygG22eatysBIPt9zbVG6ktSnSj9YhoGlN2ukLxp
         +XCVqI14WhgHWcP6jDHVMCY//qj4Kh+U35iFGg3a/Pbc+SYZIYwJwCw908CWLnTjUY
         H6gbIS17J6PDA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 1/5] lib: Don't indent in `#ifdef -> #define -> #endif` block
Date:   Mon,  6 Jun 2022 13:12:05 +0700
Message-Id: <20220606061209.335709-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
References: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
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

Follow the surrounding code style.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 6672cc5..5dabd28 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -23,14 +23,14 @@
 
 
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

