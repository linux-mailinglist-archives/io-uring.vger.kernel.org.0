Return-Path: <io-uring+bounces-11743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FD0D26535
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA9693150641
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4613D1CD7;
	Thu, 15 Jan 2026 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8GoXRFc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B63C1FE3
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497164; cv=none; b=WhfXxxF4Oi3yqvE+M4Z2iN1gAXGqEfgCOtj25CL3RrxQvO17Ha6Hp/Ur3yDLYFUcE5iF4zEmcvpVqEAY8i27pS6pGP4oPvRK7ZPQ2a6CzJ6NXzh4K6NMUn/z9SqFfzkX0+bsYB0RqCIvPdb/7Ci31q6XezgAo74zX3MErSCGweE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497164; c=relaxed/simple;
	bh=axdc3q5KY7YeHULab/TvgzOYs0oof9ugiogriyYfhIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtEXgEVPfQEnuRYhznKjtUhh1Wq0EpjopPGsD/kB+hmLcwyeBiB/28ocFIRWe6HmgEhJHI+37RBFFqDsb8PxwRdoJ/2COoR2gbK0QlGjrBo2RcWHtC2wiO1deTESn4SeceznJQDTGVSse/ymUUpsKjchqmYRkODOsuwkPo7Uhx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8GoXRFc; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47edffe5540so12301625e9.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497160; x=1769101960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiBEtLY6CE0u/w5HMF7IyfpDPmY7qzN3np9POU+8r/k=;
        b=A8GoXRFc0IJMW1qfOfJrOBj1JHhZwXvCopVi2+PE2DOaFTMuDMnBiAw+2k0Qtxm+hs
         LgdgjOe7NnSX7UaF8b7r4PfW15tcwfenWHlJ7akUcMP7Evmb2nyvPmhrYTLKAaP/DS9d
         o2UqH7xu88UmohiLg90AcDD97OgiExglCL4W44+PajXj7dUvM39oUJn+f+nN9pJyVIiw
         jq2aONOfPO73F4MWAC9MrzLv+DmU0STcN5G9FGhOc8U8A7SQuiNaSbnHgRnrkcIU4cm6
         O88JXvbq1HxOS5z7yJqidF2evKknMKxlYrkoQbvbL+v/aV3JMwrMxGuXWX/hviJc+hMn
         ELig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497160; x=1769101960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kiBEtLY6CE0u/w5HMF7IyfpDPmY7qzN3np9POU+8r/k=;
        b=QNZ8ChenJJ5vga8JZNTVvykSjS2wIITi1MwDlEC9FkcuWZtqWa0x+U9hPQrb2yCVBX
         mS4YTbMYw47trqxwqxOnMvkP1o5yXhSV/L0MEbxoEQqyZxsMwrdaI7jhBpijnOSwAFw4
         8pMptarFIDsMcpH/0oJUy15q7l6KnjQyWcTmJWSPrFRUisszVPQDfrNd4SEO+GILa3qb
         4BCG9viaaYYk37rC86ICLaUld9pumXooEq3xjDncn6pqGtquQTY5WiCzjXRXFz877Te+
         SpysgzslhZFn1kOqUlahkkiKdFcS2QNWhn2Io9gQ3Q2ZE+ltzwWhCagJVxFkMKEQECXW
         DRdw==
X-Forwarded-Encrypted: i=1; AJvYcCWWX0aAq/pL72Ux5/b7Qg3sjA+RKjMcDQA4s6davWZhDHWojXkV4vwaAn/+x7L9gRDHXaxVP8CwCA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9wE+yLwM/TrhsherPkb9xyJxE8kbEUm8yy2LtYzo4inM8dQan
	14Jmz6q7IflXucf8dCeshpQ8446LE7lsjdAZiX4/iNFaOAblCHJG4IJw
X-Gm-Gg: AY/fxX7UHJ3leXl+WjOlqxOz6MKmnhxNtVDbWXkSeGMbkqW5jYJPgq+j8iJ66IkSRp1
	GE9vCSlv6CeMX5h/ziBwG0N7Ys2PTewNmquqLl8/bwTRJ6Gol1tc6h3CM3vaGLA6ocBK6hFBlNI
	BNkrJ5pbTWVY5mz1Qu3KdC1YkAwORalIIcPvh6pRv0YrBJ5t60gzbdbHkzqxAggGKgkLoF4GypF
	GUzTQyZK8PCi6T5heVEq3CB8XoTBN3ahmcepLXgogdnLUhg0tuOTCEF35qIGcSm+4QTxXdY0sJc
	84hIrR4Z5FIl+FmUDudqeVZ8vLhKImN7N2BqUnvw+hcqSxs3XgMxjEiLULqLgLiDfXg4v6k0ujx
	tPUJngO8bIctIVmpM6fzph6TxdK8TeEKLV2AFtDiHn0UtN2H0fEoQ7pdU4BOrmChhqA63OBDthP
	a18JWSQU9oq12JEzNwI8IWoR6T7eh6G9ApLeDBqJJNtgW0uOr2W6bQHX50wQi1sMKSeDmqQHYvg
	0NeuExDMci5ownerBeN21kyYfc3
X-Received: by 2002:a05:600c:3ba8:b0:477:9eb8:97d2 with SMTP id 5b1f17b1804b1-4801e2fddcbmr5854765e9.8.1768497160083;
        Thu, 15 Jan 2026 09:12:40 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm54741645e9.11.2026.01.15.09.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:12:39 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	kernel-team@meta.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v9 9/9] io_uring/zcrx: document area chunking parameter
Date: Thu, 15 Jan 2026 17:12:02 +0000
Message-ID: <d1de61db1536727c1cad049c09decff22e8b6dd7.1768493907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768493907.git.asml.silence@gmail.com>
References: <cover.1768493907.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct io_uring_zcrx_ifq_reg::rx_buf_len is used as a hint specifying
the kernel what buffer size it should use. Document the API and
limitations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/networking/iou-zcrx.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
index 54a72e172bdc..7f3f4b2e6cf2 100644
--- a/Documentation/networking/iou-zcrx.rst
+++ b/Documentation/networking/iou-zcrx.rst
@@ -196,6 +196,26 @@ Return buffers back to the kernel to be used again::
   rqe->len = cqe->res;
   IO_URING_WRITE_ONCE(*refill_ring.ktail, ++refill_ring.rq_tail);
 
+Area chunking
+-------------
+
+zcrx splits the memory area into fixed-length physically contiguous chunks.
+This limits the maximum buffer size returned in a single io_uring CQE. Users
+can provide a hint to the kernel to use larger chunks by setting the
+``rx_buf_len`` field of ``struct io_uring_zcrx_ifq_reg`` to the desired length
+during registration. If this field is set to zero, the kernel defaults to
+the system page size.
+
+To use larger sizes, the memory area must be backed by physically contiguous
+ranges whose sizes are multiples of ``rx_buf_len``. It also requires kernel
+and hardware support. If registration fails, users are generally expected to
+fall back to defaults by setting ``rx_buf_len`` to zero.
+
+Larger chunks don't give any additional guarantees about buffer sizes returned
+in CQEs, and they can vary depending on many factors like traffic pattern,
+hardware offload, etc. It doesn't require any application changes beyond zcrx
+registration.
+
 Testing
 =======
 
-- 
2.52.0


