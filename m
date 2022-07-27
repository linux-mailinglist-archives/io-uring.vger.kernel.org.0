Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A905829BD
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiG0Pef (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiG0Pec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:32 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B11237F4
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:31 -0700 (PDT)
Received: (qmail 15389 invoked by uid 989); 27 Jul 2022 15:27:48 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 9/9] meson: update available examples to liburing 2.3
Date:   Wed, 27 Jul 2022 17:27:23 +0200
Message-Id: <20220727152723.3320169-10-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999993)
X-Rspamd-Score: -5.599993
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:48 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use an array of sources instead of declaring each example individually.

Add examples introduced by Pavel and Dylan in 82001392, c1d15e78 and 61d472b.

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 examples/meson.build | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/examples/meson.build b/examples/meson.build
index becfc02..e7f5daf 100644
--- a/examples/meson.build
+++ b/examples/meson.build
@@ -1,17 +1,19 @@
-executable('io_uring-cp',
-           'io_uring-cp.c',
-           dependencies: uring)
-
-executable('io_uring-test',
-           'io_uring-test.c',
-           dependencies: uring)
-
-executable('link-cp',
-           'link-cp.c',
-           dependencies: uring)
+example_sources = [
+  'io_uring-cp.c',
+  'io_uring-test.c',
+  'io_uring-udp.c',
+  'link-cp.c',
+  'poll-bench.c',
+  'send-zerocopy.c',
+]
 
 if has_ucontext
-    executable('ucontext-cp',
-               'ucontext-cp.c',
-               dependencies: uring)
+  example_sources += ['ucontext-cp.c']
 endif
+
+foreach source: example_sources
+    name = source.split('.')[0]
+    executable(name,
+               source,
+               dependencies: uring)
+endforeach
-- 
2.37.1

