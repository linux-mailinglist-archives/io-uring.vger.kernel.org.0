Return-Path: <io-uring+bounces-1845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8398C1479
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 20:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1091EB215EC
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 18:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD9C78B4E;
	Thu,  9 May 2024 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ML7mhbv+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63C6770F0
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715277995; cv=none; b=hDPWaZcvZSta9+hpbw3sAN1D9S1jnzj1EJU8QN0XV3VZV0KCyl7tVJwnnpn49Pp4F6zKPITvBWsYHrFi3Bdt5p4i1BOaXkfmR6Nx5DDbFXB9T+8a+IPtG7quFM0TVcfE4IDNvkz5rLsUf5LjTGojpZmurePlYtwMLIlHN41hrLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715277995; c=relaxed/simple;
	bh=k9pGOKTp41kudyyh3q/Rd0bRJkFuAgmCHrwlq71GjXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zitu1AN2kzLMB8NxqFrsZakaxcIxRj/BPuhl9xnldRdLEAEUZ7H+9/aF5/lPq68DjO1sTCiKParoqhzEvtGbePREG0CrW4FKzzKiCSwFuHwdBijV3tDfGJnIi2hqxO6Y8+XsuyWpAUoOSJzKoTzo4xRj0Ar/E2nU1O6Lv9G8WpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ML7mhbv+; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-36c0d2b0fdeso992475ab.1
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715277991; x=1715882791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79qvl4qYaiTP0NJ1j2FfQ93P28sw9K7kYp4VDb9gItc=;
        b=ML7mhbv+7F96P1xTv7idNYfY1Ktc/iMJyv/8UhAnMVdrJyBVE35E9al6IRR3LSJm2s
         44HrRIYpMG80wyb7wLjHxplwefxfvYC88Nr1rZ6TB6nNErxuBCvakaAIJnESiqJv5J3R
         wK1wQlm1nNnVCJvaONuPm9bF/A3xK2J8MV1Cfyfw5pDIQY2QhgjMCOvNVqU9YZ0HgBz3
         xVcDJJ8ihX4BBH4sKkhlqeqKOkWtDqUcHLY01ho3SZ91N2V7fl/HHbOP7VMAseXUgKDt
         YTFbMfyAAd/XfwQQmB9ZV0he4xc15PtbFKGIP7sv4Z9bJ1svsv16mtZtaDu66UXe/ubJ
         hUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715277991; x=1715882791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79qvl4qYaiTP0NJ1j2FfQ93P28sw9K7kYp4VDb9gItc=;
        b=BNtsI8beitbq7yz39XYLXgSttR3uRJEK++FiOziAy9ykyON4Lax38kvNfRs7Giv6Vu
         K9emo385yDeU+HV6WYGNAA5O0Hm5/3MqgaEM6mlR1izpJ7zw922oiCKeMpjXC3Slplus
         5v2vfr7wL7iJ4rTKUuuRSghvBeqznIO+djKe6wDY0+B9JPS4Ran+VPSdcsQRFO5Zi0Pt
         kL+vfKCgSiN4gypeTpesvHC7inKKZtz09irIKAUn3L4LIZQL6IwTJmy1zeaiYhTrwxZB
         i/a09cGpt1d400Jny4hnFDzciAHz+uiQeLQZDyqLg4nxMbHNdAav20um3ZP0e4GYIkT2
         3ixg==
X-Gm-Message-State: AOJu0Yxzk6D25TOIiKQgr0ObSbVS0gdC473bTgdtMV84L02dU6XTXMmX
	7Hur/NRYFT7PzEVZWo9BHFDjxUtjCOkL5T8xkjsiRzJjIplikiXT01H+fZ2JLXgJNIvKGUlRB61
	K
X-Google-Smtp-Source: AGHT+IGRCRUj13I1J2M7hR6CjyNVPTRw+SNyQuAaSD0YkUxWfqV82mwBS5WaiFmoPIK6CCtRuWWRWg==
X-Received: by 2002:a5d:8c8e:0:b0:7de:f48e:36c3 with SMTP id ca18e2360f4ac-7e1b500fbb0mr59878539f.0.1715277991146;
        Thu, 09 May 2024 11:06:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1b23ab4f6sm19468739f.50.2024.05.09.11.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 11:06:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] net: change proto and proto_ops accept type
