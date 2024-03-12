Return-Path: <io-uring+bounces-909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4559879DC4
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4F691C20309
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7E6145335;
	Tue, 12 Mar 2024 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fqUNScge"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118181448F9
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279883; cv=none; b=KVKRSAoqs1gGBuczb47CWxXCXOa8adJqbhRUgvZvIstZG4QJUVxUlRQoRpX8xCwX8gjpwgb9fH6HCZzXD8OXjeJe1rCvDq1ewh5NhAFrAVYrLz0qaHptcIXsDbC1ASx7HxybH+2BnlZB8rtEHmjezedjgcQJbB9uuh3Xo+PJNOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279883; c=relaxed/simple;
	bh=tt7Qj0Ee9P7w5WJse4ZzKwHZdEsDt8EZR8C9Xbepvys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5m482+3Nq7RACpsJzOQybg4TmYve5pMw6saXRl685q7t3XfUr++OEIDN44K2Zv9AoyXL/JwVRgXVvQRWACClnN7JuZtv8QCzoocj7BW9987rvZZJDu6jpS1J5LNqYY1JqZJ0b5PVkm0qNb7/LNKIFYLL1SSYTBD/vrIOS/Pyhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fqUNScge; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a1bd83d55dso2497760eaf.2
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279881; x=1710884681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSdOpXaG5eyYtOQK8HIj1OSb+RRKm9zsEqtIIKixBPg=;
        b=fqUNScgesnLybc05nt4hihQfbQEVPk/gVfDFIKICiCoxBkx0uYn08ySxfzYQM7lBLt
         QevpTx6gdQqgfjuP90QP+X4ol82khu6c8ACAjl6vgmUfzanfd1KNnblMupSFTSW7CtsU
         IasXaTpB5kesL3dbINRVjnH7MJjdLA1yQQBh/U/lg6TW7aKylC9oz0BK94PQcX5Ituat
         usDMzKjzuZnSKggGQEtcdOQvfow7QbXDKdWR1YOjDMpmCjyM4ZjlNV7ZXJVzoZAyBWyz
         TeCdBmLp50TjIMciCOk6nYsq5ii9E4Z5DI6MKQuiII+6HdEQrnMBr5PUcW5XybXComRp
         rXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279881; x=1710884681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSdOpXaG5eyYtOQK8HIj1OSb+RRKm9zsEqtIIKixBPg=;
        b=AbIhZyBk372btqPjr9rv1D86lWK9K0e+EpPcMOJeXQnATRbcZWwj/GkXWh7g4Prw55
         M4apEMR/nPVOiIqyj5wdyDAQ99HbVf9e+sljVwA7aLUQHbq4MX/z5uKBJEn0lAu9WjC9
         QEvcliX7XXvDTPfWauKEQw/jlMbgZr+RRZzAoLiYcnXbG60qht2FpvTcNG8PoORAlpAY
         XI5s3gOW7o+fx6pJnaGZFVIwt/fpnM3vF51d7MeUF5wBJMrca54izGqozXbSnJecgJYt
         RcB08sIMCmAJCbqGUhkd2NJprWuEW+Ny8Fi7zToHasBajGyzdvl8l/NiMBdEpN3rcslt
         HU5A==
X-Gm-Message-State: AOJu0Yz7vxYLNUgvb3Pfkkz20rZSbd6ekGdoZm2FCdnx8eeJiywLLOuc
	kBnjvzGE8tY0Cw9b7EIMJIZwwR/APreZyCOe1ialeauHUSuVMD4IVRDfwjqTtjTxYsHYH9bNpEX
	F
X-Google-Smtp-Source: AGHT+IEyE7hAxIEltzuiBpQ/u1B4tId9l6LVAuyoHvYl8QxHH1psuFJRa4N+p/CejwhJ97/E83Htrg==
X-Received: by 2002:a05:6358:890:b0:17e:8b57:df56 with SMTP id m16-20020a056358089000b0017e8b57df56mr3208554rwj.5.1710279880701;
        Tue, 12 Mar 2024 14:44:40 -0700 (PDT)
Received: from localhost (fwdproxy-prn-025.fbsv.net. [2a03:2880:ff:19::face:b00c])
        by smtp.gmail.com with ESMTPSA id i33-20020a635421000000b005d880b41598sm6475388pgb.94.2024.03.12.14.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:40 -0700 (PDT)
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
Subject: [RFC PATCH v4 07/16] netdev: add XDP_SETUP_ZC_RX command
Date: Tue, 12 Mar 2024 14:44:21 -0700
Message-ID: <20240312214430.2923019-8-dw@davidwei.uk>
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

RFC only, not for upstream.
This will be replaced with a separate ndo callback or some other
mechanism in next patchset revisions.

This patch adds a new XDP_SETUP_ZC_RX command that will be used in a
later patch to enable or disable ZC RX for a specific RX queue.

We are open to suggestions on a better way of doing this. Google's TCP
devmem proposal sets up struct netdev_rx_queue which persists across
device reset, then expects userspace to use an out-of-band method (e.g.
ethtool) to reset the device, thus re-filling a hardware Rx queue.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac7102118d68..699cce69a5a6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1009,6 +1009,7 @@ enum bpf_netdev_command {
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
 	XDP_SETUP_XSK_POOL,
+	XDP_SETUP_ZC_RX,
 };
 
 struct bpf_prog_offload_ops;
@@ -1047,6 +1048,11 @@ struct netdev_bpf {
 			struct xsk_buff_pool *pool;
 			u16 queue_id;
 		} xsk;
+		/* XDP_SETUP_ZC_RX */
+		struct {
+			struct io_zc_rx_ifq *ifq;
+			u16 queue_id;
+		} zc_rx;
 	};
 };
 
-- 
2.43.0


