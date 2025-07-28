Return-Path: <io-uring+bounces-8812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D842B13972
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F12BF17BA48
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F338B2594B9;
	Mon, 28 Jul 2025 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQ829mvS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365F119AD70;
	Mon, 28 Jul 2025 11:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700594; cv=none; b=DDjf4SrCt9nHj3F2aufXI44AzCwmdyx33f/T/rLs3nYOUYXoWXAQURHzLlD0AEt5KBWxvK9+k5u6AxEX7XiFM9CpWrdMWz2yfNE7eD+TkhL7xaiSzlB0chCd6jao2wMaMOcl4rBqPPp8B7aRaafhuP8j6yixIY3C87gCp+1nBko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700594; c=relaxed/simple;
	bh=fNqvn/7wBLg+ZFpwgZ5fDRQSP+ByzRTyVNXyVr9mwi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itcQQLmwOwjPS1vNJzUv7tQNsuNDZZ99yjivfWrQ+uFUwC6MHCNyGrJUpWAYNx9AmyPkvpCUmMaenNoaf0sOlMT/k1pQiAoqcX4NOzrddUGEEj5M8OBM5AKFxvioV7hvr1gQL7rEPzSTPa/JkMbHTr5rwtwmAKqiqfOnJXmozEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQ829mvS; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4563bc166a5so24950315e9.1;
        Mon, 28 Jul 2025 04:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700591; x=1754305391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DClAD2PzTadG9kSGvvOkMe/9IdZxNBy4lisn8SYmrKU=;
        b=mQ829mvSYUZhqpRHLVcQpgK47CeH4eoCcAi7sXmvYpr7hqAfnMUMgX7nWKVxO4ATlS
         sKQRCkVYTRZdRsbYSL2pI1aUuSAuk1s1eGHusFnKMU1ee3qNZsaH9IFnJmxjI0ogcZvx
         J65d8vnoFaxTTGgSKBLWPSVtLm0X+0rLeZGUkrMHE19BbQCkgZ9NrbRY1RHo2SfuV2ey
         cjXH2LMu2OO84x+Q+20K72mggyfAEVuL3riOP4mk/t70jVyfpR+AYd4DN0P8LUZ+iT9s
         yYFAR8/kjldEdMZBxAcdJEjElAmpy1pXslsMcguKzoLM3IWpjg9vOa88J5vchjQ3klOB
         6xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700591; x=1754305391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DClAD2PzTadG9kSGvvOkMe/9IdZxNBy4lisn8SYmrKU=;
        b=LE6O2tbcmVhCg4pkdBGEvWslq5KBi5faAs5AMveQie1/q3dtNTYY5O88igTbWCvsoI
         Qy7XIMnSZNxju0zKBjKZ5eLR0ENsr6Spgmszj0cmnXsvtxLVzvomYsOnRG7HfaAcRe4H
         6qJBCJe/YpKQtwVaOFdUeiyYkGc7nfQjgUSYMGL0ssxyRkURvFlFuadYLTxAMX1nDWAy
         nDyQYKxhSBTNqwPnnbraLBu1MxyYFaBI/2CF98iXeQ6gs9IQtivD9X6pAW7S1TAjdOBp
         iiyuoMZOLDx5vMUZ3ooWN5W0Aqa5u5h2TflosET75cGbnZ4SuFzLpbFsEsEECFXLgj8W
         SGmw==
X-Forwarded-Encrypted: i=1; AJvYcCU3gbWG5oaazQvrmg5qaQ6mqSMV7d3d2rK5OGM1jT+q9KPNGWoTtX5vgg1OQdVk2j+uHFwKh1BI@vger.kernel.org, AJvYcCU81KLsAPn4dD6dqGLM6Txj5t7esryKU5UOcgXv90ixchnctgGeIhYNIoaHa2RDHa+Y7q4EsIHRXw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3i3xlMdI6xFUgP4nXADZopmH6LgiomQ8IWjmIeeUYKmAAFBfO
	ambYN4K99ZgtUSyuHYhgZ9n9ROttAnr7qFO8lweZ5UOvnI44Q9DL3KeY
X-Gm-Gg: ASbGncu3jpFG0shcTT1hH5FFvYI/CLC5ZnYSgYgSeG6tpify3jX0Pp4SWL/CjXoClqZ
	CK5GrZ48vhywYtflQ5CKg9yei0xLi9B5lelJwd5k5WvAK+67ch5F4GGtw1Y+SHfUGKoun42KadN
	iKoY7uCx0hRXYke9hp5HLbH1/KOQSBoMBEJhf8jcKLBOsq7aGnfNvXveaGm3qkBITZQlQ8opueB
	bSFwebXrFreiWgxeWJ69hqOJacXT6D5vfCa3bLFa7msq98dEGYm4dEsNOjOjWLRMqMOSrDmGsbZ
	JF8SiUDmcR+wV4cJo8o80L12uoQSwfnC6VcipAopvumolHg1zNZDrxJKSxkv/TtQmfilLs4W9M6
	8eU4=
X-Google-Smtp-Source: AGHT+IHag/hmPoQE04akTLzUlFInDzYQK+iky6ca/PkzWdrDkgBLK8TTzvrPg0qhwmW5ubfdSElLwA==
X-Received: by 2002:a05:600c:46d1:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-458755f1f9fmr94903895e9.12.1753700591174;
        Mon, 28 Jul 2025 04:03:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:10 -0700 (PDT)
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
Subject: [RFC v1 01/22] docs: ethtool: document that rx_buf_len must control payload lengths
Date: Mon, 28 Jul 2025 12:04:05 +0100
Message-ID: <e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
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

Document the semantics of the rx_buf_len ethtool ring param.
Clarify its meaning in case of HDS, where driver may have
two separate buffer pools.

The various zero-copy TCP Rx schemes we have suffer from memory
management overhead. Specifically applications aren't too impressed
with the number of 4kB buffers they have to juggle. Zero-copy
TCP makes most sense with larger memory transfers so using
16kB or 32kB buffers (with the help of HW-GRO) feels more
natural.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index b6e9af4d0f1b..eaa9c17a3cb1 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -957,7 +957,6 @@ Kernel checks that requested ring sizes do not exceed limits reported by
 driver. Driver may impose additional constraints and may not support all
 attributes.
 
-
 ``ETHTOOL_A_RINGS_CQE_SIZE`` specifies the completion queue event size.
 Completion queue events (CQE) are the events posted by NIC to indicate the
 completion status of a packet when the packet is sent (like send success or
@@ -971,6 +970,11 @@ completion queue size can be adjusted in the driver if CQE size is modified.
 header / data split feature. If a received packet size is larger than this
 threshold value, header and data will be split.
 
+``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks driver
+uses to receive packets. If the device uses different memory polls for headers
+and payload this setting may control the size of the header buffers but must
+control the size of the payload buffers.
+
 CHANNELS_GET
 ============
 
-- 
2.49.0