Date: Thu,  9 May 2024 12:00:26 -0600
Message-ID: <20240509180627.204155-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240509180627.204155-1-axboe@kernel.dk>
References: <20240509180627.204155-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than pass in flags, error pointer, and whether this is a kernel
invocation or not, add a struct proto_accept_arg struct as the argument.
This then holds all of these arguments, and prepares accept for being
able to pass back more information.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 crypto/af_alg.c                    | 11 ++++++-----
 crypto/algif_hash.c                | 10 +++++-----
 drivers/xen/pvcalls-back.c         |  6 +++++-
 fs/ocfs2/cluster/tcp.c             |  5 ++++-
 include/crypto/if_alg.h            |  3 ++-
 include/linux/net.h                |  4 +++-
 include/net/inet_common.h          |  4 ++--
 include/net/inet_connection_sock.h |  2 +-
 include/net/sock.h                 | 12 +++++++++---
 net/atm/svc.c                      |  8 ++++----
 net/ax25/af_ax25.c                 |  6 +++---
 net/bluetooth/iso.c                |  4 ++--
 net/bluetooth/l2cap_sock.c         |  4 ++--
 net/bluetooth/rfcomm/sock.c        |  6 +++---
 net/bluetooth/sco.c                |  4 ++--
 net/core/sock.c                    |  4 ++--
 net/ipv4/af_inet.c                 | 10 +++++-----
 net/ipv4/inet_connection_sock.c    |  6 +++---
 net/llc/af_llc.c                   |  7 +++----
 net/mptcp/protocol.c               |  8 ++++----
 net/netrom/af_netrom.c             |  6 +++---
 net/nfc/llcp_sock.c                |  4 ++--
 net/phonet/pep.c                   | 12 ++++++------
 net/phonet/socket.c                |  7 +++----
 net/rds/tcp_listen.c               |  6 +++++-
 net/rose/af_rose.c                 |  6 +++---
 net/sctp/socket.c                  |  8 ++++----
 net/smc/af_smc.c                   |  6 +++---
 net/socket.c                       | 13 ++++++++++---
 net/tipc/socket.c                  | 10 ++++------
 net/unix/af_unix.c                 | 10 +++++-----
 net/vmw_vsock/af_vsock.c           |  6 +++---
 net/x25/af_x25.c                   |  4 ++--
 33 files changed, 123 insertions(+), 99 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5bc6d0fa7498..18cfead0081d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -407,7 +407,8 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
-int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern)
+int af_alg_accept(struct sock *sk, struct socket *newsock,
+		  struct proto_accept_arg *arg)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
@@ -422,7 +423,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern)
 	if (!type)
 		goto unlock;
 
-	sk2 = sk_alloc(sock_net(sk), PF_ALG, GFP_KERNEL, &alg_proto, kern);
+	sk2 = sk_alloc(sock_net(sk), PF_ALG, GFP_KERNEL, &alg_proto, arg->kern);
 	err = -ENOMEM;
 	if (!sk2)
 		goto unlock;
@@ -468,10 +469,10 @@ int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern)
 }
 EXPORT_SYMBOL_GPL(af_alg_accept);
 
-static int alg_accept(struct socket *sock, struct socket *newsock, int flags,
-		      bool kern)
+static int alg_accept(struct socket *sock, struct socket *newsock,
+		      struct proto_accept_arg *arg)
 {
-	return af_alg_accept(sock->sk, newsock, kern);
+	return af_alg_accept(sock->sk, newsock, arg);
 }
 
 static const struct proto_ops alg_proto_ops = {
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index e24c829d7a01..7c7394d46a23 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -223,8 +223,8 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return err ?: len;
 }
 
