Return-Path: <io-uring+bounces-7025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F14A57085
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 521B8176ACA
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2346319ABC2;
	Fri,  7 Mar 2025 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkIAEi4h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2574A23BCFA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372114; cv=none; b=Kg4UyQl8PPReQiXaZ3KLZPGi2iqEZxQRMFpLePunL/ox5zfRLk5H2h4XIu5ZTEAAybpi97DQOx5/QRbCzH1OJd/BpcsP1qK0o5sU9zGeQ0nPEQr5tjAXAr80rqyK7YfHCym7cM7T5sXq5MHm9TLpQUJ7Z3gd/yEXUjHyaBD5944=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372114; c=relaxed/simple;
	bh=CdQWfCZybetwuh0QHo4vHCvZ4DVJZbuxlvbLWuDqrUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSQeh/d9vawI7GCiezv8U5aqxTfgVY1c/fyLqcQCWhLwGv0q5y8fsUdU7AS3ko0Jl0ry+rmnB+QtzvAId0oNYfmpBqHrVRbaMeIwi7xZvCkP9SAIZRKf2nalJGTFl4KKQKIgRp0z1I5hUh28ZlYZs0Tb2843BhjL7r4Cpxp+j/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkIAEi4h; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e4ebc78da5so4077118a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741372110; x=1741976910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjAyPpy+7gR3wP8zN7zP6bimQJIBWv2Ey6Arcbs3jQQ=;
        b=RkIAEi4ha+v0AIpFUNP4CNj9ORkwxPCqfAisUxq4OigeOVejkP2OEm0N6YrZqrwF7d
         n28buLsgmz8l5/RcEbU6jrBD8UQTBW1WHTWGzhSY+vX+XFtvu00GAeY0frwg+cgth7XA
         ccTqa2sh/HuBvf1w5LaR5/6Zl7EV6GYlAYTPCPnau1fxRFvyB7vzaCOOl++kHCQdV9GI
         QKKtxc3Hbs3ox3HDaG2R/UWnDQGhkOinJc5oeS+Gpe3taaaWXCJnTdGavGszk0A04Zv8
         yZ3jgvpe5m/rkdsBhllNsBo1nux5HgfIr6AV9V3Ga7JhKv7ZgAWXZjaMb/Nlg+HRwphA
         5M0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741372110; x=1741976910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjAyPpy+7gR3wP8zN7zP6bimQJIBWv2Ey6Arcbs3jQQ=;
        b=tR6Y2sor8GDodErDzrNgRnNzFVNcVrW7aDpX6qqUMmG30Leh3kiYN/UhAzS3lpcII7
         XbqCnOwYf5MyeOSIClex1YsnLVgbnzp63A9n2ZVWyNiCUlsY+ULMppyXDJsHoJHJIKt8
         vj78z9V+bEjceul5pSUcIA1XSCj4l7tzUHNk7fZlM7SEHvh/GVhHhBvyaCLf4mAs1xsT
         JDayu/VCX4tpmzv7k3Od48a6UcQjaqUjNCqqRQH+0eDEwaS7QY88YR9uspzFX5d7QsX7
         wIkANKxgA8vF9OndX55dyS5e5rF/yWYkfFm6n0YnX/6mB83oWftiZDK+p4rTk8xIfKYQ
         GN/w==
X-Gm-Message-State: AOJu0Ywt6iciyry+aMfOIkYjC7XdZgcgjSUNIZZEVN+N+ulj1MN9SpUq
	RZqCMJKFFXpX4nou+ojmgXzS2KfEk+wxJ7y+ev8PpheV+3NuoOIIsk4pkg==
X-Gm-Gg: ASbGncspAeWwIeeLxEadBCP5+xz0xCMGTKoZQ6nDRPDLkGpw2qP2c0Iyfv8S76Li3lC
	i2QL1LgBK/EafAvj7NNgcTsHVQ8+862CZd9RsdBiIoZ0wEbTuIFhRzjjvLByZM0kXcCKRqOR5cH
	MTdiCl1xNKS2qGCG26nVnZIkbB5LnT9swdlO9cYDpc2JznmtNOxZPxnqghJcCxaKV04KVuc1bq3
	runydmLsnhnbNCQS9PbOTvtwmHjO2raI3A0Cme0TaQuc6njp7MPfEs+nlD6AT0XbqjHrKoTLJkG
	jcymKSu8T7feDKRivhvfmDnhhd1nvlKLblOrnBpVZRB0ZTOP1k4HR1YkqA==
