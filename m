Return-Path: <io-uring+bounces-10826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E76DC9024A
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 70FCD4E2400
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16742F7AAF;
	Thu, 27 Nov 2025 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4Vq6lT8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59E315D28
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276275; cv=none; b=fowYTI0qAJistP2bVLP71kBuk+FoteHU0CDF3j2M0Mw0GQy+XlcVuUVePZ8iPaNLCmn4ZKVr3oDeC0IZ7i6PdL1Rp/y3kghWkeNS/ZwxBCMvlKTxRq1VnMliygGcdNE/dXrw6rdfLCTdA3gjW5TmkGQ9BgCWIADXTOrCLkLdNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276275; c=relaxed/simple;
	bh=LSh5hLuiJCxDRwJ+BQ+Xc7tCZE16QA/b770rYhc+vp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmD3s4Ujodle5Q4T8FHA+D862WQFtv/KTIhZGhA4HwYCHIHyF565uZYTjpGncw/MljoiGwhpWJBtL0DNwegd2eZ5rShfZlv2FJFCF4U6ua7af1JiEiWXcu+4ngnUGhTZrAZJgIgH3YXd4wD41GKBiGKL7M6nuvWo/DS8Dfaged0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4Vq6lT8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477632b0621so6576075e9.2
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276272; x=1764881072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=h4Vq6lT8dw57ZZH9qYwYgKj40DBAQA5xlFNwfRYEnrpMIrT0ISZ16ioVBQSBDlNS5s
         OKr7CBmJc7rpRztUcdIkdL20sYQCEqxfKNw9S2pTWdajS5IV8p+8OjSZ8vj4uLU0N8fc
         BUB0mMsV84s6iwxryLWxQUiMKv1OHPAmWpc5cbJCvnslwq/szwv6Gw/5Cv9PyXQe0ZS9
         opRJkfbKBH0wdTl1SrYT5U33BidBSxKRl+rXISl9ELU6C/NDEj3X7MYJdMAQgB8NLQOm
         mgAt2pktouiiow4hpjQgQZ+orqEmk9O0VTQbD04Yz5QaSYRPoBsLTLImjlrBB6FLho3i
         AMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276272; x=1764881072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BopLoWIhKj7xpDJExutQghL/d96/x+rVfP3p1ohtywE=;
        b=DgTtEBEwZNtNqNOwMJBmVu7A8C3tfOqQB3xtmFGiG17LBY6bNBNANq5VoKHIf/shYD
         mWGnC2dzAnVAXMAfEgKnaN24OoJhHI5NyJB328dvKmBSXqt//RdJs2X9RVy1bkwNCs3L
         Yju1sIceXCyFxrebHGUZMtx4Mc9kNMEtLW76XI+s5ruZS4OoVBmAe/aLE+wlXi5EkkbJ
         NiCbgL16xaVSupLLx4KOq/04vqqWdjJKhO1Z7pVIDjjNFYRFFbWXI1gdMRpU0ZIbKzQr
         phz4BDexPDLI1pR52A6EAoAkRvImUJrRRPCtlXnP8rvHyDzb93oUanSwlHaQKFBJonHv
         6FNA==
X-Forwarded-Encrypted: i=1; AJvYcCXam/eImlE57qBwwQrfY3ZwR++j9lSPTsbwPZOtW7ULxfTt6T7iJI3BicjtdqXFVblithgaLBVl2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiVYDEg/hNNF1APoadhcHGj+Ekk6Bsi1SxEGG+CAOqUIAR3mcs
	jdEWdcTDAck0Dgr3l/T3hkqU3DSj+/UI7juutLZ/sffJeeX8rld96LxS
X-Gm-Gg: ASbGncuznAgDTr4we6LeeKqOER4b0eZUIFFsuUDyuIRD35jtgby54UbUyKhhnpHNyz9
	ZCYnaevJYyUwoWWit76o89duO3bsPbiWcS7XBD/R97MhfMbhg6iPfZJ9DaM2PcDFPOyPTdgJEWG
	5POzDE7TxFROmnC2+k5FdjsYStcNZA4g5h4EHLDTn6Xy7W+ZbQs8/rIdJcWaQq87vGxI5Pb6pzj
	sQAU1mwu3ewaYE7hd+xzB0z5AkgBfH1cIJV/h5CxEZVS6Wj1d7pcxALhS/wkmPgrdKSOmq08wZa
	BcE1TO18pcE5OZSGt95OodllRdG3OeBwPdTj1sWiyVfFcGfMYHkReJtN2OhL5k4mxny3hdpVBeH
	gW5KaEWt4Y7k+ZCWhcpE/x2fAoa53XMQYF4RPdJf1ioXNMPL5XSJxZ40AeLSt/M8vekvIaY3nBp
	JUPzlE37I5LclBow==
X-Google-Smtp-Source: AGHT+IFwRmakImgODlTFBacPBXxUnLB6FVPSTpr1ZGMe5y5759YvSUHXOymgL600ltx5XYutVYMrKw==
X-Received: by 2002:a05:6000:40c9:b0:429:b5a8:5c65 with SMTP id ffacd0b85a97d-42cc1d2d5d1mr27183858f8f.30.1764276271798;
        Thu, 27 Nov 2025 12:44:31 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:31 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v6 2/8] net: memzero mp params when closing a queue
Date: Thu, 27 Nov 2025 20:44:15 +0000
Message-ID: <cea893ad1560a47f6a1c6c8fbfe1a308613d11cd.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764264798.git.asml.silence@gmail.com>
References: <cover.1764264798.git.asml.silence@gmail.com>
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