-static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
-		       bool kern)
+static int hash_accept(struct socket *sock, struct socket *newsock,
+		       struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -252,7 +252,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
 	if (err)
 		goto out_free_state;
 
-	err = af_alg_accept(ask->parent, newsock, kern);
+	err = af_alg_accept(ask->parent, newsock, arg);
 	if (err)
 		goto out_free_state;
 
@@ -355,7 +355,7 @@ static int hash_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
 }
 
 static int hash_accept_nokey(struct socket *sock, struct socket *newsock,
-			     int flags, bool kern)
+			     struct proto_accept_arg *arg)
 {
 	int err;
 
@@ -363,7 +363,7 @@ static int hash_accept_nokey(struct socket *sock, struct socket *newsock,
 	if (err)
 		return err;
 
-	return hash_accept(sock, newsock, flags, kern);
+	return hash_accept(sock, newsock, arg);
 }
 
 static struct proto_ops algif_hash_ops_nokey = {
diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index d52593466a79..fd7ed65e0197 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -517,6 +517,10 @@ static void __pvcalls_back_accept(struct work_struct *work)
 {
 	struct sockpass_mapping *mappass = container_of(
 		work, struct sockpass_mapping, register_work);
+	struct proto_accept_arg arg = {
+		.flags = O_NONBLOCK,
+		.kern = true,
+	};
 	struct sock_mapping *map;
 	struct pvcalls_ioworker *iow;
 	struct pvcalls_fedata *fedata;
@@ -548,7 +552,7 @@ static void __pvcalls_back_accept(struct work_struct *work)
 	sock->type = mappass->sock->type;
 	sock->ops = mappass->sock->ops;
 
-	ret = inet_accept(mappass->sock, sock, O_NONBLOCK, true);
+	ret = inet_accept(mappass->sock, sock, &arg);
 	if (ret == -EAGAIN) {
 		sock_release(sock);
 		return;
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 960080753d3b..2b8fa3e782fb 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1784,6 +1784,9 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct o2nm_node *node = NULL;
 	struct o2nm_node *local_node = NULL;
 	struct o2net_sock_container *sc = NULL;
+	struct proto_accept_arg arg = {
+		.flags = O_NONBLOCK,
+	};
 	struct o2net_node *nn;
 	unsigned int nofs_flag;
 
@@ -1802,7 +1805,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 
 	new_sock->type = sock->type;
 	new_sock->ops = sock->ops;
-	ret = sock->ops->accept(sock, new_sock, O_NONBLOCK, false);
+	ret = sock->ops->accept(sock, new_sock, &arg);
 	if (ret < 0)
 		goto out;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 78ecaf5db04c..f7b3b93f3a49 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -166,7 +166,8 @@ int af_alg_unregister_type(const struct af_alg_type *type);
 
 int af_alg_release(struct socket *sock);
 void af_alg_release_parent(struct sock *sk);
-int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern);
+int af_alg_accept(struct sock *sk, struct socket *newsock,
+		  struct proto_accept_arg *arg);
 
 void af_alg_free_sg(struct af_alg_sgl *sgl);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index 15df6d5f27a7..688320b79fcc 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -153,6 +153,7 @@ struct sockaddr;
 struct msghdr;
 struct module;
 struct sk_buff;
+struct proto_accept_arg;
 typedef int (*sk_read_actor_t)(read_descriptor_t *, struct sk_buff *,
 			       unsigned int, size_t);
 typedef int (*skb_read_actor_t)(struct sock *, struct sk_buff *);
@@ -171,7 +172,8 @@ struct proto_ops {
 	int		(*socketpair)(struct socket *sock1,
 				      struct socket *sock2);
 	int		(*accept)    (struct socket *sock,
-				      struct socket *newsock, int flags, bool kern);
+				      struct socket *newsock,
+				      struct proto_accept_arg *arg);
 	int		(*getname)   (struct socket *sock,
 				      struct sockaddr *addr,
 				      int peer);
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index f50a644d87a9..c17a6585d0b0 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -29,8 +29,8 @@ int __inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 			  int addr_len, int flags, int is_sendmsg);
 int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags);
-int inet_accept(struct socket *sock, struct socket *newsock, int flags,
-		bool kern);
+int inet_accept(struct socket *sock, struct socket *newsock,
+		struct proto_accept_arg *arg);
 void __inet_accept(struct socket *sock, struct socket *newsock,
 		   struct sock *newsk);
 int inet_send_prepare(struct sock *sk);
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 20e7b0c0b3d1..7d6b1254c92d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -250,7 +250,7 @@ inet_csk_rto_backoff(const struct inet_connection_sock *icsk,
         return (unsigned long)min_t(u64, when, max_when);
 }
 
-struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern);
+struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg);
 
 int inet_csk_get_port(struct sock *sk, unsigned short snum);
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 0450494a1766..217079b3e3e8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1194,6 +1194,12 @@ static inline void sk_prot_clear_nulls(struct sock *sk, int size)
 	       size - offsetof(struct sock, sk_node.pprev));
 }
 
