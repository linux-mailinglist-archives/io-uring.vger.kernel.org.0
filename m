Return-Path: <io-uring+bounces-8825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375ABB1398E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8619C16DE4E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4563B202998;
	Mon, 28 Jul 2025 11:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXW1t/X1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC725B663;
	Mon, 28 Jul 2025 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700616; cv=none; b=WiWbARhSnuYRZODHcgZC7RB3ELE9GWVTDEJawf7bqDbUxWHcGwu7Pz4FnWYPz9leUJ9P+APGyBnyjeJ6O+TWxuasUrM6i80a4LZDStu+8cfUqH8JxLc8lD1Kl6fuvplQb4Yce0TCw6yPpdkcmAQcDRI8f2jpGx9uwM+l378UoXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700616; c=relaxed/simple;
	bh=lwYfxi5NqTcdLDS3JLtP8/PoMkfggR/CCjG67u77Iq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqzLhJeOGKsb8BRqIy3iRlLPFc38ccOirgJVBxcbOuDUSfdCCJL8M4cSQ0Jv+QxSpKNTWVljdKdpHF9q27/hpGgbuxEPd6Nf8wag809VCrn9eLQV8+afRJtdgqR7EbfHsN0uW4JVqcLp6CInE3btfB8yZBmto5HCJSdr8X6M6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gXW1t/X1; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451d54214adso27597225e9.3;
        Mon, 28 Jul 2025 04:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700613; x=1754305413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OnVMPxTwHTWTej+r6RHoILVNlRYaZF+Jgl4QhvAgCo=;
        b=gXW1t/X1TqlZq7ySgi/Nn2xvVOHjBvgnHocWUbgTo5sN9/22p2+g98Pcv+CnKTgZLY
         HtIehcaZGKyGoeX4XQHnU7AUiUX3bvkTigIwYxExGGzQjcNr6jaZNvI0kM76DM6pFKA0
         M2FirFORMW2RjIP3j8d99jLln2neyL8XQibLX2dgusaqHLIRcFZ3+76HkPKvMzmlEIkF
         h5E+h4M3/LPRivPhRJBikdO5itLHLpEakib04wuWhQhRPmq+t7+d5M2MD0k8xIUwITxu
         rIebP3Vq7G/Si2XlrSBjsV7YKWKOcneFdbmkgzAnfjnZ0QexLRxtUTQjZah7AtHhr6Q4
         1TEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700613; x=1754305413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OnVMPxTwHTWTej+r6RHoILVNlRYaZF+Jgl4QhvAgCo=;
        b=M4N9zqz+iGxk/lK9c49biu4A/P/Noba/6aM8VdIpHdeNXh1v5YpU9A51ZRg9vdGuVm
         GUzsaQed6xXHH3bZQV9wWL6iEvgqfQEWOpJkXU1K3C9E1BEZOxTckYko24Mpv6fCuHJF
         SPJyHpa7FnpNZ7cFeL3cgx2tR63ausS1A+QCWSByrHf21B2V4p8UM/AKDuFppNtNMM8x
         nM00RLmqULYcITa3SAnEcfA6swDgh6WLUQRZh7H+/cYVQrX9wrCICozTFAMqF/+psNtX
         BV/Ycm+EXr8fkN4hbjuh0sN0uJxkSl4X1jLhj3M4FaEump2WTgMlfIvTvhz7sFdu0MY5
         iCXA==
X-Forwarded-Encrypted: i=1; AJvYcCU2khBvPJsHSDg9AtephWQvdOwBwcg6YrLam0179x3Ts7HyD0OMMsnDAoXsdHvRnaW+QceDOown@vger.kernel.org, AJvYcCXqwuvaf2Zo81EH+hN4hKp0JOV+PhNas+836l9sOJ006Db9+8OYT+lzG9SRPKO8IC9fkG4reUgzMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YysbfJKSs3aFdR7gdXTY3yZB3687eFNQbHcf/qDsxW4MyrUy28o
	D/fl29hJ+LENTe/SpfTFZQ9LctLfA2mSsppLcOsP+wv9s3kPYk1mRPgybzwr1Q==
X-Gm-Gg: ASbGnctcFHQ/vZNcvpgJ8Nalhn5YxvQOaEJbnNM95Ebb2uGsOHw/9N2HwgnVPzPLB0d
	xciJoPhm0x9+PEeB2sRUAGxixJ2b1cTCUMZ/EBs5CCilvnx4EqyaNft6FKcQkTq5HNDE3igtlnf
	YkfMajG0iFP+qSrUshHkUc2ro2GaQMxrDfF9OiY4ji3ser3yW74VIw0hUbYZLgLZfnz8eyzuAxW
	pvq9iyumaBuKRNfsOZlNN9qG/hhfcGuGKSyRzLbXLM9x0eKDctLCz4v6+GZPyL8LSzgojpxgVfy
	vo1gFmTlRo4X368xlwRRQzC9Jrv2dq+zx7lOJDxhv1L9apNIKce4gjNFn4++5C1GP8XTOiDlsxu
	N4pk=
X-Google-Smtp-Source: AGHT+IE07thBDclHI7rQOddZ84qdGn1QqUWNpWgpu41MOoRAWVcxC5B5/n/tfk6ABL0s50oULAzT1w==
X-Received: by 2002:a05:600c:4e08:b0:456:11db:2f0f with SMTP id 5b1f17b1804b1-4587f8a9ac5mr63521525e9.16.1753700612342;
        Mon, 28 Jul 2025 04:03:32 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:31 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
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
	ap420073@gmail.com
Subject: [RFC v1 14/22] eth: bnxt: always set the queue mgmt ops
Date: Mon, 28 Jul 2025 12:04:18 +0100
Message-ID: <8eb9793e5bd1100dd6db95e0c84cac32f8b44152.1753694914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
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
otherwise lean on the core to feel it the correct settings.

Always set the queue ops, but provide no restart-related callbacks if
queue ops are not supported by the device. This should maintain current
behavior, the check in netdev_rx_queue_restart() looks both at op struct
and individual ops.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b5f7a65bf678..884fb3e99e65 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16126,6 +16126,9 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_stop		= bnxt_queue_stop,
 };
 
+static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+};
+
 static void bnxt_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
@@ -16781,7 +16784,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bp->rss_cap |= BNXT_RSS_CAP_MULTI_RSS_CTX;
 	if (BNXT_SUPPORTS_QUEUE_API(bp))
 		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops;
-	dev->request_ops_lock = true;
+	else
+		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops_unsupp;
 
 	rc = register_netdev(dev);
 	if (rc)
-- 
2.49.0


