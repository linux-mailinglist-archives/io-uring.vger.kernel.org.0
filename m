Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E31B33FAD0
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCQWLB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCQWKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9860AC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:39 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n198so188854iod.0
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yFfTTrDlXU/aoA5+ezDGI+JriDDqafa03HZ3PC/E9nE=;
        b=rk/INnSk1hUFZsKelBzhxsDuOZYVgDDxnHKY1J14kmE213QylibJmganh17BtPNNmg
         jx6RIoTGAc13KH+o/+JzyMmToHMQ3gF++0cC0q59WVRwKYkCVK5V6hBm6ABxQawAiOJB
         trsBo3Wbz0RSS3HUhy8yB96NcTnkyILkejJ1WWLrIZ0ojh8WSlIUnaoE2Pg19IPGC1Z4
         f3xl1QKzToyGd4ppOZvwzcqUJTphx7XTjfOBHJpfuCRdhu+DaZK61Xzl0ULo7j7aUcuU
         BrH0fup8D6FXvNFY8zYc/oqk4xSbwjeMXvS9axNsUiWM6PUMwaIZpY46eFhuyedJH889
         /Nzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFfTTrDlXU/aoA5+ezDGI+JriDDqafa03HZ3PC/E9nE=;
        b=Kvz3IXRL8s9Jcaog31UNOGXQbgc/dI5hs8AQDa1NjArzOHlyCyXngz14S9Cylxzs0A
         abnwWiWX8NDlNO+C4oKjGyGqkDSAmoAnrS7qON9dwIRco0VdCFVpCmKH0XacltM2NJgk
         mMt8BF9ZBhUqvxGGER2nfMjHubux59IykgUKQ6jveQ/e5j2af6+3O4n9uAiv9SsGL/iY
         ITeSpMKSb4YkQ/uQ5fp2sKGsGmAb77oyQgdo3gLZRtEdgkntYByKAG9KGaUO9fGm9L1q
         1t/oXqGe2L0dsYesV8gVdaSua2fDwMus27xxFf0ZmIoxj4cawqboc1vJ3zIIwX+M0nl/
         Jb2Q==
X-Gm-Message-State: AOAM53076yh0Q7W9t75R4UkTHwlOQ4cqHpAisCyISmh2n9t8JsQIn7KQ
        PVEzR9y5dIinZHOccNNvJ7yRIJkJY5+ViA==
X-Google-Smtp-Source: ABdhPJzeeyb2mVHxCDRlIG8DgSu9F7f7LU/o7DNQNaiCpkxp7a3sONMBcasz+YqJEt9vVaTEAniEFw==
X-Received: by 2002:a6b:5818:: with SMTP id m24mr8041012iob.144.1616019038784;
        Wed, 17 Mar 2021 15:10:38 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] net: add example SOCKET_URING_OP_SIOCINQ/SOCKET_URING_OP_SIOCOUTQ
Date:   Wed, 17 Mar 2021 16:10:27 -0600
Message-Id: <20210317221027.366780-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for these sample ioctls for tcp/udp/raw ipv4/ipv6.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/raw.h        |  3 +++
 include/net/tcp.h        |  2 ++
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h | 17 +++++++++++++++++
 net/ipv4/raw.c           | 27 +++++++++++++++++++++++++++
 net/ipv4/tcp.c           | 36 ++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  1 +
 net/ipv4/udp.c           | 18 ++++++++++++++++++
 net/ipv6/raw.c           |  1 +
 net/ipv6/tcp_ipv6.c      |  1 +
 net/ipv6/udp.c           |  1 +
 11 files changed, 109 insertions(+)

diff --git a/include/net/raw.h b/include/net/raw.h
index 8ad8df594853..27098db724dd 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -82,4 +82,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 #endif
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+			enum io_uring_cmd_flags issue_flags);
+
 #endif	/* _RAW_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 963cd86d12dd..b2aca8ce3293 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -350,6 +350,8 @@ void tcp_twsk_destructor(struct sock *sk);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+			enum io_uring_cmd_flags issue_flags);
 
 void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
 static inline void tcp_dec_quickack_mode(struct sock *sk,
diff --git a/include/net/udp.h b/include/net/udp.h
index a132a02b2f2c..0588ca8a9406 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+			enum io_uring_cmd_flags issue_flags);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/include/uapi/linux/net.h b/include/uapi/linux/net.h
index 4dabec6bd957..5e8d604e4cc6 100644
--- a/include/uapi/linux/net.h
+++ b/include/uapi/linux/net.h
@@ -19,6 +19,7 @@
 #ifndef _UAPI_LINUX_NET_H
 #define _UAPI_LINUX_NET_H
 
+#include <linux/types.h>
 #include <linux/socket.h>
 #include <asm/socket.h>
 