+struct proto_accept_arg {
+	int flags;
+	int err;
+	bool kern;
+};
+
 /* Networking protocol blocks we attach to sockets.
  * socket layer -> transport layer interface
  */
@@ -1208,8 +1214,8 @@ struct proto {
 					int addr_len);
 	int			(*disconnect)(struct sock *sk, int flags);
 
-	struct sock *		(*accept)(struct sock *sk, int flags, int *err,
-					  bool kern);
+	struct sock *		(*accept)(struct sock *sk,
+					  struct proto_accept_arg *arg);
 
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 int *karg);
@@ -1804,7 +1810,7 @@ int sock_cmsg_send(struct sock *sk, struct msghdr *msg,
 int sock_no_bind(struct socket *, struct sockaddr *, int);
 int sock_no_connect(struct socket *, struct sockaddr *, int, int);
 int sock_no_socketpair(struct socket *, struct socket *);
-int sock_no_accept(struct socket *, struct socket *, int, bool);
+int sock_no_accept(struct socket *, struct socket *, struct proto_accept_arg *);
 int sock_no_getname(struct socket *, struct sockaddr *, int);
 int sock_no_ioctl(struct socket *, unsigned int, unsigned long);
 int sock_no_listen(struct socket *, int);
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 36a814f1fbd1..f8137ae693b0 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -324,8 +324,8 @@ static int svc_listen(struct socket *sock, int backlog)
 	return error;
 }
 
-static int svc_accept(struct socket *sock, struct socket *newsock, int flags,
-		      bool kern)
+static int svc_accept(struct socket *sock, struct socket *newsock,
+		      struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
@@ -336,7 +336,7 @@ static int svc_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	lock_sock(sk);
 
-	error = svc_create(sock_net(sk), newsock, 0, kern);
+	error = svc_create(sock_net(sk), newsock, 0, arg->kern);
 	if (error)
 		goto out;
 
@@ -355,7 +355,7 @@ static int svc_accept(struct socket *sock, struct socket *newsock, int flags,
 				error = -sk->sk_err;
 				break;
 			}
-			if (flags & O_NONBLOCK) {
+			if (arg->flags & O_NONBLOCK) {
 				error = -EAGAIN;
 				break;
 			}
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 9169efb2f43a..8077cf2ee448 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1373,8 +1373,8 @@ static int __must_check ax25_connect(struct socket *sock,
 	return err;
 }
 
-static int ax25_accept(struct socket *sock, struct socket *newsock, int flags,
-		       bool kern)
+static int ax25_accept(struct socket *sock, struct socket *newsock,
+		       struct proto_accept_arg *arg)
 {
 	struct sk_buff *skb;
 	struct sock *newsk;
@@ -1409,7 +1409,7 @@ static int ax25_accept(struct socket *sock, struct socket *newsock, int flags,
 		if (skb)
 			break;
 
-		if (flags & O_NONBLOCK) {
+		if (arg->flags & O_NONBLOCK) {
 			err = -EWOULDBLOCK;
 			break;
 		}
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index ef0cc80b4c0c..2a075119d65d 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1186,7 +1186,7 @@ static int iso_sock_listen(struct socket *sock, int backlog)
 }
 
 static int iso_sock_accept(struct socket *sock, struct socket *newsock,
-			   int flags, bool kern)
+			   struct proto_accept_arg *arg)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sock *sk = sock->sk, *ch;
@@ -1195,7 +1195,7 @@ static int iso_sock_accept(struct socket *sock, struct socket *newsock,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	BT_DBG("sk %p timeo %ld", sk, timeo);
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 5cc83f906c12..125dddc77452 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -327,7 +327,7 @@ static int l2cap_sock_listen(struct socket *sock, int backlog)
 }
 
 static int l2cap_sock_accept(struct socket *sock, struct socket *newsock,
-			     int flags, bool kern)
+			     struct proto_accept_arg *arg)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sock *sk = sock->sk, *nsk;
@@ -336,7 +336,7 @@ static int l2cap_sock_accept(struct socket *sock, struct socket *newsock,
 
 	lock_sock_nested(sk, L2CAP_NESTING_PARENT);
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	BT_DBG("sk %p timeo %ld", sk, timeo);
 
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 29aa07e9db9d..37d63d768afb 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -468,8 +468,8 @@ static int rfcomm_sock_listen(struct socket *sock, int backlog)
 	return err;
 }
 
-static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int flags,
-			      bool kern)
+static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock,
+			      struct proto_accept_arg *arg)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sock *sk = sock->sk, *nsk;
@@ -483,7 +483,7 @@ static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int f
 		goto done;
 	}
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	BT_DBG("sk %p timeo %ld", sk, timeo);
 
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 5d03c5440b06..09941da7d1fd 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -643,7 +643,7 @@ static int sco_sock_listen(struct socket *sock, int backlog)
 }
 
 static int sco_sock_accept(struct socket *sock, struct socket *newsock,
-			   int flags, bool kern)
+			   struct proto_accept_arg *arg)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sock *sk = sock->sk, *ch;
@@ -652,7 +652,7 @@ static int sco_sock_accept(struct socket *sock, struct socket *newsock,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	BT_DBG("sk %p timeo %ld", sk, timeo);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 8d6e638b5426..8629f9aecf91 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3241,8 +3241,8 @@ int sock_no_socketpair(struct socket *sock1, struct socket *sock2)
 }
 EXPORT_SYMBOL(sock_no_socketpair);
 
