Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0213066B5
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhA0VsQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbhA0V1P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:27:15 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337ECC0613ED
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:52 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f63so2140942pfa.13
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwkIeFMyPHdFBpJspR0EfBlfEKIetotyg62j4rx8Yj4=;
        b=xQKgMVSVaLwx/RkGQF40DWLpeidfFequUgbArGyAyc98NJrZ65KS+YKnuyRQkt+/gV
         B+awf43nFfQLCqqZZMm2bu193YQ2rwbPx5HSDFxdeD0ToYw51UIKXKwEDnmXGT7JLpCg
         1n5ce5DzHmZ9eAVeaujpOWOtUNH8KaJo8+8ZCOPp22lkkNoxzxy7nuNnXfXNylJLP8zm
         YlJtubFZq0gsYXXje/OLMX9G6qylMW82OAlQx3ECb0QkPqf87EZI+d/5mmG1xr4Kae0v
         Ht2YufLix6E5vyKndvAIjuF9QALBegMDd4m+XTOXhDpG3jAzajqYkp035/svP+BVaEGl
         1HSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwkIeFMyPHdFBpJspR0EfBlfEKIetotyg62j4rx8Yj4=;
        b=nt0vBW7ao/rKVVd2d98SSD0x+ZStFnqzgBnyaThoFvLTyJYGUEOSs+2I2EavaEHRdr
         RwMiYplWdpsI1NuS76G+JNmGxuufVMDl4cYnrTNjCBoiCm52LN0ascCQbh3TXigFJQWo
         24bHQJ9IIGhOKT6Mq5vs4Gol3G5Be5/GJCB7pVZv10cBwiTn6tzRBo7L+WKtPRRczOJg
         G1CxrBOjzbd3XBO0BwS9MJm5gc3D6uP6/Lc9azCr2OC1j1i04w6lmNtnLZlvvsda/iDE
         VrNNqskS4OC7gmsEfp+qsJR49MTSP+msgtbS+85Kh0je01VWfwpTRRS6Rdvpy3sca/2k
         jcbQ==
X-Gm-Message-State: AOAM532uBFDVGqvqTodsr0r14y0KbBcB4i18V0gYZoTPnk4DCU0pGThG
        TdsAvMNyuTFSSWmBmyW9KtXzWrjeY1ii4g==
X-Google-Smtp-Source: ABdhPJzybu2drvZ+TD3/JuYFEM5kqfpJVfzecNoLPDuH8hNIz5GTnDTrgWpvenqQBrCn442mjXASyA==
X-Received: by 2002:a65:648c:: with SMTP id e12mr13283600pgv.123.1611782751382;
        Wed, 27 Jan 2021 13:25:51 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] net: wire up support for file_operations->uring_cmd()
Date:   Wed, 27 Jan 2021 14:25:41 -0700
Message-Id: <20210127212541.88944-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127212541.88944-1-axboe@kernel.dk>
References: <20210127212541.88944-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support for SOCKET_URING_OP_SIOCINQ and SOCKET_URING_OP_SIOCOUTQ
for tcp/udp/raw ipv4/ipv6.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/raw.h        |  3 +++
 include/net/sock.h       |  3 +++
 include/net/tcp.h        |  2 ++
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h | 12 ++++++++++++
 net/ipv4/raw.c           | 23 +++++++++++++++++++++++
 net/ipv4/tcp.c           | 33 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  1 +
 net/ipv4/udp.c           | 14 ++++++++++++++
 net/ipv6/raw.c           |  1 +
 net/ipv6/tcp_ipv6.c      |  1 +
 net/ipv6/udp.c           |  1 +
 12 files changed, 96 insertions(+)

diff --git a/include/net/raw.h b/include/net/raw.h
index 8ad8df594853..fbaa123c2458 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -82,4 +82,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 #endif
 }
 
+int raw_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+		  enum io_uring_cmd_flags flags);
+
 #endif	/* _RAW_H */