X-Google-Smtp-Source: AGHT+IGzfHzrYdTJCaz6aDLCNCfL7wMrYPBOHj3dJEx1w2UpSwPDnBG/vG8OmTFg0vOcSxQR5jTHBg==
X-Received: by 2002:a05:6402:26cf:b0:5e0:8c35:a137 with SMTP id 4fb4d7f45d1cf-5e5e2490c0dmr4679741a12.23.1741372109786;
        Fri, 07 Mar 2025 10:28:29 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a9315sm2883230a12.46.2025.03.07.10.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 10:28:28 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 3/4] tests/helpers: add t_create_socketpair_ip
Date: Fri,  7 Mar 2025 18:28:55 +0000
Message-ID: <f298148414a34e3a02c551509be2b308268e3e25.1741372065.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741372065.git.asml.silence@gmail.com>
References: <cover.1741372065.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_socketpair_ip() is useful for zerocopy tx testing as it needs TCP
sockets and not just AF_UNIX. There will be tx zc tests in more files,
so move the function to helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.c       | 111 ++++++++++++++++++++++++++++++++++++++
 test/helpers.h       |   5 ++
 test/send-zerocopy.c | 123 ++++---------------------------------------
 3 files changed, 127 insertions(+), 112 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 07186911..b2d386f4 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -373,3 +373,114 @@ void *aligned_alloc(size_t alignment, size_t size)
 
 	return ret;
 }
+
+int t_create_socketpair_ip(struct sockaddr_storage *addr,
+				int *sock_client, int *sock_server,
+				bool ipv6, bool client_connect,
+				bool msg_zc, bool tcp, const char *name)
+{
+	socklen_t addr_size;
+	int family, sock, listen_sock = -1;
+	int ret;
+
+	memset(addr, 0, sizeof(*addr));
+	if (ipv6) {
+		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
+
+		family = AF_INET6;
+		saddr->sin6_family = family;
+		saddr->sin6_port = htons(0);
+		addr_size = sizeof(*saddr);
+	} else {
+		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
+
+		family = AF_INET;
+		saddr->sin_family = family;
+		saddr->sin_port = htons(0);
+		saddr->sin_addr.s_addr = htonl(INADDR_ANY);
+		addr_size = sizeof(*saddr);
+	}
+
+	/* server sock setup */
+	if (tcp) {
+		sock = listen_sock = socket(family, SOCK_STREAM, IPPROTO_TCP);
+	} else {
+		sock = *sock_server = socket(family, SOCK_DGRAM, 0);
+	}
+	if (sock < 0) {
+		perror("socket");
+		return 1;
+	}
+
+	ret = bind(sock, (struct sockaddr *)addr, addr_size);
+	if (ret < 0) {
+		perror("bind");
+		return 1;
+	}
+
+	ret = getsockname(sock, (struct sockaddr *)addr, &addr_size);
+	if (ret < 0) {
+		fprintf(stderr, "getsockname failed %i\n", errno);
+		return 1;
+	}
+
+	if (tcp) {
+		ret = listen(sock, 128);
+		assert(ret != -1);
+	}
+
+	if (ipv6) {
+		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
+
+		inet_pton(AF_INET6, name, &(saddr->sin6_addr));
+	} else {
+		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
+
+		inet_pton(AF_INET, name, &saddr->sin_addr);
+	}
+
+	/* client sock setup */
+	if (tcp) {
+		*sock_client = socket(family, SOCK_STREAM, IPPROTO_TCP);
+		assert(client_connect);
+	} else {
+		*sock_client = socket(family, SOCK_DGRAM, 0);
+	}
+	if (*sock_client < 0) {
+		perror("socket");
+		return 1;
+	}
+	if (client_connect) {
+		ret = connect(*sock_client, (struct sockaddr *)addr, addr_size);
+		if (ret < 0) {
+			perror("connect");
+			return 1;
+		}
+	}
+	if (msg_zc) {
+#ifdef SO_ZEROCOPY
+		int val = 1;
+
+		/*
+		 * NOTE: apps must not set SO_ZEROCOPY when using io_uring zc.
+		 * It's only here to test interactions with MSG_ZEROCOPY.
+		 */
+		if (setsockopt(*sock_client, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
+			perror("setsockopt zc");
+			return 1;
+		}
+#else
+		fprintf(stderr, "no SO_ZEROCOPY\n");
+		return 1;
+#endif
+	}
+	if (tcp) {
+		*sock_server = accept(listen_sock, NULL, NULL);
+		if (!*sock_server) {
+			fprintf(stderr, "can't accept\n");
+			return 1;
+		}
+		close(listen_sock);
+	}
+	return 0;
+}
diff --git a/test/helpers.h b/test/helpers.h
index d0294eba..f8a5c7f2 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -81,6 +81,11 @@ struct iovec *t_create_buffers(size_t buf_num, size_t buf_size);
  */
 int t_create_socket_pair(int fd[2], bool stream);
 
+int t_create_socketpair_ip(struct sockaddr_storage *addr,
+				int *sock_client, int *sock_server,
+				bool ipv6, bool client_connect,
+				bool msg_zc, bool tcp, const char *name);
+
 /*
  * Helper for setting up a ring and checking for user privs
  */
diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 680481a0..b505e4d0 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -258,117 +258,6 @@ static int test_send_faults(int sock_tx, int sock_rx)
 	return T_EXIT_PASS;
 }
 
