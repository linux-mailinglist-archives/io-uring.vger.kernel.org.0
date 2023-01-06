Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C310A6603B7
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 16:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjAFPwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 10:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjAFPwU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 10:52:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7705911A27
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 07:52:19 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id A65F97E51F;
        Fri,  6 Jan 2023 15:52:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673020339;
        bh=QaFA/PFZVrWHpLbUPPChboMLcuyCxW3JGVxmlBUo5uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQHhEyhaeaxincCwJeezghgRhnDKuk1E8d1Ui1A9XfQHiJRqINfTBXCMbfE3A2+9J
         BGduiMmwKCGMMcEtAvxBmWVjqbZYEBUhOnqUwbK295CGFcPzXmQCg+DDpji4aRw/wU
         84xu45DCESifJ81CW5fRuRsEKAORpMZveXzP4tuAiGpsmwQp64Xj9X8Zemf5VcF1mF
         GiflpNiDVZvzI3z5nEQsxCCnbxJe2uYZ3JkF39D4DTLbix0RnDKcV31OBDjQj+Tbdl
         I2V9bQabHy1viS12uc4FVv81cjB4GclovYecSS8m+iQJ5ZrWXH7NT4J6ZOcJx5BKLH
         xngZarPV+AP1Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [RFC PATCH liburing v1 1/2] github: Remove nolibc build on the GitHub CI bot
Date:   Fri,  6 Jan 2023 22:52:01 +0700
Message-Id: <20230106155202.558533-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106155202.558533-1-ammar.faizi@intel.com>
References: <20230106155202.558533-1-ammar.faizi@intel.com>
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

This is a preparation patch to deprecate `--nolibc` configure option.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index c2aa3e6..f18f069 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -117,16 +117,6 @@ jobs:
         ./configure --cc=${{matrix.cc}} --cxx=${{matrix.cxx}};
         make -j$(nproc) V=1 CPPFLAGS="-Werror" CFLAGS="$FLAGS" CXXFLAGS="$FLAGS";
 
-    - name: Build nolibc
-      run: |
-        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "i686" || "${{matrix.arch}}" == "aarch64" ]]; then \
-            make clean; \
-            ./configure --cc=${{matrix.cc}} --cxx=${{matrix.cxx}} --nolibc; \
-            make -j$(nproc) V=1 CPPFLAGS="-Werror" CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"; \
-        else \
-            echo "Skipping nolibc build, this arch doesn't support building liburing without libc"; \
-        fi;
-
     - name: Test install command
       run: |
         sudo make install;
-- 
Ammar Faizi

