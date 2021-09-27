Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD5418E66
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 06:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhI0EkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 00:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhI0EkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 00:40:04 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A565CC061570
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so14388125pjb.2
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=saquoOZNYEkIfhOLEiaeLFyrfQLVvidiVimyOolufNY=;
        b=op9R7jDwzAopRQQ59w4kFTulR5u5poB7yoaBB1tZg3VoBxC1JHylemMYPvar5UBY16
         bjSGPkw+UZFanuBCKdQOrHEmxoJdWtVhbFNSGvrHu5IvTJJG1+XmCA30B6wHqt8rP0v3
         Qey/mDe2F+duM0fc8wd6r963pxNZC9pxqRztXpv0QTKLcp64m4C+HH1xjBzKezzy7kd3
         2BQfLDZft8Uitgcb13nam9FPC1Oj4LqSCeFf+XkBfDFdy006/b9aj5gZyoBYVaqeAQay
         LDnl3tPhUD7gUC6NDC3yKgwXZ3caUG8yi+pz8F2RxnZsyWU/BP0DuWffrUM984ZTfdJ7
         wK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=saquoOZNYEkIfhOLEiaeLFyrfQLVvidiVimyOolufNY=;
        b=XgXvedr4EkMTySyH2Ffq5JyzpCZOxWCRUGAgGDitSmYlaglEIm+ZjjwTfw+TnyvQtA
         QKAf5qF7Eu1X3KVlwy8AyFlupaA27sQZRWD6wz2povMPCfYY7OR1Ctrcf9It5rY/kwJD
         QnExrX0Wx8MgWbUKInh67lO07tWrQtwqbqrO8aMJEbWKkehPVe6URbVBJToiPsf8x/1C
         TDofSxvmJP2imvNXJZT0D4SVwd8fHCYqX4zt2TPAvaslfZV2gRdEqCfGKQ97nSp37GMP
         hOrpa24mYXYwzlL525o0Pb1T2bBOcTpIY+V3LldYOcDzCJcH7GdjtmAbFXQZGyz3NvXX
         UIiQ==
X-Gm-Message-State: AOAM530fvtEx8a6fhEQblQe5KRXsjqbWSeJYMsQO1CoW7KOQA3w78zgO
        3OOAIINODCAat8UURli5XYU=
X-Google-Smtp-Source: ABdhPJwHKTVSoebKOqlVCSdrN63YBHPC/RtIHSBaZtp/cq3AW+Xx4FtWaOwHmaNIZzx5d9IeLJAqrg==
X-Received: by 2002:a17:90b:1e4d:: with SMTP id pi13mr17624777pjb.96.1632717507153;
        Sun, 26 Sep 2021 21:38:27 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id l128sm15623040pfd.106.2021.09.26.21.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 21:38:26 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCH liburing 1/2] test: Fix endianess issue on `bind()` and `connect()`
Date:   Mon, 27 Sep 2021 11:37:43 +0700
Message-Id: <20210927043744.162792-2-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927043744.162792-1-ammarfaizi2@gmail.com>
References: <20210927043744.162792-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we call `bind()` or `connect()`, the `addr` and `port` should be
in big endian value representation.

Portability notes:
  - Do not hard code the address with integer like this `0x0100007fU`.
    Instead, use `inet_addr("127.0.0.1")` to ensure portability for
    the machine with different endianess. It's also cleaner and more
    readable to use `inet_addr()` from `#include <arpa/inet.h>`.

  - Use `htons(port_number)` to make sure the port_number is properly
    choosen instead directly assign it with integer (still about
    endianess problem).

This commit fixes endianess issue in these files:
  test/232c93d07b74-test.c
  test/accept-link.c
  test/accept.c
  test/poll-link.c
  test/shutdown.c
  test/socket-rw-eagain.c
  test/socket-rw.c

Fixes: 08bd815170ab4352d71019f4d3e532cd3f6f0489 ("Un-DOSify test/232c93d07b74-test.c")
Fixes: 4bce856d43ab1f9a64477aa5a8f9f02f53e64b74 ("Improve reliability of poll/accept-link tests")
Fixes: 76e3b7921fee98a5627cd270628b6a5160d3857d ("Add nonblock empty socket read test")
Fixes: 7de625356997dea66826007676224285d407a0fe ("test/accept: code reuse cleanup")
Fixes: 8a3a8d744db428a326e2f54093665411734fa3a8 ("Add IORING_OP_SHUTDOWN test case")
Fixes: e3adbfc235da96ac97a9cafac78292a22eb12036 ("Moves function calls out of assert().")
Suggested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/232c93d07b74-test.c |  9 +++++----
 test/accept-link.c       | 11 +++++++----
 test/accept.c            |  5 +++--
 test/poll-link.c         | 11 +++++++----
 test/shutdown.c          |  5 +++--
 test/socket-rw-eagain.c  |  5 +++--
 test/socket-rw.c         |  5 +++--
 7 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/test/232c93d07b74-test.c b/test/232c93d07b74-test.c
index cd194cb..4153aef 100644
--- a/test/232c93d07b74-test.c
+++ b/test/232c93d07b74-test.c
@@ -19,6 +19,7 @@
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -75,8 +76,8 @@ static void *rcv(void *arg)
 		struct sockaddr_in addr;
 
 		addr.sin_family = AF_INET;
