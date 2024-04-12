Return-Path: <io-uring+bounces-1521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C918A2EA3
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A34871F233AE
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D355A11D;
	Fri, 12 Apr 2024 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmcVR+0H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466F45A0F1;
	Fri, 12 Apr 2024 12:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926539; cv=none; b=DJ4HK0vupYlR1SlmYRRdmZkh0KeX5YcYK0nP4fpCLKuiiVzmPXepNPe/abHi8RWWP4LdGw5JRgUmvhxjx0mFO5kI5F1eGDNcZKNDG6cphG1sBF7AQG/gLLORl5zOgTkNIIBI+g5GEXc8ASoKYWRSGAvsly/EzPd7MaEvBa5IGdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926539; c=relaxed/simple;
	bh=+J6ZIjWMtQpY2a/JESoUxz7LG42hzE5YzesreEyeq9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNIFfBQ5XMd91qXAGK0/oSfcIRe1q/x5uiMk15wbIp5D8cDQ2wlLsFI2wiXJ59ibWzHzmFwe/3j/2d0tjlIJaYe4tIpa9qIZ26xd4O5EhNbSgxylRg99KB2/D+pUlQCJRGROmBCdhVCs+6WSV0GEOTylTbA0TNALIfx6gvtSTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmcVR+0H; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a4715991c32so109284566b.1;
        Fri, 12 Apr 2024 05:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926535; x=1713531335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+ZC7kUGHtaoxOSEWHEf09FVIWFyHEq4CFf55bkSPKQ=;
        b=lmcVR+0HOPdlp13B+3s98sd4FGuoRXXuBGDgxFLIzKnoQq0Xi280pKAebG/pUKiMGC
         5rwqIvOYUjAgenKLU40cit1COZ3CAh1/leQzuQuGjBC51uTUolxgZ8uenF4QOx8T1jyO
         C33zuYmBZlQZImwHNmmVXfCfvxVvio8bIInQ6lHN31ibjBw4770mDaEcak1g1Du0Zc8+
         l/1dbbu8JqEyM6Q5AzsaDyf+Xval+lXSnA3J+peQ+nRWIr8WY9MWfAG4Uz5cT2oWQRt0
         d514H9iNpJWXJE97nBUA8RKuqkyrg3G3xaYqo+EFKpTE5hfUzKOMCtUlt3V2sxfuY/RT
         xMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926535; x=1713531335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+ZC7kUGHtaoxOSEWHEf09FVIWFyHEq4CFf55bkSPKQ=;
        b=VuD6/WQjkV7ESm4vcljCB+WD/NAbJuJLJ+EB5dw2ZvCQfWpuMxRTqM8l2qylO7RfAs
         /tkwk5jT7AqwiRJjRxcWLL++b4kOThWXcSfkmRshwIX7VilU57zIbvLVbeSRiP673bkU
         HuwtRUDAQgk6+CqIWAsOxWR5EB3tNfbGl3KstpxC6j5hYHSqC6L/USEU3X2p4H18ye/P
         /zJL2an01Pzj/xLkzW0p18QaB0SdfE92eLCBGKPIxPaBc2JjRmWwrED/nwoZxRdkjKTN
         +BZa1SOy2LM9ip7fIFVrvTZRBtMRHwmU7CPQWHUM7c0LfVphcKvjsr5OQu69qRAvysSZ
         Ddaw==
X-Forwarded-Encrypted: i=1; AJvYcCV6xcLbLc01s+JFxlRouxbDyBSaCTEICTNXFb8hKembG0wC/+rnX7/AzC7MfD+dn/8vji7ffgFuQua4sutVGHMcaXujGzpZ
X-Gm-Message-State: AOJu0YzCpMDMPMaoPKIlp4kR5qaaS5WOZfzi/z997Oq5NKNo5GNu3fXU
	pcjVk8sVwwE+qGqkWjmX/T/HU8fSrOyIAAjt/QisInrLC2Tclmi0rZw0vA==
X-Google-Smtp-Source: AGHT+IGic95rkODjnCp3+iDkZNikLHY1laWxB/nSxwKlIaRWZKcnyrG/ntgHs0sWENYiUz5IuWjWeA==
X-Received: by 2002:a17:906:d20d:b0:a51:ad60:ea32 with SMTP id w13-20020a170906d20d00b00a51ad60ea32mr1455939ejz.27.1712926535420;
        Fri, 12 Apr 2024 05:55:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:34 -0700 (PDT)
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
Subject: [RFC 1/6] net: extend ubuf_info callback to ops structure
Date: Fri, 12 Apr 2024 13:55:22 +0100
Message-ID: <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need to associate additional callbacks with ubuf_info, introduce
a structure holding ubuf_info callbacks. Apart from a more smarter
io_uring notification management introduced in next patches, it can be
used to generalise msg_zerocopy_put_abort() and also store
->sg_from_iter, which is currently passed in struct msghdr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/tap.c      |  2 +-
 drivers/net/tun.c      |  2 +-
 drivers/vhost/net.c    |  8 ++++++--
 include/linux/skbuff.h | 19 +++++++++++--------
 io_uring/notif.c       |  8 ++++++--
 net/core/skbuff.c      | 17 +++++++++++------
 6 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9f0495e8df4d..bfdd3875fe86 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -754,7 +754,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		skb_zcopy_init(skb, msg_control);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(NULL, uarg, false);
+		uarg->ops->complete(NULL, uarg, false);
 	}
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0b3f21cba552..b7401d990680 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1906,7 +1906,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_zcopy_init(skb, msg_control);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(NULL, uarg, false);
+		uarg->ops->complete(NULL, uarg, false);
 	}
 
 	skb_reset_network_header(skb);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c64ded183f8d..f16279351db5 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -380,7 +380,7 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 	}
 }
 
