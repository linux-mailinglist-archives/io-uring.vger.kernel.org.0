Return-Path: <io-uring+bounces-1593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6397D8AAD69
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AB96282E3D
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B6D85635;
	Fri, 19 Apr 2024 11:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnQDYn+6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FC984D2E;
	Fri, 19 Apr 2024 11:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524931; cv=none; b=G2XKu6Wm6nZNWqNeN+PSYSerqpNz0/fnj9sH0qAn9RsC5cmo2kS7ztpp5nbP3khgb4/FYnHtk4M+/oGpXODdNtUQupurXPvWQsvOD3bQV00pIY+P0HpeT6KR1NXcF4PDnqK4vPqoUk3/RAUdJmMVacUOReNnjv5DCvORYcqQQUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524931; c=relaxed/simple;
	bh=sgd0fnLt4r0RsBT24bZl6Ymc5Cr9jd8UGDKTw3oGxVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfJtab+Ukz3wv3uutNRcZZvZN8lGL9IBlfKA/vA3ahYoFYyqsTql4BtDEzvxrZ0kxYYMMDvZIDhhojIeYEWK3m71hVJ0AhzGnyuvVbu4Qu6A0tNI4NsinKvKd7a5c1J38vKIK30A7ZNQUvSa5oXHmKAlxBC0I3nbn5totIF32UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnQDYn+6; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a5561b88bb3so207744866b.0;
        Fri, 19 Apr 2024 04:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713524928; x=1714129728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fP3T1HRg4APmOPCr1i20fy3OAFGb9fSrnxRLKsDwOU=;
        b=FnQDYn+6iSLNMs9xOgGywna20u9bs/S15XW0t1y85QovUidQy5rFapaq06PRVB61Hk
         Cisnk/PfejXxYWgfSpmCJ28IPV9Mivl6M2WMkS+Pb1noomVBjvUeV4sf0Wgc8c8b2tWc
         UF82mCV/wBeqY4Do5hZbpSsY215JK2Oi78XqqAkxmviTt5CvQPjcS44UEAsAGavjNQ/0
         qbra4Gcq8Qww4/QMR2GDzDNwLqKRZDuD/YoqACVSNNScWHLvvF2rg+pMMB1/34CNl3ak
         dQAmKbAW9Zgeu6M0nT9m6FG39TAitVhpTQglh3joIAz/Mbx/sZ8pL9PbPU4glUxxL8BP
         zjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713524928; x=1714129728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fP3T1HRg4APmOPCr1i20fy3OAFGb9fSrnxRLKsDwOU=;
        b=w6gTjJECk8WQifhJSTDRdbqyNhWVpdjSAJyM1d/KhmE0PW1b6f71+uufsHwasXB7k2
         66vfygy8iSuBWAsZMil3UlYE7R6196kHSrVzx6MmtPhLwSQ0uDGFzXrrX9x7iPzUkjX5
         i9QvEqmyCnmp9ziHQM5YgkJNH/6G9+j+AXFZgIIJjDn6g2oM94mWxkQmwaDy5eIvP02u
         BWzTTxVa2RIp+4MngWxKcseiVLXSJB3AJ9S2eH5u1ZdqRhjehFKhRfGsm+gzut0a28nd
         ethBqJSv+Q0CDi5SIvNKMAbJCOLCWOywBjTnuislRGdYL1/PONJrW1xwPh0+V1TAJV2K
         HMJA==
X-Forwarded-Encrypted: i=1; AJvYcCVCR7jymh/4t7ZkELLLjMo2vzUr9nxKufjLZGj2P/zI15E821EankDuOILkJAMxj5BXcPsSPdLTEzjHyjC/dMBeVIHeNDlc6iu+2hNM7PHeow9DzxLaH2Ef/1Ul
X-Gm-Message-State: AOJu0YyX5TYhEdvEm8jqzzPS1bOWVjvPHthlBe94Muhhe+0n/LjNjqPk
	E8fTy9h0bz2JWVjpAQ9YodKiPGs9JVNAFuLhw6ppvyR+PmWniXda3kYJOA==
X-Google-Smtp-Source: AGHT+IFy2QsdrmLfOtT9EYc1USivrPyf0Bwi5GEdqAq0Fpn53sZdiNwWQaN42/Mf/SYmqQzPfik1yw==
X-Received: by 2002:a17:906:a206:b0:a52:2c00:9850 with SMTP id r6-20020a170906a20600b00a522c009850mr1380280ejy.59.1713524927726;
        Fri, 19 Apr 2024 04:08:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a4739efd7cesm2082525ejp.60.2024.04.19.04.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 04:08:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH io_uring-next/net-next v2 4/4] io_uring/notif: implement notification stacking
