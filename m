Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C613B635F16
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiKWNNY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbiKWNNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:13:08 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15341FCDE3
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:57 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id D0DF0816DC;
        Wed, 23 Nov 2022 12:54:08 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208052;
        bh=JK7/UCifqW8wTlavxsrzyY75SQ9viwdXe29FHFo0AQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyyBq2oydhR3Kz9Z52H1d7pKqUwda8+nXClSqv8HltIPGRezDquhT4ukKeVWeutOu
         0CzO7lDj6CAVfiOjfVFuPi4ktLzT470++nQ8X+FHRKeK53L16j6LjNfva6yAd3TTM2
         EzeClH9J0yqWnfXKo8Y+HbLvaci0thu91POwHNtOrLjcABmEfFzDeA9/aX4BZDg/uV
         sdc6E8q/DElMj9SZnX11E/fmw+94i28+NGL4rbZpTVv3Y+gwnyF15oKaBcElt83iV2
         gNMiuQz+mh8w6Zi3O0Mkcbyelb4vB+FwiqtOcmffe1qKc6i9l82rY66yybDhYUqviY
         LxBMdsFw2GFqA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 4/5] register: Remove useless branch in register probe
Date:   Wed, 23 Nov 2022 19:53:16 +0700
Message-Id: <20221123124922.3612798-5-ammar.faizi@intel.com>
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

IORING_REGISTER_PROBE doesn't return a positive value. This branch is
useless. Remove it.

[1]: io_probe

Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/io_uring.c#L3608-L3646 [1]
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/src/register.c b/src/register.c
index c66f63e..6075f04 100644
--- a/src/register.c
+++ b/src/register.c
@@ -219,11 +219,8 @@ int io_uring_register_eventfd_async(struct io_uring *ring, int event_fd)
 int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
 			    unsigned int nr_ops)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE, p,
-				      nr_ops);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE, p,
+				       nr_ops);
 }
 
 int io_uring_register_personality(struct io_uring *ring)
-- 
Ammar Faizi

