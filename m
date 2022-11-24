Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC181637344
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKXIBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiKXIBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:45 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4858D1C30
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:44 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id D267381712;
        Thu, 24 Nov 2022 08:01:40 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276904;
        bh=PiYQQILwWUGqPy72iXWcKsCfm2nayS/FojzHuMN10q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUyapkpegtof5aiJGNi+iOJZbsrxrC79AYGqPnlMZRPiEui7X/4ADXgdfm1Rcv7pl
         Di3iFVGCRDhJl1yfmC4EUPoxpQkYEtR0J9j+ITFqxaXrOWeIKJbCCFcnBnTZ2RbwpS
         uAHLkiJt+sruGyedbmGy4yicqaM3KEQP6jpJhGzDEdVzcsT/WTYI7v2Pa2BLsqOhcW
         RrMnk4y3HlxbSRiwXhvv4tcKKM5AOuRnO1pVR+JK8GsOQojCIGmNSfW4l7oi57yH3h
         QAA29Cf1FoIAdAtCSjeIWGaOfgh0TEY/1+zZHkWjZHwbrRc0ypxQ5s2XYl8Ze9iqYs
         oQT+prihRGKbw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 5/7] ucontext-cp: Mark internal functions as static
Date:   Thu, 24 Nov 2022 15:01:00 +0700
Message-Id: <20221124075846.3784701-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124075846.3784701-1-ammar.faizi@intel.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
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

Functions that are not used outside the translation unit should be
static.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/ucontext-cp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/ucontext-cp.c b/examples/ucontext-cp.c
index ed3b342..d17aae7 100644
--- a/examples/ucontext-cp.c
+++ b/examples/ucontext-cp.c
@@ -68,7 +68,7 @@ DEFINE_AWAIT_OP(readv)
 DEFINE_AWAIT_OP(writev)
 #undef DEFINE_AWAIT_OP
 
-int await_delay(async_context *pctx, time_t seconds)
+static int await_delay(async_context *pctx, time_t seconds)
 {
 	struct io_uring_sqe *sqe = io_uring_get_sqe(pctx->ring);
 	struct io_uring_cqe *cqe;
-- 
Ammar Faizi

