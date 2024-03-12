Return-Path: <io-uring+bounces-908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 803FB879DC1
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F2501F226D7
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C95A1448DB;
	Tue, 12 Mar 2024 21:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="idQWWBiN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA571448E6
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279882; cv=none; b=Fh7jovKoEL8kJi4EjHib5QHp8VMoLRszR6ThzD+TYTVE0j2PlCK0XQSfFkAlhOg5zWVaZ4tcngI18puvNO6KX/Y6KXFa4pjp+MWb9TO6GLyPejVJ6nQtiE31/vWsHT6BpCIdPA76OhZAfrNKSnouDdD8U3cuujSoTTrZQkvbtTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279882; c=relaxed/simple;
	bh=Au5TaJwti+/pCSZs4du2poKs+p8m7iLV6MJss0mMKm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTqoGycBoIPoHt/A5mui/Zx48uEy8e+ym2B3xUpCi57pZ/dJJTaJRHw5DNCK/vGw2UnhdKCy8N5+EgJhMq1b5+k2IZHWFFLHSf0UeXSiGNI0DiFbwZsO4ErbF9tSc6QDyt+cMUbGtLvXIt3ZGzyfu7youNPoVOt15iyEIdBZ1LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=idQWWBiN; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5c66b093b86so224397a12.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279880; x=1710884680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDipnnybmoHT+VNKp8P+1c7yNG5XeUpEUaaGmNJ3fNs=;
        b=idQWWBiNJBfxT+sV6Gyi1lhuJMVgLK22FwC7eMbOqW7uQMwEv8IgBcr1qNec7WHLrD
         IuPLnJgCHiVoGZJQqHM1cL4FZg6evIWVhz3yUfu2mXOjdr2SbaJVGASB7/079j5whzAz
         m/z4HUBoR8v7f++3hDCFcYFVSaZxUYv+P3gByeNCbRRkAxMOBtmuW1Z+guRS0dkrjzf9
         EQ73EN0Q0EQ/H7bxs+TCi+zjWWMEvINQcOVJ4i7v7V5595HMwEBvX+fZTZk+D9C84CCe
         nBBabPwKnnrY62S4KKvx+KUd4NgQ+g0BQ0kAUvZ8ZrRz+LQrrFStRBFmOiDTZIPtnSIp
         5RkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279880; x=1710884680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDipnnybmoHT+VNKp8P+1c7yNG5XeUpEUaaGmNJ3fNs=;
        b=c2IR5KmjYziDygbH24MSs2brZJF/PUnetfCQEjsvBFdk2/7HS6YB2x15aoqUMxIQnL
         DcY5WTb5KlgQGrBxmruJbaiSukqMkM+Yq5/PHGrFDY2det+3LYGOzjx7J6qu//qlIi1Q
         2mA8S/VWsaAMdckATtAezZHwF6xoKGLM2Wy3yAaebLCr7pkpZvuoxvHOWDQspBPjPaZC
         JAUp82X3Jse5keNuPi/K+OcTDo0sM9X5g3wrr5th0liVPVls9M6uEjZAtKNY9lEfCwxY
         SSWJbiatzUmUiQ2E96b7Z19qvkYEpYqQ//PlSSohzO/bb28R1DXdcfpmogcnIv/XXJzm
         RJ5g==
X-Gm-Message-State: AOJu0YxHIUe9DQsuOXAyHuG/IHz9PBCxc2BZOEAjUfmjoTdvZ18DJt8u
	60U4hhOOhNeCrxf6Ns4S0NTIVEYyYXD1FlR6kwZanh8f1JbwtFf1PKxJAVvDho/Lbew92Ix8IS1
	A
X-Google-Smtp-Source: AGHT+IGXFFMsyn12TGJpkd/F1krEy783KFAWHV6gkAUHyjREN82kjk/2T8EtM1scBgtGbhvLUHDvOg==
X-Received: by 2002:a17:90a:bb85:b0:29b:f0e8:6454 with SMTP id v5-20020a17090abb8500b0029bf0e86454mr1012593pjr.21.1710279879717;
        Tue, 12 Mar 2024 14:44:39 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id fr12-20020a17090ae2cc00b0029c472ec962sm50922pjb.47.2024.03.12.14.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:39 -0700 (PDT)
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
Subject: [RFC PATCH v4 06/16] io_uring: add mmap support for shared ifq ringbuffers
Date: Tue, 12 Mar 2024 14:44:20 -0700
Message-ID: <20240312214430.2923019-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

This patch adds mmap support for ifq refill ring. Just like the io_uring
SQ/CQ rings, userspace issues a single mmap call using the io_uring fd
w/ magic offset IORING_OFF_RQ_RING. An opaque ptr is returned to
userspace, which is then expected to use the offsets returned in the
registration struct to get access to the head/tail and rings.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/io_uring.c           |  5 +++++
 io_uring/zc_rx.c              | 15 ++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7b643fe420c5..a085ed60478f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -438,6 +438,8 @@ enum {
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_RQ_RING		0x20000000ULL
+#define IORING_OFF_RQ_SHIFT		16
 
 /*
  * Filled with the offset for mmap(2)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5614c47cecd9..280f2a2fd1fe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3434,6 +3434,11 @@ static void *io_uring_validate_mmap_request(struct file *file,
 			return ERR_PTR(-EINVAL);
 		break;
 		}
+	case IORING_OFF_RQ_RING:
+		if (!ctx->ifq)
+			return ERR_PTR(-EINVAL);
+		ptr = ctx->ifq->rq_ring;
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index e6c33f94c086..6987bb991418 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -58,6 +58,7 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 {
 	struct io_uring_zc_rx_ifq_reg reg;
 	struct io_zc_rx_ifq *ifq;
+	size_t ring_sz, rqes_sz;
 	int ret;
 
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
@@ -80,8 +81,20 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq_id = reg.if_rxq_id;
-	ctx->ifq = ifq;
 
+	ring_sz = sizeof(struct io_uring);
+	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
+	reg.mmap_sz = ring_sz + rqes_sz;
+	reg.rq_off.rqes = ring_sz;
+	reg.rq_off.head = offsetof(struct io_uring, head);
+	reg.rq_off.tail = offsetof(struct io_uring, tail);
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
2.43.0


