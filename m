Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3625829BA
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiG0Ped (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiG0Pea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:30 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB103D58A
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:28 -0700 (PDT)
Received: (qmail 15316 invoked by uid 989); 27 Jul 2022 15:27:47 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 8/9] github bot: add jobs for meson
Date:   Wed, 27 Jul 2022 17:27:22 +0200
Message-Id: <20220727152723.3320169-9-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.876435)
X-Rspamd-Score: -5.476435
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:47 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* Use meson CPU family names in matrix
* Install meson and ninja
* Create a cross compilation file
* Build with meson
* Build nolibc variant with meson
* Test installation with meson

Acked-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 .github/workflows/build.yml | 45 +++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 333929c..95fd892 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -28,7 +28,7 @@ jobs:
             cxx: clang++
 
           # x86 (32-bit) gcc
-          - arch: i686
+          - arch: x86
             cc_pkg: gcc-i686-linux-gnu
             cxx_pkg: g++-i686-linux-gnu
             cc: i686-linux-gnu-gcc
@@ -49,14 +49,14 @@ jobs:
             cxx: arm-linux-gnueabi-g++
 
           # powerpc64
-          - arch: powerpc64
+          - arch: ppc64
             cc_pkg: gcc-powerpc64-linux-gnu
             cxx_pkg: g++-powerpc64-linux-gnu
             cc: powerpc64-linux-gnu-gcc
             cxx: powerpc64-linux-gnu-g++
 
           # powerpc
-          - arch: powerpc
+          - arch: ppc
             cc_pkg: gcc-powerpc-linux-gnu
             cxx_pkg: g++-powerpc-linux-gnu
             cc: powerpc-linux-gnu-gcc
@@ -85,6 +85,8 @@ jobs:
 
     env:
       FLAGS: -g -O3 -Wall -Wextra -Werror
+      MESON_BUILDDIR: build
+      MESON_CROSS_FILE: /tmp/cross-env.txt
 
     steps:
     - name: Checkout source
@@ -114,7 +116,7 @@ jobs:
 
     - name: Build nolibc
       run: |
-        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "i686" || "${{matrix.arch}}" == "aarch64" ]]; then \
+        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "x86" || "${{matrix.arch}}" == "aarch64" ]]; then \
             make clean; \
             ./configure --cc=${{matrix.cc}} --cxx=${{matrix.cxx}} --nolibc; \
             make -j$(nproc) V=1 CPPFLAGS="-Werror" CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"; \
@@ -125,3 +127,38 @@ jobs:
     - name: Test install command
       run: |
         sudo make install;
+
+    - name: Install meson
+      run: |
+        sudo apt-get update -y;
+        sudo apt-get install -y meson;
+
+    - name: Generate meson cross file
+      run: |
+        { \
+          echo -e "[host_machine]\nsystem = 'linux'"; \
+          echo "cpu_family = '${{matrix.arch}}'"; \
+          echo "cpu = '${{matrix.arch}}'"; \
+          echo "endian = 'big'"; \
+          echo -e "[binaries]\nc = '/usr/bin/${{matrix.cc}}'"; \
+          echo "cpp = '/usr/bin/${{matrix.cxx}}'"; \
+        } > "$MESON_CROSS_FILE"
+
+    - name: Build with meson
+      run: |
+        meson setup "$MESON_BUILDDIR" -Dtests=true -Dexamples=true --cross-file "$MESON_CROSS_FILE";
+        ninja -C "$MESON_BUILDDIR";
+
+    - name: Build nolibc with meson
+      run: |
+        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "x86" || "${{matrix.arch}}" == "aarch64" ]]; then \
+            rm -r "$MESON_BUILDDIR"; \
+            meson setup "$MESON_BUILDDIR" -Dnolibc=true -Dtests=true -Dexamples=true --cross-file "$MESON_CROSS_FILE"; \
+            ninja -C "$MESON_BUILDDIR"; \
+        else \
+            echo "Skipping nolibc build, this arch doesn't support building liburing without libc"; \
+        fi;
+
+    - name: Test meson install
+      run: |
+       sudo meson install -C "$MESON_BUILDDIR"
-- 
2.37.1

