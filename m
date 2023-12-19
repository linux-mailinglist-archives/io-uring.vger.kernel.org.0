Return-Path: <io-uring+bounces-301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BA18191E4
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6953283C09
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B6F39AFC;
	Tue, 19 Dec 2023 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="KTauUz9t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6D3A269
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso3792699a12.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019847; x=1703624647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHaFgdexCzA0uTP4OJiRQISL/EACmJ6kzizjojPCXBw=;
        b=KTauUz9txi8e8EDGRgr7KZDO3GLkQxgu9BD+dn1djoKo/8Enlb+nguOCnC3D8nyDmz
         dzKgEX4OKmqK+TUm4Nv/izPM3FHj++rCwbB9aQYQOv6hPupeMWCQ3yui2JWK3vEObReB
         /ccew2Dj455A2VWcpa9YFFCEo9CqzEW7aAIobFD/TZ1WWSnE+norGtTqjRdE5vcPlTTq
         6mplqBvIZparTmqfSI6n9C1hZCC20AKZjgO5A2wmrNabqK0vptd+rpryxybdVOxwjmFK
         dCyA5y/VmdCyuAm2aAbuU6ep7W7/08uGNyi1807TWc7Tf4L2LpS9sCmZFOsFkIVJV5Tc
         x7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019847; x=1703624647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHaFgdexCzA0uTP4OJiRQISL/EACmJ6kzizjojPCXBw=;
        b=w5YH8zfZMzwOC5x/3pT6nW+OaUIV3jV9if9u482pM4L4/JVdXjoIYdOw2m579XBAaw
         U0U74lz+yBztJPmg5/AdnNdnPqU/vJ+kPXJprUx38XH6is/mrmuJwgHHRa8TXuFGWZcD
         ad5mlSWDtPmOtHwEtm4PO2ay0WqSC/9KboGOE5s/aGFXVeJyMWs7fA4K1K2VdnvQVzZH
         zPyM/DznhoR1Eoz3Oe1Dwr5gPreu3vSK29yBgZ5vlfv1WNF4V1vmCmeh98Cpx33VT0nH
         Lh9+uRmVAt203M2iZaT/3D0//OqUMIf+eEZyjbQ9bBA4UhCTW21+teqgY6Sji3WCnXli
         unqA==
X-Gm-Message-State: AOJu0Yy80H9WsouZ94BbaQxUdBVLERS5de8Yr3XZqWCX1+9d/+GFoIH7
	YC3Si394lxmHa+ew4Yd/nAfJDztvdcGOBj4o8l9y/g==
X-Google-Smtp-Source: AGHT+IF16V9K9fxk40dVoBfsF4UCnLKdU0l3jKOgVGqIYtUJwS2ni4AdskvJa710jcq0aAXd9+X4lA==
X-Received: by 2002:a17:90a:fa4f:b0:28b:c572:1f0 with SMTP id dt15-20020a17090afa4f00b0028bc57201f0mr819001pjb.90.1703019846948;
        Tue, 19 Dec 2023 13:04:06 -0800 (PST)
Received: from localhost (fwdproxy-prn-020.fbsv.net. [2a03:2880:ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a4b0f00b0028bb87b2378sm2082025pjh.49.2023.12.19.13.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:06 -0800 (PST)
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
Subject: [RFC PATCH v3 02/20] tcp: don't allow non-devmem originated ppiov
Date: Tue, 19 Dec 2023 13:03:39 -0800
Message-Id: <20231219210357.4029713-3-dw@davidwei.uk>
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

From: Pavel Begunkov <asml.silence@gmail.com>

NOT FOR UPSTREAM

There will be more users of struct page_pool_iov, and ppiovs from one
subsystem must not be used by another. That should never happen for any
sane application, but we need to enforce it in case of bufs and/or
malicious users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/ipv4/tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 33a8bb63fbf5..9c6b18eebb5b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2384,6 +2384,13 @@ static int tcp_recvmsg_devmem(const struct sock *sk, const struct sk_buff *skb,
 			}
 
 			ppiov = skb_frag_page_pool_iov(frag);
+
+			/* Disallow non devmem owned buffers */
+			if (ppiov->pp->p.memory_provider != PP_MP_DMABUF_DEVMEM) {
+				err = -ENODEV;
+				goto out;
+			}
+
 			end = start + skb_frag_size(frag);
 			copy = end - offset;
 
-- 
2.39.3