diff --git a/include/net/sock.h b/include/net/sock.h
index 129d200bccb4..d0fbd366887a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1146,6 +1146,9 @@ struct proto {
 
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 unsigned long arg);
+	int			(*uring_cmd)(struct sock *sk,
+					struct sock_uring_cmd *scmd,
+					enum io_uring_cmd_flags flags);
 	int			(*init)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..8174d9752e52 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -350,6 +350,8 @@ void tcp_twsk_destructor(struct sock *sk);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
+int tcp_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+			enum io_uring_cmd_flags flags);
 
 void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
 static inline void tcp_dec_quickack_mode(struct sock *sk,
diff --git a/include/net/udp.h b/include/net/udp.h
index 877832bed471..362224fe83fe 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -326,6 +326,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+			enum io_uring_cmd_flags flags);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/include/uapi/linux/net.h b/include/uapi/linux/net.h
index 4dabec6bd957..629e5df40858 100644
--- a/include/uapi/linux/net.h
+++ b/include/uapi/linux/net.h
@@ -55,4 +55,16 @@ typedef enum {
 
 #define __SO_ACCEPTCON	(1 << 16)	/* performed a listen		*/
 
+enum {
+	SOCKET_URING_OP_SIOCINQ		= 0,
+	SOCKET_URING_OP_SIOCOUTQ,
+};
+
+struct sock_uring_cmd {
+	__u16	op;
+	__u16	unused[13];
+	__u64	reserved;		/* will be overwritten by core */
+	__u64	unused2;
+};
+
 #endif /* _UAPI_LINUX_NET_H */
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 50a73178d63a..106200033a60 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -878,6 +878,28 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
 	return do_raw_getsockopt(sk, level, optname, optval, optlen);
 }
 
+int raw_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+		  enum io_uring_cmd_flags flags)
+{
+	switch (scmd->op) {
+	case SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	case SIOCINQ: {
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
+
 static int raw_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -956,6 +978,7 @@ struct proto raw_prot = {
 	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = raw_hash_sk,
 	.unhash		   = raw_unhash_sk,
+	.uring_cmd	   = raw_uring_cmd,
 	.obj_size	   = sizeof(struct raw_sock),
 	.useroffset	   = offsetof(struct raw_sock, filter),
 	.usersize	   = sizeof_field(struct raw_sock, filter),
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 32545ecf2ab1..3757106bc54c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -602,6 +602,39 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 }
 EXPORT_SYMBOL(tcp_poll);
 
+int tcp_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+		  enum io_uring_cmd_flags flags)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	bool slow;
+	int ret;
+
+	switch (scmd->op) {
+	case SIOCINQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		slow = lock_sock_fast(sk);
+		ret = tcp_inq(sk);
+		unlock_sock_fast(sk, slow);
+		break;
+	case SIOCOUTQ:
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
+
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 777306b5bc22..ca3c2654a351 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2788,6 +2788,7 @@ struct proto tcp_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v4_init_sock,
 	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 69ea76578abb..b3ccacf25300 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1676,6 +1676,19 @@ static int first_packet_length(struct sock *sk)
 	return res;
 }
 
+int udp_uring_cmd(struct sock *sk, struct sock_uring_cmd *scmd,
+		  enum io_uring_cmd_flags flags)
+{
+	switch (scmd->op) {
+	case SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	case SIOCINQ:
+		return max_t(int, 0, first_packet_length(sk));
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -2832,6 +2845,7 @@ struct proto udp_prot = {
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
index 0e1509b02cb3..e86af3503a4b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2116,6 +2116,7 @@ struct proto tcpv6_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v6_init_sock,
 	.destroy		= tcp_v6_destroy_sock,
 	.shutdown		= tcp_shutdown,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b9f3dfdd2383..881ae4a1cdda 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1701,6 +1701,7 @@ struct proto udpv6_prot = {
 	.connect		= ip6_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
+	.uring_cmd		= udp_uring_cmd,
 	.init			= udp_init_sock,
 	.destroy		= udpv6_destroy_sock,
 	.setsockopt		= udpv6_setsockopt,
-- 
2.30.0

