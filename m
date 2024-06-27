Return-Path: <io-uring+bounces-2371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C672F91A735
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BE10282140
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE543179211;
	Thu, 27 Jun 2024 12:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmOKsqmD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C51849FC;
	Thu, 27 Jun 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493190; cv=none; b=V9EDHdj2uIUCdoXp3E8Y1jQQKUykjq5Z11dcBOCTx/vc+rBoTjdlZPDU1ZQigVRclK3CuwABPeEgREuqAL8d/uHoeysiyNNV10CeJbPC7w8/EjHMDAJw1SIlfRqOP7WdlKGlUH72PwIa0AE/TsPiRrvCAQbJnc1Y9+/vb3uq7JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493190; c=relaxed/simple;
	bh=LspUSUQisVXEzuvKb/HhQ7sazs/RezEAljb8kvYO+/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ficUMHi58oEtn2lQmJLmwvCwcyO+t1tl68Tl63TDrEbJqvTK+SGTLPqF06Bcb+GOQTMDfOxc6B3VBhMl2ZqQB74Vz5YTdixiU+66r6bEFCYSfbybewUjaI1Hvjo3QnPSl2imMA9ofQ8Onux9CElFKWDKoVOmdWb8jbIbOdFoY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmOKsqmD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a72510ebc3fso698398366b.2;
        Thu, 27 Jun 2024 05:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493187; x=1720097987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMm73DkQQbIKqvrdgDxsT4wUsrpx/7Ch+5m3Ck5HfkI=;
        b=SmOKsqmDk+u+cQy2fQWjr7jwEsos+IX+lnHlhMkJmWVK68yrxQ//Sd3FAsRBCDL7HV
         2icjMYR2dTBgWJn8QYbqI8NkDp/ZsxCq5cVpeRaoUTe3lRBXOtyJMgGx9esaPDTtB8H+
         zL+b24TITYBLXU5VPxWTw0dUibzOmVC5agrdL1sCmqNDurG+SAx6jRfDYJx+hKWeO4lI
         4IdcVdVleJZJqXuOMMCfggFvx97h1OEjVjFo8SDLDVE8cWgLgeosqI91jkM/tQ4WM11O
         nGutI9/XHrPZuRy7sZKT2TJU6Rwnm9YyvKXFI/mHfwPPyPMJ0Ko0ITItJrvBThF7JSKo
         6lnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493187; x=1720097987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMm73DkQQbIKqvrdgDxsT4wUsrpx/7Ch+5m3Ck5HfkI=;
        b=aNt5VbReomyZ7dJPsdUXmyUs+ul6nvYVTJFKvKqaR2bTJJEnk77DQDset1auj3DDIo
         KZ7Cbq48sZ3/GHcYlzLio39Dx3FCC3/McQqsD4bGEaPIMuRbhfGCzu9OZG29Md+/061X
         m46nGjlQIErGYmdtVcxjoBCJWtqSmrhZsOogDSwTkZWwN31dX2RT5gtRsGnTCAGbZ48I
         ZD/jJ2Mbh2sI7ecFa9dePEvVDJx7WuEpt8Xt9XJ/TcVUUfb1uOBEJWbPF34W8ZvJnqKm
         Tornl9xG697WSX59IHIfKZ12zWF4geSfxEKTXxB4HVlG3D0wC3T6OmXBo2xrrNAwCdlr
         BRCw==
X-Forwarded-Encrypted: i=1; AJvYcCU8FN7XYqSp7K9Fu5iSAMHMhKRIdq16KqxJ96gdKTDNl998IC6gqypV0K1k7BFFys+8YsbJLf7vgqpCyhdUuStd1I/LAeJP
X-Gm-Message-State: AOJu0YxBXksEBgm/sviz54PgazKWbZYGLRFlAiC0ubA4PhTihMGgAVoo
	Wg0TVtB5UFVL26aJ80IvYyCXFI8tc5byMqiTRKSGZweVapcTeEPgKXCTSKMS
