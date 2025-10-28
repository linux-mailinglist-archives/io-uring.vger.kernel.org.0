Return-Path: <io-uring+bounces-10275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA6FC1707C
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 22:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5FA74507901
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 21:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509DB3590D6;
	Tue, 28 Oct 2025 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="sttCoi5Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8006351FDE
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 21:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686804; cv=none; b=UkiWjTymcWz6W7qG59tJGLQiRxdr+oVJdgGKnMrHzPlMWbrVREY0BX232Zx3j72I9ThwqJ3x2GKnUXirzxbKpuC8NRiCCO2YFO847LvHO3qew1l8H0Ec6prZu3ZAJxgqYJOO9V1Mz4ITUrASaYjS1MqpTjKLVGNNi477r8NAok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686804; c=relaxed/simple;
	bh=NmfWWel/uLUgCXqnYeSfad/rdE/DuSTaCZQZtXRF7oE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qJeoHSXAHLKEjfsQDL8WIIAkM3Jg7Eh1YQiiMQBHHqs/h+0TPsnebH8cCUsa0eVQOGLoxeJArb8+ZLmZh2QDTF5ajn65z+kfxRXaqA7mvFuYSbAjZM3yPLnuqCbUC6p4lT1Sn4OMDPLO/sDz7x1xS5FPhhLphFyJoC+2H9K/CTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=sttCoi5Z; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6504c33afb1so167104eaf.1
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 14:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761686802; x=1762291602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lf/qKvY/6grSieEmtDItMT5V+0zB1kmOa/TLCMeokX8=;
        b=sttCoi5ZqHaBXmZ5VukAcK1rOBqtNq7ci2Reos64MRiWgp7CctXWsWW5SrvGa45wQi
         jxzVvz9lsxpx3F36zc+tBEptR0AQa2TQDG41FEFnxffbChiABG0AoXGzvRCfjQMsyzvx
         pYrAn6lbm2zJIPn7lPrfWRBKnpsZm9otJG7N0GM7F/uWmamJbOykB47Ki32FN6EBuCqO
         8Z7wC0oviS+z6HUVYtx2qJ3ATCyuGcIA44KWMVSwr3QFP4XgD21/HB9jsITkqVFN0XXJ
         M482A2No6ZIQhHpVyox8veUB3xQdsqRKhgwkBIj55/vybKH4P+xuHG2pLe4Yg9GtVPoe
         Gd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686802; x=1762291602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lf/qKvY/6grSieEmtDItMT5V+0zB1kmOa/TLCMeokX8=;
        b=HOyQ+Bnw+G2GsTUSpQnHDd+qQoqB/r/9ohAIMXwLB5wVXeOn02rJTD2zXy/raHMmwa
         2thI1Z9+7dTpBA/azsnAjTuDX2cf78SSCiBsUtsMr5wdqDmWfN5YsYCeugxWuG1AtYeC
         5M18WWbGd4GI6KDukoXo2e1GTG/Tgi05skjQ+tD738vSJvm1y0PauTNoKxNzOUojwugY
         triiO/n6hK+7OKoqnUcQTojfNbGGAg2kv9tfaKSKhI8gc8hEuyC9/ODQVOqGK7/gAYUJ
         Dn5uUCwVMPqqbzA8WtnfJYJc4XKSW02gi2rokRbWvsoTTBvagHzVYoBCo5RohP2T1TgE
         WcRA==
X-Gm-Message-State: AOJu0Yx2YzzSs6B3ImUShLq+aQB72EFL7el/h1Yu2lMFPV4GpbsKxRox
	mqiGp0rKVIrk//8EPvSDEkeiy1vBFLkooD6DA1B5utaKuaTY7RrPxUTl8doAjlI5VZWusxiChQl
	vgwwF
X-Gm-Gg: ASbGnctDvNs635A6wV8ZC3/fYjiVlGOnTEZoUb8RIiKvPTIX1FQ+OQ31Ji9p00bSPm4
	mvTGHh3qWidub3X7t0R6ISz3AnSJX1GEhUoitvKrY3iaaIHzcoV8WdgwLhWpv1QfzaF43UBp0Ye
	HCADCL7WNcN7/1lOVIie/tOMQN4WE9x+sZwczwbJDfkQ5S7WER6F4fjLIkbxmm7Qd9Rh1gltPh3
	eQNwZqszUbUC71SzIX9XcdmnTXJF4ijsH5VfflKGF9cHl4ZyUovYij9za/kXnOk4pdqNlfqvTwE
	xTyZrrN2ve/Jcg/iSpHwZhbaQJCiHt/wybdYbptMzaEIDUQw5TPaA7ngjPurAoCEnyMhop41XWT
	MHs3/n+xUjkUPOaehkad4QEayeCU6cKPl37x2fpwTyfxOCoeCuvbMg55y5n7Rr70/0vIoWL6O+k
	DIped9gmLAjxaVVwy+Gpg=
X-Google-Smtp-Source: AGHT+IHuy9AWJkX2b6nDcGaVqIeZlLjcxye366RNKuvVZD0nP8aoe4Til19GdVTLQr4y4RAQuo6r5g==
X-Received: by 2002:a4a:b684:0:b0:656:3197:ac3e with SMTP id 006d021491bc7-6567011505dmr1374207eaf.2.1761686801746;
        Tue, 28 Oct 2025 14:26:41 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:74::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-654ef2ae0d8sm2972050eaf.12.2025.10.28.14.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 14:26:41 -0700 (PDT)
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
Subject: [PATCH net v1] net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
Date: Tue, 28 Oct 2025 14:26:39 -0700
Message-ID: <20251028212639.2802158-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev ops must be called under instance lock or rtnl_lock, but
io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().

Fix this by taking the instance lock.

Opted to do this by hand instead of netdev_get_by_index_lock(), which is
an older helper that doesn't take netdev tracker.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..55010c0aa7b9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -606,11 +606,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
+	netdev_lock(ifq->netdev);
 	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
-		goto err;
+		goto netdev_unlock;
 	}
+	netdev_unlock(ifq->netdev);
 	get_device(ifq->dev);
 
 	ret = io_zcrx_create_area(ifq, &area);
@@ -640,6 +642,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 	return 0;
+netdev_unlock:
+	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.47.3


