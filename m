Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8936B4F0AB3
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355184AbiDCPlA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiDCPlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:41:00 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B926E3
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:39:05 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 109B27E363;
        Sun,  3 Apr 2022 15:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649000345;
        bh=e+UTO4LVNq7HfBQgE5ie/ha2hc22h/kmYd7zz3Uq1oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crEP25D/vRPB2utC06+ESGaDLoLmM0+kGZwwTrzgQiXv8r5JqBFnYEZaiwxjxfa45
         /Y9TElIj/E7bdcOJ/J+r9gqJa+EXxwtH8VEZR7YjMjjxXhK1M2/jI7EI1K2IRS4sF3
         4DOYL47s1iNRX2vt5QI0hwp7ipPmRsRTYZMbeKyNDEh1D90wAWp4GqYZzX+jBvcQWq
         mINQ04/ShPxUWci66SKc/4Sv18XnDCQhW8RBF3vOP7oLcmXp9huHWfr0iJu95Pn6md
         S3+62ZgaOROwSzVZWN0p+9DMR4Lfssrph2Zoz9GyhvMRafTv9QPZQQ78DQzxh3xzwE
         S9g9ljJKiP8kQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 1/2] test/Makefile: Append -lpthread for all tests
Date:   Sun,  3 Apr 2022 22:38:48 +0700
Message-Id: <20220403153849.176502-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
References: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
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

Instead of overriding LDFLAGS one by one for tests that need pthread,
append -lpthread to LDFLAGS for all tests. This makes the Makefile
script simpler. It also saves some hassle when we add a new test
that does use pthread.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/Makefile | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/test/Makefile b/test/Makefile
index 1526776..e43738f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -31,7 +31,7 @@ override CFLAGS += $(XCFLAGS) -DLIBURING_BUILD_TEST
 override CXXFLAGS += $(XCFLAGS) -std=c++11 -DLIBURING_BUILD_TEST
 
 LDFLAGS ?=
-override LDFLAGS += -L../src/ -luring
+override LDFLAGS += -L../src/ -luring -lpthread
 
 test_srcs := \
 	232c93d07b74-test.c \
@@ -210,29 +210,6 @@ helpers.o: helpers.c
 %: %.cc $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
-
-35fa71a030ca-test: override LDFLAGS += -lpthread
-232c93d07b74-test: override LDFLAGS += -lpthread
-send_recv: override LDFLAGS += -lpthread
-send_recvmsg: override LDFLAGS += -lpthread
-poll-link: override LDFLAGS += -lpthread
-accept-link: override LDFLAGS += -lpthread
-submit-reuse: override LDFLAGS += -lpthread
-poll-v-poll: override LDFLAGS += -lpthread
-across-fork: override LDFLAGS += -lpthread
-ce593a6c480a-test: override LDFLAGS += -lpthread
-wakeup-hang: override LDFLAGS += -lpthread
-pipe-eof: override LDFLAGS += -lpthread
-timeout-new: override LDFLAGS += -lpthread
-thread-exit: override LDFLAGS += -lpthread
-ring-leak2: override LDFLAGS += -lpthread
-poll-mshot-update: override LDFLAGS += -lpthread
-exit-no-cleanup: override LDFLAGS += -lpthread
-pollfree: override LDFLAGS += -lpthread
-msg-ring: override LDFLAGS += -lpthread
-recv-msgall: override LDFLAGS += -lpthread
-recv-msgall-stream: override LDFLAGS += -lpthread
-
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
 	$(INSTALL) -D -m 755 $(test_targets) $(datadir)/liburing-test/
-- 
Ammar Faizi

