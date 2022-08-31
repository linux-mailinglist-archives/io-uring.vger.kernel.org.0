Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C95A72EC
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 02:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiHaAsq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 20:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiHaAsq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 20:48:46 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83374E842;
        Tue, 30 Aug 2022 17:48:44 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.75.186])
        by gnuweeb.org (Postfix) with ESMTPSA id 64C2C80B6D;
        Wed, 31 Aug 2022 00:48:41 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661906924;
        bh=+8I1uumCWG1OkrBQHCAZBfQtlAsV5zytkdAHrr1UCts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR3ZQBDFUxxu0VnGOCRSGBr+IyvM6ZsVN2L97BFzFci5RbETlAu/W4QIFGjom7ehg
         Dk2cPk5t6xMeusYheeT/ONtEFfsb4KTH+c1kNnTZxnp4/ZCbtazIkOkdAaSlfF5niS
         Gj2Vfg2VDQvkeuDod5IwvKHVtrPWWTMohXq/MZVeq2rXxm0WV46phgQvtlTI9NQvuJ
         xF6AbEMhB2MV+4WkHUGHn53XL0Q9yzD5VYeeXtZFkf3eMiHce+da9rpYd1DmSRFISn
         zJQgzIqr7JQ5sTznRc+scEXttOlGc86+rg2o6/G7j5Cre08gGBg4bTKO3DeaaCJrwg
         mX2pXfzgA4odA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/3] github bot: Upgrade clang version to 16
Date:   Wed, 31 Aug 2022 07:48:15 +0700
Message-Id: <20220831004449.2619220-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831004449.2619220-1-ammar.faizi@intel.com>
References: <20220831004449.2619220-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

clang-16 is now available, use it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 333929c..2608644 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -91,15 +91,15 @@ jobs:
       uses: actions/checkout@v2
 
     - name: Install Compilers
       run: |
         if [[ "${{matrix.cc_pkg}}" == "clang" ]]; then \
             wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh; \
-            sudo bash /tmp/llvm.sh 15; \
-            sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 400; \
-            sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 400; \
+            sudo bash /tmp/llvm.sh 16; \
+            sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-16 400; \
+            sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 400; \
         else \
             sudo apt-get update -y; \
             sudo apt-get install -y ${{matrix.cc_pkg}} ${{matrix.cxx_pkg}}; \
         fi;
 
     - name: Display compiler versions
-- 
Ammar Faizi

