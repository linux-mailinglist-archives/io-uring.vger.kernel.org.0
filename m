Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871D0565DFE
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 21:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiGDTcU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 15:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGDTcT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 15:32:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277FDDFBA
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 12:32:19 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 3F53E8027E;
        Mon,  4 Jul 2022 19:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656963138;
        bh=2+vkFY/cAwJcxO/eliCRmSw5WdJfTavO74HpsygISOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRP6mJtZc1RrptbK86D2+xQk9wbmtwfDoNNfR69j3LyEcjpVxcyp+SDfq4TzABYSf
         WvBSC37oFAmZsHLkRswckko+/2Lo4BBO4tszhAZ6BcKo3GCUUMIcLNdoVkemHdGPi3
         pGU0b7KJsTVmKcKhp8Xsp5KEWV4TK4YacdKkT0PB2AkI3EM9EqLXMNbr1Q1ZNnTwhf
         JfAwfyVwF/vqLet9gVuQRzFS/5dHIuh8otSKLQi2dr0hTy4fpaQROD6HIU8clSTOsi
         WioN6Zk+9UHWTwC35RuuLNlHVCJ8N18Df76JZxwHReKcxhDqfV9LGH5ptJU3VRfiyB
         05L2dBC170gCQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v4 01/10] CHANGELOG: Fixup missing space
Date:   Tue,  5 Jul 2022 02:31:46 +0700
Message-Id: <20220704192827.338771-2-ammar.faizi@intel.com>
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

