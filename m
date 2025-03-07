Return-Path: <io-uring+bounces-7007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D826DA56D79
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D7353A4DA6
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E79C238D22;
	Fri,  7 Mar 2025 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjgL3Ziq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9C723A9BB
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364524; cv=none; b=Lq9k5qt4QcR4+1IRt0+Q9HSbEJo4Me7M9xnRp4zqCq+3nUMOXLLdjS4IeSN3K21baifh4FQSkuiVSLYnMWvpLW17HMD6n2B4h25nQjSNr0y+M63svCryW1Q6JmYP4fQVZumxR+ZfdW34d6wSWI0mvq0Lc3+yeOdG6g+aifMbw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364524; c=relaxed/simple;
	bh=CdQWfCZybetwuh0QHo4vHCvZ4DVJZbuxlvbLWuDqrUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE5F8v+Sd1Nqt6VqyNUPNKsBAQCKg0hAEju2kMjINw4/mKFfM4QCW1nwtxojBj1XirOeVrOYkTs3dt196iPP0edtV5F9rkT+yuzMr9abF8rg9gpaZSkQnCQuLDKF1p5AMcWxkVCADVyZZCkD4RN/YCnoGmQpBwTHkGooGqQ4rfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjgL3Ziq; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so3696311a12.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741364520; x=1741969320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjAyPpy+7gR3wP8zN7zP6bimQJIBWv2Ey6Arcbs3jQQ=;
        b=LjgL3ZiqcWFlKtgTxgGQESwONFunr1axMv9wtW4VuoTHefrsXNIu3+coUlg1X8lUJr
         YTPWFo4Jc58oXzFdo+3GkROjWw548O/MNi9/fCw0hO98wv+Tqf5vIO7oY01jUgcTA5XZ
         StRYBxqaPZ6voVg0ZOe+f75F6wFfLcfgb0+s+CHDD56ylCAOxHAeNCqFFXFP9dXmkTq7
         plA0Bn2eEovcmxan90bYHMByZdESIS3txymZ92nZnzGF0vLr28ylmppajggXbtnUVOLz
         +IQA+GFIxUCuIelUvxfqofUJEu9PregOLWoPkRsUIPZ1P2JjzF7EaGojhUS2Zk03SiT8
         GUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364520; x=1741969320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjAyPpy+7gR3wP8zN7zP6bimQJIBWv2Ey6Arcbs3jQQ=;
        b=XxPWLWs2RsdWRem4IAYw1GwZ37rhoSoXolEqfCeZXbfur9H5qjntnarx/zBe5guMCC
         UIDewIxRW91hDRJ3JImS7LLwWds/8qFcGb5IkaniOET4T2XmbC+5sr7S73UGOOrRJOvi
         OVxVmJLZSd2hveMtZVDOiMdmC/jn1SmYn2MmLgwRgzSDJZclKQPANo5fWp6EsKNJzXCT
         +45w4os7P5NEpsxqZTeSBbhd/KxE2xivkQWUS5C54Fzsfr9xtsmRjL//emlXlChorQAi
         z+RJ5ue/USfutEaJvbWsM5hddjlBkSMJqLDToMUommI3DLH5zO3LVX3Lnp3aIgH1P8kU
         O5OQ==
X-Gm-Message-State: AOJu0YxjyQ6WoiAKIFb4ibJeEp+zrPJfbu8qOhIyX+NqwXyNd2tlwzFw
	9x23Md1U1LDNEJyBCEaf91MtBm1GiCEtJsM/C/oTsqBLriOt3B9GL9Lokg==
X-Gm-Gg: ASbGncu+4FL/6T5gJrvDre7Xpp9qsOGWQlAUY1fabpLDpytp74PlzRxPHRWCyfvaYtx
	HhPpg95G7oDPT9ZBwXJg85OiTrlExnKqBSgXXcnwTPVlqX8YzoOQf6umT/0vIdb5eeo6L2FhxgH
	pukL/nc/bYG68O26pOg51KzeVi2tYBCI4GDQ2ANZPlborvvd6pkB6mInKqaaCoN65nuP3jS0Qxe
	1Ae+n6tXMBpzACuEerPsAAkydwFiTHEsDYovzgat8uxTag28a054mC5d30jm0tDdAPdclPRaqqu
	vgXvo20razZrdwReTfQdqdUtC3W+
X-Google-Smtp-Source: AGHT+IEeLPcMY9wxNtSDe/2OgbmwVXSStYUSP+rL4pbVoWcnxLgQhp2G4ITqmpMJ00nvOkYuQPF+0A==
X-Received: by 2002:a17:907:6e9e:b0:ab7:d454:11c9 with SMTP id a640c23a62f3a-ac25259859amr452676566b.8.1741364519871;
        Fri, 07 Mar 2025 08:21:59 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac239438955sm300566166b.19.2025.03.07.08.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:21:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/4] tests/helpers: add t_create_socketpair_ip
Date: Fri,  7 Mar 2025 16:22:45 +0000
Message-ID: <8b22b1bd210938bb908bd9c630ba8b118e4e5d47.1741364284.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741364284.git.asml.silence@gmail.com>
References: <cover.1741364284.git.asml.silence@gmail.com>
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


