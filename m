Return-Path: <io-uring+bounces-11790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE85ED38A2F
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A9313029FA0
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E6E1FE44A;
	Fri, 16 Jan 2026 23:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgO7Ptdx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BC723B61E
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606304; cv=none; b=Z0MijKJvYO6c5yx2Glj/EX6qCQoXxFZTdWQ2JBfA03oIe6n3eZHeW1Fw8KA7IOdyXbZXYJjHAmq1inw9AV36B03voVr+0c8cxSyxWqvO+vKbAXG2fuuN73nbfAPrkN4YfMq22/lLmUEgyhBkJfILucp+DiQQn6wAG1SR58AQASE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606304; c=relaxed/simple;
	bh=ivPoUzroIpJRQA5fNd8bgoKTlK1sllAkVv2Qkjs1H6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao2W62H3yLNEOcWMeE58WwlJTQwMqMCLqAOgt2Ota1+9JjJV9geYprFah8NRwn12peh9zOkx4Kxh54GM8OEzqa1vjq+C9MYBt5BVSeLh5nB+YiXzHubzHSESM4kpeHB7Om6XctDgk98y08gZtPZx9VIccgrec66oMV355BYoBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgO7Ptdx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0833b5aeeso25008375ad.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606303; x=1769211103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F455casoetTzeH6TRK8x9XB97xDajVMprk+C0lM7aq4=;
        b=RgO7PtdxPn37gga7fbBjCDBRjuAtknoUBm6ekx66L223uyT5gN9S61Zwg000f2KKhu
         DVsU21cVeWmqyHa88mVUKs32YQ2Xxx98Cb0IUve9P6Nlnn0xt3kfun4xVn+6NzMbrCkX
         7GNE0pDDTy9tKcncAR74q3kUeuuTiQlZqdEJoEBYOlIp19Ka1auaJt4AYaHVRzzAJXag
         pUlTAVqOoQuxCIY9167hoc97W+TAHzzcomXXcCu82xfev5OZk2aiZLH7Oxtwh+3PX2Fb
         f9LfYqSCdV70Qtj+roNs2vhkyx8IEISyUP7mHBFr1JuFwXRjHTRcKYXouN5VDh/3/sXV
         1pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606303; x=1769211103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F455casoetTzeH6TRK8x9XB97xDajVMprk+C0lM7aq4=;
        b=LvlMBhSRLFzdyAqX5qL9n6n2PLAs4LPNxtLFJV4kSOjxqei65TT114U36SMmMMQB6T
         e9qprAHsMlmIPfwlKtZDfKuYmPhFh8xXT2tBl7tHzv7eYxrdbbBQVGbXpmq1osdUUryJ
         c2IBl41RvdVgJPGfvNdQYQ1WoE23jdAAPyHLjcwfsNp3CuzEQGI6CIqWpM/TRZ1LuwUM
         8PvdXOAKAVu5dmB6O/OhzM2iZBdXbquvaOsUEwiSAeFLfttVHatVk+vmVv5XwIAJ1Knb
         OkbHfKvtWLng5lwT8/aY+urLuncu64NkabROD05cE979yss+xIwE713gIRlzJz1uQT9x
         n0Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXudiHH02x6ygZWNm5meI3ohl7EW8aLr/CKOUudN9Z0zkPnlcow+PsPVUqTovt+Ki80zhoIgwU7Kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxfmsTkGi3BF+1qN/z4pGEMWN20eRE7ueQxhbAnVfhhrEburIW
	UO3weGIyEMF0Kn2Jc3cwaZmMc4Js670QvScj0afsCocGvp47MZPoKYK5
X-Gm-Gg: AY/fxX5/nz0KdcEV5J1wFNkxWia/uRsg0AO/XMva3owne9+aUnVvN23fd1vCP9NuKpl
	yuNHm1H1qGeo2GWnz10WRzX3yltPLRlqfj0dRm6zVUOy9QF1uDuF4+ywTL0nl9btZZU363BcFhK
	h4M3ksJ5gBdxkF/Mvl83Sosu7JiW+3f4eO83swhOqvbhH3KGZrtYcd0HlyjdfnNoFNslgkqUq0B
	6aPm2WFSVf4D5bVg+s6qxvQxo+ZfzRzqyxO4Tv8yAHAdfFra4v3s8Oys7CjGUbI0BoQbFsxn8+h
	PfAQAZ5fVWrOZkNxObGE8/XnCHGtAOHifH/iL4gA8+aER2/8shTc+XUEfb5AfePsEXSbl7VWB0e
	6vzxbTX90C7IBmU0hVtB+GKR9MpEYl0F6fBRMkCQwmgGwIbVaL3H+fJRIId5dhpCiQ2WN4YP1uG
	y7kRjnECrEnn6TE1U=
X-Received: by 2002:a17:902:f545:b0:29d:7a96:7ba1 with SMTP id d9443c01a7336-2a718918720mr42646925ad.46.1768606303043;
        Fri, 16 Jan 2026 15:31:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:a::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190ab910sm30225005ad.6.2026.01.16.15.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:42 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 22/25] io_uring/rsrc: Allow buffer release callback to be optional
Date: Fri, 16 Jan 2026 15:30:41 -0800
Message-ID: <20260116233044.1532965-23-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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
index 63ddadca116b..dc43aab0f019 100644
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