-		addr.sin_port = PORT;
-		addr.sin_addr.s_addr = 0x0100007fU;
+		addr.sin_port = htons(PORT);
+		addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 		res = bind(s0, (struct sockaddr *) &addr, sizeof(addr));
 		assert(res != -1);
 	} else {
@@ -190,8 +191,8 @@ static void *snd(void *arg)
 		struct sockaddr_in addr;
 
 		addr.sin_family = AF_INET;
-		addr.sin_port = PORT;
-		addr.sin_addr.s_addr = 0x0100007fU;
+		addr.sin_port = htons(PORT);
+		addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 		ret = connect(s0, (struct sockaddr*) &addr, sizeof(addr));
 		assert(ret != -1);
 	} else {
diff --git a/test/accept-link.c b/test/accept-link.c
index 605e0ec..f111275 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -11,6 +11,7 @@
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <poll.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -42,7 +43,8 @@ struct data {
 	unsigned expected[2];
 	unsigned just_positive[2];
 	unsigned long timeout;
-	int port;
+	unsigned short port;
+	unsigned int addr;
 	int stop;
 };
 
@@ -63,7 +65,7 @@ static void *send_thread(void *arg)
 
 	addr.sin_family = AF_INET;
 	addr.sin_port = data->port;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	addr.sin_addr.s_addr = data->addr;
 
 	ret = connect(s0, (struct sockaddr*)&addr, sizeof(addr));
 	assert(ret != -1);
@@ -95,11 +97,12 @@ void *recv_thread(void *arg)
 	struct sockaddr_in addr;
 
 	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	data->addr = inet_addr("127.0.0.1");
+	addr.sin_addr.s_addr = data->addr;
 
 	i = 0;
 	do {
-		data->port = 1025 + (rand() % 64510);
+		data->port = htons(1025 + (rand() % 64510));
 		addr.sin_port = data->port;
 
 		if (bind(s0, (struct sockaddr*)&addr, sizeof(addr)) != -1)
diff --git a/test/accept.c b/test/accept.c
index 0c69b98..a4fc677 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -17,6 +17,7 @@
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include "helpers.h"
 #include "liburing.h"
@@ -107,8 +108,8 @@ static int start_accept_listen(struct sockaddr_in *addr, int port_off)
 		addr = &laddr;
 
 	addr->sin_family = AF_INET;
-	addr->sin_port = 0x1235 + port_off;
-	addr->sin_addr.s_addr = 0x0100007fU;
+	addr->sin_port = htons(0x1235 + port_off);
+	addr->sin_addr.s_addr = inet_addr("127.0.0.1");
 
 	ret = bind(fd, (struct sockaddr*)addr, sizeof(*addr));
 	assert(ret != -1);
diff --git a/test/poll-link.c b/test/poll-link.c
index 4b4f9aa..197ad77 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -11,6 +11,7 @@
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <poll.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -42,7 +43,8 @@ struct data {
 	unsigned expected[2];
 	unsigned is_mask[2];
 	unsigned long timeout;
-	int port;
+	unsigned short port;
+	unsigned int addr;
 	int stop;
 };
 
@@ -59,7 +61,7 @@ static void *send_thread(void *arg)
 
 	addr.sin_family = AF_INET;
 	addr.sin_port = data->port;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	addr.sin_addr.s_addr = data->addr;
 
 	if (connect(s0, (struct sockaddr*)&addr, sizeof(addr)) != -1)
 		wait_for_var(&recv_thread_done);
@@ -90,11 +92,12 @@ void *recv_thread(void *arg)
 	struct sockaddr_in addr;
 
 	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	data->addr = inet_addr("127.0.0.1");
+	addr.sin_addr.s_addr = data->addr;
 
 	i = 0;
 	do {
-		data->port = 1025 + (rand() % 64510);
+		data->port = htons(1025 + (rand() % 64510));
 		addr.sin_port = data->port;
 
 		if (bind(s0, (struct sockaddr*)&addr, sizeof(addr)) != -1)
diff --git a/test/shutdown.c b/test/shutdown.c
index 5aa1371..20bcc77 100644
--- a/test/shutdown.c
+++ b/test/shutdown.c
@@ -15,6 +15,7 @@
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -42,8 +43,8 @@ int main(int argc, char *argv[])
 	assert(ret != -1);
 
 	addr.sin_family = AF_INET;
-	addr.sin_port = (rand() % 61440) + 4096;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	addr.sin_port = htons((rand() % 61440) + 4096);
+	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
 	ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
 	assert(ret != -1);
diff --git a/test/socket-rw-eagain.c b/test/socket-rw-eagain.c
index cc87aca..9854e00 100644
--- a/test/socket-rw-eagain.c
+++ b/test/socket-rw-eagain.c
@@ -15,6 +15,7 @@
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -38,10 +39,10 @@ int main(int argc, char *argv[])
 	assert(ret != -1);
 
 	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
 	do {
-		addr.sin_port = (rand() % 61440) + 4096;
+		addr.sin_port = htons((rand() % 61440) + 4096);
 		ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
 		if (!ret)
 			break;
diff --git a/test/socket-rw.c b/test/socket-rw.c
index 1b731b2..5afd14d 100644
--- a/test/socket-rw.c
+++ b/test/socket-rw.c
@@ -17,6 +17,7 @@
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -40,10 +41,10 @@ int main(int argc, char *argv[])
 	assert(ret != -1);
 
 	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = 0x0100007fU;
+	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
 	do {
-		addr.sin_port = (rand() % 61440) + 4096;
+		addr.sin_port = htons((rand() % 61440) + 4096);
 		ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
 		if (!ret)
 			break;
-- 
2.30.2

