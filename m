Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70645A72EF
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 02:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiHaAsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 20:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiHaAst (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 20:48:49 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE256F262;
        Tue, 30 Aug 2022 17:48:48 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.75.186])
        by gnuweeb.org (Postfix) with ESMTPSA id A913180B71;
        Wed, 31 Aug 2022 00:48:44 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661906927;
        bh=iBes758DU4Vy6f+oLSWxX6fPMaaegbn7oMLvUt/NqyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvG3K52V2xFj9l+0F6oortTAxl2OB6f874/jQ3eNby89r4j/+ciyDJ0+BaT+ZhO+O
         R0knMJRw8G8bb9ta/pgdo8bxu727ZcdnR2z8ZOnlVI1XpEFqriNWe53095Gg4RV0rA
         feIqYgiZK9uaEnbhB/gCZayJeOGwUulNQsiU1b+WerKl2OW3iUdpxw8Yeifetvkw47
         BwW71GS4MO3N3gR6qR3dlPh+9Tg3GZlzehbm5opUfHiRnVml3J4myvFfU151gfGk/C
         I+1QMtFm6xWYsMTlLolPZMfw8kZvGvRYbb+qhQeXxo0560ofOfyvJZrTX5eiIC+J1r
         /c7iEHrVYJW4g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/3] CHANGELOG: Note about `io_uring_{enter,enter2,register,setup}`
Date:   Wed, 31 Aug 2022 07:48:16 +0700
Message-Id: <20220831004449.2619220-3-ammar.faizi@intel.com>
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

Commit f0b43c84cb3d1 ("syscall: Add io_uring syscall functions")
exports 4 new functions. Mention it in the CHANGELOG file.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 1 +
 1 file changed, 1 insertion(+)

diff --git a/CHANGELOG b/CHANGELOG
index 9c054b0..1f37e92 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,9 +1,10 @@
 liburing-2.3 release
 
 - Support non-libc build for aarch64.
+- Add io_uring_{enter,enter2,register,setup} syscall functions.
 
 
 liburing-2.2 release
 
 - Support non-libc builds.
 - Optimized syscall handling for x86-64/x86/aarch64.
-- 
Ammar Faizi

