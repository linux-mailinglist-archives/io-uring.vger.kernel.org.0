Return-Path: <io-uring+bounces-8821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29ED0B1398A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCB901884C07
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B9F2620E7;
	Mon, 28 Jul 2025 11:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qsw03Miy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435C25A33F;
	Mon, 28 Jul 2025 11:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700609; cv=none; b=NHsOowvSSZSBldFSewy5oq8W5k2HEZkjTA9ExADCdMSLwuD2aLGKWJrCZrWohhKRsj2x/5PEudvm+XTUsRvKaNMfy78H3j41nd7vcLci4iu6+A0RlCWfepS+0qJ73ZVUhyNO3khxOhHnpxLr0s3Im8dD89fTdqvrJHCYvUtQFGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700609; c=relaxed/simple;
	bh=Q8VAoY+JiTgBOS2OE592vFF+nO+fAG54zliJVUv6aRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVFtGItC3ZjRjMwphtiU8psyYUQZAKW3PBL70UJwu27pgBiPANASbKBJg9ja7jM3wiVbpG53TFh23AJhbxpZVF1emsYk4BfBW91HUzNU5a/02vWbWn7U7gLc8bBnY1YS056at8LkNKLl6a7EBfCcYqajYQPVJNfYUcFakyz2+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qsw03Miy; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4555f89b236so34989205e9.1;
        Mon, 28 Jul 2025 04:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700606; x=1754305406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Og1+oClwVah8diY/ULCXBddDc6KYDKD9ewvWOh+xo4w=;
        b=Qsw03MiyZdv8Z1UdTQwGFVkEuC5oP7t1wbV/q6hHcniQHSlc4O+WoL1khOZ+cLgvrB
         QQL8EZpBQCGrcJH9vmjwqhjUJL54rGXAO1hcHzZQGw4e6msWLarCgtu59PCb0j9ZBRVU
         7373NWHAQIS0MIu1OTN/TH0EgYpkKCFde2Q3xuy8MBmg0ngSWAU2CN6Kb34GGBK9FxWA
         d0DBwKGuW1skQlWml03RcVi6k4B/vqp9KD9bLhQdYfxyIbfoqdk/oGUjlejkPmZP6fhm
         xicwAkYyndSzTZbQxIYGGhDcq1xJyFMP01TxQSLN/+CkpyP80fhq/itjZ3PuF+wWITbh
         cV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700606; x=1754305406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Og1+oClwVah8diY/ULCXBddDc6KYDKD9ewvWOh+xo4w=;
        b=Cw2XFrlOaqanCrR6UNz3Xf7Osmt/aDRJzwbQflW+8yCRXCVXAasbvoc8j9AmwPw7xU
         /il7BmDKQIVCnHlQv0aPChrd/qjTKvjKI3MYj7TdwK3HMdwttXlojhMwyZP+2/QPKcwL
         gVqy6ckYICUNqFUVG0VO2BcTU9RU60SwRnaqnVDIZE+xn/pf/n4ZES0XoCD8LL0CdkGm
         /MIPcyEVp/cFkC+pUvRdOnbcjPDrIcsWbJK8DBF6YY94WD7iilHEj0kKaeesFaupU9YJ
         fviWXKXGq19LeqD1BCyulp5HYNmNFY3mSPQQ5v3z5R/2+QOs4LIL/Od7RHA1YP/EB5yl
         /sNw==
X-Forwarded-Encrypted: i=1; AJvYcCUmghfdzzGk6XlqXrfLfsLWEsj68Vm/SwF3RwqZDPp95xwebPFyfkT3P98PnNBDxDxhzLyIXvLQpQ==@vger.kernel.org, AJvYcCX1T1NanZAfHfdNMPSRLtFxrlVLFd9f2N0DsB6KyvRKbRHSsQks9xf7xoJTvM8W0J7uqownW8C9@vger.kernel.org
X-Gm-Message-State: AOJu0YwW1VeVzwzJPLaGuOpP6Ha6dStfM7i5JcohVMpACCHTE5U4+OuU
	OYzfJgeGxS2uKKw3F8sxxpL4xrFCllbNzdb2SM7FRiwx/VVlDRHx0xUf
X-Gm-Gg: ASbGnctFF5b6y4NBnT7LSQBSl2YZQOf+AD4eF3xmH6Hgm+NrdvEJPvrw3X5bvkEb906
	w8R1uOg0LV7te5DAabf1M4rydxEN3y690TN9JGF0rFLErtoYzFvcdVprs7K9Evf+77gRNd1fLFS
	oNlWcJHFMHOBJVze3x3ya0txXhEM4zL63GDsX3x8SaVAS8+UjDAJ+sB9vsXT76RMgDyI2tez0xY
	ZI7kOEHSLSVCNK4B5h1Ca0Wr5i9yDs9lLOhKxtcjWTqeHdynLHVerx3eRguPgYLUooveCZObIFI
	ALyjO27Wg5ZfvvqxUk5B0ftUvRMiw54nb7Jhicc8i0EkBxGg1bpoHAWRe+eSDAQP8poZlOg+vZ1
	jmGHYGTlX20OlrQ==
X-Google-Smtp-Source: AGHT+IEqQDds6EKXvPfkDKlls7BlLljmmOgGkxqfYXRoigvFatSVi17TdWpbMhERg4oA1XzB1a/otQ==
X-Received: by 2002:a05:600c:1992:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-45876656c6fmr76775335e9.33.1753700606059;
        Mon, 28 Jul 2025 04:03:26 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:25 -0700 (PDT)
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
Subject: [RFC v1 10/22] net: reduce indent of struct netdev_queue_mgmt_ops members
Date: Mon, 28 Jul 2025 12:04:14 +0100
Message-ID: <ef22f51fc7a3edc51a68ae6ae8f34c02b63a761f.1753694913.git.asml.silence@gmail.com>
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
index eb3a5ac823e6..070a1150241d 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -151,18 +151,18 @@ void netdev_stat_queue_sum(struct net_device *netdev,
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


