Return-Path: <io-uring+bounces-10317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F28ACC275FB
	for <lists+io-uring@lfdr.de>; Sat, 01 Nov 2025 03:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3FDC189D4A6
	for <lists+io-uring@lfdr.de>; Sat,  1 Nov 2025 02:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3167C25B311;
	Sat,  1 Nov 2025 02:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="QTHANDRW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BCB25783F
	for <io-uring@vger.kernel.org>; Sat,  1 Nov 2025 02:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761963896; cv=none; b=Jpfgfe6itPoQsVRpoY/pwClOS5fnLgrSqccJIFUfkXJT0EqeEkMLERg258G+iVmXmtYxoNM4pbaGcBABycq7A0+tKNMYNyzZP/8AN2o+acY1dkEc8K3dG8Y6hU1Tm3VMcvKBPKV5XWNiSVvmVinPF4t1lLAAT0URpWZCt/q8kbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761963896; c=relaxed/simple;
	bh=b5yo7g3MZU1FijxRkUhNS/q6XXJNwXad+y5lAYbqm3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUDx/W5v0V8njUiu20R76d8rqyl7oBUkvemvHAud3fCbF5MlOtp54XECcQzDgbvcTSUtRFLp/mWsYzkJwXcW0BrO5TVa8iyYTIn1hbfQNMKfIA9Cb+A6NII7KD+B6JhY+LZlQufYfq8Y4OlT+FT4abgkcimLLU9z0Jepip3LBcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=QTHANDRW; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-44f9564eb0bso845030b6e.3
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 19:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761963894; x=1762568694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMtSUVt3oTxs4d8Yt4wZTEMxA2A6WcjkTSoUILrkV8c=;
        b=QTHANDRW2sNLFuuot7DkLuBz7ojrlt6xEsVKBG7HNKWdfXbEYVjcJUoxa/jIyp+NGI
         Zai9Vwp2TRG4C286PG0CxRBUmd1MfrC4eZ0dKqYtYwCZqbH6N58hTp5ny9L/AC1G2R0F
         N0ikg1NzI3oRf5JEV91UF4eIQox2NUi3DgI+/4AmK6TP8u8XDLWMXdP9vIKoyyALqelI
         upJmyQcIOAXYmRzF3Xm+vc0GPSnftGY5d1scVLlgpkiBLxzJgdiRPwcyJ1Fkeh9OXmOB
         RxtOWyXEO6S3rM71vm3OY6yFrfWGHs+bBe0UvwOkR09KLUqyCBaSQPh798V9+4FiTWBs
         zv5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761963894; x=1762568694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rMtSUVt3oTxs4d8Yt4wZTEMxA2A6WcjkTSoUILrkV8c=;
        b=PKeC7vsTZ3dO1tq04NBUvWLn9Z/CLLgvxkdHCVFWAOml3iu7qHNbiIu18pTZx46pZQ
         Qtq8ljK0nR1OvIv6sR18y8MMk6KA0nqH50TdGw4CCRYVN2Qve4yFTS3Kd3fDwnDtGegp
         HERaJA210HaIdHqq7pRQgEo3P2dB4J/Fxonv3ccpTzfEeQ9RCTvagf8hbZeBIIQwIvrS
         ECbawIH5EX2lFZ761pSgZvUqOlLkAkSAZP865RtuJvVCOnCa2NrhWrHct5au5WcHU0Q4
         82u2ixhvQp7WvBTQfHbCBpNXVDO/JmAOKTMX+IcMD9uhCUwjx3NZ6FfLq84HmXdH3m8P
         uJ7g==
X-Gm-Message-State: AOJu0YxSOvRS/c3Tkp2L8NbkNYR7fiOHTkEoEkNwH7uHAV4Iov1MeeAT
	jtjpWh8+Mi7lPMNujIl/KZy4MY5Vxkm2P61yZOdkUUK3winPOw203Zibl4IznmQmuYGi0Z8jSfb
	rrti9
X-Gm-Gg: ASbGncvUAYeCtMiPEBxGWITFKumULsUtbZj24Xnx0+k8YOhVvyVLgzHcqNGjWQTP/gk
	o1qoQpJUnd6FsfuLvcIv/ThaT4hjoL3TsUwyUg1NkCmABcddQF1vousAlfEXgvx/Og0nCLVEjMr
	IqlhDjSDNAqx+wG0LYOFAZDYry5/AY+ICk3WCzPzMc7uMQpVPm5nuCN4FOVXRd0qZ3SvX0kxLWX
	tDK1sBYJClLmecR59CpyHSDNANAYGn3EpVyiHneM6LnkyvquQzGGqDnuqoD3Qw3f3L3O80Mn5jV
	n69mCJ7Rs1fgeZp09Ssj5IqUeyiMDnPc1xFIsZjhpM1egQyYb6i8pYVeCkwntJKcLJV0EtBhgW9
	KXCnNdRE4W0fp+VRHNat32hiNeuIJJQ2qp/dEx/pDIQ/tRd0UIBWC0mGBTYg/WlD65Lq6D1W8RW
	6JNyvPYqYvPUo//L//q+E=
X-Google-Smtp-Source: AGHT+IFZuGg22ixwVqdlXJEvkn+nh1eIMRzgR50YHgoqPtaBQRHCnOKhXy2/NXZYs/uhgBqjQUJOuw==
X-Received: by 2002:a05:6808:508e:b0:44f:9513:3dc0 with SMTP id 5614622812f47-44f960413a0mr2643162b6e.61.1761963893682;
        Fri, 31 Oct 2025 19:24:53 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c699d9f305sm1023372a34.22.2025.10.31.19.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 19:24:53 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v3 2/2] net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
Date: Fri, 31 Oct 2025 19:24:49 -0700
Message-ID: <20251101022449.1112313-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101022449.1112313-1-dw@davidwei.uk>
References: <20251101022449.1112313-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev ops must be called under instance lock or rtnl_lock, but
io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
Fix this by taking the instance lock using netdev_get_by_index_lock().

Extended the instance lock section to include attaching a memory
provider. Could not move io_zcrx_create_area() outside, since the dmabuf
codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.

Fixes: 59b8b32ac8d4 ("io_uring/zcrx: add support for custom DMA devices")
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..4ffa336d677c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -599,29 +599,30 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
-	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
-					  &ifq->netdev_tracker, GFP_KERNEL);
+	ifq->netdev = netdev_get_by_index_lock(current->nsproxy->net_ns, reg.if_idx);
 	if (!ifq->netdev) {
 		ret = -ENODEV;
 		goto err;
 	}
+	netdev_hold(ifq->netdev, &ifq->netdev_tracker, GFP_KERNEL);
 
 	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
-		goto err;
+		goto netdev_put_unlock;
 	}
 	get_device(ifq->dev);
 
 	ret = io_zcrx_create_area(ifq, &area);
 	if (ret)
-		goto err;
+		goto netdev_put_unlock;
 
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
-	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
+	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
 	if (ret)
-		goto err;
+		goto netdev_put_unlock;
+	netdev_unlock(ifq->netdev);
 	ifq->if_rxq = reg.if_rxq;
 
 	reg.zcrx_id = id;
@@ -640,6 +641,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 	return 0;
+netdev_put_unlock:
+	netdev_put(ifq->netdev, &ifq->netdev_tracker);
+	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.47.3


