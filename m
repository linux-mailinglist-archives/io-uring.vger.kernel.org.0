Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18B9696A2C
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 17:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBNQrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 11:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjBNQrA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 11:47:00 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721B92CFF7
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 08:46:44 -0800 (PST)
Received: from gnuweeb.org (unknown [51.81.211.47])
        by gnuweeb.org (Postfix) with ESMTPSA id 8C8858301E;
        Tue, 14 Feb 2023 16:46:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1676393203;
        bh=Agx3WsvAdlpkvMZO/4c4jlRV85Ljbzg/RJp7B8gfe6c=;
        h=From:To:Cc:Subject:Date:From;
        b=ULmEihceQLcA4gg3O08BVbyyDZk5RNgTmj6cMcnGwYWZPBS2MrZ6jMmFf6P1nKS3q
         nDVM+IfM4iDANvLx2fEuWVHleZu0VPW3SB/HD1Cza0oDjVtDNmBO11LIGuoJ81cSxf
         /xG5TVxDNMpi+jdTDnuzGc3sSoEHWmZ7NC5GOU+E/9H9ER1jtn5YcKpSg5aDd0nN9O
         lgAH8Edyltcg6+v7sdpVZxduFEXydDInWUvFiLQeMohdUBEmYD4drDYQRBgrzvBGQ3
         bqaXXdNdTdKypsUMD6zivn+tZyIYXFLUdQ0goekB/0ArOf9ym4tc5jAoquWGWmN7zz
         ImHYGm68QxRQg==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dwiky Rizky Ananditya <kyzsuki@gnuweeb.org>
Subject: [PATCH] test/fsnotify: Skip fsnotify test if sys/fanotify.h not available
Date:   Tue, 14 Feb 2023 16:46:13 +0000
Message-Id: <20230214164613.2844230-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
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

Fix build on Termux (Android). Most android devices don't have
<sys/fanotify.h> on Termux. Skip the test if it's not available.

Reported-by: Dwiky Rizky Ananditya <kyzsuki@gnuweeb.org>
Tested-by: Dwiky Rizky Ananditya <kyzsuki@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 configure       | 19 +++++++++++++++++++
 test/fsnotify.c | 13 ++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index e9b7f882f0707e64..28f3eb0aee24f9ea 100755
--- a/configure
+++ b/configure
@@ -419,6 +419,22 @@ fi
 print_config "nolibc support" "$liburing_nolibc";
 #############################################################################
 
+####################################################
+# Most Android devices don't have sys/fanotify.h
+has_fanotify="no"
+cat > $TMPC << EOF
+#include <sys/fanotify.h>
+int main(void)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "fanotify"; then
+  has_fanotify="yes"
+fi
+print_config "has_fanotify" "$has_fanotify"
+####################################################
+
 if test "$liburing_nolibc" = "yes"; then
   output_sym "CONFIG_NOLIBC"
 fi
@@ -452,6 +468,9 @@ fi
 if test "$nvme_uring_cmd" = "yes"; then
   output_sym "CONFIG_HAVE_NVME_URING"
 fi
+if test "$has_fanotify" = "yes"; then
+  output_sym "CONFIG_HAVE_FANOTIFY"
+fi
 
 echo "CC=$cc" >> $config_host_mak
 print_config "CC" "$cc"
diff --git a/test/fsnotify.c b/test/fsnotify.c
index b9b6926ced937c5f..d672f2cc2c3ff27c 100644
--- a/test/fsnotify.c
+++ b/test/fsnotify.c
@@ -2,6 +2,10 @@
 /*
  * Description: test fsnotify access off O_DIRECT read
  */
+
+#include "helpers.h"
+
+#ifdef CONFIG_HAVE_FANOTIFY
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -11,7 +15,6 @@
 #include <sys/wait.h>
 
 #include "liburing.h"
-#include "helpers.h"
 
 int main(int argc, char *argv[])
 {
@@ -99,3 +102,11 @@ out:
 		unlink(fname);
 	return err;
 }
+
+#else /* #ifdef CONFIG_HAVE_FANOTIFY */
+
+int main(void)
+{
+	return T_EXIT_SKIP;
+}
+#endif /* #ifdef CONFIG_HAVE_FANOTIFY */
-- 
Alviro Iskandar Setiawan