-static int create_socketpair_ip(struct sockaddr_storage *addr,
-				int *sock_client, int *sock_server,
-				bool ipv6, bool client_connect,
-				bool msg_zc, bool tcp)
-{
-	socklen_t addr_size;
-	int family, sock, listen_sock = -1;
-	int ret;
-
-	memset(addr, 0, sizeof(*addr));
-	if (ipv6) {
-		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
-
-		family = AF_INET6;
-		saddr->sin6_family = family;
-		saddr->sin6_port = htons(0);
-		addr_size = sizeof(*saddr);
-	} else {
-		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
-
-		family = AF_INET;
-		saddr->sin_family = family;
-		saddr->sin_port = htons(0);
-		saddr->sin_addr.s_addr = htonl(INADDR_ANY);
-		addr_size = sizeof(*saddr);
-	}
-
-	/* server sock setup */
-	if (tcp) {
-		sock = listen_sock = socket(family, SOCK_STREAM, IPPROTO_TCP);
-	} else {
-		sock = *sock_server = socket(family, SOCK_DGRAM, 0);
-	}
-	if (sock < 0) {
-		perror("socket");
-		return 1;
-	}
-
-	ret = bind(sock, (struct sockaddr *)addr, addr_size);
-	if (ret < 0) {
-		perror("bind");
-		return 1;
-	}
-
-	ret = getsockname(sock, (struct sockaddr *)addr, &addr_size);
-	if (ret < 0) {
-		fprintf(stderr, "getsockname failed %i\n", errno);
-		return 1;
-	}
-
-	if (tcp) {
-		ret = listen(sock, 128);
-		assert(ret != -1);
-	}
-
-	if (ipv6) {
-		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
-
-		inet_pton(AF_INET6, HOSTV6, &(saddr->sin6_addr));
-	} else {
-		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
-
-		inet_pton(AF_INET, HOST, &saddr->sin_addr);
-	}
-
-	/* client sock setup */
-	if (tcp) {
-		*sock_client = socket(family, SOCK_STREAM, IPPROTO_TCP);
-		assert(client_connect);
-	} else {
-		*sock_client = socket(family, SOCK_DGRAM, 0);
-	}
-	if (*sock_client < 0) {
-		perror("socket");
-		return 1;
-	}
-	if (client_connect) {
-		ret = connect(*sock_client, (struct sockaddr *)addr, addr_size);
-		if (ret < 0) {
-			perror("connect");
-			return 1;
-		}
-	}
-	if (msg_zc) {
-#ifdef SO_ZEROCOPY
-		int val = 1;
-
-		/*
-		 * NOTE: apps must not set SO_ZEROCOPY when using io_uring zc.
-		 * It's only here to test interactions with MSG_ZEROCOPY.
-		 */
-		if (setsockopt(*sock_client, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
-			perror("setsockopt zc");
-			return 1;
-		}
-#else
-		fprintf(stderr, "no SO_ZEROCOPY\n");
-		return 1;
-#endif
-	}
-	if (tcp) {
-		*sock_server = accept(listen_sock, NULL, NULL);
-		if (!*sock_server) {
-			fprintf(stderr, "can't accept\n");
-			return 1;
-		}
-		close(listen_sock);
-	}
-	return 0;
-}
-
 struct send_conf {
 	bool fixed_buf;
 	bool mix_register;
@@ -574,6 +463,16 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	return 0;
 }
 
+static int create_socketpair_ip(struct sockaddr_storage *addr,
+				int *sock_client, int *sock_server,
+				bool ipv6, bool client_connect,
+				bool msg_zc, bool tcp)
+{
+	return t_create_socketpair_ip(addr, sock_client, sock_server, ipv6,
+					client_connect, msg_zc, tcp,
+					ipv6 ? HOSTV6 : HOST);
+}
+
 static int test_inet_send(struct io_uring *ring)
 {
 	struct send_conf conf;
@@ -598,7 +497,7 @@ static int test_inet_send(struct io_uring *ring)
 			continue;
 #endif
 		ret = create_socketpair_ip(&addr, &sock_client, &sock_server, ipv6,
-				 client_connect, msg_zc_set, tcp);
+					client_connect, msg_zc_set, tcp);
 		if (ret) {
 			fprintf(stderr, "sock prep failed %d\n", ret);
 			return 1;
-- 
2.48.1


