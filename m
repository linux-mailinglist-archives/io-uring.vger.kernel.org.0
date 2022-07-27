Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2805829B9
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiG0Ped (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiG0Pea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:30 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8FB1F61F
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:28 -0700 (PDT)
Received: (qmail 15274 invoked by uid 989); 27 Jul 2022 15:27:46 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 7/9] meson: add 'raw' test suite
Date:   Wed, 27 Jul 2022 17:27:21 +0200
Message-Id: <20220727152723.3320169-8-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999422)
X-Rspamd-Score: -5.599422
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:46 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 'raw' test suite runs each compiled test without the runtest*.sh
wrapper scripts.
This is useful to debug tests using meson's gdb support.
To debug a test in gdb run `meson test -C build --suite=raw <testname>_raw`

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 test/meson.build | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/test/meson.build b/test/meson.build
index 1537ad9..088b5fa 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -166,15 +166,15 @@ foreach test_source: all_tests
     # using the meson filesystem module would solve this restriction
     # but require to bump our minimum meson version to '>= 0.54'.
     test_name = test_source.split()[0]
-    executable(test_name,
-               [test_source, 'helpers.c'],
-               c_args: xcflags,
-               cpp_args: xcflags,
-               include_directories: liburing_internal_includes,
-               link_with: liburing.get_static_lib(),
-               dependencies: test_dependencies,
-               install: true,
-               install_dir: get_option('datadir') / 'liburing-test')
+    test_exe = executable(test_name,
+                          [test_source, 'helpers.c'],
+                          c_args: xcflags,
+                          cpp_args: xcflags,
+                          include_directories: liburing_internal_includes,
+                          link_with: liburing.get_static_lib(),
+                          dependencies: test_dependencies,
+                          install: true,
+                          install_dir: get_option('datadir') / 'liburing-test')
 
     test(test_name,
          runtests_sh,
@@ -195,6 +195,10 @@ foreach test_source: all_tests
          args: test_name,
          workdir: meson.current_build_dir(),
          suite: 'parallel')
+
+    test(test_name + '_raw',
+         test_exe,
+         suite: 'raw')
 endforeach
 
 if meson.version().version_compare('>=0.57')
-- 
2.37.1

