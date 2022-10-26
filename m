Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5D60EC0C
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 01:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJZXOD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Oct 2022 19:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJZXOA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Oct 2022 19:14:00 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FF08D216
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 16:13:59 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t4so11266435wmj.5
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 16:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2WrTugIcdNs4nMY6CBHKJh4z2Pixco8CZGbHxnRnNM=;
        b=Uor6syvk0vXrBsk8LaM4RzWm1LoKEs3cxwJ3+rt1pjjcpY7MzoU/7mBqk0qBfftK4A
         XpRLY9zqj/zgZBo/bdK2eIeEW85RA/6RxOyxJgpN/VdXPVuhTIWNHQFs7WmioQo8Af99
         iA+AdC8TyXr7nDyMArxtthMfrlo/b4tfC1XVTj6qdSdlsCWOP6XeyjuioYmBzExI+OhD
         MTu23+mJu06RW054MalE6uV/fOT5r53O9bng/L+OI6PZyqAkxBntQsRVi9AJ8qBW4iAV
         6mmmG8vIV2u4N5EomCBCN6P0q/qS12ZNXruHk1YNmiyJy7PlzqoTqIvdHcBnvFr5EC5j
         4bng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w2WrTugIcdNs4nMY6CBHKJh4z2Pixco8CZGbHxnRnNM=;
        b=WQjvrHX+QMBM5Wc/vuI0nJ4oB7Qg0N8IPxzKFp88b2c1IBY4gFcPEfWsfBPiSEWHds
         n0d3SDwBoWChsbQX80o4ZnmU3eIOlZRGAlIMvSf7Vb7eaIsrA4L017YuUTcVkM9gR7De
         426MnZS9EiX9BiQASUPiUAR0YLu2qknergiA/DzHh3Qv2f8XGUz0HrJSlax/CY000E7L
         BdysWLm//LneTuAM+XqA94zYh44l2WyaQjXx7vT9sXcWij7yFhXBRynGK/sKyJXBO5Ps
         B08zZySr7sj6YCtmTU8O/v85yu3WG+GiXYE97VokNIWPaoy42PSksbpQPmaoQyBvIncP
         n3PA==
X-Gm-Message-State: ACrzQf1H6g6Ev+e0UopZxJuStUKemeZZNULZ27wGVnt8NOhq45WuokGS
        OTwk4T5B8JCi73mXVYBdxKPV83q1JM9IjA==
X-Google-Smtp-Source: AMsMyM6n+qSppJ/3G1xfATu3yUblZAEX3W6e1quqV/tRtVtC1KnsCBXgIOAEs7q/ATjHy9nQUfUFrw==
X-Received: by 2002:a05:600c:1d95:b0:3c6:fc59:5ed0 with SMTP id p21-20020a05600c1d9500b003c6fc595ed0mr3762644wms.21.1666826037569;
        Wed, 26 Oct 2022 16:13:57 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id h13-20020adfe98d000000b0022ccae2fa62sm6137670wrm.22.2022.10.26.16.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:13:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing-next 1/1] tests: test both TCP ends in send zc tests
Date:   Thu, 27 Oct 2022 00:13:00 +0100
Message-Id: <83dce097a9930b47788cc5c14a9f19b0f901146e.1666807018.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test sending data from both ends of a TCP connection to tests any
modifications need for zc in the accept path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index a061d49..5030d63 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -445,14 +445,17 @@ static int test_inet_send(struct io_uring *ring)
 	int sock_client = -1, sock_server = -1;
 	int ret, j, i;
 
-	for (j = 0; j < 16; j++) {
+	for (j = 0; j < 32; j++) {
 		bool ipv6 = j & 1;
 		bool client_connect = j & 2;
 		bool msg_zc_set = j & 4;
 		bool tcp = j & 8;
+		bool swap_sockets = j & 16;
 
 		if (tcp && !client_connect)
 			continue;
+		if (swap_sockets && !tcp)
+			continue;
 
 		ret = prepare_ip(&addr, &sock_client, &sock_server, ipv6,
 				 client_connect, msg_zc_set, tcp);
@@ -460,6 +463,12 @@ static int test_inet_send(struct io_uring *ring)
 			fprintf(stderr, "sock prep failed %d\n", ret);
 			return 1;
 		}
+		if (swap_sockets) {
+			int tmp_sock = sock_client;
+
+			sock_client = sock_server;
+			sock_server = tmp_sock;
+		}
 
 		for (i = 0; i < 4096; i++) {
 			bool regbuf;
-- 
2.38.0