X-Google-Smtp-Source: AGHT+IF7w1FciUHwpOTOnu9uCADI6XtyROo6IXITmFVw9xvMf6MobEAU9TB6ZODtgxksRY3Th1iSQg==
X-Received: by 2002:a17:906:7f89:b0:a6f:bf0f:4209 with SMTP id a640c23a62f3a-a7242c4b8c4mr1009588566b.42.1719493186099;
        Thu, 27 Jun 2024 05:59:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 4/5] io_uring/net: move charging socket out of zc io_uring
Date: Thu, 27 Jun 2024 13:59:44 +0100
Message-ID: <1e55ad85b726d50a45bdd35fc04e1565d3ba7896.1719190216.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, io_uring's io_sg_from_iter() duplicates the part of
__zerocopy_sg_from_iter() charging pages to the socket. It'd be too easy
to miss while changing it in net/, the chunk is not the most
straightforward for outside users and full of internal implementation
details. io_uring is not a good place to keep it, deduplicate it by
moving out of the callback into __zerocopy_sg_from_iter().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h |  3 +++
 include/linux/socket.h |  2 +-
 io_uring/net.c         | 16 ++++------------
 net/core/datagram.c    | 10 +++++-----
 4 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f4cda3fbdb75..9c29bdd5596d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1703,6 +1703,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
 			    size_t length);
 
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length);
+
 static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
 					  struct msghdr *msg, int len)
 {
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 89d16b90370b..2a1ff91d1914 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -76,7 +76,7 @@ struct msghdr {
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 	struct ubuf_info *msg_ubuf;
-	int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
+	int (*sg_from_iter)(struct sk_buff *skb,
 			    struct iov_iter *from, size_t length);
 };
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 7c98c4d50946..84a7602bcef1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1265,14 +1265,14 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG_ZC);
 }
 
-static int io_sg_from_iter_iovec(struct sock *sk, struct sk_buff *skb,
+static int io_sg_from_iter_iovec(struct sk_buff *skb,
 				 struct iov_iter *from, size_t length)
 {
 	skb_zcopy_downgrade_managed(skb);
-	return __zerocopy_sg_from_iter(NULL, sk, skb, from, length);
+	return zerocopy_fill_skb_from_iter(skb, from, length);
 }
 
-static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
+static int io_sg_from_iter(struct sk_buff *skb,
 			   struct iov_iter *from, size_t length)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -1285,7 +1285,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	if (!frag)
 		shinfo->flags |= SKBFL_MANAGED_FRAG_REFS;
 	else if (unlikely(!skb_zcopy_managed(skb)))
-		return __zerocopy_sg_from_iter(NULL, sk, skb, from, length);
+		return zerocopy_fill_skb_from_iter(skb, from, length);
 
 	bi.bi_size = min(from->count, length);
 	bi.bi_bvec_done = from->iov_offset;
@@ -1312,14 +1312,6 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	skb->data_len += copied;
 	skb->len += copied;
 	skb->truesize += truesize;
-
-	if (sk && sk->sk_type == SOCK_STREAM) {
-		sk_wmem_queued_add(sk, truesize);
-		if (!skb_zcopy_pure(skb))
-			sk_mem_charge(sk, truesize);
-	} else {
-		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
-	}
 	return ret;
 }
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 2b24d69b1e94..554316c40883 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -610,8 +610,8 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
-static int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
-					struct iov_iter *from, size_t length)
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
 
@@ -687,11 +687,11 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	int ret;
 
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
-		return msg->sg_from_iter(sk, skb, from, length);
+		ret = msg->sg_from_iter(skb, from, length);
+	else
+		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
-	ret = zerocopy_fill_skb_from_iter(skb, from, length);
 	truesize = skb->truesize - orig_size;
-
 	if (sk && sk->sk_type == SOCK_STREAM) {
 		sk_wmem_queued_add(sk, truesize);
 		if (!skb_zcopy_pure(skb))
-- 
2.44.0


