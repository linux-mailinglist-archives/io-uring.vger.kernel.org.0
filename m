Return-Path: <io-uring+bounces-2528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FDB935272
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 22:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77C091F21486
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 20:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484D914535E;
	Thu, 18 Jul 2024 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JeZcHuXx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A9143C54
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721334873; cv=none; b=ISwXA4izk2COfnVnZAGbFfreSLwyDKuZqGG+yZTvR4tHpQvFIXlzbeT25frkhEKbWq/rwW+6M8rLpyFRU0JENb5df8vBWzyfr2Vbhozi4jQYp9FTDV/rj28z7n4AkR+D4hSYOeuh5pA5TiYlYTZRmm2IrxW+gPVW9hX08E33xes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721334873; c=relaxed/simple;
	bh=Ge0nsfGaoFWUvhKdmryL28ecrQxryg/WyfceosiSjbY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VR01roul8rVvuMtpJh/KwtxeDXLN2Q33vNzgMiq7ZDsFnWUTY03IzJFdUQcR2SaZxQOKKApSGtQarISeXnjdouijq0C7eZq7zoysT+piWknWYPD42gjVi66LHwRuUAerMYcY2agePf1aIvVx0PG4nv3TiB7E5DDPt4nwFjp/Evg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JeZcHuXx; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cb4c2d13a0so97891a91.0
        for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 13:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721334868; x=1721939668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29mnQccpFxSM5ONmvazGHRmcTIOZ+EV3gJcumeRhhho=;
        b=JeZcHuXx42qBKmxiFwJOES4IZDXO1pdyIDHDzwnGp2Gx1HWddvBkoCJcBo7Ybgi+sZ
         UmtBIdkCHJW1j+cAexhL57QeKFGrpa77gxnC11Ja+U90ta7o5chqLHP5jKsijEVAu2UO
         +0BiL1NwDoFEbI0kXM/sVn1tDA8tp4nWkqbG2Owb1brjgFOtQJWHolnZmq8aUuJxJyKh
         kbjcDKwvECeKrehQ1nlfsy2h2dbCP3f8YjRTi9+pgZH17H/SrWWEplr7w+nvXgaUv5Hs
         QHfJfcYX6IZ/U5g3gP3Blwcwml+ptPea4yRYOoYjHEgyTMi+6GhMO1KRaEz1fxTEO95v
         N3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721334868; x=1721939668;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29mnQccpFxSM5ONmvazGHRmcTIOZ+EV3gJcumeRhhho=;
        b=IS+n25RdRQ0adm3AWoNWmkRpu7t5rEO6gs2CHxq2h/WkKMP14IvJArlyK+pdUgwvIt
         qXiSDK/OpcDtm/4u2R32Y2PmIr6eAXUu/33gyCLMVAZnj8tT6rbwPO716RFJRuxnAjiW
         MNooZM+jmRooyXXc7sYsD0VEqI4/tPXRwJLY82CSiLIhkNGZk7cSNFhmTGJrxXOqx9sw
         /tnkXcJmKNSKxL459h4DIOKjb9X1wHKFulMMb/YuPdBgG6DMsH843VhmMjhbKX/8rjG2
         4Ui5upx1Jm2g8/+N4zn8GDS/yInukgwVEU4i/+lJo638YVcnRIFFOfv1lqu4zdBbxePJ
         mEJg==
X-Gm-Message-State: AOJu0YweNAcBi85V/jKM3SQ0I/W9OOwRMdyzWYizrJJB8ghII8KcPdlB
	tyTaumxpLTc0U70FyWS2NCCo2y5UFakIkYnRvx2gw3H0U4e7hFfy8RHiIY+RpfLbN9a23w6H+lT
	jofWvmg==
X-Google-Smtp-Source: AGHT+IFd/+2E+bgLSRPz+VgAOwHbxyl11PgHavCMy7n0qjjll1LevaJEWhzSU8v/aHwKIfUkV8+BHw==
X-Received: by 2002:a17:90b:1e0c:b0:2c9:9f50:466f with SMTP id 98e67ed59e1d1-2ccef6ab13bmr543258a91.2.1721334868462;
        Thu, 18 Jul 2024 13:34:28 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf7b30f35sm37236a91.11.2024.07.18.13.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 13:34:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Breno Leitao <leitao@debian.org>
In-Reply-To: <ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com>
References: <ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix lost getsockopt completions
Message-Id: <172133486720.46273.6648440231001293393.b4-ty@kernel.dk>
Date: Thu, 18 Jul 2024 14:34:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Tue, 16 Jul 2024 19:05:46 +0100, Pavel Begunkov wrote:
> There is a report that iowq executed getsockopt never completes. The
> reason being that io_uring_cmd_sock() can return a positive result, and
> io_uring_cmd() propagates it back to core io_uring, instead of IOU_OK.
> In case of io_wq_submit_work(), the request will be dropped without
> completing it.
> 
> The offending code was introduced by a hack in
> a9c3eda7eada9 ("io_uring: fix submission-failure handling for uring-cmd"),
> however it was fine until getsockopt was introduced and started
> returning positive results.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix lost getsockopt completions
      commit: 2554b855a2f8605407a2018ca55cabb1af1feb61

Best regards,
-- 
Jens Axboe




