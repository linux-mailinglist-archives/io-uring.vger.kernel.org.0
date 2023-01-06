Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8AC6603B8
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 16:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjAFPwY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 10:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjAFPwX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 10:52:23 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A911A27
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 07:52:22 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id C7B9E7E41C;
        Fri,  6 Jan 2023 15:52:19 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673020342;
        bh=P9xWc8JRTwJuvDZNiI0hkbuuk8tWAvyw91Blr0so0Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXetpVTr4HM7ejH/C4xU0Ceh4dhGCIvORP5qWXSxfo10ihD6hrnjlTp9ycso3mTfV
         /V4mLEwjVahPJ/Cp8GxmptRFTq5DM2MqsShxAw8Bx0WQNSuzWKgGZAAyLaorbUpl8p
         czvty4VeAFzaA7FZDCXVLFD5g0Qvc8ZueFlddwj87rPnnhg6azHCPCW2JXZnfftBV1
         5glIzHETGRK905WfBkWvSKpGbn5LNLf22JQ8yzEO9Zp58DSybBqIGyrLK2I3KB0Xnv
         oVJ0tWAukaPV58x7F2J38pw+SHNCdz7uQi0A9nSNlOWZ+0RNB9Invw9WGvk5OmDykZ
         32BDxejID3P3A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [RFC PATCH liburing v1 2/2] configure: Always enable `CONFIG_NOLIBC` if the arch is supported
Date:   Fri,  6 Jan 2023 22:52:02 +0700
Message-Id: <20230106155202.558533-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106155202.558533-1-ammar.faizi@intel.com>
References: <20230106155202.558533-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Currently, the default liburing compilation uses libc as its dependency.
liburing doesn't depend on libc when it's compiled on x86-64, x86
(32-bit), and aarch64. There is no benefit to having libc.so linked to
liburing.so on those architectures. Always enable CONFIG_NOLBIC if the
arch is supported. If the architecture is not supported, fallback to
libc.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 configure | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 4d9e99c..2033e6f 100755
--- a/configure
+++ b/configure
@@ -5,6 +5,22 @@ set -e
 cc=${CC:-gcc}
 cxx=${CXX:-g++}
 
+#
+# TODO(ammarfaizi2): Remove this notice and `--nolibc` option.
+#
+nolibc_deprecated() {
+  echo "";
+  echo "=================================================================";
+  echo "";
+  echo "  --nolibc option is deprecated and has no effect.";
+  echo "  It will be removed in a future liburing release.";
+  echo "";
+  echo "  liburing on x86-64, x86 (32-bit) and aarch64 always use CONFIG_NOLIBC.";
+  echo "";
+  echo "=================================================================";
+  echo "";
+}
+
 for opt do
   optarg=$(expr "x$opt" : 'x[^=]*=\(.*\)' || true)
   case "$opt" in
@@ -26,7 +42,7 @@ for opt do
   ;;
   --cxx=*) cxx="$optarg"
   ;;
-  --nolibc) liburing_nolibc="yes"
+  --nolibc) nolibc_deprecated
   ;;
   *)
     echo "ERROR: unknown option $opt"
@@ -385,13 +401,27 @@ fi
 print_config "NVMe uring command support" "$nvme_uring_cmd"
 
 #############################################################################
+#
+# Currently, CONFIG_NOLIBC is only enabled on x86-64, x86 (32-bit) and aarch64.
+#
+cat > $TMPC << EOF
+int main(void){
+#if defined(__x86_64__) || defined(__i386__) || defined(__aarch64__)
+  return 0;
+#else
+#error libc is needed
+#endif
+}
+EOF
+if compile_prog "" "" "nolibc support"; then
+  liburing_nolibc="yes"
+fi
+print_config "nolibc support" "$liburing_nolibc";
+#############################################################################
+
 if test "$liburing_nolibc" = "yes"; then
   output_sym "CONFIG_NOLIBC"
-else
-  liburing_nolibc="no"
 fi
-print_config "liburing_nolibc" "$liburing_nolibc"
-
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
 fi
-- 
Ammar Faizi

