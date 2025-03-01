Return-Path: <io-uring+bounces-6872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 565F3A4A6E4
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2038D7ABC19
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49885234;
	Sat,  1 Mar 2025 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TZRVwYdo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A79B676
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 00:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740788177; cv=none; b=jvsNFlk/VfKGFFwzORfw+AmsTaFR2AJBZTQtgn1LNoHb11LhSEfqhVFmnime9PxSdceoEG5p6lk7OaHRFmcuCwa4vsBkgPOEZXjYX+AGDUKXERmoPM7hZHUEMLDJcvA3PVl+Bq3OmuLIyE9rN5Ob4znBAg4HGEf2KpuAPfy/5n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740788177; c=relaxed/simple;
	bh=gEsO3KSN33JHbOjHTf+tQsfxSg1mhFmpgrI1pGdf+Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cfl/xFIcNWbTW38Gx768RBlsceVxdTaMPUdG2vHpSjfy7YB6bZzz80FelO3a/VnMVU4GWK7eT9ESlD/QbuytqAYxVWdfK/J6taO2ZEL+VFNJxq1vTW1hIu7PqpvyPtsWoQzKWN3bYQIgiivdWqVQtCkAwoY5vPR889+QK92o3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TZRVwYdo; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-22367eba6f5so4644315ad.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 16:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740788174; x=1741392974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQZ71ECrKkWECl6xiI/pDVZ0FP+103ZQTyoLJB/O+Z4=;
        b=TZRVwYdothALMFYxxZa/Evs3/rFbbkU/wa1uWjzrTOUjVgwq17FPVQPzrkTWCAA8Bl
         fpkOPqd3W2aSbJxd9IpD8nWrqHOqEA7Ck1K9wQJOmbUAq5Wt0uCH6PZNcQ95tx4vEjAm
         k+GYwnbO9ql/SVCT8pJ4ZnggFcV5Hvvi4+vi0IbUdnpLbMFLdvXjURDkooiDMFTiHHZ1
         nYEVTzWiwPiet2keQvBlHGyVYd+o7owLipLRw14tUMckM7zpWBrv4XISFgGuUGuSEVww
         0Dnv6AWa2Dagd/IcH1pJUKuoDoycMGFVRJSW3EGIFrkUtWErlriueDZvyB82QwAQ6nDD
         Cflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740788174; x=1741392974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQZ71ECrKkWECl6xiI/pDVZ0FP+103ZQTyoLJB/O+Z4=;
        b=erRUSWDosrA7ev7oiUQyGodoz0iOalZWoQtrwFn99uRrpKM9mIw12FWJ4eswqaObaV
         baprprRNOedUABfLe2lVRh14maF8ezMIPyn2XZQgRot9uFl4kf/NCXQaXwesja47uVKV
         2aL0tvcyWKkRdC8Oh6wvNg32x6kyN5VIEL+lh2uL9ULgdP+F9zyrrOlKtPFxM12goOxK
         9eeeuAzR16raDp4ilomGi/f3Mzg5tBhbC9uzMyEVjoSZuliRXV45AyDtPqsuTrUVOo4L
         w7qSKRmjzGYe/mJy7ZlZv2kZSINlGIBek7nsz+viDXtZ89FtYPu/viqtMglDp2FNlP6L
         YsBg==
X-Forwarded-Encrypted: i=1; AJvYcCX+d0H8x77H+g8wMdC7WT+VSCbMuEmGJOj/dvWk3e4qXLACDMvDc+XiDDGCgnf4uNpYT8lQMTVC9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZJKmVInMkNsS/UkJhcOaSUp00QgjxzAUO/8oN0ayreHp2IWn4
	FysYpV/027beZHnGT5Li42yhdObB/RQ+PYFMxaZkBOaIguAotaJ+zolbR4gsGX9aHbVGcCzLvgo
	lVB6Rb7MTlfQnvQxDhIB3N1wzDY92rohE
X-Gm-Gg: ASbGncttjsXqfDXJHaJQ6WkmaIPhxKr/ziv9T+iw5bFI8khlJOr5hsot3DKjuoqqZLp
	U3qhw0F1x/FPs4QNK0LAoq6dp89CatZaLdCHG2E5mrX/tIw0n4GRYqWE42FMoqAs1+J1m4BtKCz
	N278zCVs8fNdDvpnAD90emz7Gy3PGLgHhkjDRW4Gt2fPRqJdNXt+1fyAgq/EWgQD42a7ZetVapn
	ADkdYMMT39nJ2gLl5VikxZTPLO85qeEa1i6IAqVH/H1OjTGQf97BwRWwBieeFtUTporTYmxPnPl
	+NIr1e2uBGYwn5sX5nnup46s6cK22xOoFn5oxfu7n5k+/D2y
X-Google-Smtp-Source: AGHT+IHm7l5gSAjpuXl6sjpSEETVwb08PP2ae8KBZIblUgIaqAeUNtu1Pov6eYfnSnHcoVeKU6k3kOvp+iND
X-Received: by 2002:aa7:8895:0:b0:730:87b2:e848 with SMTP id d2e1a72fcca58-734ac4a764bmr3123476b3a.5.1740788174093;
        Fri, 28 Feb 2025 16:16:14 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7349fde9edasm289102b3a.8.2025.02.28.16.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 16:16:14 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8BA97340D6A;
	Fri, 28 Feb 2025 17:16:13 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 86D82E419EA; Fri, 28 Feb 2025 17:16:13 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
Date: Fri, 28 Feb 2025 17:16:08 -0700
Message-ID: <20250301001610.678223-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250301001610.678223-1-csander@purestorage.com>
References: <20250301001610.678223-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call io_find_buf_node() to avoid duplicating it in io_nop().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/nop.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index ea539531cb5f..28f06285fdc2 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -59,21 +59,12 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EBADF;
 			goto done;
 		}
 	}
 	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_rsrc_node *node;
-
-		ret = -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-		if (node) {
-			io_req_assign_buf_node(req, node);
-			ret = 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
+		if (!io_find_buf_node(req, issue_flags))
+			ret = -EFAULT;
 	}
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, nop->result, 0);
-- 
2.45.2


