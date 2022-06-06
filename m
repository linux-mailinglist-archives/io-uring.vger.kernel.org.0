Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1353E317
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiFFGMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiFFGMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:45 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0BF1838F
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:43 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id 50A877ED7E;
        Mon,  6 Jun 2022 06:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495963;
        bh=rCu1i8LhhlOrdGzVPKASiSeqaLaUQwOx8jlREhrRbJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLFpC+ugkfj7xCmDohna4yz+shAWwP88Sh8PqRMBBzEUliow1ZieJl1mrztrpdnei
         WhzS2ZX3sHDeD+mSV9mObTxK2bl+CuGLuglvL96WX9Ql4wVxYdAJqWiiMOUUTC5rwn
         6+N/M+i6h0QTASsfQJqUkIVC62GXHVZ2FUvFdxJ0OaW5WXy/ap4JxOrg6uexCu3GnG
         1KcqxmkXyea9Y0m64syZ0wINC+ZnAkjrIPkurt+STA4OAJYaa1ot4bivpXcZx9podw
         koD8J9pHid16YibeStzgpj4YRtxdHEb9hoPvovxSciJEMTniMo+S/BE/JGOphLGqeN
         TLIrPubMzYHIg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 3/5] lib: Add `sizeof_field()` macro
Date:   Mon,  6 Jun 2022 13:12:07 +0700
Message-Id: <20220606061209.335709-4-ammarfaizi2@gnuweeb.org>
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
index 40e2817..0db7499 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -26,6 +26,10 @@
 #define BUILD_BUG_ON(EXPR) static_assert(!(EXPR), "!(" #EXPR ") failed")
 #endif
 
+#ifndef sizeof_field
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+#endif
+
 #ifndef offsetof
 #define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
 #endif
-- 
Ammar Faizi

