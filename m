Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5941933FAD1
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhCQWLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCQWKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:39 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C6BC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:38 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id t7so3021266ilq.5
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QcIC9AJXtpThxMkHO6EHpl8vXTIqJ7UbjVf3Kn/bC7o=;
        b=pz9PXLINzEse5f48mEUswt2YeHFMy7zQw9f9ObmtPhY3P022fn8QSQ/+HUoVxdDdO0
         SsbMoDPHB2E/Nu68mzCgZotkmjNzw1Y4gS+6zmKXN563Sgg1mzkI7tekhnWe+cuOmAFt
         HkyR70fOmRng0SsAWc6aPIRlQsytQYwLg3UIi1HimjoJLONPbM6DsyHI5c7MnQGJzxHj
         am9sowvXT5Nir+w1ZDsN++6Bsl8eCjes2hZbAH54SkENRn9OLFGRGHOyVhHTDxIL8YiZ
         vp/GeiS+1XF1utw2rjvLTMsLw+HjTogkzoNE7sMXTTiC2+RkF+QI2gzEAW7h31GtgRaW
         HTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QcIC9AJXtpThxMkHO6EHpl8vXTIqJ7UbjVf3Kn/bC7o=;
        b=Jc7FeSazJjBJxqHAf7Ov2bhxBwXGW6Bq6PwEXpXr0kOUvw2bYBhHwAUqgPGkZz8/Er
         ExFd8a/+7IWM/+C+CzTHFcYZdD6mZ/56yDiFmULkEXwT2YJFv0slbFhCYYZCckYtFzAZ
         JPQZay3BoHtyp+iZAS1s3xAXlHtVTbAzVUc4lilFgpbb2uR5dzPBOU2vHSd3Wc0cm51W
         OwySmoVY9H75ZHPUXCTz50+YVBoOWPmb/eYLoUw6Ab0vuG2TC8CJBEcIUkFWPor7yg/x
         Ebzej4FqfulSxNIkKZlxQvziKhuGO1J0JMQ2Gadzi6z0iliipJTGdQU9MU6cZsSve9Jf
         jsXA==
X-Gm-Message-State: AOAM533BQJcTisWCaMNt1sLRTkaWH5knPisthIXVgUakD2svlXpuEqQc
        KvTmuh+9tXh6yvy/nNsYeB6CkJLwK4sXoQ==
X-Google-Smtp-Source: ABdhPJyUPe18vW6d4l74brZYi4w3YGoKQOFCe4ikfiz2AzueqCCUYCh7yoEJeqkhNWVsK4cUSpT08Q==
X-Received: by 2002:a92:d352:: with SMTP id a18mr8790000ilh.33.1616019037985;
        Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] net: wire up support for file_operations->uring_cmd()
Date:   Wed, 17 Mar 2021 16:10:26 -0600
Message-Id: <20210317221027.366780-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass it through the proto_ops->uring_cmd() handler, so we can plumb it
through all the way to the proto->uring_cmd() handler.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/net.h  |  2 ++
 include/net/sock.h   |  6 ++++++
 net/core/sock.c      | 17 +++++++++++++++--
 net/dccp/ipv4.c      |  1 +
 net/ipv4/af_inet.c   |  3 +++
 net/l2tp/l2tp_ip.c   |  1 +
 net/mptcp/protocol.c |  1 +
 net/sctp/protocol.c  |  1 +
 net/socket.c         | 13 +++++++++++++
 9 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index ba736b457a06..b61c6cfefc15 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -159,6 +159,8 @@ struct proto_ops {
 	int	 	(*compat_ioctl) (struct socket *sock, unsigned int cmd,
 				      unsigned long arg);
 #endif
+	int		(*uring_cmd)(struct socket *sock, struct io_uring_cmd *cmd,
+					enum io_uring_cmd_flags issue_flags);
 	int		(*gettstamp) (struct socket *sock, void __user *userstamp,
 				      bool timeval, bool time32);
 	int		(*listen)    (struct socket *sock, int len);
diff --git a/include/net/sock.h b/include/net/sock.h
index 636810ddcd9b..9c2921f4357a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -110,6 +110,7 @@ typedef struct {
 struct sock;
 struct proto;
 struct net;
+struct io_uring_cmd;
 
 typedef __u32 __bitwise __portpair;
 typedef __u64 __bitwise __addrpair;
@@ -1146,6 +1147,9 @@ struct proto {
 
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 unsigned long arg);
+	int			(*uring_cmd)(struct sock *sk,
+					struct io_uring_cmd *cmd,
+					enum io_uring_cmd_flags issue_flags);
 	int			(*init)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
@@ -1761,6 +1765,8 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags);
 int sock_common_setsockopt(struct socket *sock, int level, int optname,
 			   sockptr_t optval, unsigned int optlen);
+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
+				enum io_uring_cmd_flags issue_flags);
 
 void sk_common_release(struct sock *sk);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 0ed98f20448a..e3c1bd68fdfd 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3264,6 +3264,18 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
 
