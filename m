Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663554F089B
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 11:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiDCJ6V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 05:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiDCJ6U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 05:58:20 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5AD35253
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 02:56:27 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 908847E342;
        Sun,  3 Apr 2022 09:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648979786;
        bh=c2mytYztrEqp9QVP7Z/HjwKEWrWoJYAL8JKacX73oeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl+WWQZnccfBOiJ4fQGYCeQ/fVE1/TKUY61sQbJv83YE1j3c0h3CP2re4vPtjYMxb
         XP71LNUk5J6y8o4m1LWbJcAJW/oR2K+m4bg4JXL8JqbNf/BHJ20x1PneZRnXmDgcFr
         K4UgOErB09iYuZTELei6bmgGeWsQkYD1gWlSzLnjytdvWbQ7ISzz204MXF+R6ZQ/4j
         /iUZVEI2qaND4/3EAK7TaBbELEW/w5REHZe9ou2U2jFTcNF1aCM1SBZIJ4wrprstUN
         ojPtvX3deH9wE9VHRF92m+F8hkp6n2XFRDuuw6Vsj5Nfa6Qfrb1cLP90Z81ATQAm4Q
         dPUFRHYwjAFHA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/2] src/int_flags.h: Add missing SPDX-License-Identifier
Date:   Sun,  3 Apr 2022 16:56:01 +0700
Message-Id: <20220403095602.133862-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
References: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
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

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/int_flags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/int_flags.h b/src/int_flags.h
index b9270ae..90505ec 100644
--- a/src/int_flags.h
+++ b/src/int_flags.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: MIT */
 #ifndef LIBURING_INT_FLAGS
 #define LIBURING_INT_FLAGS
 
-- 
Ammar Faizi

