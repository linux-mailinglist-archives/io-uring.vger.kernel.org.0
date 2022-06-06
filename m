Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAC53E20A
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiFFGMk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiFFGMk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1FA55B0
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:38 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id 3B2677FA0A;
        Mon,  6 Jun 2022 06:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495958;
        bh=g0hFM7Sftj3Glht2ZLdg1dGmI4JnKxkQ3//5BI8JNPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKO6rFzYp/xP/ebXzpg8ubu/ZmFA2p20lgu9w8QsubV+cbKs+ALWuWaAR4nk8rvBH
         X0uB2SnP5lslZvhtnLKGBHnYpnK25LxAPI066nxDRUs6FNV6qCaW9UY2bP+zpBecHo
         6F5jBL8x4TSQoEz4/pdIxsFPqyNg/+hJgAs9EMSOG5iIj/szUg32KGdFtRvmk5fLOm
         RNkvSep4+jm6jNe6JWl44zHWSSvDdltnSKEz22NsxfM2/214yNMAv1xbbjdocTZSJD
         LLc3qNE2/kmDphaEeRnPW2BsYkaOKHSzmKoP3+SS3ErjNyzf7scLtS2/tC0fZBFkxn
         hxIb9PNPNch7w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 2/5] lib: Add `BUILD_BUG_ON()` macro
Date:   Mon,  6 Jun 2022 13:12:06 +0700
Message-Id: <20220606061209.335709-3-ammarfaizi2@gnuweeb.org>
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

The first use case of this macro is for data structure assertion at
compile time. It's like what we do in the io_uring.c in the kernel.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/lib.h b/src/lib.h
index 5dabd28..40e2817 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <assert.h>
 
 #define __INTERNAL__LIBURING_LIB_H
 #if defined(__x86_64__) || defined(__i386__)
@@ -21,6 +22,9 @@
 #endif
 #undef __INTERNAL__LIBURING_LIB_H
 
+#ifndef BUILD_BUG_ON
+#define BUILD_BUG_ON(EXPR) static_assert(!(EXPR), "!(" #EXPR ") failed")
+#endif
 
 #ifndef offsetof
 #define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
-- 
Ammar Faizi

