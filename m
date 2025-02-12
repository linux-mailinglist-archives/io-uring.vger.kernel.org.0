Return-Path: <io-uring+bounces-6376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D963A32F19
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A63F168B53
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFDAC263C65;
	Wed, 12 Feb 2025 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="za24uZQa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02F263880
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386754; cv=none; b=V7oyF7rotsA6Wx1k6tNxCM/of8u0oF8Mg7SrQbMKO3/rqjXB6JA265/vVeAZGJowPChuxW4QihENGKvrlBll/PfOazok2CR3hiEmlqcYX18tbem8t7/MhexsEazmPORn2h1SWiTQbHeWVLRyNxRXon34W53GLT7hdcA8swQxWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386754; c=relaxed/simple;
	bh=Dpy282S2VS9hbSG8QbL0FgWrEKfT6otuKfGWIdJQ0Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk7JPDy03M3F+jH2s9Vh2twiZhVZSk1WcUkKiOqff8KqGECzNcK5gUb3amszkNupL0i1jPfnZ59J/BLCyGVgTEOctIMX7v/Zlc2vthrJAv47G17Sw3jOOtebSJbxlBFDIo93XTha910oIY7CEXpqGfaO7sTI7fAp7sStcJCvUs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=za24uZQa; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fa40c0bab2so225929a91.0
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386753; x=1739991553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVZ7I9E//ExcaJzKh4O+QD5jakmBreCl243jnc0OV9Q=;
        b=za24uZQapsdkjw0wYNLEaNSFAUlkhJR2KmHV754dGRiHHxLcAyZMmWNoIyf5ecRLWv
         mZrRTjztX4Xl3yp3ATfcpcgPAhQnfPCD8qEGMCvNahkctD/lpHfa2xcFOUH21QBWJoQk
         7DRYdRrUWdX7Vq2Ld9KSKnciGfpbr12YBanSy3nYXEO6oyAIiJQfkYbtpCnyGTBSGcZF
         02H1wKTlWmFpPG9ersZFYidRzjlBzQ6pq9hMhagEoY1MfIu/YLradHa+6nUbrjVcrnyi
         V3C1axODlRVJCGhVMutyiDaNBeP+cc4WnohZdvYcZxSe4IHoC/LGJlNMpxuKTa3c7sHL
         AMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386753; x=1739991553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVZ7I9E//ExcaJzKh4O+QD5jakmBreCl243jnc0OV9Q=;
        b=Cr+rPqVQjNpIvMqaGtYZ477uibSYu2bz5qmOpML45fvRZUedletVpKaaHYzn632ODq
         zeZy4d2xChKwc58OQtT0IPnD6K8r1NkRzUOjlhS35ErKPOAzG920u35QpW2tPxy+tQBt
         VrZ+ZQNVggr/Os55bsBfR5GjN648Dyn1hLDpPuYrMM8XHCRb8VD/Ff/BnF7KMYYUIIVk
         s76wh80uQLdBP6Gy69G7nXIEka9JlrvJ+TSimS7zSOl8nReFizpxFXTq06SCFlF25U9z
         HkbD1Kv1WHwmiuH3wdVbeF5RGqi3rbtEJMT1Lw+oT+CHQJ66c3Pfg7igvlB/yV9he7ta
         K90Q==
X-Gm-Message-State: AOJu0Yz1R+mlo4U2HjjsBTqLOyGoxvGqidlEqJPnLUngdrRIDp0xAWOT
	fRmY5l1Nlglw3bfqw/MebQlbhc9rjMShI07vEXUV9fV2C2yqW73Ud0tVY9GThwXWhCoF9zQhPZj
	e
X-Gm-Gg: ASbGncturFEJw79cY20C5KTF+CHJa0SxqOhE10VqQH+p5fSQPMJBhIcgwBdXrRYSf1p
	9f1AfxcYOvqw09xZu1j4hF2UMXz6Wlh/0EVqFa1cWZiXw6LESJNNBBybGWZTYT4/sXWzamJq2gH
	FK8PFbOdBkOT2ARjZdkfARXlVwDtpDlHmYQQ2miWLQy9veYAXmqlpLiZ19jNXISLD+pDClk5nEk
	w6irEun1WJYPT0OavxGLqJn/tkhKQuxCq531Lc9t+Rsqv+SRjfH5U1KUL/9lEUHE0P4SE0Bu8vs
X-Google-Smtp-Source: AGHT+IHAtFBJ3NfxI2ZHlX5KmVZcNDon8H18mxMQ89ldOl5X+k9um4xX9aGb2VBDMuXlKKR6270uhQ==
X-Received: by 2002:a05:6a00:8006:b0:72a:9ddf:55ab with SMTP id d2e1a72fcca58-7322c38b08emr6234057b3a.10.1739386752804;
        Wed, 12 Feb 2025 10:59:12 -0800 (PST)
Received: from localhost ([2a03:2880:ff:15::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7309270637bsm5631443b3a.172.2025.02.12.10.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:12 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v13 07/11] io_uring/zcrx: set pp memory provider for an rx queue
Date: Wed, 12 Feb 2025 10:57:57 -0800
Message-ID: <20250212185859.3509616-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the page pool memory provider for the rx queue configured for zero
copy to io_uring. Then the rx queue is reset using
netdev_rx_queue_restart() and netdev core + page pool will take care of
filling the rx queue from the io_uring zero copy memory provider.

For now, there is only one ifq so its destruction happens implicitly
during io_uring cleanup.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a487f5149641..af357400aeb8 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -274,8 +274,34 @@ static void io_zcrx_drop_netdev(struct io_zcrx_ifq *ifq)
 	spin_unlock(&ifq->lock);
 }
 
+static void io_close_queue(struct io_zcrx_ifq *ifq)
+{
+	struct net_device *netdev;
+	netdevice_tracker netdev_tracker;
+	struct pp_memory_provider_params p = {
+		.mp_ops = &io_uring_pp_zc_ops,
+		.mp_priv = ifq,
+	};
+
+	if (ifq->if_rxq == -1)
+		return;
+
+	spin_lock(&ifq->lock);
+	netdev = ifq->netdev;
+	netdev_tracker = ifq->netdev_tracker;
+	ifq->netdev = NULL;
+	spin_unlock(&ifq->lock);
+
+	if (netdev) {
+		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
+		netdev_put(netdev, &netdev_tracker);
+	}
+	ifq->if_rxq = -1;
+}
+
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_queue(ifq);
 	io_zcrx_drop_netdev(ifq);
 
 	if (ifq->area)
@@ -290,6 +316,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct pp_memory_provider_params mp_param = {};
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -340,7 +367,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
 
 	ret = -ENODEV;
 	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
@@ -357,16 +383,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	mp_param.mp_ops = &io_uring_pp_zc_ops;
+	mp_param.mp_priv = ifq;
+	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
+	if (ret)
+		goto err;
+	ifq->if_rxq = reg.if_rxq;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
-	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd))) {
-		ret = -EFAULT;
-		goto err;
-	}
-	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
+	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
 		ret = -EFAULT;
 		goto err;
 	}
@@ -445,6 +475,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 
 	if (ctx->ifq)
 		io_zcrx_scrub(ctx->ifq);
+
+	io_close_queue(ctx->ifq);
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.43.5


