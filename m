Return-Path: <io-uring+bounces-10825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EDAC90240
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D2E43A9F35
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487843161BD;
	Thu, 27 Nov 2025 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUPfxoq0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0EB314B7F
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276274; cv=none; b=s0bZ/RtBDI3XcWgQk0Kdg19qUtW7+yw6YgWpfhWDaQxH5/7G8F9AJUpYrl6jCVlWdG7e1XrvtbTDUyLRAOZ/eted00GTZ6Wi/uRfOZSKGO8U5GehXLO4QYLgflwvYDEtnzNb9ZYm78tVQ5ac9JJEVfZl4An+FLRUZegZS5+Ppkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276274; c=relaxed/simple;
	bh=wKLX50upMBXTkaYsn5OUPjFxWSff+rFLBPN8t4x3gXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzKQcr51NO+jVoEOHsezmtodOqv8TnbmEBIKjZnfz63tMR57NXGFPF/EcpY3S+abOPFwRpFOibcTSySJ55FRCON7mLuiwcu0hiGyMLfoNh7Yv0kccilECBLTSXXRL0XIcRnuNc/7HfcS/NKlFM+hRygz+rCKIfvUgoc1dOkRJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUPfxoq0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477770019e4so9406675e9.3
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276271; x=1764881071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqckiZGHf3bNG1zTutRGSVS8PaQ4OMxeAJnwQy2/Q0I=;
        b=aUPfxoq0Hio5ZQS2G2fSjo0D2AbYa5RAD/3sviTaZmeuhfDe4kUhhkqG2F9uicqq0T
         8NM/Iw5A++YZYbDOWzRar66j0C11LjMgtJQF7Dr5fk1sihqoS+x+sa3pvL9OeooNkjq7
         KrYdJIji7Lnlis05CvAHPwGc33gcPaQFQmFnwH5+zLPNn5KYaumjEHhuj4TqR6GZeilF
         a2i7co6DnN73ELuYq1t1Tdl9td/uKBKv3Ggw3Oe6Cfv+n5nxpVI/CpOmzwBx9XMxr2O9
         V0o5xHOiytQhzFticuvKM+PxRrxyhK1ykMRjt0+y7fkSOZcr6gq1zdHtYoW0onuSX8wI
         iyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276271; x=1764881071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QqckiZGHf3bNG1zTutRGSVS8PaQ4OMxeAJnwQy2/Q0I=;
        b=CfQkwchNaMHY1GyWvAXSA6gA6A+t0mpIK4EXBThuH5GLVwUGFmmFGQDe0h/sP1ZI1q
         4ev/i2O6iuDXSP1J1YbUB3ykKehGmZr2H4viYc9WzgZO+O8wHlmIz4W2CgT0kc0XsUA5
         dY0Q0KMhngBIVOVgBZc0GMlUU5Cje7tuSbXj4PgAfs+xqlUqL/EI7WJqr5ubiLz+82Ac
         UGKTs3dg2A3YavvmNOAPFvzG1legY78mQHdI7NtprVWUPjucsRTdb8Ojm4Yab2qmpRbL
         lmXtpz72Hz0vN0Uv2ydF9W1PLjnVH8JTmabcSs/fKxonbKJFyCqmOJro1azA3oBqO9AY
         GX7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUp/iqassl78heSB9StbGdl6yqF+wpkIb6d/W9469SeLCt3NvwLLBY2dWuINVFE9BvFrc1qI9iDgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfTwTXD6XXJLKK8sW4Uywvs7hJ9Wn11XrPnH7fjHW7fuJZB1JD
	AbgHECFEN5MVxp6NN6O5L3Qfu4AevIu/Lx3Gllgx2EJFy76iVyJrP+/5
X-Gm-Gg: ASbGnctYm4RnsqQidf+Ye1+WfgqGJkhtFr8Q8Va+JhMfZnKfE4itoW4TWQuV/mkjL1c
	Isxbtum9AXP79xkp6qQP+UY3fXoVeGEktCliHe+8pu5ERjEPINVw8uO/DcUZ1FoF2C913Lq7kaK
	cwwnsOnd9dzwLigceo+OciY/IhUBnjNKnRpJw/NBsrm8f6jQVGXhQBpxFiLTr/xp4oblZXiRIQ0
	DW9XuoN6oXxNmP1kcpRXYs2VCyF2ECXokYYBfJ9fVf+9cbM3dI32ixIH0EoDa5fYQ75ra/lVP+U
	heg7VC3FVw3aUnr5lrr7noJkFpRjEYDjebDjmm6AsnyyY3ooWOmustyAceBiY+ABWPlCGSipw27
	1suozC5Y0WH+lc8i7ZEDc9HhRTr0ZhSfCt0Ilavttdp1MYc8a6gQr5HoO5tg6HxzmSvr6f6BzU3
	6wn0AvJSCvMBrN0Wisa9Rhnd0g
X-Google-Smtp-Source: AGHT+IG8xP4HJO4DnqjJPYdufQcB54g2uija30UcXEQTiQoRe6u8ZY63WY3zQ9RB9/Vh8e5LOItojw==
X-Received: by 2002:a05:6000:2c0c:b0:42b:2c61:86f1 with SMTP id ffacd0b85a97d-42e0f34a082mr13136672f8f.35.1764276270574;
        Thu, 27 Nov 2025 12:44:30 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:29 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH net-next v6 1/8] net: page_pool: sanitise allocation order
Date: Thu, 27 Nov 2025 20:44:14 +0000
Message-ID: <337ee90a6464e9b9ab09d1850fd9aedcb0e13679.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764264798.git.asml.silence@gmail.com>
References: <cover.1764264798.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're going to give more control over rx buffer sizes to user space, and
since we can't always rely on driver validation, let's sanitise it in
page_pool_init() as well. Note that we only need to reject over
MAX_PAGE_ORDER allocations for normal page pools, as current memory
providers don't need to use the buddy allocator and must check the order
on init.i

Suggested-by: Stanislav Fomichev <stfomichev@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..635c77e8050b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -301,6 +301,9 @@ static int page_pool_init(struct page_pool *pool,
 		}
 
 		static_branch_inc(&page_pool_mem_providers);
+	} else if (pool->p.order > MAX_PAGE_ORDER) {
+		err = -EINVAL;
+		goto free_ptr_ring;
 	}
 
 	return 0;
-- 
2.52.0


