Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7571C501E85
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 00:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiDNWoj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 18:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347120AbiDNWoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 18:44:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB7C6B6F
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 15:42:12 -0700 (PDT)
Received: from integral2.. (unknown [36.80.217.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 3D0407E39E;
        Thu, 14 Apr 2022 22:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649976131;
        bh=0BPHA/7yUhP2Ljy1cKy+kqXx0mIZf2dQuhwHFIlhYnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+4/L/wRheJaoMdP80V6NWEeMdS9Y7reinmERxZtkXGgBo5HANUtOIC9+HDtHgje+
         K/WA4v+bcGpA0MG0s8Jes5Ex1PHkyyCDJGEqODWVsd6kILcQjeZgeEPhWjNV+cGRsq
         3pUIHe7KBkJK5CtbpK5rH1x4V7UrN8E7UZ6ZJog3ppeVSN2YpRQhB5T/nmLzgeSybX
         Otyz1K9M7AmcgB0Bk1NzU3906YW4BM+3WtaGiGW5AqcKnPSybru87ZcEX7Q0HnJblV
         onsOM8yI69sraIWmCvIAkJJRZrRqC7MsBd4Bg0ClRhBMHpEgeaeaq/BV+aQg/ydrTn
         VGtgGDhMTWPAA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing 2/3] arch/x86/lib: Provide `get_page_size()` function for x86 32-bit
Date:   Fri, 15 Apr 2022 05:41:39 +0700
Message-Id: <20220414224001.187778-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414224001.187778-1-ammar.faizi@intel.com>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
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

A preparation to add nolibc support for x86 32-bit. Provide
get_page_size() function for x86 32-bit.

x86 32-bit and x86-64, both have the same page size 4K, and they can
share the same function definition. Just remove the #ifdef here.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/x86/lib.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
index bacf74e..e6a74f3 100644
--- a/src/arch/x86/lib.h
+++ b/src/arch/x86/lib.h
@@ -7,26 +7,9 @@
 #ifndef LIBURING_ARCH_X86_LIB_H
 #define LIBURING_ARCH_X86_LIB_H
 
-#if defined(__x86_64__)
-
 static inline long get_page_size(void)
 {
 	return 4096;
 }
 
-#else /* #if defined(__x86_64__) */
-
-/*
- * For x86 (32-bit), fallback to libc wrapper.
- * We can't use CONFIG_NOLIBC for x86 (32-bit) at the moment.
- *
- * TODO: Add x86 (32-bit) nolibc support.
- */
-#ifdef CONFIG_NOLIBC
-	#error "x86 (32-bit) is currently not supported for nolibc builds"
-#endif
-#include "../generic/lib.h"
-
-#endif /* #if defined(__x86_64__) */
-
 #endif /* #ifndef LIBURING_ARCH_X86_LIB_H */
-- 
Ammar Faizi

