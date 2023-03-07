Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCCD6AF6D1
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 21:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCGUjK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 15:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCGUjI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 15:39:08 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC52D97FD4;
        Tue,  7 Mar 2023 12:39:06 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 0E7467E3C0;
        Tue,  7 Mar 2023 20:39:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1678221546;
        bh=Mp/rhC8HIg+j7inL/6xYeQll6B81fY9c8V1MheagYO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3+HBuyqNpRf7N/ZrB56nQ1bmLN/VsgZ6aPzZHMukxR3xjgEHB9cDMcDBZagHCDGD
         klH41erNqp0897Ja5Kz94Ib/Vk7YIX7jlURUcxNARHdDjvXUF9D4as5DDebu5olOAM
         YE+MnCAMxZQEaGT2Mm7V2wzt7u8jVw7n9aqWkKXZR4n8pUBQ+jD25bjlkR3i2epe/V
         qnJx7BOhMjzZgO0TUFX90M09J5l95MRqdOwymOr1408RLKK0jgaHXMsyLXM9xq3Kta
         u8D0F2em8kQe9Ac8qDC4GtVxhOBduBGnk0JvXgp33rRxFn8LHdiT13xFmimymLxzvS
         nex/jJS57MSEg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 1/3] io_uring-udp: Fix the wrong `inet_ntop()` argument
Date:   Wed,  8 Mar 2023 03:38:28 +0700
Message-Id: <20230307203830.612939-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
References: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The verbose output shows the wrong IP address. The second argument of
inet_ntop() should be a pointer to the binary representation of the IP
address. Fix it.

Reported-by: @mczka # A GitHub user
Cc: Dylan Yudaken <dylany@fb.com>
Closes: https://github.com/axboe/liburing/pull/815
Fixes: https://github.com/axboe/liburing/issues/814
Fixes: 61d472b51e761e61c ("add an example for a UDP server")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/io_uring-udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/io_uring-udp.c b/examples/io_uring-udp.c
index a07c3e2a6f20cd17..b81a5e7c47afd9c8 100644
--- a/examples/io_uring-udp.c
+++ b/examples/io_uring-udp.c
@@ -275,7 +275,7 @@ static int process_cqe_recv(struct ctx *ctx, struct io_uring_cqe *cqe,
 		const char *name;
 		struct sockaddr_in *addr = io_uring_recvmsg_name(o);
 
-		name = inet_ntop(ctx->af, addr, buff, sizeof(buff));
+		name = inet_ntop(ctx->af, &addr->sin_addr, buff, sizeof(buff));
 		if (!name)
 			name = "<INVALID>";
 		fprintf(stderr, "received %u bytes %d from %s:%d\n",
-- 
Ammar Faizi