Date: Fri, 19 Apr 2024 12:08:42 +0100
Message-ID: <bf1e7f9b72f9ecc99999fdc0d2cded5eea87fd0b.1713369317.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The network stack allows only one ubuf_info per skb, and unlike
MSG_ZEROCOPY, each io_uring zerocopy send will carry a separate
ubuf_info. That means that send requests can't reuse a previosly
allocated skb and need to get one more or more of new ones. That's fine
for large sends, but otherwise it would spam the stack with lots of skbs
carrying just a little data each.

To help with that implement linking notification (i.e. an io_uring wrapper
around ubuf_info) into a list. Each is refcounted by skbs and the stack
as usual. additionally all non head entries keep a reference to the
head, which they put down when their refcount hits 0. When the head have
no more users, it'll efficiently put all notifications in a batch.

As mentioned previously about ->io_link_skb, the callback implementation
always allows to bind to an skb without a ubuf_info.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 71 +++++++++++++++++++++++++++++++++++++++++++-----
 io_uring/notif.h |  3 ++
 2 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 26680176335f..d58cdc01e691 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,18 +9,28 @@
 #include "notif.h"
 #include "rsrc.h"
 
+static const struct ubuf_info_ops io_ubuf_ops;
+
 static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
-	if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
-		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+	do {
+		notif = cmd_to_io_kiocb(nd);
 
-	if (nd->account_pages && notif->ctx->user) {
-		__io_unaccount_mem(notif->ctx->user, nd->account_pages);
-		nd->account_pages = 0;
-	}
-	io_req_task_complete(notif, ts);
+		lockdep_assert(refcount_read(&nd->uarg.refcnt) == 0);
+
+		if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
+			notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
+		if (nd->account_pages && notif->ctx->user) {
+			__io_unaccount_mem(notif->ctx->user, nd->account_pages);
+			nd->account_pages = 0;
+		}
+
+		nd = nd->next;
+		io_req_task_complete(notif, ts);
+	} while (nd);
 }
 
 void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
@@ -39,12 +49,56 @@ void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 	if (!refcount_dec_and_test(&uarg->refcnt))
 		return;
 
+	if (nd->head != nd) {
+		io_tx_ubuf_complete(skb, &nd->head->uarg, success);
+		return;
+	}
 	notif->io_task_work.func = io_notif_tw_complete;
 	__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
+static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
+{
+	struct io_notif_data *nd, *prev_nd;
+	struct io_kiocb *prev_notif, *notif;
+	struct ubuf_info *prev_uarg = skb_zcopy(skb);
+
+	nd = container_of(uarg, struct io_notif_data, uarg);
+	notif = cmd_to_io_kiocb(nd);
+
+	if (!prev_uarg) {
+		net_zcopy_get(&nd->uarg);
+		skb_zcopy_init(skb, &nd->uarg);
+		return 0;
+	}
+	/* handle it separately as we can't link a notif to itself */
+	if (unlikely(prev_uarg == &nd->uarg))
+		return 0;
+	/* we can't join two links together, just request a fresh skb */
+	if (unlikely(nd->head != nd || nd->next))
+		return -EEXIST;
+	/* don't mix zc providers */
+	if (unlikely(prev_uarg->ops != &io_ubuf_ops))
+		return -EEXIST;
+
+	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
+	prev_notif = cmd_to_io_kiocb(nd);
+
+	/* make sure all noifications can be finished in the same task_work */
+	if (unlikely(notif->ctx != prev_notif->ctx ||
+		     notif->task != prev_notif->task))
+		return -EEXIST;
+
+	nd->head = prev_nd->head;
+	nd->next = prev_nd->next;
+	prev_nd->next = nd;
+	net_zcopy_get(&nd->head->uarg);
+	return 0;
+}
+
 static const struct ubuf_info_ops io_ubuf_ops = {
 	.complete = io_tx_ubuf_complete,
+	.link_skb = io_link_skb,
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -65,6 +119,9 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	nd = io_notif_to_data(notif);
 	nd->zc_report = false;
 	nd->account_pages = 0;
+	nd->next = NULL;
+	nd->head = nd;
+
 	nd->uarg.flags = IO_NOTIF_UBUF_FLAGS;
 	nd->uarg.ops = &io_ubuf_ops;
 	refcount_set(&nd->uarg.refcnt, 1);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 2cf9ff6abd7a..f3589cfef4a9 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -14,6 +14,9 @@ struct io_notif_data {
 	struct file		*file;
 	struct ubuf_info	uarg;
 
+	struct io_notif_data	*next;
+	struct io_notif_data	*head;
+
 	unsigned		account_pages;
 	bool			zc_report;
 	bool			zc_used;
-- 
2.44.0


