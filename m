Return-Path: <io-uring+bounces-11736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 57CC3D262C1
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4E15C3012E90
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048553BF301;
	Thu, 15 Jan 2026 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpSyJ0Nx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD943B8BC0
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497147; cv=none; b=VhPRGQKY0UAZha7Li8CEP1frMMCec5qvx+Tj3qp+8R/d9zs28V0dsdlf1CWrGhd5XZ8QfsRaJdyYj7ShTC0vM/5gqNYnXNwfKRbad4s7ti0le865iDO5i2aRepUL+GnRSTTxIsYe+nR1KhMRk9nBF72ZyrTfckZWzzy4oSm7hak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497147; c=relaxed/simple;
	bh=LSh5hLuiJCxDRwJ+BQ+Xc7tCZE16QA/b770rYhc+vp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIzhuhtSdRopWETcNydF4DT0Ks1eCAu2i7KVmPVqjoSmtC189Oa4wXjC5fa92C6yYQytVpN8ryiPP/7xOY8/VnkJIWA3JS5N8CLz1d73h5fhzbWwJdZP2ClJzjTXwGeIaLJ27r57CZUvXPn+4RgXzmKLCeLj58NeLT6A2lVPXMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BpSyJ0Nx; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so9446065e9.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497144; x=1769101944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=BpSyJ0NxtpRPZ6abZNisiXXoEYNXasXggd9O3OKVrGnHSKsViorbq/MWM0H+4+vazG
         wTWa6BJKsVkIsYVo4yw5n1V36rolO6khYXu1on9DSEl6H8AJa8Y7Z4y+Hr7EnSyAbAJL
         DtY/5SZojfLmswHJCdLMrYeVy16h5gtGQFlxzRL2Zfsd2Gh15s7MO/hW57pZ5JtvIdbB
         QsYiSaDzlLIQW0Vbt6yqGYOi1Tutq0LhPaSWhlPyAOp9WghftsjiYCqKgjEsBWG0k6oB
         BbZEJGFMCKC46d5tVENMJ26vXugK9oIXgKOBZgW8fSv6KqwRyAHOkGrBH/EbNo6QQyaj
         5NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497144; x=1769101944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=tFSviSpSpLCxW9WDANPFxdUYzxnRoTszJ5t10WpL1Ll46DiHGU34T3YT1vZRU1N531
         FfeO2jejv0u604x5pnfW0mgXZGtERMKfT/tWTXIxyB3dnd5itiUKugxDNnZjSKqZwIBE
         36dzbH7wiVENh0SNIKZs9m/LjmBoVEPmAhwtSSNzIGqSMqw+8oxWHHjLfEEgK/PbTguF
         mVzWAoIaRQ2JucoIKmC6L2MFM9zzofukxQU4k3hh/GHiMiSQOzMNG1gXvbuCKyMXP8Nq
         F4OHMwsq263/tIOcjdhkb+aWp8sgK5JIiH1pAJo74kFRHPcJolw128MFxgtrn1IjwpgR
         dVMA==
X-Forwarded-Encrypted: i=1; AJvYcCXFEAZq28JrsO+sbIC4FmExUOEeEXmilt9uyPURNDcBb351NA7JML2AD0npQbPBb/K5RyL+6w54eQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf1xU/dgIvTYkvgmW3JuUkW9PSyfnxTXy15+b5qCBVyxMIGXGw
	sQfIIBZMpZ/p8H8pVOhEj4ZfFWIsHnMqOGPODGHeCr59w38k294hX2W3
X-Gm-Gg: AY/fxX4lEUedS4BPvZKN3MCyXHT3VHI0k4hmxy5R0fbDOeD2z8KTA9nH7pd0UHRjNd9
	6/VyQHElCPqfP8PQKdX6lq+9IYHEeC8JQYNkMKao4QUP+uX1bBOi/u7Geoj0Zb4gJoTvou/IQiF
	KKzAXjNkZRvVI+ZYc1/vftnm34aCX82OQKhCR61jROx0FISoomgkfC8W8OtAUz/eWPMPXebjJHU
	2avaCc20nY0hxuA0kCS/xtGzaw9HXqVAayQxLBuJBzfKB61PiyZVksIfvH1Z5BltHrs4JlyaZRD
	Duh66at6G/tYnxUgKjKEsVjlRxWMzOpQy9DrLt553vks0QgvNeI/K5NXiLgXUU0BzEyrXzSoiPx
	F4AwBCd9UzgfVZDGY35hsAAEe02fP4hswNiATdmFPIMkNunNGYdSHQbv91Q6oKO+wZcrHwhysfA
	kx+bbwVmlnTmDtJ+9O0EIBoHZmXN7+Ca8Na+aTGW9m6Fjd16w5Cb5EaApq7o9bFdZhPGEu8z7lv
	Z1f37VpA+zEpx63kQ==
X-Received: by 2002:a05:600d:640f:20b0:47d:6c36:a125 with SMTP id 5b1f17b1804b1-4801e7d2a3cmr1460515e9.17.1768497144306;
        Thu, 15 Jan 2026 09:12:24 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm54741645e9.11.2026.01.15.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:12:23 -0800 (PST)
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
Subject: [PATCH net-next v9 1/9] net: memzero mp params when closing a queue
Date: Thu, 15 Jan 2026 17:11:54 +0000
Message-ID: <7073bb4b696f5593c1f2e0b9451f0120ca624182.1768493907.git.asml.silence@gmail.com>
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

Instead of resetting memory provider parameters one by one in
__net_mp_{open,close}_rxq, memzero the entire structure. It'll be used
to extend the structure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/netdev_rx_queue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index c7d9341b7630..a0083f176a9c 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -139,10 +139,9 @@ int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 
 	rxq->mp_params = *p;
 	ret = netdev_rx_queue_restart(dev, rxq_idx);
-	if (ret) {
-		rxq->mp_params.mp_ops = NULL;
-		rxq->mp_params.mp_priv = NULL;
-	}
+	if (ret)
+		memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
+
 	return ret;
 }
 
@@ -179,8 +178,7 @@ void __net_mp_close_rxq(struct net_device *dev, unsigned int ifq_idx,
 			 rxq->mp_params.mp_priv != old_p->mp_priv))
 		return;
 
-	rxq->mp_params.mp_ops = NULL;
-	rxq->mp_params.mp_priv = NULL;
+	memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
 	err = netdev_rx_queue_restart(dev, ifq_idx);
 	WARN_ON(err && err != -ENETDOWN);
 }
-- 
2.52.0


