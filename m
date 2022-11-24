Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A41637346
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiKXIBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiKXIBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:49 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED15C6611
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:48 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id D1B9C816FF;
        Thu, 24 Nov 2022 08:01:44 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276908;
        bh=I8+aPRh++xFhEmPVgD+jVUkqZVdfhhklZ90+OLkmncE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJtpFAMrVlWU5FM4cAulJ8XV2htCkp/nyWEXhujh+DvzGNLZKileiMv+Aq2BtYSWw
         hi0dmE2sGO+ezgdxVT+0+qVj54KohYn4onpXMTD0t1cLjDOHjs+dnjzkphLCPYCW3O
         qlgNSLJHLIovPUSJCAMehNTm+UhNqQoUjHy7k0aBqxmmtpbzCRpFzIdhJ0EB13nQRJ
         qujP0267+ovIyuD1A2viX/LHlvoN/N4J+p2HXv2e8XATi/oL/n+OhH+TnP8uDfDHe1
         ss8H7zbVlPU9bW2yCINwlwoQFZYOutxdt0zvfkCN9IBZaFvihvk9R7bShFr25xHwnw
         f9Jud+s1oghBQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 6/7] test/Makefile: Omit `-Wmissing-prototypes` from the C++ compiler flags
Date:   Thu, 24 Nov 2022 15:01:01 +0700
Message-Id: <20221124075846.3784701-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124075846.3784701-1-ammar.faizi@intel.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
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

