Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C5C53E353
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiFFGM5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiFFGMs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:48 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896EC18B39
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:46 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id 176667FA12;
        Mon,  6 Jun 2022 06:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495966;
        bh=dBOpmAduDiXY4nER9lKHy68iLQirETS3vn0iIYcKfUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEHfMOQ1s0AciECR4nno64ejyGcS3c7Qmypk27VrsEOgtLl/eZiy64OzE543oWdJC
         M3+heluXBBIkxQSOZ9j8H6ujTClHPfFyfVHKoYTKER2lAufuCQTmWl4wgcBXRqmg5t
         aE6mVLrZhjhWDxQ0aF6vsEVn0zt7afRAjjzZukdkZgSoXEeNIYcl4iKfqCWmTsYDK9
         0mNnaMo1up4ARtqs7tnfiT/BmSWwuDbw/yipUeh049h2WCzlfIuw1qRUSPOvFmacG5
         fOK22p2vFtdS0ZcC1qVbjkkSMtBDHGIeMuLrqKCKRZYbcC5qFQTZtVSWZg1mIiAr1q
         Q61XsPT/2SdhA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 4/5] Avoid macro redefinition warnings
Date:   Mon,  6 Jun 2022 13:12:08 +0700
Message-Id: <20220606061209.335709-5-ammarfaizi2@gnuweeb.org>
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

This is a prep patch. The next patch will cause macro redefinition
warnings if we don't have this patch.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/queue.c    | 2 ++
 src/register.c | 2 ++
 src/setup.c    | 2 ++
 src/syscall.c  | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/src/queue.c b/src/queue.c
index ce0ecf6..800ae0c 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: MIT */
+#ifndef _POSIX_C_SOURCE
 #define _POSIX_C_SOURCE 200112L
+#endif
 
 #include "lib.h"
 #include "syscall.h"
diff --git a/src/register.c b/src/register.c
index 993c450..f19a720 100644
--- a/src/register.c
+++ b/src/register.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: MIT */
+#ifndef _POSIX_C_SOURCE
 #define _POSIX_C_SOURCE 200112L
+#endif
 
 #include "lib.h"
 #include "syscall.h"
diff --git a/src/setup.c b/src/setup.c
index d2adc7f..e28560d 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: MIT */
+#ifndef _DEFAULT_SOURCE
 #define _DEFAULT_SOURCE
+#endif
 
 #include "lib.h"
 #include "syscall.h"
diff --git a/src/syscall.c b/src/syscall.c
index 362f1f5..b10f8b0 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: MIT */
+#ifndef _DEFAULT_SOURCE
 #define _DEFAULT_SOURCE
+#endif
 
 /*
  * Functions in this file require libc, only build them when we use libc.
-- 
Ammar Faizi

