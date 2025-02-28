Return-Path: <io-uring+bounces-6871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50609A4A6CA
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95CFD3BC523
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9221DF74F;
	Fri, 28 Feb 2025 23:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bbYcnhvh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com [209.85.221.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3092B1DFE3D
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740787198; cv=none; b=RA05Z0MNnxN/5ykcjmM66sthfuWdu+1y4hWSk38l1BqGkL8LMeAayYL1pg8JpQbUuuGh6duh1OENLpvIAGSqH4WiDskkVJXt83iy4KEnpBfYankvRBPW9fquPtEuqcZP6vazYs3bLx9Se4MHWP5W2aJN1g+vpw29RNCVZGf8NCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740787198; c=relaxed/simple;
	bh=GqEhJOiyYXdr8rGQugNrCU6kawK92vTYNv4q8/6+xKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqN3b3UxbwIjTu9fYFn1sN+N/pSYSIZd6sJXPMo4HXsvrGDWjpVGwGqdGUO8CWgRy5CduMTgFqlzaiJeX0R/9pCJqM4U/XxEm22+M2gMB55YqRNe0A1/dY0HrxOATUMW56D0UG+1LPS1hOAndLCKWovDRf+uxHDSjYDb5PSRdOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bbYcnhvh; arc=none smtp.client-ip=209.85.221.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vk1-f228.google.com with SMTP id 71dfb90a1353d-523610d834eso22705e0c.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740787196; x=1741391996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqbUgsOP74rQAaYypSD/gLbYz0cVUXhGZfBogbxaru4=;
        b=bbYcnhvhpzE+esEVp0I7U0EDjNqvwDySuY0XTWgXlYJxrCawT3hYpHiWdN95RxL2U9
         e6bKZnoOIZ4QzUeJeOmo0nu2YxcFQjAkmNNnmlcrxsVhiRV1NzmvjW8NgD2AIefJR85g
         JJn+ZG6Om1SHOKuFlHgkd0syQBxv29Av2V8hfBVUTHgMOY0zP3CU1L9DpxHAtPOp3JfL
         I+CdouGPDKU/kuQkm6c0zxgF3MGtt0gwQQL9IZ0NRV/rGno/hyECfFl/fewzhDCgCMx+
         jzxpgMItWzgOLV4LHY/DjJuhTp31b14C7G1A1yNDD4CYA9FaD5rQVuUnNFqI1815YRS2
         jULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740787196; x=1741391996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqbUgsOP74rQAaYypSD/gLbYz0cVUXhGZfBogbxaru4=;
        b=kfgdcURDEQzUMGbQke/AA4MQAYN/GudK39vXL0vcgmJTFbfIKp/sbAYfROsa0/hl1o
         dai4rFZwckmdOgeCXr/soxAlIBdL7Gw8iIpTmXH5lvaD/o6PpIRsLSGl4ZSVE9QH51Td
         Yzmmg6ay+HpvDRO9oWXhI6w7mdsfqy5dVOd2Kq7LLpvdVR4rom0ZbLOUCqjxqnmu1RwH
         dAPBnXhBkdBRj0ApebY0DrHczBjDykngHHtxopPljiUcnaekESiqEuORodQk3wRWqzIF
         hQEUpjMRJQmkGKNh5M5W6XAOE8XeeesCFOJkDuAMoo6l3ySY7maK/ifHIRx2WAOCG6Ks
         LI8w==
X-Forwarded-Encrypted: i=1; AJvYcCWu69k0shh01AL+KOnpnIR5Alf3p1/98njpYNn9tcX7s8wvGCeXZy8PvqBwuEFrnnm+4kaYQsbqcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjeEDA+SgMDCv8yp1lFH94fMeB5H/tuRmJN6WM1QhP/MbwbPTi
	fUeb8U5wAMD0wgkNHnA51QZQf2PhKIrSbpQ7Dxk9ar9gWfHH8UAq4dUHrqI/CDtIEe73FRQLUiq
	uibag/8f6tKlWsvu6wrRjSYwJ7xImfPCuP6HfIxa7YPStZrZF
X-Gm-Gg: ASbGncvjuknkHcqN8WYwlHc+YMqkTLlW5jh/pe01zwBmyXj94EHDlQGe7GuUVWvlET0
	Uv/KjpAo4rVmlCmZXhtrDdF9VH1xcv1fc+SrJ4D0/myVn+toZkFIqP/70tpKAdsZN6Vy3KRCNa9
	9nSHDFRvpObBDMJKyYCk7h61GPMgv6Vwe1sl2xVoVknFaLxwb7n8jiIYAyIddVWTYQtYSqX0/3B
	tKAs3rTvB2C2K2GDn+2ELVAnf79dGDTuyB7xk6J6URDZ3kfrk8oSetfquKG6KB98SOIFBJ8HG2g
	+UbBGTYndVcvcYYH5pP+hzB8FmqvpLJvYA==
X-Google-Smtp-Source: AGHT+IGRBEGoIDXj6ALCnhETDFnXCj12VARjJtS72JzhHgZ8tigxOcRZZIHSTkQ218vW8h9TJLZxg4EO/5ga
X-Received: by 2002:a05:6122:1b8d:b0:520:579d:893c with SMTP id 71dfb90a1353d-5235b64757dmr1239548e0c.1.1740787195935;
        Fri, 28 Feb 2025 15:59:55 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5234bec414fsm230393e0c.2.2025.02.28.15.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:59:55 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 6B12334028F;
	Fri, 28 Feb 2025 16:59:54 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 5C474E41A01; Fri, 28 Feb 2025 16:59:24 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring/rsrc: call io_free_node() on io_sqe_buffer_register() failure
Date: Fri, 28 Feb 2025 16:59:12 -0700
Message-ID: <20250228235916.670437-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250228235916.670437-1-csander@purestorage.com>
References: <20250228235916.670437-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_sqe_buffer_register() currently calls io_put_rsrc_node() if it fails
to fully set up the io_rsrc_node. io_put_rsrc_node() is more involved
than necessary, since we already know the reference count will reach 0
and no io_mapped_ubuf has been attached to the node yet.

So just call io_free_node() to release the node's memory. This also
avoids the need to temporarily set the node's buf pointer to NULL.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 748a09cfaeaa..398c6f427bcc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -780,11 +780,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return NULL;
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
-	node->buf = NULL;
 
 	ret = -ENOMEM;
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
 				&nr_pages);
 	if (IS_ERR(pages)) {
@@ -837,11 +836,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 done:
 	if (ret) {
 		if (imu)
 			io_free_imu(ctx, imu);
 		if (node)
-			io_put_rsrc_node(ctx, node);
+			io_free_node(ctx, node);
 		node = ERR_PTR(ret);
 	}
 	kvfree(pages);
 	return node;
 }
-- 
2.45.2


