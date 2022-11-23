Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517DC635F18
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbiKWNNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKWNNL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:13:11 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92999FCDF5
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:59 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 58093816F7;
        Wed, 23 Nov 2022 12:54:13 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208057;
        bh=AceEeefFFeGB0qMzUO5w2GRK4sjEAwRSlatli7g4VE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfqQ0rJ/iaZj+DGrhpBMcxjl/siasdPVdgUwjQGo3bR1Ps5T1JurQ8hHlxJKan3YF
         mmVzizqUE9ri4pyxgvZRCB6rIIYj4W2L1dX+aKpPKNtKQs1M5sim9Iwh5xjohQRh1Q
         FSWwpvhp5lh8+4HC28+ctxOaG1izJqeOVmUOyIr5x5DMeM1VL9NVdntHr9+4+0bu1z
         +aU8vZlPJbUxWMNJk4tt1+Ru4cipOXuLdO3iHdeNmJrGfHFkIICsw3e2OTdId52H7Q
         Mk0OE7K/HPks9pNp5+tKAY5tpw5lyux5rj1XHRXQVGpe9IcxVYVNHCC5ABj/9KhY46
         RVaotgHfrwuuw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 5/5] register: Remove useless branch in register restrictions
Date:   Wed, 23 Nov 2022 19:53:17 +0700
Message-Id: <20221123124922.3612798-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123124922.3612798-1-ammar.faizi@intel.com>
References: <20221123124922.3612798-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

IORING_REGISTER_RESTRICTIONS doesn't return a positive value. This
branch is useless. Remove it.

[1]: io_register_restrictions

Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/io_uring.c#L3665-L3733 [1]
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/register.c b/src/register.c
index 6075f04..5fdc6e5 100644
--- a/src/register.c
+++ b/src/register.c
@@ -239,12 +239,9 @@ int io_uring_register_restrictions(struct io_uring *ring,
 				   struct io_uring_restriction *res,
 				   unsigned int nr_res)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-				      IORING_REGISTER_RESTRICTIONS, res,
-				      nr_res);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_RESTRICTIONS, res,
+				       nr_res);
 }
 
 int io_uring_enable_rings(struct io_uring *ring)
-- 
Ammar Faizi

