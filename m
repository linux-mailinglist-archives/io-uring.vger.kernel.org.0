Return-Path: <io-uring+bounces-307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E418191F3
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 815E11F22F0B
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7283B198;
	Tue, 19 Dec 2023 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="z61dSdpK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE4E3B18E
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6d93278bfbeso849196b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019852; x=1703624652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3Y4JU6HMwB1uVJ+JNXJdWd+XQLYN1jCeFKBg4yFw1k=;
        b=z61dSdpK2dWdcPpUIawfQsityXb4ZJwOdbh1tIQkyl8JFy0GbLtyTn6RaAtEscYQoR
         75SVcTjSgH4aZIZYWp/AiIL86Rm6WWJlmMKhMhgwqvYbDuV1vtndOGUzBaIToXfkda4k
         qhFMNtIlK1mqySfyzzTsR+RErc2SkUo2QkMAv2jMRdsXvEidFthsQl6OjtXOVcUkSDZT
         rIO1Q5M5Y/1tiSUR8C3rxIHzoZgoKfqZqa8FkA4Ua6xgIHh/98Ok2S3cpbSvvLcKvaqn
         Q/j8Eyzk6IGXQgm9TGQjglqCGpTDxLHmXmLU91WOOuRNzfcZICz8I1I70oVj7rkJPhe3
         XVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019852; x=1703624652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3Y4JU6HMwB1uVJ+JNXJdWd+XQLYN1jCeFKBg4yFw1k=;
        b=aeSe4byBW7MxPpE/VQFy5mGk1L96tCxJ+MM5CdO94ss/0FeWw9V2N5LyJhVCxAsKX+
         QSJBWNcOX/fHnEU+9Y7byu91oy+DODPmwz96eILO/93pmviT1Gh+cxq5wkcCWG8/4go4
         G1599oqwtxrjShmVTRNoUxi0HxbD4bWFcVJxVF+q5w55bqrdFpx5wzb6EvZMXGlXeXAF
         toOjZzR+2CPz+EpnFcM1zPQC1pNTFKefX+8bMhD7Yrb967ZKWicEsn8H2cHPOV5uTuLE
         +dz0JOAMfCBvQVQqKF4VEplIdjNe504HghJqNMgv0CAfjhlUfYPvPzxzHxR9J9yE65CD
         VN2w==
X-Gm-Message-State: AOJu0Yw1lGdMMwzIGB33KCV6MXmVBsIiat/Y2SdQ6F2JB2xY/8sRc3fp
	ykLVahG46JK+vwKNNjOYPzPAo4v5jYjeC9puflflmA==
X-Google-Smtp-Source: AGHT+IG4uhmPRuRYA1PBi6o4YeFNdksavwq6wMK9ezYS86VITabON3ke2qgZ1ovSnIArd+jBALIfSg==
X-Received: by 2002:a05:6a00:4783:b0:6ce:2731:5f7c with SMTP id dh3-20020a056a00478300b006ce27315f7cmr7863805pfb.59.1703019852569;
        Tue, 19 Dec 2023 13:04:12 -0800 (PST)
Received: from localhost (fwdproxy-prn-010.fbsv.net. [2a03:2880:ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id x11-20020a056a00188b00b006d7d454e58asm4085899pfh.117.2023.12.19.13.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:12 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 08/20] io_uring: add mmap support for shared ifq ringbuffers
Date: Tue, 19 Dec 2023 13:03:45 -0800
Message-Id: <20231219210357.4029713-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

This patch adds mmap support for ifq rbuf rings. There are two rings and
a struct io_rbuf_ring that contains the head and tail ptrs into each
ring.

Just like the io_uring SQ/CQ rings, userspace issues a single mmap call
using the io_uring fd w/ magic offset IORING_OFF_RBUF_RING. An opaque
ptr is returned to userspace, which is then expected to use the offsets
returned in the registration struct to get access to the head/tail and
rings.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/io_uring.c           |  5 +++++
 io_uring/zc_rx.c              | 19 ++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 024a6f79323b..839933e562e6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -428,6 +428,8 @@ enum {
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_RBUF_RING		0x20000000ULL
+#define IORING_OFF_RBUF_SHIFT		16
 
 /*
  * Filled with the offset for mmap(2)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7fff01d57e9e..02d6d638bd65 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3516,6 +3516,11 @@ static void *io_uring_validate_mmap_request(struct file *file,
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
index 5fc94cad5e3a..7e3e6f6d446b 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -61,6 +61,7 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 {
 	struct io_uring_zc_rx_ifq_reg reg;
 	struct io_zc_rx_ifq *ifq;
+	size_t ring_sz, rqes_sz, cqes_sz;
 	int ret;
 
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
@@ -87,8 +88,24 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
 	ifq->if_rxq_id = reg.if_rxq_id;
-	ctx->ifq = ifq;
 
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
+	ctx->ifq = ifq;
 	return 0;
 err:
 	io_zc_rx_ifq_free(ifq);
-- 
2.39.3


