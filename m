Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4475829B7
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiG0Pea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiG0Pe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:29 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5529C237D9
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:28 -0700 (PDT)
Received: (qmail 15183 invoked by uid 989); 27 Jul 2022 15:27:45 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>,
        Eli Schwartz <eschwartz@archlinux.org>
Subject: [PATCH liburing 5/9] meson: add default test setup running each test once
Date:   Wed, 27 Jul 2022 17:27:19 +0200
Message-Id: <20220727152723.3320169-6-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.997468)
X-Rspamd-Score: -5.597468
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:45 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With this patch running `meson test` in the build directory behaves like
`make -C test runtests`.

To execute the other test suites (running the tests in a loop or in
parallel) run: `meson test --suite=loop` or `meson test --suite=parallel`.

Suggested-by: Eli Schwartz <eschwartz@archlinux.org>
Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 test/meson.build | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/test/meson.build b/test/meson.build
index 4d9b3f3..af394a4 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -197,6 +197,12 @@ foreach test_source: all_tests
          suite: 'parallel')
 endforeach
 
+if meson.version().version_compare('>=0.57')
+  add_test_setup('runtests',
+                 exclude_suites: ['loop', 'parallel'],
+                 is_default: true)
+endif
+
 test_runners = ['runtests.sh', 'runtests-loop.sh', 'runtests-quiet.sh']
 
 foreach test_runner: test_runners
-- 
2.37.1

