Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE4D637DA2
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKXQ3u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKXQ3s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:48 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E71170C88
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:47 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 8155F81735;
        Thu, 24 Nov 2022 16:29:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307387;
        bh=mEI6HC5l2sBw24fjcNUAA4bUPzG2/JQPzrbzIlLPK4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiPz2yf3kXTFTRgy3NC3HG7IY7oGAX45jCqBG2EQ0ApxuxNVkwotFznfsFvW02wV9
         AoZ5q7ZKFEKHTQ+Qf2YDEOMfbuxd6HILpneD+cnfWQ2qYD6RivR/eY6xUbHnNP7B2F
         8GeTha1tU3b/MyQZtB/IkfU9avfC89PFJ6JoEu76guYqdlfhpfQKoTalHNxrqlGLI3
         XSYs6A7EXVTVvQHKpvGbG3bE6Uf0/3VpDPfyLyK2G7ytiL7Wr9St2JtselcMeRgB++
         XCSsBULXsf9MtWDoxvxSPiQw8jtVWmaduknBGqNiCy1kLuftwozNCxWuawyBN58rm8
         zn3wWSKtJupZg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 8/8] github: Add `-Wmissing-prototypes` for GitHub CI bot
Date:   Thu, 24 Nov 2022 23:29:01 +0700
Message-Id: <20221124162633.3856761-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
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
static if we don't use them outside the translation unit.

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

