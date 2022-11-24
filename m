Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D3637D9B
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiKXQ3T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXQ3S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:18 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C2D16FB34
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:18 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 4843281754;
        Thu, 24 Nov 2022 16:29:14 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307358;
        bh=lWLuJAgrOcmH7yJVZ5Yi6DKqREayPo1EvH6B5Qi8OO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXYd+mtIXoYA4hRe5LAzXPE/GjTETgQ+3HNiDg/NNCeX0fa6ai0eKnLAVfS8itrQG
         FqVipBN4qWZHl6Ve27hP4+VD1zVbERRkM6g5oiLYGLfKs9niT5ZnsxoDiAvrPe9SDW
         ywYnJ+HULEwDcsL6vW5S/na94J1sdp2BjF0zwuRXc1iNiosNUuPAfVBGe2u0K5oTMV
         iYjQNSyM79LMVlvv+JdieCF9NvrfpuiBoCqcA8HrX7EXJ8fFjiqjXJLZuKCf1GIdhr
         Fa+G8y3Amvs8vDOyZckxPOKQUBMg+bF5OwCMVyw2jNErgfnZ8SushuGYDgqy5wSqn7
         Kp8EDaWDTXg0Q==
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
Subject: [PATCH liburing v2 1/8] queue: Fix typo "entererd" -> "entered"
Date:   Thu, 24 Nov 2022 23:28:54 +0700
Message-Id: <20221124162633.3856761-2-ammar.faizi@intel.com>
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

  s/entererd/entered/

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/queue.c b/src/queue.c
index c06bcc3..feea0ad 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -81,7 +81,7 @@ static int _io_uring_get_cqe(struct io_uring *ring,
 		}
 		if (!cqe && !data->wait_nr && !data->submit) {
 			/*
-			 * If we already looped once, we already entererd
+			 * If we already looped once, we already entered
 			 * the kernel. Since there's nothing to submit or
 			 * wait for, don't keep retrying.
 			 */
-- 
Ammar Faizi