-int sock_no_accept(struct socket *sock, struct socket *newsock, int flags,
-		   bool kern)
+int sock_no_accept(struct socket *sock, struct socket *newsock,
+		   struct proto_accept_arg *arg)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index a7bad18bc8b5..de3449e16b89 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -771,16 +771,16 @@ void __inet_accept(struct socket *sock, struct socket *newsock, struct sock *new
  *	Accept a pending connection. The TCP layer now gives BSD semantics.
  */
 
-int inet_accept(struct socket *sock, struct socket *newsock, int flags,
-		bool kern)
+int inet_accept(struct socket *sock, struct socket *newsock,
+		struct proto_accept_arg *arg)
 {
 	struct sock *sk1 = sock->sk, *sk2;
-	int err = -EINVAL;
 
 	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
-	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, flags, &err, kern);
+	arg->err = -EINVAL;
+	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, arg);
 	if (!sk2)
-		return err;
+		return arg->err;
 
 	lock_sock(sk2);
 	__inet_accept(sock, newsock, sk2);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 3b38610958ee..7734d189c66b 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -661,7 +661,7 @@ static int inet_csk_wait_for_connect(struct sock *sk, long timeo)
 /*
  * This will accept the next outstanding connection.
  */
-struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
+struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
@@ -680,7 +680,7 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 
 	/* Find already established connection */
 	if (reqsk_queue_empty(queue)) {
-		long timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+		long timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 		/* If this is a non blocking socket don't sleep */
 		error = -EAGAIN;
@@ -745,7 +745,7 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 out_err:
 	newsk = NULL;
 	req = NULL;
-	*err = error;
+	arg->err = error;
 	goto out;
 }
 EXPORT_SYMBOL(inet_csk_accept);
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index fde1140d899e..4eb52add7103 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -688,14 +688,13 @@ static void llc_cmsg_rcv(struct msghdr *msg, struct sk_buff *skb)
  *	llc_ui_accept - accept a new incoming connection.
  *	@sock: Socket which connections arrive on.
  *	@newsock: Socket to move incoming connection to.
- *	@flags: User specified operational flags.
- *	@kern: If the socket is kernel internal
+ *	@arg: User specified arguments
  *
  *	Accept a new incoming connection.
  *	Returns 0 upon success, negative otherwise.
  */
-static int llc_ui_accept(struct socket *sock, struct socket *newsock, int flags,
-			 bool kern)
+static int llc_ui_accept(struct socket *sock, struct socket *newsock,
+			 struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk, *newsk;
 	struct llc_sock *llc, *newllc;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index bb8f96f2b86f..7537d63ed007 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3881,7 +3881,7 @@ static int mptcp_listen(struct socket *sock, int backlog)
 }
 
 static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
-			       int flags, bool kern)
+			       struct proto_accept_arg *arg)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct sock *ssk, *newsk;
@@ -3897,7 +3897,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		return -EINVAL;
 
 	pr_debug("ssk=%p, listener=%p", ssk, mptcp_subflow_ctx(ssk));
-	newsk = inet_csk_accept(ssk, flags, &err, kern);
+	newsk = inet_csk_accept(ssk, arg);
 	if (!newsk)
 		return err;
 
