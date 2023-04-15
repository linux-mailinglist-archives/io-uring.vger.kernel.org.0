Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B076E32A5
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjDOQ73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDOQ72 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:59:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50FD3C25;
        Sat, 15 Apr 2023 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577957;
        bh=QWY+Zl3F1B+NIqLmMETedIlIuKxQpaMYeUw+n9XJjn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VPmETBGuOfeU9HhDCmto5vPxpe3Q4+4tGX8NGPX1t+hlE8aGInj9W0c4RjyVnH5qf
         6PG6z0Ln1PBof0KPRRbHYA7b9lOS5ovz6loK1t4ddKrcVXbL21VJ78gNs65fKKvu5Y
         VAQST6SDa+Ha1oUqG6nS+NlpnCHl9a8jqD3yFKykIQJb0RzoKgSRX55ETo15KNH2Ba
         HjyLIAqPquXL7fqEJBOalaewLLnkb0Hec+ca5K+E3ULG9NYA9EcXz6oz352GEcQhIp
         lk+5MTMRAOzz5CoMSQrEjDtLdytmcdS+E3d/e6TTRZv8kTrs1Vbe+cXKcgBp88wXA3
         h1UfZ8SNB52Pg==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id AF4F324552A;
        Sat, 15 Apr 2023 23:59:14 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 1/3] io_uring-udp: Fix the wrong IPv6 binary to string conversion
Date:   Sat, 15 Apr 2023 23:59:02 +0700
Message-Id: <20230415165904.791841-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
References: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
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

Another io_uring-udp fix. The verbose output shows the wrong address
when using IPv6.

When the address family is AF_INET6, the pointer should be cast to
'struct sockaddr_in6', not 'struct sockaddr_in'.

While in there, also add a square bracket around the IP address to
easily read the port number, especially for IPv6.

Before this patch:

    port bound to 49567
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:47048
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:54755
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:57968

(the IPv6 address is wrong)

After this patch:

    port bound to 48033
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:40456
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:50306
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:52291

Link: https://github.com/axboe/liburing/issues/814#issuecomment-1458862489
Fixes: https://github.com/axboe/liburing/issues/814
Fixes: 61d472b51e761e61c ("add an example for a UDP server")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/io_uring-udp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/examples/io_uring-udp.c b/examples/io_uring-udp.c
index b81a5e7c47afd9c8..4697af171ba68999 100644
--- a/examples/io_uring-udp.c
+++ b/examples/io_uring-udp.c
@@ -271,14 +271,22 @@ static int process_cqe_recv(struct ctx *ctx, struct io_uring_cqe *cqe,
 	}
 
 	if (ctx->verbose) {
+		struct sockaddr_in *addr = io_uring_recvmsg_name(o);
+		struct sockaddr_in6 *addr6 = (void *)addr;
 		char buff[INET6_ADDRSTRLEN + 1];
 		const char *name;
-		struct sockaddr_in *addr = io_uring_recvmsg_name(o);
+		void *paddr;
 
-		name = inet_ntop(ctx->af, &addr->sin_addr, buff, sizeof(buff));
+		if (ctx->af == AF_INET6)
+			paddr = &addr6->sin6_addr;
+		else
+			paddr = &addr->sin_addr;
+
+		name = inet_ntop(ctx->af, paddr, buff, sizeof(buff));
 		if (!name)
 			name = "<INVALID>";
-		fprintf(stderr, "received %u bytes %d from %s:%d\n",
+
+		fprintf(stderr, "received %u bytes %d from [%s]:%d\n",
 			io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg),
 			o->namelen, name, (int)ntohs(addr->sin_port));
 	}
-- 
Ammar Faizi

