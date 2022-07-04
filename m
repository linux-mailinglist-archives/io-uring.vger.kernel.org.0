Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6E2565D37
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiGDRzB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiGDRzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:01 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB470BF59
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:00 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 6B9F88024B;
        Mon,  4 Jul 2022 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957300;
        bh=2+vkFY/cAwJcxO/eliCRmSw5WdJfTavO74HpsygISOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqS5mR5nNrF1vUjSLaID/YUeU7t4qnVx3w94TTUG64vWC0GqGlusC9w18Gf5m4/Yq
         LkmqwWNgGKqTQGyoANGi/SgNdU7LY1zqmqcuwumDxALayvb7/y/63wFXRyUQbp1dck
         UBDazYMZZj27cu6/Oty/Izj5SC5NPIQKeFs59LGdie96a+Q3iyGql6w00Ylw7nDHxS
         Vo5gy4ar4DR3LMlasyKnoRx7vC0xK3Om8RE8tUk46CM5SuY7BjXQPdSI9leKq0R6Pt
         J79marxpicbpIEtLhN0isxJha9/uH0VMc3cSdm1zolTOYU2Y38DvgrE9WOaMHj4Qz0
         a/+G5O8HgLOfw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 01/10] CHANGELOG: Fixup missing space
Date:   Tue,  5 Jul 2022 00:54:27 +0700
Message-Id: <20220704174858.329326-2-ammar.faizi@intel.com>
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

  s/reducingthe/reducing the/

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CHANGELOG b/CHANGELOG
index 01cb677..efb3ff3 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -6,7 +6,7 @@ liburing-2.2 release
 - Add support for multishot accept.
 - io_uring_register_files() will set RLIMIT_NOFILE if necessary.
 - Add support for registered ring fds, io_uring_register_ring_fd(),
-  reducingthe overhead of an io_uring_enter() system call.
+  reducing the overhead of an io_uring_enter() system call.
 - Add support for the message ring opcode.
 - Add support for newer request cancelation features.
 - Add support for IORING_SETUP_COOP_TASKRUN, which can help reduce the
-- 
Ammar Faizi