+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
+				enum io_uring_cmd_flags issue_flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (!sk->sk_prot || !sk->sk_prot->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sk->sk_prot->uring_cmd(sk, cmd, issue_flags);
+}
+EXPORT_SYMBOL(sock_common_uring_cmd);
+
 void sk_common_release(struct sock *sk)
 {
 	if (sk->sk_prot->destroy)
@@ -3615,7 +3627,7 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 {
 
 	seq_printf(seq, "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s "
-			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
+			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
 		   proto->name,
 		   proto->obj_size,
 		   sock_prot_inuse_get(seq_file_net(seq), proto),
@@ -3629,6 +3641,7 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 		   proto_method_implemented(proto->disconnect),
 		   proto_method_implemented(proto->accept),
 		   proto_method_implemented(proto->ioctl),
+		   proto_method_implemented(proto->uring_cmd),
 		   proto_method_implemented(proto->init),
 		   proto_method_implemented(proto->destroy),
 		   proto_method_implemented(proto->shutdown),
@@ -3657,7 +3670,7 @@ static int proto_seq_show(struct seq_file *seq, void *v)
 			   "maxhdr",
 			   "slab",
 			   "module",
-			   "cl co di ac io in de sh ss gs se re sp bi br ha uh gp em\n");
+			   "cl co di ac io ur in de sh ss gs se re sp bi br ha uh gp em\n");
 	else
 		proto_seq_printf(seq, list_entry(v, struct proto, node));
 	return 0;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 2455b0c0e486..8ba02865ae98 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -983,6 +983,7 @@ static const struct proto_ops inet_dccp_ops = {
 	/* FIXME: work on tcp_poll to rename it to inet_csk_poll */
 	.poll		   = dccp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	/* FIXME: work on inet_listen to rename it to sock_common_listen */
 	.listen		   = inet_dccp_listen,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1355e6c0d567..7dc4d399b2ef 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1030,6 +1030,7 @@ const struct proto_ops inet_stream_ops = {
 	.getname	   = inet_getname,
 	.poll		   = tcp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = inet_listen,
 	.shutdown	   = inet_shutdown,
@@ -1064,6 +1065,7 @@ const struct proto_ops inet_dgram_ops = {
 	.getname	   = inet_getname,
 	.poll		   = udp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
@@ -1095,6 +1097,7 @@ static const struct proto_ops inet_sockraw_ops = {
 	.getname	   = inet_getname,
 	.poll		   = datagram_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 97ae1255fcb6..9b5a4b3b5acb 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -615,6 +615,7 @@ static const struct proto_ops l2tp_ip_ops = {
 	.getname	   = l2tp_ip_getname,
 	.poll		   = datagram_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 76958570ae7f..7f61fb783f50 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3454,6 +3454,7 @@ static const struct proto_ops mptcp_stream_ops = {
 	.getname	   = inet_getname,
 	.poll		   = mptcp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = mptcp_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6f2bbfeec3a4..fdb960e752b3 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1133,6 +1133,7 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.getname	   = inet_getname,	/* Semantics are different.  */
 	.poll		   = sctp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sctp_inet_listen,
 	.shutdown	   = inet_shutdown,	/* Looks harmless.  */
diff --git a/net/socket.c b/net/socket.c
index 84a8049c2b09..19ab0986af9d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -86,6 +86,7 @@
 #include <linux/xattr.h>
 #include <linux/nospec.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -113,6 +114,7 @@ unsigned int sysctl_net_busy_poll __read_mostly;
 static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to);
 static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from);
 static int sock_mmap(struct file *file, struct vm_area_struct *vma);
+static int sock_uring_cmd(struct io_uring_cmd *cmd, enum io_uring_cmd_flags issue_flags);
 
 static int sock_close(struct inode *inode, struct file *file);
 static __poll_t sock_poll(struct file *file,
@@ -156,6 +158,7 @@ static const struct file_operations socket_file_ops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_sock_ioctl,
 #endif
+	.uring_cmd =	sock_uring_cmd,
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
@@ -1182,6 +1185,16 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return err;
 }
 
+static int sock_uring_cmd(struct io_uring_cmd *cmd, enum io_uring_cmd_flags issue_flags)
+{
+	struct socket *sock = cmd->file->private_data;
+
+	if (!sock->ops || !sock->ops->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sock->ops->uring_cmd(sock, cmd, issue_flags);
+}
+
 /**
  *	sock_create_lite - creates a socket
  *	@family: protocol family (AF_INET, ...)
-- 
2.31.0