-static void vhost_zerocopy_callback(struct sk_buff *skb,
+static void vhost_zerocopy_complete(struct sk_buff *skb,
 				    struct ubuf_info *ubuf_base, bool success)
 {
 	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
@@ -408,6 +408,10 @@ static void vhost_zerocopy_callback(struct sk_buff *skb,
 	rcu_read_unlock_bh();
 }
 
+static const struct ubuf_info_ops vhost_ubuf_ops = {
+	.complete = vhost_zerocopy_complete,
+};
+
 static inline unsigned long busy_clock(void)
 {
 	return local_clock() >> 10;
@@ -879,7 +883,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
-			ubuf->ubuf.callback = vhost_zerocopy_callback;
+			ubuf->ubuf.ops = &vhost_ubuf_ops;
 			ubuf->ubuf.flags = SKBFL_ZEROCOPY_FRAG;
 			refcount_set(&ubuf->ubuf.refcnt, 1);
 			msg.msg_control = &ctl;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9d24aec064e8..a110e97e074a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -527,6 +527,11 @@ enum {
 #define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
 				 SKBFL_DONT_ORPHAN | SKBFL_MANAGED_FRAG_REFS)
 
+struct ubuf_info_ops {
+	void (*complete)(struct sk_buff *, struct ubuf_info *,
+			 bool zerocopy_success);
+};
+
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
@@ -536,8 +541,7 @@ enum {
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct sk_buff *, struct ubuf_info *,
-			 bool zerocopy_success);
+	const struct ubuf_info_ops *ops;
 	refcount_t refcnt;
 	u8 flags;
 };
@@ -1662,14 +1666,13 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 }
 #endif
 
+extern const struct ubuf_info_ops msg_zerocopy_ubuf_ops;
+
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 				       struct ubuf_info *uarg);
 
 void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
-void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
-			   bool success);
-
 int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
 			    size_t length);
@@ -1757,13 +1760,13 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 static inline void net_zcopy_put(struct ubuf_info *uarg)
 {
 	if (uarg)
-		uarg->callback(NULL, uarg, true);
+		uarg->ops->complete(NULL, uarg, true);
 }
 
 static inline void net_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	if (uarg) {
-		if (uarg->callback == msg_zerocopy_callback)
+		if (uarg->ops == &msg_zerocopy_ubuf_ops)
 			msg_zerocopy_put_abort(uarg, have_uref);
 		else if (have_uref)
 			net_zcopy_put(uarg);
@@ -1777,7 +1780,7 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 
 	if (uarg) {
 		if (!skb_zcopy_is_nouarg(skb))
-			uarg->callback(skb, uarg, zerocopy_success);
+			uarg->ops->complete(skb, uarg, zerocopy_success);
 
 		skb_shinfo(skb)->flags &= ~SKBFL_ALL_ZEROCOPY;
 	}
diff --git a/io_uring/notif.c b/io_uring/notif.c
index b561bd763435..7caaebf94312 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -24,7 +24,7 @@ void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 	io_req_task_complete(notif, ts);
 }
 
-static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+static void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 				bool success)
 {
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
@@ -43,6 +43,10 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	}
 }
 
+static const struct ubuf_info_ops io_ubuf_ops = {
+	.complete = io_tx_ubuf_complete,
+};
+
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
@@ -62,7 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	nd->zc_report = false;
 	nd->account_pages = 0;
 	nd->uarg.flags = IO_NOTIF_UBUF_FLAGS;
-	nd->uarg.callback = io_tx_ubuf_callback;
+	nd->uarg.ops = &io_ubuf_ops;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b99127712e67..749abab23a67 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1708,7 +1708,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 		return NULL;
 	}
 
-	uarg->ubuf.callback = msg_zerocopy_callback;
+	uarg->ubuf.ops = &msg_zerocopy_ubuf_ops;
 	uarg->id = ((u32)atomic_inc_return(&sk->sk_zckey)) - 1;
 	uarg->len = 1;
 	uarg->bytelen = size;
@@ -1734,7 +1734,7 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 		u32 bytelen, next;
 
 		/* there might be non MSG_ZEROCOPY users */
-		if (uarg->callback != msg_zerocopy_callback)
+		if (uarg->ops != &msg_zerocopy_ubuf_ops)
 			return NULL;
 
 		/* realloc only when socket is locked (TCP, UDP cork),
@@ -1845,8 +1845,8 @@ static void __msg_zerocopy_callback(struct ubuf_info_msgzc *uarg)
 	sock_put(sk);
 }
 
-void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
-			   bool success)
+static void msg_zerocopy_complete(struct sk_buff *skb, struct ubuf_info *uarg,
+				  bool success)
 {
 	struct ubuf_info_msgzc *uarg_zc = uarg_to_msgzc(uarg);
 
@@ -1855,7 +1855,7 @@ void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	if (refcount_dec_and_test(&uarg->refcnt))
 		__msg_zerocopy_callback(uarg_zc);
 }
-EXPORT_SYMBOL_GPL(msg_zerocopy_callback);
+
 
 void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
@@ -1865,10 +1865,15 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 	uarg_to_msgzc(uarg)->len--;
 
 	if (have_uref)
-		msg_zerocopy_callback(NULL, uarg, true);
+		msg_zerocopy_complete(NULL, uarg, true);
 }
 EXPORT_SYMBOL_GPL(msg_zerocopy_put_abort);
 
+const struct ubuf_info_ops msg_zerocopy_ubuf_ops = {
+	.complete = msg_zerocopy_complete,
+};
+EXPORT_SYMBOL_GPL(msg_zerocopy_ubuf_ops);
+
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
-- 
2.44.0


