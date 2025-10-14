Return-Path: <io-uring+bounces-9996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DC8BD97FF
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 145554F2F92
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 13:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B433A3148C2;
	Tue, 14 Oct 2025 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwMl9ymu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A62313E05
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446835; cv=none; b=VtPzqewkRLGS56DcanqOYKC5Svf/SpNgA3ruh14/GysxI7T4r+lcld+1Wo6XhzhXpYNuLyhv3E7fjA81Q4cAU3JYu80xKiHyKzU5iOBX1Dzuo6ij4f6LBoJs0ldj612ksq6cO4iMcFcBp4YGP+6MSQfDtt+aP56DsWYDZGruaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446835; c=relaxed/simple;
	bh=8sl8zh/edgEOL187hvVRKslTd9Ju8bi2edrvqaXpJ6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBs+HcC9PRw4IA/dUoOz5rIuI5R1SloaS/Ij5ojr4jTX2E3iJnVbuclwwuPsVVW/Tr11gmhnx8AR4xLzPGIeMFqp/vt2ORdIsowLFdeq7OiHfAnBDrde8EeDsTOdEETmpcNDFIIz9kTF5dz0T0WsHAIMg0uOfV8ih4YEjnVd04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwMl9ymu; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so467451f8f.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 06:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446832; x=1761051632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eHv7iWS5Rns6GMFeZ+EPNWQuD+MpI0tmNw4Ue2Rubw=;
        b=DwMl9ymuaASIc2CqbtCQf1Q0NTrmkTfrESnUsQYjUkvV0ApahXP6xW0E3QPOnporiB
         0PzYsKi+aSTzgtqgkViD//LVF5kcoRy79xtjDQtem0iW31PWu8X4j3EX4bZGQS/X0t6v
         ShL0duq0RxfW7nnAt1InePAj9lJ624pP5V6KOL0KCVaL2rD9Sltea1c7IYiGOB4uHi4V
         iqDVPpFCYFaZcqFlIVlFwngwdvZ5FDZJQb75DT9tTTuRxqQOlkL+V91CqKE0wUPFeAPy
         eQ72Miuckzpc/GWI957KVCx6ESACBSlevvFz1LagIDXRt1/dAbbRufmAkBFIGE9dayfn
         YSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446832; x=1761051632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eHv7iWS5Rns6GMFeZ+EPNWQuD+MpI0tmNw4Ue2Rubw=;
        b=mVdDD4ya973r+opsak7ZSb+ufJ520LhUbF+vLDTiWXeYqUSQKwy2fCSBnaamu8+iqS
         r2YYBFuL6V5zUKtH6WTyPJJN34mvApalbyYwfY8bjiVs/THIFIo13XyqyZeqUiqDNDmf
         FmxdNep15me4A0sdi1mQvZeQWZDbrG5AyGTq8EzmQae4up6qSuRLlSR7HGfRZyBmW714
         7dnAUlosDwMqN/KL92ToB+PzPg0n4fUu+MIvlpcYPAWV+tOzG/WMb868ETvi5lEmP37s
         3xk2PEXgBrBScqx8Cjrzv+KywW+P55XNhidWkkoFQaMysmbIRYF7wDzAgbfAxhijjeXy
         UeFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsM+XJccCFFVgANj4lOVdyNGyqGIXxP1Wa46Ns661PbYbh2dzw+O6Q5r9HW+v3a+xg4o53YlNPpg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9ErmYuCiv8iNn+dWWGzaIaUZ0qEAZ28BYQuBVK15G314ofakL
	1/tEiIdtGDwauYH82eQPp2dZuwPGT7/kXdnpmxDVJK1mMsUdn3GiHzQp
X-Gm-Gg: ASbGnctH24hNfl2rAMVonCz0brzPRu5/iKbWqViYgu4lPmMxvVhfD64dz0H9M+m/una
	m33yi1HUkxrwRMvRU2T2inhJl4pPxdFdZ/OzGrZlLHXdWa9a1xmOtqKp0ekdMZg2nMYU2RTDbiy
	s9aLpRfXramWza2Gp2X9c9GeHX5P3td3IanioDHkJ4y//1Sk5R/BvSJK9YmO8B8p30iP6yPgzPz
	enJREcjqFcCIXaXquwprcMUXxfpFxRXts3v9sV/ltidJKeh+SfNs6t2Civ3QKNk1Dea53E8BNGF
	QMs4A+rLM6J6+vsqFSsYpusbZWmKBOHc5dsd4ESQDajl7bJa1iRXEet3hrNlOW64gS7EYfCD1nO
	HqkDTo2O4kTOv4F6mRmwdYQeIHLag0IWjvCI=
X-Google-Smtp-Source: AGHT+IHTVOrXrZfK+kAqvvmeegQqbXJ5u1kSQeQq4d6GAFTvHJqKybjw0WNnBMaqSNBLp4I965jdvA==
X-Received: by 2002:a5d:5005:0:b0:425:8334:9a9d with SMTP id ffacd0b85a97d-42583349adamr13032753f8f.1.1760446831885;
        Tue, 14 Oct 2025 06:00:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582b39sm23296494f8f.15.2025.10.14.06.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:00:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	David Wei <dw@davidwei.uk>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 2/6] net: memzero mp params when closing a queue
Date: Tue, 14 Oct 2025 14:01:22 +0100
Message-ID: <80f18e7ee9bd50514d7dca31b5f28c5b0b27e3a5.1760440268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760440268.git.asml.silence@gmail.com>
References: <cover.1760440268.git.asml.silence@gmail.com>
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
2.49.0


