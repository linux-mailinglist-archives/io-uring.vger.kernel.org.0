Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46633650F54
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiLSPxm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiLSPxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCF1E5A
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:48 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 2C2F88191C;
        Mon, 19 Dec 2022 15:50:45 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465048;
        bh=3KScUysxnhrfiadv4/f41SW2hPuPIQ2i6Q69sW6VId4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdnmOzVZKktJSC5JwmXZNJkj9/++Jmbg/ifsKuB3+YC5AOEZFwXUsUiaFe+xHG6G8
         rdUdJ9rKksCMdxxHv59fYEkSGkYhOBZipZ/DEWiS+exJMFm7Z3WK43YZz/3Czfrssb
         u0LAzPumHG0FqlxfME5IXcLZCphs9O3PLgJs2+t7OchZvYAikn/MEQI2Ul574Bku9m
         qGzLeUeajx4BzcnXLQVyBhJR3Z4sUISM6yqusuhPcAyseVEYgV1fwsflgTjjQXffjO
         UZAmh/bh56qFKXxGeGEGLbKB25rLLBU048BxVd2Wo/BlHFH+R+gKxlehw5qdQwNBpG
         +1VyLtuRGpvOA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 7/8] github: Add more extra flags for clang build
Date:   Mon, 19 Dec 2022 22:49:59 +0700
Message-Id: <20221219155000.2412524-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
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

Add these 4 flags:

  -Wstrict-prototypes
  -Wunreachable-code-loop-increment
  -Wunreachable-code
  -Wmissing-variable-declarations

for stricter clang build.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 4c0bd26..c2aa3e6 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -20,21 +20,21 @@ jobs:
             cc: x86_64-linux-gnu-gcc
             cxx: x86_64-linux-gnu-g++
 
           # x86-64 clang
           - arch: x86_64
             cc_pkg: clang
             cxx_pkg: clang
             cc: clang
             cxx: clang++
             liburing_extra_flags: -Wshorten-64-to-32
-            extra_flags: -Wmissing-prototypes
+            extra_flags: -Wmissing-prototypes -Wstrict-prototypes -Wunreachable-code-loop-increment -Wunreachable-code -Wmissing-variable-declarations
 
           # x86 (32-bit) gcc
           - arch: i686
             cc_pkg: gcc-i686-linux-gnu
             cxx_pkg: g++-i686-linux-gnu
             cc: i686-linux-gnu-gcc
             cxx: i686-linux-gnu-g++
 
           # aarch64 gcc
           - arch: aarch64
-- 
Ammar Faizi

