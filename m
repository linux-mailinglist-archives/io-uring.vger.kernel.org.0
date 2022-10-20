Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1458C605F6E
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 13:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJTLxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 07:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJTLxO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 07:53:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F087F7B593
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:53:13 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id 0BCE481101;
        Thu, 20 Oct 2022 11:53:10 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666266793;
        bh=jnZvodqpnnsAyxXZpMTOloEEdBVMnRIQh2CflLouVGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEMZMIRtLfPC68DGZtt3dU1LJXOp6B2jKa77jFYBa0CBXAXSvRuqmy7BWu04ytmdq
         MiwHG2Wk9yJoMa1+uB6sgCZKOVVSLwBTIsahAq7gpw6wLD2FcAnc0n7od6XScMEjK7
         ENOrF7Zw//x3WUEcFZm9kHI2bG1k4/3YYMfHkR/NZrmT3Xfsey3FLPzmps0rnfQ7wi
         +FoXBPXJ5gH/ZslJ/FwnvI+Sw1SFBA9jAK/jigTU6Ac0nWjeXJM4qhhKqCJXMbE2mZ
         UfdGBVeAmDOdkagv5H1E6pIVaDd+/1EzKKJJPv9lKyc4JGadktPYLlhLZ3ZQGvkRqR
         3YOK5jonODAgg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 3/3] github: Append `-Wshorten-64-to-32` flag for clang build
Date:   Thu, 20 Oct 2022 18:52:06 +0700
Message-Id: <20221020114814.63133-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020114814.63133-1-ammar.faizi@intel.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

liburing has a couple of int shortening issues found by clang. A
previous commit has cleaned them up. Integrate -Wshorten-64-to-32
flag to the GitHub bot to spot the same issue in the future.

This flag is clang-specific, it currently doesn't exist in GCC.

Co-authored-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 2608644..b0e669d 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -26,6 +26,7 @@ jobs:
             cxx_pkg: clang
             cc: clang
             cxx: clang++
+            extra_flags: -Wshorten-64-to-32
 
           # x86 (32-bit) gcc
           - arch: i686
@@ -86,6 +87,9 @@ jobs:
     env:
       FLAGS: -g -O3 -Wall -Wextra -Werror
 
+      # Flags for building sources in src/ dir only.
+      LIBURING_CFLAGS: ${{matrix.extra_flags}}
+
     steps:
     - name: Checkout source
       uses: actions/checkout@v2
-- 
Ammar Faizi

