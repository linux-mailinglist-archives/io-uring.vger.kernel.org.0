Return-Path: <io-uring+bounces-11202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 40339CCAF5C
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7075C302F39E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37C8334C11;
	Thu, 18 Dec 2025 08:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5sIS/vk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51163335069
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046911; cv=none; b=QVT3Kqm/jgbqmUhcwP50dDHvew8TLG5m6rA65t7KQU7DWpwLqDXSeze8Mxo3NzLxulCIV0pURWGlN9THrSQmFR49bKrTJFq6voSuJuO2UE1Fd2/YY7AU+Wf0Ef3L7ql4+rrQyuWM6b0+UgtorV74VuiCzVXZx56g1mUNG9q0+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046911; c=relaxed/simple;
	bh=UvxGykMLagJodFF82NAYTU28hUSWK6gDUTcLTRmQJ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfZwOME2PJzSyy0b1QzmYq/O05YLTcBdRn+t5n0z0Kz+A2/tt9qagThXOm6jkL4Hiejh/CcnZiwdTT9ywdrb5Oe5LSKCf9ulmFJ0EjD+EdMP3ogRGaw1oGB+Op5c4z6SVBBNMxmHSRdkWKSyZVKQDPFQm9MzV55huOeZKiMkANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5sIS/vk; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34e730f5fefso400740a91.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046910; x=1766651710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMsOqo9v937yP4fh4eba7UqfVJcPSIWogxrx4HYNtHk=;
        b=H5sIS/vk7fKBT6BoN1/ZbMSzMy5UijTRCtsUA5/0DQQapwJC7rgc+juWjlp6Jr2V12
         KZIEDxZPLlrOHLlu3bCE5H6m7j/XRXPJ04kP/RYnpwtwFsXdVae6mpPfFhCMfQHlI/B8
         dHyr0EMZFta1t7l34FsVWcGbEOE8hkst2gX1XSX7G8Q9lF/lkIZHSQgYya+DRG+DnrLW
         9v59Xv88k6OaiwVI/UIrl0NMv4d1MUBzJh2P4PfRKfUMdhZWp0KuYtF1qAn34FIVwk0N
         5YJJ6N1+dj9p3A2zwU1OMMxPpi4KZv/JRqAB6btv01ZXI2mWX72mFQHvcIAtO90tGxaj
         QwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046910; x=1766651710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jMsOqo9v937yP4fh4eba7UqfVJcPSIWogxrx4HYNtHk=;
        b=Zml/dNOlzL2fFhwbFdC2bo6L0R+QM83ZYf049sjRoW3A/MtUN1iOYOpj5kdIy4qDFx
         BCvI94SaqWkQU7cYdyeuV94pkTAhyjy13YI+/wDsm2+zZ/kv2+BTSPLb9KhtleUHgTaj
         p/vLxhL0YSKJWsAGzN1o/2vHSSwKYaqF0+x3r+3wL4HyYfQB3vedB4vBls/ENpFGYIWr
         gCprW+eRrd5f30jxwNSkG1nPKqrUfF6YCUE+ECEGRQSy/5Ir+PazUr6aNYSL8snLHNUe
         1C7rr13R8E9ioOtTKInMpbCXN2N6XufhPbsmavzj9dh6mkiyvYoAD8rjirj58UReIU/q
         dg4w==
X-Forwarded-Encrypted: i=1; AJvYcCV2RGN9d8A+JXyh/fUbKGs89+xN/CHf0iBH4NW+e+6GjGz3phxnf7S1LSts0rNW2LwfphDkOyx0EA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc3BULUfAjdnyQ+R58kAN4+NWAnkvW0qf3eMsjNqHpNZ5W/qM3
	SwqFSQFs0dbgGufKIWraQ2UAWdqAR9YTTKdUcbdELG2uXiac65nT4UTy
X-Gm-Gg: AY/fxX4MLJedq4DFcP1vVJsTyU2+uJCfSv7NYN/dRZ6obIcFW2VpJr8jfvpHvNri3mW
	W1sxCDio9KQeR6azB+GDuq0QRwZTybqYUoR+3Be7SQCWUTM4I0aGIVSqlIMoA2ZN14hkBHyiL/0
	PlCvdTxkLfMgafMGYxNwBb0e3ckjxzq7dhwqNKeZOlPPuhxVwGD3m9AkHn9oicyC10XGnf0SHJD
	ZO6zwjnOMLi27BzjeKtU1cl6/3ngxZ49UQZSO5KgSpN3YR5Rqti6tE8VSOHFlreNk8BW5+Vytc9
	yZqgku97aGWCm39eYEMlYjGB/wfyY1dsi5K/8pUlEYIJJWETVZtzZtph8VMZI4XagivZ1FpzJq1
	7vT2CT5hx5ccPIoBfjGss+N8qYc5Zb2NvTY1IL53xvJb+tsgA4FerNaz9lCvSPWWmgH3RMF1n7e
	BTygxycZ44q5cvFFcesw==
X-Google-Smtp-Source: AGHT+IGNysnUgud81zg6tiqMjIi3MWubotdaZNNwAn2aMcMHx7UXWf6+Er75NM3gN3rjaJs+wBtmjA==
X-Received: by 2002:a17:90b:2e0c:b0:340:ff89:8b62 with SMTP id 98e67ed59e1d1-34abd78fbedmr17591453a91.21.1766046909601;
        Thu, 18 Dec 2025 00:35:09 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e7454653bsm1609107a91.8.2025.12.18.00.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:09 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 22/25] io_uring/rsrc: Allow buffer release callback to be optional
Date: Thu, 18 Dec 2025 00:33:16 -0800
Message-ID: <20251218083319.3485503-23-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which does not need a release callback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5fe2695dafb6..5a708cecba4a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -148,7 +148,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	imu->release(imu->priv);
+	if (imu->release)
+		imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
 
-- 
2.47.3


