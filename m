Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A8656646D
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiGEHpj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 03:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiGEHpi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 03:45:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D0E13D2A
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 00:45:37 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 0B555804D1;
        Tue,  5 Jul 2022 07:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657007137;
        bh=zQ5DQmoxSwZ6Mva+LUDQuM5nON1RwWAYQmZoxevo84c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISU7ajVPCULHnRZzFBhH7G4UelUp6k/sEDpLMQVa8NV9RuQryqeazB9l8KcH4Ehe5
         ya9PbUeh2D0AlLAPccUQJgo0vtCZTrJ7wYsgS11nvTtlpr7UOd/xFt5Y8r5F6Z8/t0
         uB69oagSMhVHeFhje19bXX05d2CpPuLK3ALtz5d0J+N1+erMA4WiLK9Y3ZJqLSDhlO
         Pv6SmhMRIQGJOH1nsOygWtXhF+iUg/5lIyOH/SmvO79QKkBtiTdCXgzmeuAqq3jAt6
         8XUnmaGgHDMQaZqd73/5RwIncFc9Xk5YtCx0uwEaIrqgAu6fgxV9ZOpkIT2Y+bd2yW
         aJ2ZxGmKJJ8oA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v5 10/10] CHANGELOG: Note about aarch64 support
Date:   Tue,  5 Jul 2022 14:44:00 +0700
Message-Id: <20220705073920.367794-11-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220705073920.367794-1-ammar.faizi@intel.com>
References: <20220705073920.367794-1-ammar.faizi@intel.com>
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

