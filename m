Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98850C126
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiDVViY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiDVViP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFC7409D23
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:41 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id B5CE77E75B;
        Fri, 22 Apr 2022 20:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659767;
        bh=UE3ilkLW293P4Gf65uB6NIMDZtKJe7uK4QkILHO2epI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaLmyvomT6W0+WTviMafT4R26XKlLAA3cEiMjszpzxwzAhzib9Z3gaZrtd4wzOGXt
         KtHtZZ941r8jHxoIssrW3N9JxXSWX/Gi3LDZhugA3GoJ2p86z0hVgjDjI5ZmErr0m+
         NiT/fp4fmH+Aq0MYLEwRge/VZWSzgbea9i8VEMAXvx+0sT1ZBrDD03wdYHfZAwLvvS
         VbtpvmitenEmugFoer5r1XANiRCMXJGjIW9XSGNUJ38zuQSunqqXXpRxaDvO26PJZU
         qEACw5tqeVcNivr1Z2JTtvQb5WZoCwRImYD7VGZ1CerOluksI5DeFkVQ85FWagRcrV
         B0U9FsWujWfKA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 2/6] Makefile: Make sure we build everything before runtests
Date:   Sat, 23 Apr 2022 03:35:38 +0700
Message-Id: <20220422203340.682723-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1499; h=from:subject:message-id; bh=Zq63fjlbAX/vC7X+EFP6VXUuX/HX0u5CSJOpsF5c+Io=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFs2on1PDWL8LtK2zyhHRu7J6fUa+G4oE95E1XB 6lYSlg6JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRbAAKCRA2T7o0/xcKS35gB/ 0SOwMbuO7db6Z65A9vop2Mkvoc6fqkwvzohbG5oAd3fpwd1lVtR9gFeI5WDuNnV4YPhvNJf6kj5Dj7 +KBZALn8zdLrjsXeamYtDiZphC5ocYKK1RbqlrrlCEmM0oU+oqrWQYR+KXtVJHeXHRNUv2qJzZ5uGz Gtgk8nxFzJ1r5gItlzX6C2rBHybUErPp95dXxwn4yPxRaqZAW0hiVMf/ZHlBD4xbWDnAR9NUTn8x16 W9OnJTDbvEOvhPLUCZOyZyZ7wPido3T7Lg9xAo2sOkbg8heUtwZjnITE0svU2WaLUgRuf61PYIzQ7Y 79jEBJUvi17nYdW3tczYWll5MnAmct
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

A recent commit added `runtests-parallel` target to run the tests in
parallel. But it doesn't have a proper build dependency.

As such, when doing:

  make -j clean;
  make -j runtests-parallel;

we got this error:

```
  make[1]: Entering directory '/home/ammarfaizi2/app/liburing/test'
  make[1]: *** No rule to make target '232c93d07b74.t', needed by '232c93d07b74.run_test'.  Stop.
  make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/test'
  make: *** [Makefile:25: runtests-parallel] Error 2
```

Add `all` target as the dependency of `runtests-parallel`. While in
there, I found the same issue on `runtests-loop` target. Do the same
thing for it too. This way the main Makefile will build everything
first before trying to execute the tests.

Cc: Dylan Yudaken <dylany@fb.com>
Fixes: 4fb3c9e9c737c2cf2d4df4e1972e68d596a626f7 ("Add runtests-loop target")
Fixes: 6480f692d62afbebb088febc369b30a63dbc2ea7 ("test: add make targets for each test")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d54551e..686be4f 100644
--- a/Makefile
+++ b/Makefile
@@ -19,9 +19,9 @@ partcheck: all
 
 runtests: all
 	@$(MAKE) -C test runtests
-runtests-loop:
+runtests-loop: all
 	@$(MAKE) -C test runtests-loop
-runtests-parallel:
+runtests-parallel: all
 	@$(MAKE) -C test runtests-parallel
 
 config-host.mak: configure
-- 
Ammar Faizi

