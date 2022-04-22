Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6704C50C119
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiDVViZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiDVViP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF45409D06
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:38 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id AFCCC7E762;
        Fri, 22 Apr 2022 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659771;
        bh=veA7zba2Eq3AjbfAeIDDv5Gj7X5O+rKQOjHA8+hpRG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4zWNQNxg9ApvQqlucOlnJKGNLhs2sDK7zPCueEH3VajztWk3CvQOjC5f+8szDmhB
         Jpw0QsPdhRT7pTtIJlwB+JT3e4GQt09mDs9dZDBlr/+TrOhL2TJ+ppgKgHWmLrmuGz
         MEvpAPwRYUY9FMzuh00K2iVJgFrZ8R5HXKnomGnYVf5muzgLccuO0m61W80M2OHT8E
         HYE/Li4ydew8L+ln5KTEg/M259EYfR8O6T8RV8w8eEV2FfmVAXV1OCTNtCY8IsyN0P
         /DE6dnk+RNhPPoAzYjO4bdjO+6FwJdGmRivpE5qN0DTQfyr2p4TXdTlQFezHwTzeZ9
         yBnbegS99sjmQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 4/6] test/Makefile: Sort the test file list alphabetically
Date:   Sat, 23 Apr 2022 03:35:40 +0700
Message-Id: <20220422203340.682723-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=954; h=from:subject:message-id; bh=7D7xOPmyyLpiIrPzPTCO/iZgPc+4aCwDjzncMWGt9tc=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFs7NHJO7RseUS45tA6rWstoxsHvDs0/rWf9cPZ YdvBGKKJATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRbAAKCRA2T7o0/xcKS1SmB/ 46q6M+I7w1XdLNL/SUINYTHPd/LQenYtsfIes88KvrNbu7E/8SqKR7QeQj7nsQggL6OGtoGH8m0EEw if2aMQoKy9D6JMGxsVNsacroJD+X+iQ4fYXYksYReJjgywQRhDb/2D3MHPuDvem+T67n9Tnm/eW5S4 UHu2gx8ge1dkwhciaRHtvRvTVU2+NzEhTVFCXLZ3wGNA7hxBLTo/1mBz83u+lYQ+JnU6VmmdS/BvQd j1EGwL5oV7j1dBBQ2EMEMgG7t3gomrJn527bhaZxCq8IP5f3tuTP9x73N2B9wq41ycbGkectxGVGIu vBxqoXZNFnApXckKXLtT68FPw00AEY
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
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

Make it easy to manage and find by sorting it alphabetically. Also, add
a comment to remind us to keep it sorted alphabetically.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/Makefile b/test/Makefile
index 444c749..923f984 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -33,6 +33,7 @@ override CXXFLAGS += $(XCFLAGS) -std=c++11 -DLIBURING_BUILD_TEST
 LDFLAGS ?=
 override LDFLAGS += -L../src/ -luring -lpthread
 
+# Please keep this list sorted alphabetically.
 test_srcs := \
 	232c93d07b74.c \
 	35fa71a030ca.c \
@@ -133,6 +134,7 @@ test_srcs := \
 	short-read.c \
 	shutdown.c \
 	sigfd-deadlock.c \
+	skip-cqe.c \
 	socket-rw.c \
 	socket-rw-eagain.c \
 	socket-rw-offset.c \
@@ -159,7 +161,6 @@ test_srcs := \
 	tty-write-dpoll.c \
 	unlink.c \
 	wakeup-hang.c \
-	skip-cqe.c \
 	# EOL
 
 
-- 
Ammar Faizi

