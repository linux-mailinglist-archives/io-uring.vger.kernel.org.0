Return-Path: <io-uring+bounces-53-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D26407E4ADE
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B506CB20F0F
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDEC2A8DD;
	Tue,  7 Nov 2023 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="k9vEzKgG"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30252450EA
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:40:59 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72210E6
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:40:58 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5bbd3eb2f8fso97147a12.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393258; x=1699998058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=520r0fT9CXFqnN6K8LnXvZLFpQESKDxVi7WN1Xfbe2s=;
        b=k9vEzKgGlRKmhi2MuyolRjg5HtyNkSuNUVCRr0Jvexarp+wKHrVnPNqne56FWpyAEI
         igW6nHudepHRNs7Wp9vDHYF/DhEzpmTPgCn3qhlIA01xd/99xMqgdmC6RvS8jJOQWsKY
         8qp178i/m62iTjNOvwFoIxwrLJRKYorN1bIHt3TIWpE7R8Y9OOdodowTlgjsZ6P3bHlO
         mePztIytxhFUt3upa+u/4Fj/BlGe2qkrk2gjU5eDlQeQZXBUj/UKAff9xNx2dgltRq3k
         WoGe2oJsh+VjP6vClHszNRjWlo6kmld/vCD62JScEjV69ofpno51OZM8ikgAoIrS/H62
         hOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393258; x=1699998058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=520r0fT9CXFqnN6K8LnXvZLFpQESKDxVi7WN1Xfbe2s=;
        b=TN+Rkfa060fG4D0NEC2aCvSpQdaxObUf1nHx/vVf3FuswmFFB4nIsnf7Zd8hvsZajI
         vn0PAA8ozjMc5UsFFnP+ktIhEGSV0My3eMxVB+moSeO0ifesoYyrTv60WsAXxvC+iLXT
         Q1rfhezuW8kaQyA/VoqRccgqzjb9pFvwVbftQSNQMITcvLnMC1cxhkUwzzBfGElNMFeX
         yXNh0i/9oQ9cnRubeSK9GucaQYbs4HIDQWHbj/wPiyvkX0FEhiS7Ldimwdtbl69WDpnf
         dW7zNuxqfuA10nHLd/0yZUsHjDa3BBYJ/LLkifP/Bpj1mrsm8sg99+nnyw/N3MOz9J4M
         2udw==
X-Gm-Message-State: AOJu0YyVx5oWnjsuugsAWKumoPyTPWxrJwWl8Fno/tPz3QCFLV+w3Ccx
	4jqtp0o32bjBC1hiOYXh3y35wWHL47FkK0WGsxCPyA==
X-Google-Smtp-Source: AGHT+IFF+B6gbHUBADrXjroISxhXSQTrTB1jUxSanL6FHfskkynBovVZjD0Q3/Xkekd9MJkNt6gUMA==
X-Received: by 2002:a17:90a:fb42:b0:280:6cde:ecc2 with SMTP id iq2-20020a17090afb4200b002806cdeecc2mr5299320pjb.11.1699393258176;
        Tue, 07 Nov 2023 13:40:58 -0800 (PST)
Received: from localhost (fwdproxy-prn-010.fbsv.net. [2a03:2880:ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id ft20-20020a17090b0f9400b002800d17a21csm268331pjb.15.2023.11.07.13.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:40:57 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 02/20] io_uring: add mmap support for shared ifq ringbuffers
Date: Tue,  7 Nov 2023 13:40:27 -0800
Message-Id: <20231107214045.2172393-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds mmap support for ifq rbuf rings. There are two rings and
a struct io_rbuf_ring that contains the head and tail ptrs into each
ring.

Just like the io_uring SQ/CQ rings, userspace issues a single mmap call
using the io_uring fd w/ magic offset IORING_OFF_RBUF_RING. An opaque
ptr is returned to userspace, which is then expected to use the offsets
returned in the registration struct to get access to the head/tail and
rings.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/io_uring.c           |  5 +++++
 io_uring/zc_rx.c              | 17 +++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 84c82a789543..ae5608bcd785 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -416,6 +416,8 @@ enum {
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_RBUF_RING		0x20000000ULL
+#define IORING_OFF_RBUF_SHIFT		16
 
 /*
  * Filled with the offset for mmap(2)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae7f37aabe78..f06e9ed397da 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3438,6 +3438,11 @@ static void *io_uring_validate_mmap_request(struct file *file,
 			return ERR_PTR(-EINVAL);
 		break;
 		}
+	case IORING_OFF_RBUF_RING:
+		if (!ctx->ifq)
+			return ERR_PTR(-EINVAL);
+		ptr = ctx->ifq->ring;
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 45dab29fe0ae..a3a54845c712 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -35,6 +35,7 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 {
 	struct io_uring_zc_rx_ifq_reg reg;
 	struct io_zc_rx_ifq *ifq;
+	size_t ring_sz, rqes_sz, cqes_sz;
 	int ret;
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
@@ -59,6 +60,22 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
+	ring_sz = sizeof(struct io_rbuf_ring);
+	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
+	cqes_sz = sizeof(struct io_uring_rbuf_cqe) * ifq->cq_entries;
+	reg.mmap_sz = ring_sz + rqes_sz + cqes_sz;
+	reg.rq_off.rqes = ring_sz;
+	reg.cq_off.cqes = ring_sz + rqes_sz;
+	reg.rq_off.head = offsetof(struct io_rbuf_ring, rq.head);
+	reg.rq_off.tail = offsetof(struct io_rbuf_ring, rq.tail);
+	reg.cq_off.head = offsetof(struct io_rbuf_ring, cq.head);
+	reg.cq_off.tail = offsetof(struct io_rbuf_ring, cq.tail);
+
+	if (copy_to_user(arg, &reg, sizeof(reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
 	return 0;
 err:
 	io_zc_rx_ifq_free(ifq);
-- 
2.39.3


