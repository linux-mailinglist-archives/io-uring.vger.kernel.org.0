Return-Path: <io-uring+bounces-1526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 158008A2EAE
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 384031C22840
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3405B694;
	Fri, 12 Apr 2024 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEFTQt27"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63235C61A;
	Fri, 12 Apr 2024 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926544; cv=none; b=AABxc1E/y3WNc0IX3UHzcdCRh41b9XbW6NMQoI+hwUjOEW4z48i0dNbp+x2cSP0YY1jLAPlwliQOWQYhrVwNmLSxvavmGM2n4lxXr95CVXTxBZ+ouNa2kyh56KhU7iTTTm3kR6ICGTOGezzBU9Aod+G8jFIzCyFtMmjsNOAIl7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926544; c=relaxed/simple;
	bh=rr1yCQeGebZn9uchHo/5phlmbfa/+1Hr89YHFY9SqYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb4OroNDENglymqDUBATieeLD0JWNkI8JpyLM5CQyEMaQUxuIee/I8A3AxGLMAzjeLkH7zW52utpwE4kHbdmFQ8irQyK1tk5wm99tnvEdzYf8RL6WixtczceGazQcpktw7vhZ6rNK9gsyJOQmXWFlR35kw5vTEfQrUnVBagm7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VEFTQt27; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a51a7d4466bso104907866b.2;
        Fri, 12 Apr 2024 05:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926540; x=1713531340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRv+s3gr19+ls832LKX6BTVWxWU26v5TpvDr6QThETk=;
        b=VEFTQt27vJ8kKR+Yx58dFtHD94ewZTiKKCISY/x/nDE6VM5MDqsMQjMEsXiY1QWEyi
         9ibjvcgUw7kMlx4aS299kof9AUmUcyvVSsGR6gg/lyYEoYoV2UHQh2KzQncaFDRZuzfb
         IHPLOz51qOHTdN9ow/ygNZyIm+mqA+hnEejEYESzLt0uIh2n+Ig5wW/aGwQkk/KkIlef
         kadD1MNNBi7ID93gOwfHHW1AbDDX+DPBJARgZ0nqfusQYitGdUisWZ1DsiozOCVW9arJ
         2p9dc3Siqg/FT5Nu6SCPl/trrgTb+nYkuz70fFRUBv/NrGjclx9IZl23DIReL/WgClz6
         p+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926540; x=1713531340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRv+s3gr19+ls832LKX6BTVWxWU26v5TpvDr6QThETk=;
        b=mbYRRxCu2g7IXCP6fQiVuu5tJWDBIIEIwbBoZRNGSbYkc9feSGV+YXnboBoL8EO2Nt
         TpHi8poN9m8ja0pQKiqe7ovCR6cyOJ0A6NFKdyFoZzgWP+AgDfOfZb7okymzV8FTmRE4
         8g5nd9+1afhBlUY8LAw/9v7RDSUWRR53Exg7gs51Iqz5X5CaZxSWmiijRe7shupfW3gp
         HfcyEZomvxdfX7i1GHixM47wvgZfWWMSDD+KmNBY4k9AK2izrBWWQ0S4d0OYpcwwQN+D
         iPw3/IKCGd0KcqAiInKvhYB8dtt9gBtoOs9OARjUuHmV7VyCk/tnSgkFCN7YcW43Y/aa
         HOMw==
X-Forwarded-Encrypted: i=1; AJvYcCXb2zfhu89MhzuaRWxqasrbcPt7UT3VBqyqPv9GYzAzgClOKgo9f0WMi8O6lLa4wBpfEOBJzlCGtVyWo7USbJWyV7TpH0Rt
X-Gm-Message-State: AOJu0Yw6wC3UNKmqV3B7w06Dt0Ne837texBJ4Bu/jvaiRLF2wc2g/kSs
	lD+iYkCpe9R4uEEDyfSkgGny7g2yclsJBnqs42otvF3qu2nJTqDo+kr32Q==
X-Google-Smtp-Source: AGHT+IGU1Cj2Qd4ICEikKVxaLwMb3o/vkuQOcLgb/6LyzlNUnruzZMmMfXmI+cimfdm3M3GRFXP42A==
X-Received: by 2002:a17:906:5a90:b0:a52:24d6:3024 with SMTP id l16-20020a1709065a9000b00a5224d63024mr1533334ejq.12.1712926540369;
        Fri, 12 Apr 2024 05:55:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:39 -0700 (PDT)
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
Subject: [RFC 6/6] io_uring/notif: implement notification stacking
Date: Fri, 12 Apr 2024 13:55:27 +0100
Message-ID: <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 71 +++++++++++++++++++++++++++++++++++++++++++-----
 io_uring/notif.h |  4 +++
 2 files changed, 68 insertions(+), 7 deletions(-)

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
index 394e1d33daa6..6d2e8b674b43 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -14,6 +14,10 @@ struct io_notif_data {
 	struct file		*file;
 	struct ubuf_info	uarg;
 	unsigned long		account_pages;
+
+	struct io_notif_data	*next;
+	struct io_notif_data	*head;
+
 	bool			zc_report;
 	bool			zc_used;
 	bool			zc_copied;
-- 
2.44.0


