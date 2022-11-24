Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF63637DA1
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKXQ3q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiKXQ3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:43 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F38170C8F
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:43 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 593DC8173F;
        Thu, 24 Nov 2022 16:29:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307382;
        bh=I8+aPRh++xFhEmPVgD+jVUkqZVdfhhklZ90+OLkmncE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AENnaq1Le1MjsOlT6XtI24kwNjHRaIsjRR+b/KuRQq/8wkmLczo3VW/JrmnBLZ1J0
         LAbVkKQ7tApKgjFTpG3fT87T2dFuTyZVJbFepyirS8ZC9pAaUElLoMcBd8qwMJ3lfr
         XjOfW6dLXtdgWUOe6yaEQZp61GMp/Z2enW54ULCPP/NZDrgH78R2mRyypA1qbnLrd5
         9pQpib7QqfDjGmumbAnn8AeHtnRu5X9E94HJ5yjAnRped5jqXoJqLdYXDUeRZnzI+y
         74611WaTuGTV3tVxCvatD67Bn1CSPbG7gP1Zq07Hvuy+I/ykfwwauiepZRQHphRAMw
         Tr9BdgJ7uMuCQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 7/8] test/Makefile: Omit `-Wmissing-prototypes` from the C++ compiler flags
Date:   Thu, 24 Nov 2022 23:29:00 +0700
Message-Id: <20221124162633.3856761-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
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

This is a preparation patch to integrate -Wmissing-prototypes to the
CI test robot. Clang++ is not happy with -Wmissing-prototypes:

    cc1plus: warning: command-line option '-Wmissing-prototypes' \
    is valid for C/ObjC but not for C++

Omit this flag when we are compiling a C++ source file.

Using -Wmissing-prototypes ensures we mark functions and variables as
static if we don't use them outside the translation unit.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/test/Makefile b/test/Makefile
index 8ad9964..87b1fe1 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -214,8 +214,17 @@ helpers.o: helpers.c
 %.t: %.c $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
+#
+# Clang++ is not happy with -Wmissing-prototypes:
+#
+#   cc1plus: warning: command-line option '-Wmissing-prototypes' \
+#   is valid for C/ObjC but not for C++
+#
 %.t: %.cc $(helpers) helpers.h ../src/liburing.a
-	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
+	$(QUIET_CXX)$(CXX) \
+	$(patsubst -Wmissing-prototypes,,$(CPPFLAGS)) \
+	$(patsubst -Wmissing-prototypes,,$(CXXFLAGS)) \
+	-o $@ $< $(helpers) $(LDFLAGS)
 
 
 install: $(test_targets) runtests.sh runtests-loop.sh
-- 
Ammar Faizi

