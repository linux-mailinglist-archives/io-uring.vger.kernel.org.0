Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E08637DA0
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiKXQ3k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKXQ3j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:39 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090D017027F
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:39 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 2982B8175E;
        Thu, 24 Nov 2022 16:29:34 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307378;
        bh=PiYQQILwWUGqPy72iXWcKsCfm2nayS/FojzHuMN10q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2HTO/9q5Hh7ZrllC2zIIgS/59lQ4MhFDLOYE3V/gUFYyYHe5HzjhhaVtUhTt0+Wb
         vgfQW5dr32fLwxDPfVJnFBatR5xeah+Ta78LsBNKoVvsZVWdfrq3axAcSKwKIBLdHi
         xDibxg58/zrjYhPXv9zu+//OoH2RVxPR98kgHt4RvWuP0IKj1uw7Fi2/d+0beTzlqo
         5GgbWRxe5nP6g96YklwT/MDpQarwUmWP60r80EIpf8ezyYjwf6CdEEdIeI8vSa8+Xz
         x2mF/zjH3294D1cYkeFVHlNPzIHw2ujtTAncj2i9bRi8YqxVSSw0Fnv/WA/zkISzlx
         9Eo2jQZYoJMuA==
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
Subject: [PATCH liburing v2 6/8] ucontext-cp: Mark a non-exported function as static
Date:   Thu, 24 Nov 2022 23:28:59 +0700
Message-Id: <20221124162633.3856761-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
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

