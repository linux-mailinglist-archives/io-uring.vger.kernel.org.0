Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1C941953B
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbhI0NmK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbhI0NmK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:42:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58A3C061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so13725978pjb.5
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=saquoOZNYEkIfhOLEiaeLFyrfQLVvidiVimyOolufNY=;
        b=lgBBt6CPz7ULdmAlxR87jkNrn1BoH5DBMxo6+HPP2Bnxu4Cq+bzGaC2a5rrny6qKRF
         XNXm4HOFjJ03ShKKuVR52NEieiQofAFAk1cDWuk51Kfiaoej2oNP3GbaBxfoiC8eO6PB
         +o2QrrqU0TzCxRSEAq/lpyxBXVX+Z1CWAS9qh5RBdgSsscr5iAqDhq0DlG9Hldw+1U14
         OSBwrdPdlx3gZmNBzXRbQXDZoTKDFgohk6T04FYumuS9xpCeEtogcFFb0OtKlWRpgXo2
         4bxhCYmZngcKqq3H8rHAO/hEerOLYRYRXAafLVaO0oxRuu9wE800naSehx/k8z/ZJHBa
         coZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=saquoOZNYEkIfhOLEiaeLFyrfQLVvidiVimyOolufNY=;
        b=cbdGdfagiNWacf6Qa9ken5uFTbZuxtGq5b8Vp66E7mG3XWAFcvgleqwHrTI1ZJggJF
         0LiXy2p5yRYn+9q5hosspIhAUo37+zXcDPYtZq3MV5zgPzjYrILRlNU5IaofE7FnYHL0
         rYcysBoBO15NBgf7/xx/oI5DzoD0XR/r65vByq+Ds08ToF9+DiAOv8KEjAZECOZYAOF+
         tqHsGc6zDEY68liLRmW5nD0x2j2ZR0yt2qJVrMkU0blFcr+Bo/1jX40q0xCjS7AvYzf8
         1dpT61jAzcjWunZ9w55YGVsX6hI5OnBURCR0L3eMkMTYNgBmdgPdfIqYv/kgRN0qWrl/
         niHw==
X-Gm-Message-State: AOAM532O0qZdzTUff9xyGN0kRKAWD16O+8ATQITa7IaSjgQNEUZYCJoS
        l8eN+gvWBU6WsSPiB3QzBXjXWm/f8vSjPw==
X-Google-Smtp-Source: ABdhPJzACkQY1j6pvxAUBlAacrxOlvLUnCoVpglkslZrujt6+5O8K2GsRnMtZMYecOybNJy/nJoKxg==
X-Received: by 2002:a17:90b:3a90:: with SMTP id om16mr19991318pjb.194.1632750032287;
        Mon, 27 Sep 2021 06:40:32 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id b21sm17306914pfv.96.2021.09.27.06.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 06:40:32 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCH liburing v2 1/2] test: Fix endianess issue on `bind()` and `connect()`
Date:   Mon, 27 Sep 2021 20:40:22 +0700
Message-Id: <20210927134023.294466-2-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927134023.294466-1-ammarfaizi2@gmail.com>
References: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
 <20210927134023.294466-1-ammarfaizi2@gmail.com>
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

