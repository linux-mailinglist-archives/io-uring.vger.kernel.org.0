Return-Path: <io-uring+bounces-9026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E3FB2A8DD
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3B473ADC32
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF17334708;
	Mon, 18 Aug 2025 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itppsPXR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935AF32A3D5;
	Mon, 18 Aug 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525413; cv=none; b=SQkLlMpG6zx56Rhqua5GM1SD4miAR95NiKruw76ACRLNTCkm9OsPvu53kyqGBAYzkjB1hfTAsDKlNxySgKSJaAEEnjr422QUOu30zO9MPvleTsisZkZ/AcHs971jwhHry0d39Qt0JoQOL+C1WbPCx5kX7VPebRW5h/UmZMvNK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525413; c=relaxed/simple;
	bh=mGd5zTDnP8+6/R0d1mih7E5A9LE5XPZC1Y/OWMGdGH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3cf1br0o8u3Vskmt9KXN8hSJKRh7pL5BQrI2LAV1IyjVBpRPDtSGA4GxWPdUp1TbbDkcxMw+5MUyZbjmFQuA3XBgVaEIVhhG+YRa7e0oz1LRNl63jVO58IllXDnMoqh5IUHYBxdB4KpdAFVLLABLP5kd0xQ3RoHJoQkrKuTqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=itppsPXR; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b00a65fso20670645e9.0;
        Mon, 18 Aug 2025 06:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525410; x=1756130210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0l1Q2AJy1H9F9FS1CSlvjw3MiwKgx+PXi31KVx/m80=;
        b=itppsPXRvou7Uup4QoooZFqIEwmqyp5NwObJLrC25cWXr1RhrRRrD8Myb7zEvi6N/3
         DUaBgoLoj8UvGsn/fJwShtrXgYGLRM7AtQd3ZEiCxQ9GbWt6Crj85kHaNm3falWbeRM/
         aNl4t4ybBfKCHHc6NoMAPove6oIg+dtkFoMsATcJe2Sr0WkculOSp8c5MZPUhH6+8sMH
         fVyFK10rhLj5xje3nu4xI6FK++z+wZ9oheYXcYWoNUeHJ//O3MC23zePzZnXDnyV9Y8R
         3y/fevJkeiua6jQXRBxu897p7fMf8AhpJwRfnpEN40iAEbhtwpw91jYIeUMNW3Brsphf
         T+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525410; x=1756130210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0l1Q2AJy1H9F9FS1CSlvjw3MiwKgx+PXi31KVx/m80=;
        b=MOBuHUXzcW79enhANFYHjAVRH9Q6dkAv+E32aqmleSsq96/CcpOzBYuH4/YW2WtIbV
         msOesij7g0QLNfYDGnkEUIWRtWK6t6iEIx2DX+drHvjx7+LezgfEfz7v3alvREllfXbN
         E35r238k4RJrfrbfsRzWX64Q7YOisinxebOSHPsjT2BBtZNTg193hel18vwpcmg3wDA7
         3YXg6J8JNnL5gvpistcd8rzRpAhkM4nfcLQOR0fLcXwm6UfPbeP2xivOxMrmG3SDLPUW
         Lb3m8f5ZMu0wKEIPmSWw/jgpiu4ydcF0qBEMBgYMDw+wylacVON5sWHgxy571+XFSH1W
         cJmw==
X-Forwarded-Encrypted: i=1; AJvYcCU7syUjk2xww8NmgZENJAapv7oWA6GzVaYsYROANCe/arF4xaNjR70TgFlTmJR6aLjugAu9fCoBdNabzAgG@vger.kernel.org, AJvYcCUVHPd3IsPZx/DJCzozyaCAwH4VjPZmHl6nyMfz/dEZFP8ukFBluNb1tpInf5C7galX/qAqdFY4tg==@vger.kernel.org, AJvYcCXUx2cl20ekZFVLwuPOpPI4gN4RJOH3bGn+Fnb4OLHNWgoYNYR/tKlEv2+uKhGai33BRvrj6rhK@vger.kernel.org
X-Gm-Message-State: AOJu0YxSN5iU05thekX9eUBzhFW0mxiyYN7uEvJqFgaqlyP4zMsLbUL7
	zAOG7anFLpgH/51fPR285HFO5wtOYyPuqiMqFqnhYRaEwx5IbPkC7CF6
X-Gm-Gg: ASbGncslxIb2oesX3xa5R1YUVpHM5m/WOB1G4Kz2wQ5bLnB1BtEFwIcJzkdI1ErHVJ6
	YAqdrW4V/r5YJStXzWxWcZirEN5eg7b6KkbS3NbKtTDbo5o3vyz3kBvag298IK34Y5Y1MySy3J0
	X3kyylgYea1X/kddG8w9vClozaH/aA4CWYVzWUtGrtqI8hc7F+4MhJPLbn4wDSAHNp6eiOsxRjz
	DrWquOIh9lRJWasjtTJ7EUO4MuyP/wieA/OlE3m+XEEcbdJdWuYhLVQ5sdU4Cal9upzpRCqcWS0
	ZEkSaKO7hT4povJYoOEwGdKCXQjMCACAujQQpJUYqWqL12aHNEwNWZdYd/Gwc2ihR/nvPHRhTK/
	5oe4/OuddqoRuIBaL+Y4pS5NGY8jTBrwlBg==
X-Google-Smtp-Source: AGHT+IEjxxvWt/ifwBZv+Mlc7Qp+L3RjGgZuyt5dO4CjlWtPG9aLLfbwpBBf4+SQfQN/oDZktmwi0w==
X-Received: by 2002:a05:600c:c059:10b0:458:bc58:850c with SMTP id 5b1f17b1804b1-45a218013abmr56154175e9.1.1755525409789;
        Mon, 18 Aug 2025 06:56:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:49 -0700 (PDT)
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
Subject: [PATCH net-next v3 11/23] net: reduce indent of struct netdev_queue_mgmt_ops members
Date: Mon, 18 Aug 2025 14:57:27 +0100
Message-ID: <724bdda392884e0fd1ee26457856f9e4fb7be869.1755499376.git.asml.silence@gmail.com>
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

Trivial change, reduce the indent. I think the original is copied
from real NDOs. It's unnecessarily deep, makes passing struct args
problematic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 8c21ea9b9515..d73f9023c96f 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -152,18 +152,18 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
-	size_t			ndo_queue_mem_size;
-	int			(*ndo_queue_mem_alloc)(struct net_device *dev,
-						       void *per_queue_mem,
-						       int idx);
-	void			(*ndo_queue_mem_free)(struct net_device *dev,
-						      void *per_queue_mem);
-	int			(*ndo_queue_start)(struct net_device *dev,
-						   void *per_queue_mem,
-						   int idx);
-	int			(*ndo_queue_stop)(struct net_device *dev,
-						  void *per_queue_mem,
-						  int idx);
+	size_t	ndo_queue_mem_size;
+	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
+				       void *per_queue_mem,
+				       int idx);
+	void	(*ndo_queue_mem_free)(struct net_device *dev,
+				      void *per_queue_mem);
+	int	(*ndo_queue_start)(struct net_device *dev,
+				   void *per_queue_mem,
+				   int idx);
+	int	(*ndo_queue_stop)(struct net_device *dev,
+				  void *per_queue_mem,
+				  int idx);
 };
 
 /**
-- 
2.49.0


