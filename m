Return-Path: <io-uring+bounces-229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B076380545C
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 13:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7A0A1C20B9B
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 12:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FBE3C48D;
	Tue,  5 Dec 2023 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BA/GDjsT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E14D5A
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 04:37:22 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40c09f4bea8so23436895e9.1
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 04:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701779841; x=1702384641; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEQ0nPJK2l6MEItIcOUo+Cj1aUU6b9K1G/w+FexHPQM=;
        b=BA/GDjsTIHpykQtRNDowRNmaQIXe2g0tGNJL54hfknz0eL9S2PfnNQTruDPPjnBO70
         kEd3d7lgJh6Al8YKhCdoF0Cb8Ah2Ue+7QzO5nzlBy8P1ly91C9ApOnLwt6vVIEPBDUG9
         6O+OD5Qf0hnRwKMVdVt3HmJpY66TUonkjFYJ9koHk5R7LUgEquR79GDZ5AWyWYt6whzm
         1wGHhpsbs9CcrgSHKPmiSbVobu5cU0qflq1sKmkhmpkgpRhcuo0oKEw9sPstV9FU9ety
         0wKNtu9JpcGcaeoFBWlhcjv+9mcVBGMHXIIXvpvWUkqxO1VSGgkzfAGYIFYiT1SN5rFQ
         M5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701779841; x=1702384641;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEQ0nPJK2l6MEItIcOUo+Cj1aUU6b9K1G/w+FexHPQM=;
        b=cR8t8gqDTxddiEiLwTlZ/oLYXXMGs2DWBqEz8/EaGpIyoX1/3+wnoUI912oU2t6XAa
         minoe9PnhR7I7vcrzMjE3m5OVKedVqG5dkWKuCYs1fmvSHIAjnHCTRK3ELNFV+PPC6f7
         MNXa+ykAXYf8UkTHrhKPIfECI1s7LuEcVLoYrMe0pkJys8QLk3perTIX1eWzRC4Z9x4m
         GLbprk9Q4ZJDiKwAcEDSilnbX+cmdadpBaEhcekAIVweZQwTu21ovHH+mAApEFxZbS9q
         tansEdbwL3agLIO6NSQMF50L+rvtCpVMw1QZ2o6Iqj+eCiK8bzmH5CiRX65IGUm0ggI9
         uZwg==
X-Gm-Message-State: AOJu0YwvEYwpysYWIRO2UtPUioXKYp+IiSEUIxTsoqf7k12lylZWcqWW
	W3GcoI/h4GArpffFeKiN1uyRIQ==
X-Google-Smtp-Source: AGHT+IHGwMratcq3hVnhryBa3837VxHeTKKs/Jd/i8LMX25Dk+Chk0tB18TP0Xcjd5ROraLCl/4gNQ==
X-Received: by 2002:a05:600c:2199:b0:40b:5e21:e281 with SMTP id e25-20020a05600c219900b0040b5e21e281mr375751wme.110.1701779840967;
        Tue, 05 Dec 2023 04:37:20 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c350600b0040b43da0bbasm18511650wmq.30.2023.12.05.04.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 04:37:20 -0800 (PST)
Date: Tue, 5 Dec 2023 15:37:17 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring/kbuf: Fix an NULL vs IS_ERR() bug in
 io_alloc_pbuf_ring()
Message-ID: <5ed268d3-a997-4f64-bd71-47faa92101ab@moroto.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The io_mem_alloc() function returns error pointers, not NULL.  Update
the check accordingly.

Fixes: b10b73c102a2 ("io_uring/kbuf: recycle freed mapped buffer ring entries")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 268788305b61..bd25bc2deeaf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -636,8 +636,8 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	ibf = io_lookup_buf_free_entry(ctx, ring_size);
 	if (!ibf) {
 		ptr = io_mem_alloc(ring_size);
-		if (!ptr)
-			return -ENOMEM;
+		if (IS_ERR(ptr))
+			return PTR_ERR(ptr);
 
 		/* Allocate and store deferred free entry */
 		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
-- 
2.42.0


