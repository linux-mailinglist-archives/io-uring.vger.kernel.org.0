Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0680055F268
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiF2A2s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451B2F65B
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:47 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 73BFA7FE70;
        Wed, 29 Jun 2022 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462526;
        bh=xth/MUDvJ+GnBq5UPBliavkj3h6/xeBFoQ2W83La9IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=talaTWBQsBjS2bmzzwMD26E/3/h3LBvnnwiUbutRXq4tM+qWSfLhvlAF0h2T/tHzE
         F8YWujo+6JSjx7E2GozcMZj5/OXOezKP12md0rFv4ZVJezuEufia/Nb5CVve5EmEVB
         ODV62PjSovyzZrg6bZ/ZeqR6NK/ZX19bH3/3y0XD8kpF1tYibz3ZA5S99w4W8ALlet
         9S++uNm+UA+h3FLYJ19WNbLVHJ1TivzTgLBFfTT48eKkp6xdjH8t28rd91eh+UOZJS
         BX1Sgj3b2E5WvV+8sjC1SI01B8VxjdcBQu5q4hTQClmYGzCALz4EZDcM5s4d117LtI
         ZxKycQTzh+t1w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 9/9] .github: Enable aarch64 nolibc build for GitHub bot
Date:   Wed, 29 Jun 2022 07:27:53 +0700
Message-Id: <20220629002028.1232579-10-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
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

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 88192ff..fc119cb 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -114,7 +114,7 @@ jobs:
 
     - name: Build nolibc
       run: |
-        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "i686" ]]; then \
+        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "i686" || "${{matrix.arch}}" == "aarch64" ]]; then \
             make clean; \
             ./configure --cc=${{matrix.cc}} --cxx=${{matrix.cxx}} --nolibc; \
             make -j$(nproc) V=1 CPPFLAGS="-Werror" CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"; \
-- 
Ammar Faizi

