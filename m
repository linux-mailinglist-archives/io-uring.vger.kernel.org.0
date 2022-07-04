Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9425565E08
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 21:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGDTc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 15:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiGDTc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 15:32:57 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3A5DFD0
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 12:32:56 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 87C428026A;
        Mon,  4 Jul 2022 19:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656963176;
        bh=zQ5DQmoxSwZ6Mva+LUDQuM5nON1RwWAYQmZoxevo84c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJ+nuuYu8E6XEHJYcaAgP5xHl3qhegOZSC2N3oouhZ5frKkTABoolI1mtLY7ymzms
         d9OUzcfN9Fd6zlKgGmdnlu6C9p57doI62ePWUh/X4Y9qfN9fnELX0CTqfLsiFW7zAA
         GGYTsX5Q4wz+gYvQyB8FH0OzrY9lkRQeZQfKRCf2oTlXYo9jEcX0DBWjnIxpwuz7R9
         Ij/BZhRTreffMDml13+P2a0cGPbC2x0rSfdq+8x7BXaE9972GatiW4s+1p6qUSkEOv
         60qofQpS4ZncYquM04dwygvdxnaNBV0HyKqEqmsmnWxu+pZJ8jfZGpEsLTS9wHRwdO
         0qGhb5mfCNy4Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v4 10/10] CHANGELOG: Note about aarch64 support
Date:   Tue,  5 Jul 2022 02:31:55 +0700
Message-Id: <20220704192827.338771-11-ammar.faizi@intel.com>
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

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/CHANGELOG b/CHANGELOG
index efb3ff3..9c054b0 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,3 +1,8 @@
+liburing-2.3 release
+
+- Support non-libc build for aarch64.
+
+
 liburing-2.2 release
 
 - Support non-libc builds.
-- 
Ammar Faizi

