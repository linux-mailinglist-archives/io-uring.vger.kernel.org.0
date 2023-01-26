Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FA867D1A0
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 17:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjAZQbJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Jan 2023 11:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAZQbI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Jan 2023 11:31:08 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4880A3597
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 08:31:03 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y15so1689060edq.13
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 08:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HleuoVRiyuggowpxKmLHjzrYpuoCE0ItvrD1lq6Te2s=;
        b=o6OzgOddZItmy5v693ShoU4gQZoCU/etmwwSMIGDs6dl3pzPGkza8WBsnQ07dhDkbl
         lMsEC3ddSSVXbGllXWHt0E5XcsAB3TZutsN5TZYMua9ZyYAXdgEvFd8hqlu+CM+ns/Xo
         rHXRbWEJPqWRteGZSHm8txPK1fGtJrDfplopc9b4MB9Mvz5iJ3N1T1Frky1Wsn96mQUk
         ZrNlK2KcWB/N8DGXh1O/sK3Ih29iaYQyNZq5DwQ+qGZrNaM0lqzBAXtXFlLDoVLq6N+4
         4uqf8a4bO/dVs1NkYmbJJOgVkUBNBc2fRiAjJZsNIBHrEWY7+h4WXxbasDIcwJ/HS8Wt
         XBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HleuoVRiyuggowpxKmLHjzrYpuoCE0ItvrD1lq6Te2s=;
        b=GMx44FAjZZ81efTtrhMUanNGS4MEj70R4sJlDelaaTMAdKjPaAW5CfBy3b/JDWFQD4
         71LNK+vudm+2qEKqDr2zA99Z4MFZlWDBQnZ1OgTdK4HWKIHmXAf6JDA5pshFG+42OSRQ
         Objz3npUbCSuCvEuWNYIVJqqso/udegx1qNUz33X88kUvThxaDIxZm3jhDmJOtDDs0qy
         xXmFJ+c2yBIze2Mk+SeDIBVGJpLaTvW0rH8cERSEF8Gy40S9xHUUg7RicCBBr1jF8vTb
         2V8Lp2vff3OFrj2FDHjeMgGD6IImfdoLZ1Bkh6L13LvOyMWUX8YmLgJ5UR2Cfc+4nrwT
         S3Vw==
X-Gm-Message-State: AO0yUKWsGmL3v5PKEav8d9Y/gn+GLm7ICQO8UOp1/BTR6XR+uVD/X+Xe
        CKLT4AHoTisVNmembImIi7lS4xlInuA=
X-Google-Smtp-Source: AK7set/NCzBaEmO04yjg3ei5sSbdDFgxeKWktCOGZ41XaB+li+HG3Apm+lqveMvWmvJrYQPgBVTJaw==
X-Received: by 2002:a05:6402:481:b0:4a0:b554:c26c with SMTP id k1-20020a056402048100b004a0b554c26cmr4978671edv.21.1674750661535;
        Thu, 26 Jan 2023 08:31:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:63ae])
        by smtp.gmail.com with ESMTPSA id dn10-20020a05640222ea00b00482b3d0e1absm942072edb.87.2023.01.26.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 08:31:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 1/1] test: fix parallel send-zerocopy
Date:   Thu, 26 Jan 2023 16:29:46 +0000
Message-Id: <a8ab36c6126de3a0595c1b27e610fc203d076461.1674750570.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Dylan reported that running send-zerocopy in parallel often fails,
seems to trigger regardless whether it's zc or not. The problem here
is using the same port for all programs, let the kernel to select it.

Reported-by: Dylan Yudaken <dylany@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 16830df..ab56397 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -40,7 +40,6 @@
 
 #define MAX_MSG	128
 
-#define PORT	10200
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
@@ -190,7 +189,8 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 				bool ipv6, bool client_connect,
 				bool msg_zc, bool tcp)
 {
-	int family, addr_size;
+	int family;
+	socklen_t addr_size;
 	int ret, val;
 	int listen_sock = -1;
 	int sock;
@@ -201,14 +201,14 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 
 		family = AF_INET6;
 		saddr->sin6_family = family;
-		saddr->sin6_port = htons(PORT);
+		saddr->sin6_port = htons(0);
 		addr_size = sizeof(*saddr);
 	} else {
 		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
 
 		family = AF_INET;
 		saddr->sin_family = family;
-		saddr->sin_port = htons(PORT);
+		saddr->sin_port = htons(0);
 		saddr->sin_addr.s_addr = htonl(INADDR_ANY);
 		addr_size = sizeof(*saddr);
 	}
@@ -223,16 +223,19 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 		perror("socket");
 		return 1;
 	}
-	val = 1;
-	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
-	val = 1;
-	setsockopt(sock, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 
 	ret = bind(sock, (struct sockaddr *)addr, addr_size);
 	if (ret < 0) {
 		perror("bind");
 		return 1;
 	}
+
+	ret = getsockname(sock, (struct sockaddr *)addr, &addr_size);
+	if (ret < 0) {
+		fprintf(stderr, "getsockname failed %i\n", errno);
+		return 1;
+	}
+
 	if (tcp) {
 		ret = listen(sock, 128);
 		assert(ret != -1);
-- 
2.39.1