@@ -3920,7 +3920,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		newsk = new_mptcp_sock;
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 
-		newsk->sk_kern_sock = kern;
+		newsk->sk_kern_sock = arg->kern;
 		lock_sock(newsk);
 		__inet_accept(sock, newsock, newsk);
 
@@ -3949,7 +3949,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		}
 	} else {
 tcpfallback:
-		newsk->sk_kern_sock = kern;
+		newsk->sk_kern_sock = arg->kern;
 		lock_sock(newsk);
 		__inet_accept(sock, newsock, newsk);
 		/* we are being invoked after accepting a non-mp-capable
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 104a80b75477..6ee148f0e6d0 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -772,8 +772,8 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 	return err;
 }
 
-static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
-		     bool kern)
+static int nr_accept(struct socket *sock, struct socket *newsock,
+		     struct proto_accept_arg *arg)
 {
 	struct sk_buff *skb;
 	struct sock *newsk;
@@ -805,7 +805,7 @@ static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
 		if (skb)
 			break;
 
-		if (flags & O_NONBLOCK) {
+		if (arg->flags & O_NONBLOCK) {
 			err = -EWOULDBLOCK;
 			break;
 		}
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index d5344563e525..57a2f97004e1 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -447,7 +447,7 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
 }
 
 static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
-			    int flags, bool kern)
+			    struct proto_accept_arg *arg)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct sock *sk = sock->sk, *new_sk;
@@ -463,7 +463,7 @@ static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
 		goto error;
 	}
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	/* Wait for an incoming connection. */
 	add_wait_queue_exclusive(sk_sleep(sk), &wait);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 3dd5f52bc1b5..53a858478e22 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -759,8 +759,8 @@ static void pep_sock_close(struct sock *sk, long timeout)
 	sock_put(sk);
 }
 
-static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
-				    bool kern)
+static struct sock *pep_sock_accept(struct sock *sk,
+				    struct proto_accept_arg *arg)
 {
 	struct pep_sock *pn = pep_sk(sk), *newpn;
 	struct sock *newsk = NULL;
@@ -772,8 +772,8 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 	u8 pipe_handle, enabled, n_sb;
 	u8 aligned = 0;
 
-	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
-				errp);
+	skb = skb_recv_datagram(sk, (arg->flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				&arg->err);
 	if (!skb)
 		return NULL;
 
@@ -836,7 +836,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	/* Create a new to-be-accepted sock */
 	newsk = sk_alloc(sock_net(sk), PF_PHONET, GFP_KERNEL, sk->sk_prot,
-			 kern);
+			 arg->kern);
 	if (!newsk) {
 		pep_reject_conn(sk, skb, PN_PIPE_ERR_OVERLOAD, GFP_KERNEL);
 		err = -ENOBUFS;
@@ -878,7 +878,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 drop:
 	release_sock(sk);
 	kfree_skb(skb);
-	*errp = err;
+	arg->err = err;
 	return newsk;
 }
 
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 1018340d89a7..5ce0b3ee5def 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -292,18 +292,17 @@ static int pn_socket_connect(struct socket *sock, struct sockaddr *addr,
 }
 
 static int pn_socket_accept(struct socket *sock, struct socket *newsock,
-			    int flags, bool kern)
+			    struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk;
 	struct sock *newsk;
-	int err;
 
 	if (unlikely(sk->sk_state != TCP_LISTEN))
 		return -EINVAL;
 
-	newsk = sk->sk_prot->accept(sk, flags, &err, kern);
+	newsk = sk->sk_prot->accept(sk, arg);
 	if (!newsk)
-		return err;
+		return arg->err;
 
 	lock_sock(newsk);
 	sock_graft(newsk, newsock);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 05008ce5c421..d89bd8d0c354 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -105,6 +105,10 @@ int rds_tcp_accept_one(struct socket *sock)
 	int conn_state;
 	struct rds_conn_path *cp;
 	struct in6_addr *my_addr, *peer_addr;
+	struct proto_accept_arg arg = {
+		.flags = O_NONBLOCK,
+		.kern = true,
+	};
 #if !IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr saddr, daddr;
 #endif
@@ -119,7 +123,7 @@ int rds_tcp_accept_one(struct socket *sock)
 	if (ret)
 		goto out;
 
