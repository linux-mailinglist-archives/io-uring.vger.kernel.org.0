Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F192B69D7E2
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjBUBHL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjBUBHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:09 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF121969
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p3-20020a05600c358300b003e206711347so2026506wmq.0
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9q6Z2EIeHPOpA/P1M1xO/wwloJ7HKSJ8ogHi9NQ5BT8=;
        b=eWLvjE7S5OdY0JFG5uE0YeAB0QfSUPesUe6LEGfvvTjioruI6EMTP763jquErzjAPT
         nsKUTViWwZt0ZOxm1J1V8NwR/tBWrjMi2glaXuViprieF285OeV/iTUB/bpIYZtO5xo8
         2Tr5VXuVQLWSWTVAqXsOkgZlmqeiyd/efoaCvB0Ituuk74iSWMwUWBwEhmDE2I+S+K2x
         3VI+m54MEzM5vt/AWpvAn0dCqUDLz12KUYNZ6lS+SsvcuoaCd1SRPbMgrBSpY4UPqX3D
         S29gGQI2yhMoj7R6brnKINBi4+d9d09nt7ieWwq0Fy7eyC7xrOvor1sU8rgpD6TKrWVh
         cSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9q6Z2EIeHPOpA/P1M1xO/wwloJ7HKSJ8ogHi9NQ5BT8=;
        b=70jfK/zvdUnCyMJo6tbRW8OHrJygyjDHtqGwSGRY4i3YQ1nUVhfbfQRAzudegcGy5s
         TJmh1aFKpC8qDubxvu7twpmc6o3cVMA4G14RlznzOGTZ7F6aOAKQ2B9Rk2n4FncjEnLi
         n9EiyH4q00jNYoIMYTZlf6ACdaR1miBJBabod6bZeck6Vy19/Xb/pI57QTF52gH3WFSt
         9qXwFQXQN+vjhqjmnu2CjVdpvU87TTxy0I0LhxmORaM/aHxcMivDzFLi3TW1AVv7n6DB
         u4O58IOOl1HTCaaqaRIpHXWRzVZ6Rqw0Pb1xs7nJXBu7Q4/+xP7plOo0JUkb9z1TItt1
         3SiQ==
X-Gm-Message-State: AO0yUKUgAXSyZ+FZxqq2v/JKKdUTzmUXyBdYD1iAIvEWA8FQp2C3WUk6
        0XC2REeucdfRP/br2cM0rmlhhFkLQZ0=
X-Google-Smtp-Source: AK7set+mtdMSb2VU1Y6Wpz2pC+qY/G8SlY/TtFVcAPd4zII1nBzMapYy99IozeGk/XfvlVEm1W/Bjw==
X-Received: by 2002:a05:600c:1d16:b0:3df:f860:3089 with SMTP id l22-20020a05600c1d1600b003dff8603089mr2536896wms.32.1676941624400;
        Mon, 20 Feb 2023 17:07:04 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 5/7] test/send: don't use SO_ZEROCOPY if not available
Date:   Tue, 21 Feb 2023 01:05:56 +0000
Message-Id: <ecc68eb72d8aff9bd3b16a0f5a3ea005b25126c3.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index f1277fa..481aa28 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -197,11 +197,9 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 				bool ipv6, bool client_connect,
 				bool msg_zc, bool tcp)
 {
-	int family;
 	socklen_t addr_size;
-	int ret, val;
-	int listen_sock = -1;
-	int sock;
+	int family, sock, listen_sock = -1;
+	int ret;
 
 	memset(addr, 0, sizeof(*addr));
 	if (ipv6) {
@@ -278,11 +276,17 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 		}
 	}
 	if (msg_zc) {
-		val = 1;
+#ifdef SO_ZEROCOPY
+		int val = 1;
+
 		if (setsockopt(*sock_client, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
 			perror("setsockopt zc");
 			return 1;
 		}
+#else
+		fprintf(stderr, "no SO_ZEROCOPY\n");
+		return 1;
+#endif
 	}
 	if (tcp) {
 		*sock_server = accept(listen_sock, NULL, NULL);
@@ -502,7 +506,10 @@ static int test_inet_send(struct io_uring *ring)
 			continue;
 		if (swap_sockets && !tcp)
 			continue;
-
+#ifndef SO_ZEROCOPY
+		if (msg_zc_set)
+			continue;
+#endif
 		ret = create_socketpair_ip(&addr, &sock_client, &sock_server, ipv6,
 				 client_connect, msg_zc_set, tcp);
 		if (ret) {
-- 
2.39.1

