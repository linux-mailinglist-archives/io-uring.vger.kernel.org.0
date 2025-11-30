Return-Path: <io-uring+bounces-10862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 63748C95672
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 00:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 983543419C2
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 23:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420722FFFAB;
	Sun, 30 Nov 2025 23:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7UypCOO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27CD2FF65D
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 23:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764545739; cv=none; b=AzjuzAX/g7H7Uae7QN5jJryhUO58WiLa2BzIrFGaoHy5wUH2r8+8kTUV59NcJObyJa2lDMYF07KhhbvVnsOKZhnMXbFame3gpHHEn+3S+H5YHXC8cDG7BPrYAi4i95ZUA3TkiohckvLqYbHtSr8hSHgJ1/ZcAl87STpHqams+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764545739; c=relaxed/simple;
	bh=LSh5hLuiJCxDRwJ+BQ+Xc7tCZE16QA/b770rYhc+vp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkIQhqJh43x4G4a5lhDQvxXW7vn6miXRCIFdgs8K4zQ3Ikhn033epdw7tB9ycPIsFjdk/lj05d2Fi+WRPy74Mc33atMCDAnIKjB+kOaS7xXnTBLNnxenKvFQuiEXxUUeg4LPydeS03K5kRXjg/ZWOCcnbedAkVLtSboD/YM+EEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7UypCOO; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47778b23f64so19530265e9.0
        for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 15:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764545736; x=1765150536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=D7UypCOOix839eTbKC/dmhlH6EbPRl2Q9K5FTyuaos0ra5SfgnRH67yxhdXonRzNE1
         JLm/05xwKtxykCoPmzkttHKzOmVki1Jk1KIITlrwiebCDzkATqj3aa0lBfnszDQIwT8i
         ct5CkJNOqMBUydrm89AS2BFiomYcBjCX2G3YsZ3MSuE3aq/ps+ZtYJQxcjULM/Z81xPm
         hqjkAzibMOr0aVfM9a0KkPmay+GuLD7jQddO38eBauV6wOpy2qkK/5B9RIqXSr/PB6RZ
         W0IjlPfXngCtYQbDJzdtD1CA18rqtwJrrgmy1LKiYd9iwF0gqqaZhlRZv5MoKAlOlV0a
         F4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764545736; x=1765150536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=w9iv9hbIuMF2aHUNsQ0x20tRxpwctH4qmJwcUioWee7+FAGvrhvtKrut2c6IC6SYc4
         +GR1agdSU/y3SkwlptM9mkCoh4thxUZmUFAT1E0P5UbraNtL1lcpAFjKH5Xysa4iealP
         SVsFeESNMldcIAIjjFqcuZLCFJz8KPBJa7iv/Lxa3RZPgNf8QmDEaT2ykOtk6RyPRZ1o
         DVlqfRyYT0t99nWl+Gaqgt18oBG/E8Zsh3C0HDLbRM4VZcn4RoWjGzInp6XM/5kZk4rQ
         NsyOxG8CPBCaaAUFQNDMIK/P2HKkleuF9SyBmOIjLhIik2rZixjP+D2VW4u8XK9QXOFJ
         GIYg==
X-Forwarded-Encrypted: i=1; AJvYcCVkPgBBukRrpEm+irAz+7CIe5GJBB+a16kE7xVb1qloES++Akgmt1ML/xWpzjggJ5tAlqQl7phubA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsjMHlNRQGifa+uiBg+qOS1RwGP0mByhYPDjk2HOk3HAtlFxaK
	jAq6QGckoL1ikG/43M2sIyEX+WWitE8nEQtaq36RFsmPwBFoNR0Mt+0y
X-Gm-Gg: ASbGncsmHWfUUY/1iKJlzFBhiYc+KJb3AoXtNPp29TaeliIaN/lbCWZAjvEnlqrLgYv
	WxOXQDGmIEiQe5KZUKuFLCtTrSlTPSZ/kXCEYljhjLPpm82FV6GoRl45+glGKkPttv1MUrq1QcF
	ftcymttoc5EBh/1AaGMI2Mc5cNVsQ70hYVSqwdJJ3kBsjuNsQW5ecT5ujeR1mR8jfK9Bu58WD3D
	3mGuc2MIzG8PgkbtaD190s0J9A3vlG+HfZdSpzQtcdxI9mbvK/4ANZ5RmIoYgxWAb7nb3LV71sO
	EmDE51slr5k7W2pcDEdr07iD5HV4nSIgQ+Dc1eezJd+Lp/N5pTrh108PX8+BUiFjmPO4ff14o0C
	YPRT6xVn+ITfA+XzQWxvd1MFD/ABx8GJF8u2s9ww7RTmZJJVi1oBlLTsvq3jrxEVEC61FBESFfO
	qDNWFOzXVEnzvjEuKDAGW2M8jpiosai+lS/wt+FDOMdaKHKZTEBe+1bhwl3iz62hcD9MODcgRq6
	/EKRNnUZ2yHy7uLylZfxdzLcKE=
X-Google-Smtp-Source: AGHT+IHISYLGMcAbCVZNiKeY1dtZPkbvCAz/q8vqp6c82/yUdHZQKIhPMrYnHbV51FKqG4IwK4u77g==
X-Received: by 2002:a05:600c:5252:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-477c110328amr358728235e9.4.1764545736071;
        Sun, 30 Nov 2025 15:35:36 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b3092sm142722075e9.1.2025.11.30.15.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 15:35:35 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	David Wei <dw@davidwei.uk>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joe Damato <jdamato@fastly.com>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v7 3/9] net: memzero mp params when closing a queue
Date: Sun, 30 Nov 2025 23:35:18 +0000
Message-ID: <374b055a2119076d43336008817248854774668e.1764542851.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
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