-	ret = sock->ops->accept(sock, new_sock, O_NONBLOCK, true);
+	ret = sock->ops->accept(sock, new_sock, &arg);
 	if (ret < 0)
 		goto out;
 
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ef81d019b20f..59050caab65c 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -919,8 +919,8 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	return err;
 }
 
-static int rose_accept(struct socket *sock, struct socket *newsock, int flags,
-		       bool kern)
+static int rose_accept(struct socket *sock, struct socket *newsock,
+		       struct proto_accept_arg *arg)
 {
 	struct sk_buff *skb;
 	struct sock *newsk;
@@ -953,7 +953,7 @@ static int rose_accept(struct socket *sock, struct socket *newsock, int flags,
 		if (skb)
 			break;
 
-		if (flags & O_NONBLOCK) {
+		if (arg->flags & O_NONBLOCK) {
 			err = -EWOULDBLOCK;
 			break;
 		}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 64196b1dce1d..c009383369b2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4847,7 +4847,7 @@ static int sctp_disconnect(struct sock *sk, int flags)
  * descriptor will be returned from accept() to represent the newly
  * formed association.
  */
-static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
+static struct sock *sctp_accept(struct sock *sk, struct proto_accept_arg *arg)
 {
 	struct sctp_sock *sp;
 	struct sctp_endpoint *ep;
@@ -4871,7 +4871,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 		goto out;
 	}
 
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 
 	error = sctp_wait_for_accept(sk, timeo);
 	if (error)
@@ -4882,7 +4882,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	 */
 	asoc = list_entry(ep->asocs.next, struct sctp_association, asocs);
 
-	newsk = sp->pf->create_accept_sk(sk, asoc, kern);
+	newsk = sp->pf->create_accept_sk(sk, asoc, arg->kern);
 	if (!newsk) {
 		error = -ENOMEM;
 		goto out;
@@ -4899,7 +4899,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 
 out:
 	release_sock(sk);
-	*err = error;
+	arg->err = error;
 	return newsk;
 }
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 9389f0cfa374..e50a286fd0fb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2689,7 +2689,7 @@ static int smc_listen(struct socket *sock, int backlog)
 }
 
 static int smc_accept(struct socket *sock, struct socket *new_sock,
-		      int flags, bool kern)
+		      struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk, *nsk;
 	DECLARE_WAITQUEUE(wait, current);
@@ -2708,7 +2708,7 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
 	}
 
 	/* Wait for an incoming connection */
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 	add_wait_queue_exclusive(sk_sleep(sk), &wait);
 	while (!(nsk = smc_accept_dequeue(sk, new_sock))) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -2735,7 +2735,7 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
 	if (rc)
 		goto out;
 
-	if (lsmc->sockopt_defer_accept && !(flags & O_NONBLOCK)) {
+	if (lsmc->sockopt_defer_accept && !(arg->flags & O_NONBLOCK)) {
 		/* wait till data arrives on the socket */
 		timeo = msecs_to_jiffies(lsmc->sockopt_defer_accept *
 								MSEC_PER_SEC);
diff --git a/net/socket.c b/net/socket.c
index 01a71ae10c35..6ff5f21d9633 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1898,6 +1898,9 @@ struct file *do_accept(struct file *file, unsigned file_flags,
 	struct file *newfile;
 	int err, len;
 	struct sockaddr_storage address;
+	struct proto_accept_arg arg = {
+		.flags = file_flags,
+	};
 	const struct proto_ops *ops;
 
 	sock = sock_from_file(file);
@@ -1926,8 +1929,8 @@ struct file *do_accept(struct file *file, unsigned file_flags,
 	if (err)
 		goto out_fd;
 
-	err = ops->accept(sock, newsock, sock->file->f_flags | file_flags,
-					false);
+	arg.flags |= sock->file->f_flags;
+	err = ops->accept(sock, newsock, &arg);
 	if (err < 0)
 		goto out_fd;
 
@@ -3580,6 +3583,10 @@ int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
 {
 	struct sock *sk = sock->sk;
 	const struct proto_ops *ops = READ_ONCE(sock->ops);
+	struct proto_accept_arg arg = {
+		.flags = flags,
+		.kern = true,
+	};
 	int err;
 
 	err = sock_create_lite(sk->sk_family, sk->sk_type, sk->sk_protocol,
@@ -3587,7 +3594,7 @@ int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
 	if (err < 0)
 		goto done;
 
-	err = ops->accept(sock, *newsock, flags, true);
+	err = ops->accept(sock, *newsock, &arg);
 	if (err < 0) {
 		sock_release(*newsock);
 		*newsock = NULL;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 798397b6811e..f9d3b8a5fd2a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -146,8 +146,6 @@ static void tipc_data_ready(struct sock *sk);
 static void tipc_write_space(struct sock *sk);
 static void tipc_sock_destruct(struct sock *sk);
 static int tipc_release(struct socket *sock);
-static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
-		       bool kern);
 static void tipc_sk_timeout(struct timer_list *t);
 static int tipc_sk_publish(struct tipc_sock *tsk, struct tipc_uaddr *ua);
 static int tipc_sk_withdraw(struct tipc_sock *tsk, struct tipc_uaddr *ua);
@@ -2716,8 +2714,8 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
  *
  * Return: 0 on success, errno otherwise
  */
-static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
-		       bool kern)
+static int tipc_accept(struct socket *sock, struct socket *new_sock,
+		       struct proto_accept_arg *arg)
 {
 	struct sock *new_sk, *sk = sock->sk;
 	struct tipc_sock *new_tsock;
@@ -2733,14 +2731,14 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		res = -EINVAL;
 		goto exit;
 	}
-	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	timeo = sock_rcvtimeo(sk, arg->flags & O_NONBLOCK);
 	res = tipc_wait_for_accept(sock, timeo);
 	if (res)
 		goto exit;
 
 	buf = skb_peek(&sk->sk_receive_queue);
 
-	res = tipc_sk_create(sock_net(sock->sk), new_sock, 0, kern);
+	res = tipc_sk_create(sock_net(sock->sk), new_sock, 0, arg->kern);
 	if (res)
 		goto exit;
 	security_sk_clone(sock->sk, new_sock->sk);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dc1651541723..c27d273fbef7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -755,7 +755,7 @@ static int unix_bind(struct socket *, struct sockaddr *, int);
 static int unix_stream_connect(struct socket *, struct sockaddr *,
 			       int addr_len, int flags);
 static int unix_socketpair(struct socket *, struct socket *);
-static int unix_accept(struct socket *, struct socket *, int, bool);
+static int unix_accept(struct socket *, struct socket *, struct proto_accept_arg *arg);
 static int unix_getname(struct socket *, struct sockaddr *, int);
 static __poll_t unix_poll(struct file *, struct socket *, poll_table *);
 static __poll_t unix_dgram_poll(struct file *, struct socket *,
@@ -1689,8 +1689,8 @@ static void unix_sock_inherit_flags(const struct socket *old,
 		set_bit(SOCK_PASSSEC, &new->flags);
 }
 
-static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
-		       bool kern)
+static int unix_accept(struct socket *sock, struct socket *newsock,
+		       struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
@@ -1709,8 +1709,8 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
 	 * so that no locks are necessary.
 	 */
 
-	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
-				&err);
+	skb = skb_recv_datagram(sk, (arg->flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				&arg->err);
 	if (!skb) {
 		/* This means receive shutdown. */
 		if (err == 0)
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 54ba7316f808..4b040285aa78 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1500,8 +1500,8 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 	return err;
 }
 
-static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
-			bool kern)
+static int vsock_accept(struct socket *sock, struct socket *newsock,
+			struct proto_accept_arg *arg)
 {
 	struct sock *listener;
 	int err;
@@ -1528,7 +1528,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* Wait for children sockets to appear; these are the new sockets
 	 * created upon connection establishment.
 	 */
-	timeout = sock_rcvtimeo(listener, flags & O_NONBLOCK);
+	timeout = sock_rcvtimeo(listener, arg->flags & O_NONBLOCK);
 	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
 	while ((connected = vsock_dequeue_accept(listener)) == NULL &&
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d18d51412cc0..8dda4178497c 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -871,8 +871,8 @@ static int x25_wait_for_data(struct sock *sk, long timeout)
 	return rc;
 }
 
-static int x25_accept(struct socket *sock, struct socket *newsock, int flags,
-		      bool kern)
+static int x25_accept(struct socket *sock, struct socket *newsock,
+		      struct proto_accept_arg *arg)
 {
 	struct sock *sk = sock->sk;
 	struct sock *newsk;
-- 
2.43.0


