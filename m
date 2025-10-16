Return-Path: <io-uring+bounces-10038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24281BE3ABB
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44CEF19A2043
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3688E1E5B73;
	Thu, 16 Oct 2025 13:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSuK9y5f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF12DA773
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620937; cv=none; b=K7tIjbJqzoX9GOcERxuLXt0WAfN+ZCeDRJUW4kS6iVfxfKnczJ9renO4vBHAoTItpFUMvsEIHdDH36bgarygrU7QJVB9MAcxz3c/6sTsESqyIgLYWMra33R1vVuewoKHsl8lbFseJiFi/awmsy2z5jpt2oRRg6kwEIOrwKYRn20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620937; c=relaxed/simple;
	bh=zorgn6fjaqSwinh3bAdJSzX62ATby256M5FihNw6R1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVzgrtCy2nwmKeSNF+qedME96umR5zUsdRuh+fjfpVLHISMCRNa3E+pEX4JBmrwy9bq9UslXMzSOT+f6SJkdMILvzq9cfs+yuRA6+olc3SYGMuVpgtfc1kPBVy0U40sojMaMFstpJN4gBdvzepv55l9Jtx/xcDHSiNj7KkecbQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSuK9y5f; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso328328f8f.2
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620932; x=1761225732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrCstFOJDy3Czkh1Bq3LRClu3CWh9iM0tUvmZwDslRE=;
        b=GSuK9y5f9VY8WBf2x6fBmrMNOUnfDQA8QInawzKrtwELL9mEizKdLz2lv8EuJsSuij
         EO06j9rebkyl5qWH/uGE8WW0Bk/6MkGlItbXLqGe7ZArg7pJDdceuGW/aXuD3k/Ota1O
         6GTi9k987s7SX3nSGNnU4VOIPrr2HyWM1xNGVKVgMatltIf1fRx7UZXA+zv1PAEmuZdJ
         BrchgRdx1cUW/4mj2Ay4t1bcI7CTJeo4hxyjTnhv4oFrTdfgjGku4KaLme27LwjtBk74
         Z3J0X808+HuVUdPtI+7dicG6M8/ZrOjMSWcHj3oHLlMYwqH4tbsOVpREpizXNhkjzxGK
         R1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620932; x=1761225732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrCstFOJDy3Czkh1Bq3LRClu3CWh9iM0tUvmZwDslRE=;
        b=KVsBRH2/s9FzmKVY8eN1HJMBpJd694rAY/shRsUAtp4jHdiIUV50g9VFWu+n/+GCVv
         TsiXjJdLZUMob5gsuD5OVP6dn8Azg42g/bUMmB8uw96FNX8+zAwolRPEre9fGG30MqvO
         vst8Ro8orlxahcEZC3wtfNhFlm/4BxjFdlVja71Xar0+6yNtn2bAu9dkN7+KdzcnJBGr
         9VSdo4DlzcXsQNluGi/58poRDemI7TOhDGot/uERDK+W3+SR+dhrn6oeprRImdkXmb7z
         V0fohbrQbFGyTDqcBY+dJkOMFbOSxWnH6gRV5i5r3OJDJG3azhsM6C8nxYwwR3LGVcn3
         rYvg==
X-Gm-Message-State: AOJu0YzW19PIgFxrlk+IG/j3wKFlj/8vLoXqUfSkQqr3zxVKK21EeliL
	W2I7QaHfO50X/UoLDtxu+ZJQiPzMqB47n+udPX9URwKDUmbgfW5BP2TrlKKMUg==
X-Gm-Gg: ASbGncs35KuacKmw9VxlPoMO4+Oo9iFpY9Oh6NGqrxaO39PMmwYlHXASaBaARY+CbTk
	FhT1NfEq1EwbqkF3fYRXR0hrD0/NRhzn27WcnpNI7E/ZljzXSjysQI/d/FHqfJ2Xu0X1SABhp+F
	3lU5lzkOKCVDxqvb+8dPFzhHiqcbgi3R9DNbgGi2tdFEl34Iw+v9KzDgz3dRSWJ3zQXFVk4klPy
	Mdb/tPQrCndEekG1IoDjDW5HomAMvdifnBaA3JA8ZguCtss05F5RUx48+l7xP8/V7ZKRzinIRuT
	9+831BasDxuMSfzJGZB9QnwaSkFUJKnFBTAl7U9XaO9FSQyt650Y/YNpFsZNUdPDCAEYlzi03yR
	a1uAMZ6WctBsdU16P2q6lcWGUSwUSyuat1gvF/3bxl7t1cCOOQfWxw6P7Zx0=
X-Google-Smtp-Source: AGHT+IEz+3q9HlBqb6OWQc10m1RorMqobtkpLldqCIM97J0izMDZhpw1+wBthX+lWBG3NxuaQrWOng==
X-Received: by 2002:a05:6000:26c2:b0:425:8bff:69fe with SMTP id ffacd0b85a97d-42704dae2bdmr49213f8f.57.1760620932172;
        Thu, 16 Oct 2025 06:22:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring/kbuf: use io_create_region for kbuf creation
Date: Thu, 16 Oct 2025 14:23:22 +0100
Message-ID: <7caecfaa8688b75cb916425d9bb8b0b5138c87b0.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kbuf ring is published by io_buffer_add_list(), which correctly protects
with mmap_lock, there is no need to use io_create_region_mmap_safe()
before as the region is not yet exposed to the userspace via mmap.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index aad655e38672..e271b44ff73e 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -630,7 +630,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		rd.user_addr = reg.ring_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
-	ret = io_create_region_mmap_safe(ctx, &bl->region, &rd, mmap_offset);
+	ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
 	if (ret)
 		goto fail;
 	br = io_region_get_ptr(&bl->region);
-- 
2.49.0


