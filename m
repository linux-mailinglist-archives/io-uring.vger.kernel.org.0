Return-Path: <io-uring+bounces-2877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD65E95ABE8
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 116F0B20FF7
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB201C287;
	Thu, 22 Aug 2024 03:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wh0PJVYn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2951B1BC39;
	Thu, 22 Aug 2024 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297427; cv=none; b=TCVfll9rGWb15ZxjioqrfOSzAro1lh03D2hh0YaBrSx23r3ljARV47iwPkEl85ET7PWemoMRMkNVvBdLlqe9JMk8yVKaonnaxlnBdL6GAtLOycmICtjShGDTuSxlE6jMbE2O3PTNSmQwUpSiECBCRCmyjn5ykgMpPbnrp15TsUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297427; c=relaxed/simple;
	bh=RhNYw7mAdhZfgeamA68hm+Y7EGtxUNCyPl9DsESkuk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rouWCqpBm5aF+lh+esTNQPMjFI2zGMMkBjbhN8qNcpf4WmB4TYN8tgEu+m5ZF9DCnHjVc8N4yAwfi2kUXDxX9TKU5unD3Ae+l/ftrFBFtzQ4zDaBjVNDaXhaVjP0gasMPKI6P+KfbZ01BiRRe+M8xylGyzvbupiAZ43v6LfXPzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wh0PJVYn; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3719753d365so132940f8f.2;
        Wed, 21 Aug 2024 20:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297424; x=1724902224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zPiuOc0Ds4TXOsTSymRy71QH64OUPsa/XwqfFqjnNV8=;
        b=Wh0PJVYnpIRIB8buwD8PWeXmEP4tt6ku/3FA9LE3me6gVgFisT+6Zp1zzsoiRYLNlj
         cUC+6/IChyXj+CkKi734jWpuZ8uGpSKu0RMyGtVHFdEpT/ivqxgZZISgD7qKpAY04353
         cJYdKSAmsQW1FELkjCmm85KOhuyBJ8LENoJGaqVma4XL6CF4/bARn+a0M8Ssh/YuODNA
         MSz8ikCIcFAfWAOX90G5e+oZ2HrOsG3ORbQITxRNrSHITuNXGj+echoCZ+u/xCMInXf1
         ZG8Q6X7QB9XYzJ5BvT9VYZG4BbLsZD5bChSASWyzRyj9w3UZ02LlHwH6O3K8BhXKt5U3
         O9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297424; x=1724902224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPiuOc0Ds4TXOsTSymRy71QH64OUPsa/XwqfFqjnNV8=;
        b=cu578m5JpccXNv4Gc5MwGzf0lx9vRlpr8UZUwG4ldV/oeJAl1JOLz5HnHHinsoNSq/
         BbTyBYeF8qYJv3rjPZWNX5oM4e3iw02RGMWMI9t6KqAWFy5O3nQkswjd3l7xIonzYr2P
         fSHow8Y02G+6eVYOuvsT++svMqf+q881RTRNuCpZ2p9OjyUNg5nuytnPU75ZvoJDjntV
         hZy4ac42zgyT3mpxRvbNTk+ba6XPai2ZAhSBgE7evkiqnyDTQTwIaBMVxGDh8E7Y6MIW
         zCcVn2Q55pi1MCOAcOZ/JKek022cLHmO3Uo2rws4NwEPhYsLmySFlybuRj8dEIXi9nDV
         KuMA==
X-Forwarded-Encrypted: i=1; AJvYcCUxZ/AwbUTuu4VsBEhIVTpRXh5fKl8j29Jq2Wy1l0+gbg7Vpg+wq/h9KA54gNGNRAXjy7ijstryV/GbkA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2SSVU1btfDnUODchwpzHNjzXrozoG1JyvR9Z68KFth1bx7WE5
	R3ndk/bbTw6Xlx7T7XvrLio/i9v0UVNOoM5j8L0wZDxR6aYrAvuQvy49oQ==
X-Google-Smtp-Source: AGHT+IHenptdiG4MQzOA4NtwZariaK0Ofl1Vk5xeSTGIEmQVw2fxOjF32uiu08JG3g/Y5jztts0gaA==
X-Received: by 2002:a05:6000:246:b0:371:8cb7:5d6b with SMTP id ffacd0b85a97d-372fd728d5cmr2311120f8f.53.1724297423651;
        Wed, 21 Aug 2024 20:30:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abef81777sm44690655e9.27.2024.08.21.20.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:30:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH liburing 1/1] test/send-zerocopy: test fix datagrams over UDP limit
Date: Thu, 22 Aug 2024 04:30:36 +0100
Message-ID: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 8796974..597ecf1 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -646,7 +646,8 @@ static int test_inet_send(struct io_uring *ring)
 
 				if (!buffers_iov[buf_index].iov_base)
 					continue;
-				if (!tcp && len > 4 * page_sz)
+				/* UDP IPv4 max datagram size is under 64K */
+				if (!tcp && len > (1U << 15))
 					continue;
 
 				conf.buf_index = buf_index;
-- 
2.45.2


