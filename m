Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4AC637D9E
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiKXQ3b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKXQ3b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:31 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62C6170277
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:30 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id D09A88175E;
        Thu, 24 Nov 2022 16:29:26 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307370;
        bh=IjiWigqeUBXqOFxVyLVTRYHaAHBjdEuLBkIGHoU0ZZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6zIvaQxvBvB2xnnL7KBWtT7ZK5b367vvLbOBhK73HhEICkMbuH3O8vFqZF392v9A
         ZFBC4KWTbqeKXyxHBwiwUbeR3e5GlGgV4APmbhj1/kMne2LJ0oSdpjhsJV5qYZNsOr
         a208DEXwGlDmQiPcir37VAl9+1A8A/SB0cqpWRVWxIoEzHdTQD10a+I6EXxgRnsCNp
         uuGRwfYw2Meourrh0h4/wZ3HBPuWYnWwLQu8a9nMZTBJAP87FbkQmudr0hkoSZ3rnd
         URVkYBR5KzPAquu+X29QphoPFlc11q2jJ9byj4h/z23euKs6dR8r3otWAmVXsSK7Gy
         ju+Tuv9Hp6QNA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 4/8] ucontext-cp: Remove an unused function
Date:   Thu, 24 Nov 2022 23:28:57 +0700
Message-Id: <20221124162633.3856761-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

When marking all internal functions as static after an attempt to
integrate `-Wmissing-prototypes` flag. An unused function is found:

  ucontext-cp.c:71:12: error: ‘await_poll’ defined but not used [-Werror=unused-function]
     71 | static int await_poll(async_context *pctx, int fd, short poll_mask)
        |            ^~~~~~~~~~
  cc1: all warnings being treated as errors
  make[1]: *** [Makefile:36: ucontext-cp] Error 1

Remove it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/ucontext-cp.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/examples/ucontext-cp.c b/examples/ucontext-cp.c
index 281013f..ed3b342 100644
--- a/examples/ucontext-cp.c
+++ b/examples/ucontext-cp.c
@@ -68,23 +68,8 @@ DEFINE_AWAIT_OP(readv)
 DEFINE_AWAIT_OP(writev)
 #undef DEFINE_AWAIT_OP
 
-int await_poll(async_context *pctx, int fd, short poll_mask) {
-	struct io_uring_sqe *sqe = io_uring_get_sqe(pctx->ring);
-	struct io_uring_cqe *cqe;
-	if (!sqe)
-		return -1;
-
-	io_uring_prep_poll_add(sqe, fd, poll_mask);
-	io_uring_sqe_set_data(sqe, pctx);
-	swapcontext(&pctx->ctx_fnew, &pctx->ctx_main);
-	io_uring_peek_cqe(pctx->ring, &cqe);
-	assert(cqe);
-	io_uring_cqe_seen(pctx->ring, cqe);
-
-	return cqe->res;
-}
-
-int await_delay(async_context *pctx, time_t seconds) {
+int await_delay(async_context *pctx, time_t seconds)
+{
 	struct io_uring_sqe *sqe = io_uring_get_sqe(pctx->ring);
 	struct io_uring_cqe *cqe;
 	struct __kernel_timespec ts = {
-- 
Ammar Faizi

