Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF194F0BBA
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 20:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbiDCSYf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359738AbiDCSYe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 14:24:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C302838BC7
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 11:22:40 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id DED6C7E35D;
        Sun,  3 Apr 2022 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649010160;
        bh=oCDwsVKfNM71r1QpM+9S6NUpbCJtPTQA+3vGKHHb4JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBhLMvqFkZryIiXzH30D8Ine/f6B7+lfSGEuUztD41gGDrCnst3FH0hBlYtosfOWW
         CcRtvaMqNCayU4PBmZg5m5KG374gub4p5UJBpBCrrpNNeVCD61cdCczg0TK9xiGmZ5
         ecqBq+jSvcsORX503GoXE0uPzOeh8W/jjdPGJ8xvSUvmWbJx9Cr7SWFfZtfjQLAV/C
         1bIFWG9TGGgU+DY1oh1l718k5JvVt4Ey0/yyFbSwoOTzY+c0rqUxN+LjRI7+lUG3Vq
         JWUTvrmCQxipTeu3gat1/TSE58UiKWVsiaaCxP3ek9sRQD2//uwroWowZrah3/7D5l
         sjnr5QryNxsfA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 2/3] test/Makefile: Append `-lpthread` to `LDFLAGS` for all tests
Date:   Mon,  4 Apr 2022 01:21:59 +0700
Message-Id: <20220403182200.259937-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
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
 test/Makefile | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/test/Makefile b/test/Makefile
index 44a96b2..eb1e7d5 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -31,7 +31,7 @@ override CFLAGS += $(XCFLAGS) -DLIBURING_BUILD_TEST
 override CXXFLAGS += $(XCFLAGS) -std=c++11 -DLIBURING_BUILD_TEST
 
 LDFLAGS ?=
-override LDFLAGS += -L../src/ -luring
+override LDFLAGS += -L../src/ -luring -lpthread
 
 test_srcs := \
 	232c93d07b74.c \
@@ -211,28 +211,6 @@ helpers.o: helpers.c
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 
-35fa71a030ca: override LDFLAGS += -lpthread
-232c93d07b74: override LDFLAGS += -lpthread
-send_recv: override LDFLAGS += -lpthread
-send_recvmsg: override LDFLAGS += -lpthread
-poll-link: override LDFLAGS += -lpthread
-accept-link: override LDFLAGS += -lpthread
-submit-reuse: override LDFLAGS += -lpthread
-poll-v-poll: override LDFLAGS += -lpthread
-across-fork: override LDFLAGS += -lpthread
-ce593a6c480a: override LDFLAGS += -lpthread
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

