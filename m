Return-Path: <io-uring+bounces-2370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30EEC91A734
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83B83B216AC
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59811849D2;
	Thu, 27 Jun 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGxz62ry"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289681849D7;
	Thu, 27 Jun 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493188; cv=none; b=ajj/yVDU16/b6OOQgpoOgZZ3TxVpLnnCyuPx7VC0A99HESZc+sPFDAXDbFNQFfMm2GuLw++qwrnYJrISCWJVj4/YXam/16EBGfBP9piKCgoFlVArqE1W5QiBVScF7UlTvOFSdr8ouYNlogUI0w+j/jU317na9FBtYfpP6NjZe2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493188; c=relaxed/simple;
	bh=WZxjExbJY57zIqoo/+Q9dKxeNZQlbSRr32BEuf/2Xpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOOamlgjwlaafx/L4+w/z6LJGZ2CUaYCgV096ccdzKoxWNpanfypZ3uml/5Y1p4vhvQ5FRJTtzQkQO5Jl1O1tu5rHNoyRIIncl4ovR6W2+qsWvNyFqeOeM3n38UqpGvKixBb/F1ssIxHJzJPN/69X6gjUvyE13WzsEMRkIci0o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGxz62ry; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57d1012e52fso1613146a12.3;
        Thu, 27 Jun 2024 05:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493185; x=1720097985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fjc6mD01lmIiX8GcrjloiH+OKRZl4anANwhXBkOfgDs=;
        b=iGxz62ryF96GBKQtDKtG8t33dTCiEM0we3u51384ajByV22dVx2KgarETQNyyylvpV
         /qlhgW0x1L4nrj5tgjzAG2sfiIU9leFwfs7Ptz9m4DIAkCF+/icPNjYqBAPu3K44jGL6
         wsHqj597MIfyKXQw175celdDG+sFGIenzlG/egIgk7aZx/5D4yrwxZfvxHLk/JxIcOib
         k9DFE2/3DchPt/9DsJ1OxKoTpmPnY4ZQu4rMPcJn31chRrdOL7aVw6eShyXIMzP6fLCU
         5X87nPgkXd6NLR5w6xIesRpfJ0g7SFkz5jOscythgA/C3Bd2c1QMVbrkUDOx4eQN4Zxd
         3SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493185; x=1720097985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fjc6mD01lmIiX8GcrjloiH+OKRZl4anANwhXBkOfgDs=;
        b=v2fZEd81Pil1UYCJBkpTau+/oIUFg9BdIw7WPpXRdVTQ4Z0n4rQKVHCsZV3ILOnoGH
         A9unVC4JyXP4jCSljSYQhWC8kk5Vff2nKrOLSG6rPQTtMsK3lXet0aarBYosRTqLYrXW
         ghwo9QChq+YrOvrdQgBB9ylbxle6q7ADK1EFmKTR1EysgqSK6ddszamziK8H6ZNOfIlX
         GRhUvjz9AAzhl0dO2gxjxF1TEVrAS1gr3zBjooyKjJl1BQu0jAvqZ8gsnNZLZ+cpTQVp
         0lH3AkH8sI2vF0KBxE9+b2nMhV98CAl8QKCi4CJ1YncWG7/YlBJi0bGoEjMdq11hDX6l
         qYIw==
X-Forwarded-Encrypted: i=1; AJvYcCUo25U33sAsJ7kf43s1Njib9rE8UAnGHvUjcKCaQ8Vx9q1Ah9buijlFcrnOJWTJ2/pWYGil4kB2xlxJ86m/DOaQGmkmARfp
X-Gm-Message-State: AOJu0YyjuBG3Bo0y84Dh4bS37cxjSk8QIZ5XpFevIoIedOMdWpTPoS5y
	dgQUzXdY+mTffwSFYgshWnIpFAGOfTwn8WcXJzJQwP8LxTyeW1jw76kyDRwG
X-Google-Smtp-Source: AGHT+IGbuT+N1shQBBUGGLsCg2q0mwzzoD0BaJYqv6R8boS/hyhHmCkRjehm64p2pcLMeitVmaTCUQ==
X-Received: by 2002:a17:907:368a:b0:a72:98a0:2bfc with SMTP id a640c23a62f3a-a7298a02d4amr188678166b.17.1719493184686;
        Thu, 27 Jun 2024 05:59:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:43 -0700 (PDT)
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
Subject: [PATCH net-next 3/5] net: batch zerocopy_fill_skb_from_iter accounting
Date: Thu, 27 Jun 2024 13:59:43 +0100
Message-ID: <a916f99aa91bc9066411015835cadd5677a454fb.1719190216.git.asml.silence@gmail.com>
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

Instead of accounting every page range against the socket separately, do
it in batch based on the change in skb->truesize. It's also moved into
__zerocopy_sg_from_iter(), so that zerocopy_fill_skb_from_iter() is
simpler and responsible for setting frags but not the accounting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/datagram.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 7f7d5da2e406..2b24d69b1e94 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -610,7 +610,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
-static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
+static int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 					struct iov_iter *from, size_t length)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
@@ -621,7 +621,6 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
 		int refs, order, n = 0;
 		size_t start;
 		ssize_t copied;
-		unsigned long truesize;
 
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
@@ -633,17 +632,9 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
 
 		length -= copied;
 
-		truesize = PAGE_ALIGN(copied + start);
 		skb->data_len += copied;
 		skb->len += copied;
-		skb->truesize += truesize;
-		if (sk && sk->sk_type == SOCK_STREAM) {
-			sk_wmem_queued_add(sk, truesize);
-			if (!skb_zcopy_pure(skb))
-				sk_mem_charge(sk, truesize);
-		} else {
-			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
-		}
+		skb->truesize += PAGE_ALIGN(copied + start);
 
 		head = compound_head(pages[n]);
 		order = compound_order(head);
@@ -691,10 +682,24 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
 			    size_t length)
 {
+	unsigned long orig_size = skb->truesize;
+	unsigned long truesize;
+	int ret;
+
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		return msg->sg_from_iter(sk, skb, from, length);
-	else
-		return zerocopy_fill_skb_from_iter(sk, skb, from, length);
+
+	ret = zerocopy_fill_skb_from_iter(skb, from, length);
+	truesize = skb->truesize - orig_size;
+
+	if (sk && sk->sk_type == SOCK_STREAM) {
+		sk_wmem_queued_add(sk, truesize);
+		if (!skb_zcopy_pure(skb))
+			sk_mem_charge(sk, truesize);
+	} else {
+		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
+	}
+	return ret;
 }
 EXPORT_SYMBOL(__zerocopy_sg_from_iter);
 
-- 
2.44.0


