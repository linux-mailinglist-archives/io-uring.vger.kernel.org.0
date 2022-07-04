Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD013565E04
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiGDTco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 15:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiGDTco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 15:32:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB92DFC9
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 12:32:43 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 6529A804A9;
        Mon,  4 Jul 2022 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656963163;
        bh=FveaZGALRuvhoMHrWSZliK1bwLSB96JV/GOf2wakANQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEQNP+LDBVdkivvq/9hflrZHMvU/wkJbt6ACP/2nlCi00qQ9r/vg8j5kvQ7Utpz/6
         fXgj15yKO8uJLeN14OZl98uTCb8bTAtfcG9cxuPlxcTfMsp9foYT7z3U3PyOlJExBr
         o9FJGng7Swxm8ThS4OLR5cN3F1OEU8XWGCyHtak7GAEbjH0CiwYS/g5i7ZrAbtPeMp
         HnVX+2fQB3Ah1hSaEFTgmre+j+JFqBBhqqMB7kZGWpVbzw/yiLUGCVjL71+lUtbBHH
         nWaysaSY/N71e+uyXb5Q4yYlIAKXIr62NMM5fJrXfKEuxwl364yJIer013XRoUqCJV
         Kq7gMyBOYcwCw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v4 07/10] lib: Enable nolibc support for aarch64
Date:   Tue,  5 Jul 2022 02:31:52 +0700
Message-Id: <20220704192827.338771-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704192827.338771-1-ammar.faizi@intel.com>
References: <20220704192827.338771-1-ammar.faizi@intel.com>
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

A previous patch adds get_page_size() function which is the missing bit
for aarch64 nolibc support. Now we have a full set of functions to
enable nolibc build support for aarch64.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/lib.h b/src/lib.h
index a966c77..f347191 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -8,6 +8,8 @@
 
 #if defined(__x86_64__) || defined(__i386__)
 #include "arch/x86/lib.h"
+#elif defined(__aarch64__)
+#include "arch/aarch64/lib.h"
 #else
 /*
  * We don't have nolibc support for this arch. Must use libc!
-- 
Ammar Faizi

