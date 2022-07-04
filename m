Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8DD565D3E
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiGDRzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiGDRzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:21 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9AABE38
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:21 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 55C6C8022E;
        Mon,  4 Jul 2022 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957321;
        bh=FveaZGALRuvhoMHrWSZliK1bwLSB96JV/GOf2wakANQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj4Vfn6ZRhiDRr+SSQd9DXIifDAxH5QPnPURWBGL7WVEO+lj3kmdVI+xoampd1URD
         xLCcGdg4MAHu8f3OYwShSkz2mr7x9UuFH9qQ6mlZ5HQAzATxyVsapCsUwzbvrvB4du
         Pv3qDYfljw4rW0ipSH33W9XnXqEwU6atJTA/bkn/Hm8uEDf5vwenkaH5YKbYdIPmbR
         uxzhYkJMVTGcxGFudByzItpUePruJgodAPb6KW107LoG5IqTlzU3+Nr2Qg5YI49YRE
         nL6jkK06IvajYA5PHDuPhJUuZ4VqhpEF2NJF5IE1fF4/PhFtmtVcZodGx9F70TBLAi
         RQmNq3MDrmpAg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 07/10] lib: Enable nolibc support for aarch64
Date:   Tue,  5 Jul 2022 00:54:33 +0700
Message-Id: <20220704174858.329326-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704174858.329326-1-ammar.faizi@intel.com>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
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

