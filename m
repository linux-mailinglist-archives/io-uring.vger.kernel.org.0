Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE56273A71A
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjFVRUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjFVRUr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:20:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5B32122;
        Thu, 22 Jun 2023 10:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687454443;
        bh=BRDGujV5bASaXtU4sheMv8CYwhxietJD+x2yxoDCxrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=pm4EJdOucz/QFIs9qx8AhSqVSkcNTrceYPjxeRkf5mWBx/zlgPp/7qB4g2jIyAL2f
         5erRWGGOrF9hmU60mA7EHt/hTsxOczh8vmbwhR4WQuyNAWBQULOKk4IEOfhvW9qfyL
         BnIqudSH/5s/2Yg23Dv7GHn0nvPb7l6u30yU+UrC4u7PhdsG1XPimEDQWcWAMlTQ2m
         lzL0anzjOmJyoqRhyB4nGRVS+zMXBlAmngtKnLUEo2sYbb1G63met3FH4CWKZWf2JV
         aqeI79+C2po8v+CsTeUCy0AwPMLv7DLF36WmsqsuK+6PdBaEcD4VhGdYhuXIg/Gru7
         AEr5/1J/Mo7gw==
Received: from integral2.. (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 77D11249C7A;
        Fri, 23 Jun 2023 00:20:40 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Matthew Patrick <ThePhoenix576@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 2/3] configure: Introduce '--use-libc' option
Date:   Fri, 23 Jun 2023 00:20:28 +0700
Message-Id: <20230622172029.726710-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
References: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
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

Currently, when compiling liburing on x86, x86-64, and aarch64
architectures, the resulting binary lacks the linkage with the standard
C library (libc).

To address the concerns raised by Linux distribution package maintainers
regarding security, it is necessary to enable the linkage of libc to
liburing. Especially right now, when the security of io_uring is being
scrutinized. By incorporating the '--use-libc' option, developers can
now enhance the overall hardening of liburing by utilizing compiler
features such as the stack protector and address sanitizer.

Link: https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
Link: https://lore.kernel.org/io-uring/20230621100447.GD2667602@fedora
Link: https://lore.kernel.org/io-uring/ZJLkXC7QffsoCnpu@thunder.hadrons.org
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Guillem Jover <guillem@hadrons.org>
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 configure | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index a16ffca83d678364..46afb7285a1ea8d0 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,8 @@ for opt do
   ;;
   --cxx=*) cxx="$optarg"
   ;;
+  --use-libc) use_libc=yes
+  ;;
   *)
     echo "ERROR: unknown option $opt"
     echo "Try '$0 --help' for more information"
@@ -73,6 +75,7 @@ Options: [defaults in brackets after descriptions]
   --datadir=PATH           install shared data in PATH [$datadir]
   --cc=CMD                 use CMD as the C compiler
   --cxx=CMD                use CMD as the C++ compiler
+  --use-libc               use libc for liburing (useful for hardening)
 EOF
 exit 0
 fi
@@ -382,10 +385,13 @@ fi
 print_config "NVMe uring command support" "$nvme_uring_cmd"
 
 #############################################################################
-#
-# Currently, CONFIG_NOLIBC is only enabled on x86-64, x86 (32-bit) and aarch64.
-#
-cat > $TMPC << EOF
+liburing_nolibc="no"
+if test "$use_libc" != "yes"; then
+
+  #
+  # Currently, CONFIG_NOLIBC only supports x86-64, x86 (32-bit) and aarch64.
+  #
+  cat > $TMPC << EOF
 int main(void){
 #if defined(__x86_64__) || defined(__i386__) || defined(__aarch64__)
   return 0;
@@ -394,10 +400,13 @@ int main(void){
 #endif
 }
 EOF
-if compile_prog "" "" "nolibc support"; then
-  liburing_nolibc="yes"
+
+  if compile_prog "" "" "nolibc"; then
+    liburing_nolibc="yes"
+  fi
 fi
-print_config "nolibc support" "$liburing_nolibc";
+
+print_config "nolibc" "$liburing_nolibc";
 #############################################################################
 
 ####################################################
-- 
Ammar Faizi

