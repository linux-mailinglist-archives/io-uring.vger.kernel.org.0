Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3688637347
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKXIBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiKXIBx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:53 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7144CC17E
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:52 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id C4C3081352;
        Thu, 24 Nov 2022 08:01:48 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276912;
        bh=XmqNASuTOUfQYepVgge6guKR+RUrIm89rG2vy1bPaFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDZhfJJv4qlvI9QyXxIKxjXgZIP63RVaE4tHZYt66LnAtO6CUQmagaNU2vHZo7jCv
         J2jY7VCln8slp683tAYHxnd4iITdgBmM2zwW2eryOKeYFj87YB0gzfyY08yCvMe7a1
         5y7D6qG89OiSuHyRG167Yj7yDn8IB8ne8XcmEUBdFr9Ysiv3/XywSkibEq7I/Mh2kr
         fYtC0/76Tv5nhhqKItn/DTA1CW5mYTRsJSgjh2ZkcLEBP5dQNMp81DKk9zd60AD/x4
         j5zFX9Pvcf25IHmI3UaioKgUvkwpdeTVa8FN33QK38rGL+9zKfT8LSguyhBcFMSDSb
         PPl/sQ70QwYrg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 7/7] github: Add `-Wmissing-prototypes` for GitHub CI bot
Date:   Thu, 24 Nov 2022 15:01:02 +0700
Message-Id: <20221124075846.3784701-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124075846.3784701-1-ammar.faizi@intel.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Using -Wmissing-prototypes ensures we mark functions and variables as
static if we don't use them outside the translation unit. This
enforcement is good because it hints the compiler to do escape analysis
and optimization better.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index b0e669d..4c0bd26 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -26,7 +26,8 @@ jobs:
             cxx_pkg: clang
             cc: clang
             cxx: clang++
-            extra_flags: -Wshorten-64-to-32
+            liburing_extra_flags: -Wshorten-64-to-32
+            extra_flags: -Wmissing-prototypes
 
           # x86 (32-bit) gcc
           - arch: i686
@@ -85,10 +86,10 @@ jobs:
             cxx: mips-linux-gnu-g++
 
     env:
-      FLAGS: -g -O3 -Wall -Wextra -Werror
+      FLAGS: -g -O3 -Wall -Wextra -Werror ${{matrix.extra_flags}}
 
       # Flags for building sources in src/ dir only.
-      LIBURING_CFLAGS: ${{matrix.extra_flags}}
+      LIBURING_CFLAGS: ${{matrix.liburing_extra_flags}}
 
     steps:
     - name: Checkout source
-- 
Ammar Faizi

