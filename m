Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085C6635F12
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbiKWNM5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiKWNMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:12:31 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524C7F8847
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:33 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 70E4B81642;
        Wed, 23 Nov 2022 12:54:04 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208048;
        bh=3fqkhmZgFdmIuypFqGHSrYYYxflG5WO0kGOle4KtvAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4ko4gKjs9lgXOyReOvpOAYSN8PBDGvkeM+MXBT5Yfzk30kJRvTpJSNfa80WBubeC
         dc8JmsI68PY6WOc8lG7PvC9bhffMHS32BhIDH4PTAHaar0En4r/YDBss8Ra+s4vBZG
         Qt+5mdq2i6H1oLqUz7tDAugqcPPmWzIK+rmsjBkAHG4fWQ93ugI675YdpTXWCJG+iO
         hDA1x+/ObzI2VzXbPYDwJmu/2MWX0a1FOD4LjlTsSF3ubxezejCDaqvE9X/C9MczSw
         lL7cM+8gCQhV3qMCuUG/tQcJbAh0sI0v43fd4rxasCccS7TbPHAnqzGMicvecwB/O1
         njQpJJar2jARg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 3/5] register: Remove useless branch in unregister files
Date:   Wed, 23 Nov 2022 19:53:15 +0700
Message-Id: <20221123124922.3612798-4-ammar.faizi@intel.com>
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

IORING_UNREGISTER_FILES doesn't return a positive value. This branch
is useless. Remove it.

[1]: io_sqe_files_unregister

Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/rsrc.c#L787-L805 [1]
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/src/register.c b/src/register.c
index adb64cc..c66f63e 100644
--- a/src/register.c
+++ b/src/register.c
@@ -193,11 +193,8 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
 
 int io_uring_unregister_files(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
-				      NULL, 0);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
+				       NULL, 0);
 }
 
 int io_uring_register_eventfd(struct io_uring *ring, int event_fd)
-- 
Ammar Faizi

