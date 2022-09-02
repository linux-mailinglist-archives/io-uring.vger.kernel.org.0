Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC6C5AA899
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiIBHQE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiIBHQD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:16:03 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C189250725
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:16:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id BC97180C38;
        Fri,  2 Sep 2022 07:15:57 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102961;
        bh=fB/SGSBw+8SZhNANAbgH+HD11RWuT2SAsbQ2ZNOIGLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSbLiMsWBY5yKtSLcrjP2QWCPHCuaD03SbnWVZGJEDYJNpSaBz85v7U4Wytjul2bA
         BWj1CBt6hfBHbM3F4ATQh2svj69MkOSMmXE/FxJz2IITHkRCNkOXdKA2h6fL86pQz2
         MW8ArP7BpMdVTCC1+g8eLpRctoaetDKqNcocYWkKfSZTXNfadnNsoJR52FSlq5+ptL
         goCbOqt2AYOgTTepoSOlFggeR9R6mRr0Yu4UX+Lfs/vHLioeJJt1qAui+PgOVg0dWf
         8yAwAMvT1gfhyjv7S9Myi1qzd3J2pSh0F881YfWxUfnmUrJCq3e5O/ifbIR4uaJQ58
         OrRAwrjY+D4zw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing v2 08/12] t/connect: Don't use a static port number
Date:   Fri,  2 Sep 2022 14:15:01 +0700
Message-Id: <20220902071153.3168814-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902071153.3168814-1-ammar.faizi@intel.com>
References: <20220902071153.3168814-1-ammar.faizi@intel.com>
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

Don't use a static port number. It might already be in use, resulting
in a test failure. Use an ephemeral port to make this test reliable.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/accept.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index b35ded4..1821faa 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -190,19 +190,16 @@ static int start_accept_listen(struct sockaddr_in *addr, int port_off,
 
 	struct sockaddr_in laddr;
 
 	if (!addr)
 		addr = &laddr;
 
 	addr->sin_family = AF_INET;
-	addr->sin_port = htons(0x1235 + port_off);
 	addr->sin_addr.s_addr = inet_addr("127.0.0.1");
-
-	ret = bind(fd, (struct sockaddr*)addr, sizeof(*addr));
-	assert(ret != -1);
+	assert(!t_bind_ephemeral_port(fd, addr));
 	ret = listen(fd, 128);
 	assert(ret != -1);
 
 	return fd;
 }
 
 static int set_client_fd(struct sockaddr_in *addr)
-- 
Ammar Faizi

