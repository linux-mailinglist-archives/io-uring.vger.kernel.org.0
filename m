Return-Path: <io-uring+bounces-9030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A80B2A913
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 417E5207615
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155CA33A03D;
	Mon, 18 Aug 2025 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUEjpK+o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5440433A012;
	Mon, 18 Aug 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525421; cv=none; b=AE27MexG7zw8AWE8MuHBcvgtohMYqC54/pZ/n3BetTEdlWSuhneKELCcY70H8j4DcfFYliPsFxjsi4YWmY74M6TBb0Sd7l7tgsdhqi7Abo6mFv9x7uvSm87gLzlJIbgLHMhrJyGFMLEotpGOWIoLgIaLZkY0ahTrIJQ8M18rxLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525421; c=relaxed/simple;
	bh=nD5PvWpNaGg+EB6vwWm37VJLhYDc4ljaynOHbbYJj1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYHYfExyHI4WRKxfDN9h0L1aBSADTmLeXUrUvMopvieYFQ5MdpCn+BPVnCTIejhGxgrUFq8lNvXHBSMLkysgjEdDZKShCT9a2u983/MQBNY1cy0avPIe4hb9KpuAPzGtLKoWLp/1CIzVRNnk4b+FCQURHt2GgdpHoHN+WI4isXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUEjpK+o; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b001f55so17364685e9.0;
        Mon, 18 Aug 2025 06:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525418; x=1756130218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvfnwBAFQAn1RtN+NTtAWiTt1fyLuYlp8K6FvhJpuWs=;
        b=UUEjpK+owQqptdhRvN++aJCpLbn5mjIW2DmgZ7Bu8S5Xqi9FL1+/QBcCz7uR2bkI/D
         070cZKitdV7mv29bbYH4W4Rx/qK4ZckhBI2+WsB5q2gJrICeBQAipKGvZabIf9/LW9cZ
         enCNGez1sG1jnKkVPlilnW057ZOGauLtJeuLdbTsTbtztlYAYUDB9zfnePW0kewr9Tyf
         gQyWoMsREGqBa0jJhCWt63d0NWywTqkJlqg6QQhejv5T4lVqYU7DZZbR22zgvsCOI0DP
         lbEuBFG9yhw1neDiqWGiHjV1V0y2JE6BK+J09kFDtgS1ZEgfMJXRESOdr9YZP89jcRAO
         sRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525418; x=1756130218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yvfnwBAFQAn1RtN+NTtAWiTt1fyLuYlp8K6FvhJpuWs=;
        b=babKgnRmnr8AXt0sYH2nEDlSr3bVe9nrrq8t/5nU/xWfzDkzJrzAd3mXR7DhXsdA5H
         TNKEh7AYuukgZa+CPL74xN4K+5s+r8TJQ5O13w4ewdpH9GMOcgQqfGx6NL8+13gpABWa
         fh2cFzmGKlr/YmtFyWmdG4OZJPAPkYNhkaro4NRw0l7Ialr2rp5S51jr3esh0fc3qiFv
         JcbFGVtn6uqp6NKFkK8Smzq1ZO9IVvDs643qgU4Zu02XzTuLa/5N23Aegtu3bFcI3RJ/
         aN6xHyTi81ulVatufrregLeGbwsMjuH9Xzesz+q6AJ6kLDiobrWzsgxXg8e2wVf567d5
         vm7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVgwo/V15FJVG5cmoOYZIU+2FD+1VBXCZXKKkRg8Ua5DX0CCDB/1d6K3BerBkE3DRm5a4eJ6rV@vger.kernel.org, AJvYcCWIL+tSaIVlO3QFfRkOvpGL9uW55dae8I6uU2BFJ5fjbyXUjq7Q/ypjwabbrd4Qh1Rf5HpVjGVirA==@vger.kernel.org, AJvYcCWSb8Q7c5Xb/AsMPNiRy/zK+Kn/l9u7GeRvlLcqr6Ld4H1EFzKQL5bjcljoy8kl+xgEwdyi9iPh7+ABEy3a@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmm7wpD5yVr0ASp8UneuxHe4RBUcS2iWSnPliq7NKjs/2x4aR9
	nqKuEujY28A44+jyB07bHF0cf6I6JsGdWyc/KUwaWULWqTesUpmlgOap
X-Gm-Gg: ASbGncvY4bgzGC7mLiP+x79PHVSG+89LrnLKiQeKz9Hhl0vVAHc9aSJPPSazby/ZUbY
	dMa9iIu5M76BF/uGzIJCdxojdgMj7vFmyLneXhxRkXb3r+LocMxwfxOAhTbh97GD6KKFdKB5nF/
	cFPNAd//ODWCQyXIlnS74eyoFSbjG6oc0ft04wyzOA8SWbWAduAhe8LrG3vMOsWDsdTiBzZWnC/
	bzPG4WbNysMQoIsTGY+O15e2mnr9PpEG6GZ9tbLsuaqOXAkS3jc04e+q//AC1FQEzOe1TFxnSUh
	qczgNXu4nOohSYj+hlazPZ6Dc/euFQXFQ80NG+An3tGF/Uk696Ytjnh+8+gzOKguYbajTrE8WOh
	HKJR//hPSdcYHL1jLkpLXu9NodvnrCgdQjZrYlEQjTUkN
X-Google-Smtp-Source: AGHT+IFNIPiylMCocGT3d+JBL2csDxP+x1EQN/XFfCq8zXqkDZf8i/3lXjmzrhHY+edquPemzKBMDw==
X-Received: by 2002:a05:600c:4f83:b0:459:e370:d065 with SMTP id 5b1f17b1804b1-45a267524cfmr86314135e9.15.1755525417318;
        Mon, 18 Aug 2025 06:56:57 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 15/23] eth: bnxt: always set the queue mgmt ops
Date: Mon, 18 Aug 2025 14:57:31 +0100
Message-ID: <63cfaa6b723410ec24c1f7b865ca66fc94fe9cce.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Core provides a centralized callback for validating per-queue settings
but the callback is part of the queue management ops. Having the ops
conditionally set complicates the parts of the driver which could
otherwise lean on the core to feed it the correct settings.

Always set the queue ops, but provide no restart-related callbacks if
queue ops are not supported by the device. This should maintain current
behavior, the check in netdev_rx_queue_restart() looks both at op struct
and individual ops.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[pavel: reflow mgmt ops assignment]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4cb92267251d..467e8a0745e1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16131,6 +16131,9 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_stop		= bnxt_queue_stop,
 };
 
+static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+};
+
 static void bnxt_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
@@ -16784,6 +16787,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (BNXT_SUPPORTS_NTUPLE_VNIC(bp))
 		bp->rss_cap |= BNXT_RSS_CAP_MULTI_RSS_CTX;
+
+	dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops_unsupp;
 	if (BNXT_SUPPORTS_QUEUE_API(bp))
 		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops;
 	dev->request_ops_lock = true;
-- 
2.49.0