@@ -55,4 +56,20 @@ typedef enum {
 
 #define __SO_ACCEPTCON	(1 << 16)	/* performed a listen		*/
 
+enum {
+	SOCKET_URING_OP_SIOCINQ		= 0,
+	SOCKET_URING_OP_SIOCOUTQ,
+
+	/*
+	 * This is reserved for custom sub protocol
+	 */
+	SOCKET_URING_OP_SUBPROTO_CMD	= 0xffff,
+};
+
+struct sock_uring_cmd {
+	__u16	op;
+	__u16	unused[3];
+	__u64	unused2[4];
+};
+
 #endif /* _UAPI_LINUX_NET_H */
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 50a73178d63a..f93011d8f174 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -75,6 +75,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/compat.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 struct raw_frag_vec {
 	struct msghdr *msg;
@@ -878,6 +879,31 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
 	return do_raw_getsockopt(sk, level, optname, optval, optlen);
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  enum io_uring_cmd_flags issue_flags)
+{
+	struct sock_uring_cmd *scmd = (struct sock_uring_cmd *)&cmd->pdu;
+
+	switch (scmd->op) {
+	case SOCKET_URING_OP_SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	case SOCKET_URING_OP_SIOCINQ: {
+		struct sk_buff *skb;
+		int amount = 0;
+
+		spin_lock_bh(&sk->sk_receive_queue.lock);
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb)
+			amount = skb->len;
+		spin_unlock_bh(&sk->sk_receive_queue.lock);
+		return amount;
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(raw_uring_cmd);
+
 static int raw_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -956,6 +982,7 @@ struct proto raw_prot = {
 	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = raw_hash_sk,
 	.unhash		   = raw_unhash_sk,
+	.uring_cmd	   = raw_uring_cmd,
 	.obj_size	   = sizeof(struct raw_sock),
 	.useroffset	   = offsetof(struct raw_sock, filter),
 	.usersize	   = sizeof_field(struct raw_sock, filter),
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index de7cc8445ac0..b9d4c6098049 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <linux/io_uring.h>
 
 /* Track pending CMSGs. */
 enum {
@@ -600,6 +601,41 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 }
 EXPORT_SYMBOL(tcp_poll);
 
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  enum io_uring_cmd_flags issue_flags)
+{
+	struct sock_uring_cmd *scmd = (struct sock_uring_cmd *)&cmd->pdu;
+	struct tcp_sock *tp = tcp_sk(sk);
+	bool slow;
+	int ret;
+
+	switch (scmd->op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		slow = lock_sock_fast(sk);
+		ret = tcp_inq(sk);
+		unlock_sock_fast(sk, slow);
+		break;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			ret = 0;
+		else
+			ret = READ_ONCE(tp->write_seq) - tp->snd_una;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tcp_uring_cmd);
+
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index daad4f99db32..c131eb1007b1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2791,6 +2791,7 @@ struct proto tcp_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v4_init_sock,
 	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..809ac8ae7e41 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,6 +113,7 @@
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
+#include <linux/io_uring.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
@@ -1682,6 +1683,22 @@ static int first_packet_length(struct sock *sk)
 	return res;
 }
 
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  enum io_uring_cmd_flags issue_flags)
+{
+	struct sock_uring_cmd *scmd = (struct sock_uring_cmd *)&cmd->pdu;
+
+	switch (scmd->op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		return max_t(int, 0, first_packet_length(sk));
+	case SOCKET_URING_OP_SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(udp_uring_cmd);
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -2837,6 +2854,7 @@ struct proto udp_prot = {
 	.connect		= ip4_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
+	.uring_cmd		= udp_uring_cmd,
 	.init			= udp_init_sock,
 	.destroy		= udp_destroy_sock,
 	.setsockopt		= udp_setsockopt,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 1f56d9aae589..50f1e8189482 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1235,6 +1235,7 @@ struct proto rawv6_prot = {
 	.connect	   = ip6_datagram_connect_v6_only,
 	.disconnect	   = __udp_disconnect,
 	.ioctl		   = rawv6_ioctl,
+	.uring_cmd	   = raw_uring_cmd,
 	.init		   = rawv6_init_sk,
 	.setsockopt	   = rawv6_setsockopt,
 	.getsockopt	   = rawv6_getsockopt,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bd44ded7e50c..1ce253cc28f5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2119,6 +2119,7 @@ struct proto tcpv6_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v6_init_sock,
 	.destroy		= tcp_v6_destroy_sock,
 	.shutdown		= tcp_shutdown,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fd..082593726a1e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1702,6 +1702,7 @@ struct proto udpv6_prot = {
 	.connect		= ip6_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
+	.uring_cmd		= udp_uring_cmd,
 	.init			= udp_init_sock,
 	.destroy		= udpv6_destroy_sock,
 	.setsockopt		= udpv6_setsockopt,
-- 
2.31.0

